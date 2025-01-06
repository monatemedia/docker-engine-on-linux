#!/bin/bash

# Define constants
REPO_URL="https://github.com/monatemedia/docker-engine-on-linux.git"
TEMP_DIR="/tmp/denlin-update"
INSTALL_DIR="/usr/local/bin/denlin-cli"
SYMLINK_PATH="/usr/local/bin/denlin"

# Step 1: Inform User
echo
echo "=== Denlin Update Script ==="
echo "This script will update Denlin to the latest version from $REPO_URL."
echo "Temporary files will be stored in $TEMP_DIR."
echo

# Step 2: Clone Repository to Temporary Directory
echo "Cloning the repository to $TEMP_DIR..."
rm -rf "$TEMP_DIR" # Ensure a clean temp directory
git clone "$REPO_URL" "$TEMP_DIR" || {
    echo "Error: Failed to clone the repository. Check your network connection."
    exit 1
}
echo "Repository successfully cloned."
echo

# Step 3: Locate denlin-cli Directory
echo "Checking for 'denlin-cli' folder in the cloned repository..."
if [ ! -d "$TEMP_DIR/denlin-cli" ]; then
    echo "Error: 'denlin-cli' folder not found in the repository."
    exit 1
fi
echo "'denlin-cli' folder found."
echo

# Step 4: Copy Files to Installation Directory
echo "Updating files in $INSTALL_DIR..."
sudo rm -rf "$INSTALL_DIR" # Remove the old installation directory
sudo mkdir -p "$INSTALL_DIR"
sudo cp -r "$TEMP_DIR/denlin-cli/." "$INSTALL_DIR" || {
    echo "Error: Failed to update files in $INSTALL_DIR."
    exit 1
}
echo "Files successfully updated."
echo

# Step 5: Make Main Script Executable
echo "Making the main script executable..."
if [ -f "$INSTALL_DIR/denlin.sh" ]; then
    sudo chmod +x "$INSTALL_DIR/denlin.sh" || {
        echo "Error: Failed to make the main script executable."
        exit 1
    }
    echo "Main script is now executable."
else
    echo "Error: 'denlin.sh' not found in $INSTALL_DIR."
    exit 1
fi
echo

# Step 6: Create or Update the Global Symbolic Link
echo "Updating the global 'denlin' command..."
sudo ln -sf "$INSTALL_DIR/denlin.sh" "$SYMLINK_PATH" || {
    echo "Error: Failed to update the symbolic link."
    exit 1
}
echo "'denlin' command successfully updated."
echo

# Step 7: Test the Updated Installation
echo "Testing the updated installation..."
if command -v denlin &>/dev/null; then
    echo "'denlin' command is available globally."
else
    echo "Error: 'denlin' command is not available globally. Check your setup."
    exit 1
fi
echo

# Step 8: Cleanup Temporary Files
echo "Cleaning up temporary files..."
rm -rf "$TEMP_DIR" || {
    echo "Warning: Failed to remove temporary files. Please delete $TEMP_DIR manually."
}
echo "Temporary files removed."
echo

# Step 9: Completion
echo "=== Update Complete ==="
echo "Denlin has been successfully updated to the latest version."
echo "You can now use 'denlin' to run the updated tool."
echo
