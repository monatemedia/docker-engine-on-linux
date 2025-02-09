#!/bin/bash

# Menu: Configure VPS
# Description: Create a shared proxy server and SSL certificate


# Variables
CONF_FILE="/etc/denlin-cli.conf"
DOCKER_COMPOSE_DIR="/usr/local/bin/denlin-cli/services/docker-compose/nginx-proxy.template.yml"
TARGET_DIR="$HOME/nginx-proxy"
DOCKER_COMPOSE_FILE="$TARGET_DIR/docker-compose.yml"

# Function to prompt user for email
prompt_email() {
    local email
    echo "Enter your email address (for SSL certificate notifications):"
    read -r email
    while [[ ! "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; do
        echo "Invalid email format. Please try again:"
        read -r email
    done
    echo "$email"
}

# Step 1: Check if email exists in CONF_FILE
if [ -f "$CONF_FILE" ]; then
    existing_email=$(grep '^user_email=' "$CONF_FILE" | cut -d '=' -f2)
    if [ -n "$existing_email" ]; then
        echo "Found existing email: $existing_email"
        read -p "Do you want to use this email? (y/n): " choice
        if [[ "$choice" =~ ^[Nn]$ ]]; then
            user_email=$(prompt_email)
            sudo sed -i "s|^user_email=.*|user_email=$user_email|" "$CONF_FILE"
        else
            user_email="$existing_email"
        fi
    else
        user_email=$(prompt_email)
        echo "user_email=$user_email" | sudo tee -a "$CONF_FILE" > /dev/null
    fi
else
    echo "Config file not found. Creating one..."
    sudo touch "$CONF_FILE"
    user_email=$(prompt_email)
    echo "user_email=$user_email" | sudo tee "$CONF_FILE" > /dev/null
fi

echo "Using email: $user_email"

# Step 2: Create nginx-proxy directory structure
echo "Creating necessary directories in $TARGET_DIR..."
mkdir -p "$TARGET_DIR/nginx/html" "$TARGET_DIR/nginx/certs" "$TARGET_DIR/nginx/vhost" "$TARGET_DIR/nginx/acme"

# Step 3: Generate docker-compose.yml from template
if [ -f "$DOCKER_COMPOSE_DIR" ]; then
    echo "Generating docker-compose.yml..."
    sed "s|\${user_email}|$user_email|g" "$DOCKER_COMPOSE_DIR" > "$DOCKER_COMPOSE_FILE"
    echo "docker-compose.yml created successfully."
else
    echo "Error: Template file not found at $DOCKER_COMPOSE_DIR"
    exit 1
fi

# Step 4: Start Docker services
cd "$TARGET_DIR" || { echo "Failed to enter directory."; exit 1; }
echo "Starting Docker services with 'docker compose up -d'..."
docker compose up -d

if [ $? -eq 0 ]; then
    echo "Proxy setup completed successfully! Your shared proxy is now running."
else
    echo "Failed to start Docker services. Please check the configuration and try again."
    exit 1
fi

echo "Setup is complete."
