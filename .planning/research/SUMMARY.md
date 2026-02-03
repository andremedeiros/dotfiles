# Project Research Summary

**Project:** LazyVim Migration for rcm-managed Dotfiles
**Domain:** Neovim Configuration Migration (Vimscript to LazyVim)
**Researched:** 2026-02-03
**Confidence:** HIGH

## Executive Summary

This is a complete migration from a vimscript-based Neovim configuration (using minpac and manual plugin management) to LazyVim, a modern Lua-based Neovim distribution. LazyVim provides a curated set of plugins with sensible defaults, built on the lazy.nvim plugin manager, and is specifically designed to be customized through layered configuration. The configuration must integrate with the existing rcm dotfiles management system, which handles symlinking and post-installation hooks.

The recommended approach is to use the LazyVim starter template as a foundation, systematically migrate existing keybindings and settings to Lua, and leverage LazyVim's built-in replacements for old plugins (Telescope for FZF, neo-tree for NERDTree, native LSP for vim-lsp). The migration should be done as a single replacement rather than gradual, using separate `NVIM_APPNAME` configurations for testing. Critical success factors include preserving muscle memory through careful keybinding migration, using LazyVim's "extras" system for language support (especially Go), and integrating with rcm through a post-up hook that automates lazy.nvim installation.

Key risks center around keybinding conflicts between custom mappings and LazyVim defaults, configuration loading order issues (LazyVim auto-loads specific file paths), and the critical requirement for tree-sitter-cli >= 0.25.0. These can be mitigated by systematically disabling conflicting default keybindings before adding custom ones, understanding LazyVim's auto-loading behavior to avoid manual requires, and ensuring tree-sitter-cli is installed via the rcm post-hook.

## Key Findings

### Recommended Stack

LazyVim is built on a foundation of Neovim >= 0.11.2 and lazy.nvim >= 11.17.5, with automatic plugin management and lazy loading for performance. The system requires tree-sitter-cli >= 0.25.0 for syntax highlighting (a breaking change in LazyVim v15+), and integrates with Mason for LSP/tool management. The LazyVim starter template provides the correct bootstrap structure and file layout, making it the recommended installation method over manual setup.

**Core technologies:**
- **Neovim >= 0.11.2:** Required by LazyVim for native LSP config mechanisms and automatic LSP enabling
- **LazyVim v15.13.0+:** Actively maintained distribution with pre-configured, extensible setup and sensible defaults
- **lazy.nvim v11.17.5+:** Plugin manager with auto-caching, lazy-loading, and lockfile support
- **tree-sitter-cli >= 0.25.0:** Required for on-demand parser compilation (LazyVim v15+ breaking change)
- **Mason.nvim:** LSP/DAP/linter manager bundled with LazyVim for tool installation
- **ripgrep + fd:** Required for Telescope file/text searching (already in ecosystem)

**Supporting infrastructure:**
- **rcm post-hook:** Automates lazy.nvim bootstrap and tree-sitter-cli installation after rcup
- **Nerd Font:** Optional but recommended for icons (already using Hack Nerd Font)

### Expected Features

The migration must preserve existing workflow while modernizing the plugin stack. LazyVim provides built-in replacements for most existing functionality, but custom keybindings require careful migration to avoid conflicts.

**Must have (table stakes):**
- **Buffer/file fuzzy finding:** LazyVim includes Telescope (replaces FZF), mapped to `<leader>,` and `<leader><space>`
- **Window navigation:** `<C-h/j/k/l>` already built into LazyVim (identical to existing config)
- **File tree explorer:** neo-tree.nvim (extra) or mini.files replaces NERDTree
- **Symbol/tag navigation:** LSP symbols via `<leader>ss` and Aerial plugin replaces Vista/Tagbar
- **Go language support:** `extras.lang.go` provides gopls, formatting, testing, debugging
- **LSP integration:** Full native LSP support built-in, replaces vim-lsp
- **Git integration:** gitsigns.nvim replaces gitgutter, with Telescope integration
- **which-key integration:** Built-in by default, auto-shows keybinding hints

**Should have (competitive):**
- **Preserved muscle memory:** Custom keymaps in `lua/config/keymaps.lua` to maintain existing shortcuts
- **Custom which-key labels:** Self-documenting keybindings using `desc` field
- **Zoom window toggle:** LazyVim has `<leader>wm`, replaces zoomwintab
- **Search/replace across files:** grug-far.nvim included, can map to custom key
- **Custom Go shortcuts:** Need custom maps for `<leader>got/gotf/gor/god` commands

