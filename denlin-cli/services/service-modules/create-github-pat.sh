#!/bin/bash

# Main script: Configure VPS
# Description: Configure GitHub PAT on the VPS and local machine

CONFIG_FILE="/usr/local/bin/denlin-cli/services/services.conf"
SERVICE_MODULE_DIR="/usr/local/bin/denlin-cli/services/service-modules"
TEMP_SCRIPT="/tmp/configure-pat-locally.sh"

# 1. Get the username of the signed-in user
USER_NAME=$(whoami)

# Check if services.conf exists, if not create it
if [ ! -f "$CONFIG_FILE" ]; then
    echo "services.conf not found, creating it..."
    touch "$CONFIG_FILE"
fi

# 2. Check if VPS IP address exists in services.conf
VPS_IP=$(grep "VPS_IP" "$CONFIG_FILE" | cut -d '=' -f2)

if [ -z "$VPS_IP" ]; then
    echo "Enter your VPS IP address:"
    read VPS_IP
    echo "VPS_IP=$VPS_IP" >> "$CONFIG_FILE"
else
    echo "Current VPS IP: $VPS_IP"
    echo "Do you want to change it? (y/n)"
    read CHANGE_VPS
    if [ "$CHANGE_VPS" == "y" ]; then
        echo "Enter new VPS IP address:"
        read VPS_IP
        sed -i "s/VPS_IP=$VPS_IP/VPS_IP=$VPS_IP/" "$CONFIG_FILE"
    fi
fi

# 3. Get GitHub username
GITHUB_USERNAME=$(grep "GITHUB_USERNAME" "$CONFIG_FILE" | cut -d '=' -f2)

if [ -z "$GITHUB_USERNAME" ]; then
    echo "Enter your GitHub username:"
    read GITHUB_USERNAME
    echo "GITHUB_USERNAME=$GITHUB_USERNAME" >> "$CONFIG_FILE"
else
    echo "Current GitHub username: $GITHUB_USERNAME"
    echo "Do you want to change it? (y/n)"
    read CHANGE_GITHUB
    if [ "$CHANGE_GITHUB" == "y" ]; then
        echo "Enter new GitHub username:"
        read GITHUB_USERNAME
        sed -i "s/GITHUB_USERNAME=$GITHUB_USERNAME/GITHUB_USERNAME=$GITHUB_USERNAME/" "$CONFIG_FILE"
    fi
fi

# 4. Get the PAT (Personal Access Token)
echo "To create a new token visit: https://github.com/settings/tokens/new"
echo "Generate a new personal access token (classic) for 'VPS 1' with 'write:packages' and 'delete:packages' scopes, and 90 days expiry."
echo "Enter your GitHub PAT (Personal Access Token):"
read -s CR_PAT

echo "CR_PAT=$CR_PAT" >> "$CONFIG_FILE"

# 5. Log into GitHub Container Registry
echo "$CR_PAT" | docker login ghcr.io -u "$GITHUB_USERNAME" --password-stdin

# 6. Create configure-pat-locally.sh script in /tmp
cat > "$TEMP_SCRIPT" <<EOL
#!/bin/bash

# 1. Save the PAT to the .env file
if [ ! -f ".env" ]; then
    touch .env
fi
echo "CR_PAT=$CR_PAT" >> .env

# 2. Add .env to .gitignore if not already there
if ! grep -q ".env" .gitignore; then
    echo ".env" >> .gitignore
fi

# 3. Log into GitHub Container Registry
echo "\$CR_PAT" | docker login ghcr.io -u "$GITHUB_USERNAME" --password-stdin

# 4. Clean up the temporary script
rm -- "$TEMP_SCRIPT"
rm /tmp/configure-pat-locally.sh

# 5. Notify user that the process is complete
echo "GitHub Container Registry is now configured on your local machine."
echo "You can now close the terminal window."
EOL

# 7. Provide instructions to the user
echo "A temporary script has been created at /tmp/configure-pat-locally.sh."
echo "To configure your local machine, follow these steps:"
echo "1. Open a terminal in your project folder."
echo "2. Run the following command to download the configuration script:"
echo "   wget http://$VPS_IP/configure-pat-locally.sh -O configure-pat-locally.sh"
echo "3. Run the downloaded script:"
echo "   bash configure-pat-locally.sh"
