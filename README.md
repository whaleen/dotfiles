# dotfiles

Personal configuration files and bootstrap scripts for macOS.
Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Start

```bash
# Full new machine setup
./install.sh

# Re-stow dotfiles only (no installs)
stow -t ~ -d ~/Projects/_whaleen/dotfiles --restow zsh bash git npm \
  ghostty cursor gh yabai btop yazi opencode lsd \
  warp claude gemini codex scripts
```

## Structure

Each top-level directory is a stow package. The tree inside each package mirrors `$HOME`.

```
dotfiles/
  zsh/              .zshrc, .zshenv, .config/vesper-fzf.sh
  bash/             .bash_profile, .profile
  git/              .gitconfig, .config/git/ignore
  npm/              .npmrc
  ghostty/          .config/ghostty/config
  cursor/           .config/cursor/settings.json, .cursor/extensions/vesper-custom/
  gh/               .config/gh/config.yml
  yabai/            .config/yabai/yabairc
  btop/             .config/btop/btop.conf, .config/btop/themes/vesper.theme
  yazi/             .config/yazi/yazi.toml, .config/yazi/theme.toml
  lsd/              .config/lsd/colors.yaml
  opencode/         .config/opencode/package.json
  warp/             .warp/themes/Vesper.yaml, .warp/launch_configurations/
  claude/           .claude/CLAUDE.md, .claude/settings.json
  gemini/           .gemini/settings.json
  codex/            .codex/config.toml
  scripts/          .local/bin/cert
```

## Theme

All tools share a single color palette based on [Vesper](https://github.com/raunofreiberg/vesper).

```bash
# Edit the master palette
$EDITOR theme/vesper.sh

# Regenerate all tool configs
./theme/generate.sh

# Restow to apply
stow -t ~ --restow ghostty warp yazi btop lsd cursor zsh
```

Generated configs: Ghostty, Warp, Yazi, btop, lsd, fzf, Cursor.

## Adding a new config

1. Create a directory for the package.
2. Inside it, recreate the path from `$HOME` to the config file.
3. Add the package name to `STOW_PACKAGES` in `install.sh`.
4. Run `stow -t ~ <package>`.

## Scripts

- `install.sh` — Full bootstrap (Homebrew, nvm, Rust, Solana, stow, macOS defaults)
- `theme/generate.sh` — Regenerate all tool themes from `theme/vesper.sh`

## Package Inventories

- `Brewfile` — Homebrew packages (taps, formulae, casks, vscode extensions, cargo crates)
- `npm-global.txt` — npm global packages
- `cargo-global.txt` — Cargo crates
