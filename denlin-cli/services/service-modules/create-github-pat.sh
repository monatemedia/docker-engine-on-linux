#!/bin/bash

# Main script: Configure VPS
# Description: Configure GitHub PAT on the VPS and local machine

# Variables
SCRIPT_NAME="configure-pat-locally.sh"
TMP_PATH="/tmp/$SCRIPT_NAME"

# Step 1: Collect User Information
if [ ! -f "/usr/local/bin/denlin-cli/services/services.conf" ]; then
    echo "services.conf not found, creating it..."
    sudo touch /usr/local/bin/denlin-cli/services/services.conf
    sudo chmod 666 /usr/local/bin/denlin-cli/services/services.conf  # Give write permission for users to modify
fi

# Ensure we're able to write to services.conf
if [ ! -w "/usr/local/bin/denlin-cli/services/services.conf" ]; then
    echo "No write permission to services.conf. Please run this script as root (sudo)."
    exit 1
fi

# Read or Collect the VPS IP Address
vps_ip=$(grep "VPS_IP=" /usr/local/bin/denlin-cli/services/services.conf | cut -d'=' -f2)
if [ -z "$vps_ip" ]; then
    read -p "Enter your VPS IP address: " vps_ip
    echo "VPS_IP=$vps_ip" | sudo tee -a /usr/local/bin/denlin-cli/services/services.conf
else
    read -p "Current VPS IP is $vps_ip. Is this correct? (y/n): " confirm
    if [[ "$confirm" != "y" ]]; then
        read -p "Enter the new VPS IP address: " vps_ip
        echo "VPS_IP=$vps_ip" | sudo tee -a /usr/local/bin/denlin-cli/services/services.conf
    fi
fi

# Read or Collect the GitHub Username
github_username=$(grep "GITHUB_USERNAME=" /usr/local/bin/denlin-cli/services/services.conf | cut -d'=' -f2)
if [ -z "$github_username" ]; then
    read -p "Enter your GitHub username: " github_username
    echo "GITHUB_USERNAME=$github_username" | sudo tee -a /usr/local/bin/denlin-cli/services/services.conf
else
    read -p "Current GitHub username is $github_username. Is this correct? (y/n): " confirm
    if [[ "$confirm" != "y" ]]; then
        read -p "Enter your new GitHub username: " github_username
        echo "GITHUB_USERNAME=$github_username" | sudo tee -a /usr/local/bin/denlin-cli/services/services.conf
    fi
fi

# Ask for GitHub PAT
read -p "Enter your GitHub Personal Access Token (PAT): " github_pat

# Log in to GitHub Container Registry
echo $github_pat | docker login ghcr.io -u $github_username --password-stdin

# Step 2: Create the temporary configure-pat-locally.sh script
cat << EOF > "$TMP_PATH"
#!/bin/bash

# Step 1: Add the PAT to the .env file
if [ ! -f ".env" ]; then
    echo ".env file not found, creating one..."
    touch .env
fi

echo "GITHUB_PAT=$github_pat" >> .env

# Step 2: Add .env to .gitignore if not already ignored
if ! grep -q ".env" .gitignore; then
    echo ".env" >> .gitignore
    echo ".env has been added to .gitignore."
else
    echo ".env is already ignored in .gitignore."
fi

# Step 3: Log in to GitHub Container Registry
echo "\$GITHUB_PAT" | docker login ghcr.io -u \$GITHUB_USERNAME --password-stdin

# Clean up by deleting the script
echo "Cleaning up..."
rm -f \$HOME/$SCRIPT_NAME
exit
EOF

chmod +x "$TMP_PATH"

# Step 3: Provide instructions to the user
echo "================================================================================"
echo "A temporary configuration script has been created and saved in the VPS temp folder: $TMP_PATH"
echo ""
echo "To proceed, follow these steps:"
echo ""
echo "1. Open a new terminal window from your project folder."
echo "2. Download the second script to the current directory using this command:"
echo "   scp $USER@$vps_ip:$TMP_PATH $(pwd)/$SCRIPT_NAME"
echo ""
echo "3. Run the script using this command:"
echo "   bash ./$SCRIPT_NAME"
echo ""
echo "4. After completing the above steps, return to this terminal session."
echo ""
echo "Note: The temporary script will delete itself from the current folder and the VPS after running."
echo "================================================================================"
