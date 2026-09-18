#!/usr/bin/env bash
set -e

# ____  ___               .___
# \   \/  /____  ____   __| _/____
#  \     // ___\/  _ \ / __ |/ __ \
#  /     \  \__(  <_> ) /_/ \  ___/
# /___/\  \___  >____/\____ |\___  >
#       \_/   \/           \/    \/

# accept license and trigger xcode developer tool download (needs sudo;
# skipped non-interactively — run once by hand if it warns)
sudo -n xcodebuild -license accept 2>/dev/null || echo "WARN: sudo xcodebuild -license accept needs a password"

#                       ________    _________
#   _____ _____    ____ \_____  \  /   _____/
#  /     \\__  \ _/ ___\ /   |   \ \_____  \
# |  Y Y  \/ __ \\  \___/    |    \/        \
# |__|_|  (____  /\___  >_______  /_______  /
#       \/     \/     \/        \/        \/

# disable key hold popup
defaults write -g ApplePressAndHoldEnabled -bool false

# make repetitions super fast — System Settings writes these as
# ticks in NSGlobalDomain (15 ticks ≈ 250ms delay, 2 ticks ≈ 33ms
# interval); com.apple.Accessibility keys are ignored
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain KeyRepeat -int 2

# remove stale repeat keys an earlier version of this script wrote
# to com.apple.Accessibility — not the store System Settings uses
defaults delete com.apple.Accessibility KeyRepeatDelay 2>/dev/null || true
defaults delete com.apple.Accessibility KeyRepeatInterval 2>/dev/null || true
defaults delete com.apple.Accessibility KeyRepeatEnabled 2>/dev/null || true

# map caps lock to escape on every keyboard. same per-device store
# System Settings writes; applies on next login. keyboards attached
# later need a script re-run or the System Settings toggle.
while read -r vid pid; do
  defaults -currentHost write -g "com.apple.keyboard.modifiermapping.${vid}-${pid}-0" -array \
    '{"HIDKeyboardModifierMappingSrc" = 30064771129; "HIDKeyboardModifierMappingDst" = 30064771113;}'
done < <(ioreg -r -c IOHIDEventDriver -d 1 | awk '
  /^\+-o/ { if (drv && vid != "" && pid != "") print vid, pid; drv = ($0 ~ /Keyboard/); vid = ""; pid = "" }
  drv && /"VendorID" =/  { vid = $3 }
  drv && /"ProductID" =/ { pid = $3 }
  END { if (drv && vid != "" && pid != "") print vid, pid }
')

# dock goes on the left
defaults write com.apple.dock orientation -string left

# disable automatic capitalization and smart quotes as they're annoying when writing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# use a dark menu bar and dock
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# tap to click, please
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# don't open photos.app every time I plug in a device
defaults write com.apple.ImageCapture disableHotPlug -bool YES

# free up cmd+space for raycast: disable spotlight (64) and
# finder search window (65) hotkeys. Raycast's own hotkey is set
# once in its settings (stored internally, not in defaults).
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null || \
  /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:64:enabled bool false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:65:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null || \
  /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:65:enabled bool false" ~/Library/Preferences/com.apple.symbolichotkeys.plist

# automatically hide and show the dock
defaults write com.apple.Dock autohide -bool true

# show the dock quickly
defaults write com.apple.Dock autohide-delay -float 0

# hide recent applications
defaults write com.apple.Dock show-recents -bool false

# expand save dialog by default
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

# only show scrollbar when scrolling
defaults write -g AppleShowScrollBars -string "WhenScrolling"

# don't write .DS_Store
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

#   _________              __  .__  .__       .__     __
#  /   _____/_____   _____/  |_|  | |__| ____ |  |___/  |_
#  \_____  \\____ \ /  _ \   __\  | |  |/ ___\|  |  \   __\
#  /        \  |_> >  <_> )  | |  |_|  / /_/  >   Y  \  |
# /_______  /   __/ \____/|__| |____/__\___  /|___|  /__|
#         \/|__|                      /_____/      \/

# be selective on things we do index
defaults write com.apple.spotlight orderedItems -array \
  '{"enabled" = 1;"name" = "APPLICATIONS";}' \
  '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
  '{"enabled" = 1;"name" = "DIRECTORIES";}' \
  '{"enabled" = 0;"name" = "PDF";}' \
  '{"enabled" = 0;"name" = "FONTS";}' \
  '{"enabled" = 0;"name" = "DOCUMENTS";}' \
  '{"enabled" = 0;"name" = "MESSAGES";}' \
  '{"enabled" = 0;"name" = "CONTACT";}' \
  '{"enabled" = 0;"name" = "EVENT_TODO";}' \
  '{"enabled" = 0;"name" = "IMAGES";}' \
  '{"enabled" = 0;"name" = "BOOKMARKS";}' \
  '{"enabled" = 0;"name" = "MUSIC";}' \
  '{"enabled" = 0;"name" = "MOVIES";}' \
  '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
  '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
  '{"enabled" = 0;"name" = "SOURCE";}' \
  '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
  '{"enabled" = 0;"name" = "MENU_OTHER";}' \
  '{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
  '{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
  '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
  '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

# ________                 __                .__
# \______ \   _______  ___/  |_  ____   ____ |  |   ______
#  |    |  \_/ __ \  \/ /\   __\/  _ \ /  _ \|  |  /  ___/
#  |    `   \  ___/\   /  |  | (  <_> |  <_> )  |__\___ \
# /_______  /\___  >\_/   |__|  \____/ \____/|____/____  >
#         \/     \/                                    \/
sudo -n /usr/sbin/DevToolsSecurity --enable 2>/dev/null || echo "WARN: DevToolsSecurity needs a password"

# and we're done
apps=()
apps=("${apps[@]}" "corespotlightd")
apps=("${apps[@]}" "Safari")

for app in "${apps[@]}"; do
  killall "${app}" &> /dev/null || true
done
