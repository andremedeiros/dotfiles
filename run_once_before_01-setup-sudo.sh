#!/usr/bin/env bash
set -e

banner="%wheel ALL=(ALL) NOPASSWD: ALL #andremedeiros/dotfiles"

if sudo -n grep -q "${banner}" /etc/sudoers 2>/dev/null; then
  exit 0
fi

if ! sudo -n true 2>/dev/null; then
  echo "WARN: passwordless sudo not configured and sudo needs a password."
  echo "      Re-run 'chezmoi apply' interactively to set it up."
  exit 0
fi

echo "$banner" | sudo tee -a /etc/sudoers > /dev/null
sudo dscl . append /Groups/wheel GroupMembership "$(whoami)"
