#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

info() { printf "\033[1;34m==> %s\033[0m\n" "$1"; }
ok()   { printf "\033[1;32m  ✓ %s → %s\033[0m\n" "$1" "$2"; }

backup_and_link() {
  local src="$1"
  local dest="$2"

  if [ ! -e "$src" ] && [ ! -d "$src" ]; then
    echo "  ⚠ Source not found: $src (skipping)"
    return
  fi

  # Create parent directory if needed
  mkdir -p "$(dirname "$dest")"

  # Back up existing file/dir (skip if it's already our symlink)
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$dest" "$BACKUP_DIR/"
    echo "  ↪ Backed up $(basename "$dest") → $BACKUP_DIR/"
  elif [ -L "$dest" ]; then
    rm "$dest"
  fi

  ln -sf "$src" "$dest"
  ok "$src" "$dest"
}

backup_and_link_contents() {
  local src_dir="$1"
  local dest_dir="$2"
  shift 2
  local files=("$@")

  mkdir -p "$dest_dir"
  for f in "${files[@]}"; do
    backup_and_link "$src_dir/$f" "$dest_dir/$f"
  done
}

info "Linking dotfiles"

# Shell configs
backup_and_link "$DOTFILES/.zshrc"        "$HOME/.zshrc"
backup_and_link "$DOTFILES/.gitconfig"    "$HOME/.gitconfig"
backup_and_link "$DOTFILES/.bash_profile" "$HOME/.bash_profile"
backup_and_link "$DOTFILES/.profile"      "$HOME/.profile"

# Ghostty (uses ~/Library/Application Support, not ~/.config)
backup_and_link "$DOTFILES/.config/ghostty" "$HOME/Library/Application Support/com.mitchellh.ghostty"

# Cursor
backup_and_link "$DOTFILES/.config/cursor/settings.json" "$HOME/Library/Application Support/Cursor/User/settings.json"

# GitHub CLI
backup_and_link "$DOTFILES/.config/gh/config.yml" "$HOME/.config/gh/config.yml"

# Global gitignore
backup_and_link "$DOTFILES/.config/git/ignore" "$HOME/.config/git/ignore"

# Broot
backup_and_link_contents "$DOTFILES/.config/broot" "$HOME/.config/broot" \
  "conf.hjson" "verbs.hjson"

# YouTube TUI
backup_and_link "$DOTFILES/.config/youtube-tui" "$HOME/.config/youtube-tui"

# Claude Code
backup_and_link "$DOTFILES/.claude/CLAUDE.md"     "$HOME/.claude/CLAUDE.md"
backup_and_link "$DOTFILES/.claude/settings.json"  "$HOME/.claude/settings.json"
backup_and_link "$DOTFILES/.claude.json"           "$HOME/.claude.json"

# Gemini CLI
backup_and_link_contents "$DOTFILES/.gemini" "$HOME/.gemini" \
  "settings.json" "projects.json" "trustedFolders.json"

# Codex
backup_and_link_contents "$DOTFILES/.codex" "$HOME/.codex" \
  "config.toml"
backup_and_link "$DOTFILES/.codex/rules/default.rules" "$HOME/.codex/rules/default.rules"

# OpenCode
backup_and_link "$DOTFILES/.config/opencode/package.json" "$HOME/.config/opencode/package.json"
backup_and_link "$DOTFILES/.config/opencode/opencode.json" "$HOME/.config/opencode/opencode.json"

if [ -d "$BACKUP_DIR" ]; then
  info "Backups saved to $BACKUP_DIR"
else
  info "No existing files needed backup"
fi

info "Symlinks done"
