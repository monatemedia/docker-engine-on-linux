#!/bin/bash
# modules/wordpress/install-tailwind.sh
# Menu: WordPress
# Description: Initializes TailPress theme with Tailwind CSS in a WordPress Docker container
set -e
set -o pipefail

# Load environment variables
source "$(pwd)/.env"

# Resolve container name
CONTAINER_NAME="${DOCKER_CONTAINER_NAME}-web"

# Convert WP_SITE_TITLE to kebab-case for the theme directory name
THEME_SLUG=$(echo "$WP_SITE_TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

echo "➡️ Logging into the WordPress container..."
docker exec -it "$CONTAINER_NAME" bash <<'EOF'
  set -e
  set -o pipefail

  echo "📂 Changing directory to wp-content/themes..."
  cd /var/www/html/wp-content/themes

  # Get the site title and theme slug from environment variables
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

  echo "📦 Changing directory to the new theme: $THEME_SLUG"
  cd "$THEME_SLUG"

  echo "⚙️ Installing npm dependencies..."
  npm install --timeout=120000

  echo "🛠️ Running the npm build process..."
  npm run build

  echo "✅ Theme build complete."
EOF

echo "🚀 Activating the '$THEME_SLUG' theme..."
docker exec -it "$CONTAINER_NAME" wp theme activate "$THEME_SLUG" --allow-root

echo "✅ Tailwind theme installation and activation complete!"