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

echo "Starting Docker Rootless Daemon..."
PATH=/usr/bin:/sbin:/usr/sbin:$PATH dockerd-rootless.sh &

sleep 5  # Give the daemon some time to start

echo "Verifying Docker Rootless Mode..."
docker run hello-world || echo "Failed to connect to Docker daemon. Try running: PATH=/usr/bin:/sbin:/usr/sbin:\$PATH dockerd-rootless.sh"

echo "Docker Rootless Mode installed successfully!"

