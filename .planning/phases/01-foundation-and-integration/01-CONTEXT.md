# Phase 1: Foundation and Integration - Context

**Gathered:** 2026-02-03
**Status:** Ready for planning

<domain>
## Phase Boundary

Set up LazyVim as the new Neovim configuration foundation and integrate it with the existing rcm dotfiles management system. This phase delivers a working LazyVim installation with all dependencies verified and health checks passing. Custom keybindings (Phase 2) and documentation (Phase 3) are separate.

</domain>

<decisions>
## Implementation Decisions

### rcm integration strategy
- Config files live in `config/nvim/` (standard XDG structure mirroring ~/.config/nvim)
- LazyVim data directories stay in default XDG locations (not tracked in dotfiles):
  - Plugins: ~/.local/share/nvim
  - State/shada: ~/.local/state/nvim
  - Cache: ~/.cache/nvim
- Old vimscript config removed immediately (clean break, no coexistence)

### Dependency installation
- Add LazyVim dependencies to existing Brewfile:
  - neovim (>= 0.11.2)
  - ripgrep
  - fd
  - tree-sitter
- Existing post-up hook already handles `brew bundle` installation
- No new hook needed for dependency management

### Plugin management timing
- lazy.nvim bootstraps automatically on Neovim first launch (LazyVim starter handles this)
- Plugins install automatically on first launch (no manual :Lazy sync needed)
- lazy-lock.json NOT tracked in dotfiles (let lazy.nvim manage versions per machine)
- Health checks run automatically after setup to validate installation

### Claude's Discretion
- Exact timing of when post-up hook runs :checkhealth (after plugins install)
- Error messaging format for failed health checks
- How to handle LazyVim starter example configs (keep useful ones, remove boilerplate)

</decisions>

<specifics>
## Specific Ideas

- User already has Brewfile in dotfiles root with post-up hook for installation
- Want clean break from old vimscript config — remove, don't archive
- Prefer automation where sensible (auto-install plugins, auto-run health checks)

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 01-foundation-and-integration*
*Context gathered: 2026-02-03*
