#!/bin/sh
set -eu

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <codex|claude|cursor|grok|human> <task-name>" >&2
  exit 2
fi

task_owner=$1
task_slug=$2
case "$task_owner" in codex|claude|cursor|grok|human) ;; *) exit 2 ;; esac
case "$task_slug" in ''|*[!a-z0-9-]*|-*|*-) exit 2 ;; esac

task_repo_root=$(git worktree list --porcelain | awk 'NR == 1 { sub(/^worktree /, ""); print; exit }')
task_parent=${MEDPHOTO_WORKTREE_ROOT:-"$(dirname "$task_repo_root")/CamLink-Vault-worktrees"}
task_branch="$task_owner/$task_slug"
task_path="$task_parent/$task_owner-$task_slug"

git -C "$task_repo_root" fetch origin main
if git -C "$task_repo_root" show-ref --verify --quiet "refs/heads/$task_branch" ||
   git -C "$task_repo_root" ls-remote --exit-code --heads origin "$task_branch" >/dev/null 2>&1; then
  echo "Branch already exists: $task_branch" >&2
  exit 1
fi
if [ -e "$task_path" ]; then echo "Path already exists: $task_path" >&2; exit 1; fi

mkdir -p "$task_parent"
git -C "$task_repo_root" worktree add -b "$task_branch" "$task_path" origin/main
echo "Created $task_branch from origin/main"
echo "Worktree: $task_path"
