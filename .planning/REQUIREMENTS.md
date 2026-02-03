# Requirements: LazyVim Migration

**Defined:** 2026-02-03
**Core Value:** A working, modern Neovim setup with familiar keybindings that requires minimal maintenance

## v1 Requirements

Requirements for initial migration. Each maps to roadmap phases.

### Foundation

- [x] **FOUND-01**: LazyVim installed using starter template
- [x] **FOUND-02**: File structure created (init.lua, lua/config/, lua/plugins/)
- [x] **FOUND-03**: Neovim >= 0.11.2 verified
- [x] **FOUND-04**: tree-sitter-cli >= 0.25.0 installed
- [x] **FOUND-05**: Dependencies verified (ripgrep, fd)

### Integration

- [x] **INTG-01**: rcm post-hook script created for LazyVim installation
- [x] **INTG-02**: Config symlinked from dotfiles repo to ~/.config/nvim
- [x] **INTG-03**: Post-hook installs lazy.nvim bootstrap automatically
- [x] **INTG-04**: Post-hook installs tree-sitter-cli via Homebrew

### Keybindings

- [x] **KEYS-01**: H/L mapped to line start/end (^ and $)
- [x] **KEYS-02**: // mapped to clear search highlight (:noh)
- [x] **KEYS-03**: Visual mode < and > indent without losing selection
- [x] **KEYS-04**: <leader>p mapped to file finder
- [x] **KEYS-05**: <leader><Tab> mapped to alternate buffer
- [x] **KEYS-06**: <leader>z mapped to zoom window toggle
- [x] **KEYS-07**: Custom keybindings show in which-key popup with labels

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
| FOUND-01 | Phase 1 | Complete |
| FOUND-02 | Phase 1 | Complete |
| FOUND-03 | Phase 1 | Complete |
| FOUND-04 | Phase 1 | Complete |
| FOUND-05 | Phase 1 | Complete |
| INTG-01 | Phase 1 | Complete |
| INTG-02 | Phase 1 | Complete |
| INTG-03 | Phase 1 | Complete |
| INTG-04 | Phase 1 | Complete |
| KEYS-01 | Phase 2 | Complete |
| KEYS-02 | Phase 2 | Complete |
| KEYS-03 | Phase 2 | Complete |
| KEYS-04 | Phase 2 | Complete |
| KEYS-05 | Phase 2 | Complete |
| KEYS-06 | Phase 2 | Complete |
| KEYS-07 | Phase 2 | Complete |
| DOCS-01 | Phase 3 | Pending |
| DOCS-02 | Phase 3 | Pending |
| DOCS-03 | Phase 3 | Pending |

**Coverage:**
- v1 requirements: 19 total
- Mapped to phases: 19 (100%)
- Unmapped: 0

---
*Requirements defined: 2026-02-03*
*Last updated: 2026-02-03 after roadmap creation*
