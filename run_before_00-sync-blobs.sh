#!/usr/bin/env bash
set -e

# rsync iCloud blobs (fonts, licensed assets) into ~. Runs every apply;
# rsync is cheap and idempotent. Blob layout mirrors the target path:
# blobs/Library/Fonts/x.otf -> ~/Library/Fonts/x.otf
ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs/dotfiles"

if [ -d "$ICLOUD/blobs" ]; then
  rsync --recursive "$ICLOUD"/blobs/ ~/

# Fonts rsynced from iCloud aren't always indexed by fontd (e.g. when the
# source files were still dataless placeholders at sync time). Register
# them explicitly so apps see them without a reboot. Idempotent.
if [ -d "$HOME/Library/Fonts" ] && command -v swift >/dev/null; then
  swift -e '
import CoreText
import Foundation
let exts: Set<String> = ["otf", "ttf", "ttc", "dfont"]
let dir = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/Fonts")
for f in (try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)) ?? []
where exts.contains(f.pathExtension.lowercased()) {
    CTFontManagerRegisterFontsForURL(f as CFURL, .user, nil)
}'
fi
fi
