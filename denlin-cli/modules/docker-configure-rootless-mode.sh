#!/bin/bash

# Menu: Docker Management
# Description: Configure Docker Rootless Mode

# Docker Rootless Mode Script
# ============================


echo "Checking if systemd is installed..."
if ! command -v systemctl &> /dev/null; then
    echo "systemd is not installed. Installing now..."
    sudo apt-get update -y && sudo apt-get install -y systemd
else
    echo "systemd is installed."
fi

echo "🔍 Checking if systemd is running in user mode..."
if ! systemctl --user status &> /dev/null; then
    echo "Enabling systemd user mode..."
    systemctl --user start
    systemctl --user enable docker
else
    echo "systemd user mode is running."
fi

echo "Disabling system-wide Docker daemon..."
sudo systemctl disable --now docker.service docker.socket
sudo rm -f /var/run/docker.sock

echo "Installing required dependencies..."
sudo apt-get update -y
sudo apt-get install -y slirp4netns rootlesskit

echo "Configuring environment variables..."
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export PATH=/usr/bin:$PATH
export DOCKER_HOST=unix:///home/$USER/.docker/run/docker.sock
echo "export XDG_RUNTIME_DIR=/run/user/$(id -u)" >> ~/.bashrc
echo "export PATH=/usr/bin:$PATH" >> ~/.bashrc
echo "export DOCKER_HOST=unix:///home/$USER/.docker/run/docker.sock" >> ~/.bashrc
source ~/.bashrc

echo "Installing Docker in Rootless Mode..."
dockerd-rootless-setuptool.sh install

echo "Starting Docker Rootless Daemon..."
PATH=/usr/bin:/sbin:/usr/sbin:$PATH dockerd-rootless.sh --experimental --debug &

echo "Waiting for Docker to start..."
sleep 5

echo "Verifying Docker Rootless Mode..."
docker run hello-world

if [ $? -eq 0 ]; then
    echo "Docker Rootless Mode is successfully installed and running!"
else
    echo "Failed to start Docker Rootless Mode. Try running:"
    echo "   PATH=/usr/bin:/sbin:/usr/sbin:\$PATH dockerd-rootless.sh"
    exit 1
fi