**Defer (v2+):**
- **Plugin performance optimization:** `:Lazy profile` can identify slow-loading plugins after initial migration
- **Symbol navigation fine-tuning:** Test Aerial vs Telescope symbols, pick one approach
- **Advanced lazy loading:** Let LazyVim handle defaults initially, optimize later if needed

### Architecture Approach

LazyVim uses a layered architecture where user configurations merge with base defaults through lazy.nvim's plugin specification system. Files under `lua/config/` (options, keymaps, autocmds) are automatically loaded at appropriate times, and files under `lua/plugins/*.lua` define plugin customizations that extend or override defaults. The system depends on specific file locations and loading order, with LazyVim core loading first, then extras, then user specs.

**Major components:**
1. **Bootstrap layer** (`init.lua` → `lua/config/lazy.lua`) — Minimal entry point that ensures lazy.nvim exists and initiates plugin loading
2. **Configuration layer** (`lua/config/*.lua`) — Auto-loaded files for vim options, keymaps, and autocmds that run at appropriate startup phases
3. **Plugin specification layer** (`lua/plugins/*.lua`) — User-defined plugin specs that merge with LazyVim defaults using `opts` merging or `config` functions
4. **LazyVim core** — Pre-packaged plugin bundle with sensible defaults, loaded by lazy.nvim
5. **rcm integration** — Symlinks dotfiles repo to `~/.config/nvim`, post-hook ensures runtime dependencies

**Key architectural patterns:**
- **Configuration layering:** User `opts` merge with LazyVim defaults (keys, opts, event, cmd, ft extend; other fields override)
- **Auto-loading:** LazyVim automatically loads `lua/config/*.lua` and `lua/plugins/*.lua` — manual requires cause double-loading
- **which-key integration:** Keymaps with `desc` field automatically register with which-key
- **LazyVim extras:** Opt-in language/feature bundles imported before user plugins for proper merging

**Data flow:**
1. rcup symlinks config → Neovim starts → init.lua bootstraps lazy.nvim
2. lazy.nvim loads LazyVim core → LazyVim loads options.lua (pre-startup)
3. Plugins initialize with merged specs → VeryLazy event loads autocmds.lua and keymaps.lua
4. which-key registers keymaps with descriptions

### Critical Pitfalls

The research identified 13 pitfalls, with 6 critical ones that can break the migration if not addressed.

1. **Manually requiring auto-loaded files** — Using `require("config.keymaps")` causes double-loading since LazyVim auto-loads these files. Results in duplicate keybindings and wasted startup time. Prevention: Never manually require `lua/config/*.lua` files.

2. **Conflicting keymaps not disabled** — Adding custom keymap without disabling LazyVim default creates delays and unpredictable behavior. Prevention: Use `vim.keymap.del()` or `{ "<key>", false }` in plugin spec before adding custom keymap.

3. **Using `config` function instead of `opts`** — Breaks LazyVim's automatic option merging, losing all defaults. Prevention: Always use `opts` for plugin configuration unless plugin lacks `.setup()` function or needs complex initialization.

4. **Missing tree-sitter-cli** — LazyVim v15+ requires tree-sitter-cli >= 0.25.0 for syntax highlighting. Parser compilation fails silently without it. Prevention: Add `brew install tree-sitter` to rcm post-hook before first LazyVim launch.

5. **Wrong import order** — Importing LazyVim extras after user plugins causes merge order warnings and unpredictable behavior. Prevention: Import order must be: LazyVim core → extras → third-party → custom specs.

6. **which-key v3 API changes** — LazyVim uses which-key v3 with breaking changes from v2. Old `register()` syntax doesn't work. Prevention: Use new `opts = { spec = {...} }` API or `add()` method.

**Moderate pitfalls requiring attention:**
- Conflicting leader key bindings with LazyVim defaults (must systematically review and resolve)
- Using `vim.g` variables in `config` instead of `init` (timing issue with vimscript plugins)
- Attempting partial migration with both plugin managers (use separate NVIM_APPNAME instead)

## Implications for Roadmap

Based on research, the migration should follow a sequential approach that establishes foundation before building on it. The architecture requires correct structure before any customization, and pitfalls are phase-specific.

### Phase 1: Foundation Setup
**Rationale:** LazyVim's auto-loading behavior requires correct file structure before any configuration. Without proper bootstrap and directory layout, subsequent configuration will fail or double-load.

**Delivers:**
- Working LazyVim installation with starter template
- Proper file structure (`init.lua`, `lua/config/`, `lua/plugins/`)
- rcm integration via updated post-hook
- tree-sitter-cli installed and verified

