#!/bin/bash

# ==========================
# Denlin CLI Tool
# ==========================

# Global Config File
CONFIG_FILE="/usr/local/bin/denlin-cli/services.conf"

# Load Config File
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Configuration file not found. Please run 'install.sh' to initialize."
    exit 1
fi

# ASCII Art Banner
display_banner() {
    echo -e "                                                                 "
    echo -e "    _____     ______     __   __     __         __     __   __   "
    echo -e "   /\\  __-.  /\\  ___\\   /\\ \"-.\\ \\   /\\ \\       /\\ \\   /\\ \"-.\\ \\  "
    echo -e "   \\ \\ \\/\\ \\ \\ \\  __\\   \\ \\ \\-.  \\  \\ \\ \\____  \\ \\ \\  \\ \\ \\-.  \\ "
    echo -e "    \\ \\____-  \\ \\_____\\  \\ \\_ \\\"\\_\\  \\ \\_____\\  \\ \\_\\  \\ \\_\\ \"\\_\\"
    echo -e "     \\/____/   \\/_____/   \\/_/ \\/_/   \\/_____/   \\/_/   \\/_/ \\/_/"
    echo -e "                                                                 "
    echo -e "                                                                 "
    echo -e "       Denlin: Docker Engine on Linux CLI Tool Version Golf      "
    echo -e "                                                                 "
    echo -e "                                                                 "
}

#!/bin/bash

# ==========================
# Denlin CLI Tool
# ==========================

# Global Config File
CONFIG_FILE="/usr/local/bin/denlin-cli/services.conf"

# Load Config File
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Configuration file not found. Please run 'install.sh' to initialize."
    exit 1
fi

# Display Banner
display_banner() {
    echo -e "   ____       _   _       _         "
    echo -e "  |  _ \  ___| |_| |_   _| | ___    "
    echo -e "  | | | |/ _ \ __| | | | | |/ _ \   "
    echo -e "  | |_| |  __/ |_| | |_| | |  __/   "
    echo -e "  |____/ \___|\__|_|\__,_|_|\___|   "
    echo -e "   Docker Engine on Linux (Denlin) "
    echo -e "===================================="
}

# Parse Scripts and Descriptions Dynamically
load_menu() {
    MENU_ITEMS=()
    MENU_DESCRIPTIONS=()

    while IFS= read -r line; do
        MENU_ITEMS+=("${line%%:*}")
        MENU_DESCRIPTIONS+=("${line#*:}")
    done < <(grep -E "^Menu:" "$CONFIG_FILE")
}

# Show Submenu
show_submenu() {
    local submenu="$1"
    local options=()
    local i=1

    echo "Loading submenu: $submenu..."
    while IFS= read -r line; do
        if [[ "$line" == "$submenu"* ]]; then
            options+=("${line##* }")
        fi
    done < <(grep -E "^$submenu" "$CONFIG_FILE")

    if [ ${#options[@]} -eq 0 ]; then
        echo "No options found in submenu: $submenu"
        return
    fi

    PS3="Select an option (or press ENTER to go back): "
    select opt in "${options[@]}" "Back"; do
        if [[ "$opt" == "Back" ]]; then
            main_menu
            return
        fi
        echo "You selected $opt"
    done
}

# Main Menu
main_menu() {
    display_banner
    load_menu

    echo "Main Menu:"
    PS3="Select an option (or press ENTER to exit): "
    select opt in "${MENU_ITEMS[@]}" "Exit"; do
        case "$opt" in
            "Exit")
                echo "Goodbye!"
                exit 0
                ;;
            *)
                show_submenu "$opt"
                ;;
        esac
    done
}

main_menu
