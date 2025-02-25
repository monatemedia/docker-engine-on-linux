#!/bin/bash

# Main script: Configure VPS
# Description: Renames the 'master' branch to 'main' in your git repository

# Get the username of the logged-in user on the VPS
vps_user=$(whoami)

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

# Step 4: Check if the current branch is 'main'
current_branch=\$(git symbolic-ref --short HEAD)

if [[ "\$current_branch" != "main" ]]; then
    echo "Error: The current branch is not 'main', it's '\$current_branch'. Please switch to 'main' first."
    exit 1
fi

# Step 5: Fetch updates from the remote repository
echo "Fetching updates from remote repository..."
git fetch origin

# Check if the remote 'main' branch exists, and create it if it doesn't
if ! git show-ref --verify --quiet refs/remotes/origin/main; then
    echo "Remote 'main' branch does not exist. Creating it now..."
    git push origin main
fi

# Set the upstream for the local 'main' branch
git branch --unset-upstream
git branch -u origin/main
git remote set-head origin -a

# Step 6: Push the 'main' branch and ensure that we set 'main' as the default branch
echo "Pushing 'main' branch and changing default to 'main' on GitHub..."

# First, push the main branch
git push origin main

# Now, check if 'master' is the default branch and change it if necessary
default_branch=$(git remote show origin | grep 'HEAD branch' | awk '{print $3}')

if [[ "$default_branch" == "master" ]]; then
    echo "'master' is the default branch. Changing default to 'main' on GitHub..."

    # Use GitHub API to update default branch (requires a GitHub Personal Access Token with repo scope)
    github_token="YOUR_GITHUB_TOKEN"  # Replace with your GitHub token
    repo_name="monatemedia/laragigs"  # Replace with your repository name

    curl -X PATCH -H "Authorization: token $github_token" \
         -d '{"default_branch": "main"}' \
         "https://api.github.com/repos/$repo_name"

    echo "Default branch changed to 'main' on GitHub."
else
    echo "'$default_branch' is already the default branch. Skipping default change."
fi

# Step 7: Delete remote 'master' branch
echo "Deleting remote 'master' branch..."
git push origin --delete master || echo "Failed to delete remote 'master' branch. You may need to manually delete it after changing the default branch."

# Step 8: Cleaning up
echo "Cleaning up script..."
rm -- "\$0"
echo "Rename complete. You can now close this terminal."
EOF

# Provide user with download instructions
echo "Temporary script created."
echo "Download and run it from your local machine:"
echo ""
echo "  scp ${vps_user}@${vps_ip}:/tmp/rename-git-branch.sh ./rename-git-branch.sh"
echo ""
echo "Then run command  ./rename-git-branch.sh"
echo ""
echo "Once completed, the script will delete itself."
