#!/usr/bin/env bash
set -e

# Give ~/Code the Developer folder icon (hammer) — the closest
# built-in "code" icon. Extracts from CoreTypes, applies via
# NSWorkspace, cleans up.
CODE_DIR="${HOME}/Code"
[ -d "$CODE_DIR" ] || exit 0

ICON_SRC="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/DeveloperFolderIcon.icns"
ICON_PNG="$(mktemp -t codeicon).png"
trap 'rm -f "$ICON_PNG"' EXIT

sips -s format png "$ICON_SRC" --out "$ICON_PNG" >/dev/null 2>&1 || exit 0

osascript \
  -e 'use framework "AppKit"' \
  -e "set img to current application's NSImage's alloc()'s initWithContentsOfFile:\"$ICON_PNG\"" \
  -e "current application's NSWorkspace's sharedWorkspace()'s setIcon:img forFile:\"$CODE_DIR\" options:0" \
  >/dev/null 2>&1 || true
