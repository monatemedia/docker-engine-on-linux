#!/bin/bash

# ==========================
# Denlin CLI Tool - Simplified Main Menu
# ==========================

# Colors
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
RESET="\e[0m"

# ASCII Art Banner
display_banner() {
    echo -e "${BLUE}"
    echo -e "                                                                     "
    echo -e "    _____     ______     __   __     __         __     __   __      "
    echo -e "   /\\  __-.  /\\  ___\\   /\\ \"-.\\ \\   /\\ \\       /\\ \\   /\\ \"-.\\ \\   "
    echo -e "   \\ \\ \\/\\ \\ \\ \\  __\\   \\ \\ \\-.  \\  \\ \\ \\____  \\ \\ \\  \\ \\ \\-.  \\  "
    echo -e "    \\ \\____-  \\ \\_____\\  \\ \\_\\ \"\\_\\  \\ \\_____\\  \\ \\_\\  \\ \\_\\ \"\\_\\ "
    echo -e "     \\/____/   \\/_____/   \\/_/ \\/_/   \\/_____/   \\/_/   \\/_/ \\/_/ "
    echo -e "                                                                     "
    echo -e "     ${RESET}Denlin: Docker Engine on Linux CLI Tool Version Juliet 1.0.3${BLUE}"
    echo -e "                                                                     "
    echo -e "${RESET}"
}

# Set root directory for scripts
MODULES_DIR="/usr/local/bin/denlin-cli/modules"

# Load menu items (menu:script_name:description)
load_menu() {
    MENU_ITEMS=()
    while IFS= read -r script; do
        if [ -f "$script" ]; then
            menu=$(sed -n 's/^# Menu: \(.*\)/\1/p' "$script" | tr -d '\r')
            description=$(sed -n 's/^# Description: \(.*\)/\1/p' "$script" | tr -d '\r')

            rel_path="${script#$MODULES_DIR/}"
            basename="${rel_path%.sh}"

            # Only add scripts with a menu name
            if [ -n "$menu" ]; then
                MENU_ITEMS+=("$menu:$basename:$description")
            fi
        fi
    done < <(find "$MODULES_DIR" -type f -name "*.sh")
}

# Run a selected script by basename
run_script() {
    local script_name="$1"
    local script_path="$MODULES_DIR/$script_name.sh"

    if [ -f "$script_path" ]; then
        if [ ! -x "$script_path" ]; then
            echo -e "${RED}Script '$script_path' is not executable. Run:\nchmod +x \"$script_path\"${RESET}"
            exit 1
        fi
        echo -e "\nRunning script: $script_name\n"
        bash "$script_path"
    else
        echo -e "${RED}Script '$script_name' not found.${RESET}"
        exit 1
    fi
}

# Show main menu and prompt user
main_menu() {
    display_banner
    load_menu

    echo -e "${GREEN}Main Menu:${RESET}\n"

    # Get unique menus in order
    local menus=()
    for item in "${MENU_ITEMS[@]}"; do
        menu=$(echo "$item" | cut -d: -f1)
        if [[ ! " ${menus[*]} " =~ " $menu " ]]; then
            menus+=("$menu")
        fi
    done

    # Add Exit option
    menus+=("Exit")

    while true; do
        # Display menu options with numbers
        for i in "${!menus[@]}"; do
            echo "$((i+1))) ${menus[i]}"
        done

        echo
        read -rp "Select a menu option (or press ENTER to exit): " choice
        choice=$(echo "$choice" | xargs)  # Trim whitespace

        # Exit on empty input or Exit option
        if [[ -z "$choice" ]] || [[ "${menus[choice-1]}" == "Exit" ]]; then
            echo -e "\nGoodbye!\n"
            exit 0
        fi

        # Validate input number range
        if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#menus[@]} )); then
            selected_menu="${menus[choice-1]}"
            if [[ "$selected_menu" == "Exit" ]]; then
                echo -e "\nGoodbye!\n"
                exit 0
            fi

            # If only one script per menu, run it directly
            # Otherwise, list scripts under that menu for selection

            # Find scripts under selected menu
            local scripts=()
            local descriptions=()
            for item in "${MENU_ITEMS[@]}"; do
                IFS=":" read -r menu_name script_name script_desc <<< "$item"
                if [[ "$menu_name" == "$selected_menu" ]]; then
                    scripts+=("$script_name")
                    descriptions+=("$script_desc")
                fi
            done

            if [ "${#scripts[@]}" -eq 1 ]; then
                run_script "${scripts[0]}"
            else
                # Show submenu to select a script
                echo -e "\n${GREEN}$selected_menu Options:${RESET}"
                for i in "${!scripts[@]}"; do
                    printf "%d) %s - %s\n" "$((i+1))" "${scripts[i]}" "${descriptions[i]}"
                done
                echo

                read -rp "Select a script to run (or press ENTER to return): " subchoice
                subchoice=$(echo "$subchoice" | xargs)

                if [[ -z "$subchoice" ]]; then
                    continue
                fi

                if [[ "$subchoice" =~ ^[0-9]+$ ]] && (( subchoice >= 1 && subchoice <= ${#scripts[@]} )); then
                    run_script "${scripts[subchoice-1]}"
                else
                    echo -e "${RED}Invalid option. Returning to main menu.${RESET}\n"
                    sleep 1
                fi
            fi
        else
            echo -e "${RED}Invalid option. Try again.${RESET}\n"
            sleep 1
        fi
    done
}

# Script entry point
if [ "$1" ]; then
    run_script "$1"
else
    main_menu
fi
