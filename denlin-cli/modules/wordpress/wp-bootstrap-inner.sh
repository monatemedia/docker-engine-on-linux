#!/bin/bash

set -e

wp() {
  command wp "$@" --allow-root
}

# Install WordPress core if not installed
if ! wp core is-installed; then
  wp core install \
    --url="$WP_SITE_URL" \
    --title="$WP_SITE_TITLE" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASS" \
    --admin_email="$WP_ADMIN_EMAIL"
fi

wp core update
wp theme list --field=name | grep -v twentytwentyfive | xargs -r wp theme delete
wp theme install twentytwentyfive --activate
wp plugin list --field=name | xargs -r wp plugin delete
wp plugin install wpvivid-backuprestore --activate
wp plugin install litespeed-cache
wp plugin install wordpress-seo

if ! wp user get "$WP_ADMIN_USER" >/dev/null 2>&1; then
  wp user create "$WP_ADMIN_USER" "$WP_ADMIN_EMAIL" --user_pass="$WP_ADMIN_PASS" --role=administrator
fi

wp option update siteurl "$(wp option get siteurl | sed 's|http:|https:|')"
wp option update home "$(wp option get home | sed 's|http:|https:|')"

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

wp config set WP_AUTO_UPDATE_CORE "$WP_AUTO_UPDATE_CORE" --raw
wp config set AUTOMATIC_UPDATER_DISABLED false --raw
wp config set WP_PLUGIN_AUTO_UPDATE "$WP_AUTO_UPDATE_PLUGINS" --raw
wp config set WP_THEME_AUTO_UPDATE "$WP_AUTO_UPDATE_THEMES" --raw

wp post list --post_type=page --format=ids | xargs -r wp post delete --force
wp post list --post_type=post --format=ids | xargs -r wp post delete --force
wp comment list --format=ids | xargs -r wp comment delete --force

HOME_ID=$(wp post create --post_type=page --post_title="Home" --post_status=publish --porcelain)
wp option update show_on_front page
wp option update page_on_front "$HOME_ID"

wp rewrite structure '/%postname%/' --hard
wp rewrite flush --hard

echo '✅ WordPress setup completed successfully.'