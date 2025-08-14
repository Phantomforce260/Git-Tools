#!/bin/bash

REPOS=(
  "${HOME}/Documents/Github/LunarFlame-Website"
  "${HOME}/Documents/Github/Lunar-Blog"
  "${HOME}/Documents/Github/Sopa-Website"
  "${HOME}/.config/hypr"
  "${HOME}/.config/waybar"
  "${HOME}/.config/nvim"
  "${HOME}/Documents/Github/CS3043-Website"
  "${HOME}/Documents/Projects/video_call"
)

USER_ACTION=""


SUMMARY_SCRIPT="./summary/git_summary.sh"
FETCH_SCRIPT="./pull/git_pull.sh"

# Check if the git tool script exists
if [ ! -x "$SUMMARY_SCRIPT" ]; then
  echo "Error: Summary script '$SUMMARY_SCRIPT' not found or not executable."
  exit 1
elif [ ! -x "$FETCH_SCRIPT" ]; then
  echo "Error: Fetch script '$FETCH_SCRIPT' not found or not executable."
  exit 1
fi

echo "What would you like to do?"
echo "1) Pull all repositories"
echo "2) Check the status of all repositories"

read -p "" USER_ACTION

# Check each option
if [ "$USER_ACTION" = "1" ]; then
    echo "Fetching all repositories..."
    
    for REPO in "${REPOS[@]}"; do
        "$FETCH_SCRIPT" "$REPO"
    done
    
elif [ "$USER_ACTION" = "2" ]; then
    echo "Getting the status of all repositories..."

    # Loop through each repository and call the summary script
    for REPO in "${REPOS[@]}"; do
      echo -e "\n==================================================="
      echo "Checking repository at: $REPO"
      echo "==================================================="
      "$SUMMARY_SCRIPT" "$REPO"
    done
fi
