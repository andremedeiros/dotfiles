#!/usr/bin/env bash
set -e

echo "==> Validating Neovim installation..."

# Check Neovim is available
if ! command -v nvim >/dev/null 2>&1; then
  echo "ERROR: Neovim not found in PATH"
  echo "Run: brew bundle --global"
  exit 1
fi

# Check version (LazyVim v15.x requires >= 0.11.2)
NVIM_VERSION=$(nvim --version | head -n1 | awk '{print $2}' | sed 's/v//')
REQUIRED_VERSION="0.11.2"

version_compare() {
  printf '%s\n' "$1" "$2" | sort -V | head -n1
}

if [ "$(version_compare "$REQUIRED_VERSION" "$NVIM_VERSION")" != "$REQUIRED_VERSION" ]; then
  echo "ERROR: Neovim $NVIM_VERSION is too old. Need >= $REQUIRED_VERSION"
  echo "Run: brew upgrade neovim"
  exit 1
fi

echo "OK: Neovim $NVIM_VERSION installed"

# Check LazyVim dependencies
DEPS_OK=true
for cmd in rg fd tree-sitter; do
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "OK: $cmd installed"
  else
    echo "WARN: $cmd not found (required for LazyVim)"
    DEPS_OK=false
  fi
done

if [ "$DEPS_OK" = false ]; then
  echo ""
  echo "Missing dependencies. Run: brew bundle --global"
fi

echo ""
echo "==> LazyVim setup instructions:"
echo "    1. Run 'nvim' to bootstrap plugins on first launch"
echo "    2. Wait for plugin installation to complete"
echo "    3. Run ':checkhealth' to validate full installation"
