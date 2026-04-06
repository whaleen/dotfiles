#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

info() { printf "\033[1;34m==> %s\033[0m\n" "$1"; }
ok()   { printf "\033[1;32m  ✓ %s\033[0m\n" "$1"; }
skip() { printf "\033[1;33m  – %s (already installed)\033[0m\n" "$1"; }

# ---------- 1. Xcode Command Line Tools ----------
info "Xcode Command Line Tools"
if xcode-select -p &>/dev/null; then
  skip "Xcode CLT"
else
  xcode-select --install
  echo "    Waiting for Xcode CLT install to finish..."
  until xcode-select -p &>/dev/null; do sleep 5; done
  ok "Xcode CLT"
fi

# ---------- 2. Homebrew ----------
info "Homebrew"
if command -v brew &>/dev/null; then
  skip "Homebrew"
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  ok "Homebrew"
fi

# ---------- 3. Brew bundle ----------
info "Brew bundle (Brewfile)"
brew bundle --file="$DOTFILES/Brewfile" --no-lock
ok "Brew bundle"

# ---------- 4. Oh My Zsh ----------
info "Oh My Zsh"
if [ -d "$HOME/.oh-my-zsh" ]; then
  skip "Oh My Zsh"
else
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ok "Oh My Zsh"
fi

# ---------- 5. nvm + Node ----------
info "nvm + Node"
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  skip "nvm"
else
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  ok "nvm"
fi
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
if nvm ls 22 &>/dev/null; then
  skip "Node 22"
else
  nvm install 22
  ok "Node 22"
fi

# ---------- 6. npm globals ----------
info "npm global packages"
while IFS= read -r pkg; do
  [[ -z "$pkg" || "$pkg" == npm || "$pkg" == corepack ]] && continue
  if npm ls -g "$pkg" &>/dev/null; then
    skip "$pkg"
  else
    npm install -g "$pkg"
    ok "$pkg"
  fi
done < "$DOTFILES/npm-global.txt"

# ---------- 7. Rust + cargo crates ----------
info "Rust (rustup)"
if command -v rustup &>/dev/null; then
  skip "rustup"
else
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  # shellcheck source=/dev/null
  source "$HOME/.cargo/env"
  ok "rustup"
fi
# cargo crates are handled by brew bundle (cargo section in Brewfile)
# but install any that aren't in the Brewfile from cargo-global.txt
info "Cargo crates"
while IFS= read -r crate; do
  [[ -z "$crate" ]] && continue
  if cargo install --list | grep -q "^${crate} "; then
    skip "$crate"
  else
    cargo install "$crate"
    ok "$crate"
  fi
done < "$DOTFILES/cargo-global.txt"

# ---------- 8. bun ----------
info "bun"
if command -v bun &>/dev/null; then
  skip "bun"
else
  curl -fsSL https://bun.sh/install | bash
  ok "bun"
fi

# ---------- 9. Solana CLI ----------
info "Solana CLI"
if command -v solana &>/dev/null; then
  skip "Solana CLI"
else
  sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
  export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
  ok "Solana CLI"
fi

# ---------- 10. avm + Anchor ----------
info "Anchor (via avm)"
if command -v avm &>/dev/null; then
  avm install latest
  avm use latest
  ok "Anchor (latest)"
else
  echo "    avm not found — install it via: cargo install --git https://github.com/coral-xyz/anchor avm"
fi

# ---------- 11. SbarLua (sketchybar Lua module) ----------
info "SbarLua"
if [ -f "$HOME/.local/share/sketchybar_lua/sketchybar.so" ]; then
  skip "SbarLua"
else
  (git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)
  ok "SbarLua"
fi

# ---------- 12. Stow dotfiles ----------
info "Stowing dotfiles"

STOW_PACKAGES=(
  zsh bash git npm
  ghostty cursor gh yabai skhd sketchybar btop yazi opencode lsd
  warp claude gemini codex cmux scripts
)

for pkg in "${STOW_PACKAGES[@]}"; do
  stow -t "$HOME" -d "$DOTFILES" --restow "$pkg"
  ok "$pkg"
done

# Cursor (macOS reads from ~/Library/Application Support, not ~/.config)
mkdir -p "$HOME/Library/Application Support/Cursor/User"
ln -sf "$DOTFILES/cursor/.config/cursor/settings.json" \
       "$HOME/Library/Application Support/Cursor/User/settings.json"
ok "cursor → Application Support"

# ---------- 13. yabai scripting addition sudoers ----------
info "yabai scripting addition (sudoers)"
YABAI_BIN="$(which yabai)"
YABAI_HASH="$(shasum -a 256 "$YABAI_BIN" | cut -d ' ' -f 1)"
echo "$(whoami) ALL=(root) NOPASSWD: sha256:${YABAI_HASH} ${YABAI_BIN} --load-sa" \
  | sudo tee /private/etc/sudoers.d/yabai > /dev/null
ok "yabai sudoers"

# ---------- 14. macOS defaults ----------
info "macOS defaults"
defaults write com.apple.dock tilesize -int 16
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock workspaces-swoosh-animation-off -bool true
killall Dock 2>/dev/null || true
ok "Dock preferences"

echo ""
info "Done! Open a new terminal to pick up all changes."
