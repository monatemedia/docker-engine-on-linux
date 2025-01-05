#!/bin/bash

# ==========================
# Denlin CLI Tool
# ==========================
# ASCII Art Banner
display_banner() {
    echo "                                                               "
    echo " _____     ______     __   __     __         __     __   __    "
    echo "/\  __-.  /\  ___\   /\ "-.\ \   /\ \       /\ \   /\ "-.\ \   "
    echo "\ \ \/\ \ \ \  __\   \ \ \-.  \  \ \ \____  \ \ \  \ \ \-.  \  "
    echo " \ \____-  \ \_____\  \ \_\\"\_\  \ \_____\  \ \_\  \ \_\\"\_\ "
    echo "  \/____/   \/_____/   \/_/ \/_/   \/_____/   \/_/   \/_/ \/_/ "
    echo "                                                               "
    echo "                                                               "
    echo "     Denlin: Docker Engine on Linux CLI Tool Version Alpha     "
    echo "                                                               "
    echo "                                                               "
}

# Interactive Menu
interactive_menu() {
    while true; do
        display_banner
        echo "Main Menu:"
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
                echo "Exiting Denlin. Goodbye!"
                exit 0
                ;;
            *)
                echo "Invalid choice. Please select a valid option."
                ;;
        esac

        echo ""
        read -p "Press Enter to return to the menu..."
    done
}

# Update Functionality
update() {
    REPO_URL="https://github.com/monatemedia/docker-engine-on-linux"
    INSTALL_DIR="/usr/local/bin/denlin"

    if [ -d "$INSTALL_DIR/.git" ]; then
        echo "Updating Denlin tool from $REPO_URL..."
        git -C "$INSTALL_DIR" pull origin main || echo "Failed to update. Ensure Git is installed and the repo is properly set up."
    else
        echo "Cloning Denlin tool from $REPO_URL..."
        sudo git clone "$REPO_URL" "$INSTALL_DIR" || echo "Failed to clone the repository. Check your network connection."
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
