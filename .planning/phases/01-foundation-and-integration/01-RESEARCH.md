# Phase 1: Foundation and Integration - Research

**Researched:** 2026-02-03
**Domain:** Neovim configuration with LazyVim + rcm dotfiles integration
**Confidence:** HIGH

## Summary

LazyVim is a modern Neovim configuration framework built on lazy.nvim plugin manager. It requires Neovim >= 0.11.2 and follows a structured approach with automatic plugin installation and bootstrap. The standard setup uses the LazyVim starter template, which provides a minimal but complete configuration structure with `lua/config/` for core settings and `lua/plugins/` for custom plugins.

Integration with rcm dotfiles manager is straightforward: place config files in `config/nvim/` within the dotfiles repository, and rcm will symlink them to `~/.config/nvim/`. The key architectural decision is keeping LazyVim's data directories (plugins, state, cache) in their default XDG locations rather than tracking them in dotfiles, which aligns with rcm's design philosophy.

The main pitfalls involve understanding the bootstrap process timing, avoiding manual file requires for auto-loaded files, and correctly managing the lazy-lock.json lockfile decision.

**Primary recommendation:** Use LazyVim starter template as base, integrate via rcm symlinking to `~/.config/nvim/`, automate dependency installation through Brewfile + post-up hooks, and let lazy.nvim handle plugin bootstrap automatically on first launch.

## Standard Stack

The established libraries/tools for this domain:

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Neovim | >= 0.11.2 | Editor runtime | Required for LazyVim v15.x LSP improvements |
| LazyVim | v15.x+ | Configuration framework | Official maintained config, modern plugin ecosystem |
| lazy.nvim | stable branch | Plugin manager | Fast, async, declarative plugin management |
| tree-sitter-cli | >= 0.25.0 | Parser generator tool | Required for nvim-treesitter main branch |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| ripgrep | latest | Fast grep tool | Required for Telescope fuzzy finder |
| fd | latest | Fast find alternative | Required for Telescope file finding |
| Git | >= 2.19.0 | Version control | Required for lazy.nvim partial clones |
| C compiler | system | Treesitter parser builds | Required for nvim-treesitter compilation |
| rcm | latest | Dotfiles manager | User's chosen dotfiles management |
| Homebrew | latest | Package manager | macOS dependency installation |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| LazyVim | kickstart.nvim | More minimal but requires more manual configuration |
| LazyVim | AstroNvim | Different plugin ecosystem and keybinding philosophy |
| lazy.nvim | packer.nvim | Packer is older, less active development |
| rcm | GNU Stow | Stow doesn't support hooks, would need separate automation |

**Installation:**
```bash
# Via Homebrew (recommended for macOS)
brew install neovim ripgrep fd tree-sitter

# Verify versions
nvim --version  # Should show >= 0.11.2
tree-sitter --version  # Should show >= 0.25.0
```

## Architecture Patterns

### Recommended Project Structure
```
dotfiles/
├── config/
│   └── nvim/                 # XDG-compliant config location
│       ├── init.lua          # Entry point, loads lazy.nvim
│       ├── lua/
│       │   ├── config/       # Auto-loaded core config
│       │   │   ├── autocmds.lua
│       │   │   ├── keymaps.lua
│       │   │   ├── lazy.lua  # lazy.nvim setup
│       │   │   └── options.lua
│       │   └── plugins/      # Custom plugin specs (auto-discovered)
│       │       └── *.lua     # Each file = plugin spec or group
│       ├── .neoconf.json     # Project-specific Neovim settings
│       ├── stylua.toml       # Lua formatter config
│       └── .gitignore        # Ignore data directories
├── hooks/
│   └── post-up/
│       ├── 00-brew-bundle    # Existing: installs Brewfile deps
│       └── XX-nvim-health    # New: validate LazyVim installation
└── Brewfile                  # Homebrew dependencies
```

**Data directories (NOT in dotfiles):**
- Plugins: `~/.local/share/nvim/` (managed by lazy.nvim)
- State: `~/.local/state/nvim/` (shada files, plugin state)
- Cache: `~/.cache/nvim/` (temporary build artifacts)

