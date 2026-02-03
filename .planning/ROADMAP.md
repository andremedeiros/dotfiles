# Roadmap: LazyVim Migration

## Overview

This migration replaces the existing vimscript-based Neovim configuration with LazyVim, a modern Lua-based distribution. The journey begins with establishing LazyVim's foundation and integrating it with the rcm dotfiles system, continues with migrating muscle-memory keybindings to preserve workflow, and concludes with comprehensive documentation to support future maintenance.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: Foundation and Integration** - LazyVim setup with rcm integration
- [x] **Phase 2: Keybinding Migration** - Preserve muscle memory with custom mappings
- [ ] **Phase 3: Documentation** - Document new setup and archive old config

## Phase Details

### Phase 1: Foundation and Integration
**Goal**: LazyVim is installed, integrated with rcm, and ready for customization
**Depends on**: Nothing (first phase)
**Requirements**: FOUND-01, FOUND-02, FOUND-03, FOUND-04, FOUND-05, INTG-01, INTG-02, INTG-03, INTG-04
**Success Criteria** (what must be TRUE):
  1. Neovim launches with LazyVim starter template
  2. Config files in dotfiles repo are symlinked to ~/.config/nvim via rcm
  3. rcm post-hook installs lazy.nvim and tree-sitter-cli automatically
  4. Neovim health checks pass for LazyVim, lazy.nvim, and tree-sitter
  5. All required dependencies verified (ripgrep, fd, Neovim >= 0.11.2)
**Plans**: 3 plans

Plans:
- [x] 01-01-PLAN.md — Update Brewfile dependencies, remove old vimscript config
- [x] 01-02-PLAN.md — Create LazyVim starter template, add health check hook
- [x] 01-03-PLAN.md — Fix tree-sitter CLI dependency gap (gap closure)

### Phase 2: Keybinding Migration
**Goal**: Custom keybindings migrated and integrated with which-key for discoverability
**Depends on**: Phase 1
**Requirements**: KEYS-01, KEYS-02, KEYS-03, KEYS-04, KEYS-05, KEYS-06, KEYS-07
**Success Criteria** (what must be TRUE):
  1. H/L move cursor to line start/end as expected
  2. // clears search highlighting
  3. Visual mode < and > indent without losing selection
  4. Leader+p opens file finder (Telescope)
  5. Leader+Tab switches to alternate buffer
  6. Leader+z toggles window zoom
  7. Custom keybindings display in which-key popup with descriptive labels
**Plans**: 1 plan

Plans:
- [x] 02-01-PLAN.md — Implement all custom keybindings with which-key integration

### Phase 3: Documentation
**Goal**: Migration documented and old configuration archived
**Depends on**: Phase 2
**Requirements**: DOCS-01, DOCS-02, DOCS-03
**Success Criteria** (what must be TRUE):
  1. README contains LazyVim setup instructions including rcm integration
  2. Old vimscript configuration moved to archive or removed
  3. Custom keybindings documented with rationale
**Plans**: 1 plan

Plans:
- [ ] 03-01-PLAN.md — Update README.md with LazyVim documentation and keybindings

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Foundation and Integration | 3/3 | Complete | 2026-02-03 |
| 2. Keybinding Migration | 1/1 | Complete | 2026-02-03 |
| 3. Documentation | 0/1 | Not started | - |
