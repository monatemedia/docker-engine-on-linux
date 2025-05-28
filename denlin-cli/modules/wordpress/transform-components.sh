#!/bin/bash
# modules/wordpress/transform-components.sh
# Menu: WordPress
# Description: Transform Vite components into TailPress PHP template parts

set -e
set -o pipefail

# Load environment variables from project root .env
source "$(pwd)/.env"

# Check container name
if [ -z "$DOCKER_CONTAINER_NAME" ]; then
  echo "❌ DOCKER_CONTAINER_NAME environment variable not set"
  exit 1
fi
CONTAINER_NAME="${DOCKER_CONTAINER_NAME}-web"

# Convert WP_SITE_TITLE to kebab-case for theme slug
THEME_SLUG=$(echo "$WP_SITE_TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_JS="$SCRIPT_DIR/transform-components/transform-components.js"
DEST_JS="$(pwd)/template/scripts/transform-components.js"

echo "➡️ Copying JS transformer to template/scripts..."
mkdir -p "$(dirname "$DEST_JS")"
cp "$SOURCE_JS" "$DEST_JS"
echo "✅ JS transformer copied to template/scripts."

echo "🧠 Setting THEME_SLUG env variable in container..."

# Assuming your node environment inside container can access the JS script at /var/www/html/template/scripts/transform-components.js
# Adjust path below to the actual mount point inside your container

CONTAINER_JS_PATH="/var/www/html/template/scripts/transform-components.js"

echo "📦 Running transform-components.js inside container..."
docker exec -e THEME_SLUG="$THEME_SLUG" -it "$CONTAINER_NAME" node "$CONTAINER_JS_PATH"

echo "✅ Components transformed and placed into theme's template-parts folder."
echo
