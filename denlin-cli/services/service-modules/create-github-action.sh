#!/bin/bash

# Main script: Create GitHub Action
# Description: Generates a temporary script to create a GitHub Action in the user's local project directory

CONF_FILE="/etc/denlin-cli.conf"
GITHUB_ACTIONS_DIR="/usr/local/bin/denlin-cli/services/github-actions"
TEMP_SCRIPT="/tmp/create-github-action-temp.sh"

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
  echo "Available GitHub Action templates:"
  i=1
  for file in "$GITHUB_ACTIONS_DIR"/*.yml; do
    if [[ -f "$file" ]]; then
      template_name=$(grep -i "Template:" "$file" | awk -F: '{print $2}' | xargs)
      description=$(grep -i "Description:" "$file" | awk -F: '{print $2}' | xargs)
      templates[$i]="$file"
      echo "[$i] $template_name - $description"
      ((i++))
    fi
  done
  if [[ $i -eq 1 ]]; then
    echo "No GitHub Action templates found in $GITHUB_ACTIONS_DIR."
    exit 1
  fi
}

# Function to generate a temporary script for GitHub Action
generate_temp_script() {
  selected_template="$1"
  template_content=$(cat "$selected_template")

  # Automatically fetch the repository name and GitHub user from git config
  repo_name=$(git config --get remote.origin.url | sed -n 's#.*/\([^/]*\)\.git$#\1#p')
  github_user=$(git config --get remote.origin.url | sed -n 's#.*[:/]\([^/]*\)/.*#\1#p')

  # Debugging statements (optional)
  echo "Repo name resolved as: $repo_name"
  echo "GitHub user resolved as: $github_user"

  # Update placeholders in the template
  template_content=$(echo "$template_content" | sed "s|\${{ github.actor }}/\$current_repo|\${{ github.actor }}/\$repo_name|g")
  template_content=$(echo "$template_content" | sed "s|ghcr.io/\${{ github.actor }}/\$current_repo|ghcr.io/\${{ github.actor }}/\$repo_name|g")

  # Create .github/workflows directory if it doesn't exist
  mkdir -p .github/workflows

  # Add the GitHub Action template
  cat <<GITHUB_ACTION > .github/workflows/$(basename "$selected_template")
$template_content
GITHUB_ACTION

  echo "GitHub Action template created in .github/workflows/$(basename "$selected_template")."

  # Git operations
  git add .github/workflows/$(basename "$selected_template")
  git commit -m "feat: Add GitHub Action for Docker publish"
  git push

  # Provide the GitHub Actions link for tracking progress
  echo "GitHub Action created. Track it here:"
  echo "https://github.com/$github_user/$repo_name/actions"

  # Cleanup: Remove the temporary script locally and on the VPS
  rm -- "$0"
  ssh ${vps_user}@${vps_ip} "rm -f $TEMP_SCRIPT"
}

# Function to provide download instructions
provide_download_instructions() {
  echo "Temporary script has been created at $TEMP_SCRIPT"
  echo "To download it to your local computer, run the following command:"
  echo "scp ${vps_user}@${vps_ip}:$TEMP_SCRIPT ./create-github-action-temp.sh"
  echo "Then, navigate to the root of your project directory and run the script:"
  echo "./create-github-action-temp.sh"
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
