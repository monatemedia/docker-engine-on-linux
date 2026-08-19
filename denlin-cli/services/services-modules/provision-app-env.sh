#!/bin/bash

# Main script: Configure VPS
# Description: Build a per-environment .env locally from a filled deploy-secrets file and scp it straight to the VPS

# Get the username of the logged-in user on the VPS
vps_user=$(whoami)

# Variables
CONF_FILE="/etc/denlin-cli.conf"
TEMP_SCRIPT="/tmp/provision-app-env-temp.sh"

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

# Step 5: Save vps_ip to configuration file
echo "Saving configuration to $CONF_FILE..."
sudo bash -c "cat <<EOL > $CONF_FILE
vps_ip=\"$vps_ip\"
github_username=\"${github_username:-}\"
CR_PAT=\"${CR_PAT:-}\"
EOL"

# Step 6: Create the temporary script — reads a local deploy-secrets.<env>.env
# file, builds the full app .env, and scp's it straight to the VPS. This is
# LOCAL work (the filled secrets file lives on the local machine, never on
# the VPS or in GitHub), so it has to run from the developer's machine.
echo "Creating the temporary script to build and send the .env locally..."
cat <<EOL >"$TEMP_SCRIPT"
#!/bin/bash

set -e

VPS_USER="$vps_user"
VPS_IP="$vps_ip"
DEPLOY_ENVIRONMENT="$deploy_environment"
ENV_UPPER="$env_upper"
WORK_DIR="$work_dir"

application_name=\$(basename "\$(pwd)")
SECRETS_FILE="deploy-secrets.\${DEPLOY_ENVIRONMENT}.env"

if [[ ! -f "\$SECRETS_FILE" ]]; then
    echo "Error: \$SECRETS_FILE not found in \$(pwd). Copy it from the .example template and fill it in first."
    exit 1
fi

# Pull a bare Laravel var out of the ENV-prefixed local secrets file, e.g.
# get_val APP_URL reads STAGING_APP_URL= (or PRODUCTION_APP_URL=) from the file.
get_val() {
    grep -E "^\${ENV_UPPER}_\$1=" "\$SECRETS_FILE" | head -n1 | cut -d'=' -f2-
}

MISSING=()
for key in APP_KEY APP_URL SUPERUSER_NAME SUPERUSER_EMAIL SUPERUSER_PASSWORD \\
           DB_USERNAME DB_PASSWORD OPENAI_API_KEY MAIL_FROM_ADDRESS \\
           LEGAL_TERMS_LAST_UPDATED LEGAL_PRIVACY_LAST_UPDATED \\
           SUPPORT_EMAIL_ACCOUNT_DATA SUPPORT_EMAIL_CUSTOMER_DATA \\
           DOCKER_WEB_PORT DOCKER_POSTGRES_PORT DOCKER_REDIS_PORT; do
    val=\$(get_val "\$key")
    if [[ -z "\$val" ]]; then
        MISSING+=("\${ENV_UPPER}_\${key}")
    fi
