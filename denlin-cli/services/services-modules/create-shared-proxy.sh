#!/bin/bash

# Menu: Configure VPS
# Description: Create a shared proxy server and SSL certificate

# Function to prompt user for input
prompt_email() {
    echo "Enter your email address (for SSL certificate notifications):"
    read -r user_email
    while [[ ! "$user_email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; do
        echo "Invalid email format. Please try again:"
        read -r user_email
    done
    echo "$user_email"
}

# Step 1: Create the shared-proxy directory
echo "Creating shared-proxy directory..."
mkdir -p shared-proxy/nginx/{html,certs,vhost,acme}
cd shared-proxy || { echo "Failed to enter directory."; exit 1; }
echo "Directory structure created successfully."

# Step 2: Create and edit docker-compose.yml
echo "Creating docker-compose.yml..."
cat > docker-compose.yml <<EOL
services:
  nginx-proxy:
    container_name: nginx-proxy
    image: nginxproxy/nginx-proxy
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
      - ./nginx/html:/usr/share/nginx/html
      - ./nginx/certs:/etc/nginx/certs
      - ./nginx/vhost:/etc/nginx/vhost.d
      - ./nginx/acme:/etc/acme.sh
    networks:
      - proxy-network

  letsencrypt-companion:
    container_name: letsencrypt-companion
    image: jrcs/letsencrypt-nginx-proxy-companion
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:z
      - ./nginx/acme:/etc/acme.sh:rw
    networks:
      - proxy-network
    environment:
      DEFAULT_EMAIL: <yourEmail>

networks:
  proxy-network:
    external: true
EOL

echo "docker-compose.yml created. You need to replace '<yourEmail>' with your email address."

# Step 3: Prompt for email
user_email=$(prompt_email)
escaped_email=$(echo "$user_email" | sed 's/[\/&]/\\&/g')
sed -i "s/<yourEmail>/$escaped_email/" docker-compose.yml
echo "Email updated in docker-compose.yml."

# Step 4: Create the Docker proxy network
echo "Creating Docker network 'proxy-network' (if it doesn't already exist)..."
docker network create proxy-network 2>/dev/null || echo "Docker network 'proxy-network' already exists."

# Step 5: Start the nginx-proxy and Let's Encrypt services
echo "Starting Docker services with 'docker-compose up -d'..."
docker compose up -d

if [ $? -eq 0 ]; then
    echo "Proxy setup completed successfully! Your shared proxy is now running."
else
    echo "Failed to start Docker services. Please check the docker-compose.yml and try again."
    exit 1
fi

echo "Setup is complete."
