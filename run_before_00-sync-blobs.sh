#!/usr/bin/env bash
set -e

# rsync iCloud blobs (fonts, licensed assets) into ~. Runs every apply;
# rsync is cheap and idempotent. Blob layout mirrors the target path:
# blobs/Library/Fonts/x.otf -> ~/Library/Fonts/x.otf
ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs/dotfiles"

if [ -d "$ICLOUD/blobs" ]; then
  rsync --recursive "$ICLOUD"/blobs/ ~/
fi