**Addresses:**
- Critical pitfall 1 (auto-loading) by establishing correct structure
- Critical pitfall 4 (tree-sitter-cli) through post-hook installation
- Pitfall 9 (both plugin managers) by clean replacement

**Avoids:**
- Manual requires (structure prevents need)
- Missing dependencies (post-hook installs prerequisites)

**Research flags:** Standard pattern, skip research-phase. LazyVim starter template is well-documented with official examples.

---

### Phase 2: Core Keybinding Migration
**Rationale:** Muscle memory preservation is a primary goal. Must address keybinding conflicts before adding plugin customizations, as many plugins define their own keymaps that could conflict with custom mappings.

**Delivers:**
- Custom movement mappings (H/L, //, visual indent)
- Buffer/file navigation mapped to muscle memory (`<leader>j/p`)
- which-key descriptions for all custom keybindings
- Conflict resolution with LazyVim defaults

**Uses:**
- which-key v3 API for descriptions and groups
- Telescope for buffer/file finding

**Addresses:**
- Critical pitfall 2 (conflicting keymaps) by systematic disable-then-add
- Critical pitfall 6 (which-key v3) by using new API
- Pitfall 7 (leader key conflicts) by reviewing defaults first

**Avoids:**
- Keymap delays from conflicts
- Missing which-key descriptions
- Old which-key v2 syntax

**Research flags:** Standard pattern, skip research-phase. LazyVim keybinding customization is well-documented with examples.

---

### Phase 3: Plugin Replacements
**Rationale:** With structure and keybindings established, can safely migrate plugin functionality. This phase replaces old vimscript plugins with LazyVim equivalents, using configuration layering patterns.

**Delivers:**
- File tree (neo-tree replaces NERDTree)
- Symbol navigation (Aerial or Telescope LSP replaces Vista)
- Window zoom functionality
- Plugin-specific keybinding customizations

**Uses:**
- LazyVim extras system (for neo-tree)
- Plugin `opts` merging (avoiding `config` function)
- `opts_extend` for list-like options

**Implements:**
- Plugin specification layer architecture
- Configuration layering pattern

**Addresses:**
- Critical pitfall 3 (`config` vs `opts`) by using `opts` consistently
- Critical pitfall 5 (import order) by importing extras first
- Pitfall 8 (`vim.g` timing) by using `init` for vimscript plugins
- Pitfall 11 (list replacement) by using `opts_extend`

**Avoids:**
- Config function overriding all defaults
- Wrong import order warnings
- List options being replaced instead of extended

**Research flags:** Standard pattern, skip research-phase. LazyVim plugin customization patterns are well-established.

---

### Phase 4: Go Language Support
**Rationale:** Go is the primary development language. Requires understanding of LazyVim's language extras system and custom keybinding integration. Depends on Phase 2 keybinding foundation.

**Delivers:**
- `extras.lang.go` enabled with gopls LSP
- Custom Go commands (`<leader>got/gotf/gor/god`)
- Go-specific autocmds (nolist for .go files)
- which-key group for Go commands

**Uses:**
- LazyVim extras system for base Go support
- Custom keymaps for workflow shortcuts
- Autocmds for filetype-specific settings

**Addresses:**
- Pitfall 13 (ignoring extras) by using extras.lang.go
- Feature requirement for Go development workflow

**Avoids:**
- Manual LSP configuration (extras handle this)
- Incomplete language support

**Research flags:** May need research-phase if Go extras don't cover specific workflow needs (neotest-golang, vim-go coexistence, debugging setup). Review extras documentation first, then decide.

---

### Phase 5: Verification and Refinement
**Rationale:** Comprehensive health checks catch subtle issues before they compound. Ensures migration is complete and optimized.

**Delivers:**
- All `:checkhealth` sections passing
- Performance baseline established
- Documentation of custom configuration
- Verification of all migrated features

**Addresses:**
- Pitfall 12 (not running checkhealth) systematically
- Overall confidence in migration completeness

**Avoids:**
- Silent failures accumulating
- Performance degradation going unnoticed

**Research flags:** Standard pattern, skip research-phase. Health check commands are built-in and well-documented.

---

### Phase Ordering Rationale

This sequential approach is necessary due to:

1. **Dependency chain:** Structure → Keybindings → Plugins → Language support follows LazyVim's layered architecture. Can't customize plugins without structure, can't resolve keymap conflicts without understanding defaults.

2. **Pitfall timing:** Each phase addresses specific pitfalls that must be prevented at that stage. For example, auto-loading pitfalls (Phase 1) must be understood before adding keybindings (Phase 2) that could double-load.

3. **Testing isolation:** Each phase produces a working system, allowing incremental testing. If Phase 2 breaks keybindings, don't compound by adding plugin customizations in Phase 3.

4. **Muscle memory preservation:** Phase 2 priority ensures immediate usability. If buffer switching doesn't work, developer productivity stops regardless of other features.

5. **Risk mitigation:** Foundation first prevents cascading failures. Wrong file structure causes every subsequent configuration to fail mysteriously.

### Research Flags

**Phases needing research during planning:**
- **Phase 4 (Go Language Support):** May need deeper research if extras.lang.go doesn't cover all workflow needs. Specifically: neotest-golang integration, vim-go coexistence decision, debugging configuration (DAP), custom command implementation. Standard patterns exist, but user has specific commands (`got/gotf/gor/god`) that may need plugin evaluation.

**Phases with standard patterns (skip research-phase):**
- **Phase 1 (Foundation Setup):** LazyVim starter template installation is well-documented with official guide
- **Phase 2 (Core Keybinding Migration):** LazyVim keybinding customization has extensive examples and clear API
- **Phase 3 (Plugin Replacements):** Plugin customization patterns are standard, well-documented with examples
- **Phase 5 (Verification and Refinement):** Health checks are built-in, no additional research needed

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | Official LazyVim and lazy.nvim documentation with specific version requirements. tree-sitter-cli requirement is recent (LazyVim v15) but well-documented. |
| Features | HIGH | Existing config is well-understood, LazyVim replacement mappings are documented. All feature requirements have known LazyVim equivalents. |
| Architecture | HIGH | LazyVim architecture is officially documented with clear patterns. Auto-loading behavior and file structure requirements are explicit. |
| Pitfalls | HIGH | Pitfalls sourced from extensive GitHub discussions, official migration guides, and LazyVim issue tracker. Patterns are well-established from community experience. |

**Overall confidence:** HIGH

The research is based on official documentation (LazyVim, lazy.nvim, Neovim), the LazyVim starter template source code, and extensive community discussion threads documenting common migration issues. The existing vimscript configuration is well-understood (190 lines in init.vim with clear plugin list). LazyVim has been in active development for 2+ years with stable patterns.

The only uncertainty is around specific Go workflow commands (`got/gotf/gor/god`) which may require custom plugin configuration beyond the standard extras.lang.go. This can be addressed during Phase 4 planning.

### Gaps to Address

- **Go command implementation strategy:** The existing config has custom leader commands for Go testing and running. Need to decide during Phase 4 whether to use neotest-golang (LazyVim's default), keep vim-go, or implement custom commands via terminal. This requires evaluating neotest-golang capabilities vs. vim-go features during Phase 4 planning.

- **Symbol navigation preference:** Both Aerial and Telescope LSP symbols can replace Vista. Need to test both during Phase 3 to determine which fits workflow better (tree view vs. fuzzy finder). Not critical for migration success, can be changed later.

- **Lazy loading optimization:** Initial migration should use LazyVim defaults. If startup time is problematic (>500ms), can profile and optimize in Phase 5. This is a post-migration refinement, not a blocker.

## Sources

### Primary (HIGH confidence)
- [LazyVim Official Documentation](https://www.lazyvim.org/) — Installation, configuration, keymaps, plugin customization
- [LazyVim Starter Repository](https://github.com/LazyVim/starter) — Bootstrap structure and file layout
- [LazyVim GitHub Repository](https://github.com/LazyVim/LazyVim) — Source code for defaults and version requirements
- [lazy.nvim Documentation](https://lazy.folke.io/) — Plugin manager spec, merging behavior, lazy loading
- [which-key.nvim GitHub](https://github.com/folke/which-key.nvim) — v3 API documentation and changelog
- [LazyVim Default Keymaps Source](https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua) — Exact default keybindings
- [rcm Documentation](https://thoughtbot.github.io/rcm/) — Hook system and symlinking behavior

### Secondary (MEDIUM confidence)
- LazyVim GitHub Discussions — Keybinding conflicts (#3863, #1186, #6557), plugin configuration (#2534, #1652), which-key issues (#4008, #4014, #3598)
- LazyVim Migration Issues — v15 migration (#6421), tree-sitter-cli (#6451, #6503), import order (#5854)
- lazy.nvim Discussions — Plugin spec merging (#1706), lazy loading events (#1049, #858)
- Community Guides — "LazyVim for Ambitious Developers" (Chapter 19), "Customizing LazyVim" (Andrew Courter), "Why I Switched to LazyVim" (Nick Janetakis)

### Tertiary (LOW confidence)
- Individual dotfiles repositories referenced in discussions (for pattern validation, not implementation details)

---
*Research completed: 2026-02-03*
*Ready for roadmap: yes*
