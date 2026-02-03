# Feature Research: LazyVim Migration

**Domain:** Neovim Configuration Migration (Vimscript to LazyVim)
**Researched:** 2026-02-03
**Confidence:** HIGH

## Feature Landscape

### Table Stakes (Users Expect These)

Features users assume exist. Missing these = product feels incomplete.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Buffer management with fuzzy finder | Core workflow - switching between open files | LOW | LazyVim includes Telescope with `<leader>,` for buffers, replaces FZF's `:Buffers` |
| File navigation with fuzzy finder | Core workflow - opening new files | LOW | LazyVim includes Telescope with `<leader><space>` and `<leader>ff`, replaces FZF's `:Files` |
| File tree explorer | Visual file browsing | LOW | LazyVim supports neo-tree (extra) or mini.files, replaces NERDTree |
| Window navigation shortcuts | Moving between splits efficiently | LOW | LazyVim has `<C-h/j/k/l>` built-in (identical to existing config) |
| Symbol/tag navigation | Code structure browsing | LOW | LazyVim includes symbols via `<leader>ss` (LSP) and Aerial plugin, replaces Vista/Tagbar |
| Go language support | Primary development language | MEDIUM | LazyVim has `extras.lang.go` with gopls, formatting, testing, debugging |
| LSP integration | Modern code intelligence | LOW | LazyVim has full LSP support built-in, replaces vim-lsp |
| Git integration | Version control awareness | LOW | LazyVim includes gitsigns.nvim (replaces gitgutter) and telescope-git integration |
| Clear search highlight | Quality of life feature | LOW | LazyVim has `<Esc>` to clear, can add custom `//` mapping |
| Visual indent preservation | Quality of life for code editing | LOW | LazyVim needs custom keymap `</>gv` pattern in keymaps.lua |
| which-key integration | Discoverability of keybindings | LOW | LazyVim includes which-key.nvim by default, auto-shows on `<leader>` press |

### Differentiators (Competitive Advantage)

Features that set the product apart. Not expected, but valuable.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Preserved muscle memory | Zero retraining time for existing keybindings | MEDIUM | Requires custom keymaps in `lua/config/keymaps.lua` to override defaults |
| Custom which-key labels | Self-documenting keybindings | LOW | Use `desc` field in keymaps or configure which-key groups |
| Zoom window toggle | Focus on single buffer without closing splits | LOW | LazyVim has `<leader>wm` (maximize toggle), replaces zoomwintab |
| Search/replace across files | Code refactoring workflow | LOW | LazyVim includes grug-far.nvim, can map to custom key |
| Custom Go shortcuts | Language-specific productivity | LOW | LazyVim's Go extra has debugging/testing, need custom maps for `got/gotf/gor/god` |

### Anti-Features (Commonly Requested, Often Problematic)

Features that seem good but create problems.

| Feature | Why Requested | Why Problematic | Alternative |
|---------|---------------|-----------------|-------------|
| Replicating exact plugin stack | "Don't want to change plugins" | Old plugins (NERDTree, vim-lsp) are less maintained, conflict with LazyVim architecture | Use LazyVim's modern equivalents (neo-tree, native LSP) with compatibility mappings |
| Custom leader key | "My muscle memory uses different leader" | LazyVim is designed around `<space>` leader, changing breaks integrations | Keep `<space>`, map old bindings to LazyVim equivalents |
| Disabling all LazyVim defaults | "Want clean slate" | LazyVim's value is its curated defaults and plugin integrations | Selectively override only conflicting keybindings |
| Loading vimscript configs | "Easier than converting" | Mixed vim/lua configs are harder to debug, lose LazyVim's lazy-loading benefits | Convert to Lua systematically |

## Feature Dependencies

```
LazyVim Base
    ├──requires──> Lazy.nvim (plugin manager)
    └──requires──> which-key.nvim (built-in)

Custom Keybindings
    ├──requires──> LazyVim Base (loaded first)
    └──enhances──> which-key (auto-detects desc fields)

Go Development
    ├──requires──> extras.lang.go (LazyVim extra)
    └──requires──> Custom keybindings (for got/gotf/gor/god)

File Navigation
    ├──uses──> Telescope (LazyVim default picker)
    └──or──> fzf-lua (alternative, requires extra)

File Tree
    ├──uses──> neo-tree (recommended extra)
    └──or──> mini.files (lighter alternative)
```

