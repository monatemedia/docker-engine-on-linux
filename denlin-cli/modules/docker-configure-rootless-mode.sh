#!/bin/bash

# Menu: Docker Management
# Description: Configure Docker Rootless Mode

set -e  # Exit on error

echo "Checking if systemd is installed..."
if ! command -v systemctl &>/dev/null; then
    echo "Systemd is NOT installed. Installing it now..."
    sudo apt-get update && sudo apt-get install -y systemd
else
    echo "Systemd is already installed."
fi

echo "Checking if systemd is running in user mode..."
if ! systemctl --user status &>/dev/null; then
    echo "Setting up environment variables..."
    export DBUS_SESSION_BUS_ADDRESS=$(dbus-launch --sh-syntax | grep DBUS_SESSION_BUS_ADDRESS | sed 's/DBUS_SESSION_BUS_ADDRESS=//')
    export XDG_RUNTIME_DIR=/run/user/$(id -u)
    
    echo "Enabling systemd user mode..."
    systemctl --user enable --now docker.service || echo "Failed to enable Docker user service."
fi

echo "Disabling system-wide Docker daemon..."
sudo systemctl disable --now docker.service docker.socket || echo "Docker daemon already disabled."

echo "Installing required dependencies..."
sudo apt-get update && sudo apt-get install -y docker-ce-rootless-extras rootlesskit slirp4netns

echo "Verifying Docker Rootless setup tools..."
if ! command -v dockerd-rootless-setuptool.sh &>/dev/null; then
    echo "dockerd-rootless-setuptool.sh not found. Installation might have failed."
    exit 1
fi
if ! command -v dockerd-rootless.sh &>/dev/null; then
    echo "dockerd-rootless.sh not found. Installation might have failed."
    exit 1
fi

echo "Installing Docker in Rootless Mode..."
dockerd-rootless-setuptool.sh install

echo "Configuring environment variables..."
export XDG_RUNTIME_DIR=/home/$USER/.docker/run
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR
export PATH=/usr/bin:/sbin:/usr/sbin:$PATH
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

echo "Starting Docker Rootless Daemon..."
dockerd-rootless.sh --experimental --debug &

sleep 5  # Give the daemon some time to start

echo "Verifying Docker Rootless Mode..."
if ! docker run hello-world; then
    echo "Failed to connect to Docker daemon. Try running: PATH=/usr/bin:/sbin:/usr/sbin:\$PATH dockerd-rootless.sh"
    exit 1
fi

echo "Docker Rootless Mode installed successfully!"
echo "You can now use Docker without root privileges."
