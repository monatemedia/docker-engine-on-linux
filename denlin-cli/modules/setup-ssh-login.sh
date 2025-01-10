#!/bin/bash

# Menu: Linux Commands
# Description: Set Up Automatic Server Login from the Local Computer

# File details
SCRIPT_NAME="setup-ssh-login.sh"
SCRIPT_PATH="$HOME/$SCRIPT_NAME"

# Create the SSH setup script
cat << 'EOF' > "$SCRIPT_PATH"
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

# Make the script executable
chmod +x "$SCRIPT_PATH"

# Get the local user's IP (if possible) for SCP instructions
CLIENT_IP=$(echo $SSH_CLIENT | awk '{print $1}')

echo "================================================================================"
echo "The SSH setup script has been created at: $SCRIPT_PATH"
echo ""
echo "To download it to your local machine, run the following SCP command in your terminal:"
echo ""
if [ -n "$CLIENT_IP" ]; then
    echo "  scp $USER@$(hostname -I | awk '{print $1}'):$SCRIPT_PATH ~/Desktop/$SCRIPT_NAME"
else
    echo "  scp $USER@<your-vps-ip>:$SCRIPT_PATH ~/Desktop/$SCRIPT_NAME"
fi
echo ""
echo "Replace '<your-vps-ip>' with the IP address of your VPS if necessary."
echo ""
echo "After downloading, navigate to your Desktop and run the following command:"
echo "  bash ~/Desktop/$SCRIPT_NAME"
echo "================================================================================"