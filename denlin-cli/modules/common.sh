#!/bin/bash

# Menu: Services
# Description: Entry point for reusable commands and integration with services.sh

# Resolve the project root directory
PROJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

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
display_banner
start_services