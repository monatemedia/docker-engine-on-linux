#!/bin/bash

# Menu: Docker Management
# Description: Install Docker with default options

# Docker Installation Script
# ============================

echo -e "\nThis script will install Docker Engine on your Ubuntu system."
echo -e "Please read the following warnings carefully before proceeding:\n"

echo -e "Warnings:"
echo -e "- This script installs Docker and its dependencies without confirmation."
echo -e "- It installs the latest stable release of Docker CLI, Engine, Buildx, Compose, containerd, and runc."
echo -e "- Major version upgrades may occur, so test in a non-production environment first."
echo -e "- Manual installation methods are available at: https://github.com/monatemedia/docker-engine-on-linux/\n"

# Confirm installation
read -p "Do you want to proceed with the installation of Docker? (yes/no): " confirmation
if [[ "$confirmation" != "yes" ]]; then
    echo -e "\nOperation canceled. Docker has not been installed.\n"
    exit 0
fi

# Uninstall old versions
echo "Removing old Docker versions..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do 
    sudo apt-get remove -y $pkg 
done

# Run Package Updates
echo "Updating package list..."
sudo apt-get update

echo "Installing required dependencies..."
sudo apt-get install -y ca-certificates curl

echo "Adding Docker's official GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "Adding Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating package list after adding Docker repository..."
sudo apt-get update

echo "Installing Docker Engine and related packages..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Adding current user to Docker group..."
sudo usermod -aG docker $USER

echo "Attempting to refresh group membership in the current session..."
newgrp docker <<EOF
    echo "Verifying Docker installation..."
    if ! docker run hello-world; then
        echo "Failed to connect to Docker daemon."
        echo "Possible solutions:"
        echo "- Log out and log back in, or restart your computer."
        echo "- Check that the Docker service is running with: sudo systemctl status docker"
        echo "- Ensure your user is in the 'docker' group with: groups $USER"
        exit 1
    fi
    echo -e "\nDocker installation completed successfully."
    echo "You can now use Docker without root privileges."
EOF

echo -e "\nDocker installation completed successfully."    
echo "\nThis terminal will still need a logout/relogin or reboot for other commands (outside this script) to recognize your new group membership."

