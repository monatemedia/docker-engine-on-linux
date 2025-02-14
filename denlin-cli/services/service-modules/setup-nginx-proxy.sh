#!/bin/bash

# Menu: Configure VPS
# Description: Create a shared proxy server and SSL certificate

CONF_FILE="/etc/denlin-cli.conf"
DOCKER_COMPOSE_DIR="/usr/local/bin/denlin-cli/services/docker-compose/nginx-proxy.template.yml"
TARGET_DIR="$HOME/nginx-proxy"
DOCKER_COMPOSE_FILE="$TARGET_DIR/docker-compose.yml"

# Ensure the config file exists
echo "Checking configuration file at $CONF_FILE..."
if [[ ! -f "$CONF_FILE" ]]; then
    echo "$CONF_FILE does not exist. Creating it now."
    sudo bash -c "cat > $CONF_FILE" <<EOF
user_email=
EOF
fi

# Source configuration file
source "$CONF_FILE"

# Prompt user to confirm or update email
if [[ -n "$user_email" ]]; then
    read -p "The current email in the config file is: $user_email. Do you want to use this email? (y/n): " confirm_email
    if [[ "$confirm_email" != "y" ]]; then
        read -p "Enter a new email address for SSL certificate notifications: " input_email
        user_email="$input_email"
    fi
else
    read -p "Enter your email address for SSL certificate notifications: " user_email
fi

# Validate the email format
if [[ ! "$user_email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
    echo "Error: Invalid email format. Please enter a valid email."
    exit 1
fi

# Update config file if a new email was entered
echo "Updating configuration file..."
sudo bash -c "cat > $CONF_FILE" <<EOF
user_email=$user_email
EOF


# Step 1: Generate docker-compose.yml from the template
echo "\nCreating Docker Compose file from the template..."
mkdir -p "$TARGET_DIR"
cp "$DOCKER_COMPOSE_DIR" "$DOCKER_COMPOSE_FILE"

# Step 2: Replace the user email variable in the template
echo "\nConfiguring Nginx Proxy with your email..."
sed -i "s/\${user_email}/$user_email/" "$DOCKER_COMPOSE_FILE"

# Step 3: Deploy the Docker Compose stack
echo "\nDeploying Docker Compose stack..."

# Step 4: Create a network for the proxy
echo "\nCreating proxy network..."
docker network create proxy-network

# Step 5: Start the Nginx Proxy and Let's Encrypt containers
echo "\nStarting Nginx Proxy and Let's Encrypt containers..."
docker compose -f "$DOCKER_COMPOSE_FILE" up -d

echo "Nginx Proxy and Let's Encrypt setup complete."