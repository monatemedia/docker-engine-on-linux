#!/bin/bash

# Menu: Configure VPS
# Description: A script to deploy a Node Docker Compose container from a template.

CONF_FILE="/etc/denlin-cli.conf"
DOCKER_COMPOSE_TEMPLATE="/usr/local/bin/denlin-cli/services/docker-compose/node.template.yml"

# Ensure the config file exists
echo "Checking configuration file at $CONF_FILE..."
if [[ ! -f "$CONF_FILE" ]]; then
    echo "$CONF_FILE does not exist. Creating it now."
    sudo bash -c "cat > $CONF_FILE" <<EOF
github_username=
domain_name=
vps_ip=
EOF
fi

# Source configuration file
source "$CONF_FILE"

# Function to validate an IP address
validate_ip() {
    local ip="$1"
    local regex='^([0-9]{1,3}\.){3}[0-9]{1,3}$'
    if [[ $ip =~ $regex ]]; then
        IFS='.' read -r -a octets <<< "$ip"
        for octet in "${octets[@]}"; do
            if (( octet < 0 || octet > 255 )); then
                return 1
            fi
        done
        return 0
    fi
    return 1
}

# Get service name
while true; do
    read -p "Enter the desired service name: " service_name
    [[ -n "$service_name" ]] && break
    echo "Error: Service name cannot be empty."
done

# Get repository name
while true; do
    read -p "Enter the repository name (on GitHub): " repo_name
    [[ -n "$repo_name" ]] && break
    echo "Error: Repository name cannot be empty."
done

# Ensure GitHub username exists in the config file
if [[ -z "$github_username" ]]; then
    read -p "Enter your GitHub username: " github_username
fi

# Get or confirm domain name
if [[ -n "$domain_name" ]]; then
    read -p "Use existing domain name ($domain_name)? (y/n): " confirm_domain
    if [[ "$confirm_domain" != "y" ]]; then
        read -p "Enter new domain name: " domain_name
    fi
else
    read -p "Enter your domain name: " domain_name
fi

# Normalize domain name
domain_name=$(echo "$domain_name" | sed -E 's~^(https?://)~~' | sed -E 's~/$~~')

# Validate domain format
if [[ ! "$domain_name" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "Error: Invalid domain format."
    exit 1
fi

# Get domain type (main or subdomain)
while true; do
    read -p "Is this a main domain or subdomain? (main/sub): " domain_type
    [[ "$domain_type" == "main" || "$domain_type" == "sub" ]] && break
    echo "Invalid choice! Enter 'main' or 'sub'."
done

if [[ "$domain_type" == "sub" ]]; then
    full_domain="$service_name.$domain_name"
    dns_name="$service_name"
else
    full_domain="$domain_name"
    dns_name="@"
fi

# Get VPS IP address
if [[ -n "$vps_ip" ]]; then
    read -p "Use existing VPS IP ($vps_ip)? (y/n): " confirm_vps_ip
    if [[ "$confirm_vps_ip" != "y" ]]; then
        while true; do
            read -p "Enter your VPS IP address: " input_vps_ip
            if validate_ip "$input_vps_ip"; then
                vps_ip="$input_vps_ip"
                break
            else
                echo "Invalid IP address! Try again."
            fi
        done
    fi
else
    while true; do
        read -p "Enter your VPS IP address: " vps_ip
        if validate_ip "$vps_ip"; then
            break
        else
            echo "Invalid IP address! Try again."
        fi
    done
fi

# Output final settings
echo -e "\nFinal Settings:"
echo "Service Name: $service_name"
echo "Repository: $repo_name"
echo "Full Domain: $full_domain"
echo "VPS IP: $vps_ip"

# Save to configuration file
sudo sed -i "s/^github_username=.*/github_username=$github_username/" "$CONF_FILE" 2>/dev/null || echo "github_username=$github_username" | sudo tee -a "$CONF_FILE" > /dev/null
sudo sed -i "s/^domain_name=.*/domain_name=$domain_name/" "$CONF_FILE" 2>/dev/null || echo "domain_name=$domain_name" | sudo tee -a "$CONF_FILE" > /dev/null
sudo sed -i "s/^vps_ip=.*/vps_ip=$vps_ip/" "$CONF_FILE" 2>/dev/null || echo "vps_ip=$vps_ip" | sudo tee -a "$CONF_FILE" > /dev/null

# Set up project directory
TARGET_DIR="$HOME/$service_name"
mkdir -p "$TARGET_DIR"
DOCKER_COMPOSE_FILE="$TARGET_DIR/docker-compose.yml"

# Generate Docker Compose file
export service_name="$service_name"
export full_domain="$full_domain"
export github_username="$github_username"
export repo_name="$repo_name"

sed -e "s/\${service_name}/$service_name/g" \
    -e "s/\${full_domain}/$full_domain/g" \
    -e "s/\${github_username}/$github_username/g" \
    -e "s/\${repo_name}/$repo_name/g" \
    "$DOCKER_COMPOSE_TEMPLATE" > "$DOCKER_COMPOSE_FILE"

# Ensure the file was created
if [[ -f "$DOCKER_COMPOSE_FILE" ]]; then
    echo "Docker Compose file created successfully at $DOCKER_COMPOSE_FILE"
else
    echo "Error: Failed to create the Docker Compose file."
    exit 1
fi

# Deploy the container
cd "$TARGET_DIR" || exit
docker compose up -d

# DNS Instructions
echo -e "\nDNS Configuration for $full_domain:"
printf "%-10s | %-30s | %-15s | %-5s \n" "Type" "Name" "Points to" "TTL"
printf "%-10s | %-30s | %-15s | %-5s \n" "----------" "------------------------------" "---------------" "-----"
printf "%-10s | %-30s | %-15s | %-5s \n" "A" "$dns_name" "$vps_ip" "14400"

# Verify if the container is running
sleep 5
if docker ps | grep -q "$service_name"; then
    echo "Container '$service_name' is running successfully!"
else
    echo "Warning: Container '$service_name' may not have started correctly."
fi