### Dependency Notes

- **LazyVim Base requires Lazy.nvim:** LazyVim is built on top of the Lazy.nvim plugin manager, not minpac
- **Custom keybindings enhance which-key:** When keymaps include `desc` field, which-key automatically picks them up
- **File Tree options conflict:** Choose either neo-tree or mini.files, not both (different philosophies)
- **Go extra requires setup:** Must enable via `:LazyExtras` command, then add custom keymaps

## Configuration Structure Mapping

### Old Structure (Vimscript)
```
~/.config/nvim/
├── init.vim (main config, sources other files)
├── languages/
│   ├── elm.vim
│   ├── golang.vim
│   └── ruby.vim
└── plugins/
    ├── fzf.vim
    ├── nerdtree.vim
    ├── vim-lsp.vim
    └── vista.vim
```

### New Structure (LazyVim)
```
~/.config/nvim/
├── init.lua (minimal, just bootstraps LazyVim)
├── lua/
│   ├── config/
│   │   ├── autocmds.lua (autocommands, replaces Go augroup)
│   │   ├── keymaps.lua (custom keybindings, MAIN FILE FOR MIGRATION)
│   │   ├── lazy.lua (plugin manager setup)
│   │   └── options.lua (vim settings, replaces init.vim options)
│   └── plugins/
│       ├── telescope.lua (customize telescope keybindings)
│       ├── neo-tree.lua (customize file tree)
│       ├── which-key.lua (add custom groups/labels)
│       └── go.lua (Go-specific config overrides)
└── lazyvim.json (enabled extras, e.g., lang.go)
```

**Critical Loading Order:**
1. LazyVim defaults load first automatically
2. `lua/config/*.lua` files auto-load at appropriate time (DO NOT require manually)
3. `lua/plugins/*.lua` files merge with defaults (keys extend, other props override)
4. Custom keymaps in `lua/config/keymaps.lua` have highest priority

## LazyVim Built-in Features vs. Old Plugins

| Old Plugin | LazyVim Built-in Replacement | Migration Path |
|------------|------------------------------|----------------|
| minpac | Lazy.nvim | No action needed - LazyVim bootstraps automatically |
| fzf + fzf.vim | Telescope (default picker) | Map old `<leader>j/p/gr` to telescope functions |
| NERDTree | neo-tree.nvim (extra) | Enable extra, map `<leader>\` to `:Neotree toggle` |
| vim-lsp | Native LSP + nvim-lspconfig | No action - LazyVim configures LSP automatically |
| Vista | Aerial (symbols) + Telescope LSP | Map `<leader>t` to `:Telescope lsp_document_symbols` or `:AerialToggle` |
| vim-go | extras.lang.go + nvim-dap-go | Enable extra, add custom keymaps for got/gotf/gor/god |
| vim-gitgutter | gitsigns.nvim | No action - included by default |
| lightline | lualine.nvim | No action - included by default |
| vim-startify | snacks.nvim dashboard | No action - included by default |
| zoomwintab | Snacks or native maximize | Map `<leader>z` to `<leader>wm` or use Snacks zoom |
| vim-surround | mini.surround | No action - included by default |
| editorconfig | Already supported | Check if works with LazyVim's formatting |

## Keybinding Migration Matrix

### Direct Equivalents (No Custom Config Needed)

| Old Binding | LazyVim Default | Notes |
|-------------|-----------------|-------|
| `<C-h/j/k/l>` | `<C-h/j/k/l>` | Identical window navigation |
| H (line start) | - | Need custom map: `noremap H ^` |
| L (line end) | - | Need custom map: `noremap L $` |
| `<leader><Tab>` | `<leader>bb` | Buffer switch, need alias |

### Replacements (Map Old to LazyVim Function)

| Old Binding | Old Command | LazyVim Equivalent | Custom Config Required |
|-------------|-------------|-------------------|------------------------|
| `<leader>j` | `:Buffers` | `<leader>,` or `:Telescope buffers` | Map `<leader>j` to telescope.buffers |
| `<leader>p` | `:Files` | `<leader><space>` or `:Telescope find_files` | Map `<leader>p` to telescope.find_files |
| `<leader>\` | `:NERDTreeToggle` | `:Neotree toggle` | Map `<leader>\` to neotree toggle |
| `<leader>t` | `:Vista!!` | `:Telescope lsp_document_symbols` or `:AerialToggle` | Choose symbol browser, map to `<leader>t` |
| `<leader>z` | `:ZoomWinTabToggle` | `<leader>wm` (maximize) | Alias or remap zoom function |
| `<leader>gr` | `:Ag` | `<leader>/` or `:Telescope live_grep` | Map `<leader>gr` to telescope.live_grep |
| `//` | `:noh` | `<Esc>` (LazyVim default) | Add custom map for `//` -> `:noh` |

