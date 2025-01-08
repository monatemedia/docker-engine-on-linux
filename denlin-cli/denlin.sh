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

# Parse Scripts and Descriptions Dynamically
load_menu() {
    MENU_ITEMS=()
    MENU_DESCRIPTIONS=()

    for script in /modules/*.sh; do
        if [ -f "$script" ]; then
            # Extract menu, submenu, and description from the header
            menu=$(head -n 1 "$script" | sed 's/# Menu: //')
            submenu=$(head -n 2 "$script" | tail -n 1 | sed 's/# Submenu: //')
            description=$(head -n 3 "$script" | tail -n 1 | sed 's/# Description: //')

            MENU_ITEMS+=("$menu:$submenu:$script")
            MENU_DESCRIPTIONS+=("$description")
        fi
    done
}

# Show Submenu
show_submenu() {
    local submenu="$1"
    local options=()
    local descriptions=()
    local i=1

    # Loop through each script in the modules directory
    for ((i = 0; i < ${#MENU_ITEMS[@]}; i++)); do
        # Extract the menu and submenu from the item
        item=${MENU_ITEMS[$i]}
        menu=$(echo "$item" | cut -d: -f1)
        sub=$(echo "$item" | cut -d: -f2)
        script=$(echo "$item" | cut -d: -f3)

        # If the item matches the current submenu, add it to the options
        if [ "$sub" == "$submenu" ]; then
            options+=("$menu:$sub:$script")
            descriptions+=("${MENU_DESCRIPTIONS[$i]}")
        fi
    done

    if [ ${#options[@]} -eq 0 ]; then
        echo "No options found for submenu: $submenu"
        return
    fi

    PS3="Select an option (or press ENTER to go back): "
    select opt in "${options[@]}" "Back"; do
        if [[ "$opt" == "Back" ]]; then
            main_menu
            return
        fi

        # Show the selected option and its description
        index=$(echo "$opt" | cut -d: -f3)
        description="${descriptions[$index]}"
        echo "You selected: $opt"
        echo "Description: $description"

        # Execute the selected script
        bash "$index"
    done
}

# Main Menu
show_main_menu() {
    PS3="Select a menu option: "
    select opt in "${MENU_ITEMS[@]}" "Exit"; do
        if [ "$opt" == "Exit" ]; then
            exit 0
        fi

        menu=$(echo "$opt" | cut -d: -f1)
        submenu=$(echo "$opt" | cut -d: -f2)
        script=$(echo "$opt" | cut -d: -f3)

        echo "You selected: $menu -> $submenu"
        description="${MENU_DESCRIPTIONS[$index]}"
        echo "Description: $description"

        show_submenu "$submenu"
    done
}

main_menu