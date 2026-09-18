#!/usr/bin/env bash
set -e

# fetch remote vale packages (vale.ini Packages = ...) into ~/.styles
if ! command -v vale >/dev/null 2>&1; then
  echo "WARN: vale not found, skipping vale sync (run: brew bundle --global)"
  exit 0
fi

# vale resolves StylesPath relative to the vale.ini it finds in cwd;
# run from $HOME so it picks up ~/.vale.ini and syncs into ~/.styles
cd "$HOME" && vale sync
