#!/usr/bin/env bash
# Safely remove tracked virtualenv directories from git history (stops tracking them)
# Usage: run from the repository root: ./git-remove-venv.sh venv

set -euo pipefail
if [ $# -lt 1 ]; then
  echo "Usage: $0 <venv-dir-name> [<venv-dir-name> ...]"
  echo "Example: $0 venv .venv djangoenv"
  exit 1
fi

for v in "$@"; do
  echo "Removing tracked files under: $v"
  git rm -r --cached "$v" || true
done

echo "Committing the removal and updating .gitignore if necessary"

git add .gitignore || true
GIT_MSG="Remove virtualenv dirs from tracking"

git commit -m "$GIT_MSG" || echo "Nothing to commit"

echo "Push your commit to update remote repo: git push"

echo "Done. Virtualenv directories will now be ignored by git if present in .gitignore."
