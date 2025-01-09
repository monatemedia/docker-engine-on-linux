#!/bin/bash

# Load common functions and configuration
source ../modules/common.sh
source ../services.conf

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

# Main entry point for the script
main() {
    display_banner
    echo "Welcome to the Docker Services Setup!"
    validate_docker

    # Get the service name
    read -p "Enter a name for your service (e.g., 'shared-proxy'): " SERVICE_NAME
    SERVICE_DIR="../${SERVICE_NAME}"
    mkdir -p "$SERVICE_DIR"

    # List available Docker networks or create a new one
    echo "Checking Docker networks..."
    NETWORK=$(choose_network)

    # Generate docker-compose.yml
    generate_docker_compose "$SERVICE_NAME" "$NETWORK" "$SERVICE_DIR"

    # Suggest adding a cron job
    echo "Would you like to set up a cron job to renew SSL certificates? (y/n)"
    read -r ADD_CRON
    if [[ "$ADD_CRON" == "y" || "$ADD_CRON" == "Y" ]]; then
        ../modules/create-cron.sh "$SERVICE_DIR"
    fi

    echo "Service setup complete! Your docker-compose.yml is in $SERVICE_DIR."
}

# Generate docker-compose.yml using the template
generate_docker_compose() {
    SERVICE_NAME=$1
    NETWORK=$2
    SERVICE_DIR=$3

    TEMPLATE="../services/templates/nginx-proxy.template.yml"
    OUTPUT="$SERVICE_DIR/docker-compose.yml"

    echo "Generating docker-compose.yml for $SERVICE_NAME..."

    sed -e "s|<SERVICE_NAME>|$SERVICE_NAME|g" \
        -e "s|<NETWORK_NAME>|$NETWORK|g" \
        -e "s|<DEFAULT_EMAIL>|$DEFAULT_EMAIL|g" \
        "$TEMPLATE" > "$OUTPUT"

    echo "docker-compose.yml created at $OUTPUT."
}

main
