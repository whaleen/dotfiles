# dotfiles

Personal configuration files and bootstrap scripts for macOS.

## Quick Start

```bash
# Full new machine setup
./install.sh

# Re-link dotfiles only (no installs)
./link.sh
```

## Scripts

- `install.sh` — Full bootstrap script
- `link.sh` — Symlink configuration files
- `bin/cert` — Quickly generate and copy `cntx-ui` certification prompts using `fzf`

## Shell

- `.zshrc` — Zsh config (oh-my-zsh, nvm, pnpm, bun, Solana, fzf, yt-dlp/VLC, zoxide)
- `.bash_profile` — Bash profile (Solana, broot, cargo)
- `.profile` — Login profile (cargo, nvm, Solana)
- `.gitconfig` — Git user config
- `.npmrc` — npm registry authentication (uses NPM_TOKEN env var)

## App Configs

- `.config/ghostty/config` — Ghostty terminal (Vesper-inspired color scheme)
- `.config/cursor/settings.json` — Cursor editor settings
- `.config/gh/config.yml` — GitHub CLI config
- `.config/git/ignore` — Global gitignore
- `.config/broot/` — Broot file manager (conf + verbs)
- `.config/youtube-tui/` — YouTube TUI config

## AI Tools

- `.claude/CLAUDE.md` — Global Claude Code instructions
- `.claude/settings.json` — Claude Code settings
- `.claude.json` — Global Claude metrics and session state
- `.gemini/` — Gemini CLI configuration (settings, projects, trusted folders)
- `.codex/` — Codex CLI configuration and global rules
- `.config/opencode/package.json` — OpenCode plugin environment
- `.config/opencode/opencode.json` — OpenCode settings and autonomous mode

## Package Inventories

- `Brewfile` — Homebrew packages (taps, formulae, casks, vscode extensions, cargo crates)
- `npm-global.txt` — npm global packages (read by `install.sh`)
- `cargo-global.txt` — Cargo crates (read by `install.sh`)
