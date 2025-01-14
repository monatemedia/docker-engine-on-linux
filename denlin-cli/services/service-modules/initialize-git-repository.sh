#!/bin/bash

# Main script: Configure VPS
# Description: Initializes git repo for your project on your local computer

# Get the username of the logged-in user on the VPS
vps_user=$(whoami)

CONF_FILE="/etc/denlin-cli.conf"
TEMP_SCRIPT="/tmp/initialize-git-repository-temp.sh"

# Step 1: Get or set variables from /etc/denlin-cli.conf
echo "Checking configuration file at $CONF_FILE..."
if [[ ! -f "$CONF_FILE" ]]; then
    echo "$CONF_FILE does not exist. Creating it now."
    sudo bash -c "cat > $CONF_FILE" <<EOF
vps_ip=
github_username=
EOF
fi

source "$CONF_FILE"

# Prompt for VPS IP
read -p "Enter VPS IP or hit ENTER to accept (current: ${vps_ip:-not set}): " input_vps_ip
vps_ip="${input_vps_ip:-$vps_ip}"

# Prompt for GitHub username
read -p "Enter GitHub username or hit ENTER to accept (current: ${github_username:-not set}): " input_github_username
github_username="${input_github_username:-$github_username}"

# Update the configuration file
echo "Updating configuration file..."
sudo bash -c "cat > $CONF_FILE" <<EOF
vps_ip=$vps_ip
github_username=$github_username
EOF

# Step 2: Create the temporary script
echo "Creating temporary script at $TEMP_SCRIPT..."
cat > "$TEMP_SCRIPT" <<'EOF'
#!/bin/bash

# Step 1: Initialize Git repository
PROJECT_NAME=$(basename "$PWD")
echo "Initializing a Git repository for project: $PROJECT_NAME"
git init
git add .
git commit -m "Initial commit"

# Step 2: Create GitHub repository
echo "Creating GitHub repository..."
gh repo create "$PROJECT_NAME" --source=. --public --remote=origin

# Step 3: Push changes to GitHub
echo "Pushing changes to GitHub..."
git push -u origin main

# Step 4: Cleanup
echo "Cleaning up temporary script..."
rm -- "$0"
ssh "${vps_user}@${vps_ip}" "rm /tmp/initialize-git-repository-temp.sh"
echo "Cleanup complete. You may now close this terminal."
EOF

# Step 3: Add instructions for the user
echo "Temporary script created."
echo "To use it, download the script to your local computer and run it from your project root folder:"
echo
echo "scp ${vps_user}@${vps_ip}:/tmp/initialize-git-repository-temp.sh ./initialize-git-repository.sh"
echo
echo "Then run:"
echo "./initialize-git-repository.sh"
echo
echo "This action will initialize a Git repository, set up a GitHub repository, and push your code to GitHub."
echo "Once the script finishes, it will delete itself from both the VPS and the local computer."
echo "You may now close this terminal window."
