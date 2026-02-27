#!/bin/bash

# Menu: Linux Commands
# Description: Create a new linux user with write permissions

echo "================================================================================"
echo "This script will:"
echo "- Create a new user"
echo "- Grant the new user admin rights"
echo "- Add the new user to the docker group"
echo "- Close the terminal session afterward"
echo "You must log in with the new user and password after this process."
echo "================================================================================"

# Prompt for new username
read -p "Enter the username for the new user: " new_user
read -sp "Enter the password for the new user (must be at least 12 characters): " new_password
echo ""

# Add the new user
adduser --disabled-password --gecos "" "$new_user"
echo "$new_user:$new_password" | chpasswd

# Grant admin rights
usermod -aG sudo "$new_user"

# Add to docker group
if getent group docker > /dev/null 2>&1; then
    usermod -aG docker "$new_user"
    echo "User '$new_user' added to the docker group."
else
    echo "Warning: docker group does not exist yet. Run this after installing Docker:"
    echo "  sudo usermod -aG docker $new_user"
fi

echo "User '$new_user' created and granted admin rights."

# Exit session
echo "You can now exit this terminal session and log in as '$new_user'."
exit