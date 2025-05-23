#!/bin/bash
# denlin.sh
# Menu: <Main Menu>
# Description: Denlin CLI Tool Main Script

# ==========================
# Denlin CLI Tool
# ==========================

# Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
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
    echo -e "    ${YELLOW}Denlin: Docker Engine on Linux CLI Tool Version Juliet 1.0.3${BLUE}"
    echo -e "                                                                     "
    echo -e "${RESET}"
}

# Set root directory
MODULES_DIR="/usr/local/bin/denlin-cli/modules"

load_menu() {
    MENU_ITEMS=()
    MENU_DESCRIPTIONS=()
    UNASSIGNED_SCRIPTS=()

    while IFS= read -r script; do
        if [ -f "$script" ]; then
            menu=$(sed -n 's/^# Menu: \(.*\)/\1/p' "$script" | tr -d '\r')
            description=$(sed -n 's/^# Description: \(.*\)/\1/p' "$script" | tr -d '\r')

            rel_path="${script#$MODULES_DIR/}"
            basename="${rel_path%.sh}"

            if [ -z "$menu" ]; then
                menu="Unassigned Scripts"
            fi

            if [ "$menu" == "Unassigned Scripts" ]; then
                UNASSIGNED_SCRIPTS+=("$basename:$description")
            else
                MENU_ITEMS+=("$menu:$basename:$description")
            fi
        fi
    done < <(find "$MODULES_DIR" -type f -name "*.sh")
}

log_execution() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$HOME/.denlin.log"
}

run_script() {
    script_name="$1"
    shift
    script_path="$MODULES_DIR/$script_name.sh"

    if [ -f "$script_path" ]; then
        if [ ! -x "$script_path" ]; then
            echo -e "${YELLOW}\nScript '$script_path' is not executable. Try running:\nchmod +x \"$script_path\"\n${RESET}"
            exit 1
        fi

        echo -e "\nRunning script: $script_name\n"
        log_execution "$script_name $*"
        bash "$script_path" "$@"
    else
        echo -e "${RED}\nScript '$script_name' not found in modules directory.\nExpected: $script_path\n${RESET}"
        exit 1
    fi
}

show_submenu() {
    local menu="$1"
    echo -e "${BLUE}\nSubmenu: $menu${RESET}\n"
    local options=()

    for item in "${MENU_ITEMS[@]}"; do
        IFS=':' read -r item_menu basename description <<< "$item"
        if [ "$item_menu" == "$menu" ]; then
            echo -e "  ${GREEN}$basename${RESET} - $description"
            options+=("$basename")
        fi
    done

    echo
    PS3="Select an option (or press ENTER to go back): "
    select opt in "${options[@]}" "Back"; do
        if [ "$opt" == "Back" ]; then
            main_menu
            return
        elif [ -n "$opt" ]; then
            run_script "$opt"
            return
        fi
    done
}

show_unassigned_scripts() {
    echo -e "${BLUE}\nUnassigned Scripts:${RESET}\n====================\n"
    if [ ${#UNASSIGNED_SCRIPTS[@]} -eq 0 ]; then
        echo -e "No unassigned scripts.\n"
        return
    fi

    echo -e "These scripts are not assigned to any menu. To assign a script:"
    echo -e "  1. Open the script in a text editor."
    echo -e "  2. Add a line:   # Menu: <desired_menu_name>"
    echo -e "  3. Add a line:   # Description: <desired_description>"

    echo
    PS3="Select an unassigned script (or press ENTER to go back): "
    select script in "${UNASSIGNED_SCRIPTS[@]}" "Back"; do
        if [[ "$script" == "Back" ]]; then
            main_menu
            return
        elif [ -n "$script" ]; then
            script_name=$(echo "$script" | cut -d: -f1)
            run_script "$script_name"
            return
        fi
    done
}

main_menu() {
    display_banner
    load_menu

    echo -e "${GREEN}Main Menu:${RESET}\n"
    local options=()
    local has_unassigned_scripts=0

    for item in "${MENU_ITEMS[@]}"; do
        menu=$(echo "$item" | cut -d: -f1)
        if [[ ! " ${options[*]} " =~ " $menu " ]]; then
            options+=("$menu")
        fi
    done

    if [ ${#UNASSIGNED_SCRIPTS[@]} -gt 0 ]; then
        options+=("Unassigned Scripts")
        has_unassigned_scripts=1
    fi

    options+=("Exit")

    PS3="Select a menu option: "
    select opt in "${options[@]}"; do
        if [[ -z "$REPLY" ]]; then
            echo -e "\nNo selection made. Goodbye!\n"
            exit 0
        elif [ "$opt" == "Exit" ]; then
            echo -e "\nGoodbye!\n"
            exit 0
        elif [ "$opt" == "Unassigned Scripts" ] && [ $has_unassigned_scripts -eq 1 ]; then
            show_unassigned_scripts
        elif [[ " ${options[*]} " =~ " $opt " ]]; then
            show_submenu "$opt"
        else
            echo -e "${RED}\nInvalid option. Try again.\n${RESET}"
        fi
    done
}

# Direct Script Execution
if [ "$1" ]; then
    run_script "$@"
else
    main_menu
fi
