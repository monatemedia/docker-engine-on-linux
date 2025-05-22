#!/bin/bash
# modules/example/example-script.sh
# Menu: Example
# Description: This is a sample script. Copy this folder to start a new module.

# Example module script function
show_example() {
    echo -e "\nExample Module Script\n"
    echo "========================="
    echo -e "#!/bin/bash\n"
    echo -e "# Menu: <Submenu Name>"
    echo -e "# Description: <Description of what this script does>\n"
    echo "example_function() {"
    echo -e "    echo \"This is an example function in the script.\"\n"
    echo "    # Add your logic here"
    echo "}\\n"
    echo -e "# Call the function\n"
    echo "example_function"
    echo -e "\n=========================\n"
}

# Call the example function
show_example
