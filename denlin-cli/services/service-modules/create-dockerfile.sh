#!/bin/bash

# Filepath for denlin-cli config
CONF_FILE="/etc/denlin-cli.conf"

# Step 1: Check and load configuration variables
if [[ -f "$CONF_FILE" ]]; then
    source "$CONF_FILE"
else
    echo "Configuration file $CONF_FILE not found!"
    exit 1
fi

# Step 2: Get current user logged into VPS (programmatically)
vps_user=$(whoami)

# Step 3: Prompt user for VPS IP if not in config
if [[ -z "$vps_ip" ]]; then
    read -p "Enter the VPS IP address: " vps_ip
    sudo bash -c "echo 'vps_ip=\"$vps_ip\"' >> $CONF_FILE"
    echo "VPS IP saved to $CONF_FILE."
fi

# Step 4: List available Dockerfile templates and descriptions
echo "Available Dockerfile templates:"
echo "-----------------------------"

# Loop through dockerfile directory and display templates with descriptions
template_files=()
for template in /usr/local/bin/denlin-cli/services/dockerfile/*.sh; do
    # Get template name and description
    template_name=$(grep -m 1 "^# Template:" "$template" | cut -d ':' -f2- | xargs)
    description=$(grep -m 1 "^# Description:" "$template" | cut -d ':' -f2- | xargs)
    echo "$template_name: $description"
    template_files+=("$template")
done

# Step 5: Prompt user to select a template
echo "Please select a template from the list above by entering the corresponding name:"
read selected_template

# Step 6: Verify selected template exists
selected_template_path=""
for template_path in "${template_files[@]}"; do
    template_name=$(grep -m 1 "^# Template:" "$template_path" | cut -d ':' -f2- | xargs)
    if [[ "$template_name" == "$selected_template" ]]; then
        selected_template_path="$template_path"
        break
    fi
done

if [[ -z "$selected_template_path" ]]; then
    echo "Invalid template name. Exiting."
    exit 1
fi

# Step 7: Create a temporary script in /tmp that the user will download
temp_script="/tmp/create-dockerfile.sh"
cat <<EOL > "$temp_script"
#!/bin/bash

# This script will create the selected Dockerfile in the current directory

# Define the selected Dockerfile template path
template_path="$selected_template_path"

# Check if template exists
if [[ ! -f "\$template_path" ]]; then
    echo "Selected template not found. Exiting."
    exit 1
fi

# Read the template content and save it as a Dockerfile
template_name=\$(grep -m 1 "^# Template:" "\$template_path" | cut -d ':' -f2- | xargs)
description=\$(grep -m 1 "^# Description:" "\$template_path" | cut -d ':' -f2- | xargs)
dockerfile_content=\$(sed -n '3,\$p' "\$template_path")

# Create the Dockerfile in the current directory
echo "\$dockerfile_content" > Dockerfile

echo "Dockerfile created from the selected template (\$template_name) in the current directory."

# Clean up: remove this script after execution
rm -- "\$0"
EOL

# Step 8: Provide download instructions for the temporary script
echo "The script to create your Dockerfile has been created in $temp_script."
echo "To download and execute the script, run the following command:"
echo "scp $vps_user@$vps_ip:$temp_script ./create-dockerfile.sh"
echo "Once downloaded, run the script in your project folder to generate the Dockerfile."

# Step 9: Clean up the temporary script from the VPS
ssh "$vps_user@$vps_ip" "rm $temp_script"

# Step 10: Self-delete the current script from the local machine
echo "Cleaning up the local script..."
rm -- "$0"
