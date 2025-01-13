#!/bin/bash

# Main script: Configure VPS
# Description: Create a Dockerfile for your project on your local computer

CONF_FILE="/etc/denlin-cli.conf"
TEMP_SCRIPT="/tmp/create-dockerfile.sh"

# Function to read configuration
read_conf() {
  if [[ -f "$CONF_FILE" ]]; then
    source "$CONF_FILE"
  else
    echo "Configuration file not found: $CONF_FILE"
    exit 1
  fi
}

# Function to display available templates
list_templates() {
  echo "Available Dockerfile templates:"
  i=1
  for file in ./dockerfile/*.sh; do
    if [[ -f "$file" ]]; then
      template_name=$(grep -i "Template:" "$file" | awk -F: '{print $2}' | xargs)
      description=$(grep -i "Description:" "$file" | awk -F: '{print $2}' | xargs)
      templates[$i]="$file"
      echo "[$i] $template_name - $description"
      ((i++))
    fi
  done
}

# Function to generate temporary script
generate_temp_script() {
  selected_template="$1"
  template_content=$(cat "$selected_template")

  cat <<EOL >"$TEMP_SCRIPT"
#!/bin/bash

# Create Dockerfile in the current directory
echo "Creating Dockerfile in the current directory..."
cat <<DOCKERFILE > Dockerfile
$template_content
DOCKERFILE

echo "Dockerfile has been created successfully."

# Clean up
echo "Cleaning up temporary script..."
rm -- "\$0"
echo "Temporary script has been deleted."
EOL

  chmod +x "$TEMP_SCRIPT"
}

# Function to provide download instructions
provide_download_instructions() {
  echo "Temporary script has been created at $TEMP_SCRIPT"
  echo "To download it to your local computer, run the following command:"
  echo "scp ${vps_user}@${vps_ip}:/tmp/create-dockerfile.sh ./create-dockerfile.sh"
  echo "Then, navigate to the root of your project directory and run the script:"
  echo "./create-dockerfile.sh"
}

# Main script logic
read_conf

# Ensure required variables are present
if [[ -z "$vps_ip" ]]; then
  echo "VPS IP address is not configured. Please update $CONF_FILE."
  exit 1
fi

vps_user=$(whoami)

# List available templates
declare -A templates
list_templates

# Get user selection
while :; do
  echo
  read -p "Enter the number of the template you want to use: " choice
  if [[ -n "${templates[$choice]}" ]]; then
    selected_template="${templates[$choice]}"
    echo "You selected: $(grep -i "Template:" "$selected_template" | awk -F: '{print $2}' | xargs)"
    break
  else
    echo "Invalid choice. Please try again."
  fi
done

# Generate temporary script
generate_temp_script "$selected_template"

# Provide download instructions
provide_download_instructions
