#!/bin/bash

# Menu: Configure VPS
# Description: A script to deploy a Hello World container with Nginx Proxy and Let's Encrypt.

CONF_FILE="/etc/denlin-cli.conf"
DOCKER_COMPOSE_DIR="/usr/local/bin/denlin-cli/services/docker-compose/hello-world.template.yml"
TARGET_DIR="$HOME/nginx-proxy"
DOCKER_COMPOSE_FILE="$TARGET_DIR/docker-compose.yml"

# Ensure the config file exists
echo "Checking configuration file at $CONF_FILE..."
if [[ ! -f "$CONF_FILE" ]]; then
    echo "$CONF_FILE does not exist. Creating it now."
    sudo bash -c "cat > $CONF_FILE" <<EOF
domain_name=
vps_ip=
EOF
fi

# Source configuration file
source "$CONF_FILE"

# Step 1: Get service name
read -p "Enter the desired service name: " service_name

# Step 2: Confirm or update domain name
if [[ -n "$domain_name" ]]; then
    read -p "The current domain name in the config file is: $domain_name. Do you want to use this domain name? (y/n): " confirm_domain_name
    if [[ "$confirm_domain_name" != "y" ]]; then
        read -p "Enter a new domain name: " input_domain_name
        domain_name="$input_domain_name"
    fi
else
    read -p "Enter your domain name: " domain_name
fi

# Remove protocol (http:// or https://) and trailing slash
domain_name=$(echo "$domain_name" | sed -E 's~^(https?://)~~' | sed -E 's~/$~~')

# Extract only the root domain and extension
domain_name=$(echo "$domain_name" | sed -E 's~^([a-zA-Z0-9-]+\.)*([a-zA-Z0-9-]+\.[a-zA-Z]{2,})/??.*$~\2~')

# Validate domain format
if [[ ! "$domain_name" =~ ^[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "Error: Invalid domain format. Please enter a valid domain name."
    exit 1
fi

# Step 3: Ask if it's a main domain or subdomain
while true; do
    read -p "Is this container mapped as a main domain (e.g., monatemedia.com) or a subdomain (e.g., hello-world.monatemedia.com)? Enter 'main' or 'sub': " domain_type

    if [[ "$domain_type" == "main" || "$domain_type" == "sub" ]]; then
        break
    else
        echo -e "\nInvalid choice! Please enter 'main' for a root domain (e.g., monatemedia.com) or 'sub' for a subdomain (e.g., hello-world.monatemedia.com). Try again.\n"
    fi
done

# Step 4: Confirm or update VPS IP
if [[ -n "$vps_ip" ]]; then
    read -p "The current VPS IP in the config file is: $vps_ip. Do you want to use this IP? (y/n): " confirm_vps_ip
    if [[ "$confirm_vps_ip" != "y" ]]; then
        read -p "Enter your VPS IP address: " input_vps_ip
        vps_ip="$input_vps_ip"
    fi
else
    read -p "Enter your VPS IP address: " vps_ip
fi

# Output final domain and VPS IP
echo "Final Domain Name: $domain_name"
echo "VPS IP Address: $vps_ip"

# Step 5: Update config file
echo "Updating configuration file..."
sudo bash -c "cat > $CONF_FILE" <<EOF
domain_name=$domain_name
vps_ip=$vps_ip
EOF

# Step 6: Create Docker Compose file from the template
echo "Creating Docker Compose file from the template..."
mkdir -p "$TARGET_DIR"
cp "$DOCKER_COMPOSE_DIR" "$DOCKER_COMPOSE_FILE"

# Step 7: Replace placeholders in the template
sed -i "s/\${service_name}/$service_name/" "$DOCKER_COMPOSE_FILE"
sed -i "s/\${domain_name}/$domain_name/" "$DOCKER_COMPOSE_FILE"

# Step 8: Deploy the Docker Compose stack
echo "Deploying Docker Compose stack..."
docker compose -f "$DOCKER_COMPOSE_FILE" up -d

echo "Setup complete: $domain_name (Service: $service_name) is now running."

# Step 9: Display DNS Instructions
echo -e "\n${domain_name} needs an A record. Add the following DNS entry:\n"

# Print Table Header
printf "%-10s | %-30s | %-15s | %-5s \n" "Type" "Name" "Points to" "TTL"
printf "%-10s | %-30s | %-15s | %-5s \n" "----------" "------------------------------" "---------------" "-----"

# Print Table Row
if [[ -n "$vps_ip" ]]; then
    printf "%-10s | %-30s | %-15s | %-5s \n" "A" "$domain_name" "$vps_ip" "14400"
else
    printf "%-10s | %-30s | %-15s | %-5s \n" "A" "$domain_name" "-" "14400"
fi

echo -e "\nPlease update your DNS settings accordingly."
