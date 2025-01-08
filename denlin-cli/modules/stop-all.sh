#!/bin/bash
# Menu: Main Menu
# Submenu: Docker Management
# Description: Stops all Docker containers.

while read -r project_dir; do
  if [ -d "$project_dir" ]; then
    echo "Stopping services in $project_dir"
    (cd "$project_dir" && docker compose down)
  else
    echo "Directory $project_dir does not exist. Skipping..."
  fi
done < services.conf
