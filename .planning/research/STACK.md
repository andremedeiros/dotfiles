# Stack Research

**Domain:** LazyVim Configuration for Dotfiles
**Researched:** 2026-02-03
**Confidence:** HIGH

## Recommended Stack

### Core Technologies

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| Neovim | >= 0.11.2 | Modern Vim-based editor | Required by LazyVim; built with LuaJIT for performance. 0.11+ includes native LSP configuration mechanisms. |
| LazyVim | v15.13.0+ | Neovim distribution | Provides pre-configured, extensible setup with sensible defaults. Actively maintained (Nov 2025 release). |
| lazy.nvim | v11.17.5+ | Plugin manager | Auto-caching, lazy-loading, lockfile support. Required by LazyVim. Mature and performant. |
| Git | >= 2.19.0 | Version control | Required for lazy.nvim partial clone support. Already used by rcm. |

### Supporting Tools

| Tool | Version | Purpose | When to Use |
|------|---------|---------|-------------|
| ripgrep | Latest | Fast text search | Required for Telescope file/text searching. Already in ecosystem. |
| fd | Latest | Fast file finder | Alternative to find for Telescope. Better performance and UX. |
| lazygit | Latest | Terminal Git UI | Optional. Provides TUI for Git operations within LazyVim. |
| tree-sitter-cli | Latest | Parser generator | Optional. Enables local parser compilation for languages not pre-built. |
| C compiler | System | Native code compilation | Required for nvim-treesitter to compile language parsers. |
| Nerd Font | Any | Icon support | Optional but recommended. Enables pretty icons in UI. Already using Hack Nerd Font. |

### LSP/Language Infrastructure

| Component | Purpose | Installation Method |
|-----------|---------|---------------------|
| mason.nvim | LSP/DAP/linter manager | Bundled with LazyVim |
| mason-lspconfig.nvim | Bridge mason + lspconfig | Bundled with LazyVim |
| nvim-lspconfig | LSP client configs | Bundled with LazyVim |
| nvim-treesitter | Syntax highlighting | Bundled with LazyVim |

**Language servers installed via Mason UI:**
- Run `:Mason` after first launch
- Install servers as needed (lua_ls, ts_ls, pyright, gopls, etc.)
- Mason handles all dependencies and PATH configuration

## Installation Approach

### Recommended: LazyVim Starter Template

**Method:** Clone starter, customize structure
**Why:** Provides correct file layout, bootstrap code, and update path

```bash
# In rcm dotfiles: config/nvim/
git clone https://github.com/LazyVim/starter.git tmp-starter
cp -R tmp-starter/* config/nvim/
rm -rf tmp-starter
rm -rf config/nvim/.git  # Use your own version control
```

**Rationale:**
- Ensures correct `init.lua` bootstrap
- Provides proper `lua/config/` and `lua/plugins/` structure
- Easier to track upstream LazyVim updates
- Starter is designed to be customized, not forked

### Alternative: Manual Setup

**Method:** Add LazyVim to custom lazy.nvim config
**Why Not:** More complex, requires understanding bootstrap sequence

Use starter unless you have specific constraints or deep Lua configuration experience.

## File Structure (rcm Context)

LazyVim expects this structure in `~/.config/nvim/`:

```
config/nvim/                 # In dotfiles repo
├── init.lua                 # Bootstrap lazy.nvim and LazyVim
├── lua/
│   ├── config/
│   │   ├── autocmds.lua     # Custom autocommands
│   │   ├── keymaps.lua      # Custom keybindings (Space leader preserved)
│   │   ├── lazy.lua         # Plugin manager setup
│   │   └── options.lua      # Neovim options
│   └── plugins/
│       └── *.lua            # Plugin customizations (one file per plugin/feature)
└── lazy-lock.json           # Plugin versions (commit to dotfiles)
```

**RCM integration:**
- rcm symlinks `dotfiles/config/nvim` → `~/.config/nvim`
- LazyVim auto-loads all files in `lua/config/` and `lua/plugins/`
- No manual `require()` statements needed

## Post-Install Hook Script

Create `hooks/post-up/03-lazyvim-setup`:

```bash
#!/usr/bin/env bash
set -e

nvim_root="${HOME}/.config/nvim"

# Ensure LazyVim directories exist (rcup creates symlinks)
if [ -d "${nvim_root}" ]; then
  echo "Installing LazyVim plugins..."
  # Run headless to install plugins, then quit
  nvim --headless "+Lazy! sync" +qa

  echo "Running LazyVim health checks..."
  nvim --headless "+checkhealth lazy" +qa
fi
```

**Why this approach:**
- Idempotent (safe to run multiple times)
- Installs plugins automatically after rcup
- Runs health checks to verify setup
- Non-interactive (suitable for automation)

## Alternatives Considered

| Category | Recommended | Alternative | When to Use Alternative |
|----------|-------------|-------------|-------------------------|
| Installation | LazyVim Starter | Manual lazy.nvim setup | You want complete control over every plugin and config detail |
| Plugin Manager | lazy.nvim | packer.nvim, vim-plug | Never. lazy.nvim is superior in every way (performance, UX, features) |
| Distribution | LazyVim | NvChad, AstroNvim, LunarVim | You prefer different default aesthetics/keybinds, but LazyVim is most actively maintained |
| LSP Manager | mason.nvim | Manual LSP installation | You have complex cross-project LSP requirements or use Nix |

