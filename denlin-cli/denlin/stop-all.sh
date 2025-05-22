#!/bin/bash
# Menu: Docker Management
# Description: Stops all Docker containers.

# Stop all Docker containers
docker stop $(docker ps -a -q)
echo "All Docker containers have been stopped."