### Go-Specific (New Custom Keymaps)

| Old Binding | Old Command | LazyVim Approach | Custom Config Required |
|-------------|-------------|------------------|------------------------|
| `<leader>got` | `:GoTest` | Use neotest-golang or vim-go | Map to `:lua require('neotest').run.run()` or keep vim-go |
| `<leader>gotf` | `:GoTestFunc` | Use neotest-golang | Map to `:lua require('neotest').run.run()` (nearest test) |
| `<leader>gor` | `:GoRun` | Use vim-go or terminal | Map to `:GoRun` if keeping vim-go, or terminal command |
| `<leader>god` | `:GoDef` | Use LSP `gd` | Map to `vim.lsp.buf.definition()` or keep as alias |

### Visual Mode (Custom Config)

| Old Binding | Old Behavior | LazyVim Default | Custom Config Required |
|-------------|--------------|-----------------|------------------------|
| `< (visual)` | Indent left, keep selection | Indent left, lose selection | Map `v < <gv` |
| `> (visual)` | Indent right, keep selection | Indent right, lose selection | Map `v > >gv` |

## which-key Integration Patterns

### Pattern 1: Keymap with Description (Automatic)

Add to `lua/config/keymaps.lua`:
```lua
vim.keymap.set("n", "<leader>j", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
```

which-key **automatically** picks up the `desc` field and shows it in the popup.

### Pattern 2: Custom which-key Groups

Add to `lua/plugins/which-key.lua`:
```lua
return {
  "folke/which-key.nvim",
  opts = {
    spec = {
      { "<leader>go", group = "Go" },
    },
  },
}
```

Shows `+Go` when pressing `<leader>go`, organizes related commands.

### Pattern 3: Plugin Keymap with Description

Add to `lua/plugins/telescope.lua`:
```lua
return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader>p", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
  },
}
```

Plugin-specific keymaps with which-key integration.

## Customization Points

