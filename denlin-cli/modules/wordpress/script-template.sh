#!/bin/bash
# Menu: WordPress
# Description: Scaffold a basic WordPress + MySQL Docker setup

set -e

echo "📦 Setting up WordPress Docker containers..."

# Define default values
WORDPRESS_PORT=8080
DB_ROOT_PASSWORD="rootpassword"
DB_NAME="wordpress"
DB_USER="wpuser"
DB_PASSWORD="wppassword"

cat <<EOF > docker-compose.yml
version: '3.1'

services:

  wordpress:
    image: wordpress
    restart: always
    ports:
      - "${WORDPRESS_PORT}:80"
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: ${DB_USER}
      WORDPRESS_DB_PASSWORD: ${DB_PASSWORD}
      WORDPRESS_DB_NAME: ${DB_NAME}
    volumes:
      - wordpress_data:/var/www/html

  db:
    image: mysql:5.7
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
      MYSQL_DATABASE: ${DB_NAME}
      MYSQL_USER: ${DB_USER}
      MYSQL_PASSWORD: ${DB_PASSWORD}
    volumes:
      - db_data:/var/lib/mysql

volumes:
  wordpress_data:
  db_data:
EOF

echo "✅ WordPress Docker Compose file created!"
echo "👉 Run the following command to start your containers:"
echo
echo "   docker compose up -d"
echo
