#!/bin/bash

# Menu: Services
# Description: Entry point for reusable commands and integration with services.sh

# Resolve the project root directory
PROJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

# Load configuration file
if [ -f "$PROJECT_ROOT/services/services.conf" ]; then
    source "$PROJECT_ROOT/services/services.conf"
else
    echo "Error: services.conf not found at $PROJECT_ROOT/services/services.conf"
    exit 1
fi

# ASCII Art Banner
display_banner() {
    echo -e "                                                                 "
    echo -e "         _____     ______     __   __     __         __     __   __   "
    echo -e "        /\\  __-.  /\\  ___\\   /\\ \"-.\\ \\   /\\ \\       /\\ \\   /\\ \"-.\\ \\  "
    echo -e "        \\ \\ \\/\\ \\ \\ \\  __\\   \\ \\ \\-.  \\  \\ \\ \\____  \\ \\ \\  \\ \\ \\-.  \\ "
    echo -e "         \\ \\____-  \\ \\_____\\  \\ \\_ \\\"\\_\\  \\ \\_____\\  \\ \\_\\  \\ \\_\\ \"\\_\\"
    echo -e "          \\/____/   \\/_____/   \\/_/ \\/_/   \\/_____/   \\/_/   \\/_/ \\/_/"
    echo -e ""
    echo -e "   ______     ______     ______     __   __   __     ______     ______     ______    "
    echo -e "  /\  ___\   /\  ___\   /\  == \   /\ \ / /  /\ \   /\  ___\   /\  ___\   /\  ___\   "
    echo -e "  \ \___  \  \ \  __\   \ \  __<   \ \ \'/   \ \ \  \ \ \____  \ \  __\   \ \___  \  "
    echo -e "   \/\_____\  \ \_____\  \ \_\ \_\  \ \__|    \ \_\  \ \_____\  \ \_____\  \/\_____\ "
    echo -e "    \/_____/   \/_____/   \/_/ /_/   \/_/      \/_/   \/_____/   \/_____/   \/_____/ "
    echo -e "                                                                 "                  
    echo -e "                                                                 "
}

# Validate Docker installation
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

# Function to call services.sh
call_services() {
    display_banner
    source ../services/services.sh
}

# Main entry point for common.sh
main() {
    if [[ "$1" == "services" ]]; then
        "$PROJECT_ROOT/services/services.sh"
    else
        echo "Usage: $0 {services}"
    fi
}

main "$@"