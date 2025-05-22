#!/bin/bash

# Script name: delete.sh
# Description: Provides delete options and accepts an optional argument for the file/folder to delete.

# Function to confirm deletion
confirm_deletion() {
    read -p "Are you sure you want to delete '$1'? (y/n): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        if [ -f "$1" ]; then
            rm -f "$1"
            echo "File '$1' has been deleted."
        elif [ -d "$1" ]; then
            rm -rf "$1"
            echo "Folder '$1' has been deleted."
        else
            echo "'$1' does not exist."
        fi
    else
        echo "Deletion canceled."
    fi
}

# Main logic
if [ "$#" -eq 0 ]; then
    echo "Delete Options:"
    echo "1. Delete a file"
    echo "2. Delete a folder"
    echo "3. Exit"
    read -p "Enter your choice (1/2/3): " choice

    case $choice in
        1)
            read -p "Enter the name of the file to delete: " file
            confirm_deletion "$file"
            ;;
        2)
            read -p "Enter the name of the folder to delete: " folder
            confirm_deletion "$folder"
            ;;
        3)
            echo "Exiting the script."
            exit 0
            ;;
        *)
            echo "Invalid option. Exiting."
            exit 1
            ;;
    esac
elif [ "$#" -eq 1 ]; then
    target="$1"
    confirm_deletion "$target"
else
    echo "Usage: $0 [file_or_folder_to_delete]"
    exit 1
fi
