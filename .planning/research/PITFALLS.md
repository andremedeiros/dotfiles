# LazyVim Migration Pitfalls

**Domain:** Neovim Configuration Migration (Vimscript to LazyVim)
**Researched:** 2026-02-03
**Confidence:** HIGH

## Critical Pitfalls

### Pitfall 1: Manually Requiring Auto-Loaded Configuration Files

**What goes wrong:**
Users manually `require()` configuration files like `lua/config/keymaps.lua`, `lua/config/options.lua`, `lua/config/autocmds.lua`, or `lua/config/lazy.lua` in their init.lua or other files. LazyVim then loads these files a second time automatically, causing duplicate keybindings, option settings, or plugin registrations.

**Why it happens:**
Coming from manual Neovim/Lua configs or other frameworks, users are accustomed to explicitly requiring all configuration modules. LazyVim's automatic loading isn't obvious from typical Neovim documentation.

**Consequences:**
- Keybindings execute twice
- Options get set redundantly (usually benign but wastes startup time)
- Plugins may be registered multiple times, causing lazy.nvim warnings
- Autocmds fire twice, potentially causing race conditions or duplicate actions

**Prevention:**
Never use `require("config.keymaps")`, `require("config.options")`, `require("config.autocmds")`, or `require("config.lazy")` anywhere in your configuration. LazyVim loads these automatically at the appropriate time during startup.

**Warning signs:**
- Keybindings seem to trigger multiple times
- `:Lazy` shows duplicate plugin entries
- `:messages` shows duplicate autocmd execution
- Startup time is higher than expected

**Phase to address:**
Phase 1 (Configuration Structure) - Document the auto-loading behavior prominently in setup documentation

