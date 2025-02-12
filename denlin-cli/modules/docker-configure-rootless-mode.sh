#!/bin/bash

# Menu: Docker Management
# Description: Configure Docker Rootless Mode

# Docker Rootless Mode Script
# ============================

#!/bin/bash

set -e  # Exit on error

echo "Disabling system-wide Docker daemon..."
sudo systemctl disable --now docker.service docker.socket || echo "Docker daemon already disabled."
sudo rm -f /var/run/docker.sock

echo "Installing Docker in Rootless Mode..."
dockerd-rootless-setuptool.sh install

echo "Verifying Docker Rootless Mode..."
docker run hello-world

echo "Docker Rootless Mode installed successfully!"
