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

# Copy inner script into the container
docker cp modules/wordpress/wp-bootstrap-inner.sh "$CONTAINER_NAME":/tmp/wp-bootstrap-inner.sh

# Run it inside container with environment variables
docker exec -i \
  -e WP_SITE_URL \
  -e WP_SITE_TITLE \
  -e WP_ADMIN_USER \
  -e WP_ADMIN_PASS \
  -e WP_ADMIN_EMAIL \
  -e WP_SITE_TAGLINE \
  -e WP_TIMEZONE \
  -e WP_START_OF_WEEK \
  -e WP_LANGUAGE \
  -e WP_AUTO_UPDATE_CORE \
  -e WP_AUTO_UPDATE_PLUGINS \
  -e WP_AUTO_UPDATE_THEMES \
  "$CONTAINER_NAME" bash /tmp/wp-bootstrap-inner.sh
  