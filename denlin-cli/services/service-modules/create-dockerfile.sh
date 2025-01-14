#!/bin/bash

# Main script: Configure VPS
# Description: Create a Dockerfile, .dockerignore, and .gitignore for your project

CONF_FILE="/etc/denlin-cli.conf"
DOCKERFILE_DIR="/usr/local/bin/denlin-cli/dockerfile"
DOCKERIGNORE_DIR="/usr/local/bin/denlin-cli/dockerignore"
GITIGNORE_DIR="/usr/local/bin/denlin-cli/gitignore"
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

# Function to append missing content to a file
append_if_missing() {
  local file="$1"
  local content="$2"
  if ! grep -Fxq "$content" "$file"; then
    echo "$content" >> "$file"
  fi
}

# Function to create or update .dockerignore and .gitignore
create_or_update_ignore_files() {
  local project_type="$1"

  # Generate .dockerignore
  local dockerignore_template="$DOCKERIGNORE_DIR/${project_type}-dockerignore-template.sh"
  if [[ -f "$dockerignore_template" ]]; then
    echo "Creating or updating .dockerignore..."
    while IFS= read -r line; do
      append_if_missing ".dockerignore" "$line"
    done < <(grep -v '^#' "$dockerignore_template") # Exclude comments
  else
    echo "Dockerignore template for $project_type not found."
  fi

  # Generate .gitignore
  local gitignore_template="$GITIGNORE_DIR/${project_type}-gitignore-template.sh"
  if [[ -f "$gitignore_template" ]]; then
    echo "Creating or updating .gitignore..."
    while IFS= read -r line; do
      append_if_missing ".gitignore" "$line"
    done < <(grep -v '^#' "$gitignore_template") # Exclude comments
  else
    echo "Gitignore template for $project_type not found."
  fi
}

# Function to generate temporary script
generate_temp_script() {
  local selected_template="$1"
  local template_content=$(cat "$selected_template")

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
    project_type=$(basename "$selected_template" | cut -d- -f1) # Extract project type
    echo "You selected: $(grep -i "Template:" "$selected_template" | awk -F: '{print $2}' | xargs)"
    break
  else
    echo "Invalid choice. Please try again."
  fi
done

# Generate temporary script
generate_temp_script "$selected_template"

# Create or update .dockerignore and .gitignore
create_or_update_ignore_files "$project_type"

# Provide download instructions
provide_download_instructions
