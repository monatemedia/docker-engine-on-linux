#!/bin/bash

# ==========================
# Services CLI Tool
# ==========================

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


# Parse Scripts and Descriptions Dynamically
MODULES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/service-modules" && pwd)"

load_menu() {
    MENU_ITEMS=()
    MENU_DESCRIPTIONS=()

    for script in "$MODULES_DIR"/*.sh; do
        if [ -f "$script" ]; then
            # Extract description
            description=$(sed -n 's/^# Description: \(.*\)/\1/p' "$script" | tr -d '\r')
            basename=$(basename "$script" .sh)

            MENU_ITEMS+=("$basename")
            MENU_DESCRIPTIONS+=("$description")
        fi
    done
}

run_service_script() {
    script_name="$1"
    script_path="$MODULES_DIR/$script_name.sh"
    if [ -f "$script_path" ]; then
        echo -e "\nRunning service: $script_name\n"
        bash "$script_path"
    else
        echo -e "\nService script '$script_name' not found.\n"
        exit 1
    fi
}

main_menu() {
    display_banner
    load_menu

    echo -e "Available Services:\n"
    for i in "${!MENU_ITEMS[@]}"; do
        echo "$((i+1))) ${MENU_ITEMS[i]} - ${MENU_DESCRIPTIONS[i]}"
    done
    echo -e "\nq) Quit"

    echo
    read -p "Select an option: " choice

    if [ "$choice" == "q" ]; then
        echo -e "\nGoodbye!"
        exit 0
    elif [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -le "${#MENU_ITEMS[@]}" ]; then
        run_service_script "${MENU_ITEMS[$((choice-1))]}"
    else
        echo -e "\nInvalid choice. Please try again.\n"
        main_menu
    fi
}

main_menu
