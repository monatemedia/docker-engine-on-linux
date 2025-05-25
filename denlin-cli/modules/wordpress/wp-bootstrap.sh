#!/bin/bash
# modules/wordpress/wp-bootstrap.sh
# Menu: WordPress
# Description: Bootstraps WordPress in Docker using WP-CLI and environment variables

set -e
set -o pipefail

# Load environment variables
source "$(pwd)/.env"

# Resolve container name
CONTAINER_NAME="${DOCKER_CONTAINER_NAME}-web"

docker exec -i "$CONTAINER_NAME" bash <<'EOF'

  set -e

  wp() {
    command wp "$@" --allow-root
  }

  # Load environment variables inside container
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

  # Install WordPress if not already installed
  if ! wp core is-installed; then
    wp core install \
      --url="$WP_SITE_URL" \
      --title="$WP_SITE_TITLE" \
      --admin_user="$WP_ADMIN_USER" \
      --admin_password="$WP_ADMIN_PASS" \
      --admin_email="$WP_ADMIN_EMAIL"
  fi

  # Update WordPress core
  wp core update

  # Clean up themes and install Twenty Twenty-Five
  wp theme list --field=name | grep -v twentytwentyfive | xargs -r wp theme delete
  wp theme install twentytwentyfive --activate

  # Clean up plugins
  wp plugin list --field=name | xargs -r wp plugin delete

  # Install essential plugins
  wp plugin install wpvivid-backuprestore --activate
  wp plugin install litespeed-cache
  wp plugin install wordpress-seo

  # Re-create admin user if necessary
  if ! wp user get "$WP_ADMIN_USER" >/dev/null 2>&1; then
    wp user create "$WP_ADMIN_USER" "$WP_ADMIN_EMAIL" --user_pass="$WP_ADMIN_PASS" --role=administrator
  fi

  # Force HTTPS on site/home URLs
  wp option update siteurl "$(wp option get siteurl | sed 's|http:|https:|')"
  wp option update home "$(wp option get home | sed 's|http:|https:|')"

  # General WordPress settings
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
  wp language core install "$WP_LANGUAGE" --activate

  # Configure automatic updates
  wp config set WP_AUTO_UPDATE_CORE "$WP_AUTO_UPDATE_CORE" --raw
  wp config set AUTOMATIC_UPDATER_DISABLED false --raw
  wp config set WP_PLUGIN_AUTO_UPDATE "$WP_AUTO_UPDATE_PLUGINS" --raw
  wp config set WP_THEME_AUTO_UPDATE "$WP_AUTO_UPDATE_THEMES" --raw

  # Clean up default content
  wp post list --post_type=page --format=ids | xargs -r wp post delete --force
  wp post list --post_type=post --format=ids | xargs -r wp post delete --force
  wp comment list --format=ids | xargs -r wp comment delete --force

  # Create a Home page and set it as the front page
  HOME_ID=$(wp post create --post_type=page --post_title="Home" --post_status=publish --porcelain)
  wp option update show_on_front page
  wp option update page_on_front "$HOME_ID"

  # Set permalink structure
  wp rewrite structure '/%postname%/' --hard
  wp rewrite flush --hard

  echo '✅ WordPress setup completed successfully.'

EOF
