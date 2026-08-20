#!/bin/bash

# Main script: Configure VPS
# Description: Generate and install a per-environment SSH deploy key, then store it as GitHub Actions secrets

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

# Step 3: Ask which environment this deploy key is for
echo "This key is used by GitHub Actions to deploy — not for your own personal login"
echo "(use 'denlin setup-ssh-login' for that instead)."
while true; do
    read -p "Which environment is this deploy key for? (staging/production): " deploy_environment
    if [[ "$deploy_environment" == "staging" || "$deploy_environment" == "production" ]]; then
        break
    fi
    echo "Please enter 'staging' or 'production'."
done
env_upper=$(echo "$deploy_environment" | tr '[:lower:]' '[:upper:]')

# Named per-environment (not a fixed "/tmp/create-deploy-ssh-temp.sh") so that
# running this twice in a row for two different environments — staging, then
# production, say — before downloading/running the first one can't silently
# overwrite it on the VPS. That collision used to be real: the second run's
# temp script would clobber the first's at the same fixed path, so only the
# second environment's key ever actually got generated even though both runs
# reported success.
TEMP_SCRIPT="/tmp/create-deploy-ssh-temp-${deploy_environment}.sh"

# Step 4: Ask for the work dir this environment's docker-compose.yml will live in
echo "This must be a DIFFERENT path than any other environment sharing this VPS —"
echo "otherwise one environment's deploy will delete another's docker-compose.yml."
read -p "Absolute work dir on this VPS for '$deploy_environment' (e.g. /home/${vps_user}/PROJECT-${deploy_environment}): " work_dir

# Step 5: Save vps_ip to configuration file (github_username/CR_PAT untouched if already set)
echo "Saving configuration to $CONF_FILE..."
sudo bash -c "cat <<EOL > $CONF_FILE
vps_ip=\"$vps_ip\"
github_username=\"${github_username:-}\"
CR_PAT=\"${CR_PAT:-}\"
EOL"

# Step 6: Create the temporary script — everything below runs on the LOCAL
# machine, not the VPS: keygen, ssh-copy-id (local -> VPS), and gh secret set
# (needs the local project's git remote) all have to happen there.
echo "Creating the temporary script to configure the deploy key locally..."
cat <<EOL >"$TEMP_SCRIPT"
#!/bin/bash

set -e

# On Windows Git Bash, MSYS silently rewrites any argument that looks like a
# POSIX absolute path (e.g. \$WORK_DIR, starting with /) into a Windows path
# before handing it to a native (non-MSYS) binary like gh.exe — turning
# "/home/edward/sparkshop-staging" into "C:/Program Files/Git/home/edward/..."
# with no error and no visible difference in what you typed. This broke
# WORK_DIR secrets multiple times in production use before being tracked down.
# No-op on Linux/Mac, so safe to export unconditionally.
export MSYS_NO_PATHCONV=1

VPS_USER="$vps_user"
VPS_IP="$vps_ip"
DEPLOY_ENVIRONMENT="$deploy_environment"
ENV_UPPER="$env_upper"
WORK_DIR="$work_dir"

# Step 1: Identify the current project's repo name and GitHub remote
application_name=\$(basename "\$(pwd)")
remote_url=\$(git config --get remote.origin.url)
if [[ -z "\$remote_url" ]]; then
    echo "Error: No remote URL found. Run this from the project's root folder."
    exit 1
fi
if [[ "\$remote_url" =~ github\.com[:/](.+)/(.+)\.git ]]; then
    repo_owner="\${BASH_REMATCH[1]}"
    repo_name="\${BASH_REMATCH[2]}"
else
    echo "Error: Unable to parse the remote URL '\$remote_url'."
    exit 1
fi
full_repo="\${repo_owner}/\${repo_name}"

# Step 2: Generate the key pair — NO passphrase (-N ""). This key is loaded
# unattended by GitHub Actions' ssh-agent step; there is no human present to
# answer a passphrase prompt in CI, so a protected key fails silently there.
# (This is the opposite of 'denlin setup-ssh-login', which is a human's own
# login key and correctly DOES prompt for a passphrase.)
key_path="\$HOME/.ssh/\${application_name}_\${DEPLOY_ENVIRONMENT}_\$(date +%Y)"
if [ -f "\$key_path" ]; then
    echo "Reusing existing key: \$key_path"
else
    # ssh-keygen won't create a missing ~/.ssh itself — it just fails with
    # "No such file or directory" if this is the first time SSH has ever
    # written anything there on this machine. Cheap to guard unconditionally.
    mkdir -p "\$HOME/.ssh"
    echo "Generating ed25519 key pair (no passphrase — used unattended by CI)..."
    ssh-keygen -t ed25519 -N "" -f "\$key_path" -C "\${application_name}-\${DEPLOY_ENVIRONMENT}+\$(date +%Y)@monatemedia.com"
