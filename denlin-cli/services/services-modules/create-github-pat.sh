#!/bin/bash

# Main script: Configure VPS
# Description: Configure GitHub PAT on the VPS and local machine

# Get the username of the logged-in user on the VPS
vps_user=$(whoami)

# Variables
CONF_FILE="/etc/denlin-cli.conf"
TMP_SCRIPT="/tmp/configure-pat-locally.sh"

# Step 1: Check if configuration file exists
if [ -f "$CONF_FILE" ]; then
    source "$CONF_FILE"
fi

# Step 2: Programmatically get the username of the signed-in user
current_user=$(whoami)

# Step 3: Ask for VPS IP
if [ -z "$vps_ip" ]; then
    read -p "Enter your VPS IP address: " vps_ip
else
    read -p "VPS IP ($vps_ip): Do you want to change it? (y/n): " confirm_ip
    if [ "$confirm_ip" == "y" ]; then
        read -p "Enter your VPS IP address: " vps_ip
    fi
fi

# Step 4: Ask for GitHub username
if [ -z "$github_username" ]; then
    read -p "Enter your GitHub username: " github_username
else
    read -p "GitHub username ($github_username): Do you want to change it? (y/n): " confirm_user
    if [ "$confirm_user" == "y" ]; then
        read -p "Enter your GitHub username: " github_username
    fi
fi

# Step 5: Ask for GitHub PAT
if [ -z "$CR_PAT" ]; then
    echo "To create a new PAT, visit: https://github.com/settings/tokens/new"
    echo "Generate a new personal access token (classic) for server 'VPS 1' with 'write:packages' and 'delete:packages' scopes."
    read -sp "Enter your GitHub Personal Access Token (PAT): " CR_PAT
    echo
else
    echo "A PAT already exists."
    read -p "Do you want to change it? (y/n): " confirm_pat
    if [ "$confirm_pat" == "y" ]; then
        echo "To create a new PAT, visit: https://github.com/settings/tokens/new"
        echo "Generate a new personal access token (classic) for server 'VPS 1' with 'write:packages' and 'delete:packages' scopes."
        read -sp "Enter your new GitHub Personal Access Token (PAT): " CR_PAT
        echo
    fi
fi

# Step 6: Save to configuration file
echo "Saving configuration to $CONF_FILE..."
sudo bash -c "cat <<EOL > $CONF_FILE
vps_ip=\"$vps_ip\"
github_username=\"$github_username\"
CR_PAT=\"$CR_PAT\"
EOL"

# Step 7: Log in to GitHub Container Registry
echo "Logging into GitHub Container Registry..."
echo "$CR_PAT" | docker login ghcr.io -u "$github_username" --password-stdin

# Step 8: Create the temporary script
echo "Creating the temporary script to configure PAT locally..."
cat <<EOL >"$TMP_SCRIPT"
#!/bin/bash

# Step 1: Write the PAT to .env
echo "CR_PAT=$CR_PAT" >> .env
echo ".env file updated."

# Step 2: Ensure .env is in .gitignore
if ! grep -qxF ".env" .gitignore; then
    echo ".env" >> .gitignore
    echo ".env added to .gitignore."
fi

# Step 3: Log in to GitHub Container Registry locally
echo "Logging into GitHub Container Registry from your project folder..."
if echo "$CR_PAT" | docker login ghcr.io -u "$github_username" --password-stdin; then
  echo "Successfully logged in to GitHub Container Registry."
else
  echo "Failed to log in to GitHub Container Registry. Please check your PAT and username."
  exit 1
fi

# Step 4: Clean up temporary script
rm -- "\$0"
ssh "${vps_user}@${vps_ip}" "rm /tmp/configure-pat-locally.sh"
echo "Cleanup complete. You may now close this terminal."
EOL

chmod +x "$TMP_SCRIPT"

# Step 9: Provide instructions to the user
echo "To configure PAT locally, do the following:"
echo ""
echo "1. Open a terminal in the root of your project folder on your local computer."
echo ""
echo "2. Download the script using the following command:"
echo "   scp ${vps_user}@${vps_ip}:/tmp/configure-pat-locally.sh ./configure-pat-locally.sh"
echo ""
echo "3. Run the script using:"
echo "   ./configure-pat-locally.sh"
echo ""