## What NOT to Use

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| Vimscript config | Lua is faster, better integrated | Lua configuration files |
| minpac | Unmaintained, vimscript-based | lazy.nvim (modern, performant, Lua) |
| Manual plugin cloning | No version control, manual updates | lazy.nvim with lockfile |
| vim-lsp | Less mature than built-in Neovim LSP | Neovim native LSP + nvim-lspconfig |
| Old starter versions | Missing recent features/fixes | Always use latest LazyVim starter |

## Migration Notes (Current Setup → LazyVim)

### Current State
- Plugin manager: minpac (vimscript)
- Config: init.vim (vimscript)
- Leader: Space (matches LazyVim default)
- Hook: `03-vim-plugins` installs minpac

### Migration Path
1. **Replace config**: Copy LazyVim starter over `config/nvim/`
2. **Update hook**: Modify `03-vim-plugins` → `03-lazyvim-setup`
3. **Preserve keybinds**: Add custom mappings to `lua/config/keymaps.lua`
4. **Enable extras**: Use `:LazyExtras` to enable util.dot for dotfile support

### Key Compatibility Points
- Space leader preserved (no muscle memory changes)
- rcm hooks work identically (same idempotent pattern)
- Window navigation (Ctrl+hjkl) is LazyVim default
- FZF functionality replaced by Telescope (similar UX, better features)

## Version Compatibility

| Package | Compatible With | Notes |
|---------|-----------------|-------|
| LazyVim v15.13.0 | Neovim >= 0.11.2 | Requires native LSP config support |
| lazy.nvim v11.17.5 | Neovim >= 0.8.0 | LazyVim requires 0.11+, so this is easily met |
| mason.nvim latest | Neovim >= 0.11.0 | Auto-enables LSP servers (new in 0.11) |
| nvim-treesitter | Neovim >= 0.9.1 | LazyVim 0.11+ requirement covers this |

**Critical:** Neovim 0.11.2+ is non-negotiable. Earlier versions lack features LazyVim depends on (vim.lsp.config, automatic LSP enabling).

## Stack Patterns by Context

**For dotfiles migration (your use case):**
- Use LazyVim Starter template
- Preserve custom keybindings in `lua/config/keymaps.lua`
- Enable `util.dot` extra for dotfile syntax support
- Keep `lazy-lock.json` in version control for reproducibility
- Post-hook installs plugins automatically

**For new LazyVim setup (not migrating):**
- Clone starter directly to `~/.config/nvim`
- Run `:Lazy sync` manually first time
- Explore `:LazyExtras` for language/feature sets
- Gradually customize as you discover needs

**For multi-machine sync:**
- Commit `lazy-lock.json` to dotfiles
- Post-hook ensures consistent plugin versions
- Use tags in `lazy-lock.json` for stability
- Run `:Lazy restore` to match lockfile exactly

## Sources

**HIGH CONFIDENCE (Official Documentation & Context7):**
- [LazyVim Installation](https://www.lazyvim.org/installation) - Installation requirements and methods
- [LazyVim Configuration](https://www.lazyvim.org/configuration) - File structure and customization
- [LazyVim Keymaps](https://www.lazyvim.org/keymaps) - Default keybindings and which-key integration
- [LazyVim GitHub](https://github.com/LazyVim/LazyVim) - Current requirements (Neovim >= 0.11.2, Git >= 2.19.0)
- [LazyVim Releases](https://github.com/LazyVim/LazyVim/releases) - v15.13.0 (November 1, 2025)
- [lazy.nvim GitHub](https://github.com/folke/lazy.nvim) - v11.17.5 (November 6, 2025), requirements
- [LazyVim Dot Extra](https://www.lazyvim.org/extras/util/dot) - Dotfile support features
- [RCM rcup man page](https://thoughtbot.github.io/rcm/rcup.1.html) - Hook documentation

**MEDIUM CONFIDENCE (Verified with multiple sources):**
- [LazyVim Starter Repository](https://github.com/LazyVim/starter) - Recommended installation approach
- [Mason.nvim GitHub](https://github.com/mason-org/mason.nvim) - LSP/tool manager
- [Mason-lspconfig GitHub](https://github.com/mason-org/mason-lspconfig.nvim) - LSP bridge, auto-enable feature
- [RCM Hooks Discussion](https://github.com/thoughtbot/rcm/blob/master/test/rcup-hooks.t) - Post-up hook patterns
- [thoughtbot RCM blog](https://thoughtbot.com/blog/rcm-for-rc-files-in-dotfiles-repos) - Post-up hook example

**LOW CONFIDENCE (Community practices, unverified):**
- [LazyVim Dotfiles Discussion](https://github.com/LazyVim/LazyVim/discussions/766) - Community dotfile patterns
- [Neovim 2025 Config Guide](https://rdrn.me/neovim-2025/) - General Neovim setup trends

---
*Stack research for: LazyVim Migration to rcm-managed Dotfiles*
*Researched: 2026-02-03*
