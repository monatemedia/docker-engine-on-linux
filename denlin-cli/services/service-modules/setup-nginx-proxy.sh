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
    while true; do
        # Prompt user for the email address only, no additional text on the same line
        echo "Enter your email address (for SSL certificate notifications):"
        read -r email
        # Validate the email format using regex
        if [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
            break
        else
            echo "Invalid email format. Please try again."
        fi
    done
    # Return the clean email address
    echo "$email"
}

# Step 1: Check if email exists in CONF_FILE
if [ -f "$CONF_FILE" ]; then
    existing_email=$(grep '^user_email=' "$CONF_FILE" | cut -d '=' -f2)
    if [ -n "$existing_email" ]; then
        echo "Found existing email: $existing_email"
        echo -n "Do you want to use this email: $existing_email? (y/n): "
        read choice
        if [[ "$choice" =~ ^[Nn]$ ]]; then
            # Ask for a new email address and sanitize it
            user_email=$(prompt_email)
            echo "DEBUG: New user_email captured: '$user_email'"
            # Check if the email is clean
            if [[ "$user_email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
                # Update the email correctly in the config file
                sudo sed -i "s|^user_email=.*|user_email=$user_email|" "$CONF_FILE"
            else
                echo "Error: Invalid email format."
                exit 1
            fi
        else
            user_email="$existing_email"
        fi
    else
        echo "No email found in the config file. Please enter your email."
        user_email=$(prompt_email)  # Get new email
        echo "DEBUG: New user_email captured: '$user_email'"
        # Check if the email is clean
        if [[ "$user_email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
            # Write the email correctly into the config file
            echo "user_email=$user_email" | sudo tee -a "$CONF_FILE" > /dev/null
        else
            echo "Error: Invalid email format."
            exit 1
        fi
    fi
else
    echo "Config file not found. Creating one..."
    sudo touch "$CONF_FILE"
    echo "No email in the config file. Please enter your email."
    user_email=$(prompt_email)  # Ask for email
    echo "DEBUG: New user_email captured: '$user_email'"
    # Check if the email is clean
    if [[ "$user_email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        # Write the email correctly into the config file
        echo "user_email=$user_email" | sudo tee "$CONF_FILE" > /dev/null
    else
        echo "Error: Invalid email format."
        exit 1
    fi
fi

# Step 2: Create nginx-proxy directory structure
echo "Creating necessary directories in $TARGET_DIR..."
mkdir -p "$TARGET_DIR/html" "$TARGET_DIR/certs" "$TARGET_DIR/vhost" "$TARGET_DIR/acme"

# Step 3: Generate docker-compose.yml from template
if [ -f "$DOCKER_COMPOSE_DIR" ]; then
    echo "Generating docker-compose.yml..."
    # Use a safer delimiter (|) for the sed command to avoid issues with @ in email
    # Ensure only email address is inserted, no extra text
    sed "s|\${user_email}|$user_email|g" "$DOCKER_COMPOSE_DIR" > "$DOCKER_COMPOSE_FILE"
    if [ $? -eq 0 ]; then
        echo "docker-compose.yml created successfully."
    else
        echo "Error: Failed to generate docker-compose.yml"
        exit 1
    fi
else
    echo "Error: Template file not found at $DOCKER_COMPOSE_DIR"
    exit 1
fi

# Step 4: Ensure Docker daemon is running
echo "Checking if Docker daemon is running..."
if ! systemctl is-active --quiet docker; then
    echo "Docker daemon is not running. Starting it now..."
    sudo systemctl start docker
    if [ $? -ne 0 ]; then
        echo "Failed to start Docker daemon. Exiting."
        exit 1
    fi
else
    echo "Docker daemon is already running."
fi

# Step 5: Start Docker services
cd "$TARGET_DIR" || { echo "Failed to enter directory."; exit 1; }
echo "Starting Docker services..."
docker compose up -d
