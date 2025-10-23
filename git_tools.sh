#!/bin/bash


GITHUB="${HOME}/Documents/Github"
CONFIG="${HOME}/.config"


LFS="${GITHUB}/LFS"
PERSONAL="${GITHUB}/Phantom"
COLLABS="${GITHUB}/Collabs"

PROJECTS="${HOME}/Documents/Projects"

REPOS=(
  "${LFS}/LunarFlame-Website"
  "${LFS}/Static-Files"
  "${LFS}/Lunar-Blog"
  "${PERSONAL}/Sopa-Website"
  "${PERSONAL}/Portfolio"
  "${CONFIG}/hypr"
  "${CONFIG}/waybar"
  "${CONFIG}/nvim"
  "${COLLABS}/video_call"

  "${PERSONAL}/comm-site"
)

TOOLS_DIR="${PERSONAL}/Git-Tools"

USER_ACTION=""

SUMMARY_SCRIPT="${TOOLS_DIR}/summary.sh"
FETCH_SCRIPT="${TOOLS_DIR}/pull.sh"
RESET_SCRIPT="${TOOLS_DIR}/reset.sh"

# Check if the git tool script exists
if [ ! -x "$SUMMARY_SCRIPT" ]; then
  echo "Error: Summary script '$SUMMARY_SCRIPT' not found or not executable."
  exit 1
elif [ ! -x "$FETCH_SCRIPT" ]; then
  echo "Error: Fetch script '$FETCH_SCRIPT' not found or not executable."
  exit 1
elif [ ! -x "$RESET_SCRIPT" ]; then
  echo "Error: Fetch script '$RESET_SCRIPT' not found or not executable."
  exit 1
fi

pull() {
    echo "Fetching all repositories..."

    for REPO in "${REPOS[@]}"; do
        bash "$FETCH_SCRIPT" "$REPO"
    done
}

summary() {
    echo "Getting the status of all repositories..."

    # Loop through each repository and call the summary script
    for REPO in "${REPOS[@]}"; do
        echo -e "\n========================================================="
        echo "Checking repository at: ~/${REPO#/home/adrian/}"
        echo "========================================================="
        bash "$SUMMARY_SCRIPT" "$REPO"
    done
}

reset-repo() {
    echo
    if [ -z "$1" ]; then
        "$RESET_SCRIPT"
    else
        "$RESET_SCRIPT" "$1"
    fi
}

reset-lfs() {
    echo
    bash "$RESET_SCRIPT" "lfs"
}

if [ -z "$1" ]; then
    echo "What would you like to do?"
    echo "1) Pull all repositories"
    echo "2) Check the status of all repositories"
    echo "3) Reset a repository"
    echo "    3a) Skip confirmation (-y)"
    echo "    3b) Reset LunarFlame Studios web repositories"

    read -p "" USER_ACTION

    # Check each option
    if [ "$USER_ACTION" = "1" ]; then
        pull
    elif [ "$USER_ACTION" = "2" ]; then
        summary
    elif [ "$USER_ACTION" = "3" ]; then
        reset-repo
    elif [ "$USER_ACTION" = "3a" ]; then
        reset-repo -y
    elif [ "$USER_ACTION" = "3b" ]; then
        reset-lfs
    fi
else
    if [[ "$1" == "reset" ]]; then
        if [[ "$2" == "lfs" ]]; then
            reset-lfs
        elif [[ "$2" == "-y" ]]; then
            reset-repo "-y"
        else
            reset-repo
        fi
    elif [[ "$1" == "pull" ]]; then
        pull
    elif [[ "$1" == "summary" ]]; then
        summary
    fi
fi
