#!/bin/bash

# Main script: Configure VPS
# Description: Create a Dockerfile, .dockerignore, and .gitignore for your project on your local computer

CONF_FILE="/etc/denlin-cli.conf"
DOCKERFILE_DIR="/usr/local/bin/denlin-cli/services/dockerfile"
GITIGNORE_DIR="/usr/local/bin/denlin-cli/services/gitignore"
DOCKERIGNORE_DIR="/usr/local/bin/denlin-cli/services/dockerignore"
TEMP_SCRIPT="/tmp/create-dockerfile-temp.sh"

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
  for file in "$DOCKERFILE_DIR"/*.sh; do
    if [[ -f "$file" ]]; then
      template_name=$(grep -i "Template:" "$file" | awk -F: '{print $2}' | xargs)
      description=$(grep -i "Description:" "$file" | awk -F: '{print $2}' | xargs)
      templates[$i]="$file"
      echo "[$i] $template_name - $description"
      ((i++))
    fi
  done
  if [[ $i -eq 1 ]]; then
    echo "No Dockerfile templates found in $DOCKERFILE_DIR."
    exit 1
  fi
}

# Function to generate temporary script for Dockerfile
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

# Create .dockerignore in the current directory
echo "Creating .dockerignore in the current directory..."
cat <<DOCKERIGNORE > .dockerignore
$(cat "$DOCKERIGNORE_DIR"/$(basename "$selected_template" | sed 's/dockerfile/dockerignore/'))
DOCKERIGNORE

# Create .gitignore in the current directory
echo "Creating .gitignore in the current directory..."
cat <<GITIGNORE > .gitignore
$(cat "$GITIGNORE_DIR"/$(basename "$selected_template" | sed 's/dockerfile/gitignore/'))
GITIGNORE

echo "Dockerfile, .dockerignore, and .gitignore have been created successfully."

# Clean up
echo "Cleaning up temporary script..."
rm -- "\$0"
ssh "${vps_user}@${vps_ip}" "rm /tmp/create-dockerfile-temp.sh"
echo "Cleanup complete. You may now close this terminal."
EOL

  chmod +x "$TEMP_SCRIPT"
}

# Function to provide download instructions
provide_download_instructions() {
  echo "Temporary script has been created at $TEMP_SCRIPT"
  echo "To download it to your local computer, run the following command:"
  echo "scp ${vps_user}@${vps_ip}:/tmp/create-dockerfile-temp.sh ./create-dockerfile-temp.sh"
  echo "Then, navigate to the root of your project directory and run the script:"
  echo "./create-dockerfile-temp.sh"
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
