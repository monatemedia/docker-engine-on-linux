#!/bin/bash
# modules/wordpress/transform-components.sh
# Menu: WordPress
# Description: Transform Vite components into TailPress PHP template parts

set -e
set -o pipefail

# Load environment variables
source "$(pwd)/.env"

# Vars
CONTAINER_NAME="${DOCKER_CONTAINER_NAME}-web"
LOCAL_JS_PATH="$(pwd)/modules/wordpress/transform-components/transform-components.js"
CONTAINER_TEMPLATE_DIR="/var/www/html/template"
CONTAINER_SCRIPT_DIR="${CONTAINER_TEMPLATE_DIR}/scripts"

echo "➡️ Copying JS transformer to template/scripts..."
docker exec "$CONTAINER_NAME" mkdir -p "$CONTAINER_SCRIPT_DIR"
docker cp "$LOCAL_JS_PATH" "$CONTAINER_NAME:$CONTAINER_SCRIPT_DIR/transform-components.js"

echo "🧠 Setting THEME_SLUG env variable in container..."
THEME_SLUG=$(echo "$WP_SITE_TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

echo "📦 Running transform-components.js inside container..."
docker exec -e THEME_SLUG="$THEME_SLUG" "$CONTAINER_NAME" node "$CONTAINER_SCRIPT_DIR/transform-components.js"

echo "✅ Components transformed and placed into theme's template-parts folder."
echo