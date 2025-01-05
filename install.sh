#!/bin/bash

# Define constants
TMP_SCRIPT_PATH="/tmp/denlin-installer.sh"
REPO_DIR=$(pwd)

# Inform User
echo
echo "=== Denlin Bootstrap Installation Script ==="
echo "This script will generate a new installation script in the /tmp directory."
echo

# Step 1: Generate the New Script
echo "Creating the new installation script at $TMP_SCRIPT_PATH..."
cat > $TMP_SCRIPT_PATH <<EOF
#!/bin/bash

# Define constants
INSTALL_DIR="/usr/local/bin/denlin-cli"
SYMLINK_PATH="/usr/local/bin/denlin"

echo
echo "=== Denlin Installer ==="
echo "Installing Denlin from repository at $REPO_DIR"
echo "Target installation directory: \$INSTALL_DIR"
echo

# Step 1: Copy Files to Installation Directory
echo "Copying files to \$INSTALL_DIR..."
sudo rm -rf "\$INSTALL_DIR" # Remove any previous installation
sudo mkdir -p "\$INSTALL_DIR"

# Ensure we copy the contents of the denlin-cli folder directly, not the folder itself
sudo cp -r "$REPO_DIR/denlin-cli/." "\$INSTALL_DIR" || {
    echo "Error: Failed to copy files to \$INSTALL_DIR."
    exit 1
}
echo "Files copied successfully."
echo

# Step 2: Make Main Script Executable
echo "Making the main script executable..."
sudo chmod +x "\$INSTALL_DIR/denlin.sh" || {
    echo "Error: Failed to make the main script executable."
    exit 1
}
echo "Main script is now executable."
echo

# Step 3: Create a Global Symbolic Link
echo "Creating the global 'denlin' command..."
sudo ln -sf "\$INSTALL_DIR/denlin.sh" "\$SYMLINK_PATH" || {
    echo "Error: Failed to create the symbolic link."
    exit 1
}
echo "'denlin' command successfully created."
echo

# Step 4: Test Installation
echo "Testing the symbolic link..."
if [ -x "\$(command -v denlin)" ]; then
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

# Step 6: Remove the installer script
echo "Removing the installer script..."
rm -f "$TMP_SCRIPT_PATH" || {
    echo "Warning: Failed to remove the installer script. Please delete it manually."
}

# Step 7: Return to the user's home directory safely
echo "Returning to your home directory..."
cd ~ 2>/dev/null || echo "Warning: Failed to return to the home directory. Please ensure you are in a valid directory."

echo "=== Installation Complete ==="
echo "You can now run 'denlin' to start using the tool."
EOF

# Step 2: Make the New Script Executable
chmod +x "$TMP_SCRIPT_PATH"
echo
echo "New installation script created and made executable."

# Step 3: Run the New Script
echo
echo "Running the new installation script..."
"$TMP_SCRIPT_PATH"
