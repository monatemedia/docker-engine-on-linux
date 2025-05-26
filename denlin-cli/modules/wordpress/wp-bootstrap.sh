#!/bin/bash
# modules/wordpress/wp-bootstrap.sh
# Menu: WordPress
# Description: Bootstraps WordPress in Docker using WP-CLI and environment variables

set -e
set -o pipefail

# Load environment variables from .env in current directory
source "$(pwd)/.env"

# Resolve container name (assuming docker-compose service name + suffix)
CONTAINER_NAME="${DOCKER_CONTAINER_NAME}-web"

docker exec -i "$CONTAINER_NAME" bash <<'EOF'
  set -ex

  wp() {
    echo "+ wp $* --allow-root"
    command wp "$@" --allow-root
  }

  export WP_SITE_URL="$WP_SITE_URL"
  export WP_SITE_TITLE="$WP_SITE_TITLE"
  export WP_ADMIN_USER="$WP_ADMIN_USER"
  export WP_ADMIN_PASS="$WP_ADMIN_PASS"
  export WP_ADMIN_EMAIL="$WP_ADMIN_EMAIL"
  export WP_SITE_TAGLINE="$WP_SITE_TAGLINE"
  export WP_TIMEZONE="$WP_TIMEZONE"
  export WP_START_OF_WEEK="$WP_START_OF_WEEK"
  export WP_LANGUAGE="$WP_LANGUAGE"
  export WP_AUTO_UPDATE_CORE="$WP_AUTO_UPDATE_CORE"
  export WP_AUTO_UPDATE_PLUGINS="$WP_AUTO_UPDATE_PLUGINS"
  export WP_AUTO_UPDATE_THEMES="$WP_AUTO_UPDATE_THEMES"

  # Avoid interactive prompts
  export DEBIAN_FRONTEND=noninteractive

  # Install WordPress if not already installed
  if ! wp core is-installed; then

    # Set auto-update config BEFORE install to avoid DB connection issues later
    wp config set WP_AUTO_UPDATE_CORE "$WP_AUTO_UPDATE_CORE"
    wp config set AUTOMATIC_UPDATER_DISABLED false
    wp config set WP_PLUGIN_AUTO_UPDATE "$WP_AUTO_UPDATE_PLUGINS"
    wp config set WP_THEME_AUTO_UPDATE "$WP_AUTO_UPDATE_THEMES"

    wp core install \
      --url="$WP_SITE_URL" \
      --title="$WP_SITE_TITLE" \
      --admin_user="$WP_ADMIN_USER" \
      --admin_password="$WP_ADMIN_PASS" \
      --admin_email="$WP_ADMIN_EMAIL"
 
    # Force HTTPS immediately after install (avoid echo pollution)
    CURRENT_URL="$(command wp option get siteurl --allow-root | sed 's|^http:|https:|')"
    command wp option update siteurl "$CURRENT_URL" --allow-root

    HOME_URL="$(command wp option get home --allow-root | sed 's|^http:|https:|')"
    command wp option update home "$HOME_URL" --allow-root
  fi

  wp core update

  echo "🧹 Deleting all themes..."
  wp theme list --field=name | while read -r theme; do
    wp theme delete "$theme" 2>/dev/null || true
  done

  echo "🎨 Installing and activating 'twentytwentyfive' theme..."
  wp theme install twentytwentyfive --activate

  echo "🧹 Deleting all plugins..."
  wp plugin list --field=name | while read -r plugin; do
    wp plugin delete "$plugin" 2>/dev/null || true
  done

  echo "📦 Installing and activating required plugins..."
  wp plugin install wpvivid-backuprestore --activate
  wp plugin install litespeed-cache --activate
  wp plugin install wordpress-seo --activate

  # Ensure admin user exists
  if ! wp user get "$WP_ADMIN_USER" >/dev/null 2>&1; then
    wp user create "$WP_ADMIN_USER" "$WP_ADMIN_EMAIL" --user_pass="$WP_ADMIN_PASS" --role=administrator
  fi

  # General settings
  wp option update blogname "$WP_SITE_TITLE"
  wp option update blogdescription "$WP_SITE_TAGLINE"
  wp option update timezone_string "$WP_TIMEZONE"
  wp option update start_of_week "$WP_START_OF_WEEK"
  wp option update rss_use_excerpt 1
  wp option update default_pingback_flag 0
  wp option update default_ping_status closed
  wp option update default_comment_status closed
  wp option update comment_registration 1
  wp option update comment_moderation 1
  wp option update show_avatars 0
  wp option update blog_public 0

  # Delete all pages
  POST_IDS=$(command wp post list --post_type=page --format=ids --allow-root)
  if [ -n "$POST_IDS" ]; then
    wp post delete $POST_IDS --force
  fi

  # Delete all posts
  POST_IDS=$(command wp post list --post_type=post --format=ids --allow-root)
  if [ -n "$POST_IDS" ]; then
    wp post delete $POST_IDS --force
  fi

  # Delete all comments
  COMMENT_IDS=$(command wp comment list --format=ids --allow-root)
  if [ -n "$COMMENT_IDS" ]; then
    wp comment delete $COMMENT_IDS --force
  fi

  # Front page setup
  HOME_ID=$(wp post create --post_type=page --post_title="Home" --post_status=publish --porcelain)
  wp option update show_on_front page
  wp option update page_on_front "$HOME_ID"

  # Permalink setup, ignoring DB connection error
  wp rewrite structure '/%postname%/' --hard --allow-root 2>/dev/null || true

  # Ensure Apache mod_rewrite is enabled
  { a2enmod rewrite 2>/dev/null || true; } || true

  # Add ServerName to avoid warning
  { echo "ServerName localhost" >> /etc/apache2/apache2.conf 2>/dev/null || true; } || true
  { apache2ctl -k restart >/dev/null 2>&1 || true; } || true

  # Flush rewrite rules
  wp rewrite flush --hard --allow-root || true

  echo '✅ WordPress bootstrap completed successfully.'
EOF
