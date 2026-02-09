#!/bin/bash
# Restart all Docker containers in the Rainhold stacks directory
# This script is run once, 10 minutes after system boot

DOCKER_DIR="$1"

if [ -z "$DOCKER_DIR" ]; then
    echo "Usage: $0 <docker-directory>"
    exit 1
fi

if [ ! -d "$DOCKER_DIR" ]; then
    echo "Directory not found: $DOCKER_DIR"
    exit 1
fi

echo "$(date): Starting Docker container restart for $DOCKER_DIR"

for dir in "$DOCKER_DIR"/*/; do
    if [ -f "$dir/compose.yml" ]; then
        echo "$(date): Restarting containers in $dir"
        cd "$dir"
        docker compose down
        docker compose up -d
    fi
done

echo "$(date): Docker container restart complete"
