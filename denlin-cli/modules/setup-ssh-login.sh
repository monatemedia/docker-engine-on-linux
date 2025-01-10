#!/bin/bash

# Set up desktop path
DESKTOP_PATH="$HOME/Desktop"
SECONDARY_SCRIPT="$DESKTOP_PATH/setup-ssh-login.sh"

echo "================================================================================"
echo "This script will prepare an additional script for setting up SSH login on your VPS."
echo "The setup script will be saved to your desktop, and you'll be given instructions to run it."
echo "================================================================================"

# Create the secondary script
cat << 'EOF' > "$SECONDARY_SCRIPT"
#!/bin/bash

echo "================================================================================"
echo "This script will:"
echo "- Generate an SSH key pair on your local computer (if one doesn't already exist)."
echo "- Send the public key to your VPS to enable passwordless SSH login."
echo "================================================================================"

# Check if SSH key already exists
if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo "No SSH key pair found. Generating a new one..."
    ssh-keygen -t rsa -b 4096 -N "" -f "$HOME/.ssh/id_rsa"
    echo "SSH key pair generated."
else
    echo "An SSH key pair already exists at $HOME/.ssh/id_rsa. Using the existing key."
fi

# Get VPS details
read -p "Enter the username for the VPS (e.g., max): " vps_user
read -p "Enter the IP address of the VPS: " vps_ip

# Copy the public key to the VPS
echo "Sending your public SSH key to the VPS..."
ssh-copy-id -i "$HOME/.ssh/id_rsa.pub" "$vps_user@$vps_ip"

if [ $? -eq 0 ]; then
    echo "================================================================================"
    echo "Public key successfully copied to the VPS!"
    echo "You can now log in to the VPS using the following command:"
    echo "  ssh $vps_user@$vps_ip"
    echo "Password authentication is no longer required."
    echo "================================================================================"
else
    echo "Failed to copy the public key to the VPS. Please check your connection and try again."
fi
EOF

# Make the secondary script executable
chmod +x "$SECONDARY_SCRIPT"

echo "================================================================================"
echo "The SSH setup script has been saved to your desktop as 'setup-ssh-login.sh'."
echo "To complete the setup:"
echo "1. Open a terminal."
echo "2. Run the following command:"
echo "   bash ~/Desktop/setup-ssh-login.sh"
echo "================================================================================"
