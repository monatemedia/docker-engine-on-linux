#!/bin/bash
# modules/wordpress/download-template.sh
# Menu: WordPress
# Description: Downloads a template from a URL into the /template folder.

# Define the template URL (you can also pass this as an argument if needed)
THEME_TEMPLATE="${THEME_TEMPLATE}"

# Resolve container name
source "$(pwd)/.env"
CONTAINER_NAME="${DOCKER_CONTAINER_NAME}-web"

echo "➡️ Downloading template '$THEME_TEMPLATE' into the container's /template folder..."
docker exec -i "$CONTAINER_NAME" bash -c "cd /template && git clone '$THEME_TEMPLATE' ."

echo "✅ Template downloaded successfully to /template inside the '$CONTAINER_NAME' container."