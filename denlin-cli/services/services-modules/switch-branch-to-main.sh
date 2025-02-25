#!/bin/bash

# Main script: Configure VPS
# Description: Renames the 'master' branch to 'main' in your git repository

# Configuration file
CONF_FILE="/etc/denlin-cli.conf"

# Define temporary script path
TEMP_SCRIPT="/tmp/rename-git-branch.sh"

# Check if config file exists
if [[ ! -f "$CONF_FILE" ]]; then
    echo "Error: Configuration file $CONF_FILE not found!"
    exit 1
fi

# Read variables from config file
source "$CONF_FILE"

# Ensure necessary variables are set
if [[ -z "$vps_ip" ]]; then
    echo "Error: Missing 'vps_ip' in $CONF_FILE!"
    exit 1
fi

# Create the temporary script
echo "Creating temporary script at $TEMP_SCRIPT..."
cat > "$TEMP_SCRIPT" <<EOF
#!/bin/bash

# Set project directory
PROJECT_DIR="\$(pwd)"

# Step 1: Check or create .gitignore and .dockerignore
echo "Checking if .gitignore and .dockerignore exist..."
if [[ ! -f "\$PROJECT_DIR/.gitignore" ]]; then
    echo ".gitignore not found. Creating it now..."
    touch "\$PROJECT_DIR/.gitignore"
fi

if [[ ! -f "\$PROJECT_DIR/.dockerignore" ]]; then
    echo ".dockerignore not found. Creating it now..."
    touch "\$PROJECT_DIR/.dockerignore"
fi

# Step 2: Add script to ignore lists
echo "Adding script to .gitignore and .dockerignore..."
echo "rename-git-branch.sh" >> "\$PROJECT_DIR/.gitignore"
echo "rename-git-branch.sh" >> "\$PROJECT_DIR/.dockerignore"

# Step 3: Rename git branch locally
echo "Renaming 'master' branch to 'main' locally..."
git branch -m master main

# Step 4: Update remote repository
echo "Updating remote repository..."
git fetch origin
git branch --unset-upstream
git branch -u origin/main
git remote set-head origin -a

# Step 5: Push new branch and delete 'master'
echo "Pushing 'main' branch and deleting 'master'..."
git push origin main
git push origin --delete master

# Step 6: Cleanup
echo "Cleaning up script..."
rm -- "\$0"
echo "Rename complete. You can now close this terminal."
EOF

# Provide user with download instructions
echo "Temporary script created."
echo "Download and run it from your local machine:"
echo ""
echo "  scp \$USER@${vps_ip}:/tmp/rename-git-branch.sh ./rename-git-branch.sh"
echo ""
echo "Then run command  ./rename-git-branch.sh"
echo ""
echo "Once completed, the script will delete itself."