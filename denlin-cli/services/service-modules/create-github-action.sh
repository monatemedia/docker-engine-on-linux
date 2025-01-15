#!/bin/bash

# Menu: Configure VPS
# Main script: Configure VPS
# Description: Create a GitHub Action like Docker Publish

# Configuration
CONF_FILE="/etc/denlin-cli.conf"
TEMP_SCRIPT="/tmp/create-github-action-temp.sh"
TEMPLATE_DIR="$(dirname "$0")/github-actions" # Ensure this points to the folder containing templates.

# Check if configuration file exists
if [[ ! -f "$CONF_FILE" ]]; then
    echo "Error: Configuration file $CONF_FILE does not exist. Please create it first."
    exit 1
fi

source "$CONF_FILE"

# Validate current working directory
current_dir=$(pwd 2>/dev/null)
if [[ -z "$current_dir" ]]; then
    echo "Error: Unable to retrieve current working directory. Ensure you are running this script in a valid directory."
    exit 1
fi

# List available templates
echo "Scanning for templates in $TEMPLATE_DIR..."
templates=($(find "$TEMPLATE_DIR" -type f \( -name "*.yml" -o -name "*.yaml" \)))

if [[ ${#templates[@]} -eq 0 ]]; then
    echo "Error: No templates found in $TEMPLATE_DIR."
    exit 1
fi

echo "Available templates:"
for i in "${!templates[@]}"; do
    template_name=$(grep -m1 '^# Template:' "${templates[$i]}" | sed 's/# Template: //')
    template_desc=$(grep -m1 '^# Description:' "${templates[$i]}" | sed 's/# Description: //')
    echo "$((i + 1))) $template_name - $template_desc"
done

# Prompt user for selection
read -rp "Enter the number of the template you want to use: " choice

if ! [[ "$choice" =~ ^[0-9]+$ ]] || ((choice < 1 || choice > ${#templates[@]})); then
    echo "Error: Invalid choice."
    exit 1
fi

# Selected template
selected_template="${templates[$((choice - 1))]}"
template_name=$(grep -m1 '^# Template:' "$selected_template" | sed 's/# Template: //')

# Create the temporary script
echo "Creating temporary script at $TEMP_SCRIPT..."
cat > "$TEMP_SCRIPT" <<EOF
#!/bin/bash
# Temporary script: Create GitHub Action Workflow
# Description: Creates a workflow based on the selected template ($template_name).

# Ensure the script is run in a Git repository
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "Error: This is not a Git repository. Please run this script from within a Git project."
    exit 1
fi

# Create .github/workflows directory if it doesn't exist
mkdir -p .github/workflows

# Copy the selected template
cp "$selected_template" .github/workflows/

# Add and commit the workflow
git add .github/workflows/$(basename "$selected_template")
git commit -m "feat: add $(basename "$selected_template") workflow"

# Push changes to the remote repository
git push

# Provide GitHub Actions link
repo_url=\$(git config --get remote.origin.url)
repo_url=\$(echo "\$repo_url" | sed 's|git@github.com:|https://github.com/|' | sed 's|\.git\$||')
if [[ -n "\$repo_url" ]]; then
    echo "Your changes have been pushed. Open the 'Actions' tab in your repository to see the workflow triggered."
    echo "\$repo_url/actions"
else
    echo "Error: Unable to determine repository URL."
fi

# Cleanup
echo "Cleaning up temporary script..."
rm -- "\$0"
EOF

# Make the temporary script executable
chmod +x "$TEMP_SCRIPT"

# Provide instructions to the user
echo "Temporary script created at $TEMP_SCRIPT."
echo "To use it, download the script to your local computer and run it from your project root directory:"
echo
echo "scp ${USER}@${vps_ip}:$TEMP_SCRIPT ./create-github-action-temp.sh"
echo
echo "Then run:"
echo "./create-github-action-temp.sh"
echo
echo "Once the script finishes, it will delete itself."
