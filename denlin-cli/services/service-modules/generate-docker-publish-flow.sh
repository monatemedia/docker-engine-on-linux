#!/bin/bash

# Main script: Generate Docker Publish Workflow
# Description: Generates a temporary script to create a `docker-publish.yml` GitHub Actions workflow, adds it to the repository, and deletes itself after execution.

# Variables
CONF_FILE="/etc/denlin-cli.conf"
TEMP_SCRIPT="/tmp/create-docker-publish-temp.sh"
current_repo=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" || echo "not-a-git-repo")

# Step 1: Load configuration from `denlin-cli.conf`
echo "Checking configuration file at $CONF_FILE..."
if [[ ! -f "$CONF_FILE" ]]; then
    echo "Error: Configuration file $CONF_FILE does not exist. Please create it first."
    exit 1
fi

source "$CONF_FILE"

# Step 2: Validate repository name
if [[ "$current_repo" == "not-a-git-repo" ]]; then
    echo "Error: This script must be run inside a Git repository."
    exit 1
fi

# Step 3: Create the temporary script
echo "Creating temporary script at $TEMP_SCRIPT..."
cat > "$TEMP_SCRIPT" <<EOF
#!/bin/bash

# Temporary script: Create `docker-publish.yml`
# This script will delete itself upon successful execution.

# Check if this is a Git repository
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "Error: This is not a Git repository. Please run this script from within a Git project."
    exit 1
fi

# Create the .github/workflows directory if it doesn't exist
mkdir -p .github/workflows

# Create the `docker-publish.yml` file
cat > .github/workflows/docker-publish.yml <<YML
name: publish
on:
  push:
    branches: ["main"]
env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ghcr.io/${{ github.actor }}/$current_repo:latest
jobs:
  publish:
    name: Publish Docker Image
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Login to GitHub Container Registry
        run: |
          echo ${{ secrets.PAT }} | docker login ghcr.io -u ${{ github.actor }} --password-stdin
      - name: Build and Push Docker Image
        run: |
          docker build . --tag ${{ env.IMAGE_NAME }}
          docker push ${{ env.IMAGE_NAME }}
  deploy:
    needs: publish
    name: Deploy Image
    runs-on: ubuntu-latest
    steps:
      - name: Install SSH Keys
        run: |
          install -m 600 -D /dev/null ~/.ssh/id_rsa
          echo "${{ secrets.SSH_PRIVATE_KEY }}" > ~/.ssh/id_rsa
          ssh-keyscan -H ${{ secrets.SSH_HOST }} > ~/.ssh/known_hosts
      - name: Pull and Deploy Docker Image
        run: ssh ${{ secrets.SSH_USER }}@${{ secrets.SSH_HOST }} "cd ${{ secrets.WORK_DIR }} && docker compose pull && docker compose up -d"
      - name: Cleanup SSH Keys
        run: rm -rf ~/.ssh
YML

# Add the new workflow file to Git
git add .github/workflows/docker-publish.yml

# Commit the new workflow
git commit -m "feat: add docker-publish.yml workflow"

# Push the changes to the remote repository
git push

# Inform the user to check the Actions tab
echo "Your changes have been pushed. Open the 'Actions' tab in your repository to see the workflow triggered."
echo

# Generate GitHub Actions workflow creation link
repo_owner=$(git config --get remote.origin.url | sed -n 's|.*github\.com[:/]\(.*\)/.*|\1|p')
repo_name=$(git config --get remote.origin.url | sed -n 's|.*/\(.*\)\.git|\1|p')

if [[ -n "$repo_owner" && -n "$repo_name" ]]; then
    actions_new_link="https://github.com/$repo_owner/$repo_name/actions/new"
    echo "Click the link below to create a new GitHub Actions workflow for this repository:"
    echo "$actions_new_link"
else
    echo "Error: Unable to determine repository owner or name. Ensure this is a valid Git repository."
fi
echo

# Cleanup: Delete the script
echo "Cleaning up temporary script from both local and server..."
rm -- "$0"
ssh "${USER}@${vps_ip}" "rm -f $TEMP_SCRIPT"
EOF

# Make the temporary script executable
chmod +x "$TEMP_SCRIPT"

# Step 4: Provide instructions for usage
echo "Temporary script created at $TEMP_SCRIPT."
echo "To use it, download the script to your local computer and run it from your project root folder:"
echo
echo "scp ${USER}@${HOSTNAME}:$TEMP_SCRIPT ./create-docker-publish-temp.sh"
echo
echo "Then run:"
echo "./create-docker-publish-temp.sh"
echo
echo "Once the script finishes, it will delete itself from both your project and the VPS."
