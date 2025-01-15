#!/bin/bash

# Menu: Configure VPS
# Main script: Configure VPS
# Description: Create a GitHub Action like Docker Publish

# Variables
GITHUB_ACTIONS_DIR="/usr/local/bin/denlin-cli/services/github-actions"
TEMP_SCRIPT="/tmp/create-github-action-temp.sh"
CONF_FILE="/etc/denlin-cli.conf"
current_repo=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" || echo "not-a-git-repo")

# Step 1: Load configuration from `denlin-cli.conf`
if [[ ! -f "$CONF_FILE" ]]; then
    echo "Error: Configuration file $CONF_FILE does not exist. Please create it first."
    exit 1
fi

source "$CONF_FILE"

# Step 2: Validate repository name
if [[ "$current_repo" == "not-a-git-repo" ]]; then
    echo "Error: This script must be run inside a Git repository."
    exit 1
fi

# Step 3: Find and display template options
templates=()
descriptions=()

while IFS= read -r -d '' file; do
    template=$(grep -m 1 '^# Template:' "$file" | sed 's/# Template: //')
    description=$(grep -m 1 '^# Description:' "$file" | sed 's/# Description: //')

    if [[ -n "$template" && -n "$description" ]]; then
        templates+=("$template")
        descriptions+=("$description")
    fi
done < <(find "$GITHUB_ACTIONS_DIR" -type f \( -name '*.yml' -o -name '*.yaml' \) -print0)

if [[ ${#templates[@]} -eq 0 ]]; then
    echo "No templates found in $GITHUB_ACTIONS_DIR."
    exit 1
fi

echo "Available templates:"
for i in "${!templates[@]}"; do
    echo "$((i + 1))) ${templates[$i]} - ${descriptions[$i]}"
done

# Step 4: Prompt user to choose a template
read -rp "Enter the number of the template you want to use: " choice

if ! [[ "$choice" =~ ^[0-9]+$ ]] || ((choice < 1 || choice > ${#templates[@]})); then
    echo "Invalid choice. Exiting."
    exit 1
fi

selected_template="${templates[$((choice - 1))]}"
selected_file=$(find "$GITHUB_ACTIONS_DIR" -type f \( -name '*.yml' -o -name '*.yaml' \) -exec grep -l "# Template: $selected_template" {} +)

# Step 5: Create the workflow file
mkdir -p .github/workflows
cp "$selected_file" ".github/workflows/$(basename "$selected_file")"

git add .github/workflows
git commit -m "feat: add ${selected_template}.yml workflow"
git push

repo_owner=$(git config --get remote.origin.url | sed -n 's|.*github\.com[:/]\(.*\)/.*|\1|p')
repo_name=$(git config --get remote.origin.url | sed -n 's|.*/\(.*\)\.git|\1|p')

if [[ -n "$repo_owner" && -n "$repo_name" ]]; then
    actions_link="https://github.com/$repo_owner/$repo_name/actions"
    echo "Your changes have been pushed. Visit the Actions tab in your repository to see the workflow triggered."
    echo "Actions tab: $actions_link"
else
    echo "Error: Unable to determine repository owner or name. Ensure this is a valid Git repository."
fi

# Step 6: Cleanup SSH usage warnings
ssh_cleanup() {
    ssh -o LogLevel=QUIET -o BatchMode=yes "${USER}@${vps_ip}" "rm -f $TEMP_SCRIPT" &>/dev/null
}

echo "Cleaning up temporary script from the local machine..."
ssh_cleanup
echo "Cleanup complete. You may now close this terminal."
