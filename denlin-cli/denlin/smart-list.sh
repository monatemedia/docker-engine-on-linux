#!/bin/bash

# Menu: Linux Commands
# Description: List of directory list (ls) commands

#!/bin/bash

echo "Welcome to the Smart 'ls' Helper Script!"
echo "Choose the type of file listing you want:"
echo "1) Basic listing (ls)"
echo "2) Detailed listing (ls -l)"
echo "3) Show all files, including hidden ones (ls -a)"
echo "4) Combine detailed and hidden (ls -la)"
echo "5) Recursive listing (include subdirectories, ls -R)"
echo "6) Quit"

# Prompt the user for input
read -p "Enter your choice (1-6): " choice

# Run the appropriate command based on the user's choice
case $choice in
    1)
        echo "Running: ls"
        ls
        ;;
    2)
        echo "Running: ls -l"
        ls -l
        ;;
    3)
        echo "Running: ls -a"
        ls -a
        ;;
    4)
        echo "Running: ls -la"
        ls -la
        ;;
    5)
        echo "Running: ls -R"
        ls -R
        ;;
    6)
        echo "Exiting the script. Goodbye!"
        exit 0
        ;;
    *)
        echo "Invalid choice. Please run the script again and select a valid option."
        exit 1
        ;;
esac
