#!/bin/bash

# Menu: Configure VPS
# Description: A script to deploy a Hello World container for Docker testing.

CONF_FILE="/etc/denlin-cli.conf"
DOCKER_COMPOSE_TEMPLATE="/usr/local/bin/denlin-cli/services/docker-compose/hello-world.template.yml"

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

# Step 1: Get service name (Ensure input is not empty)
while true; do
    read -p "Enter the desired service name: " service_name
    if [[ -n "$service_name" ]]; then
        break
    else
        echo "Error: Service name cannot be empty. Please enter a valid service name."
    fi
done

# Set target directory and Docker Compose file
TARGET_DIR="$HOME/$service_name"
DOCKER_COMPOSE_FILE="$TARGET_DIR/docker-compose.yml"

# Step 2: Confirm or update domain name
if [[ -n "$domain_name" ]]; then
    while true; do
        read -p "The current domain name in the config file is: $domain_name. Do you want to use this domain name? (y/n): " confirm_domain_name
        case "$confirm_domain_name" in
            y|Y) 
                break 
                ;;
            n|N) 
                read -p "Enter a new domain name: " input_domain_name
                domain_name="$input_domain_name"
                break 
                ;;
            *) 
                echo "Invalid input! Please enter 'y' for Yes or 'n' for No."
                ;;
        esac
    done
else
    read -p "Enter your domain name: " domain_name
fi


# Normalize domain name (remove http://, https://, and trailing slashes)
domain_name=$(echo "$domain_name" | sed -E 's~^(https?://)~~' | sed -E 's~/$~~')

# Validate domain format
if [[ ! "$domain_name" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "Error: Invalid domain format."
    exit 1
fi

# Step 3: Main or Subdomain?
while true; do
    read -p "Is this container mapped as a main domain (e.g., monatemedia.com) or a subdomain (e.g., hello-world.monatemedia.com)? Enter 'main' or 'sub': " domain_type
    if [[ "$domain_type" == "main" || "$domain_type" == "sub" ]]; then
        break
    else
        echo -e "\nInvalid choice! Please enter 'main' or 'sub'.\n"
    fi
done

if [[ "$domain_type" == "sub" ]]; then
    full_domain="$service_name.$domain_name"
    dns_name="$service_name"
else
    full_domain="$domain_name"
    dns_name="@"
fi

# Determine correct DNS name format
if [[ "$domain_type" == "main" ]]; then
    dns_name="@"
else
    dns_name="$service_name.$domain_name"
fi

# Step 4: Get VPS IP with validation
if [[ -n "$vps_ip" ]]; then
    read -p "The current VPS IP is: $vps_ip. Do you want to use this IP? (y/n): " confirm_vps_ip
    if [[ "$confirm_vps_ip" != "y" ]]; then
        while true; do
            read -p "Enter your VPS IP address: " input_vps_ip
            if validate_ip "$input_vps_ip"; then
                vps_ip="$input_vps_ip"
                break
            else
                echo -e "\nInvalid IP address! Try again.\n"
            fi
        done
    fi
else
    while true; do
        read -p "Enter your VPS IP address: " vps_ip
        if validate_ip "$vps_ip"; then
            break
        else
            echo -e "\nInvalid IP address! Try again.\n"
        fi
    done
fi

# Output final domain and VPS IP
echo "Final Domain Name: $dns_name"
echo "VPS IP Address: $vps_ip"

# Save to configuration file
echo -e "domain_name=$domain_name\nvps_ip=$vps_ip" | sudo tee "$CONF_FILE" > /dev/null

# Ensure the target directory exists
TARGET_DIR="$HOME/$service_name"
mkdir -p "$TARGET_DIR"

# Copy the Docker Compose template
DOCKER_COMPOSE_FILE="$TARGET_DIR/docker-compose.yml"
cp "$DOCKER_COMPOSE_TEMPLATE" "$DOCKER_COMPOSE_FILE"

# Ensure the file was created
if [[ -f "$DOCKER_COMPOSE_FILE" ]]; then
    echo "✅ Docker Compose file created successfully at $DOCKER_COMPOSE_FILE"
else
    echo "❌ Error: Failed to create the Docker Compose file."
    exit 1
fi

# Deploy the container
cd "$TARGET_DIR" || exit
docker-compose up -d

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