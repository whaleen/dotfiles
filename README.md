# dotfiles

Personal configuration files and bootstrap scripts for macOS.
Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Start

```bash
# Full new machine setup
./install.sh

# Re-stow dotfiles only (no installs)
stow -t ~ -d ~/Projects/_whaleen/dotfiles --restow zsh bash git npm \
  ghostty cursor gh yabai skhd sketchybar btop yazi opencode lsd \
  warp claude gemini codex scripts
```

## Structure

Each top-level directory is a stow package. The tree inside each package mirrors `$HOME`.

```
dotfiles/
  zsh/              .zshrc, .zshenv, .config/whaleen-fzf.sh
  bash/             .bash_profile, .profile
  git/              .gitconfig, .config/git/ignore
  npm/              .npmrc
  ghostty/          .config/ghostty/config
  cursor/           .config/cursor/settings.json, .cursor/extensions/whaleen/
  gh/               .config/gh/config.yml
  yabai/            .config/yabai/yabairc
  skhd/             .config/skhd/skhdrc
  sketchybar/       .config/sketchybar/sketchybarrc, plugins/
  btop/             .config/btop/btop.conf, .config/btop/themes/whaleen.theme
  yazi/             .config/yazi/yazi.toml, .config/yazi/theme.toml
  lsd/              .config/lsd/colors.yaml
  opencode/         .config/opencode/package.json
  warp/             .warp/themes/Whaleen.yaml
  claude/           .claude/CLAUDE.md, .claude/settings.json
  gemini/           .gemini/settings.json
  codex/            .codex/config.toml
  scripts/          .local/bin/cert
```

## Theme

All tools share a single color palette defined in `theme/whaleen.sh`.

```bash
# Edit the master palette
$EDITOR theme/whaleen.sh

# Regenerate all tool configs
./theme/generate.sh

# Restow to apply
stow -t ~ --restow ghostty warp yazi btop lsd cursor zsh sketchybar
```

Generated configs: Ghostty, Warp, Yazi, btop, lsd, fzf, Cursor, Sketchybar.

## Window Management

yabai + skhd with partial SIP disabled for instant space switching.

- `ctrl + 1-9` — switch spaces instantly (no animation) via `yabai -m space --focus`
- yabai scripting addition loaded via sudoers entry at `/private/etc/sudoers.d/yabai`

After a fresh install, set up the sudoers entry:

```bash
echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d ' ' -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
```

## Adding a new config

1. Create a directory for the package.
2. Inside it, recreate the path from `$HOME` to the config file.
3. Add the package name to `STOW_PACKAGES` in `install.sh`.
4. Run `stow -t ~ <package>`.

## Scripts

- `install.sh` — Full bootstrap (Homebrew, nvm, Rust, Solana, stow, macOS defaults)
- `theme/generate.sh` — Regenerate all tool themes from `theme/whaleen.sh`

## Package Inventories

- `Brewfile` — Homebrew packages (taps, formulae, casks, vscode extensions, cargo crates)
- `npm-global.txt` — npm global packages
- `cargo-global.txt` — Cargo crates
