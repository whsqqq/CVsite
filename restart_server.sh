#!/usr/bin/env bash
# Restart helper script for different server types.
# Usage: ./restart_server.sh passenger [/path/to/project]
#        ./restart_server.sh systemd SERVICE_NAME
#        ./restart_server.sh docker-compose PATH_TO_COMPOSE_DIR

set -euo pipefail

cmd=${1-}
arg2=${2-}

if [ -z "$cmd" ]; then
  echo "Usage: $0 <passenger|systemd|gunicorn|docker-compose> [args]"
  exit 1
fi

case "$cmd" in
  passenger)
    # touch .restart-app in project root (arg2 optional)
    project_root=${arg2:-$(pwd)}
    touch "$project_root/.restart-app"
    echo "Touched $project_root/.restart-app — Passenger should restart the app."
    ;;
  systemd)
    if [ -z "$arg2" ]; then
      echo "systemd requires a service name: $0 systemd your-service"
      exit 1
    fi
    echo "Restarting systemd service: $arg2"
    sudo systemctl restart "$arg2"
    ;;
  gunicorn)
    # expects service name or PID file path
    if [ -z "$arg2" ]; then
      echo "gunicorn requires a service name or PID file: $0 gunicorn your-service-or-pidfile"
      exit 1
    fi
    # Try systemctl first
    if systemctl --user status "$arg2" >/dev/null 2>&1 || sudo systemctl status "$arg2" >/dev/null 2>&1; then
      echo "Restarting gunicorn service via systemctl: $arg2"
      sudo systemctl restart "$arg2" || systemctl --user restart "$arg2"
    else
      # Attempt to kill by pidfile
      if [ -f "$arg2" ]; then
        pid=$(cat "$arg2")
        echo "Killing pid $pid and letting process manager restart it"
        kill -TERM "$pid" || kill -9 "$pid" || true
      else
        echo "Could not find systemd service or pidfile; try restarting manually."
        exit 1
      fi
    fi
    ;;
  docker-compose)
    # arg2 = path to compose dir
    compose_dir=${arg2:-$(pwd)}
    echo "Restarting docker-compose in $compose_dir"
    docker-compose -f "$compose_dir/docker-compose.yml" down && docker-compose -f "$compose_dir/docker-compose.yml" up -d
    ;;
  *)
    echo "Unknown command: $cmd"
    exit 2
    ;;
esac

exit 0
