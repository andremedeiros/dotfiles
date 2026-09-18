#!/usr/bin/env bash
set -e

[ -L "${HOME}/.icloud" ] || ln -s ~/Library/Mobile\ Documents/com~apple~CloudDocs ~/.icloud

# ~/src -> ~/Code: Finder shows "Code" (nicer name), terminal keeps
# working with ~/src. The symlink is hidden from Finder.
if [ ! -d "${HOME}/Code" ] && [ -d "${HOME}/src" ]; then
  mv "${HOME}/src" "${HOME}/Code"
fi
if [ -d "${HOME}/Code" ] && [ ! -e "${HOME}/src" ]; then
  ln -s "${HOME}/Code" "${HOME}/src"
  chflags -h hidden "${HOME}/src" 2>/dev/null || true
fi
