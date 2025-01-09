#!/bin/bash

# Menu: Services
# Description: Entry point for reusable commands and integration with services.sh

# Resolve the project root directory
PROJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

# Start the services menu
start_services() {
    SERVICES_SCRIPT="$PROJECT_ROOT/services/services.sh"
    if [ -f "$SERVICES_SCRIPT" ]; then
        bash "$SERVICES_SCRIPT"
    else
        echo "Error: services.sh not found at $SERVICES_SCRIPT"
        exit 1
    fi
}

# Main logic
start_services