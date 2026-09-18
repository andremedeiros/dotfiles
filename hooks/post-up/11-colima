#!/usr/bin/env bash
set -e

# start colima at login via brew services (launchd)
if ! command -v colima >/dev/null 2>&1; then
  echo "WARN: colima not found, skipping (run: brew bundle --global)"
  exit 0
fi

# idempotent: ignore "already bootstrapped" when the agent is registered
brew services start colima 2>/dev/null || brew services list | grep -q '^colima'
# Point /var/run/docker.sock at colima's socket so docker clients and
# testcontainers autodetect it without DOCKER_HOST or properties files.
# Ryuk mounts /var/run/docker.sock into the reaper container, which is
# the real socket inside the colima VM — so this also fixes reaping.
# Created unconditionally: a dangling symlink resolves once colima's
# VM boots and creates the socket.
SOCK="$HOME/.colima/default/docker.sock"
if [ "$(readlink /var/run/docker.sock 2>/dev/null)" != "$SOCK" ]; then
  sudo ln -sfn "$SOCK" /var/run/docker.sock
fi
