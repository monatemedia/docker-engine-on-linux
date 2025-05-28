#!/bin/bash
# modules/wordpress/transform-components.sh
# Menu: WordPress
# Description: Transform Vite components into TailPress PHP template parts

set -e
set -o pipefail

# Load environment variables
source "$(pwd)/.env"

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define source and destination paths
SOURCE_JS="$SCRIPT_DIR/transform-components/transform-components.js"
DEST_JS="$SCRIPT_DIR/../../../template/scripts/transform-components.js"

echo "➡️ Copying JS transformer to template/scripts..."
mkdir -p "$(dirname "$DEST_JS")"
cp "$SOURCE_JS" "$DEST_JS"
echo "✅ JS transformer copied to template/scripts."

echo "🧠 Setting THEME_SLUG env variable in container..."
THEME_SLUG=$(echo "$WP_SITE_TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

echo "📦 Running transform-components.js inside container..."
docker exec -e THEME_SLUG="$THEME_SLUG" "$CONTAINER_NAME" node "$CONTAINER_SCRIPT_DIR/transform-components.js"

echo "✅ Components transformed and placed into theme's template-parts folder."
echo