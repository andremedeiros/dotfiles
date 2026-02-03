# Phase 2: Keybinding Migration - Research

**Researched:** 2026-02-03
**Domain:** LazyVim keybinding configuration and which-key integration
**Confidence:** HIGH

## Summary

LazyVim provides a well-structured keybinding system built on Neovim's native `vim.keymap.set()` API with automatic which-key integration. Custom keybindings are defined in `lua/config/keymaps.lua`, which loads on the VeryLazy event after plugins. The which-key.nvim plugin automatically discovers keybindings via the `desc` attribute, requiring no manual registration.

Several custom bindings will override LazyVim defaults. Space+p overrides yanky.nvim's yank history, H/L overrides Neovim's builtin screen navigation (High/Low), and Leader+Tab overrides tab management. LazyVim uses `LazyVim.pick()` as an abstraction for file finding that intelligently switches between git_files and find_files based on repository context. The snacks.nvim plugin provides window zoom via `Snacks.zen.zoom()`.

**Primary recommendation:** Define all custom keybindings in `lua/config/keymaps.lua` using `vim.keymap.set()` with descriptive `desc` fields. This ensures proper loading order (VeryLazy event) and automatic which-key integration without additional configuration.

## Standard Stack

The established libraries/tools for LazyVim keybinding configuration:

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| vim.keymap.set | Neovim 0.11.2+ | Native keymap API | Built into Neovim, recommended by LazyVim docs |
| which-key.nvim | v3+ | Keybinding discovery UI | Default in LazyVim, auto-discovers via `desc` |
| snacks.nvim | Latest | Utility collection (zoom) | Maintained by LazyVim author (folke) |
| LazyVim.pick | Built-in | File picker abstraction | LazyVim's unified picker interface |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| Telescope.nvim | Latest | Fuzzy finder | Default picker backend in LazyVim |
| yanky.nvim | Latest | Yank history management | Default in LazyVim (overridden by Leader+p) |
| lazy.nvim | Latest | Plugin manager | Plugin spec `keys` table for plugin-specific bindings |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| lua/config/keymaps.lua | Plugin spec keys table | Plugin spec better for plugin-specific bindings, keymaps.lua better for global bindings |
| vim.keymap.set | LazyVim.safe_keymap_set | LazyVim docs explicitly warn against using safe_keymap_set in user config |
| Telescope | fzf-lua | Both valid, Telescope is LazyVim default |

**Installation:**
```bash
# No additional installation required
# All components included in LazyVim starter template
```

## Architecture Patterns

### Recommended Project Structure
```
~/.config/nvim/
├── init.lua                    # Entry point (loads LazyVim)
├── lua/
│   ├── config/
│   │   ├── autocmds.lua       # Auto commands
│   │   ├── keymaps.lua        # CUSTOM KEYBINDINGS GO HERE
│   │   ├── lazy.lua           # Plugin manager config
│   │   └── options.lua        # Vim options
│   └── plugins/
│       └── *.lua              # Plugin specs (can include keys table)
```

### Pattern 1: Global Keybindings in lua/config/keymaps.lua
**What:** Define all global custom keybindings in a single file
**When to use:** For keybindings that aren't tightly coupled to a specific plugin

**Example:**
```lua
-- Source: https://www.lazyvim.org/configuration/general
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- Simple motion binding
vim.keymap.set("n", "H", "^", { desc = "Go to line start" })
vim.keymap.set("n", "L", "$", { desc = "Go to line end" })

-- Clear search highlighting
vim.keymap.set("n", "//", "<cmd>noh<cr>", { desc = "Clear search highlight" })

-- Visual mode indent (keep selection)
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- File finder using LazyVim helper
vim.keymap.set("n", "<leader>p", function()
  require("lazyvim.util").pick("files")()
end, { desc = "Find files" })

-- Alternate buffer
vim.keymap.set("n", "<leader><tab>", "<cmd>buffer #<cr>", { desc = "Alternate buffer" })

-- Window zoom
vim.keymap.set("n", "<leader>z", function()
  require("snacks").zen.zoom()
end, { desc = "Toggle zoom" })
```

### Pattern 2: Plugin-Specific Keybindings in Plugin Spec
**What:** Define keybindings in the plugin's spec file using the `keys` table
**When to use:** For bindings tightly coupled to plugin functionality, or to override plugin defaults

