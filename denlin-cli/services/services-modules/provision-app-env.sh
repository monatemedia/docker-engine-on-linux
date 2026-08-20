#!/bin/bash

# Main script: Configure VPS
# Description: Merge .env.deploy-base + .env.deploy-secrets.<environment> and send the result to the VPS as .env

# Get the username of the logged-in user on the VPS
vps_user=$(whoami)

# Variables
CONF_FILE="/etc/denlin-cli.conf"

# Step 1: Check if configuration file exists
if [ -f "$CONF_FILE" ]; then
    source "$CONF_FILE"
fi

# Step 2: Ask for VPS IP
if [ -z "$vps_ip" ]; then
    read -p "Enter your VPS IP address: " vps_ip
else
    read -p "VPS IP ($vps_ip): Do you want to change it? (y/n): " confirm_ip
    if [ "$confirm_ip" == "y" ]; then
        read -p "Enter your VPS IP address: " vps_ip
    fi
fi

# Step 3: Ask which environment
while true; do
    read -p "Which environment is this .env for? (staging/production): " deploy_environment
    if [[ "$deploy_environment" == "staging" || "$deploy_environment" == "production" ]]; then
        break
    fi
    echo "Please enter 'staging' or 'production'."
done
env_upper=$(echo "$deploy_environment" | tr '[:lower:]' '[:upper:]')

# Step 4: Ask for the work dir (same one create-deploy-ssh used for this environment)
read -p "Absolute work dir on this VPS for '$deploy_environment' (e.g. /home/${vps_user}/PROJECT-${deploy_environment}): " work_dir

TEMP_SCRIPT="/tmp/provision-app-env-temp-${deploy_environment}.sh"

# Step 5: Save vps_ip to configuration file
echo "Saving configuration to $CONF_FILE..."
sudo bash -c "cat <<EOL > $CONF_FILE
vps_ip=\"$vps_ip\"
github_username=\"${github_username:-}\"
CR_PAT=\"${CR_PAT:-}\"
EOL"

# Step 6: Create the temporary script — reads .env.deploy-base and
# .env.deploy-secrets.<environment> locally, merges them, and scp's the
# result to the VPS. This is LOCAL work (the filled secrets file lives on
# the local machine, never on the VPS or in GitHub), so it has to run from
# the developer's machine.
echo "Creating the temporary script to build and send the .env locally..."
cat <<EOL >"$TEMP_SCRIPT"
#!/bin/bash

set -e

VPS_USER="$vps_user"
VPS_IP="$vps_ip"
DEPLOY_ENVIRONMENT="$deploy_environment"
ENV_UPPER="$env_upper"
WORK_DIR="$work_dir"

BASE_FILE=".env.deploy-base"
SECRETS_FILE=".env.deploy-secrets.\${DEPLOY_ENVIRONMENT}"

cleanup_and_exit() {
    local exit_code="\${1:-0}"
    echo "Cleaning up temporary script..."
    rm -- "\$0"
    ssh "${vps_user}@${vps_ip}" "rm $TEMP_SCRIPT"
    echo "Cleanup complete. You may now close this terminal."
    exit "\$exit_code"
}

if [[ ! -f "\$BASE_FILE" ]]; then
    echo "Error: \$BASE_FILE not found in \$(pwd). Run Denlin's 'configure-deploy-env' service first."
    exit 1
fi
if [[ ! -f "\$SECRETS_FILE" ]]; then
    echo "Error: \$SECRETS_FILE not found in \$(pwd). Run Denlin's 'configure-deploy-env' service first."
    exit 1
fi

# Merge: .env.deploy-base first, then .env.deploy-secrets.<environment> on
# top — the secrets file wins on any key both files define. Neither file's
# keys carry a STAGING_/PRODUCTION_ prefix, and none is expected or stripped
# here — an earlier version of this design kept that prefix on every key in
# the secrets file, dropped because it meant a key added later without the
# prefix would silently never reach the deployed .env: no error, just a
# variable quietly missing in production. Which environment's file you're
# looking at is signalled by the filename and the header comment
# configure-deploy-env writes, not by anything this script has to parse
# correctly.
declare -A MERGED

