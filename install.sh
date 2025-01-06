#!/bin/bash

# Define constants
INSTALL_DIR="/usr/local/bin/denlin-cli"
SYMLINK_PATH="/usr/local/bin/denlin"
REPO_DIR=$(pwd)

# Inform User
echo
echo "=== Denlin Bootstrap Installation Script ==="
echo "This script will install Denlin without creating a second script."
echo

# Step 1: Copy Files to Installation Directory
echo "Copying files to $INSTALL_DIR..."
sudo rm -rf "$INSTALL_DIR" # Remove any previous installation
sudo mkdir -p "$INSTALL_DIR"

# Ensure we copy the contents of the denlin-cli folder directly, not the folder itself
sudo cp -r "$REPO_DIR/denlin-cli/." "$INSTALL_DIR" || {
    echo "Error: Failed to copy files to $INSTALL_DIR."
    exit 1
}
echo "Files copied successfully."
echo

# Step 2: Make Main Script Executable
echo "Making the main script executable..."
sudo chmod +x "$INSTALL_DIR/denlin.sh" || {
    echo "Error: Failed to make the main script executable."
    exit 1
}
echo "Main script is now executable."
echo

# Step 3: Create a Global Symbolic Link
echo "Creating the global 'denlin' command..."
sudo ln -sf "$INSTALL_DIR/denlin.sh" "$SYMLINK_PATH" || {
    echo "Error: Failed to create the symbolic link."
    exit 1
}
echo "'denlin' command successfully created."
echo

# Step 4: Test Installation
echo "Testing the symbolic link..."
if [ -x "$(command -v denlin)" ]; then
    echo "'denlin' command is available globally."
else
    echo "Error: 'denlin' command is not available globally. Check your setup."
    exit 1
fi
echo

# Step 5: Cleanup
echo "Cleaning up installation files..."
sudo rm -rf "$REPO_DIR" || {
    echo "Warning: Failed to remove the repository directory. Please delete it manually."
}

# Final Check: Ensure the current working directory is valid
echo "Ensuring the current working directory is valid..."
echo
cd ~ || exit 1

# Step 6: Completion
echo "=== Installation Complete ==="
echo "You can now run 'denlin' to start using the tool."
echo