**Example:**
```lua
-- Source: https://lazy.folke.io/spec
-- In lua/plugins/telescope.lua
return {
  "nvim-telescope/telescope.nvim",
  keys = {
    -- Disable default binding
    { "<leader>ff", false },
    -- Add custom binding
    { "<leader>p", "<cmd>Telescope find_files<cr>", desc = "Find files" },
  },
}
```

### Pattern 3: Visual Mode Selection Preservation
**What:** Reselect visual area after indentation using `gv` command
**When to use:** Visual mode operations that normally lose selection

**Example:**
```lua
-- Source: Neovim community pattern
-- The 'gv' command reselects the previously selected area
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })
```

### Pattern 4: LazyVim.pick for File Finding
**What:** Use LazyVim's picker abstraction that auto-switches between git_files and find_files
**When to use:** File finding commands that should respect git repository context

**Example:**
```lua
-- Source: https://github.com/LazyVim/LazyVim/discussions/4323
-- LazyVim.pick("files") intelligently uses git_files in git repos, find_files otherwise
vim.keymap.set("n", "<leader>p", function()
  require("lazyvim.util").pick("files")()
end, { desc = "Find files" })

-- With options
vim.keymap.set("n", "<leader>P", function()
  require("lazyvim.util").pick("files", { root = false })()
end, { desc = "Find files (cwd)" })
```

### Anti-Patterns to Avoid

- **Using LazyVim.safe_keymap_set in user config:** LazyVim docs explicitly state "DO NOT USE `LazyVim.safe_keymap_set` IN YOUR OWN CONFIG!! use `vim.keymap.set` instead"
- **Manually requiring config files:** LazyVim auto-loads files in lua/config/, don't require them manually
- **Missing desc field:** which-key requires `desc` for discoverability, always include it
- **Wrong loading order:** Setting keymaps before VeryLazy event causes plugin bindings to override yours
- **Forgetting to specify mode:** Visual mode bindings need explicit mode = "v", don't assume

## Don't Hand-Roll

Problems that look simple but have existing solutions:

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| File finder abstraction | Custom git detection logic | LazyVim.pick("files") | Auto-switches git_files/find_files, handles root detection, project-aware |
| Window zoom/maximize | Custom window size state tracking | Snacks.zen.zoom() | Handles edge cases, integrates with LazyVim ecosystem, maintained |
| Yank history | Custom clipboard ring buffer | yanky.nvim (LazyVim default) | Persistent history, visual selection, Telescope integration |
| Visual selection persistence | Manual selection tracking | Built-in `gv` command | Native Neovim command, reliable, no overhead |
| Which-key registration | Manual group/label setup | desc field in vim.keymap.set | Auto-discovered, no separate config, stays in sync |
| Alternate buffer tracking | Custom buffer history | Built-in `#` register | Native Neovim feature, reliable, works with buffer commands |

**Key insight:** LazyVim provides well-tested abstractions (LazyVim.pick, Snacks utilities) that handle edge cases and integrate with the ecosystem. Neovim builtins (`gv`, buffer `#`) are more reliable than custom implementations.

## Common Pitfalls

### Pitfall 1: Keybindings Load Before Plugins (Overridden)
**What goes wrong:** Custom keybindings defined in keymaps.lua get overridden by plugin defaults
**Why it happens:** If a plugin is not lazy-loaded, its config runs immediately at startup, before keymaps.lua loads on VeryLazy event
**How to avoid:** Either (1) use the plugin's `keys` table in plugin spec, or (2) ensure plugin lazy-loads after VeryLazy
**Warning signs:** Keybinding works briefly then stops working, or never works at startup

### Pitfall 2: Overriding Builtin Motions Without Understanding Loss
**What goes wrong:** Remapping H/L loses Neovim's High/Low screen navigation (jump to top/bottom of screen)
**Why it happens:** H moves to topmost visible line, L to bottommost visible line - these are valuable navigation commands
**How to avoid:** Consciously accept the tradeoff; H/L screen motion is less frequently used than ^ and $ line navigation
**Warning signs:** User expects to jump to top/bottom of screen with H/L but cursor stays on line

### Pitfall 3: Missing Mode Specification in Visual Bindings
**What goes wrong:** Visual mode keybindings don't work or affect wrong mode
**Why it happens:** Forgetting mode = "v" in vim.keymap.set causes binding to default to normal mode
**How to avoid:** Always explicitly specify mode for non-normal mode bindings: `vim.keymap.set("v", ...)`
**Warning signs:** Keybinding works in normal mode but not visual mode

