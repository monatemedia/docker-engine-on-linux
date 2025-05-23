#!/bin/bash
# modules/hello-world/hello-world.sh
# Menu: Hello World
# Description: Show how to make your own Denlin script

echo "👋 Hello from Denlin CLI!"
echo
echo "This is an example module script that shows you how to create a script:"
echo "  ✅ Start the script with the shebang:   #!/bin/bash"#!/bin/bash
echo "  ✅ Add a comment for the path:          # modules/hello-world/hello-world.sh"
echo "  ✅ Create a menu section using:         # Menu: <menu>"
echo "  ✅ Describe your script using:          # Description: <info>"
echo "  ✅ Add your executable script logic like this echo command"
echo
echo "💡 To add your own script:"
echo "  1. Save it in: /usr/local/bin/denlin-cli/modules/<yourfolder>/your-script.sh"
echo "  2. Make it executable: chmod +x your-script.sh"
echo "  3. Use the 'Menu' and 'Description' headers to organize it in the CLI"
echo
echo "👉 Try running: denlin <yourfolder>/your-script"
echo "👉 Or launch the full menu with: denlin"
echo
echo "🚀 Happy scripting!"
echo
