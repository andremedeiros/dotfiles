#!/usr/bin/env bash
set -e

if [ "$SHELL" != "$HOMEBREW_PREFIX/bin/fish" ]; then
  grep -qx "$HOMEBREW_PREFIX/bin/fish" /etc/shells || echo "$HOMEBREW_PREFIX/bin/fish" | sudo tee -a /etc/shells
  sudo dscl . -create /Users/"$USER" UserShell $HOMEBREW_PREFIX/bin/fish
fi

# fisher and fish_config are fish builtins — invoke via fish -c
fish -c 'fisher install jethrokuan/z' || true
fish -c 'fish_config theme choose "ayu Dark"; fish_config theme save' || true
