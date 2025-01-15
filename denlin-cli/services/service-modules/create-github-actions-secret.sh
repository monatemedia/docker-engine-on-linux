#!/bin/bash

# Main script: Configure VPS
# Description: Generates a temporary script that handles GitHub Actions secrets, then deletes itself.

# Variables
CONF_FILE="/etc/denlin-cli.conf"
TEMP_SCRIPT="/tmp/create-github-secret-temp.sh"
current_repo=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" || echo "not-a-git-repo")

# Step 1: Load configuration from `denlin-cli.conf`
echo "Checking configuration file at $CONF_FILE..."
if [[ ! -f "$CONF_FILE" ]]; then
    echo "Error: Configuration file $CONF_FILE does not exist. Please create it first."
    exit 1
fi

source "$CONF_FILE"

# Prompt for GitHub username if not set
if [[ -z "$github_username" ]]; then
    read -p "Enter your GitHub username: " github_username
fi

# Check if `CR_PAT` exists in the configuration file
use_cr_pat=false
if [[ -n "$CR_PAT" ]]; then
    echo "A CR_PAT (Personal Access Token) was found in the configuration file."
    read -p "Do you want to create a GitHub Actions secret for this PAT? (yes/no): " use_cr_pat_input
    [[ "$use_cr_pat_input" =~ ^[Yy](es)?$ ]] && use_cr_pat=true
fi

# Step 2: Create the temporary script
echo "Creating temporary script at $TEMP_SCRIPT..."
cat > "$TEMP_SCRIPT" <<EOF
#!/bin/bash

# Temporary script: Create a GitHub Actions secret
# This script will delete itself upon successful execution.

# Check prerequisites
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed. Visit https://cli.github.com/ to install."
    exit 1
fi

# Authenticate with GitHub CLI if needed
if ! gh auth status &> /dev/null; then
    echo "You are not authenticated with GitHub CLI. Please authenticate now."
    gh auth login
fi

# Extract the GitHub repository name from the remote URL
remote_url=\$(git config --get remote.origin.url)

# Ensure remote_url is not empty
if [[ -z "\$remote_url" ]]; then
    echo "Error: No remote URL found. Please ensure this is a Git repository with a remote origin."
    exit 1
fi

# Parse remote URL to get the repository name
if [[ "\$remote_url" =~ github\.com[:/](.+)/(.+)\.git ]]; then
    repo_owner="\${BASH_REMATCH[1]}"
    repo_name="\${BASH_REMATCH[2]}"
else
    echo "Error: Unable to parse the remote URL '\$remote_url'. Ensure it points to a valid GitHub repository."
    exit 1
fi

# Combine GitHub username and repo name into full repo identifier
full_repo="\${repo_owner}/\${repo_name}"

# Validate the full repository format
if [[ ! "\$full_repo" =~ ^[a-zA-Z0-9_-]+/[a-zA-Z0-9_-]+$ ]]; then
    echo "Error: The repository identifier '\$full_repo' is invalid. Please ensure your GitHub username and repository name are correct."
    exit 1
fi

EOF

if [[ "$use_cr_pat" == true ]]; then
    # Use CR_PAT from the configuration file
    cat >> "$TEMP_SCRIPT" <<EOF
# Use CR_PAT from configuration file
secret_name="PAT"
secret_value="$CR_PAT"
EOF
else
    # Prompt for secret name and value
    cat >> "$TEMP_SCRIPT" <<EOF
# Prompt for secret name and value
read -p "Enter the secret name (default: MY_SECRET): " secret_name
secret_name=\${secret_name:-MY_SECRET}
read -s -p "Enter your secret's value: " secret_value
echo
EOF
fi

cat >> "$TEMP_SCRIPT" <<EOF

# Set the secret in GitHub Actions
echo
echo "Creating GitHub Actions secret '\$secret_name' for repository '\$full_repo'..."
if gh secret set "\$secret_name" --body "\$secret_value" --repo "\$full_repo"; then
    echo "Success: Secret '\$secret_name' added to repository '\$full_repo'."
else
    echo "Error: Failed to add the secret. Please check your inputs and try again."
    exit 1
fi

echo

# Inform the user where the secret has been saved
echo "You can find your GitHub Actions secret saved to the repository here:"
echo
echo "  https://github.com/\$repo_owner/\$repo_name/settings/secrets/actions"
echo

# Cleanup: Delete the script
echo "Cleaning up temporary script..."
rm -- "\$0"
ssh "${USER}@${vps_ip}" "rm /tmp/create-github-secret-temp.sh"
echo "Cleanup complete. You may now close this terminal."
EOF

chmod +x "$TEMP_SCRIPT"

# Instructions for the user
echo "Temporary script created at $TEMP_SCRIPT."
echo "To use it, download the script to your local computer and run it from your project root folder:"
echo
echo "scp ${USER}@${vps_ip}:$TEMP_SCRIPT ./create-github-secret-temp.sh"
echo
echo "Then run:"
echo "./create-github-secret-temp.sh"
echo
echo "Once the script finishes, it will delete itself from both the project folder and the VPS."
echo "You may now close this terminal window."
