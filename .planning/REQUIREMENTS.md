# Requirements: LazyVim Migration

**Defined:** 2026-02-03
**Core Value:** A working, modern Neovim setup with familiar keybindings that requires minimal maintenance

## v1 Requirements

Requirements for initial migration. Each maps to roadmap phases.

### Foundation

- [ ] **FOUND-01**: LazyVim installed using starter template
- [ ] **FOUND-02**: File structure created (init.lua, lua/config/, lua/plugins/)
- [ ] **FOUND-03**: Neovim >= 0.11.2 verified
- [ ] **FOUND-04**: tree-sitter-cli >= 0.25.0 installed
- [ ] **FOUND-05**: Dependencies verified (ripgrep, fd)

### Integration

- [ ] **INTG-01**: rcm post-hook script created for LazyVim installation
- [ ] **INTG-02**: Config symlinked from dotfiles repo to ~/.config/nvim
- [ ] **INTG-03**: Post-hook installs lazy.nvim bootstrap automatically
- [ ] **INTG-04**: Post-hook installs tree-sitter-cli via Homebrew

### Keybindings

- [ ] **KEYS-01**: H/L mapped to line start/end (^ and $)
- [ ] **KEYS-02**: // mapped to clear search highlight (:noh)
- [ ] **KEYS-03**: Visual mode < and > indent without losing selection
- [ ] **KEYS-04**: <leader>p mapped to file finder
- [ ] **KEYS-05**: <leader><Tab> mapped to alternate buffer
- [ ] **KEYS-06**: <leader>z mapped to zoom window toggle
- [ ] **KEYS-07**: Custom keybindings show in which-key popup with labels

### Documentation

- [ ] **DOCS-01**: README updated with LazyVim setup instructions
- [ ] **DOCS-02**: Old vimscript config archived or removed
- [ ] **DOCS-03**: Custom keybindings documented

## v2 Requirements

Deferred to future iteration. Tracked but not in current roadmap.

### Plugin Customization

- **PLUG-01**: Custom colorscheme configuration (if not using LazyVim default)
- **PLUG-02**: Additional language support beyond defaults
- **PLUG-03**: Performance optimization via lazy loading tuning

### Language Support

- **LANG-01**: Go language extras enabled (extras.lang.go)
- **LANG-02**: Ruby language extras enabled
- **LANG-03**: Additional language-specific configurations

## Out of Scope

Explicitly excluded. Documented to prevent scope creep.

| Feature | Reason |
|---------|--------|
| Replicating old plugin setup | LazyVim provides modern equivalents; user will discover gaps organically |
| Dash integration | No longer used |
| Language-specific keybindings | Defer to v2; adopt LazyVim defaults initially |
| Buffer/file tree/symbol/search keybindings | Removed from scope; adopt LazyVim defaults |
| Custom Go workflow commands | Removed from scope; adopt LazyVim/neotest defaults |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| (Pending roadmap creation) | | |

**Coverage:**
- v1 requirements: 16 total
- Mapped to phases: 0 (pending roadmap)
- Unmapped: 16 ⚠️

---
*Requirements defined: 2026-02-03*
*Last updated: 2026-02-03 after initial definition*
