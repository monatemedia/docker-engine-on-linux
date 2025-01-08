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
    echo -e "       Denlin: Docker Engine on Linux CLI Tool Version Golf      "
    echo -e "                                                                 "
}

# Parse Scripts and Descriptions Dynamically
MODULES_DIR="/usr/local/bin/denlin-cli/modules"

load_menu() {
    MENU_ITEMS=()
    MENU_DESCRIPTIONS=()
    UNASSIGNED_SCRIPTS=()

    for script in "$MODULES_DIR"/*.sh; do
        if [ -f "$script" ]; then
            # Extract menu and description
            menu=$(sed -n 's/^# Menu: \(.*\)/\1/p' "$script" | tr -d '\r')
            description=$(sed -n 's/^# Description: \(.*\)/\1/p' "$script" | tr -d '\r')

            # Default to "Unassigned Scripts" if no menu is defined
            if [ -z "$menu" ]; then
                menu="Unassigned Scripts"
            fi

            # Add to menu items or unassigned scripts
            basename=$(basename "$script" .sh)
            if [ "$menu" == "Unassigned Scripts" ]; then
                UNASSIGNED_SCRIPTS+=("$basename:$description")
            else
                MENU_ITEMS+=("$menu:$basename:$description")
            fi
        fi
    done
}

run_script() {
    script_name="$1"
    script_path="$MODULES_DIR/$script_name.sh"
    if [ -f "$script_path" ]; then
        bash "$script_path"
    else
        echo "Script '$script_name' not found."
        exit 1
    fi
}

show_submenu() {
    local menu="$1"
    echo "Submenu: $menu"
    local options=()
    for item in "${MENU_ITEMS[@]}"; do
        item_menu=$(echo "$item" | cut -d: -f1)
        if [ "$item_menu" == "$menu" ]; then
            basename=$(echo "$item" | cut -d: -f2)
            options+=("$basename")
        fi
    done

    PS3="Select an option (or press ENTER to go back): "
    select opt in "${options[@]}" "Back"; do
        if [ "$opt" == "Back" ]; then
            main_menu
            return
        fi

        run_script "$opt"
        return
    done
}

show_unassigned_scripts() {
    if [ ${#UNASSIGNED_SCRIPTS[@]} -eq 0 ]; then
        echo "No unassigned scripts."
        return
    fi

    echo "Unassigned Scripts:"
    PS3="Select an unassigned script (or press ENTER to go back): "
    select script in "${UNASSIGNED_SCRIPTS[@]}" "Back"; do
        if [[ "$script" == "Back" ]]; then
            main_menu
            return
        fi

        script_name=$(echo "$script" | cut -d: -f1)
        run_script "$script_name"
        return
    done
}

main_menu() {
    display_banner
    load_menu

    echo "Main Menu:"
    local options=("Exit")
    for item in "${MENU_ITEMS[@]}"; do
        menu=$(echo "$item" | cut -d: -f1)
        if [[ ! " ${options[@]} " =~ " $menu " ]]; then
            options+=("$menu")
        fi
    done
    options+=("Unassigned Scripts")

    PS3="Select a menu option: "
    select opt in "${options[@]}"; do
        if [ "$opt" == "Exit" ]; then
            exit 0
        elif [ "$opt" == "Unassigned Scripts" ]; then
            show_unassigned_scripts
        elif [[ " ${options[@]} " =~ " $opt " ]]; then
            show_submenu "$opt"
        fi
    done
}

# Direct Script Execution
if [ "$1" ]; then
    run_script "$1"
else
    main_menu
fi
