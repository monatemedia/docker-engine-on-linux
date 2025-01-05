#!/bin/bash

# Define Constants
REPO_URL="https://github.com/monatemedia/docker-engine-on-linux.git"
TEMP_DIR="/tmp/denlin-update"
INSTALL_DIR="/usr/local/bin/denlin-cli"
SYMLINK_PATH="/usr/local/bin/denlin"

# Step 1: Inform User About the Update
echo
echo "=== Denlin Update Script ==="
echo "This script will update Denlin to the latest version from $REPO_URL."
echo "Temporary files will be stored in $TEMP_DIR."
echo "Starting update process..."
echo

# Step 2: Clone the Repository to a Temporary Directory
echo "Cloning the repository to $TEMP_DIR..."
rm -rf "$TEMP_DIR" # Ensure the temp directory is clean
git clone "$REPO_URL" "$TEMP_DIR" || {
    echo "Failed to clone the repository. Check your network connection."
    exit 1
}
echo "Repository successfully cloned."
echo

# Step 3: Copy Files to the Installation Directory
echo "Installing files to $INSTALL_DIR..."
sudo rm -rf "$INSTALL_DIR" # Remove the old installation directory
sudo cp -r "$TEMP_DIR/denlin-cli" "$INSTALL_DIR" || {
    echo "Failed to copy files to $INSTALL_DIR."
    exit 1
}
echo "Files successfully installed."
echo

# Step 4: Verify the Installation Directory
echo "Verifying files in $INSTALL_DIR..."
ls -l "$INSTALL_DIR/" || {
    echo "Verification failed. Ensure $INSTALL_DIR exists and contains the correct files."
    exit 1
}
echo

# Step 5: Make the Main Script Executable
echo "Making the main script executable..."
sudo chmod +x "$INSTALL_DIR/denlin.sh" || {
    echo "Failed to make the main script executable."
    exit 1
}
echo "Main script is now executable."
echo

# Step 6: Create or Update the Symlink
echo "Creating or updating the global 'denlin' command..."
sudo ln -sf "$INSTALL_DIR/denlin.sh" "$SYMLINK_PATH" || {
    echo "Failed to create the symbolic link."
    exit 1
}
echo "'denlin' command successfully created/updated."
echo

# Step 7: Clean Up Temporary Files
echo "Cleaning up temporary files..."
rm -rf "$TEMP_DIR" || {
    echo "Failed to clean up temporary files."
    exit 1
}
echo "Temporary files successfully removed."
echo

# Step 8: Installation Complete
echo "Denlin has been updated to the latest version!"
echo "=== Update Completed ==="
echo

# Step 9: Test Denlin Installation
echo "Testing the updated Denlin installation..."
echo
denlin