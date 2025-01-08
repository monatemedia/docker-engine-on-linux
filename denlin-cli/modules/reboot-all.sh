#!/bin/bash
# Menu: System
# Submenu: Reboot
# Description: This script will reboot all systems.

echo "Rebooting all systems..."

while read -r project_dir; do
  if [ -d "$project_dir" ]; then
    echo "Rebooting services in $project_dir"
    (cd "$project_dir" && docker compose down && docker compose up -d)
  else
    echo "Directory $project_dir does not exist. Skipping..."
  fi
done < services.conf
