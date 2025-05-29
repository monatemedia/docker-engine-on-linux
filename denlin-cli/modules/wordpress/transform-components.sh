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
CONTAINER_JS_PATH="/var/www/html/template/scripts/transform-components.js"
CONTAINER_TEMPLATE_DIR="/var/www/html/template"

echo "➡️ Copying JS transformer to template/scripts..."
mkdir -p "$(dirname "$DEST_JS")"
cp "$SOURCE_JS" "$DEST_JS"
echo "✅ JS transformer copied to template/scripts."

echo "📦 Ensuring fs-extra is installed in container..."
docker exec -it "$CONTAINER_NAME" sh -c "cd $CONTAINER_TEMPLATE_DIR && npm ls fs-extra >/dev/null 2>&1 || npm install fs-extra"

echo "🧠 Setting THEME_SLUG env variable and running JS inside container..."
docker exec -e THEME_SLUG="$THEME_SLUG" -it "$CONTAINER_NAME" node "$CONTAINER_JS_PATH"

echo "✅ Components transformed and placed into theme's template-parts folder."
echo
