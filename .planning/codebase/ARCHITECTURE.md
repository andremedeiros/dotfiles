# Architecture

**Analysis Date:** 2026-02-03

## Pattern Overview

**Overall:** Configuration Management System (Dotfiles Repository)

**Key Characteristics:**
- Managed by Thoughtbot's rcm for symlinking and installation
- Modular layer-based approach separating config types
- Hook-based lifecycle management (pre-up, post-up)
- Multi-language development environment configuration
- Platform-specific overrides and customizations

## Layers

**Installation & Lifecycle:**
- Purpose: Bootstrap and manage dotfiles installation and updates
- Location: `script/bootstrap`, `hooks/`
- Contains: Shell scripts for initialization, hook handlers
- Depends on: Homebrew, rcm, Git
- Used by: Manual installation process, rcm management system

**Configuration Management:**
- Purpose: Define dotfiles structure and exclusion patterns
- Location: `rcrc`
- Contains: rcm configuration and directory directives
- Depends on: rcm
- Used by: rcm symlink generation during installation

**Shell Environment & Aliases:**
- Purpose: Fish shell configuration and environment setup
- Location: `config/fish/conf.d/`
- Contains: Individual Fish scripts for environment setup, aliases, prompt
- Depends on: Fish shell, Homebrew, Mise, direnv, fzf
- Used by: Interactive shell sessions

**Editor Configuration:**
- Purpose: NeoVim and VS Code editor settings
- Location: `config/nvim/`, `config/code/User/`
- Contains: Vim configuration, plugin management, language-specific settings
- Depends on: Neovim, minpac, various vim plugins
- Used by: Editor sessions for development

**System Tools Configuration:**
- Purpose: Configuration for system utilities and terminal multiplexers
- Location: `config/mise/`, `config/aerospace/`, `config/starship.toml`, `config/zellij.kdl`
- Contains: Tool version management, window management, prompt/shell decoration
- Depends on: Mise, Aerospace, Starship, Zellij
- Used by: System initialization and development workflows

**Utility Scripts:**
- Purpose: Custom CLI tools and automation
- Location: `bin/`
- Contains: Executable scripts for file processing, repository utilities, system tools
- Depends on: Bash, Ruby, Git, fzf
- Used by: Manual invocation in development workflows

**Automation/Hooks:**
- Purpose: Automate setup tasks during dotfiles installation
- Location: `hooks/pre-up/`, `hooks/post-up/`
- Contains: Sequential setup scripts numbered for execution order
- Depends on: System utilities, package managers, configuration files
- Used by: rcm during `rcup` installation process

**Documentation & Linting Rules:**
- Purpose: Writing style guides and documentation configuration
- Location: `styles/`, `vale.ini`
- Contains: Vale linting rules for multiple style guides (Google, write-good, proselint, alex, Joblint)
- Depends on: Vale
- Used by: Documentation validation and writing consistency

**SSH & Security:**
- Purpose: SSH key and identity configuration
- Location: `ssh/`, `gnupg/`
- Contains: SSH control configuration, GPG settings
- Depends on: OpenSSH, GnuPG
- Used by: Git authentication, secure communication

## Data Flow

**Installation Flow:**

1. User runs `script/bootstrap` from cloned repository
2. Bootstrap detects and installs Homebrew if missing
3. Bootstrap installs rcm via Homebrew
4. Bootstrap runs `rcup` with custom RCRC configuration
5. rcup symlinks dotfiles to home directory, respecting excludes
6. Pre-up hooks execute (setup symlinks, setup sudo, sync blobs)
7. Post-up hooks execute in order (00-14): brew bundle, defaults, plugins, shell config, languages, binaries, codesign, tmux, fzf, secrets
8. Installation complete

**Configuration Loading Flow:**

1. Shell initializes Fish
2. Fish sources `config/fish/conf.d/` files in order
3. Early init: Homebrew setup (00-homebrew.fish)
4. Environment setup: paths, editors, tool configuration (10-environment.fish)
5. Mise version management initialized
6. Alias and function definitions loaded
7. Additional integrations: fzf, nnn, direnv sourced
8. Ready for user interaction

**State Management:**
- No persistent state beyond symlinks - configuration is declarative
- rcm manages symlink consistency between repo and home
- Version management via `tool-versions` for language runtimes
- Secrets managed separately via iCloud Drive integration (optional)

## Key Abstractions

**Dotfiles Configuration:**
- Purpose: Centralize all configuration files under version control
- Examples: `config/nvim/`, `config/fish/`, `gitconfig`, `editorconfig`
- Pattern: Source files stored in repo, symlinked to home via rcm

**Hook System:**
- Purpose: Execute setup tasks in defined sequence with dependencies
- Examples: `hooks/pre-up/`, `hooks/post-up/`
- Pattern: Numbered shell scripts executed in order, separated by phase

**Tool Configuration Modules:**
- Purpose: Separate configuration for different tools and languages
- Examples: `config/nvim/plugins/`, `config/fish/conf.d/`, `bin/`
- Pattern: Modular files sourced/included by parent configuration

**Language Version Management:**
- Purpose: Maintain consistent runtime versions across projects
- Examples: `tool-versions` for Mise, `.ruby-version`, `.go-version` alternatives
- Pattern: Version manifest defining required versions for tools

## Entry Points

**Script Bootstrap:**
- Location: `script/bootstrap`
- Triggers: Manual execution by user during initial setup
- Responsibilities: Install Homebrew, install rcm, execute rcup, configure git origin

**rcm rcup:**
- Location: Invoked from `script/bootstrap`
- Triggers: Bootstrap script or manual `env RCRC="$(pwd)"/rcrc rcup`
- Responsibilities: Read rcrc config, create symlinks, execute hooks

**Fish Shell Initialization:**
- Location: Fish reads `config/fish/conf.d/` automatically
- Triggers: Shell startup
- Responsibilities: Load environment, aliases, prompt, integrations

**Neovim Init:**
- Location: `config/nvim/init.vim`
- Triggers: Neovim application startup
- Responsibilities: Load plugins via minpac, set keybindings, configure editor behavior

**Hammerspoon Init:**
- Location: `hammerspoon/init.lua`
- Triggers: macOS Hammerspoon daemon startup
- Responsibilities: Load modules, setup window management, keyboard shortcuts

## Error Handling

**Strategy:** Fail-fast with detailed error reporting

**Patterns:**
- Bootstrap uses `set -e` to exit on error
- Hook scripts use `set -e` for error propagation
- Pre-up hooks prevent proceeding if critical setup fails
- Symlink creation validated by rcm
- Individual hook failures reported but don't block subsequent hooks

## Cross-Cutting Concerns

**Logging:** Limited logging in hooks - primarily via stdout/stderr during installation

**Validation:**
- Git attributes and ignore patterns in `gitattributes`, `.gitignore`
- EditorConfig standard compliance for indent/formatting
- Vale style validation for Markdown documentation

**Authentication:**
- Git SSH configuration with key signing via 1Password
- GPG signing enabled for commits
- SSH control socket configuration for connection reuse

---

*Architecture analysis: 2026-02-03*