read_into_map() {
    local file="\$1"
    while IFS= read -r line || [[ -n "\$line" ]]; do
        [[ -z "\$line" || "\$line" =~ ^[[:space:]]*# ]] && continue
        if [[ "\$line" =~ ^([A-Za-z0-9_]+)=(.*)\$ ]]; then
            local key="\${BASH_REMATCH[1]}"
            local value="\${BASH_REMATCH[2]}"
            if [[ -z "\$value" ]]; then
                echo "Error: \$key is still blank in \$file — fill it in first."
                exit 1
            fi
            MERGED["\$key"]="\$value"
        fi
    done < "\$file"
}

read_into_map "\$BASE_FILE"
read_into_map "\$SECRETS_FILE"
echo "Merged \${#MERGED[@]} total key(s) from \$BASE_FILE + \$SECRETS_FILE."

TMP_ENV=\$(mktemp)
for key in "\${!MERGED[@]}"; do
    echo "\${key}=\${MERGED[\$key]}" >> "\$TMP_ENV"
done

echo "Ensuring \$WORK_DIR exists on the VPS..."
ssh "\$VPS_USER@\$VPS_IP" "mkdir -p \$WORK_DIR"

# Never silently overwrite an .env that's already live on the VPS — the only
# way anyone routinely reaches this script again is to rotate a credential
# on an app that's already running, so a blind overwrite risks losing
# something nobody wrote down anywhere else. Back it up first instead of
# refusing outright, so rotating a credential doesn't turn into a manual
# SSH-in-and-delete step every single time.
if ssh "\$VPS_USER@\$VPS_IP" "test -f \$WORK_DIR/.env"; then
    echo "An .env already exists at \$WORK_DIR on the VPS."
    read -p "Replace it? The existing file will be backed up first. (y/n): " confirm_replace
    if [[ "\$confirm_replace" != "y" ]]; then
        echo "Cancelled — nothing was sent to the VPS."
        rm -f "\$TMP_ENV"
        cleanup_and_exit 0
    fi
    # Use the VPS's own clock for the backup timestamp, not the local
    # machine's — they can disagree, and the backup name should describe
    # when it happened on the server that actually holds the file.
    VPS_TIMESTAMP=\$(ssh "\$VPS_USER@\$VPS_IP" "date +%Y%m%d-%H%M%S")
    echo "Backing up the existing .env to .env.bak-\$VPS_TIMESTAMP..."
    ssh "\$VPS_USER@\$VPS_IP" "mv \$WORK_DIR/.env \$WORK_DIR/.env.bak-\$VPS_TIMESTAMP"
fi

echo "Sending .env to \$VPS_USER@\$VPS_IP:\$WORK_DIR/.env..."
scp "\$TMP_ENV" "\$VPS_USER@\$VPS_IP:\$WORK_DIR/.env"
ssh "\$VPS_USER@\$VPS_IP" "chmod 600 \$WORK_DIR/.env"

# Wipe the locally-built plaintext .env immediately — it's served its purpose.
rm -f "\$TMP_ENV"

echo
echo "Done. \$WORK_DIR/.env is now on the VPS."
echo "Trigger a deploy for this to take effect."
echo
echo "Reminder: delete \$SECRETS_FILE locally once you're confident this is correct —"
echo "it holds real credentials in plaintext and should not linger on disk."

cleanup_and_exit 0
EOL

chmod +x "$TEMP_SCRIPT"

# Step 7: Provide instructions to the user
echo "To build and send the .env locally, do the following:"
echo ""
echo "1. Open a terminal in the root of your PROJECT'S folder on your local computer,"
echo "   with .env.deploy-base and .env.deploy-secrets.$deploy_environment already"
echo "   filled in there (run Denlin's 'configure-deploy-env' service first if not)."
echo ""
echo "2. Download the script using the following command:"
echo "   scp ${vps_user}@${vps_ip}:$TEMP_SCRIPT ./provision-app-env-temp-${deploy_environment}.sh"
echo ""
echo "3. Run the script using:"
echo "   ./provision-app-env-temp-${deploy_environment}.sh"
echo ""
echo "Once the script finishes, it will delete itself from both the VPS and the local computer."
