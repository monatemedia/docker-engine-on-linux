#!/bin/bash

# ==========================
# Denlin CLI Tool
# ==========================

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
# Update the script directory reference
MODULES_DIR="/usr/local/bin/denlin-cli/modules"

# Refactor the load_menu function to use this directory
load_menu() {
    MENU_ITEMS=()
    MENU_DESCRIPTIONS=()
    UNASSIGNED_SCRIPTS=()

    # Loop through each script in the modules folder
    for script in "$MODULES_DIR"/*.sh; do
        if [ -f "$script" ]; then
            # Extract the first three lines of the script for menu, submenu, and description
            menu=$(sed -n '1s/# Menu: //p' "$script" | tr -d '\r')
            submenu=$(sed -n '2s/# Submenu: //p' "$script" | tr -d '\r')
            description=$(sed -n '3s/# Description: //p' "$script" | tr -d '\r')

            # Debugging output to check parsed values
            echo "Parsing script: $script"
            echo "Menu: $menu"
            echo "Submenu: $submenu"
            echo "Description: $description"

            # Check if any header fields are missing
            if [ -z "$menu" ] || [ -z "$submenu" ] || [ -z "$description" ]; then
                UNASSIGNED_SCRIPTS+=("$script")
            else
                MENU_ITEMS+=("$menu:$submenu:$script")
                MENU_DESCRIPTIONS+=("$description")
            fi
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

# Show Unassigned Scripts
show_unassigned_scripts() {
    if [ ${#UNASSIGNED_SCRIPTS[@]} -eq 0 ]; then
        echo "No unassigned scripts."
        return  # No unassigned scripts, don't show this submenu
    fi

    echo "Unassigned Scripts:"

    PS3="Select an unassigned script (or press ENTER to go back): "
    select script in "${UNASSIGNED_SCRIPTS[@]}" "Back"; do
        if [[ "$script" == "Back" ]]; then
            main_menu
            return
        fi

        echo "You selected: $script"
        # Execute the unassigned script
        bash "$script"
    done
}

# Main Menu
main_menu() {
    load_menu  # Load the menu options dynamically
    echo "Loading main menu..."

    if [ ${#MENU_ITEMS[@]} -eq 0 ] && [ ${#UNASSIGNED_SCRIPTS[@]} -eq 0 ]; then
        echo "No scripts found in the /modules folder."
        exit 1
    fi

    PS3="Select a menu option: "
    select opt in "${MENU_ITEMS[@]}" "Unassigned Scripts" "Exit"; do
        if [ "$opt" == "Exit" ]; then
            exit 0
        fi

        if [ "$opt" == "Unassigned Scripts" ]; then
            show_unassigned_scripts
            return
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

# Start the Menu
main_menu