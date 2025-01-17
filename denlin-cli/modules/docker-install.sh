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
echo -e "- For manual installation methods, refer to https://docs.docker.com/engine/install/.\n"

# Confirm installation
read -p "Do you want to proceed with the installation of Docker? (yes/no): " confirmation
if [[ "$confirmation" != "yes" ]]; then
    echo -e "\nOperation canceled. Docker has not been installed.\n"
    exit 0
fi

echo -e "\nStarting Docker installation...\n"

# Step 1: Uninstall old versions of Docker
echo -e "Step 1: Removing any old versions of Docker...\n"
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    sudo apt-get remove -y $pkg
done
echo -e "Old versions of Docker (if any) have been removed.\n"
echo -e ""

# Step 2: Download and run the Docker installation script
echo -e "Step 2: Downloading and running the Docker installation script...\n"
curl -fsSL https://get.docker.com -o get-docker.sh
if [[ $? -ne 0 ]]; then
    echo -e "Error: Failed to download the Docker installation script.\n"
    exit 1
fi
echo -e ""

echo -e "Running the installation script...\n"
sh get-docker.sh
if [[ $? -ne 0 ]]; then
    echo -e "Error: Docker installation script failed.\n"
    rm -f get-docker.sh
    exit 1
fi
rm -f get-docker.sh
echo -e "Docker has been installed successfully.\n"
echo -e ""

# Step 3: Verify Docker installation
echo -e "Step 3: Verifying Docker installation...\n"
sudo docker --version
if [[ $? -ne 0 ]]; then
    echo -e "Error: Docker is not installed or not functioning correctly.\n"
    exit 1
fi
echo -e ""

# Step 4: Prompt for rootless mode setup
read -p "Do you want to configure Docker in rootless mode for non-root users? (yes/no): " rootless_confirmation
if [[ "$rootless_confirmation" == "yes" ]]; then
    echo -e "\nSetting up Docker in rootless mode...\n"

    # Check if the required package is installed
    if ! dpkg -s uidmap > /dev/null 2>&1; then
        echo -e "Installing required package 'uidmap'...\n"
        sudo apt-get update && sudo apt-get install -y uidmap
        if [[ $? -ne 0 ]]; then
            echo -e "Error: Failed to install 'uidmap'.\n"
            exit 1
        fi
    fi

    # Run rootless setup tool
    if dockerd-rootless-setuptool.sh install; then
        echo -e "\nDocker rootless mode has been configured successfully."
    else
        echo -e "Rootless setup failed. Trying with '--force'...\n"
        if dockerd-rootless-setuptool.sh install --force; then
            echo -e "\nDocker rootless mode has been configured successfully with '--force'."
        else
            echo -e "Error: Docker rootless setup failed. Please check the system requirements or visit https://docs.docker.com/go/rootless/.\n"
            exit 1
        fi
    fi
else
    echo -e "\nSkipping Docker rootless mode configuration.\n"
fi

# Final message
echo -e "Docker has been installed successfully on your system."
echo -e "You can start using Docker. For more details, visit https://docs.docker.com/.\n"
echo -e ""