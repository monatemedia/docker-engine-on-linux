#!/bin/bash

# Main script: Configure VPS
# Description: Scaffold .gitignore, .env.deploy-base, and .env.deploy-secrets.<environment> for a project — run this before create-deploy-ssh/provision-app-env

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

# Step 3: Ask which environment this run is scaffolding files for
echo "This scaffolds the LOCAL files create-deploy-ssh and provision-app-env"
echo "depend on — .gitignore, .env.deploy-base, and .env.deploy-secrets.<environment>."
echo "It never connects to the VPS itself; run it once per environment."
while true; do
    read -p "Which environment are you scaffolding local deploy files for? (staging/production): " deploy_environment
    if [[ "$deploy_environment" == "staging" || "$deploy_environment" == "production" ]]; then
        break
    fi
    echo "Please enter 'staging' or 'production'."
done
env_upper=$(echo "$deploy_environment" | tr '[:lower:]' '[:upper:]')

# Named per-environment — same reasoning as create-deploy-ssh's TEMP_SCRIPT:
# running this twice in a row for two environments before downloading/running
# the first one can't silently overwrite it on the VPS.
TEMP_SCRIPT="/tmp/configure-deploy-env-temp-${deploy_environment}.sh"

# Step 4: Save vps_ip to configuration file (github_username/CR_PAT untouched if already set)
echo "Saving configuration to $CONF_FILE..."
sudo bash -c "cat <<EOL > $CONF_FILE
vps_ip=\"$vps_ip\"
github_username=\"${github_username:-}\"
CR_PAT=\"${CR_PAT:-}\"
EOL"

# Step 5: Create the temporary script — everything below runs on the LOCAL
# machine, not the VPS. This script never touches the VPS at all beyond
# downloading and deleting itself — it only ever creates or checks files in
# the current project directory: .gitignore, .env.deploy-base, and
# .env.deploy-secrets.<environment>. It exists purely to get the local repo
# ready before create-deploy-ssh (SSH access) and provision-app-env (merges
# and sends the .env) are run.
echo "Creating the temporary script to scaffold local deploy files..."
cat <<EOL >"$TEMP_SCRIPT"
#!/bin/bash

set -e

DEPLOY_ENVIRONMENT="$deploy_environment"
ENV_UPPER="$env_upper"

# Step 1: .gitignore — create if missing, then make sure all three files
# this whole pair of scripts deals with are listed, regardless of which
# single environment this run is for. That way the OTHER environment's
# secrets filename is already protected too, even before it exists, in case
# it gets created some other way before this script is ever run for it.
if [ ! -f .gitignore ]; then
    echo "No .gitignore found — creating one."
    touch .gitignore
fi
for entry in ".env.deploy-base" ".env.deploy-secrets.production" ".env.deploy-secrets.staging"; do
    if ! grep -qxF "\$entry" .gitignore; then
        echo "\$entry" >> .gitignore
        echo "Added \$entry to .gitignore."
    fi
done

# Step 2: .env.deploy-base — shared between staging and production. Created
# once, reused by both environments; left alone if it already exists so a
# second run (e.g. scaffolding staging after already having done production)
# never wipes out values someone's already filled in.
if [ -f .env.deploy-base ]; then
    echo ".env.deploy-base already exists — leaving it alone."
else
    cat <<'BASEEOL' > .env.deploy-base
# Values that are IDENTICAL between staging and production go here — things
# like APP_LOCALE, BCRYPT_ROUNDS, log settings, anything that doesn't differ
# per environment. This file's job is only to fill in the blanks for values
# that never change between environments — it is NOT a full copy of your
# framework's own .env.example, and Denlin doesn't try to guess what your
# app needs beyond what you put here yourself.
#
# Anything that DOES differ between staging and production — even if it
# isn't secret — belongs in .env.deploy-secrets.staging or
# .env.deploy-secrets.production instead. provision-app-env merges this file
# with whichever one applies, and the secrets file always wins on a
# conflicting key.
#
# This file is gitignored even though it's the "shared" file, not the
# "secrets" file — a shared value can still be a real credential (a reused
# API key, for example), so don't assume it's safe to commit just because
# it isn't environment-specific.
BASEEOL
    echo "Created .env.deploy-base."
fi

# Step 3: .env.deploy-secrets.<environment> — this run's environment only.
# Same non-destructive rule: left alone if it already exists.
SECRETS_FILE=".env.deploy-secrets.\${DEPLOY_ENVIRONMENT}"
if [ -f "\$SECRETS_FILE" ]; then
    echo "\$SECRETS_FILE already exists — leaving it alone."
else
    cat <<SECRETSEOL > "\$SECRETS_FILE"
# ============================================================
# THIS IS THE \${ENV_UPPER} SECRETS FILE
# Only \${DEPLOY_ENVIRONMENT}-specific values belong here — never copy these
# values into the other environment's file, and never copy the other
# environment's values into this one. The filename is what tells you which
# environment you're editing; double-check it before pasting anything in.
# ============================================================
#
# Real, sensitive credentials go here — the DB password, API keys, anything
# that differs between staging and production. Do NOT put these in your
# project's own local .env or .env.example — provision-app-env reads this
# file directly and merges it with .env.deploy-base before sending the
# result to the VPS as .env. Keys here are plain app key names (DB_PASSWORD,
# APP_KEY, etc.) — no STAGING_/PRODUCTION_ prefix on the key itself; that's
# what the filename and the banner above are for instead.
SECRETSEOL
    echo "Created \$SECRETS_FILE."
fi

echo
echo "Done. Fill in .env.deploy-base and \$SECRETS_FILE with real values, then"
echo "run Denlin's 'provision-app-env' service to send the merged result to the VPS."

# Cleanup
echo "Cleaning up temporary script..."
rm -- "\$0"
ssh "${vps_user}@${vps_ip}" "rm $TEMP_SCRIPT"
echo "Cleanup complete. You may now close this terminal."
EOL

chmod +x "$TEMP_SCRIPT"

# Step 6: Provide instructions to the user
echo "To scaffold the local deploy files, do the following:"
echo ""
echo "1. Open a terminal in the root of your PROJECT'S folder on your local computer"
echo "   (not this VPS, and not the denlin-cli folder — the actual app repo being deployed)."
echo ""
echo "2. Download the script using the following command:"
echo "   scp ${vps_user}@${vps_ip}:$TEMP_SCRIPT ./configure-deploy-env-temp-${deploy_environment}.sh"
echo ""
echo "3. Run the script using:"
echo "   ./configure-deploy-env-temp-${deploy_environment}.sh"
echo ""
echo "Once the script finishes, it will delete itself from both the VPS and the local computer."
