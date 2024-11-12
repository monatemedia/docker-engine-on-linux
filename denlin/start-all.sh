#!/bin/bash
while read -r project_dir; do
  if [ -d "$project_dir" ]; then
    echo "Starting services in $project_dir"
    (cd "$project_dir" && docker compose up -d)
  else
    echo "Directory $project_dir does not exist. Skipping..."
  fi
done < services.conf
