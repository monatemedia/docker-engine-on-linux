#!/bin/bash

# Menu: Linux Commands
# Description: Set Up Automatic Server Login from the Local Computer

# Variables
SCRIPT_NAME="temp-ssh-setup.sh"
TMP_PATH="/tmp/$SCRIPT_NAME"
LOCAL_DEST="~/Desktop/$SCRIPT_NAME"

# Step 1: Collect User Information
read -p "Is this SSH setup for the currently logged-in user? (y/n): " current_user
if [[ "$current_user" == "y" ]]; then
    vps_user="$USER"
else
    read -p "Enter the username for SSH login: " vps_user
fi

vps_ip="127.0.0.1"
read -p "Enter the IP address of the VPS (default: $vps_ip): " entered_ip
vps_ip=${entered_ip:-$vps_ip}

# If VPS IP is localhost or 127.0.0.1, prompt for a valid external IP
if [[ "$vps_ip" == "localhost" || "$vps_ip" == "127.0.0.1" ]]; then
    echo "It seems like the VPS IP is set to localhost or 127.0.0.1."
    read -p "Please enter the actual IP address of your VPS: " vps_ip
fi

# Confirm or change information
echo "============================================"
echo "SSH setup details:"
echo "Username: $vps_user"
echo "VPS IP: $vps_ip"
echo "============================================"
read -p "Is this information correct? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
    echo "Please run the script again to provide the correct details."
    exit 1
fi

# Step 2: Create the second script in the /tmp folder
cat << EOF > "$TMP_PATH"
#!/bin/bash

# Ensure SSH key exists
if [ ! -f "\$HOME/.ssh/id_rsa" ]; then
    echo "No SSH key found. Generating a new SSH key pair..."
    ssh-keygen -t rsa -b 4096 -N "" -f "\$HOME/.ssh/id_rsa"
else
    echo "An existing SSH key was found. Proceeding..."
fi

# Copy the public key to the VPS
echo "Copying SSH public key to the VPS..."
ssh-copy-id -i "\$HOME/.ssh/id_rsa.pub" "$vps_user@$vps_ip"

if [ \$? -eq 0 ]; then
    echo "Public key successfully copied. Passwordless SSH login is now enabled!"
else
    echo "Failed to copy the public key. Please check your connection and try again."
fi

# Cleanup: Delete this script from the local machine and the VPS
echo "Cleaning up..."
rm -f "\$HOME/Desktop/$SCRIPT_NAME"
ssh "$vps_user@$vps_ip" "rm -f $TMP_PATH"
echo "Cleanup complete. This terminal will now close."
sleep 2
exit
EOF

chmod +x "$TMP_PATH"

# Step 3: Provide instructions to the user
echo "================================================================================"
echo "The second SSH setup script has been created and saved in the VPS temp folder: $TMP_PATH"
echo ""
echo "To proceed, follow these steps:"
echo ""
echo "1. Open a new terminal window from your desktop."
echo "2. Download the second script to your desktop using this command:"
echo "   scp $vps_user@$vps_ip:$TMP_PATH ~/Desktop/$SCRIPT_NAME"
echo ""
echo "3. Navigate to your desktop and run the second script using this command:"
echo "   bash ~/Desktop/$SCRIPT_NAME"
echo ""
echo "4. After completing the above steps, return to this terminal session."
echo ""
echo "Note: The second script will delete itself from both your desktop and the VPS after running."
echo "      Passwordless SSH login should now be enabled!"
echo "================================================================================"