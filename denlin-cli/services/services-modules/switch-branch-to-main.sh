#!/bin/bash

# Main script: Configure VPS
# Description: Rename the local master branch to main and push it to GitHub

# Define variables
TEMP_SCRIPT="/tmp/rename-git-branch.sh"

# Step 1: Create the temporary script
echo "Creating temporary script at $TEMP_SCRIPT..."
cat > "$TEMP_SCRIPT" <<'EOF'
#!/bin/bash

# Ensure we are in a Git repository
if [[ ! -d .git ]]; then
    echo "Error: This is not a Git repository. Please run the script inside a Git project."
    exit 1
fi

PROJECT_DIR=$(pwd)

# Step 1: Check for or create .gitignore and .dockerignore
echo "Checking if .gitignore and .dockerignore exist..."

if [[ ! -f "$PROJECT_DIR/.gitignore" ]]; then
    echo ".gitignore not found. Creating it now..."
    touch "$PROJECT_DIR/.gitignore"
fi

if [[ ! -f "$PROJECT_DIR/.dockerignore" ]]; then
    echo ".dockerignore not found. Creating it now..."
    touch "$PROJECT_DIR/.dockerignore"
fi

# Step 2: Add script to ignore lists
echo "Adding script to .gitignore and .dockerignore..."
echo "rename-git-branch.sh" >> "$PROJECT_DIR/.gitignore"
echo "rename-git-branch.sh" >> "$PROJECT_DIR/.dockerignore"

# Step 3: Rename master to main locally
echo "Renaming local 'master' branch to 'main'..."
git branch -m master main

# Step 4: Push the renamed branch to GitHub
echo "Pushing 'main' branch to GitHub..."
git push -u origin main

# Step 5: Update remote tracking branches
echo "Updating remote tracking branches..."
git remote set-head origin -a

# Step 6: Set default branch to main on GitHub (if GitHub CLI is installed)
if command -v gh &> /dev/null; then
    echo "Setting 'main' as the default branch on GitHub..."
    gh repo edit --default-branch main
else
    echo "GitHub CLI not found. Please set 'main' as the default branch manually on GitHub."
fi

# Step 7: Delete the script
echo "Cleaning up temporary script..."
rm -- "$0"

echo "Branch renaming complete. You may now close this terminal."
EOF

# Step 2: Inform the user how to proceed
echo ""
echo "Temporary script created at: $TEMP_SCRIPT"
echo "To proceed, download the script to your local computer and run it from your project root:"
echo ""
echo "  scp user@your-server:$TEMP_SCRIPT ./rename-git-branch.sh"
echo ""
echo "Then run:"
echo ""
echo "  chmod +x rename-git-branch.sh && ./rename-git-branch.sh"
echo ""
echo "Once the script finishes, it will delete itself."
echo ""
