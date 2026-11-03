#!/usr/bin/env bash
set -e

if [ "$SHELL" != "$HOMEBREW_PREFIX/bin/fish" ]; then
  grep -qx "$HOMEBREW_PREFIX/bin/fish" /etc/shells || echo "$HOMEBREW_PREFIX/bin/fish" | sudo tee -a /etc/shells
  sudo dscl . -create /Users/"$USER" UserShell $HOMEBREW_PREFIX/bin/fish
fi

# fish_config is a fish builtin — invoke via fish -c
fish -c 'fish_config theme choose "ayu Dark"; fish_config theme save' || true
