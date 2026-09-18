# Dotfiles

This is my dotfiles repo. There are many others, but this one is mine.

The dotfiles here are managed with [chezmoi](https://www.chezmoi.io/).

## Installation

**Prerequisites:**
- Xcode Command Line Tools
- [Homebrew](https://brew.sh/)
- Signed into the App Store (required for `mas` entries in the Brewfile)

**Setup:**
```bash
xcode-select --install
mkdir -p ~/Code/github.com/andremedeiros
git -C ~/Code/github.com/andremedeiros clone https://github.com/andremedeiros/dotfiles.git
cd ~/Code/github.com/andremedeiros/dotfiles
script/bootstrap
git remote set-url origin git@github.com:andremedeiros/dotfiles.git
```

`script/bootstrap` installs chezmoi and runs `chezmoi init --apply`, which renders everything into `~/` and runs the `run_*` scripts (brew bundle, mise install, shell setup, vale sync). Some scripts need `sudo`. Finder shows `~/Code` with a Developer icon.

**After bootstrap:**
1. **1Password** — sign in, then enable the SSH agent: Settings → Developer → "Use the SSH agent". Required for SSH commit signing (`op-ssh-sign`) and `ssh/config`'s `IdentityAgent`.
2. **GitHub auth** — `gh auth login` then `gh auth setup-git`. HTTPS remotes authenticate via gh's credential helper; `git@github.com:` URLs are rewritten to HTTPS by `url.insteadOf` in gitconfig.
3. **Neovim** — run `nvim` once to bootstrap plugins, then `:checkhealth`.
4. **Shell** — log out/in (or `exec fish`) so the new login shell takes effect.

You can also add secret/proprietary dotfiles on your iCloud drive. Anything inside `iCloud Drive/dotfiles/blobs/` is rsynced into `~/` on every `chezmoi apply`.

## What is chezmoi?

[chezmoi](https://www.chezmoi.io/) manages dotfiles by rendering a source directory (this repo) into your home directory. Unlike symlink-based managers, files are copied — edit the repo, then `chezmoi apply`.

**How it works:**
- `dot_foo` → `~/.foo`, `dot_config/` → `~/.config/`, `private_dot_ssh/` → `~/.ssh/` (with 0700)
- `run_*.sh` scripts execute during `chezmoi apply`:
  - `run_once_before_*` — one-time setup (icloud symlink, sudoers)
  - `run_before_*` — every apply (iCloud blob/font sync)
  - `run_onchange_*` — re-runs when the script changes; `.tmpl` variants also re-run when their inputs change (Brewfile, tool-versions)

**Key commands:**
- `chezmoi apply` — render + install everything
- `chezmoi diff` — preview changes
- `chezmoi edit ~/.config/nvim/init.lua` — edit the source for a target
- `chezmoi update` — pull repo + apply

**Fonts:** Operator Mono lives in iCloud `dotfiles/blobs/Library/Fonts/` (licensed, not committed). `run_before_01-sync-blobs.sh` rsyncs blobs into `~/` on every apply.

See the [chezmoi documentation](https://www.chezmoi.io/) for more details.

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
| <kbd>Leader</kbd> + <kbd>u</kbd> <kbd>h</kbd> | Normal | Toggle inlay hints (off by default) |

### Running Tests

Tests run via [neotest](https://github.com/nvim-neotest/neotest) (LazyVim's `test.core` extra), with Go supported through `neotest-golang`:

| Key | Action |
|-----|--------|
| <kbd>Leader</kbd> + <kbd>t</kbd> <kbd>r</kbd> | Run nearest test |
| <kbd>Leader</kbd> + <kbd>t</kbd> <kbd>t</kbd> | Run current file |
| <kbd>Leader</kbd> + <kbd>t</kbd> <kbd>T</kbd> | Run all test files |
| <kbd>Leader</kbd> + <kbd>t</kbd> <kbd>l</kbd> | Run last test |
| <kbd>Leader</kbd> + <kbd>t</kbd> <kbd>s</kbd> | Toggle summary panel |
| <kbd>Leader</kbd> + <kbd>t</kbd> <kbd>o</kbd> | Show test output |
| <kbd>Leader</kbd> + <kbd>t</kbd> <kbd>w</kbd> | Toggle watch mode |

For LazyVim's built-in keybindings, see the [official keymaps documentation](https://www.lazyvim.org/keymaps).

## Guides

- [fd](https://github.com/sharkdp/fd)
