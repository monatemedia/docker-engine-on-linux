#!/bin/bash

# Menu: Services
# Description: Create Docker Compose YAML files with a wizard




display_banner

# Check if Docker is installed
validate_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Docker is not installed. Please install Docker to proceed."
        exit 1
    fi
}

# List available Docker networks
list_docker_networks() {
    docker network ls --format "{{.Name}}"
}

# Prompt user to choose or create a network
choose_network() {
    echo "Available Docker networks:"
    list_docker_networks
    echo "Enter an existing network name or type 'new' to create a new one:"
    read -r NETWORK
    if [[ "$NETWORK" == "new" ]]; then
        echo "Enter a name for the new network:"
        read -r NETWORK
        docker network create "$NETWORK"
        echo "Created new network: $NETWORK."
    fi
    echo "$NETWORK"
}