### Pitfall 4: Using Wrong LazyVim.pick Command
**What goes wrong:** File finder doesn't show git-ignored files or searches wrong directory
**Why it happens:** LazyVim.pick("files") auto-switches to git_files in git repos, which respects .gitignore
**How to avoid:** Understand that "files" command is context-aware; use `{ no_ignore = true }` option if needed
**Warning signs:** Cannot find .env files or other gitignored files in search results

### Pitfall 5: Forgetting desc Field in Keybindings
**What goes wrong:** Keybinding doesn't appear in which-key popup or shows as "which_key_ignore"
**Why it happens:** which-key.nvim uses the `desc` attribute to display keybindings; without it, binding is hidden
**How to avoid:** Always include `desc` field in vim.keymap.set: `{ desc = "Action description" }`
**Warning signs:** Leader key popup doesn't show your custom binding, or shows cryptic lua function reference

### Pitfall 6: Disabling Keybindings in Wrong Location
**What goes wrong:** Attempted to disable a plugin's default keybinding but it still works
**Why it happens:** Setting `{ "<leader>p", false }` in keymaps.lua doesn't disable plugin bindings, only works in plugin spec
**How to avoid:** Disable plugin keybindings in the plugin's spec file using `keys` table, not in keymaps.lua
**Warning signs:** Both old and new keybinding for same key work, creating conflicts

## Code Examples

Verified patterns from official sources:

### Complete keymaps.lua Implementation
```lua
-- Source: https://www.lazyvim.org/configuration/general
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- ============================================================================
-- Navigation: Line start/end
-- ============================================================================
-- Overrides: H (High - jump to top of screen), L (Low - jump to bottom of screen)
vim.keymap.set("n", "H", "^", { desc = "Go to line start" })
vim.keymap.set("n", "L", "$", { desc = "Go to line end" })

-- ============================================================================
-- Search: Clear highlighting
-- ============================================================================
vim.keymap.set("n", "//", "<cmd>noh<cr>", { desc = "Clear search highlight" })

-- ============================================================================
-- Editing: Visual mode indent (preserve selection)
-- ============================================================================
-- The 'gv' command reselects the previously selected area
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- ============================================================================
-- Files: Find files (project-aware)
-- ============================================================================
-- Overrides: <leader>p (yank history in LazyVim default)
vim.keymap.set("n", "<leader>p", function()
  require("lazyvim.util").pick("files")()
end, { desc = "Find files" })

-- ============================================================================
-- Buffers: Alternate buffer
-- ============================================================================
-- Overrides: <leader><tab> (tab management prefix in LazyVim default)
vim.keymap.set("n", "<leader><tab>", "<cmd>buffer #<cr>", { desc = "Alternate buffer" })

-- ============================================================================
-- Windows: Toggle zoom
-- ============================================================================
-- Overrides: <leader>z (Zen mode in LazyVim default)
vim.keymap.set("n", "<leader>z", function()
  require("snacks").zen.zoom()
end, { desc = "Toggle zoom" })
```

### Disabling Overridden Plugin Keybindings
```lua
-- Source: https://lazy.folke.io/spec
-- In lua/plugins/yanky.lua (if you want to completely disable yanky keybindings)
return {
  "gbprod/yanky.nvim",
  keys = {
    -- Disable yank history on leader+p
    { "<leader>p", false },
  },
}
```

### Which-Key Group Registration (Optional)
```lua
-- Source: https://github.com/folke/which-key.nvim
-- In lua/plugins/which-key.lua (optional - only if you want custom groups)
return {
  "folke/which-key.nvim",
  opts = function(_, opts)
    -- Add custom group names (optional - desc field usually sufficient)
    opts.spec = opts.spec or {}
    vim.list_extend(opts.spec, {
      { "<leader>p", desc = "Find files" }, -- Override group name if needed
    })
  end,
}
```