### Pattern 1: lazy.nvim Bootstrap
**What:** Automatic installation of lazy.nvim plugin manager on first Neovim launch
**When to use:** Always - this is the standard LazyVim installation pattern
**Example:**
```lua
-- Source: https://lazy.folke.io/installation
-- In init.lua or lua/config/lazy.lua

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "plugins" },
  },
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = true },
})
```

### Pattern 2: rcm Symlink Integration
**What:** rcm creates symlinks from `dotfiles/config/nvim/` to `~/.config/nvim/`
**When to use:** For all XDG-compliant config directories
**Example:**
```bash
# rcm automatically handles subdirectories in config/
# dotfiles/config/nvim/init.lua → ~/.config/nvim/init.lua
# dotfiles/config/nvim/lua/... → ~/.config/nvim/lua/...

# Verify symlinks after rcup
lsrc | grep nvim
# Shows: ~/.config/nvim:dotfiles/config/nvim
```

### Pattern 3: Post-Up Hook Automation
**What:** rcm post-up hooks run after symlinks are created, ideal for validation
**When to use:** To verify dependencies and run health checks
**Example:**
```bash
#!/usr/bin/env bash
# hooks/post-up/XX-nvim-health
set -e

# Wait for lazy.nvim to complete first-launch plugin installation
# Then run health checks to validate installation

if command -v nvim >/dev/null 2>&1; then
  echo "Running Neovim health checks..."
  nvim --headless "+checkhealth lazy" "+checkhealth lazyvim" "+qa" 2>&1 | tee /tmp/nvim-health.log

  # Check for errors (exit code won't catch health check failures)
  if grep -q "ERROR" /tmp/nvim-health.log; then
    echo "❌ Health check failed. Review: /tmp/nvim-health.log"
    exit 1
  fi

  echo "✅ LazyVim health checks passed"
fi
```

### Pattern 4: Brewfile Dependency Management
**What:** Declare all system dependencies in Brewfile, installed by existing post-up hook
**When to use:** For all Homebrew-installable dependencies
**Example:**
```ruby
# Add to existing Brewfile
brew 'neovim'        # Already present
brew 'ripgrep'       # Add if missing
brew 'fd'            # Add if missing
brew 'tree-sitter'   # Add for tree-sitter-cli
```

### Anti-Patterns to Avoid
- **Tracking plugin data directories:** Never add `~/.local/share/nvim/` to dotfiles. Plugins install per-machine and should not be version-controlled.
- **Manually requiring auto-loaded files:** Don't `require("config.keymaps")` in init.lua - LazyVim auto-loads `lua/config/*.lua` files.
- **Removing .git before customization:** Keep `.git` from starter template until you've made initial customizations, then remove and re-init with your own remote.
- **Running :Lazy sync manually:** lazy.nvim automatically installs missing plugins on startup; manual sync is only needed for updates.
- **Symlinking individual nvim subdirectories:** Let rcm symlink the entire `config/nvim/` directory, not individual files within it.

## Don't Hand-Roll

