# Phase 3: Documentation - Research

**Researched:** 2026-02-03
**Domain:** Dotfiles documentation and old configuration cleanup
**Confidence:** HIGH

## Summary

This phase involves documentation and cleanup rather than new technical implementation. The research focuses on three areas: (1) documenting the completed LazyVim migration in README.md, (2) verifying what old vimscript configuration remains, and (3) understanding dotfiles documentation best practices.

The old vimscript configuration has already been removed in a prior commit (`6659b1b`). The git history preserves 11 deleted files (init.vim, language configs, plugin configs) using the minpac plugin manager. No custom snippets or unique plugins need migration - the old config used common plugins (NERDTree, fzf, gitgutter, vim-go) that have equivalents in LazyVim's default setup.

For documentation, the standard approach is a single README.md with clear sections: installation/setup, rcm explanation, and keybinding reference. The keybinding table should use `<kbd>` HTML tags for visual distinction and include both the key and its action/description.

**Primary recommendation:** Update README.md with Setup/Installation and Custom Keybindings sections. Present keybindings as a simple table with `<kbd>` formatting. No old config cleanup needed as it was already removed.

## Standard Stack

This phase is primarily documentation work with no new libraries required.

### Core
| Tool | Version | Purpose | Why Standard |
|------|---------|---------|--------------|
| Markdown | - | Documentation format | Universal for GitHub READMEs |
| HTML `<kbd>` tags | - | Keyboard key formatting | Semantic HTML for keyboard input, renders with visual styling |
| Git | installed | Version control cleanup | Already in use |

### Supporting
| Tool | Version | Purpose | When to Use |
|------|---------|---------|-------------|
| rcm | installed | Dotfiles management | Already in use, needs documentation |
| LazyVim | v15.x | Config framework | Already configured, document usage |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Single README.md | README + docs/ folder | User decided on single file (simpler) |
| `<kbd>` tags | Backtick code formatting | `<kbd>` provides semantic HTML and visual styling |
| Table format | List format | Tables are more scannable for key reference |

## Architecture Patterns

### Recommended README Structure
```markdown
# Dotfiles

Brief intro about the repository.

## Installation

Prerequisites and setup steps with rcup command.

## What is rcm?

Brief explanation of rcm and how it works.

## Neovim

### Setup

Brief LazyVim explanation with first-launch instructions.

### Custom Keybindings

Table of custom keybindings.
```

### Pattern 1: Keybinding Table Format
**What:** Present keybindings as a scannable table with key, mode, and description
**When to use:** For documenting custom keybindings that differ from defaults
**Example:**
```markdown
| Key | Mode | Action |
|-----|------|--------|
| <kbd>H</kbd> | Normal | Go to first non-whitespace character |
| <kbd>L</kbd> | Normal | Go to end of line |
| <kbd>//</kbd> | Normal | Clear search highlight |
| <kbd><</kbd> / <kbd>></kbd> | Visual | Indent without losing selection |
| <kbd>Leader</kbd> + <kbd>p</kbd> | Normal | Find files |
| <kbd>Leader</kbd> + <kbd>Tab</kbd> | Normal | Switch to alternate buffer |
| <kbd>Leader</kbd> + <kbd>z</kbd> | Normal | Toggle window zoom |
```

### Pattern 2: rcm Explanation for New Users
**What:** Brief explanation of what rcm does for users unfamiliar with it
**When to use:** In README when rcm is not universally known
**Example:**
```markdown
## What is rcm?

[rcm](https://github.com/thoughtbot/rcm) is a dotfiles manager from thoughtbot.
It creates symlinks from this repository to your home directory. The main
command is `rcup`, which reads configuration from `~/.rcrc` (also symlinked).

Files in `config/` are symlinked to `~/.config/` (XDG standard).
Files in `hooks/` run automatically during `rcup`.
```

### Pattern 3: LazyVim First-Launch Documentation
**What:** Document that LazyVim needs first launch to bootstrap plugins
**When to use:** Any LazyVim-based config documentation
**Example:**
```markdown
### Neovim Setup

This config uses [LazyVim](https://www.lazyvim.org/). On first launch:

1. Run `nvim` - plugins will install automatically
2. Wait for installation to complete
3. Run `:checkhealth` to verify everything is working
```

### Anti-Patterns to Avoid
- **Documenting deprecated features:** User decided not to mention old vimscript config
- **Overly detailed LazyVim documentation:** LazyVim has its own excellent docs, link don't replicate
- **Listing every LazyVim default keybinding:** Only document custom additions
- **Complex directory structures in README:** User decided on single file, keep it simple

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Keybinding discovery | Manual list of all bindings | which-key.nvim (built into LazyVim) | Press `<Space>` to see all keybindings interactively |
| LazyVim documentation | Detailed usage guide | Link to lazyvim.org | Official docs are comprehensive and maintained |
| rcm documentation | Full tutorial | Link to thoughtbot/rcm | Official docs cover all use cases |

**Key insight:** README should be a quick-start guide, not comprehensive documentation. Link to official sources for depth.

## Common Pitfalls

### Pitfall 1: Documenting Everything vs. Essentials
**What goes wrong:** README becomes too long, users don't read it
**Why it happens:** Tendency to document every detail "just in case"
**How to avoid:** Focus on what users need to get started and what's unique to this setup
**Warning signs:** README > 200 lines, sections that duplicate official docs

### Pitfall 2: Stale Keybinding Documentation
**What goes wrong:** README shows keybindings that no longer exist or have different behavior
**Why it happens:** Code changes but README isn't updated
**How to avoid:**
- Only document custom keybindings (fewer to maintain)
- Reference source file: "See `lua/config/keymaps.lua` for all custom bindings"
- Use which-key for interactive discovery
**Warning signs:** Users report "X keybinding doesn't work"

