# Technology Stack

**Analysis Date:** 2026-02-03

## Languages

**Primary:**
- Bash - Used for CLI tool development (`bin/llmcat`, `bin/git-rewrite-branch`, `bin/nix-update`)
- Ruby - Used for scripting and utility scripts (`bin/repo2md`, `bin/darkwing`, `bin/titlecase`, `bin/alacify`, `bin/nvim-update-plugins`)
- Fish Shell - Primary shell for environment and configuration (`config/fish/`)
- Vim Script - NeoVim configuration (`config/nvim/`)
- Lua - Configuration language for Zellij (`config/zellij.kdl`)

**Secondary:**
- TOML - Configuration files (`tool-versions`, `config/mise/config.toml`, `config/starship.toml`, `config/aerospace/aerospace.toml`)
- YAML - Style definitions for Vale (`styles/*/` directories)
- JavaScript - Code styling tools configuration
- JSON - Settings and metadata files

## Runtime

**Environment:**
- macOS (Darwin) - Primary platform (evidenced by pbcopy usage, Brewfile, .app references)
- Linux support - Secondary (referenced in bin scripts)

**Version Management:**
- Mise - Tool version manager (`config/mise/config.toml`)
- ASDF-compatible `.tool-versions` file

**Configured Language Versions** (via `.tool-versions`):
- Elixir 1.19.0
- Elm 0.19.1
- Erlang 28.1
- GoHugo 0.152.2
- Golang 1.25.5
- Node.js 24.11.1
- Python 3.14.2
- Ruby 3.4.7
- Rust 1.91.1
- Java Corretto 21

## Frameworks & Tools

**Shell & Terminal:**
- Fish Shell - Primary shell configuration
- Starship - Prompt renderer (`config/starship.toml`)
- Zellij - Terminal multiplexer (`config/zellij.kdl`)
- NeoVim - Text editor with plugin configuration (`config/nvim/`)

**Development Tools:**
- Mise - Version manager for programming languages and tools
- Git with custom configuration (`gitconfig`)
- Fisher - Fish plugin manager (`Brewfile`)
- FZF - Fuzzy finder for interactive selection (`Brewfile`, referenced in `bin/llmcat`)
- Vale - Prose linting (`vale.ini`)
- RCM (Thoughtbot) - Dotfiles management system

**Build & Code Quality:**
- golangci-lint - Go linting (via Mise)
- golang-migrate - Database migrations for Go (via Mise)

## Key Dependencies (via Brewfile)

**CLI Tools:**
- `asciinema` - Terminal session recording
- `cowsay` - ASCII art text display
- `ctags` - Code indexing
- `figlet` - ASCII text rendering
- `fzf` - Fuzzy finder
- `highlight` - Code syntax highlighting
- `htop` - System monitoring
- `jq` - JSON processor
- `the_silver_searcher` - Fast file searching
- `wget` - File downloading
- `yt-dlp` - Video downloading

**System Tools:**
- `git` - Version control
- `hub` - GitHub CLI
- `mas` - Mac App Store CLI
- `neovim` - Text editor
- `ragel` - State machine compiler
- `zellij` - Terminal multiplexer

**NPM Tools** (via Mise):
- `@github/copilot` - GitHub Copilot integration
- `@openai/codex` - OpenAI Codex integration
- `opencode-ai` - AI code assistance

**Desktop Applications** (via Homebrew Cask):
- `1password` - Password manager
- `aerospace` - Window manager
- `ghostty` - Terminal emulator
- `google-chrome` - Web browser
- `insomnia` - API client
- `loopback` - Audio routing
- `ngrok` - Tunneling tool
- `obs` - Screen recording
- `postico` - PostgreSQL client
- `raycast` - Application launcher
- `visual-studio-code` - Code editor
- `vlc` - Media player

**macOS App Store Applications:**
- Slack, Discord, Fantastical, Keynote, Numbers, Pages, iA Writer, Xcode

## Configuration

**Dotfiles Management:**
- Manager: Thoughtbot's RCM
- Config: `rcrc` file specifies symlink rules
- iCloud Drive support: `~/dotfiles/` directory can contain secret/proprietary configs

**Git Configuration** (`gitconfig`):
- SSH-based authentication with Ed25519 keys
- 1Password SSH signing integration
- Git LFS support
- Custom aliases for common workflows
- GPG signing enabled

**Shell Configuration** (`config/fish/`):
- Homebrew environment setup
- Mise integration for version management
- Environment variables
- Aliases and functions
- FZF integration for fuzzy finding
- NNN file manager config

**Editor Configuration:**
- NeoVim: `config/nvim/` with plugins for LSP, Git, Elm, Ruby, Go
- VS Code: `config/code/User/settings.json`

**Prose Linting:**
- Vale: `vale.ini` with styles (Alex, write-good, proselint, Google, Joblint)

## Platform Requirements

**Development:**
- macOS (primary) with Xcode command line tools
- Homebrew package manager
- Git and SSH
- 1Password for SSH signing
- Terminal capable of 256 colors (for Starship prompt)

**Production:**
- Linux/macOS/WSL capable environments
- Fish Shell 3.x+
- Git
- Mise for language version management

**Optional:**
- NeoVim 0.8+ for advanced editor features
- PostgreSQL client (via Postico)
- Vagrant + VirtualBox for Ubuntu 20.04 LTS VM (defined in `Vagrantfile`)

---

*Stack analysis: 2026-02-03*