**Sources:**
- [LazyVim General Settings Documentation](https://www.lazyvim.org/configuration/general)

---

### Pitfall 2: Overriding Plugin Config Without Disabling Original Keymaps

**What goes wrong:**
User sets a custom keymap for a function that already has a LazyVim default keymap. Both keymaps persist, but the new one may not work because the old one still "owns" the key sequence. If the custom keymap is a prefix of an existing keymap (e.g., `<leader>f` when `<leader>fr` exists), Neovim waits for the timeout to determine which one to execute, causing noticeable delays.

**Why it happens:**
LazyVim's keymap system loads defaults first, then user configs. Simply defining a new keymap with `vim.keymap.set()` doesn't automatically remove the conflicting default. Users expect "last one wins" behavior from other editors or frameworks.

**Consequences:**
- Keymap delays (timeout waits) making the editor feel sluggish
- Keymaps don't work as expected
- which-key shows both the default and custom binding, causing confusion
- Original keymap may silently win, making custom keymap appear broken

**Prevention:**
For global keymaps in `lua/config/keymaps.lua`: First delete the conflicting keymap with `vim.keymap.del("n", "<leader>key")`, then set your new keymap.

For plugin-specific keymaps: Disable them in the plugin spec using `keys = { { "<leader>key", false } }`, then add your custom keymap elsewhere.

For which-key group conflicts: Hide the conflicting group with `opts = { spec = { { "<leader>key", hidden = true } } }` in your which-key plugin spec.

**Warning signs:**
- Noticeable delay after pressing leader key combinations
- `:checkhealth which-key` reports conflicting keymaps
- Custom keymaps don't execute the expected function
- which-key popup shows multiple entries for same key

**Phase to address:**
Phase 2 (Keybinding Migration) - Systematically identify and disable conflicting defaults before adding custom keymaps

**Sources:**
- [LazyVim Keymaps Documentation](https://www.lazyvim.org/configuration/keymaps)
- [Conflicting Keymaps Discussion](https://github.com/LazyVim/LazyVim/discussions/3863)
- [Removing Default Keybindings Discussion](https://github.com/LazyVim/LazyVim/discussions/1186)
- [Custom Keymap Override Discussion](https://github.com/LazyVim/LazyVim/discussions/6557)

---

### Pitfall 3: Using `config` Function Instead of `opts` for Plugin Configuration

**What goes wrong:**
User overrides a plugin's setup using `config = function() ... end` instead of `opts = { ... }`. LazyVim's automatic merging of plugin configurations from multiple sources (base LazyVim, extras, user config) stops working. Only the last `config` function is executed, losing all other plugin configurations for that plugin.

**Why it happens:**
The `config` function is more intuitive for developers familiar with imperative programming. The docs mention both `opts` and `config`, and users gravitate toward the more explicit `config` function without understanding the merging implications.

**Consequences:**
- All default LazyVim plugin options for that plugin are lost
- Extra plugin specifications that also configure the same plugin are ignored
- Plugin breaks because required options from LazyVim defaults are missing
- User must manually recreate all default configuration, creating maintenance burden

**Prevention:**
Always use `opts` for plugin configuration unless you have a specific reason to use `config`. LazyVim automatically merges `opts` tables from multiple specs for the same plugin. Use `opts` as a function only when you need to modify the merged options: `opts = function(_, opts) ... end`.

Only use `config` when:
- The plugin doesn't have a `.setup()` function
- You need to call multiple setup functions
- You need complex initialization logic that can't be expressed in opts

For vimscript plugins that need `vim.g.*` variables set before loading, use `init = function() ... end` instead of `config`.

**Warning signs:**
- Plugin breaks after adding your custom configuration
- Features that worked in default LazyVim stop working
- `:checkhealth` shows errors for the plugin
- Plugin documentation mentions options that aren't being applied

**Phase to address:**
Phase 2 (Keybinding Migration) and Phase 3 (Plugin Override Patterns) - Consistently use `opts` throughout configuration

**Sources:**
- [LazyVim Plugin Configuration Documentation](https://www.lazyvim.org/configuration/plugins)
- [Different Ways to Configure Plugins Discussion](https://neovim.discourse.group/t/different-ways-to-configure-plugins-through-lazy-vim-what-do-they-mean-and-which-one-do-i-use/4199)
- [Using opts and config Together Discussion](https://github.com/folke/lazy.nvim/discussions/1652)
- [LazyVim Chapter 19: Plugin Configuration Guide](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-19/)

---

### Pitfall 4: Not Installing tree-sitter CLI Before First Launch

**What goes wrong:**
User launches LazyVim for the first time without `tree-sitter` CLI installed on their system. LazyVim v15+ requires tree-sitter-cli >=0.25.0 for syntax highlighting. Parser compilation fails silently or with cryptic errors. Syntax highlighting doesn't work, and `:checkhealth nvim-treesitter` shows errors.

**Why it happens:**
LazyVim v15 (September 2025) changed from using pre-compiled parsers to requiring the CLI tool for on-demand compilation. Documentation mentions this but users often skip the prerequisites section. Mason can auto-install tree-sitter-cli, but this doesn't work reliably on all platforms and requires `gzip` to be available.

**Consequences:**
- No syntax highlighting for any language
- Treesitter-based features (text objects, incremental selection, etc.) don't work
- Cryptic error messages on startup
- Parser installation commands fail with "build command not found"
- User thinks LazyVim is broken and spends hours debugging

**Prevention:**
Install `tree-sitter-cli` before launching LazyVim for the first time:

**macOS:** `brew install tree-sitter`
**Linux:** `cargo install tree-sitter-cli` or use your package manager
**Windows:** `cargo install tree-sitter-cli` (requires Rust toolchain)

Verify installation: `tree-sitter --version` should show >= 0.25.0

For dotfiles automation: Add tree-sitter-cli installation to your post-hook script that runs after rcm symlinks config files.

**Warning signs:**
- `:checkhealth nvim-treesitter` shows "tree-sitter CLI not found"
- No syntax highlighting in any file
- Error messages mentioning "Parser not available" or "build command failed"
- `:TSInstall <language>` fails

**Phase to address:**
Phase 4 (Post-hook Installation) - Add tree-sitter-cli installation to post-hook script alongside Neovim installation

**Sources:**
- [LazyVim Treesitter Documentation](https://www.lazyvim.org/plugins/treesitter)
- [LazyVim v15 Migration Issue](https://github.com/LazyVim/LazyVim/issues/6421)
- [How Should I Install tree-sitter Discussion](https://github.com/LazyVim/LazyVim/discussions/6451)
- [Tree-sitter Installation Help Discussion](https://github.com/LazyVim/LazyVim/discussions/6503)

---

### Pitfall 5: Importing LazyVim Extras After User Plugin Specs

**What goes wrong:**
User imports LazyVim extras (like `lazyvim.plugins.extras.lang.go`) after their own plugin specifications in their plugin files. LazyVim issues warnings about incorrect import order. Plugin configurations may not merge properly, and extras may not override user specs as expected.

**Why it happens:**
The loading order matters for spec merging. LazyVim extras should be imported before user plugins so that user configurations can override extras. Users organize files alphabetically or by personal preference without understanding the dependency chain.

**Consequences:**
- Warning messages on startup about incorrect import order
- Extras don't properly override base LazyVim configuration
- User plugin specs may not override extras as expected
- Unpredictable behavior when the same plugin is configured in multiple places

**Prevention:**
Always import LazyVim extras in `lua/config/lazy.lua` or in plugin files that load first. Import order should be:

1. Core LazyVim: `"LazyVim/LazyVim"`
2. LazyVim extras: `"lazyvim.plugins.extras.lang.go"`
3. Third-party plugins: `"ray-x/go.nvim"`
4. Custom plugin specs

If organizing plugins in separate files, use file naming to ensure extras load first (e.g., `01-extras.lua`, `02-custom-plugins.lua`), or put all extras in `lazy.lua`.

**Warning signs:**
- Warning messages mentioning "import order" on startup
- Plugin configurations don't merge as expected
- Extras seem to be ignored or only partially applied

**Phase to address:**
Phase 3 (Plugin Override Patterns) - Document correct import order and structure plugin files accordingly

**Sources:**
- [LazyVim Import Order Warning Issue](https://github.com/LazyVim/LazyVim/issues/5854)
- [LazyVim Configuration Documentation](https://www.lazyvim.org/configuration)
- [lazy.nvim Structuring Plugins Documentation](https://lazy.folke.io/usage/structuring)

---

### Pitfall 6: which-key v3 Configuration Syntax Changes

**What goes wrong:**
User migrates old which-key v2 configuration syntax to LazyVim (which uses which-key v3). Mappings don't appear in the popup, `:checkhealth which-key` shows warnings, or the configuration errors on startup. The old `register()` method and options structure no longer work.

**Why it happens:**
which-key v3 (mid-2024) introduced breaking changes to the configuration API. Old tutorials, blog posts, and personal configs use v2 syntax. LazyVim adopted v3 in 2025-2026. Users copy old examples without realizing the API changed.

**Consequences:**
- Custom keybinding descriptions don't show in which-key popup
- `:checkhealth which-key` shows deprecation warnings or errors
- Configuration file errors on startup
- which-key popup shows incomplete or incorrect information

**Prevention:**
Use the new which-key v3 API:

**Old (v2):**
```lua
local wk = require("which-key")
wk.register({
  ["<leader>f"] = { name = "+file" },
  ["<leader>ff"] = { "<cmd>Telescope find_files<cr>", "Find File" }
})
```

**New (v3):**
```lua
{
  "folke/which-key.nvim",
  opts = {
    spec = {
      { "<leader>f", group = "file" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
    },
  },
}
```

Or use the `add()` method after lazy loading:
```lua
require("which-key").add({
  { "<leader>f", group = "file" },
  { "<leader>ff", desc = "Find File" },
})
```

**Warning signs:**
- `:checkhealth which-key` shows warnings about deprecated options
- Custom descriptions don't appear in popup
- Error messages mentioning "register" method
- which-key popup shows raw keybindings without descriptions

**Phase to address:**
Phase 2 (Keybinding Migration) - Use v3 API when adding which-key descriptions for custom keybindings

**Sources:**
- [which-key.nvim GitHub Repository](https://github.com/folke/which-key.nvim)
- [which-key Warnings Discussion](https://github.com/LazyVim/LazyVim/discussions/4008)
- [Overriding which-key Defaults Discussion](https://github.com/LazyVim/LazyVim/discussions/3598)
- [which-key v3 Help Discussion](https://github.com/LazyVim/LazyVim/discussions/4014)

---

## Moderate Pitfalls

### Pitfall 7: Conflicting Leader Key Bindings with LazyVim Defaults

**What goes wrong:**
User migrates custom keybindings that conflict with LazyVim defaults. Common conflicts for this migration:
- `<leader>j` (buffers) conflicts with LazyVim's jump/LSP actions
- `<leader>t` (tags/symbols) conflicts with LazyVim's test/terminal actions
- `<leader>gr` (grep) conflicts with LazyVim's git revert action
- `<leader>go*` (Go commands) conflict with LazyVim's Go-to actions
- `<leader>\` (file tree) is an unusual mapping that may cause which-key delays

**Why it happens:**
Users have muscle memory for specific key combinations from their old config. LazyVim uses space as leader and has extensive default keybindings. Users assume their custom mappings will "just work" without checking defaults.

**Prevention:**
Before migrating each keybinding:

1. Check if LazyVim has a default for that key: Review [`lua/lazyvim/config/keymaps.lua`](https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua)
2. Decide: Keep LazyVim default, override with custom, or remap custom to different key
3. If overriding: Disable LazyVim default first (see Pitfall 2)
4. If remapping: Choose key that doesn't conflict and update muscle memory

For this migration specifically:
- `<leader>j` → Consider using `<leader>bb` (LazyVim's buffer switcher) or remap to `<leader>b` if not using buffer actions
- `<leader>t` → Could remap to `<leader>s` (symbols) or accept LazyVim's Vista equivalent behavior
- `<leader>gr` → Could remap to `<leader>sg` (search grep) or use LazyVim's `<leader>/` or `<leader>sg`
- `<leader>go*` → These should work fine as LazyVim doesn't heavily use `<leader>go` prefix
- `<leader>\` → Consider standard `<leader>e` or `<leader>ee` for file tree instead

**Warning signs:**
- Custom keybindings don't work as expected
- Unexpected actions happen when pressing familiar keys
- which-key popup shows different action than expected
- Delays when pressing leader combinations

**Phase to address:**
Phase 2 (Keybinding Migration) - Systematically review and resolve conflicts between custom and default keybindings

**Sources:**
- [LazyVim Default Keymaps](https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua)
- [Changing Default Keybindings Discussion](https://github.com/LazyVim/LazyVim/discussions/1094)

---

### Pitfall 8: Using `vim.g` Variables in `config` Instead of `init`

**What goes wrong:**
User migrates vimscript plugin configuration that relied on global variables (`let g:plugin_option = value`). They convert to Lua using `vim.g.plugin_option = value` in the plugin's `config` function. The plugin doesn't respect the setting because the variable was set after the plugin loaded.

**Why it happens:**
Many vimscript plugins require global variables to be set before the plugin loads. The `config` function runs after plugin loading. Users translate vimscript to Lua mechanically without understanding the timing difference.

**Consequences:**
- Plugin ignores configuration
- Plugin uses default behavior instead of custom settings
- No error messages (silent failure)
- User thinks the plugin is broken or Lua conversion didn't work

**Prevention:**
For vimscript plugins that use `vim.g.*` variables, use the `init` function instead of `config`:

```lua
{
  "scrooloose/nerdtree",
  init = function()
    vim.g.NERDTreeShowHidden = 1
    vim.g.NERDTreeMinimalUI = 1
  end,
}
```

The `init` function runs during startup before the plugin loads, ensuring variables are set in time.

For plugins with a `.setup()` function (typical modern Lua plugins), use `opts` or `config` as normal.

**Warning signs:**
- Vimscript plugin uses default behavior despite Lua configuration
- Settings that worked in vimscript don't work in Lua
- No error messages but plugin behaves differently than expected

**Phase to address:**
Phase 3 (Plugin Override Patterns) - Identify vimscript plugins and use `init` for global variable configuration

**Sources:**
- [LazyVim Plugin Configuration Documentation](https://www.lazyvim.org/configuration/plugins)
- [lazy.nvim Plugin Spec Documentation](https://lazy.folke.io/spec)
- [vim-table-mode Configuration Discussion](https://github.com/LazyVim/LazyVim/discussions/1093)

---

### Pitfall 9: Attempting Partial Migration (Both vim-plug and lazy.nvim)

**What goes wrong:**
User tries to maintain their old vim-plug/minpac setup alongside lazy.nvim to migrate gradually. Both plugin managers fight over package paths, autocommands, and runtime files. Plugins load twice or not at all. Startup time is worse than either system alone.

**Why it happens:**
Full migration seems risky and time-consuming. Users want a safety net. Tutorials for other editors suggest gradual migration. Users don't realize Neovim plugin managers aren't designed for coexistence.

**Consequences:**
- Plugins loaded by both managers, wasting memory and startup time
- Conflicts between duplicate plugins
- Unpredictable behavior (which plugin manager's version wins?)
- Startup errors from competing autocommands
- Impossible to debug which configuration is active

**Prevention:**
**DO NOT** attempt to run both plugin managers simultaneously.

For gradual migration, use `$NVIM_APPNAME` to maintain separate configurations:

```bash
# Old config (existing setup)
NVIM_APPNAME=nvim-old nvim

# New config (LazyVim)
NVIM_APPNAME=nvim nvim  # or NVIM_APPNAME=nvim-lazyvim
```

This creates isolated configurations in different directories:
- `~/.config/nvim-old/` (your current setup)
- `~/.config/nvim/` (new LazyVim setup)

Your dotfiles rcm setup will symlink to the new location, and you can switch between configs by setting `NVIM_APPNAME` as needed.

**When to migrate:**
Based on migration strategy in PROJECT.md, this is a **single migration** (complete replacement), not gradual. The `$NVIM_APPNAME` approach is for testing and verification, not long-term parallel operation.

**Warning signs:**
- Startup errors mentioning plugin conflicts
- Plugins appear in both `:PackStatus` and `:Lazy`
- Extremely slow startup
- Unpredictable plugin behavior

**Phase to address:**
Phase 1 (Configuration Structure) - Use separate NVIM_APPNAME for testing, then fully replace old config

**Sources:**
- [Using Both vim-plug and lazy.nvim Discussion](https://github.com/LazyVim/LazyVim/discussions/4282)
- [Migration Blog Post by Nick Janetakis](https://nickjanetakis.com/blog/why-i-switched-from-vim-to-neovim-lazyvim-and-how-i-did-it)

---

### Pitfall 10: Lazy Loading with Wrong Events Causing Missing Plugin Functionality

**What goes wrong:**
User marks a plugin as lazy-loaded with an event like `event = "VeryLazy"` or `event = "BufRead"`, but the plugin depends on earlier events (like `VimEnter` or `UIEnter`) and doesn't initialize properly. Features silently fail or work inconsistently.

**Why it happens:**
LazyVim promotes lazy loading for performance. Users aggressively lazy load plugins without understanding event ordering. When a plugin is lazy loaded, it misses events that fired before it loaded. The plugin may depend on state from those earlier events.

**Consequences:**
- Plugin features don't work on first buffer
- Features work after opening a second file but not the first
- Autocommands don't fire as expected
- Unpredictable behavior depending on file opening order

**Prevention:**
Understand event ordering in Neovim:
1. `VimEnter` - After Neovim finishes starting
2. `UIEnter` - After UI is ready
3. `BufReadPre` / `BufReadPost` - When reading a buffer
4. `FileType` - After filetype is detected
5. `VeryLazy` - Custom LazyVim event, fires after everything else

For most plugins, let LazyVim handle lazy loading automatically. Only specify `event` if:
- Plugin documentation recommends specific events
- Plugin is slow and truly needs deferred loading
- You've verified the plugin works correctly with that event

If a plugin doesn't work after lazy loading:
1. Try `event = "VeryLazy"` (latest safe event)
2. Try removing `lazy = true` entirely
3. Check plugin documentation for recommended events

**Warning signs:**
- Plugin works inconsistently (sometimes yes, sometimes no)
- Features work in second buffer but not first
- Error messages about plugin not being loaded
- `:Lazy` shows plugin wasn't loaded when expected

**Phase to address:**
Phase 3 (Plugin Override Patterns) - Let LazyVim handle lazy loading by default, only customize when necessary

**Sources:**
- [Lazy Loading and Performance Guide](https://deepwiki.com/LazyVim/starter/3.2-lazy-loading-and-performance)
- [Autocmd Events Not Fired Issue](https://github.com/folke/lazy.nvim/issues/1049)
- [Plugins Not Always Loading with Autocmd Events Issue](https://github.com/folke/lazy.nvim/issues/858)

---

## Minor Pitfalls

### Pitfall 11: Not Using `opts_extend` for List-Like Tables

**What goes wrong:**
User wants to extend a plugin's list-like option (like `filetypes`, `ensure_installed`, or `sources`) but uses regular `opts`. LazyVim replaces the entire list with the user's list instead of merging them, losing the default values.

**Why it happens:**
lazy.nvim only auto-merges dictionary-like tables. List-like tables (arrays) get replaced entirely. Users expect all `opts` to merge regardless of table structure.

**Consequences:**
- Default plugin configuration lost for that option
- Plugin breaks because required defaults are missing
- User must manually recreate all defaults
- Difficult to debug because no error messages

**Prevention:**
For list-like options that should be extended, not replaced, use `opts_extend`:

```lua
{
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = { "go", "ruby" },
  },
  opts_extend = { "ensure_installed" },
}
```

This tells lazy.nvim to merge `ensure_installed` arrays from multiple specs instead of replacing.

**Warning signs:**
- Plugin loses default language support or features
- Adding one language to a list removes others
- Plugin behaves differently than default LazyVim

**Phase to address:**
Phase 3 (Plugin Override Patterns) - Use `opts_extend` for array-like options like language lists

**Sources:**
- [LazyVim Plugin Configuration Documentation](https://www.lazyvim.org/configuration/plugins)
- [opts Merging Discussion](https://github.com/LazyVim/LazyVim/discussions/2534)
- [Plugin Spec Merging Discussion](https://github.com/folke/lazy.nvim/discussions/1706)

---

### Pitfall 12: Forgetting to Run `:checkhealth` After Configuration Changes

**What goes wrong:**
User makes configuration changes, especially plugin overrides or LSP setup, without running `:checkhealth`. Subtle issues accumulate (missing dependencies, configuration errors, deprecated options) but don't cause obvious failures. Editor works but suboptimally.

**Why it happens:**
`:checkhealth` isn't part of typical Neovim workflow. Users test functionality manually ("does this plugin work?") without systematic validation. Coming from other editors, comprehensive health checks aren't expected.

**Consequences:**
- Slow performance due to misconfigured plugins
- Missing features due to missing dependencies
- Silent failures in background processes
- Accumulation of technical debt

**Prevention:**
Run `:checkhealth` after:
- Installing LazyVim for the first time
- Adding or modifying plugin configurations
- Installing new LSP servers or tools
- Changing major options (leader key, clipboard, etc.)
- Any unexplained behavior or performance issues

Pay special attention to:
- `:checkhealth lazy` - Plugin manager issues
- `:checkhealth which-key` - Keymap conflicts
- `:checkhealth nvim-treesitter` - Syntax highlighting
- `:checkhealth vim.lsp` - LSP configuration

**Warning signs:**
- Unexplained slowness
- Features not working as documented
- Warnings in `:messages`
- Plugins behaving inconsistently

**Phase to address:**
All phases - Make `:checkhealth` part of standard verification process after configuration changes

---

### Pitfall 13: Ignoring LazyVim's Extra Plugins for Language Support

**What goes wrong:**
User manually configures language-specific plugins (LSP servers, treesitter parsers, linters, formatters) without checking if LazyVim has an "extra" for that language. They recreate configuration that LazyVim already provides, often incompletely or incorrectly.

**Why it happens:**
Users come from manual Neovim configs where everything is explicit. LazyVim extras aren't discoverable without reading documentation. Plugin documentation doesn't mention LazyVim extras.

**Consequences:**
- Duplicate configuration
- Missing pieces of language support (LazyVim extras are comprehensive)
- Maintenance burden (manual config vs. maintained extras)
- Conflicts between manual config and extras if both are loaded

**Prevention:**
Before manually configuring language support, check if LazyVim has an extra:

1. Browse available extras: [http://www.lazyvim.org/extras](http://www.lazyvim.org/extras)
2. Common languages with extras: Go, Python, TypeScript, Rust, Ruby, etc.
3. Import extra in `lua/config/lazy.lua`: `{ import = "lazyvim.plugins.extras.lang.go" }`

If the extra is close but not perfect:
- Import the extra
- Override specific pieces with your own plugin specs
- Use `opts` to customize behavior

**Warning signs:**
- Spending time configuring language support manually
- Incomplete LSP setup (missing auto-import, debugging, etc.)
- Discovering LazyVim extras exist after manual configuration

**Phase to address:**
Phase 3 (Plugin Override Patterns) - Identify needed LazyVim extras before manual plugin configuration

**Sources:**
- [LazyVim Extras Documentation](http://www.lazyvim.org/extras)
- [LazyVim Configuration Guide](http://www.lazyvim.org/configuration)

---

## Technical Debt Patterns

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|----------|-------------------|----------------|-----------------|
| Wrapping vimscript in `vim.cmd()` instead of converting to Lua | Quick migration, no learning curve | Harder to debug, maintain; misses Lua plugin ecosystem benefits | Temporary during migration phase only |
| Using `config` function for everything instead of `opts` | More explicit control | Loses LazyVim's automatic merging; maintenance burden when updating LazyVim | Never for plugins with `.setup()` |
| Disabling all LazyVim keymaps and starting from scratch | Complete control over keybindings | Loses LazyVim integration; huge maintenance burden; defeats purpose of LazyVim | Never - defeats framework purpose |
| Not adding which-key descriptions to custom keybindings | Faster initial setup | Loses discoverability; defeats migration goal of "which-key integration" | Never - which-key integration is explicit project goal |
| Skipping `:checkhealth` verification | Saves time during config changes | Silent failures accumulate; hard to debug later | Never - always run after changes |
| Installing extra plugins instead of using LazyVim extras | Immediate functionality | Maintenance burden; missing integrations; potential conflicts | When extra doesn't exist or is fundamentally incompatible with needs |

---

## Integration Gotchas

| Integration | Common Mistake | Correct Approach |
|-------------|----------------|------------------|
| rcm dotfiles | Symlinking entire `.config/nvim/` with existing plugins | Clean slate: Remove old init.vim and plugins/, start fresh LazyVim structure, let rcm symlink new files |
| Fish shell | Not setting up aliases for separate NVIM_APPNAME configs | Add `alias nvim-old='NVIM_APPNAME=nvim-old nvim'` for testing old config during migration |
| Git hooks (post-up) | Not automating tree-sitter-cli installation | Add `brew install tree-sitter` or `cargo install tree-sitter-cli` to post-up script |
| Telescope | Remapping `<leader>p` without checking Telescope is already bound | LazyVim already has `<leader>ff` for files, `<leader><space>` for files, etc. - reuse or remap carefully |
| Go LSP/tools | Manually installing gopls, goimports, etc. | Import `lazyvim.plugins.extras.lang.go` which sets up everything automatically |
| Window navigation | Custom `<C-hjkl>` window navigation conflicts with plugin navigators | LazyVim defaults already include `<C-hjkl>` navigation - verify compatibility |

---

## Performance Traps

| Trap | Symptoms | Prevention | When It Breaks |
|------|----------|------------|----------------|
| Not lazy loading large plugins | Slow startup (>500ms) | Let LazyVim handle lazy loading by default; only disable for plugins that truly need immediate loading | Immediately noticeable on startup |
| Installing too many treesitter parsers with `ensure_installed = "all"` | Slow first startup, high memory usage | Only install parsers for languages actively used: `ensure_installed = { "lua", "go", "ruby" }` | First launch after clean install |
| Overusing `VeryLazy` event | Noticeable delay when triggering lazy-loaded plugin first time | Use more specific events (`FileType`, `BufRead`) or let LazyVim handle it | When first using a feature |
| Syncing plugins on every startup | 5-10 second startup delay | Remove `checker = { enabled = true, notify = false }` or set reasonable check frequency | Every single startup |
| Loading colorscheme through lazy loading | Flash of unstyled content, then colorscheme loads | Colorscheme plugin should set `lazy = false, priority = 1000` | Every startup |

---

## Migration-Specific Warnings

| Old Config Pattern | Migration Pitfall | Mitigation |
|-------------------|------------------|------------|
| `let mapleader=" "` early in init.vim | Leader already set by LazyVim, custom setting may be too late | Remove manual leader setting, LazyVim sets space as leader by default |
| `source ~/.config/nvim/plugins/fzf.vim` | File doesn't exist in new structure, config errors on startup | Delete all `source` statements, use LazyVim plugin specs instead |
| `<leader>j :Buffers<cr>` (fzf) | fzf not included, command doesn't exist | Map to LazyVim's Telescope buffer switcher: `<cmd>Telescope buffers<cr>` |
| `<leader>\ :NERDTreeToggle<cr>` | NERDTree not included | Map to LazyVim's neo-tree: `<cmd>Neotree toggle<cr>` or use default `<leader>e` |
| `<leader>t :Vista!!<cr>` | Vista not included | Map to LazyVim's aerial or symbols-outline, or use default `<leader>cs` (code symbols) |
| Global variables in init.vim: `let g:go_fmt_command = "goimports"` | No longer work without plugin that reads them | Use LazyVim's Go extra or configure gopls LSP settings instead |
| `autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()` | vim-lsp not included, LanguageClient not available | LazyVim handles formatting automatically via conform.nvim, configure in `opts` |
| `call minpac#add('fatih/vim-go')` | minpac doesn't exist, vim-go not needed | Use LazyVim's Go extra which configures native LSP with gopls |

---

## "Looks Done But Isn't" Checklist

Configuration appears complete but critical pieces are missing:

- [ ] **Custom keybindings:** Often missing which-key descriptions - verify with `<leader>` popup shows labels
- [ ] **Plugin overrides:** Often missing `opts_extend` for list options - verify `:Lazy` shows merged config
- [ ] **LSP servers:** Often not actually installed - verify `:Mason` shows installed servers
- [ ] **Treesitter parsers:** Often missing for key languages - verify `:TSInstall` shows installed parsers
- [ ] **Format on save:** Often misconfigured or missing - verify `:w` actually formats files
- [ ] **Linting:** Often not configured or missing linters - verify `:checkhealth` shows no linting errors
- [ ] **Conflicting keymaps:** Often undiscovered - verify `:checkhealth which-key` shows no conflicts
- [ ] **Window navigation:** Custom `<C-hjkl>` may silently fail with plugins - verify movement works in all contexts
- [ ] **tree-sitter-cli:** Often missing on system - verify `:checkhealth nvim-treesitter` shows CLI found
- [ ] **Post-hook automation:** Often forgotten until clean install - verify fresh checkout + rcm installs everything

---

## Recovery Strategies

When pitfalls occur despite prevention:

| Pitfall | Recovery Cost | Recovery Steps |
|---------|---------------|----------------|
| Manually required config files (Pitfall 1) | LOW | Remove `require()` statements, restart Neovim |
| Conflicting keymaps (Pitfall 2) | LOW | Add `vim.keymap.del()` before custom keymap, or set `{ key, false }` in plugin spec |
| Used `config` instead of `opts` (Pitfall 3) | MEDIUM | Refactor to `opts = { ... }` or `opts = function(_, opts) ... end` |
| Missing tree-sitter-cli (Pitfall 4) | LOW | Install CLI (`brew install tree-sitter`), run `:TSInstall <lang>` |
| Wrong import order (Pitfall 5) | LOW | Move LazyVim extras imports before custom plugins in lazy.lua |
| Old which-key syntax (Pitfall 6) | MEDIUM | Refactor to v3 API: `opts = { spec = { ... } }` |
| Both plugin managers (Pitfall 9) | HIGH | Remove old plugin manager completely, use `NVIM_APPNAME` for separate configs |
| Wrong lazy loading events (Pitfall 10) | LOW | Change to `VeryLazy` or remove `lazy = true` entirely |
| List overwritten by opts (Pitfall 11) | LOW | Add `opts_extend = { "option_name" }` to plugin spec |
| Manual lang config instead of extras (Pitfall 13) | MEDIUM | Remove manual config, import LazyVim extra, customize via `opts` |

---

## Pitfall-to-Phase Mapping

How roadmap phases should address these pitfalls:

| Pitfall | Prevention Phase | Verification |
|---------|------------------|--------------|
| Manual require of auto-loaded files (1) | Phase 1: Configuration Structure | `:messages` shows no duplicate loading, `:Lazy` shows plugins load once |
| Conflicting keymaps not disabled (2) | Phase 2: Keybinding Migration | `:checkhealth which-key` shows no conflicts, no keymap delays |
| Using config instead of opts (3) | Phase 2, 3: Keybinding + Plugin Overrides | `:Lazy` shows merged configs for multi-spec plugins |
| Missing tree-sitter-cli (4) | Phase 4: Post-hook Installation | `:checkhealth nvim-treesitter` shows CLI found, `:TSInstall` works |
| Wrong import order (5) | Phase 3: Plugin Override Patterns | No warnings on startup about import order |
| which-key v2 syntax (6) | Phase 2: Keybinding Migration | which-key popup shows custom descriptions, no deprecation warnings |
| Conflicting leader keys (7) | Phase 2: Keybinding Migration | All custom keybindings work without delays, which-key shows correct actions |
| vim.g in config not init (8) | Phase 3: Plugin Override Patterns | Vimscript plugins respect configuration |
| Both plugin managers (9) | Phase 1: Configuration Structure | Only lazy.nvim present, clean startup |
| Wrong lazy loading events (10) | Phase 3: Plugin Override Patterns | All plugins load correctly on first use |
| List replacement not extension (11) | Phase 3: Plugin Override Patterns | Default language support preserved while adding custom ones |
| Not running checkhealth (12) | All phases | All `:checkhealth` sections pass (lazy, which-key, treesitter, lsp) |
| Ignoring LazyVim extras (13) | Phase 3: Plugin Override Patterns | Language support complete without manual LSP configuration |

---

## Sources

### Official Documentation
- [LazyVim Configuration Guide](https://www.lazyvim.org/configuration)
- [LazyVim General Settings](https://www.lazyvim.org/configuration/general)
- [LazyVim Keymaps Documentation](https://www.lazyvim.org/configuration/keymaps)
- [LazyVim Plugin Configuration](https://www.lazyvim.org/configuration/plugins)
- [LazyVim Treesitter Documentation](https://www.lazyvim.org/plugins/treesitter)
- [LazyVim Extras](https://www.lazyvim.org/extras)
- [LazyVim Default Keymaps Source](https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua)
- [lazy.nvim Plugin Spec](https://lazy.folke.io/spec)
- [lazy.nvim Structuring Plugins](https://lazy.folke.io/usage/structuring)
- [which-key.nvim GitHub](https://github.com/folke/which-key.nvim)
- [which-key.nvim Changelog](https://github.com/folke/which-key.nvim/blob/main/CHANGELOG.md)

### Community Resources & Discussions

**Configuration Structure:**
- [LazyVim Configuration Help Issue #72](https://github.com/LazyVim/LazyVim/issues/72)
- [Vim Options in Lua Discussion #2742](https://github.com/LazyVim/LazyVim/discussions/2742)

**Keybinding Conflicts:**
- [Conflicting Keymaps Discussion #3863](https://github.com/LazyVim/LazyVim/discussions/3863)
- [Removing Default Keybindings Discussion #1186](https://github.com/LazyVim/LazyVim/discussions/1186)
- [Custom Keymap Override Discussion #6557](https://github.com/LazyVim/LazyVim/discussions/6557)
- [Changing Default Keybindings Discussion #1094](https://github.com/LazyVim/LazyVim/discussions/1094)
- [Replace Default Leader-w Mappings Discussion #4085](https://github.com/LazyVim/LazyVim/discussions/4085)
- [Custom Leader-w Mapping Discussion #4062](https://github.com/LazyVim/LazyVim/discussions/4062)
- [Disable All LazyVim Keymaps Feature Request #238](https://github.com/LazyVim/LazyVim/issues/238)

**which-key Issues:**
- [which-key Warnings Discussion #4008](https://github.com/LazyVim/LazyVim/discussions/4008)
- [which-key Extra Window Keymaps Discussion #4129](https://github.com/LazyVim/LazyVim/discussions/4129)
- [which-key Opts Override Help Discussion #4014](https://github.com/LazyVim/LazyVim/discussions/4014)
- [Override which-key Defaults Discussion #3598](https://github.com/LazyVim/LazyVim/discussions/3598)
- [Cannot Override Plugin Keymaps Bug #1485](https://github.com/LazyVim/LazyVim/issues/1485)

**Plugin Configuration:**
- [Different Ways to Configure Plugins Discussion (Neovim Discourse)](https://neovim.discourse.group/t/different-ways-to-configure-plugins-through-lazy-vim-what-do-they-mean-and-which-one-do-i-use/4199)
- [Using opts and config Together Discussion #1652](https://github.com/folke/lazy.nvim/discussions/1652)
- [Plugin Spec Merging Discussion #1706](https://github.com/folke/lazy.nvim/discussions/1706)
- [Override Extra Plugins Configuration Discussion #2534](https://github.com/LazyVim/LazyVim/discussions/2534)
- [Override Improvements Discussion #22](https://github.com/LazyVim/LazyVim/discussions/22)
- [Trouble Modifying Default Plugin Config Discussion #6501](https://github.com/LazyVim/LazyVim/discussions/6501)
- [vim-table-mode Configuration Discussion #1093](https://github.com/LazyVim/LazyVim/discussions/1093)
- [Migrating from Plugin.config to Plugin.opts Discussion #1082](https://github.com/folke/lazy.nvim/discussions/1082)

**Migration Issues:**
- [LazyVim v15 Migration Issue #6421](https://github.com/LazyVim/LazyVim/issues/6421)
- [Migration to conform and nvim-lint Discussion #1522](https://github.com/LazyVim/LazyVim/discussions/1522)
- [Using Both vim-plug and lazy.nvim Discussion #4282](https://github.com/LazyVim/LazyVim/discussions/4282)
- [Import Order Warning Issue #5854](https://github.com/LazyVim/LazyVim/issues/5854)

**Treesitter:**
- [How Should I Install tree-sitter Discussion #6451](https://github.com/LazyVim/LazyVim/discussions/6451)
- [Help with nvim-treesitter After v15 Update Discussion #6503](https://github.com/LazyVim/LazyVim/discussions/6503)
- [nvim-treesitter Fails to Install Parsers on Windows Issue #8147](https://github.com/nvim-treesitter/nvim-treesitter/issues/8147)
- [Parser Not Available Error Issue #524](https://github.com/LazyVim/LazyVim/issues/524)

**Lazy Loading:**
- [Autocmd Events Not Fired Issue #1049](https://github.com/folke/lazy.nvim/issues/1049)
- [Plugins Not Always Loading with Autocmd Events Issue #858](https://github.com/folke/lazy.nvim/issues/858)

**Guides & Tutorials:**
- [LazyVim for Ambitious Developers - Chapter 19: Plugin Configuration](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-19/)
- [Customizing LazyVim by Andrew Courter](https://levelup.gitconnected.com/customizing-lazyvim-overrides-and-new-keymaps-plugins-528feeb547df)
- [Why I Switched from Vim to LazyVim by Nick Janetakis](https://nickjanetakis.com/blog/why-i-switched-from-vim-to-neovim-lazyvim-and-how-i-did-it)
- [Neovim: Migrating to lazy.nvim and go.nvim by Mario Carrion](https://mariocarrion.com/2024/05/20/neovim-migrating-to-lazy-and-go-nvim.html)
- [Moving My Vim Config to Lua](https://ihaveabackup.net/2023/01/12/moving-my-vim-config-to-lua/)
- [Rewriting My Neovim Config in Lua by Jonas Hietala](https://www.jonashietala.se/blog/2023/10/01/rewriting_my_neovim_config_in_lua/)
- [lazy.nvim Plugin Configuration by VonHeikemen](https://dev.to/vonheikemen/lazynvim-plugin-configuration-3opi)

---

*Pitfalls research for: LazyVim migration from vimscript*
*Researched: 2026-02-03*
