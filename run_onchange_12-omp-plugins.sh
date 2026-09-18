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
)

for m in "${marketplaces[@]}"; do
  omp plugin marketplace add "$m" 2>/dev/null || true
done

plugins=(
  "code-modernization@claude-plugins-official"
  "superpowers@claude-plugins-official"
  "gopls-lsp@claude-plugins-official"
  "github@claude-plugins-official"
  "browser-use@claude-plugins-official"
  "interface-design@interface-design"
  "impeccable@impeccable"
)

for p in "${plugins[@]}"; do
  omp plugin install "$p" 2>/dev/null || true
done
