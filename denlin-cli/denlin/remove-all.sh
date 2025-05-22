#!/bin/bash
# Menu: Docker Management
# Description: Removes all Docker containers from memory.

# Remove all Docker containers
docker rm $(docker ps -a -q)
echo "All Docker containers have been removed."
