#!/bin/sh
set -eu

task_source_root=$(git rev-parse --show-toplevel)
task_common_dir=$(git rev-parse --path-format=absolute --git-common-dir)
task_hook_dir="$task_common_dir/medphoto-hooks"
task_existing_hooks=$(git config --get core.hooksPath || true)

if [ -n "$task_existing_hooks" ] && [ "$task_existing_hooks" != "$task_hook_dir" ]; then
  echo "Refusing to replace existing core.hooksPath: $task_existing_hooks" >&2
  exit 1
fi

mkdir -p "$task_hook_dir"
cp "$task_source_root/.githooks/pre-push" "$task_hook_dir/pre-push"
chmod 0755 "$task_hook_dir/pre-push"
git config core.hooksPath "$task_hook_dir"
git config pull.ff only
git config fetch.prune true
git config push.default simple

echo "Med Photo Vault git safety enabled for this clone."
