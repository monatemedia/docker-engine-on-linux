#!/bin/bash
# modules/wordpress/install-tailwind.sh
# Menu: WordPress
# Description: Initializes TailPress theme with Tailwind CSS in a WordPress Docker container
set -eset -o pipefail

# Load environment variables
source "$(pwd)/.env"

# Resolve container name
CONTAINER_NAME="${DOCKER_CONTAINER_NAME}-web"

# Convert WP_SITE_TITLE to kebab-case for the theme directory name
THEME_SLUG=$(echo "$WP_SITE_TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

echo "➡️ Logging into the WordPress container..."
docker exec -it "$CONTAINER_NAME" bash <<'EOF'
  set -ex

  echo "📂 Changing directory to wp-content/themes..."
  cd /var/www/html/wp-content/themes

  # Get the site title and theme slug from environment variables passed by Docker
  SITE_TITLE="$WP_SITE_TITLE"
  THEME_SLUG="$THEME_SLUG"

  echo "✨ Running 'tailpress new $THEME_SLUG'..."
  # Execute the tailpress new command and provide answers non-interactively
  echo "$SITE_TITLE" | tailpress new "$THEME_SLUG"
  echo "Monate Media"
  echo "edward@monatemedia.com"
  echo "https://localhost:8000"
  echo "no"

  echo "✅ TailPress theme '$THEME_SLUG' created."

  echo "🚀 Activating the '$THEME_SLUG' theme..."
  wp theme activate "$THEME_SLUG" --allow-root
EOF

echo "📦 Installing npm dependencies for the theme..."
docker exec -it "$CONTAINER_NAME" bash -c "cd /var/www/html/wp-content/themes/$THEME_SLUG && npm install --timeout=120000"

echo "🛠️ Running the npm build process..."
docker exec -it "$CONTAINER_NAME" bash -c "cd /var/www/html/wp-content/themes/$THEME_SLUG && npm run build"

echo "✅ Tailwind installation and build process initiated."