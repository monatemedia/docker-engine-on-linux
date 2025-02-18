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

echo ""

# Prompt for VPS IP
read -p "Enter VPS IP or hit ENTER to accept (current: ${vps_ip:-not set}): " input_vps_ip
vps_ip="${input_vps_ip:-$vps_ip}"

# Prompt for GitHub username
read -p "Enter GitHub username or hit ENTER to accept (current: ${github_username:-not set}): " input_github_username
github_username="${input_github_username:-$github_username}"

# Ensure the config file has the correct entries
if grep -q "^vps_ip=" "$CONF_FILE"; then
    sudo sed -i "s|^vps_ip=.*|vps_ip=$vps_ip|" "$CONF_FILE"
else
    echo "vps_ip=$vps_ip" | sudo tee -a "$CONF_FILE" > /dev/null
fi

if grep -q "^github_username=" "$CONF_FILE"; then
    sudo sed -i "s|^github_username=.*|github_username=$github_username|" "$CONF_FILE"
else
    echo "github_username=$github_username" | sudo tee -a "$CONF_FILE" > /dev/null
fi


echo ""

# Step 2: Create the temporary script
echo "Creating temporary script at $TEMP_SCRIPT..."
cat > "$TEMP_SCRIPT" <<'EOF'
#!/bin/bash

# Step 1: Check for or create a .gitignore file and add .env and node_modules
echo "Checking for or creating .gitignore file..."
if [ ! -f .gitignore ]; then
    echo ".gitignore file not found. Creating one..."
    touch .gitignore
else
    echo ".gitignore file already exists."
fi

# Add .env and node_modules to .gitignore if not already present
if ! grep -qx ".env" .gitignore; then
    echo ".env" >> .gitignore
    echo "Added .env to .gitignore."
fi

if ! grep -qx "node_modules" .gitignore; then
    echo "node_modules" >> .gitignore
    echo "Added node_modules to .gitignore."
fi

# Step 2: Initialize Git repository with 'main' as the default branch
PROJECT_NAME=$(basename "$PWD")
echo "Initializing a Git repository for project: $PROJECT_NAME"
git init --initial-branch=main
git add .
git commit -m "Initial commit"

# Step 3: Create GitHub repository
echo "Creating GitHub repository..."
gh repo create "$PROJECT_NAME" --source=. --public --remote=origin

# Step 4: Push changes to GitHub
echo "Pushing changes to GitHub..."
git push -u origin main

# Step 5: Cleanup
echo "Cleaning up temporary script..."
rm -- "$0"
ssh "${vps_user}@${vps_ip}" "rm /tmp/initialize-git-repository-temp.sh"
echo "Cleanup complete. You may now close this terminal."
EOF

# Step 3: Add instructions for the user
echo "Temporary script created."
echo ""
echo "To use it, download the script to your local computer and run it from your project root folder:"
echo
echo "  scp ${vps_user}@${vps_ip}:/tmp/initialize-git-repository-temp.sh ./initialize-git-repository.sh"
echo
echo "Then run:"
echo
echo "  ./initialize-git-repository.sh"
echo
echo "This action will initialize a Git repository, set up a GitHub repository, and push your code to GitHub."
echo "Once the script finishes, it will delete itself from both the VPS and the local computer."
echo
