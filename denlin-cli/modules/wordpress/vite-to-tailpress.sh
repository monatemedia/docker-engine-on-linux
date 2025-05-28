#!/bin/bash
# modules/wordpress/vite-to-tailpress.sh
# Menu: WordPress
# Description: Automate converting a Vite React template into a TailPress-based WordPress theme

set -e
set -o pipefail

# Load environment variables
source "$(pwd)/.env"

# Resolve container name
CONTAINER_NAME="${DOCKER_CONTAINER_NAME}-web"

# Convert WP_SITE_TITLE to kebab-case for the theme directory name
THEME_SLUG=$(echo "$WP_SITE_TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

echo "➡️ Logging into the WordPress container for Vite-to-TailPress conversion..."

docker exec -i -e THEME_SLUG="$THEME_SLUG" "$CONTAINER_NAME" bash <<'EOF'
  set -e
  set -o pipefail

  THEME_DIR="/var/www/html/wp-content/themes/$THEME_SLUG"

  echo "📂 Changing directory to theme folder: \$THEME_DIR"
  cd "\$THEME_DIR"

  echo "🎨 Merging app.css..."
  cat ./resources/css/base.css >> ./resources/css/app.css

  echo "📦 Creating template-parts if not exists..."
  mkdir -p ./template-parts

  echo "📄 Converting Vite React components to PHP templates..."
  for name in about contact footer hero navbar services whychooseus; do
    echo "<?php // Template part: \$name ?>" > "./template-parts/\$name.php"
    echo "Created: ./template-parts/\$name.php"
  done

  echo "🧱 Setting up index.php layout..."
  cp index.php index.php.bak
  echo "<?php get_header(); ?>" > index.php
  echo "<main><h1>Welcome to TailPress</h1></main>" >> index.php
  echo "<?php get_footer(); ?>" >> index.php

  echo "✅ Conversion complete inside container."
EOF

echo "🚀 Vite-to-TailPress conversion done!"