Problems that look simple but have existing solutions:

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Plugin management | Custom git submodule setup | lazy.nvim | Handles lazy loading, dependencies, lockfile, async installation, profiling |
| Health check automation | Custom validation scripts | `:checkhealth` command | Official Neovim health checks for all plugins, LSP, providers |
| Bootstrap installation | Manual git clone + setup | LazyVim starter template | Provides tested bootstrap code, proper error handling, sane defaults |
| Dependency verification | Custom version checking | `:checkhealth` + Brewfile | Homebrew ensures versions, health checks validate functionality |
| Dotfile symlinks | Custom ln -s commands | rcm (rcup) | Handles subdirectories, tags, hosts, hooks, excludes automatically |
| Plugin configuration | Monolithic init.lua | lua/plugins/*.lua files | lazy.nvim auto-discovers, lazy-loads, supports overrides cleanly |
| Tree-sitter parsers | Manual git clone + compile | `:TSInstall` command | Handles compilation, versioning, updates automatically |

**Key insight:** LazyVim + lazy.nvim have solved the "Neovim configuration management" problem with 5+ years of community refinement. The bootstrap, plugin loading, lazy-loading, and health check patterns are battle-tested across thousands of users. Focus integration effort on the dotfiles-specific concerns (rcm hooks, Brewfile), not reinventing plugin management.

## Common Pitfalls

### Pitfall 1: Health Check Timing
**What goes wrong:** Running `:checkhealth` immediately after `rcup` fails because plugins haven't installed yet
**Why it happens:** lazy.nvim bootstrap happens on first Neovim launch, which occurs AFTER rcup completes and AFTER post-up hooks run
**How to avoid:**
- Option A: Run health checks in post-up hook with retry logic or after manual first launch
- Option B: Document that user should run `nvim` once, wait for plugin installation, then run `:checkhealth`
- Option C: Make health check hook non-blocking, just report status without failing
**Warning signs:** Post-up hook reports "lazy.nvim not found" or "plugins not installed"

### Pitfall 2: Neovim Version Mismatch
**What goes wrong:** User has Neovim < 0.11.2 installed, LazyVim v15.x fails to start with cryptic errors
**Why it happens:** Homebrew might have older Neovim version, or user installed from different source
**How to avoid:**
- Add `brew 'neovim'` to Brewfile (ensures Homebrew manages it)
- Add version check to post-up hook before health checks
- Upgrade Neovim: `brew upgrade neovim` or `brew install neovim --HEAD` for latest
**Warning signs:** Errors mentioning LSP, vim.lsp functions, or "function not found"

### Pitfall 3: lazy-lock.json Decision Confusion
**What goes wrong:** User unsure whether to track lazy-lock.json, causing inconsistent plugin versions across machines or too many commits
**Why it happens:** lazy-lock.json pins plugin versions (good for reproducibility) but updates frequently (noisy git history)
**How to avoid:**
- User decision: Add to `.gitignore` if they prefer latest versions (simpler, recommended for personal dotfiles)
- Track it if reproducibility across machines is critical (better for team configs)
- Document decision in README
**Warning signs:** 100+ commits just updating lockfile, or "plugins different on work machine"

### Pitfall 4: Missing Tree-Sitter CLI
**What goes wrong:** LazyVim installs but tree-sitter parsers fail to compile with "tree-sitter: command not found"
**Why it happens:** LazyVim uses nvim-treesitter main branch which requires tree-sitter-cli system tool (not just the Neovim tree-sitter module)
**How to avoid:**
- Add `brew 'tree-sitter'` to Brewfile (installs tree-sitter-cli)
- Verify in health check: `:checkhealth nvim-treesitter` will show if CLI missing
- Minimum version: 0.25.0 required
**Warning signs:** Tree-sitter health check shows "tree-sitter CLI not found" or parser compilation errors

### Pitfall 5: rcm Hook Execution Environment
**What goes wrong:** Post-up hook can't find `nvim` command or runs in wrong directory
**Why it happens:** rcm hooks run with minimal environment, PATH might not include Homebrew bin
**How to avoid:**
- Use absolute paths or `command -v nvim` to check existence
- Source `/opt/homebrew/bin` or `/usr/local/bin` explicitly if needed
- Make hooks idempotent - safe to run multiple times
**Warning signs:** "nvim: command not found" in post-up hook output, despite Neovim being installed

### Pitfall 6: Starter Template Example Cleanup
**What goes wrong:** User keeps all example plugin specs from starter template, gets plugins they don't want
**Why it happens:** LazyVim starter includes example customizations in `lua/plugins/example.lua`
**How to avoid:**
- Review `lua/plugins/*.lua` files from starter template
- Keep useful examples as reference
- Remove or disable example plugins not needed (just delete the file or return `{}`)
- Starter's `plugins/example.lua` is safe to delete entirely
**Warning signs:** Unexpected plugins loading, colorscheme changes user didn't configure

### Pitfall 7: Old Config Interference
**What goes wrong:** Old Vimscript config (init.vim) gets loaded alongside new Lua config, causing conflicts
**Why it happens:** Neovim loads both init.vim and init.lua if both exist, or old symlinks persist
**How to avoid:**
- Remove `config/nvim/init.vim` and `config/nvim/plugins/` completely (user wants clean break)
- Verify `~/.config/nvim/` symlink points to new location after rcup
- Check for stale Neovim data: `rm -rf ~/.local/share/nvim.old` if needed
**Warning signs:** Error messages about Vimscript syntax, old plugins loading, duplicate keybindings

## Code Examples

Verified patterns from official sources:

### Minimal init.lua for LazyVim
```lua
-- Source: https://github.com/LazyVim/starter
-- ~/.config/nvim/init.lua

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Import LazyVim and its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Import/override with your plugins from lua/plugins
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true },
  performance = {
    rtp = {
      -- Disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Load config files (auto-loaded by LazyVim)
-- No need to require them manually
```

### Custom Plugin Spec Example
```lua
-- Source: https://www.lazyvim.org/configuration
-- ~/.config/nvim/lua/plugins/colorscheme.lua

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      transparent_background = true,
    },
  },
}
```

### rcm Post-Up Hook for Neovim Validation
```bash
#!/usr/bin/env bash
# Source: rcm documentation + neovim health docs
# hooks/post-up/XX-nvim-health
set -e

echo "==> Validating Neovim installation..."

# Check Neovim is available
if ! command -v nvim >/dev/null 2>&1; then
  echo "❌ Neovim not found in PATH"
  exit 1
fi

# Check version
NVIM_VERSION=$(nvim --version | head -n1 | awk '{print $2}' | sed 's/v//')
REQUIRED_VERSION="0.11.2"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$NVIM_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
  echo "❌ Neovim $NVIM_VERSION is too old. Need >= $REQUIRED_VERSION"
  echo "   Run: brew upgrade neovim"
  exit 1
fi

echo "✅ Neovim $NVIM_VERSION installed"

# Check dependencies
for cmd in rg fd tree-sitter; do
  if command -v $cmd >/dev/null 2>&1; then
    echo "✅ $cmd installed"
  else
    echo "⚠️  $cmd not found (optional but recommended)"
  fi
done

echo "==> Run 'nvim' to bootstrap plugins on first launch"
echo "    Then run ':checkhealth' to validate full installation"
```

### Brewfile Dependencies
```ruby
# Source: User's existing Brewfile + LazyVim requirements
# Brewfile

# Existing taps
tap 'yt-dlp/taps'
cask_args appdir: '/Applications'

# Core editor
brew 'neovim'              # >= 0.11.2 required

# LazyVim dependencies
brew 'ripgrep'             # Fast grep (Telescope)
brew 'fd'                  # Fast find (Telescope)
brew 'tree-sitter'         # Parser generator CLI

# Existing tools
brew 'git'                 # >= 2.19.0 for lazy.nvim
brew 'fzf'
brew 'mise'
# ... rest of existing Brewfile
```

### .gitignore for Neovim Config
```gitignore
# Source: LazyVim best practices
# config/nvim/.gitignore

# Lazy.nvim
lazy-lock.json

# Data directories (these should live in ~/.local/share/nvim/)
# If they appear here, something is misconfigured
data/
plugin/
state/

# OS files
.DS_Store
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Vimscript init.vim | Lua init.lua | Neovim 0.5+ (2021) | Lua is first-class, faster, better plugin APIs |
| vim-plug/packer | lazy.nvim | 2022-2023 | Async, lazy-loading, better performance, active development |
| Manual plugin config | LazyVim framework | 2023+ | Pre-configured LSP, treesitter, best practices, maintained |
| Vundle/Pathogen | Modern plugin managers | 2015+ | Async installation, parallel updates, lockfiles |
| nvim-treesitter release branch | nvim-treesitter main branch | LazyVim v15.x (2025) | Latest parsers, requires tree-sitter-cli system tool |
| Neovim 0.9.x | Neovim 0.11.2+ | LazyVim v15.x (2026) | Major LSP improvements, required for latest LazyVim |

**Deprecated/outdated:**
- **Vimscript-based configs:** Still work but Lua is now standard for Neovim, better performance and API access
- **vim-plug:** Synchronous plugin manager, slower than lazy.nvim, less active development
- **packer.nvim:** Author recommends lazy.nvim as successor, packer in maintenance mode
- **Pinning LazyVim to v14.x:** Only do this if stuck on old Neovim; miss out on updates and improvements

## Open Questions

Things that couldn't be fully resolved:

1. **Post-up hook execution timing for health checks**
   - What we know: Post-up hooks run after rcup creates symlinks, but before first Neovim launch
   - What's unclear: Best pattern for validating plugins installed on first launch vs. running checks in hook
   - Recommendation: Make health check hook informational (non-blocking), document that user should run `:checkhealth` after first launch. Alternatively, could detect first run and skip health checks, or implement retry logic.

2. **Optimal lazy-lock.json handling for personal dotfiles**
   - What we know: Can track it (reproducibility) or ignore it (always latest)
   - What's unclear: User's preference for plugin version consistency vs. simplicity
   - Recommendation: Add to `.gitignore` by default for personal dotfiles (simpler), document how to track it if user wants reproducibility. User can decide after seeing update frequency.

3. **Which LazyVim starter example files to keep**
   - What we know: Starter includes example plugin customizations, some are useful references
   - What's unclear: Which specific examples align with user's workflow (unknown until Phase 2 keybindings work)
   - Recommendation: Keep `lua/plugins/example.lua` initially as reference, review and remove/customize in Phase 2. At minimum, disable unwanted plugins by returning `{}` in spec.

4. **Health check error handling in automation**
   - What we know: `:checkhealth` outputs to buffer, can run headless with `--headless "+checkhealth" "+qa"`
   - What's unclear: Reliable way to detect health check failures in script (exit codes don't reflect check results)
   - Recommendation: Parse output for "ERROR" strings, or make health checks informational only. Priority is getting LazyVim running; health checks can be manual validation step.

## Sources

### Primary (HIGH confidence)
- [LazyVim Official Installation](https://www.lazyvim.org/installation) - Installation steps and structure
- [LazyVim GitHub Repository](https://github.com/LazyVim/LazyVim) - Requirements, version info
- [LazyVim Starter Template](https://github.com/LazyVim/starter) - Official starter structure
- [lazy.nvim Installation](https://lazy.folke.io/installation) - Bootstrap code and setup
- [lazy.nvim Lockfile Documentation](https://lazy.folke.io/usage/lockfile) - Lock file best practices
- [Neovim Health Documentation](https://neovim.io/doc/user/health.html) - Health check command usage
- [rcm GitHub Repository](https://github.com/thoughtbot/rcm) - rcm functionality
- [rcup Manual](https://thoughtbot.github.io/rcm/rcup.1.html) - Post-up hooks
- [rcrc Manual](https://thoughtbot.github.io/rcm/rcrc.5.html) - Configuration options

### Secondary (MEDIUM confidence)
- [LazyVim Discussion #850](https://github.com/LazyVim/LazyVim/discussions/850) - lazy-lock.json best practices (community consensus)
- [LazyVim Issue #6421](https://github.com/LazyVim/LazyVim/issues/6421) - v15.x migration requirements
- [thoughtbot rcm blog post](https://thoughtbot.com/blog/rcm-for-rc-files-in-dotfiles-repos) - rcm usage patterns
- [Homebrew tree-sitter formula](https://formulae.brew.sh/formula/tree-sitter) - Installation verification
- [DeepWiki LazyVim Troubleshooting](https://deepwiki.com/LazyVim/starter/7-troubleshooting-and-tips) - Common issues

### Tertiary (LOW confidence)
- Various search results on LazyVim setup issues - Validated patterns against official docs
- Community discussions on rcm + Neovim integration - Used for common patterns, not specific claims

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - All versions and requirements verified from official LazyVim documentation and GitHub
- Architecture: HIGH - Patterns verified from LazyVim starter template, rcm official documentation, and XDG standards
- Pitfalls: MEDIUM-HIGH - Based on official documentation (health checks, versions) and verified community issues, but some troubleshooting patterns are generalized

**Research date:** 2026-02-03
**Valid until:** 2026-03-03 (30 days) - LazyVim is stable, but active development. Neovim 0.12 may require research update when released.