done
if [[ \${#MISSING[@]} -gt 0 ]]; then
    echo "Error: these are still blank in \$SECRETS_FILE: \${MISSING[*]}"
    exit 1
fi

# These assume the docker-compose.yml naming convention <app>-db / <app>-redis
# and database name <app>_db (matches sparkshop's own docker-compose.yml).
# Override here if a future project's naming differs.
read -p "App display name for APP_NAME (default: \$application_name): " app_display_name
app_display_name="\${app_display_name:-\$application_name}"
read -p "DB/Redis container prefix (default: \$application_name): " container_prefix
container_prefix="\${container_prefix:-\$application_name}"
read -p "Database name (default: \${application_name}_db): " db_name
db_name="\${db_name:-\${application_name}_db}"

app_url=\$(get_val APP_URL)
app_debug="false"
[[ "\$DEPLOY_ENVIRONMENT" == "staging" ]] && app_debug="true"

TMP_ENV=\$(mktemp)
cat > "\$TMP_ENV" <<ENVEOF
APP_NAME=\$app_display_name
APP_ENV=\$DEPLOY_ENVIRONMENT
APP_KEY=\$(get_val APP_KEY)
APP_DEBUG=\$app_debug
APP_URL=\$app_url

SUPERUSER_NAME=\$(get_val SUPERUSER_NAME)
SUPERUSER_EMAIL=\$(get_val SUPERUSER_EMAIL)
SUPERUSER_PASSWORD=\$(get_val SUPERUSER_PASSWORD)

DB_CONNECTION=pgsql
DB_HOST=\${container_prefix}-db
DB_PORT=5432
DB_DATABASE=\$db_name
DB_USERNAME=\$(get_val DB_USERNAME)
DB_PASSWORD=\$(get_val DB_PASSWORD)

REDIS_HOST=\${container_prefix}-redis
REDIS_PORT=6379
CACHE_DRIVER=redis
QUEUE_CONNECTION=redis
SESSION_DRIVER=redis

OPENAI_API_KEY=\$(get_val OPENAI_API_KEY)

MAIL_MAILER=log
MAIL_FROM_ADDRESS=\$(get_val MAIL_FROM_ADDRESS)
MAIL_FROM_NAME=\$app_display_name

LEGAL_TERMS_LAST_UPDATED=\$(get_val LEGAL_TERMS_LAST_UPDATED)
LEGAL_PRIVACY_LAST_UPDATED=\$(get_val LEGAL_PRIVACY_LAST_UPDATED)
SUPPORT_EMAIL_ACCOUNT_DATA=\$(get_val SUPPORT_EMAIL_ACCOUNT_DATA)
SUPPORT_EMAIL_CUSTOMER_DATA=\$(get_val SUPPORT_EMAIL_CUSTOMER_DATA)

VIRTUAL_HOST=\$(echo "\$app_url" | sed -e 's|^[^/]*//||' -e 's|/.*\$||')
LETSENCRYPT_HOST=\$(echo "\$app_url" | sed -e 's|^[^/]*//||' -e 's|/.*\$||')

DOCKER_WEB_PORT=\$(get_val DOCKER_WEB_PORT)
DOCKER_POSTGRES_PORT=\$(get_val DOCKER_POSTGRES_PORT)
DOCKER_REDIS_PORT=\$(get_val DOCKER_REDIS_PORT)

COMPOSE_PROJECT_NAME=\${application_name}-\${DEPLOY_ENVIRONMENT}
ENVEOF

echo "Ensuring \$WORK_DIR exists on the VPS..."
ssh "\$VPS_USER@\$VPS_IP" "mkdir -p \$WORK_DIR"

echo "Sending .env to \$VPS_USER@\$VPS_IP:\$WORK_DIR/.env..."
scp "\$TMP_ENV" "\$VPS_USER@\$VPS_IP:\$WORK_DIR/.env"
ssh "\$VPS_USER@\$VPS_IP" "chmod 600 \$WORK_DIR/.env"

# Wipe the locally-built plaintext .env immediately — it's served its purpose.
rm -f "\$TMP_ENV"

echo "Done. \$WORK_DIR/.env is now on the VPS."
echo "Reminder: delete \$SECRETS_FILE locally once you're confident this is correct —"
echo "it holds the same real credentials in plaintext and should not linger on disk."

# Cleanup
echo "Cleaning up temporary script..."
rm -- "\$0"
ssh "${vps_user}@${vps_ip}" "rm $TEMP_SCRIPT"
echo "Cleanup complete. You may now close this terminal."
EOL

chmod +x "$TEMP_SCRIPT"

# Step 7: Provide instructions to the user
echo "To build and send the .env locally, do the following:"
echo ""
echo "1. Open a terminal in the root of your PROJECT'S folder on your local computer,"
echo "   with deploy-secrets.$deploy_environment.env already filled in there."
echo ""
echo "2. Download the script using the following command:"
echo "   scp ${vps_user}@${vps_ip}:$TEMP_SCRIPT ./provision-app-env-temp.sh"
echo ""
echo "3. Run the script using:"
echo "   ./provision-app-env-temp.sh"
echo ""
echo "Once the script finishes, it will delete itself from both the VPS and the local computer."
