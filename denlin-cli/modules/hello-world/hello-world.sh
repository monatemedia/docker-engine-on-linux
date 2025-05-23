#!/bin/bash
# modules/hello-world/hello-world.sh
# Menu: Hello World
# Description: Show how to make your own Denlin script

echo "👋 Hello from Denlin CLI!"
echo
echo "This is an example module script that shows you how to create a script:"
echo "  ✅ Start the script with the shebang:   #!/bin/bash"
echo "  ✅ Add a comment for the path:          # modules/hello-world/hello-world.sh"
echo "  ✅ Create a menu section using:         # Menu: Hello World"
echo "  ✅ Describe your script using:          # Description: Show how to make your own Denlin script"
echo "  ✅ Add your executable script logic like this echo command"
echo
echo -e "\nExample Module Script"
echo
echo "========================="
echo -e "#!/bin/bash"
echo -e "# modules/<yourfolder>/your-script.sh"
echo -e "# Menu: <Submenu Name>"
echo -e "# Description: <Description of what this script does>"
echo
echo "example_function() {"
echo "    # Add your logic here"
echo "}"
echo
echo -e "# Call the function"
echo "example_function"
echo -e "\n=========================\n"
echo
echo "👉 Try running: denlin <yourfolder>/your-script"
echo "👉 Or launch the full menu with: denlin"
echo
echo "🚀 Happy scripting!"
echo
