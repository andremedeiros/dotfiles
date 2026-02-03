# Dotfiles

This is my dotfiles repo. There are many others, but this one is mine.

The dotfiles here are managed with [Thoughtbot's rcm](https://github.com/thoughtbot/rcm).

## Installation

**Prerequisites:**
- Xcode Command Line Tools
- [Homebrew](https://brew.sh/)

**Setup:**
```bash
xcode-select --install
mkdir -p ~/src/github.com/andremedeiros
git -C ~/src/github.com/andremedeiros clone https://github.com/andremedeiros/dotfiles.git
cd ~/src/github.com/andremedeiros/dotfiles
script/bootstrap
git remote set-url origin git@github.com:andremedeiros/dotfiles.git
```

You can also add secret/proprietary dotfiles on your iCloud drive. Anything inside `iCloud Drive/dotfiles` will also be symlinked with the same rules as here.

## What is rcm?

[rcm](https://github.com/thoughtbot/rcm) is a dotfiles manager from thoughtbot. It creates symlinks from this repository to your home directory, making it easy to keep your configuration under version control.

**How it works:**
- Files are symlinked from this repo to your home directory
- The `config/` directory is symlinked to `~/.config/` (XDG standard)
- Hooks in `hooks/post-up/` run automatically after each `rcup`

**Key commands:**
- `rcup` - Install/update symlinks
- `lsrc` - List what will be symlinked
- `rcdn` - Remove symlinks

See the [rcm documentation](https://github.com/thoughtbot/rcm) for more details.

## Neovim

This configuration uses [LazyVim](https://www.lazyvim.org/), a Neovim configuration framework built on lazy.nvim.

### Setup

**First-time setup:**
1. Ensure Neovim >= 0.11.2 is installed (via `brew install neovim`)
2. Run `nvim` - plugins will install automatically on first launch
3. Wait for installation to complete
4. Run `:checkhealth` to verify everything is working

**Configuration files:**
- `config/nvim/init.lua` - Entry point
- `config/nvim/lua/config/keymaps.lua` - Custom keybindings
- `config/nvim/lua/plugins/` - Custom plugin configurations

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

## Tmux

Leader is bound to <kbd>Ctrl+Space</kbd>

### Splitting

* <kbd>[leader]-|</kbd> Split vertically
* <kbd>[leader]--</kbd> Split horizontally

### Navigation

* <kbd>[leader]-h</kbd> Navigate to left pane
* <kbd>[leader]-l</kbd> Navigate to right pane
* <kbd>[leader]-k</kbd> Navigate to pane above
* <kbd>[leader]-j</kbd> Navigate to pane below
* <kbd>[leader]-w</kbd> Navigate windows
* <kbd>[leader]-s</kbd> Navigate sessions
* <kbd>[leader]-[</kbd> Enter scroll mode (<kbd>q</kbd> quits)

### Session

* <kbd>[leader]-c</kbd> New window
* <kbd>[leader]-z</kbd> Zoom on current pane

## Guides

- [fd](https://github.com/sharkdp/fd)
