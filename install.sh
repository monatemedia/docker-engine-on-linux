#!/bin/bash

# Define constants
INSTALL_DIR="/usr/local/bin/denlin-cli"
SYMLINK_PATH="/usr/local/bin/denlin"
REPO_DIR=$(pwd)

# Inform User
echo
echo "=== Denlin Bootstrap Installation Script ==="
echo "We are installing the Denlin CLI tool on your system."
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

# Step 3: Make all module scripts executable
echo "Making all module scripts executable..."
sudo find "$INSTALL_DIR/modules" -type f -name "*.sh" -exec chmod +x {} \;
echo "Module scripts are now executable."
echo

# Step 4: Create a Global Symbolic Link
echo "Creating the global 'denlin' command..."
sudo ln -sf "$INSTALL_DIR/denlin.sh" "$SYMLINK_PATH" || {
    echo "Error: Failed to create the symbolic link."
    exit 1
}
echo "'denlin' command successfully created."
echo

# Step 5: Test Installation
echo "Testing the symbolic link..."
if [ -x "$(command -v denlin)" ]; then
    echo "'denlin' command is available globally."
else
    echo "Error: 'denlin' command is not available globally. Check your setup."
    exit 1
fi
echo

# Step 6: Cleanup
echo "Cleaning up installation files..."
cd ~ || exit 1  # Switch directory *before* deleting
sudo rm -rf "$REPO_DIR" || {
    echo "Warning: Failed to remove the repository directory. Please delete it manually."
}
echo "Installation files cleaned up."
echo

# Final Check: Ensure the current working directory is valid
echo "Ensuring the current working directory is valid..."
echo
cd ~ || exit 1

# Step 7: Completion
echo "=== Installation Complete ==="
echo
echo "The Denlin CLI tool has been successfully installed."
echo "You can run 'denlin' command to use the tool."
echo
echo "🚀 Happy scripting!"
echo
