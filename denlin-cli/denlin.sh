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
    echo -e "        Denlin: Docker Engine on Linux CLI Tool Version Charlie    "
    echo -e "                                                                 "
    echo -e "                                                                 "
}


# Interactive Menu
interactive_menu() {
    while true; do
        display_banner
        echo "Main Menu:"
        echo
        echo "1. Update Denlin"
        echo "2. Configure VPS"
        echo "3. Docker Management"
        echo "4. Exit"
        echo ""
        read -p "Enter your choice [1-4]: " choice

        case "$choice" in
            1)
                update
                ;;
            2)
                echo "Configuration module not yet implemented."
                ;;
            3)
                echo "Docker management module not yet implemented."
                ;;
            4)
                echo
                echo "Exiting Denlin. Goodbye!"
                echo
                exit 0
                ;;
            *)
                echo "Invalid choice. Please select a valid option."
                ;;
        esac

        echo ""
        read -p "Press Enter to return to the main menu..."
    done
}

# Path to the update script
UPDATE_SCRIPT="/usr/local/bin/denlin-cli/modules/update.sh"

# Update Functionality
update() {
    echo
    echo "=== Denlin Update ==="
    if [ -f "$UPDATE_SCRIPT" ]; then
        echo "Running the update script located at $UPDATE_SCRIPT..."
        bash "$UPDATE_SCRIPT" || {
            echo "Failed to execute the update script. Please check for errors."
            exit 1
        }
    else
        echo "Update script not found at $UPDATE_SCRIPT."
        echo "Please ensure the update script exists and try again."
        exit 1
    fi
}


# Command Parsing
case "$1" in
    update)
        update
        ;;
    *)
        # Launch interactive menu if no valid arguments are provided
        interactive_menu
        ;;
esac
