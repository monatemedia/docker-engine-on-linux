#!/bin/bash

# Main script: Configure VPS
# Purpose: Help the user configure their GitHub PAT on the VPS and local machine

# Variables
SERVICES_CONF="/services/services.conf"
TEMP_SCRIPT="/tmp/configure-pat-locally.sh"

# Ask user for GitHub username and PAT
read -p "Enter your GitHub username: " GITHUB_USERNAME
echo "To create a new token visit: https://github.com/settings/tokens/new"
echo "To generate a **new personal access token (classic)** for a server named 'VPS 1' with 'write:packages' and 'delete:packages' scopes:"
echo "- Enter 'VPS 1' in the 'Note' input box"
echo "- Select the following scopes:"
echo "    [x] write:packages"
echo "      [ ] read:packages"
echo "    [x] delete:packages"
echo "- Select 90 days until expiry"
echo "- Then, click 'Generate token'"
echo ""
read -sp "Enter your Personal Access Token (PAT): " CR_PAT
echo ""

# Update or create services.conf file
echo "Checking for $SERVICES_CONF..."
if [ -f "$SERVICES_CONF" ]; then
    echo "Updating $SERVICES_CONF with the new PAT and username..."
else
    echo "Creating $SERVICES_CONF..."
    mkdir -p /services
    touch "$SERVICES_CONF"
fi

# Ensure the variables exist in services.conf
grep -qxF "export GITHUB_USERNAME=$GITHUB_USERNAME" "$SERVICES_CONF" || echo "export GITHUB_USERNAME=$GITHUB_USERNAME" >> "$SERVICES_CONF"
grep -qxF "export CR_PAT=$CR_PAT" "$SERVICES_CONF" || echo "export CR_PAT=$CR_PAT" >> "$SERVICES_CONF"

# Add the PAT to the .env file
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

# Create the secondary script for local machine
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

echo "PAT has been saved to \$ENV_FILE, and .env has been excluded from Git."
EOL

chmod +x "$TEMP_SCRIPT"

# Instructions for the user
echo ""
echo "Done! To configure the PAT on your local machine, follow these steps:"
echo "1. Download the secondary script from the VPS:"
echo "   scp username@your-vps:$TEMP_SCRIPT ./configure-pat-locally.sh"
echo "2. Run the script from the root of your project folder:"
echo "   ./configure-pat-locally.sh"
echo "3. After running, you can safely close this window."
