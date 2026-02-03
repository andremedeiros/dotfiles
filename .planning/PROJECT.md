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
- ✓ LazyVim installed and configured in config/nvim/ — v1.0
- ✓ Custom keybindings migrated to Lua configuration — v1.0
- ✓ Keybindings integrated with which-key popup labels — v1.0
- ✓ Post-hook script for LazyVim validation — v1.0
- ✓ README updated with new LazyVim setup instructions — v1.0
- ✓ Old vimscript configuration removed — v1.0

### Active

(Ready for next milestone requirements)

### Out of Scope

- Replicating old plugin configurations (NERDTree, Vista, fzf, vim-lsp, etc.) — LazyVim provides modern equivalents
- Dash integration (`<leader>doc` keybinding) — no longer used
- Language-specific plugin configurations — defer to LazyVim defaults and iterate as needed
- Preserving old minpac plugin setup — replaced by LazyVim's plugin manager

## Context

**Current state (v1.0):**
- LazyVim-based Neovim configuration (93 LOC Lua)
- Plugin management via lazy.nvim (self-bootstrapping)
- Custom keybindings: H/L line navigation, // search clear, visual indent, Leader+p file finder, Leader+Tab buffer switch, Leader+z zoom
- Which-key integration for discoverability
- Automated dependency validation via rcm post-hook
- Tech stack: Neovim 0.11.2+, LazyVim starter, Telescope, Snacks.nvim, which-key

**v1.0 shipped (2026-02-03):**
- 3 phases, 5 plans completed
- All custom keybindings migrated and working
- README documentation complete
- Zero outstanding issues

**User feedback:** None yet (fresh migration, needs production usage time)

## Constraints

- **Dotfiles structure**: Must work within existing rcm-managed dotfiles layout — config files live in repo and get symlinked to ~/.config/
- **Keybinding compatibility**: Must preserve muscle memory for existing keybindings — same key sequences should trigger equivalent actions
- **Plugin ecosystem**: Use LazyVim's default plugins and conventions — don't fight the framework
- **Timeline**: Single migration — complete replacement of old config, not gradual transition

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| LazyVim over manual Lua config | Want maintained, modern setup without ongoing maintenance burden | ✓ Good (v1.0) |
| Adapt keybindings to LazyVim plugins | LazyVim's ecosystem (Telescope, neo-tree, etc.) is more modern than old plugins | ✓ Good (v1.0) |
| Skip Dash integration | No longer using Dash for documentation lookup | ✓ Good (v1.0) |
| Clean break from vimscript | Remove old config completely, no archiving | ✓ Good (v1.0) |
| lazy.nvim self-bootstrap | Plugin manager bootstraps on first launch, not via post-hook | ✓ Good (v1.0) |
| tree-sitter-cli formula | Use CLI formula instead of library-only formula | ✓ Good (v1.0) |
| LazyVim.pick() for file finder | Use LazyVim integration instead of direct Telescope | ✓ Good (v1.0) |
| Plugin spec for binding conflicts | Disable conflicting bindings via lazy.nvim keys table | ✓ Good (v1.0) |
| <kbd> tags for keybinding docs | Semantic HTML for visual distinction in README | ✓ Good (v1.0) |

---
*Last updated: 2026-02-03 after v1.0 milestone*
