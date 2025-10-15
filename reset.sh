#!/bin/bash


clean-repo() {
    git checkout .
    git clean -fd
    echo "Changes removed."
}

input=""

if [[ ! -d .git ]]; then
    echo "Not in the root of a Git repository. Aborting."

elif [[ "$1" == "lfs" ]]; then

    current_cwd=$(pwd)
    echo "This will discard all unsaved changes in:"
    echo 
    echo "    - LunarFlame-Website"
    echo "    - Static-Files"
    echo 

    read -p "Are you sure? [yn]: " input

    #This is zsh code
    #read "input?Are you sure? [yn]: "

    if [[ "$input" == "y" ]]; then
        cd "$HOME/Documents/Github/LFS/LunarFlame-Website"
        echo
        echo "LunarFlame-Website:"
        clean-repo

        cd "$HOME/Documents/Github/LFS/Static-Files"
        echo
        echo "Static-Files:"
        clean-repo
    else
        echo "Aborted."
    fi

    cd "$current_cwd"

elif [[ "$1" == "-y" ]]; then
    clean-repo

else
    echo "This will discard all unsaved changes. You must be in the root of the repo to do this."
    read -p "Are you sure? [yn]: " input

    #This is zsh code
    #read "input?Are you sure? [yn]: "
    
    if [[ "$input" == "y" ]]; then
        clean-repo
    else
        echo "Aborted."
    fi
fi
