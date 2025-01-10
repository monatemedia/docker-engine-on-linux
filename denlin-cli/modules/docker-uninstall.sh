#!/bin/bash

# Menu: Docker Management
# Description: Uninstall Docker and all Docker related data including containers

# Docker Uninstallation Script
# ============================

echo -e "\nThis script will uninstall Docker Engine, CLI, containerd, and Docker Compose packages from your system."
echo -e "It will also remove all images, containers, and volumes if you choose to proceed.\n"
echo -e "⚠️ Warning: This operation is irreversible and will permanently delete Docker-related data from your system.\n"
echo

# Confirm uninstallation
read -p "Are you sure you want to uninstall Docker and delete all related data? (yes/no): " confirmation
if [[ "$confirmation" != "yes" ]]; then
    echo -e "\nOperation canceled. Docker has not been uninstalled.\n"
    exit 0
fi

echo -e ""
echo -e "\nStarting the uninstallation process...\n"
echo -e ""

# Step 1: Uninstall Docker packages
echo -e "Step 1: Removing Docker Engine, CLI, containerd, and related packages...\n"
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
if [[ $? -eq 0 ]]; then
    echo -e "Docker packages have been removed successfully.\n"
else
    echo -e "Error: Failed to remove Docker packages.\n"
    exit 1
fi
echo -e ""

# Step 2: Remove all Docker images, containers, and volumes
echo -e "Step 2: Removing all Docker images, containers, and volumes...\n"
sudo rm -rf /var/lib/docker /var/lib/containerd
if [[ $? -eq 0 ]]; then
    echo -e "All Docker-related data has been removed successfully.\n"
else
    echo -e "Error: Failed to remove Docker data.\n"
    exit 1
fi
echo -e ""

# Step 3: Remove Docker source list and keyrings
echo -e "Step 3: Removing Docker source list and keyrings...\n"
sudo rm -f /etc/apt/sources.list.d/docker.list /etc/apt/keyrings/docker.asc
if [[ $? -eq 0 ]]; then
    echo -e "Docker source list and keyrings have been removed successfully.\n"
else
    echo -e "Error: Failed to remove Docker source list and keyrings.\n"
    exit 1
fi
echo -e ""

# Step 4: Remove unused packages
echo -e "Step 4: Removing unused packages...\n"
sudo apt autoremove -y
if [[ $? -eq 0 ]]; then
    echo -e "Unused packages have been removed successfully.\n"
else
    echo -e "Error: Failed to remove unused packages.\n"
    exit 1
fi

# Final message
echo -e "Docker has been uninstalled successfully from your system.\n"
echo -e "Please note: Any manually edited configuration files must be deleted manually if required.\n"
echo -e ""
