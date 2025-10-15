#!/bin/bash

# Check if a path argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/git/repo"
    exit 1
fi

REPO_PATH="$1"

# Check if the path is a valid Git repository
if [ ! -d "$REPO_PATH/.git" ]; then
    echo "Error: '$REPO_PATH' is not a valid Git repository."
    exit 1
fi

# Move into the repo path
cd "$REPO_PATH" || exit 1

echo "Fetching repo: $1"
git pull origin
