#!/bin/bash

# Main script: Configure VPS
# Description: Configure GitHub PAT on the VPS and local machine, save username and IP to services.conf

# Variables
HOME_DIR=$(eval echo ~)
SERVICES_CONF="$HOME_DIR/services/services.conf"
TEMP_SCRIPT="/tmp/configure-pat-locally.sh"

# Function to read or prompt for GitHub credentials
prompt_for_credentials() {
    local current_username current_pat

    # If services.conf exists, retrieve saved username, PAT, and IP
    if [ -f "$SERVICES_CONF" ]; then
        echo "Reading existing configuration from $SERVICES_CONF..."
        source "$SERVICES_CONF"
        current_username="$GITHUB_USERNAME"
        current_pat="$CR_PAT"
        current_ip="$VPS_IP"
    fi

    # Prompt for or confirm GitHub username
    echo "Current GitHub username: ${current_username:-Not Set}"
    read -p "Enter GitHub username (press Enter to keep current): " input_username
    GITHUB_USERNAME=${input_username:-$current_username}

    # Prompt for or confirm PAT
    echo "Current PAT: ${current_pat:+(hidden)}"
    echo "To generate a new PAT, follow these instructions:"
    echo "- Visit: https://github.com/settings/tokens/new"
    echo "- Note: VPS 1"
    echo "- Scopes: write:packages, delete:packages"
    echo "- Expiration: 90 days"
    echo ""
    read -sp "Enter GitHub PAT (press Enter to keep current): " input_pat
    echo ""
    CR_PAT=${input_pat:-$current_pat}

    # Prompt for or confirm VPS IP
    echo "Current VPS IP: ${current_ip:-Not Set}"
    read -p "Enter VPS IP (press Enter to keep current): " input_ip
    VPS_IP=${input_ip:-$current_ip}
}

# Function to update services.conf
update_services_conf() {
    echo "Updating $SERVICES_CONF..."
    mkdir -p "$(dirname "$SERVICES_CONF")"
    {
        echo "export GITHUB_USERNAME=$GITHUB_USERNAME"
        echo "export CR_PAT=$CR_PAT"
        echo "export VPS_IP=$VPS_IP"
    } > "$SERVICES_CONF"
}

# Prompt for credentials and update services.conf
prompt_for_credentials
update_services_conf

# Update or create the .env file
ENV_FILE=".env"
echo "Checking for $ENV_FILE on the VPS..."
if [ -f "$ENV_FILE" ]; then
    echo "Updating $ENV_FILE with the new PAT..."
else
    echo "Creating $ENV_FILE..."
    touch "$ENV_FILE"
fi
grep -qxF "export CR_PAT=$CR_PAT" "$ENV_FILE" || echo "export CR_PAT=$CR_PAT" >> "$ENV_FILE"

# Perform Docker login on VPS
echo "Logging into Docker on the VPS..."
echo "$CR_PAT" | docker login ghcr.io -u "$GITHUB_USERNAME" --password-stdin
if [ $? -eq 0 ]; then
    echo "Docker login successful!"
else
    echo "Docker login failed. Please check your PAT and username."
    exit 1
fi

# Create the secondary script for the local machine
echo "Creating secondary script at $TEMP_SCRIPT..."
cat <<EOL > "$TEMP_SCRIPT"
#!/bin/bash

# Script to configure PAT on local machine
ENV_FILE=".env"
GITIGNORE_FILE=".gitignore"

# Check if .env exists or create it
if [ -f "\$ENV_FILE" ]; then
    echo "Updating \$ENV_FILE with the PAT..."
else
    echo "Creating \$ENV_FILE..."
    touch "\$ENV_FILE"
fi
grep -qxF "export CR_PAT=$CR_PAT" "\$ENV_FILE" || echo "export CR_PAT=$CR_PAT" >> "\$ENV_FILE"

# Update or create .gitignore to exclude .env
if [ -f "\$GITIGNORE_FILE" ]; then
    echo "Updating \$GITIGNORE_FILE to exclude .env..."
else
    echo "Creating \$GITIGNORE_FILE..."
    touch "\$GITIGNORE_FILE"
fi
grep -qxF ".env" "\$GITIGNORE_FILE" || echo ".env" >> "\$GITIGNORE_FILE"

# Attempt self-deletion
echo "Cleaning up..."
SCRIPT_PATH="$(realpath "$0")" # Get the absolute path of the script
echo "Attempting to delete: $SCRIPT_PATH"
ls -l "$SCRIPT_PATH"
if rm -- "$SCRIPT_PATH"; then
    echo "Self-deletion successful. Script removed."
else
    echo "Failed to delete the script. Please remove it manually: $SCRIPT_PATH"
fi
EOL

chmod +x "$TEMP_SCRIPT"

# Instructions for the user
echo ""
echo "Done! To configure the PAT on your local machine, follow these steps:"
echo "1. Download the secondary script from the VPS:"
echo "   scp $(whoami)@$VPS_IP:$TEMP_SCRIPT ./configure-pat-locally.sh"
echo "2. Run the script from the root of your project folder on your local machine:"
echo "   ./configure-pat-locally.sh"
echo "3. After running, the script will delete itself automatically."
