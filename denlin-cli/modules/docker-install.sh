#!/bin/bash

# Menu: Docker Management
# Description: Install Docker with default options

# Docker Installation Script
# ============================

echo -e ""
echo -e "\nThis script will install Docker Engine on your Ubuntu system."
echo -e "Please read the following warnings carefully before proceeding:\n"
echo -e ""
echo -e "⚠️  Warnings:"
echo -e "- This script is intended as a convenient way to configure Docker's package repositories and install Docker Engine."
echo -e "- This script is NOT recommended for production environments."
echo -e "- It installs dependencies and recommendations without asking for confirmation."
echo -e "- It installs the latest stable release of Docker CLI, Docker Engine, Docker Buildx, Docker Compose, containerd, and runc."
echo -e "- It may result in unexpected major version upgrades of these packages."
echo -e "- Always test upgrades in a test environment before deploying to production systems."
echo -e "- For manual installation methods, refer to https://github.com/monatemedia/docker-engine-on-linux/.\n"

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

echo "Verifying Docker installation..."
sudo docker run hello-world

echo "Docker installation completed successfully."
