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

# Directory containing scripts
MODULES_DIR="./modules"

# Function to display the main menu
display_main_menu() {
    local menu_items=()
    local unassigned_scripts=()

    # Parse scripts for menu items
    for script in "$MODULES_DIR"/*; do
        if [[ -f "$script" && -x "$script" ]]; then
            menu=$(grep -m1 '^# Menu:' "$script" | cut -d: -f2 | xargs)
            description=$(grep -m1 '^# Description:' "$script" | cut -d: -f2 | xargs)
            if [[ -n "$menu" ]]; then
                menu_items+=("$menu")
            else
                unassigned_scripts+=("$script")
            fi
        fi
    done

    # Sort and remove duplicates from menu_items
    menu_items=($(printf "%s\n" "${menu_items[@]}" | sort -u))

    # Display menu
    echo "Main Menu:"
    local idx=1
    for item in "${menu_items[@]}"; do
        echo "$idx) $item"
        idx=$((idx + 1))
    done

    # Handle unassigned scripts
    if [[ ${#unassigned_scripts[@]} -gt 0 ]]; then
        echo "$idx) Unassigned Scripts"
        idx=$((idx + 1))
    fi

    echo "$idx) Exit"
}

# Function to display submenu
display_submenu() {
    local menu_name="$1"
    local idx=1

    echo "Submenu: $menu_name"
    for script in "$MODULES_DIR"/*; do
        if [[ -f "$script" && -x "$script" ]]; then
            menu=$(grep -m1 '^# Menu:' "$script" | cut -d: -f2 | xargs)
            description=$(grep -m1 '^# Description:' "$script" | cut -d: -f2 | xargs)
            if [[ "$menu" == "$menu_name" ]]; then
                script_name=$(basename "$script")
                echo "$idx) $script_name - $description"
                idx=$((idx + 1))
            fi
        fi
    done
    echo "$idx) Back"
}

# Function to handle unassigned scripts
handle_unassigned_scripts() {
    echo "Unassigned Scripts:"
    echo "The following scripts do not have a 'Menu:' comment."
    echo "To assign a script to a menu, add the following comment to the top of the script:"
    echo "    # Menu: <menu_name>"
    echo "    # Description: <description>"

    for script in "$MODULES_DIR"/*; do
        if [[ -f "$script" && -x "$script" ]]; then
            menu=$(grep -m1 '^# Menu:' "$script" | cut -d: -f2 | xargs)
            if [[ -z "$menu" ]]; then
                echo " - $(basename "$script")"
            fi
        fi
    done
}

# Main script loop
while true; do
    clear
    display_main_menu
    echo -n "Select a menu option: "
    read -r choice

    case "$choice" in
        [1-9]*)
            clear
            menu_name=$(display_main_menu | sed -n "${choice}p" | cut -d')' -f2 | xargs)
            if [[ "$menu_name" == "Exit" ]]; then
                echo "Goodbye!"
                break
            elif [[ "$menu_name" == "Unassigned Scripts" ]]; then
                handle_unassigned_scripts
            else
                display_submenu "$menu_name"
            fi
            echo "Press ENTER to continue..."
            read -r
            ;;
        *)
            echo "Invalid option. Try again."
            ;;
    esac
done