fi

# Step 3: Install the public key on the VPS
echo "Copying public key to \$VPS_USER@\$VPS_IP..."
ssh-copy-id -i "\${key_path}.pub" "\$VPS_USER@\$VPS_IP"

# Step 4: Preflight — the exact check the 'Add Server to Known Hosts' CI step
# runs. Catch a bad IP/closed firewall port/downed VPS here, not after a push.
echo "Preflight: ssh-keyscan..."
if ! ssh-keyscan -T 10 -H "\$VPS_IP" > /tmp/deploy_ssh_keyscan_check 2>&1 || [ ! -s /tmp/deploy_ssh_keyscan_check ]; then
    echo "Error: ssh-keyscan could not reach \$VPS_IP. Check the IP, firewall (port 22), and that the VPS is up."
    cat /tmp/deploy_ssh_keyscan_check 2>/dev/null || true
    rm -f /tmp/deploy_ssh_keyscan_check
    exit 1
fi
rm -f /tmp/deploy_ssh_keyscan_check

# Step 5: Preflight — non-interactive login, mirroring how GitHub Actions'
# ssh-agent step will use this key with no human present.
echo "Preflight: non-interactive login..."
if ! ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new -i "\$key_path" "\$VPS_USER@\$VPS_IP" "echo SSH_OK" | grep -q SSH_OK; then
    echo "Error: key-based login failed in batch mode."
    if ! ssh-keygen -y -P "" -f "\$key_path" >/dev/null 2>&1; then
        echo "\$key_path is passphrase-protected — that is the likely cause. Strip it with:"
        echo "  ssh-keygen -p -f \"\$key_path\" -N \"\""
    else
        echo "Check that the public key was actually added to ~/.ssh/authorized_keys for \$VPS_USER on the VPS."
    fi
    exit 1
fi
echo "Both preflight checks passed."

# Step 6: Upload the four secrets
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI (gh) not found — install it first: https://cli.github.com/"
    exit 1
fi
if ! gh auth status &> /dev/null; then
    echo "You are not authenticated with GitHub CLI. Please authenticate now."
    gh auth login
fi

gh_env_flag=()
if [[ "\$DEPLOY_ENVIRONMENT" == "production" ]]; then
    echo "Uploading as Environment secrets scoped to 'production' (repo secrets alone won't"
    echo "respect any required-reviewer/branch protection rules later added to that Environment)."
    gh_env_flag=(--env production)
fi

echo
echo "Setting \${ENV_UPPER}_SSH_HOST / _SSH_USER / _SSH_KEY / _WORK_DIR for \$full_repo..."
gh secret set "\${ENV_UPPER}_SSH_HOST" --body "\$VPS_IP" --repo "\$full_repo" "\${gh_env_flag[@]}"
gh secret set "\${ENV_UPPER}_SSH_USER" --body "\$VPS_USER" --repo "\$full_repo" "\${gh_env_flag[@]}"
gh secret set "\${ENV_UPPER}_SSH_KEY" --repo "\$full_repo" "\${gh_env_flag[@]}" < "\$key_path"
gh secret set "\${ENV_UPPER}_WORK_DIR" --body "\$WORK_DIR" --repo "\$full_repo" "\${gh_env_flag[@]}"
echo "Done."

echo
echo "You can find these secrets here:"
echo "  https://github.com/\$full_repo/settings/secrets/actions"

# Step 7: Cleanup
echo "Cleaning up temporary script..."
rm -- "\$0"
ssh "${vps_user}@${vps_ip}" "rm $TEMP_SCRIPT"
echo "Cleanup complete. You may now close this terminal."
EOL

chmod +x "$TEMP_SCRIPT"

# Step 7: Provide instructions to the user
echo "To configure the deploy key locally, do the following:"
echo ""
echo "1. Open a terminal in the root of your PROJECT'S folder on your local computer"
echo "   (not this VPS, and not the denlin-cli folder — the actual app repo being deployed)."
echo ""
echo "2. Download the script using the following command:"
echo "   scp ${vps_user}@${vps_ip}:$TEMP_SCRIPT ./create-deploy-ssh-temp-${deploy_environment}.sh"
echo ""
echo "3. Run the script using:"
echo "   ./create-deploy-ssh-temp-${deploy_environment}.sh"
echo ""
echo "Once the script finishes, it will delete itself from both the VPS and the local computer."
