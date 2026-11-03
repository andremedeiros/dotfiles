#!/usr/bin/env bash
set -e

# omp marketplaces + plugins. omp has no declarative manifest, so this
# hook is the manifest: add marketplaces, then install plugins by
# name@marketplace. Both are idempotent (already-added/installed = noop).
if ! command -v omp >/dev/null 2>&1; then
  echo "WARN: omp not found, skipping (mise install)"
  exit 0
fi

marketplaces=(
  "anthropics/claude-plugins-official"
  "Dammyjay93/interface-design"
  "pbakaus/impeccable"
  "CharlesWiltgen/Axiom"
  "obra/superpowers-marketplace"
  "typesafe-ai/skills"
  "mksglu/context-mode"
  "blader/humanizer"
)

for m in "${marketplaces[@]}"; do
  omp plugin marketplace add "$m" 2>/dev/null || true
done

plugins=(
  "code-modernization@claude-plugins-official"
  "superpowers@superpowers-marketplace"
  "gopls-lsp@claude-plugins-official"
  "github@claude-plugins-official"
  "browser-use@claude-plugins-official"
  "interface-design@interface-design"
  "impeccable@impeccable"
  "axiom@axiom-marketplace"
  "double-shot-latte@superpowers-marketplace"
  "typesafe@typesafe-ai"
  "context-mode@context-mode"
  "humanizer@humanizer"
)

for p in "${plugins[@]}"; do
  omp plugin install "$p" 2>/dev/null || true
done

# npm-based plugins (published to GitHub Packages, not a marketplace).
# @telus/fuelix-omp supersedes the old @fuelix/omp (telus/fuelix-omp-plugin
# on GitHub, more actively maintained). Needs gh authenticated with
# read:packages; skip quietly on a fresh machine where that isn't set up
# yet. Token is refreshed every apply so it can't go stale like a
# hand-pasted one would.
if command -v gh >/dev/null 2>&1 && command -v npm >/dev/null 2>&1; then
  token=$(gh auth token 2>/dev/null) || token=""
  if [ -n "$token" ]; then
    npm config set @telus:registry https://npm.pkg.github.com --location=user 2>/dev/null || true
    npm config set //npm.pkg.github.com/:_authToken "$token" --location=user 2>/dev/null || true
    omp plugin uninstall @fuelix/omp 2>/dev/null || true
    omp plugin install @telus/fuelix-omp 2>/dev/null || true
  fi
fi

# SwiftFairy (Nil Coalescing, https://tools.nilcoalescing.com/swiftfairy/).
# Not published anywhere: the app bundles a Claude-format marketplace
# whose .mcp.json holds a placeholder that the app's own installer fills
# in, and that installer doesn't know about omp. Build a patched copy
# outside the signed bundle and register it as a local marketplace.
# run_onchange only fires when this script changes, so after updating
# SwiftFairy.app re-run this by hand (`bash` it) to refresh the copy.
swiftfairy_app="/Applications/SwiftFairy.app"
swiftfairy_market="$HOME/.omp/local-marketplaces/swiftfairy"
if [ -d "$swiftfairy_app" ]; then
  mkdir -p "$(dirname "$swiftfairy_market")"
  rsync -a --delete "$swiftfairy_app/Contents/Resources/ClaudeMarketplace/" "$swiftfairy_market/"
  sed -i '' "s|__SWIFTFAIRY_STDIO_HELPER__|$swiftfairy_app/Contents/Helpers/swiftfairy-stdio|" \
    "$swiftfairy_market/plugins/swiftfairy/.mcp.json"
  omp plugin marketplace add "$swiftfairy_market" 2>/dev/null || true
  omp plugin install swiftfairy@nilcoalescing-swiftfairy 2>/dev/null || true
else
  echo "WARN: SwiftFairy.app not found, skipping (download from tools.nilcoalescing.com/swiftfairy)"
fi
