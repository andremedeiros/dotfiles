# Architecture Research

**Domain:** LazyVim Configuration in rcm-managed Dotfiles
**Researched:** 2026-02-03
**Confidence:** HIGH

## Standard Architecture

### LazyVim System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Neovim Entry Point                        │
│                     ~/.config/nvim/                          │
├─────────────────────────────────────────────────────────────┤
│  init.lua                                                     │
│    └─> require("config.lazy")  [Bootstrap lazy.nvim]        │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                    Configuration Layer                       │
│                     lua/config/*.lua                         │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │   lazy.lua   │  │ options.lua  │  │ keymaps.lua  │       │
│  │  [Bootstrap] │  │ [Vim Options]│  │  [Bindings]  │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
│  ┌──────────────┐                                            │
│  │autocmds.lua  │                                            │
│  │[Autocommands]│                                            │
│  └──────────────┘                                            │
├─────────────────────────────────────────────────────────────┤
│                    Plugin Layer                              │
│                  lua/plugins/*.lua                           │
├─────────────────────────────────────────────────────────────┤
│  ┌────────────┐  ┌────────────┐  ┌────────────┐             │
│  │ Plugin     │  │ Plugin     │  │ Extras     │             │
│  │ Specs      │  │ Overrides  │  │ Config     │             │
│  └────────────┘  └────────────┘  └────────────┘             │
├─────────────────────────────────────────────────────────────┤
│                    LazyVim Core                              │
│              (Loaded by lazy.nvim)                           │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────────────┐   │
│  │           LazyVim Default Configuration               │   │
│  │      (Preconfigured plugins and settings)             │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘

rcm Integration:
  dotfiles/config/nvim/ --> symlink --> ~/.config/nvim/
        │
        └─> Post-hook: hooks/post-up/XX-lazyvim-bootstrap
```

### Component Responsibilities

| Component | Responsibility | Typical Implementation |
|-----------|----------------|------------------------|
| `init.lua` | Entry point, bootstraps lazy.nvim | 2-line file: require("config.lazy") |
| `lua/config/lazy.lua` | lazy.nvim setup, plugin manager config | Bootstraps lazy.nvim if missing, configures plugin manager |
| `lua/config/options.lua` | Neovim options (set statements) | Vim settings: number, clipboard, indent, etc. |
| `lua/config/keymaps.lua` | Global key mappings | Custom keybindings using vim.keymap.set |
| `lua/config/autocmds.lua` | Event-driven behaviors | Autocommands for file-specific behavior |
| `lua/plugins/*.lua` | Plugin specifications | Tables defining plugins, configs, and keymaps |
| LazyVim Core | Default plugin bundle | Prepackaged plugins with sensible defaults |
| rcm post-hook | Automated installation | Ensures lazy.nvim is available on first run |

## Recommended Project Structure

### LazyVim in Dotfiles Repository

```
dotfiles/
├── config/
│   └── nvim/                      # Symlinked to ~/.config/nvim by rcm
│       ├── init.lua               # Entry point (require config.lazy)
│       └── lua/
│           ├── config/            # Core configuration (auto-loaded)
│           │   ├── lazy.lua       # lazy.nvim bootstrap & config
│           │   ├── options.lua    # Vim options
│           │   ├── keymaps.lua    # Global keymaps
│           │   └── autocmds.lua   # Autocommands
│           └── plugins/           # Plugin specs (auto-loaded)
│               ├── editor.lua     # Editor-related plugin overrides
│               ├── coding.lua     # Coding plugins (LSP, completion)
│               ├── ui.lua         # UI customizations
│               └── custom.lua     # Your custom plugins
├── hooks/
│   └── post-up/
│       └── XX-lazyvim-bootstrap   # Install lazy.nvim if missing
└── README.md
```

### Post-Bootstrap Runtime Structure

After first run, lazy.nvim creates additional directories:

```
~/.config/nvim/                    # Your dotfiles symlink
├── init.lua                       # (Your file)
├── lua/                           # (Your files)
│   ├── config/
│   └── plugins/
└── lazyvim.json                   # LazyVim state (auto-generated)

~/.local/share/nvim/               # Neovim data directory
└── lazy/                          # Plugin installations
    ├── lazy.nvim/                 # Plugin manager
    ├── LazyVim/                   # LazyVim core
    └── [other-plugins]/           # Installed plugins

~/.local/state/nvim/               # Neovim state
└── lazy/                          # Plugin state
```

### Structure Rationale

- **`config/nvim/` top-level:** Matches rcm convention where `config/` becomes `~/.config/`
- **Minimal `init.lua`:** Single require statement keeps entry point clean
- **`lua/config/` separation:** LazyVim auto-loads these at appropriate times
- **`lua/plugins/` modularity:** Organize by category (editor, coding, ui, etc.)
- **Post-hook integration:** rcm runs hook after symlinking, ensures lazy.nvim exists
- **Git-ignored runtime:** `lazyvim.json` and plugin installations stay out of version control

## Configuration Loading Order

### Startup Sequence

```
1. Neovim starts
     ↓
2. init.lua executes
     ↓ require("config.lazy")
3. lua/config/lazy.lua runs
     ↓ Bootstrap check
4. [If first run] Clone lazy.nvim to ~/.local/share/nvim/lazy/lazy.nvim
     ↓
5. lazy.nvim plugin manager starts
     ↓
6. Load LazyVim core plugin ("LazyVim/LazyVim")
     ↓
7. LazyVim loads lua/config/options.lua (before lazy.nvim startup)
     ↓
8. Lazy.nvim installs/loads all plugins
     ↓
9. [VeryLazy event] LazyVim loads lua/config/autocmds.lua
     ↓
10. [VeryLazy event] LazyVim loads lua/config/keymaps.lua
     ↓
11. All plugins initialized, Neovim ready
```

### Key Timing Points

| Phase | When | What Loads | Why |
|-------|------|------------|-----|
| Bootstrap | First run only | lazy.nvim clone | Ensures plugin manager exists |
| Pre-startup | Before plugins | `options.lua` | Options must be set before plugins load |
| Startup | Plugin load | All plugins via `lua/plugins/*.lua` | Core and custom plugins initialize |
| VeryLazy | After UI ready | `autocmds.lua`, `keymaps.lua` | Non-blocking, improves startup time |

### Important Auto-loading Behavior

- **Files under `lua/config/` are automatically loaded** at appropriate times by LazyVim
- **Files under `lua/plugins/` are automatically loaded** by lazy.nvim
- **You MUST NOT manually require** these files or LazyVim internals
- **Default configs load first**, then user configs override/extend them

## Architectural Patterns

### Pattern 1: Configuration Layering

**What:** User configurations layer on top of LazyVim defaults through merging

**When to use:** Customizing any LazyVim-provided plugin

**Trade-offs:**
- PRO: Minimal config needed, only specify differences
- PRO: Inherits LazyVim updates automatically
- CON: Need to understand merge semantics (some fields merge, others override)

**Example:**
```lua
-- lua/plugins/telescope.lua
-- LazyVim includes telescope by default, this extends it
return {
  "nvim-telescope/telescope.nvim",
  keys = {
    -- Disable default <leader>ff keymap
    { "<leader>ff", false },
    -- Add custom keymap
    { "<leader>p", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
  },
  opts = {
    -- Merge with default opts
    defaults = {
      layout_strategy = "vertical",
    },
  },
}
```

### Pattern 2: Modular Plugin Organization

**What:** Group related plugin specs into category files

**When to use:** Always - improves maintainability

**Trade-offs:**
- PRO: Easy to locate configurations
- PRO: Can selectively disable entire categories
- CON: Need to decide on categorization scheme

**Example:**
```lua
-- lua/plugins/editor.lua
return {
  { "nvim-telescope/telescope.nvim", opts = { ... } },
  { "nvim-neo-tree/neo-tree.nvim", opts = { ... } },
  { "folke/flash.nvim", opts = { ... } },
}

-- lua/plugins/coding.lua
return {
  { "neovim/nvim-lspconfig", opts = { ... } },
  { "hrsh7th/nvim-cmp", opts = { ... } },
}
```

### Pattern 3: Keybinding Discovery with which-key

**What:** All keybindings include `desc` field for which-key integration

**When to use:** Every custom keymap definition

**Trade-offs:**
- PRO: Self-documenting keybindings
- PRO: which-key popup shows available keys
- CON: Slight verbosity (must add desc to every map)

**Example:**
```lua
-- lua/config/keymaps.lua
vim.keymap.set("n", "<leader>p", "<cmd>Telescope find_files<cr>",
  { desc = "Find Files" })
vim.keymap.set("n", "<leader>j", "<cmd>Telescope buffers<cr>",
  { desc = "List Buffers" })

-- In plugin specs (lua/plugins/*.lua)
return {
  "some/plugin.nvim",
  keys = {
    { "<leader>t", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
  },
}

-- which-key groups
return {
  "folke/which-key.nvim",
  opts = {
    spec = {
      { "<leader>g", group = "git" },
      { "<leader>f", group = "find" },
    },
  },
}
```

### Pattern 4: LazyVim Extras

**What:** Opt-in plugin bundles managed by LazyVim

**When to use:** Adding language support, tools, or feature sets

**Trade-offs:**
- PRO: Pre-configured, tested plugin combinations
- PRO: Can enable via `:LazyExtras` command
- CON: Less granular control than manual plugin specs

**Example:**
```lua
-- lua/config/lazy.lua
require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Import LazyVim extras
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.ui.dashboard" },
    -- Your custom plugins
    { import = "plugins" },
  },
})
```

## Data Flow

### Configuration Application Flow

```
User edits config file
    ↓
rcup symlinks changes
    ↓
User restarts Neovim (or :source)
    ↓
init.lua → config.lazy
    ↓
lazy.nvim processes plugin specs
    ↓
LazyVim merges user config with defaults
    ↓
Plugins initialize with merged config
    ↓
which-key registers keymaps
```

### Plugin Specification Merging

```
LazyVim Default Spec (from LazyVim core)
    ↓
User Spec (from lua/plugins/*.lua)
    ↓
Merge Logic:
  - Mergeable fields (keys, opts, event, cmd, ft): EXTEND defaults
  - Other fields: OVERRIDE defaults
    ↓
Final Plugin Configuration
    ↓
lazy.nvim installs/configures plugin
```

### Key Data Flows

1. **Keymap Registration:** `keymaps.lua` → vim.keymap.set → which-key auto-registers with desc
2. **Options Loading:** `options.lua` → vim.opt.X = Y → Applied before plugins load
3. **Plugin Installation:** First run → lazy.nvim detects missing plugins → Installs to ~/.local/share/nvim/lazy/
4. **LazyVim State:** Configuration changes → lazyvim.json updated → Persists extras, version info

## Integration Points

### rcm Dotfiles System

| Integration | How It Works | Critical Details |
|-------------|--------------|------------------|
| Symlinking | rcm creates `~/.config/nvim → dotfiles/config/nvim` | rcm adds dots automatically, so `config/` (no dot) → `~/.config/` |
| Post-hooks | `hooks/post-up/XX-lazyvim-bootstrap` runs after rcup | Must be executable, runs every time, must be idempotent |
| Version control | Only track dotfiles repo, not runtime artifacts | `.gitignore` should exclude `lazyvim.json`, `lazy-lock.json` (if not tracking versions) |
| Multiple machines | Same dotfiles, post-hook ensures lazy.nvim on each | Bootstrap is idempotent, safe to run multiple times |

### LazyVim to lazy.nvim

| Boundary | Communication | Notes |
|----------|---------------|-------|
| config.lazy.lua → lazy.nvim | `require("lazy").setup({ spec = {...} })` | Defines what plugins to load |
| LazyVim core → user config | Spec merging | LazyVim default specs merge with user specs |
| Plugin specs → lazy.nvim | Return tables from lua/plugins/*.lua | All files auto-loaded, tables combined |

### which-key Integration

| Boundary | Communication | Notes |
|----------|---------------|-------|
| keymaps.lua → which-key | `desc` field in keymap definitions | which-key auto-registers if desc present |
| Plugin specs → which-key | `desc` in keys table | Plugin-specific keymaps also auto-register |
| which-key config → groups | `spec` in opts | Define logical groupings like "git", "find" |

## Anti-Patterns

### Anti-Pattern 1: Manual Requires

**What people do:** Add `require("lazyvim.config.options")` or `require("plugins.something")` in init.lua
**Why it's wrong:** LazyVim auto-loads these files at the correct time; manual requires cause double-loading or timing issues
**Do this instead:** Let LazyVim's auto-loading handle it; only use require for external modules

### Anti-Pattern 2: Overwriting Entire Plugin Specs

**What people do:** Copy entire LazyVim plugin spec, modify one line
**Why it's wrong:** Loses benefit of LazyVim updates; creates maintenance burden
**Do this instead:** Only specify fields you want to change; lazy.nvim merges them

**Bad:**
```lua
-- Copying entire spec just to change one option
return {
  "nvim-telescope/telescope.nvim",
  cmd = { "Telescope" },
  keys = { -- 50 lines of default keymaps copied... },
  opts = {
    -- Changed one thing here
    defaults = { layout_strategy = "vertical" },
    -- But also had to copy all the other defaults
  },
}
```

**Good:**
```lua
-- Only override what you need
return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      layout_strategy = "vertical",
    },
  },
}
```

### Anti-Pattern 3: Config Files in Wrong Locations

**What people do:** Put keymaps in `lua/keymaps.lua` or plugins in `lua/my-plugins.lua`
**Why it's wrong:** LazyVim auto-loads specific paths; files in wrong location won't load
**Do this instead:** Follow structure: `lua/config/*.lua` for core, `lua/plugins/*.lua` for plugins

### Anti-Pattern 4: Installing lazy.nvim Manually

**What people do:** Clone lazy.nvim to wrong location, or assume it's installed globally
**Why it's wrong:** lazy.nvim expects to be in Neovim data directory; wrong location breaks plugin loading
**Do this instead:** Use bootstrap code in `config.lazy.lua` or post-hook; let it install to correct path

### Anti-Pattern 5: Mixing VimScript and Lua Config

**What people do:** Keep `init.vim`, try to load Lua config with `lua require()`
**Why it's wrong:** LazyVim is Lua-first; mixing creates complexity and loading order issues
**Do this instead:** Full migration to `init.lua`; convert VimScript settings to Lua equivalents

**Migration example:**
```vim
" Old VimScript (init.vim)
set number
set expandtab
nnoremap <leader>p :Files<CR>
```

```lua
-- New Lua (lua/config/options.lua)
vim.opt.number = true
vim.opt.expandtab = true

-- New Lua (lua/config/keymaps.lua)
vim.keymap.set("n", "<leader>p", "<cmd>Telescope find_files<cr>",
  { desc = "Find Files" })
```

## Scaling Considerations

LazyVim is designed for single-user editor configuration; scaling considerations focus on config complexity, not concurrent users.

| Scale | Architecture Adjustments |
|-------|--------------------------|
| Basic user (10-20 plugins) | Use LazyVim starter as-is, minimal customization in `lua/plugins/` |
| Power user (50-100 plugins) | Organize `lua/plugins/` by category, use LazyVim extras, may need custom LSP configs |
| Heavy customization (100+ plugins) | Consider performance tuning in `lua/config/lazy.lua`, use lazy-loading extensively, profile with `:Lazy profile` |

### Scaling Priorities

1. **First bottleneck: Startup time with many plugins**
   - **Detection:** `:Lazy profile` shows slow-loading plugins
   - **Mitigation:** Use lazy-loading (event, cmd, keys), disable unused LazyVim defaults

2. **Second bottleneck: Config file organization**
   - **Detection:** Difficulty finding plugin configs, merge conflicts in single file
   - **Mitigation:** Split `lua/plugins/` into multiple category files, use consistent naming

## Migration Path: VimScript to LazyVim

### Current Architecture (VimScript + minpac)

```
config/nvim/
├── init.vim                       # Monolithic config (190 lines)
├── languages/
│   ├── elm.vim
│   ├── golang.vim
│   └── ruby.vim
└── plugins/
    ├── fzf.vim
    ├── gitgutter.vim
    ├── lightline.vim
    ├── nerdtree.vim
    ├── startify.vim
    ├── vim-lsp.vim
    └── vista.vim

~/.config/nvim/pack/minpac/opt/minpac/   # Plugin manager
~/.config/nvim/pack/minpac/start/         # Installed plugins
```

### Target Architecture (Lua + LazyVim)

```
config/nvim/
├── init.lua                       # 2 lines: require("config.lazy")
└── lua/
    ├── config/
    │   ├── lazy.lua               # Bootstrap lazy.nvim
    │   ├── options.lua            # From init.vim set statements
    │   ├── keymaps.lua            # From init.vim nnoremap statements
    │   └── autocmds.lua           # From init.vim autocmd statements
    └── plugins/
        ├── editor.lua             # NERDTree → neo-tree, fzf → telescope
        ├── ui.lua                 # lightline → lualine, startify → dashboard
        ├── coding.lua             # vim-lsp → nvim-lspconfig
        └── languages.lua          # Language-specific (treesitter, LSP)

~/.local/share/nvim/lazy/          # Plugins (not in dotfiles)
```

### Recommended Migration Order

1. **Create parallel structure** - Keep init.vim, create minimal init.lua that does nothing
2. **Bootstrap lazy.nvim** - Create `lua/config/lazy.lua` with minimal setup
3. **Migrate options** - Move `set` statements to `lua/config/options.lua`
4. **Migrate keymaps** - Move `nnoremap` to `lua/config/keymaps.lua` with which-key integration
5. **Migrate autocmds** - Move `autocmd` to `lua/config/autocmds.lua`
6. **Add LazyVim core** - Enable LazyVim in lazy.lua spec
7. **Replace plugins incrementally:**
   - NERDTree → neo-tree (LazyVim includes this)
   - fzf → telescope (LazyVim includes this)
   - lightline → lualine (LazyVim includes this)
   - vim-lsp → nvim-lspconfig (LazyVim includes this)
8. **Test thoroughly** - Run both configs in parallel until confident
9. **Remove old config** - Delete init.vim and VimScript plugin configs
10. **Update post-hook** - Replace minpac bootstrap with lazy.nvim bootstrap

### Key Decision Points

- **Keep lazy-lock.json in git?**
  - YES if you want reproducible plugin versions across machines
  - NO if you want latest versions always

- **Track lazyvim.json in git?**
  - NO - This is runtime state, machine-specific

- **Use LazyVim extras or manual plugins?**
  - EXTRAS for well-supported languages (Go, TypeScript, Python)
  - MANUAL for niche tools or heavy customization

## Sources

**Official Documentation:**
- [LazyVim Configuration](http://www.lazyvim.org/configuration) - Structure and auto-loading
- [LazyVim General Settings](http://www.lazyvim.org/configuration/general) - Core config files
- [LazyVim Plugins](http://www.lazyvim.org/plugins) - Plugin categories
- [LazyVim Plugin Configuration](http://www.lazyvim.org/configuration/plugins) - Customization and merging
- [LazyVim Installation](https://www.lazyvim.org/installation) - Bootstrap and setup
- [LazyVim Keymaps](http://www.lazyvim.org/configuration/keymaps) - Keymap patterns
- [LazyVim Extras](https://www.lazyvim.org/extras) - `:LazyExtras` command
- [LazyVim Starter - init.lua](https://github.com/LazyVim/starter/blob/main/init.lua) - Entry point
- [LazyVim Starter - lazy.lua](https://github.com/LazyVim/starter/blob/main/lua/config/lazy.lua) - Bootstrap code
- [lazy.nvim Installation](https://lazy.folke.io/installation) - Plugin manager setup

**rcm Integration:**
- [RCM Documentation](https://thoughtbot.github.io/rcm/) - Dotfiles management
- [rcup man page](https://thoughtbot.github.io/rcm/rcup.1.html) - Hook execution
- [GitHub - thoughtbot/rcm](https://github.com/thoughtbot/rcm) - rcm source

**Community Resources:**
- [Share your Lazy dotfiles](https://github.com/LazyVim/LazyVim/discussions/766) - Community patterns
- [Customizing LazyVim](https://andrewcourter.substack.com/p/customizing-lazyvim-overrides-and) - Override patterns
- [Getting Started with RCM](https://blog.jez.io/2015/03/09/getting-started-with-rcm/) - rcm workflow

---
*Architecture research for: LazyVim migration in rcm-managed dotfiles*
*Researched: 2026-02-03*
