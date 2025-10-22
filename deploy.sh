#!/usr/bin/env bash
# Simple helper script to run on the server to update and deploy the project.
# Edit variables below to match your environment before running.

set -euo pipefail

PROJECT_DIR="/path/to/your/site"   # <- change me (e.g. /var/www/u123456/data/www/mikhailkondratev.ru)
VENV_DIR="$PROJECT_DIR/venv"
PYTHON_BIN="$VENV_DIR/bin/python"
PIP_BIN="$VENV_DIR/bin/pip"
BRANCH="main"

echo "Entering project dir: $PROJECT_DIR"
cd "$PROJECT_DIR"

# Pull latest code
if [ -d .git ]; then
  git fetch origin
  git checkout $BRANCH
  git pull origin $BRANCH
fi

# Create venv if missing
if [ ! -d "$VENV_DIR" ]; then
  echo "Creating virtualenv using system python3"
  python3 -m venv "$VENV_DIR"
fi

# Activate
source "$VENV_DIR/bin/activate"

# Install deps
$PIP_BIN install --upgrade pip
$PIP_BIN install -r requirements.txt

# Load environment variables from .env if present
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

# Collect static and migrate
$PYTHON_BIN manage.py collectstatic --noinput
$PYTHON_BIN manage.py migrate --noinput

# Restart passenger (create .restart-app file)
touch .restart-app

echo "Deployment finished. Check logs if something failed."
