# LazyVim Migration

## What This Is

A migration from hand-rolled vimscript Neovim configuration to LazyVim, preserving custom keyboard mappings and integrating them with which-key for discoverability. This provides a modern, maintained editor setup without ongoing configuration maintenance while keeping familiar keybindings.

## Core Value

A working, modern Neovim setup with familiar keybindings that requires minimal maintenance.

## Requirements

### Validated

- ✓ Dotfiles repository managed by rcm — existing
- ✓ Neovim configuration with plugin management — existing
- ✓ Fish shell environment — existing
- ✓ Git hooks for automated setup — existing

### Active

- [ ] LazyVim installed and configured in config/nvim/
- [ ] Custom keybindings migrated to Lua configuration
- [ ] Keybindings integrated with which-key popup labels
- [ ] Post-hook script for LazyVim installation/download
- [ ] README updated with new LazyVim setup instructions
- [ ] Old vimscript configuration removed/archived

### Out of Scope

- Replicating old plugin configurations (NERDTree, Vista, fzf, vim-lsp, etc.) — LazyVim provides modern equivalents
- Dash integration (`<leader>doc` keybinding) — no longer used
- Language-specific plugin configurations — defer to LazyVim defaults and iterate as needed
- Preserving old minpac plugin setup — replaced by LazyVim's plugin manager

## Context

**Existing setup:**
- Dotfiles managed by thoughtbot's rcm (symlinks to ~/.config/)
- Current Neovim config at config/nvim/init.vim (vimscript)
- Plugin management via minpac
- Multiple language syntax plugins (Go, Ruby, Elm, TypeScript, etc.)
- Space as leader key
- Custom keybindings for navigation, file management, window control

**Keybindings to preserve:**
- Leader mappings: `<leader>j` (buffers), `<leader>p` (files), `<leader><Tab>` (alternate buffer), `<leader>t` (symbols/tags), `<leader>z` (zoom), `<leader>\` (file tree), `<leader>gr` (grep/search)
- Go-specific: `<leader>got/gotf/gor/god` (test/test-func/run/definition)
- Navigation: `H`/`L` (line start/end), `<C-hjkl>` (window navigation), `//` (clear search)
- Visual mode: `<`/`>` (indent without losing selection)

**Migration strategy:**
- Adapt keybindings to LazyVim's built-in features (Telescope, neo-tree, native LSP, etc.)
- Use LazyVim's plugin ecosystem rather than replicating old setup
- User will identify and address any missing behaviors organically

## Constraints

- **Dotfiles structure**: Must work within existing rcm-managed dotfiles layout — config files live in repo and get symlinked to ~/.config/
- **Keybinding compatibility**: Must preserve muscle memory for existing keybindings — same key sequences should trigger equivalent actions
- **Plugin ecosystem**: Use LazyVim's default plugins and conventions — don't fight the framework
- **Timeline**: Single migration — complete replacement of old config, not gradual transition

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| LazyVim over manual Lua config | Want maintained, modern setup without ongoing maintenance burden | — Pending |
| Adapt keybindings to LazyVim plugins | LazyVim's ecosystem (Telescope, neo-tree, etc.) is more modern than old plugins | — Pending |
| Skip Dash integration | No longer using Dash for documentation lookup | — Pending |
| No plugin replication | User will discover and address missing behaviors as needed rather than preemptively recreating old setup | — Pending |

---
*Last updated: 2026-02-03 after initialization*