### Pitfall 3: Forgetting Prerequisites
**What goes wrong:** New user follows README but setup fails
**Why it happens:** Author assumes tools are installed
**How to avoid:** Document all prerequisites (Homebrew, Neovim version requirements)
**Warning signs:** Issues asking "why doesn't rcup work?"

### Pitfall 4: Old Config References Remaining
**What goes wrong:** README references old plugins, keybindings, or file locations
**Why it happens:** README wasn't fully updated during migration
**How to avoid:**
- Review entire README for vimscript-era references
- Check for references to old plugins (NERDTree, fzf.vim, etc.)
- Update or remove Go-specific, Ruby-specific sections if no longer relevant
**Warning signs:** References to `init.vim`, `minpac`, old plugin names

## Code Examples

### Complete Keybinding Table
```markdown
### Custom Keybindings

Leader key is <kbd>Space</kbd>. Press <kbd>Space</kbd> in normal mode to see all available commands via which-key.

These are custom additions to LazyVim's defaults:

| Key | Mode | Action |
|-----|------|--------|
| <kbd>H</kbd> | Normal | Go to first non-whitespace character |
| <kbd>L</kbd> | Normal | Go to end of line |
| <kbd>//</kbd> | Normal | Clear search highlight |
| <kbd><</kbd> / <kbd>></kbd> | Visual | Indent without losing selection |
| <kbd>Leader</kbd> + <kbd>p</kbd> | Normal | Find files |
| <kbd>Leader</kbd> + <kbd>Tab</kbd> | Normal | Switch to alternate buffer |
| <kbd>Leader</kbd> + <kbd>z</kbd> | Normal | Toggle window zoom |

For LazyVim's built-in keybindings, see the [official keymaps documentation](https://www.lazyvim.org/keymaps).
```

### rcm Section Example
```markdown
## Dotfiles Management

This repository uses [rcm](https://github.com/thoughtbot/rcm) from thoughtbot.

**How it works:**
- Files are symlinked from this repo to your home directory
- The `config/` directory is symlinked to `~/.config/` (XDG standard)
- Hooks in `hooks/post-up/` run after each `rcup`

**Key commands:**
- `rcup` - Install/update symlinks
- `lsrc` - List what will be symlinked
- `rcdn` - Remove symlinks

See [rcm documentation](https://github.com/thoughtbot/rcm) for more details.
```

### Neovim Section Example
```markdown
## Neovim

Uses [LazyVim](https://www.lazyvim.org/) configuration framework.

**First-time setup:**
1. Ensure Neovim >= 0.11.2 is installed (`brew install neovim`)
2. Run `nvim` - plugins install automatically on first launch
3. Run `:checkhealth` to verify installation

**Configuration files:**
- `config/nvim/init.lua` - Entry point
- `config/nvim/lua/config/keymaps.lua` - Custom keybindings
- `config/nvim/lua/plugins/` - Custom plugin configurations
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Plain text README | Markdown README.md | Standard | Better formatting, GitHub rendering |
| Backticks for keys | `<kbd>` HTML tags | Modern practice | Semantic HTML, visual distinction |
| Full documentation | Quick-start + links | Best practice | Reduces maintenance, uses official docs |
| Document all keybindings | Document only custom | Modern practice | Less maintenance, use which-key for discovery |

**Deprecated/outdated:**
- **Text-only keybinding docs:** `<kbd>` tags provide visual styling
- **Comprehensive local documentation:** Link to official docs instead

## Open Questions

None for this phase. Documentation scope is clear:
1. Update README.md with Setup, rcm explanation, and Keybindings sections
2. Old vimscript config already removed (verified in git history)
3. No custom snippets/plugins to migrate (verified old config used common plugins)

## Sources

### Primary (HIGH confidence)
- [thoughtbot/dotfiles README](https://github.com/thoughtbot/dotfiles/blob/main/README.md) - Reference for well-structured dotfiles documentation
- [rcm documentation](https://github.com/thoughtbot/rcm) - Official rcm usage
- [rcup manual](https://thoughtbot.github.io/rcm/rcup.1.html) - rcup command reference
- [LazyVim keymaps documentation](https://www.lazyvim.org/keymaps) - Reference for keybinding documentation style
- [Keyboard key markup in Markdown](https://gist.github.com/bittner/f3e2804e06c663510e939ca569ee483e) - `<kbd>` tag best practices

### Secondary (MEDIUM confidence)
- [Managing Dotfiles guide](https://www.jakewiesler.com/blog/managing-dotfiles) - General dotfiles documentation patterns
- [Dotfiles best practices](https://www.daytona.io/dotfiles/ultimate-guide-to-dotfiles) - README section recommendations

### Repository Analysis (HIGH confidence)
- Git commit `6659b1b` - Verified old vimscript removal (11 files removed)
- `config/nvim/lua/config/keymaps.lua` - Current custom keybindings
- Existing `README.md` - Current state requiring update
- `hooks/post-up/03-vim-plugins` - Current Neovim validation hook

## Metadata

**Confidence breakdown:**
- Documentation patterns: HIGH - Verified from thoughtbot/dotfiles and official rcm docs
- Old config status: HIGH - Verified via git history analysis
- Keybinding format: HIGH - `<kbd>` tags are standard HTML and render consistently

**Research date:** 2026-02-03
**Valid until:** 2026-05-03 (90 days) - Documentation patterns are stable
