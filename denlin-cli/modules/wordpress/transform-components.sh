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

echo "🧠 Setting THEME_SLUG env variable..."
echo

# Try running the script in the container and capture output
run_js_script() {
  docker exec -e THEME_SLUG="$THEME_SLUG" -i "$CONTAINER_NAME" node "$CONTAINER_JS_PATH" 2>&1
}

echo "🚀 Running transform-components.js inside container..."
OUTPUT=$(run_js_script)

# Check if the output contains a missing module error
if echo "$OUTPUT" | grep -q "Cannot find package"; then
  MISSING_MODULE=$(echo "$OUTPUT" | grep "Cannot find package" | sed -E "s/.*Cannot find package '([^']+)'.*/\1/")
  echo "📦 Missing module detected: $MISSING_MODULE"
  echo "📥 Installing $MISSING_MODULE in container..."
  docker exec -it "$CONTAINER_NAME" sh -c "cd $CONTAINER_TEMPLATE_DIR && npm install $MISSING_MODULE"

  echo "🔁 Retrying script after installing $MISSING_MODULE..."
  OUTPUT=$(run_js_script)
fi

echo "$OUTPUT"

echo "✅ Components transformed and placed into theme's template-parts folder."
echo
