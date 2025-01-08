#!/bin/bash
# Menu: Docker Management
# Description: Starts all Docker containers.

while read -r project_dir; do
    if [ -d "$project_dir" ]; then
        echo "Starting services in $project_dir..."
        if (cd "$project_dir" && docker compose up -d); then
            echo "Services in $project_dir started successfully."
        else
            echo "Failed to start services in $project_dir."
        fi
    else
        echo "Directory $project_dir does not exist. Skipping..."
    fi
done < "$(dirname "$(realpath "$0")")/../services.conf"
