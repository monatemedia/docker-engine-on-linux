#!/bin/bash

# Main script: Configure VPS
# Description: Store the Docker image to GitHub Registry

# Get the username of the logged-in user on the VPS
vps_user=$(whoami)

# Variables
CONF_FILE="/etc/denlin-cli.conf"
TEMP_SCRIPT="/tmp/store-docker-image-temp.sh"

# Step 1: Get or set variables from /etc/denlin-cli.conf
echo "Checking configuration file at $CONF_FILE..."
if [[ ! -f "$CONF_FILE" ]]; then
    echo "$CONF_FILE does not exist. Creating it now."
    sudo bash -c "cat > $CONF_FILE" <<EOF
vps_ip=
github_username=
CR_PAT=
EOF
fi

source "$CONF_FILE"

# Prompt for VPS IP
read -p "Enter VPS IP (current: ${vps_ip:-not set}): " input_vps_ip
vps_ip="${input_vps_ip:-$vps_ip}"

# Prompt for GitHub username
read -p "Enter GitHub username (current: ${github_username:-not set}): " input_github_username
github_username="${input_github_username:-$github_username}"

# Prompt for GitHub PAT
read -s -p "Enter GitHub PAT (current: ${CR_PAT:+(Hidden)}): " input_CR_PAT
echo
CR_PAT="${input_CR_PAT:-$CR_PAT}"

# Update the configuration file
echo "Updating configuration file..."
sudo bash -c "cat > $CONF_FILE" <<EOF
vps_ip=$vps_ip
github_username=$github_username
CR_PAT=$CR_PAT
EOF

# Step 2: Create the temporary script
echo "Creating temporary script at $TEMP_SCRIPT..."
cat > "$TEMP_SCRIPT" <<EOF
#!/bin/bash

# Export github_username and CR_PAT variables
export github_username="$github_username"
export CR_PAT="$CR_PAT"

# Automatically get the name of the current directory
application_name=\$(basename "\$(pwd)")

# Step 1: Ensure Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first and try again."
    exit 1
fi

# Step 2: Wait for Docker to be ready
echo "Checking if Docker is running..."
while ! docker info &> /dev/null; do
    echo "Waiting for Docker Desktop to start..."
    sleep 5
done
echo "Docker Desktop is running."

# Step 3: Log in to GitHub Container Registry
if [[ -z "\$CR_PAT" ]]; then
    echo "GitHub Personal Access Token (CR_PAT) is not set. Exiting..."
    exit 1
fi

echo "Logging into GitHub Container Registry..."
if echo "\$CR_PAT" | docker login ghcr.io -u "\$github_username" --password-stdin; then
    echo "Successfully logged in to GitHub Container Registry."
else
    echo "Failed to log in to GitHub Container Registry. Please ensure your CR_PAT is valid."
    exit 1
fi

# Step 4: Build and push the Docker image
echo "Building and pushing the Docker image..."
docker build . -t ghcr.io/\$github_username/\$application_name:latest && \
docker push ghcr.io/\$github_username/\$application_name:latest

if [[ \$? -eq 0 ]]; then
    echo "Docker image successfully pushed to GitHub Container Registry."
else
    echo "Failed to push Docker image to GitHub Container Registry."
    exit 1
fi

# Step 5: Cleanup
echo "Cleaning up temporary script..."
rm -- "\$0"
ssh "${vps_user}@${vps_ip}" "rm /tmp/store-docker-image-temp.sh"
echo "Cleanup complete. You may now close this terminal."
EOF

# Step 3: Add instructions for the user
echo "Temporary script created."
echo "To use it, download the script to your local computer and run it from your project root folder:"
echo
echo "scp ${vps_user}@${vps_ip}:/tmp/store-docker-image-temp.sh ./store-docker-image.sh"
echo
echo "Then run:"
echo "./store-docker-image.sh"
echo
echo "This action will build and push your Docker image to the GitHub Container Registry."
echo "Once the script finishes, it will delete itself from both the VPS and the local computer."
echo "You may now close this terminal window."
