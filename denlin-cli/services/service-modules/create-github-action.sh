#!/bin/bash

# Path to the temporary script
TEMP_SCRIPT="/tmp/create-github-action-temp.sh"
TEMPLATE_DIR="/usr/local/bin/denlin-cli/services/github-actions"  # Template directory on VPS

# Check if configuration file exists
CONF_FILE="/etc/denlin-cli.conf"
if [[ ! -f "$CONF_FILE" ]]; then
    echo "Error: Configuration file $CONF_FILE does not exist. Please create it first."
    exit 1
fi

source "$CONF_FILE"

# List available templates from the predefined directory
echo "Scanning for templates in $TEMPLATE_DIR..."
templates=($(find "$TEMPLATE_DIR" -type f \( -name "*.yml" -o -name "*.yaml" \)))

if [[ ${#templates[@]} -eq 0 ]]; then
    echo "Error: No templates found in $TEMPLATE_DIR."
    exit 1
fi

# Select template from available options (just showing the first one for simplicity)
selected_template="${templates[0]}"

echo "Selected template: $selected_template"

# Create a temporary script for the user to download
cat <<EOL > "$TEMP_SCRIPT"
#!/bin/bash

# This is a temporary script for setting up a GitHub Action on your local machine
echo "This script will add a GitHub Action to your repository."

# Copy selected GitHub Action template to the local repository
cp "$selected_template" .github/workflows/

echo "GitHub Action template has been copied to your repository."

EOL

# Notify the user where to download the script
echo "Temporary script created at $TEMP_SCRIPT. Download this file and run it locally in your project directory."
