#!/bin/bash
# Menu: Denlin Management
# Description: Uninstalls Denlin

# Define constants
INSTALL_DIR="/usr/local/bin/denlin-cli"
SYMLINK_PATH="/usr/local/bin/denlin"

# Step 1: Confirmation Prompt
echo "=== Denlin Uninstallation Script ==="
read -p "Are you sure you want to completely uninstall Denlin? This action cannot be undone. (yes/no): " CONFIRMATION

if [[ "$CONFIRMATION" != "yes" ]]; then
    echo "Uninstallation cancelled. Denlin remains installed."
    exit 0
fi

# Step 2: Remove the Symbolic Link
echo "Removing the 'denlin' symbolic link..."
if [ -L "$SYMLINK_PATH" ]; then
    sudo rm "$SYMLINK_PATH" || {
        echo "Error: Failed to remove the symbolic link."
        exit 1
    }
    echo "'denlin' symbolic link removed."
else
    echo "Symbolic link not found. Skipping this step."
fi
echo

# Step 3: Remove the Denlin Folder
echo "Removing the Denlin installation directory..."
if [ -d "$INSTALL_DIR" ]; then
    sudo rm -rf "$INSTALL_DIR" || {
        echo "Error: Failed to remove the Denlin folder."
        exit 1
    }
    echo "Denlin installation directory removed."
else
    echo "Denlin directory not found. Skipping this step."
fi
echo

# Step 4: Final Message
echo "=== Uninstallation Complete ==="
echo "Denlin has been completely uninstalled from your system."
echo "If you wish to reinstall, you can do so by following the installation instructions."
echo