### 1. Keymaps File (`lua/config/keymaps.lua`)
**Purpose:** Override or add keybindings
**What goes here:**
- Muscle memory mappings (H/L, //, `<leader>j/p/t/z`)
- Visual mode indent preservation
- Go-specific shortcuts
- Any custom mappings not plugin-specific

**Pattern:**
```lua
local map = vim.keymap.set

-- Movement
map("n", "H", "^", { desc = "Start of line" })
map("n", "L", "$", { desc = "End of line" })

-- Clear search
map("n", "//", "<cmd>noh<cr>", { desc = "Clear search highlight" })

-- Visual indent
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })
```

### 2. Plugin Override Files (`lua/plugins/*.lua`)
**Purpose:** Customize specific plugin behavior
**What goes here:**
- Plugin-specific keybindings (telescope, neo-tree)
- Plugin configuration overrides
- Disabling unwanted plugins

**Pattern:**
```lua
-- lua/plugins/telescope.lua
return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader>p", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>j", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>gr", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
  },
}
```

### 3. which-key Configuration (`lua/plugins/which-key.lua`)
**Purpose:** Add group labels for keybinding organization
**What goes here:**
- Custom group definitions
- Leader submenu labels

**Pattern:**
```lua
return {
  "folke/which-key.nvim",
  opts = {
    spec = {
      { "<leader>go", group = "Go" },
    },
  },
}
```

### 4. Options File (`lua/config/options.lua`)
**Purpose:** Vim settings (not keybindings)
**What goes here:**
- Editor behavior (tabstop, shiftwidth, etc.)
- UI settings (number, wrap, etc.)
- Performance settings

**Pattern:**
```lua
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.list = true
vim.opt.listchars = { tab = "»·", trail = "·" }
```

### 5. Autocmds File (`lua/config/autocmds.lua`)
**Purpose:** Auto-commands for file types
**What goes here:**
- Go-specific settings (nolist for .go files)
- Filetype detection
- Auto-formatting triggers

**Pattern:**
```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.list = false
  end,
})
```

## LazyVim Feature Discovery Mechanisms

| Mechanism | Keybinding | Purpose |
|-----------|-----------|---------|
| which-key popup | `<space>` (wait) | Shows all leader keybindings hierarchically |
| Telescope keymaps | `<leader>sk` | Searchable list of all keybindings |
| LazyExtras UI | `:LazyExtras` | Browse/enable language and feature extras |
| Lazy plugin manager | `:Lazy` | Manage plugins, see configs, check health |
| Mason LSP installer | `:Mason` | Install LSP servers, linters, formatters |

## MVP Recommendation

For initial migration, prioritize:

1. **LazyVim installation** - Bootstrap and verify base config loads
2. **Keybinding preservation** - Add custom keymaps in `lua/config/keymaps.lua` for muscle memory
3. **Go language support** - Enable `extras.lang.go` via `:LazyExtras`
4. **File navigation** - Map old telescope/fzf keys to new telescope functions
5. **File tree** - Enable neo-tree extra, map `<leader>\`
6. **which-key labels** - Add group labels for custom Go commands

Defer to post-migration:
- **Symbol navigation optimization** - Test Aerial vs telescope symbols, pick one
- **Zoom functionality** - Verify if `<leader>wm` suffices or need custom zoom
- **Search/replace UI** - Test grug-far.nvim vs telescope for `<leader>gr` workflow
- **Plugin cleanup** - Remove unused LazyVim defaults if needed

## Migration Phases

### Phase 1: Foundation (Core keybindings work)
- LazyVim installed and loads
- Basic movement (H/L, `<C-hjkl>`, //)
- Buffer/file navigation (`<leader>j/p`)
- Visual indent (`</>`)

### Phase 2: Development Tools (Go workflow restored)
- Go extra enabled with LSP
- Symbol navigation (`<leader>t`)
- File tree (`<leader>\`)
- Window zoom (`<leader>z`)

### Phase 3: Advanced Features (Nice-to-haves)
- Custom which-key groups
- Go-specific shortcuts (got/gotf/gor/god)
- Search/replace (`<leader>gr` optimized)
- Git integration verified

## Sources

**Official Documentation (HIGH confidence):**
- [LazyVim Configuration Structure](https://www.lazyvim.org/configuration/general)
- [LazyVim Keymaps Documentation](https://www.lazyvim.org/configuration/keymaps)
- [LazyVim Plugin Customization](https://www.lazyvim.org/configuration/plugins)
- [LazyVim Default Keybindings](https://www.lazyvim.org/keymaps)
- [LazyVim Go Language Support](https://www.lazyvim.org/extras/lang/go)
- [LazyVim Editor Plugins](https://www.lazyvim.org/plugins/editor)
- [LazyVim Examples](https://www.lazyvim.org/configuration/examples)

**Community Resources (MEDIUM confidence):**
- [Customizing LazyVim Keymaps Article](https://levelup.gitconnected.com/customizing-lazyvim-overrides-and-new-keymaps-plugins-528feeb547df)
- [Which-Key Integration Discussion](https://github.com/LazyVim/LazyVim/discussions/1844)
- [Telescope Keybindings Discussion](https://github.com/LazyVim/LazyVim/discussions/2940)
- [Neo-Tree Configuration Discussion](https://github.com/LazyVim/LazyVim/discussions/1492)
- [LazyVim Cheat Sheet](https://gist.github.com/JTRNS/51d183cb42c03315e5db04f3090d0b60)

**Source Code (HIGH confidence):**
- [LazyVim Default Keymaps Implementation](https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua)

---
*Feature research for: LazyVim Migration*
*Researched: 2026-02-03*
