#!/bin/bash

set -euo pipefail

if [ "$#" -gt 1 ]; then
    echo "Usage: $0 [docker-directory]" >&2
    exit 1
fi

DOCKER_DIR="${1:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/docker}"

if [ ! -d "$DOCKER_DIR" ]; then
    echo "Directory not found: $DOCKER_DIR" >&2
    exit 1
fi

if [ "$EUID" -ne 0 ]; then
    exec sudo bash "${BASH_SOURCE[0]}" "$@"
fi

trap 'echo "Update failed (exit $?) in $PWD: $BASH_COMMAND" >&2' ERR

cd -- "$DOCKER_DIR"
FOUND_PROJECT=false

for dir in */; do
    if [ ! -f "$dir/compose.yaml" ] && [ ! -f "$dir/compose.yml" ] &&
       [ ! -f "$dir/docker-compose.yaml" ] && [ ! -f "$dir/docker-compose.yml" ]; then
        continue
    fi

    FOUND_PROJECT=true
    echo "Updating $dir"
    cd -- "$dir"
    docker compose pull
    docker compose down
    docker compose up -d
    cd ..
done

if [ "$FOUND_PROJECT" = false ]; then
    echo "No Compose projects found in $DOCKER_DIR" >&2
    exit 1
fi

echo "All Compose projects updated."
