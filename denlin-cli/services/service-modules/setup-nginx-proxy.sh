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

# Prompt for email if it's not set or invalid
if [[ -z "$user_email" || ! "$user_email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
    read -p "Enter your email address for SSL certificate notifications: " input_email
    user_email="${input_email:-$user_email}"

    # Update config file with the new email address
    echo "Updating configuration file..."
    sudo bash -c "cat > $CONF_FILE" <<EOF
user_email=$user_email
EOF
fi

# Step 1: Generate docker-compose.yml from the template
echo "Creating Docker Compose file from the template..."
mkdir -p "$TARGET_DIR"
cp "$DOCKER_COMPOSE_DIR" "$DOCKER_COMPOSE_FILE"

# Step 2: Replace the user email variable in the template
echo "Configuring Nginx Proxy with your email..."
sed -i "s/\${user_email}/$user_email/" "$DOCKER_COMPOSE_FILE"

# Step 3: Deploy the Docker Compose stack
echo "Deploying Docker Compose stack..."
docker-compose -f "$DOCKER_COMPOSE_FILE" up -d

echo "Nginx Proxy and Let's Encrypt setup complete."