### Testing Keybinding Conflicts
```lua
-- Source: Community best practice
-- Check what's mapped to a key before overriding
vim.cmd("verbose map H")  -- Shows what H is mapped to and where
vim.cmd("verbose map <leader>p")  -- Check leader+p mapping

-- List all keymaps with descriptions
vim.cmd("Telescope keymaps")  -- Visual browser of all keybindings
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| vim.api.nvim_set_keymap() | vim.keymap.set() | Neovim 0.7+ | Simpler API, better Lua integration, desc field support |
| which-key.register() | Auto-discovery via desc field | which-key.nvim v3 | No manual registration needed, stays in sync automatically |
| Manual picker selection | LazyVim.pick("files") | LazyVim 2024+ | Auto-switches git_files/find_files, project-aware |
| Custom zoom plugins | Snacks.zen.zoom() | LazyVim 2025+ | Integrated solution, maintained by LazyVim author |
| Plugin config function keymaps | Plugin spec keys table | lazy.nvim best practice | Better loading control, easier to disable/override |

**Deprecated/outdated:**
- `vim.api.nvim_set_keymap()`: Replaced by `vim.keymap.set()` (more ergonomic, supports functions)
- `which-key.register()`: v3 removed this API, use auto-discovery via desc field instead
- `LazyVim.safe_keymap_set`: Never use in user config, only internal to LazyVim core
- Global require("telescope").setup(): LazyVim handles Telescope config, override via plugin spec

## Open Questions

Things that couldn't be fully resolved:

1. **LazyVim.pick internal picker selection**
   - What we know: LazyVim.pick("files") switches between git_files and find_files based on git repo detection
   - What's unclear: Exact heuristic for git repo detection (looks for .git directory? git command?)
   - Recommendation: Use LazyVim.pick("files") as-is, it's battle-tested; override with explicit telescope commands only if behavior is wrong

2. **Snacks.nvim zoom vs LazyVim built-in zoom**
   - What we know: LazyVim has both `<leader>wm` (Toggle Zoom Mode) and `<leader>uz` (Toggle Zen Mode) by default
   - What's unclear: Difference between "Zoom Mode" and "Zen Mode" - both seem to maximize window
   - Recommendation: Test both; Snacks.zen.zoom() is likely the canonical LazyVim approach since Snacks is maintained by folke

3. **Plugin keybinding loading order edge cases**
   - What we know: keymaps.lua loads on VeryLazy, plugin config can run before or after depending on lazy-loading
   - What's unclear: Complete timing of all plugin events relative to VeryLazy
   - Recommendation: Default to keymaps.lua for global bindings, use plugin spec keys table if timing issues occur

## Sources

### Primary (HIGH confidence)
- [LazyVim Configuration - General](https://www.lazyvim.org/configuration/general) - Official keymaps.lua structure and vim.keymap.set usage
- [LazyVim Keymaps Documentation](https://www.lazyvim.org/keymaps) - Complete list of default LazyVim keybindings and conflicts
- [LazyVim Default Keymaps Source](https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua) - Exact implementation patterns
- [which-key.nvim GitHub](https://github.com/folke/which-key.nvim) - Modern API (v3) using add() and spec format
- [Neovim Motion Documentation](https://neovim.io/doc/user/motion.html) - Builtin H, L, ^, $ motion definitions
- [lazy.nvim Plugin Spec](https://lazy.folke.io/spec) - Keys table structure and usage

### Secondary (MEDIUM confidence)
- [LazyVim Telescope Integration](http://www.lazyvim.org/extras/editor/telescope) - LazyVim.pick behavior
- [LazyVim.pick Discussion #4323](https://github.com/LazyVim/LazyVim/discussions/4323) - How pick switches between git_files and find_files
- [Snacks.nvim GitHub](https://github.com/folke/snacks.nvim) - Snacks.zen.zoom() implementation (WebFetch)
- [LazyVim Keybinding Override Discussion #6557](https://github.com/LazyVim/LazyVim/discussions/6557) - Loading order and VeryLazy event timing

### Tertiary (LOW confidence)
- Community blog posts about LazyVim keybinding patterns (2024-2025)
- Stack Overflow discussions about visual mode indent patterns
- Various LazyVim user configs on GitHub (examples only)

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - All verified from official LazyVim and Neovim documentation
- Architecture: HIGH - Patterns confirmed in LazyVim source code and official docs
- Pitfalls: MEDIUM-HIGH - Loading order confirmed from discussions, others from community experience
- Code examples: HIGH - Direct from LazyVim source and official documentation

**Research date:** 2026-02-03
**Valid until:** 2026-03-03 (30 days - LazyVim is stable, breaking changes unlikely)

**Key constraints from CONTEXT.md:**
- Custom bindings override LazyVim defaults without checking (non-negotiable)
- H/L, //, visual indent, Leader+p, Leader+Tab, Leader+z are locked decisions
- Use Space as leader key (LazyVim default)
- Map old bindings to LazyVim plugin equivalents (Telescope, Snacks)
- Integrate all bindings with which-key for discoverability
- Config organized by category with comments for maintainability
