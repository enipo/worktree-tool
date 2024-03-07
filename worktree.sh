#!/bin/bash

###################################################################################
# 
# Created by Enipo (https://github.com/enipo)
# 
# This script is used to manage worktrees
# 
# Usage: wo [command] [branch_name]
# Commands:
#   g     - Go back to the main folder
#   c     - Create a worktree for the specified branch
#   r     - Remove the worktree for the specified branch
#   l     - List existing worktrees
#   init  - Initialize worktree
###################################################################################

# Run in init mode
runMode=-1

# Check if .worktrees folder exists run in control mode
if [ -e ".worktrees" ]; then
  runMode=1
# Check if .worktrees folder exists run in parent mode
elif pwd | grep -q .worktrees; then
  runMode=0
fi

# Function to create a new worktree for the specified branch
create_worktree() {
  echo "Select branch to create worktree for:"
  branch_name=$1
  worktree_path=".worktrees"

  if [ -n "$branch_name" ]; then
    sanitized_branch_name=$(echo $branch_name | tr -cd '[:alnum:]._-' | tr '[:upper:]' '[:lower:]')
    worktree_folder="$worktree_path/worktree-$sanitized_branch_name"

    if git show-ref --verify --quiet "refs/heads/$branch_name"; then
      echo "git worktree add $worktree_folder $branch_name"
      git worktree add $worktree_folder $branch_name
      read -p "Do you want to change directory to the created worktree folder? (y/n) " cd_choice
      case "$cd_choice" in
        y|Y )
          cd $worktree_folder
          ;;
        n|N ) ;;
        * ) echo "Invalid choice";;
      esac
      $SHELL
    else
      echo "Branch $branch_name does not exist"
    fi
  else
    echo "No branch selected"
    select_branch
  fi
}

# Function to remove a worktree for the specified branch
remove_worktree() {
  echo "Select branch to remove worktree for:"
  branch_name=$(echo $1 | sed 's/worktree-//')
  worktree_path=".worktrees"

  if [ -n "$branch_name" ]; then
    sanitized_branch_name=$(echo $branch_name | tr -cd '[:alnum:]._-' | tr '[:upper:]' '[:lower:]')
    worktree_folder="$worktree_path/worktree-$sanitized_branch_name"

    if [ -d "$worktree_folder" ]; then
      git worktree remove --force $worktree_folder
    else
      echo "Worktree for branch $branch_name does not exist"
    fi
  else
    echo "No branch selected"
    select_branch_to_remove
  fi
}

# Function to select a branch from the list of available branches
select_branch() {
  selected_branch=$(git branch --format='%(refname:short)' | fzf)

  if [ $? -eq 0 ]; then
    create_worktree $selected_branch
  fi
}

# Function to select a branch from the list of available branches in .worktrees folder
select_branch_to_remove() {
  selected_branch=$(ls -1 .worktrees | fzf)

  if [ $? -eq 0 ]; then
    remove_worktree $selected_branch
  fi
}

# Function to list existing worktrees and select one
select_and_cd_worktree() {
  worktree_path=".worktrees"
  if [ -d "$worktree_path" ] && [ "$(ls -A $worktree_path)" ]; then
    selected_worktree=$(ls -1 $worktree_path | fzf)
    if [ -n "$selected_worktree" ]; then
      cd "$worktree_path/$selected_worktree"
      $SHELL
    fi
  else
    echo "No worktrees found"
  fi
}

# Function to list existing worktrees and select one
list_worktrees() {
  select_and_cd_worktree
}

go_back() {
  cd ../..
  $SHELL
}

initialize_worktree() {
  worktree_path=".worktrees"
  git_folder=".git"
  if [ ! -d "$git_folder" ]; then
    echo "Error: The .git folder does not exist. Please initialize a Git repository first."
    exit 1
  fi

  if [ ! -d "$worktree_path" ]; then
    mkdir "$worktree_path"
    echo "Worktree initialized successfully"
  else
    echo "Worktree is already initialized"
  fi
}

# Function to display help
display_help() {
  echo ""
  echo ".......... ╦ ╦┌─┐┬─┐┬┌─┌┬┐┬─┐┌─┐┌─┐"
  echo "...........║║║│ │├┬┘├┴┐ │ ├┬┘├┤ ├┤ "
  echo "...........╚╩╝└─┘┴└─┴ ┴ ┴ ┴└─└─┘└─┘"
  echo ""
  if [[ $runMode -eq -1 ]]; then
    echo "No project found. Type 'wo init' to initialize."
  elif [[ $runMode -eq 0 ]]; then
    echo "Usage: wo [command] [branch_name]"
    echo ""
    echo "Commands:"
    echo "  g     - Go back to the main folder"
    echo ""
  elif [[ $runMode -eq 1 ]]; then
    echo "Usage: wo [command] [branch_name]"
    echo ""
    echo "Commands:"
    echo "  c [branch_name]   - Create a worktree for the specified branch"
    echo "  r [branch_name]   - Remove the worktree for the specified branch"
    echo "  l                 - List existing worktrees"
    echo "  init              - Initialize worktree"
    echo ""
    if ! command -v fzf &> /dev/null
    then
        echo "fzf is required for branch selection. Please install fzf to use this script."
        read -p "Do you want to install fzf? (y/n) " choice
        case "$choice" in 
          y|Y )
            if [[ $(uname) == "Darwin" ]]; then
              brew install fzf
            elif [[ $(uname) == "Linux" ]]; then
              sudo apt update
              sudo apt install fzf
            else
              echo "Unsupported operating systwo for fzf installation"
            fi
            ;;
          n|N ) ;;
          * ) echo "Invalid choice";;
        esac
    fi
  fi


}

# Check for fzf existence and display help by default
if [ -z "$1" ]; then
  display_help
  exit 1
fi

if [[ $runMode -eq -1 ]]; then
  case $1 in
    init)
      initialize_worktree
      ;;
  esac
elif [[ $runMode -eq 0 ]]; then
  case $1 in
    g)
      go_back
      ;;
    *)
      display_help
      ;;
  esac
elif [[ $runMode -eq 1 ]]; then
  case $1 in
    c)
      create_worktree $2
      ;;
    r)
      remove_worktree $2
      ;;
    l)
      list_worktrees
      ;;
    *)
      display_help
      ;;
  esac
fi
