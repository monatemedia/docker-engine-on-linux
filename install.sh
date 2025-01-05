#!/bin/bash

# Define constants
INSTALL_DIR="/usr/local/bin/denlin-cli"
SYMLINK_PATH="/usr/local/bin/denlin"
REPO_DIR=$(pwd)

# Step 1: Inform User
echo "=== Denlin First-Time Installation Script ==="
echo "This script will install Denlin on your system."
echo "Temporary installation path: $REPO_DIR"
echo "Installation directory: $INSTALL_DIR"
echo

# Step 2: Copy Files to Installation Directory
echo "Installing Denlin to $INSTALL_DIR..."
sudo rm -rf "$INSTALL_DIR" # Remove any previous installation
sudo cp -r "$REPO_DIR/denlin-cli" "$INSTALL_DIR" || {
    echo "Error: Failed to copy files to $INSTALL_DIR."
    exit 1
}
echo "Installation directory updated."
echo

# Step 3: Make the Main Script Executable
echo "Making the main script executable..."
sudo chmod +x "$INSTALL_DIR/denlin.sh" || {
    echo "Error: Failed to make the main script executable."
    exit 1
}
echo "Main script is now executable."
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

# Change directory to the user's home to avoid errors
cd ~ || exit

# Step 6: Leave User Instructions
echo "=== Installation Complete ==="
echo "Denlin has been successfully installed."
echo "Run the following command to get started:"
echo
echo "    denlin"
echo

# Step 7: Self-Cleanup
echo "Cleaning up installation files..."
rm -rf "$REPO_DIR" || {
    echo "Error: Failed to remove the repository directory."
    exit 1
}

# Remove this script itself
SCRIPT_PATH="$REPO_DIR/install.sh"
if [ -f "$SCRIPT_PATH" ]; then
    echo "Removing install.sh script..."
    rm -- "$SCRIPT_PATH" || {
        echo "Warning: Failed to remove install.sh. Please delete it manually."
    }
fi

echo "Cleanup complete."
echo "You can now run 'denlin' to start using the tool."
