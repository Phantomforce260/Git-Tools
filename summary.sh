#!/bin/bash

# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'

# No Color
NC='\033[0m' 

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

# Get the repository name
REPO_NAME=$(basename "$(git rev-parse --show-toplevel)")

git add .

# Get uncommitted changes with rename detection
CHANGES=$(git status --porcelain -M)

# Arrays to store files by status
ADDED_FILES=()
MODIFIED_FILES=()
DELETED_FILES=()

# Parse changes
while IFS= read -r line; do
  STATUS=${line:0:2}
  ENTRY=${line:3}

  case "$STATUS" in
    R*)
      OLD_NAME=$(echo "$ENTRY" | awk -F ' -> ' '{print $1}')
      NEW_NAME=$(echo "$ENTRY" | awk -F ' -> ' '{print $2}')
      MODIFIED_FILES+=("$OLD_NAME --> $NEW_NAME")
      ;;
    A*|*A)
      ADDED_FILES+=("$ENTRY")
      ;;
    M*|*M)
      MODIFIED_FILES+=("$ENTRY")
      ;;
    D*|*D)
      DELETED_FILES+=("$ENTRY")
      ;;
  esac
done <<< "$CHANGES"

git restore --staged .

# Output the result
echo "${REPO_NAME}:"

# Added Files
if [ ${#ADDED_FILES[@]} -gt 0 ]; then
  echo -e "    ${#ADDED_FILES[@]} ${GREEN}Added Files:${NC}"
  for file in "${ADDED_FILES[@]}"; do
    echo "        + $file"
  done
else
  echo -e "    0 ${GREEN}Added Files:${NC}"
  echo "        (none)"
fi

# Modified Files
if [ ${#MODIFIED_FILES[@]} -gt 0 ]; then
  echo -e "    ${#MODIFIED_FILES[@]} ${YELLOW}Modified Files:${NC}"
  for file in "${MODIFIED_FILES[@]}"; do
    echo "        ~ $file"
  done
else
  echo -e "    0 ${YELLOW}Modified Files:${NC}"
  echo "        (none)"
fi

# Deleted Files
if [ ${#DELETED_FILES[@]} -gt 0 ]; then
  echo -e "    ${#DELETED_FILES[@]} ${RED}Deleted Files:${NC}"
  for file in "${DELETED_FILES[@]}"; do
    echo "        - $file"
  done
else
  echo -e "    0 ${RED}Deleted Files:${NC}"
  echo "        (none)"
fi
