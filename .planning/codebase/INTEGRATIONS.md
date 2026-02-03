# External Integrations

**Analysis Date:** 2026-02-03

## APIs & External Services

**AI/Code Generation:**
- GitHub Copilot - Code completion and suggestions
  - SDK/Client: `@github/copilot` (npm package via Mise)
  - Integration: NeoVim LSP configuration (`config/nvim/plugins/vim-lsp.vim`)

- OpenAI Codex - AI code generation
  - SDK/Client: `@openai/codex` (npm package via Mise)
  - Integration: Available for development tools

- OpenCode AI - AI-assisted code tools
  - SDK/Client: `opencode-ai` (npm package via Mise)

**Git Hosting:**
- GitHub - Repository hosting and version control
  - Config: `gitconfig` with custom remote configuration
  - SSH URL rewrite: Converts HTTPS to SSH (`git@github.com:`)
  - PR merging: Custom alias `pr = pull-request` using hub CLI
  - User: `andremedeiros` (configured in `gitconfig`)

**API Testing:**
- Insomnia - API client for testing
  - Type: Desktop application (Homebrew Cask)
  - Purpose: REST/GraphQL API development and testing

**Network Tunneling:**
- ngrok - HTTP/TCP tunneling service
  - Type: Desktop application (Homebrew Cask)
  - Purpose: Exposing local services to internet

**Stream/Content:**
- IFTTT integration via whatthecommit.com
  - Used in: `gitconfig` custom alias `vomit`
  - Purpose: Generates random commit messages from public API

## Data Storage

**Databases:**
- PostgreSQL - Primary database
  - Client: Postico (desktop application via Homebrew Cask)
  - Purpose: Database administration and query execution
  - Note: No connection details in dotfiles (secrets managed separately)

**Version Control Storage:**
- Git with Git LFS
  - Config: `gitconfig` with LFS filter enabled
  - Binary file support: Large file storage

## Authentication & Identity

**SSH/GPG:**
- SSH Key Type: Ed25519
  - Stored in: `gitconfig` as signing key
  - Path: `~/.ssh/` (standard location)

- SSH Signing Provider: 1Password
  - Config: `[gpg "ssh"] program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"`
  - Purpose: Sign Git commits with 1Password-managed SSH keys
  - Authentication: System keychain integration

- Git Commit Signing: Enabled
  - Config: `[commit] gpgsign = true`
  - Format: SSH signatures
  - Requirement: All commits must be signed

**1Password Integration:**
- SSH key management and signing
- Password storage for various services
- iCloud Drive syncing for proprietary dotfiles

## Monitoring & Observability

**Performance Monitoring:**
- htop - System performance monitoring (CLI tool via Homebrew)
  - Purpose: Real-time process and system resource monitoring

**Code Quality:**
- Vale - Prose linting and style checking
  - Config: `vale.ini`
  - Styles: Google, Joblint, Alex, write-good, proselint
  - Purpose: Writing quality and consistency checks

**Debugging:**
- GDB - GNU Debugger
  - Config: `.gdbinit`
  - Supported in NeoVim LSP configuration

**Terminal Recording:**
- asciinema - Terminal session recording and playback
  - Purpose: Recording command-line sessions for documentation

## CI/CD & Deployment

**Hosting:**
- GitHub Pages - Static site hosting (potential via Hugo)
- Docker/Vagrant - Containerization support
  - Vagrantfile: Ubuntu 20.04 LTS VM setup with 4GB RAM, 2 CPUs
  - VirtualBox provider

**Static Site Generation:**
- GoHugo - Static site generator
  - Version: 0.152.2 (via tool-versions)
  - Purpose: Blog or documentation generation

**Version Control Hooks:**
- Location: `hooks/` directory
- Purpose: Custom Git hooks for automation

**CI Pipeline:**
- Not explicitly configured in dotfiles
- Git hooks available for custom automation
- Potential integration with GitHub Actions

## Environment Configuration

**Required Environment Variables:**
- OpenAI API Key (for Codex/Copilot integration)
- GitHub Token (for hub CLI authentication)
- PostgreSQL connection details (if using Postico)
- 1Password SSH configuration

**Configuration Loading:**
- Mise: `config/mise/config.toml` - Version manager config
- Fish Shell: `config/fish/conf.d/` - Environmental setup
  - Homebrew paths
  - Language version managers
  - FZF configuration
  - Mise initialization

**Secrets Location:**
- 1Password - Primary secret management
- SSH keys: `~/.ssh/` (system standard)
- iCloud Drive: `~/dotfiles/` for proprietary secrets

## Webhooks & Callbacks

**Incoming:**
- None detected in dotfiles

**Outgoing:**
- whatthecommit.com API - Random commit message generation
  - Endpoint: `https://whatthecommit.com/index.txt`
  - Used in: Git alias `vomit`
  - Purpose: Humorous commit messages

**Git Hooks:**
- Location: `hooks/` directory
- Pre-commit, post-commit, pre-push hooks available
- Custom automation points for development workflow

## External Tool Integrations

**Package Managers:**
- Homebrew - System package management
  - Brewfile location: Repository root
  - Managed packages: Development tools, applications, CLI utilities
  - Cask support: Desktop applications

- Fisher - Fish plugin manager
  - Purpose: Managing Fish shell extensions
  - Installed via: Homebrew

**Development Utilities:**
- GitHub Hub - GitHub CLI
  - Config: `[github] user = andremedeiros`
  - Aliases: `pr = pull-request`

- git-lfs - Large file storage
  - Config: Enabled in gitconfig
  - Supported operations: clean, smudge, process filters

**Language-Specific:**
- RVM/rbenv alternatives: Managed via Mise
- NVM alternatives: Node.js version via Mise
- pyenv alternatives: Python version via Mise

---

*Integration audit: 2026-02-03*
