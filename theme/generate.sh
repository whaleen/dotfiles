#!/bin/bash
set -e

THEME_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES="$(dirname "$THEME_DIR")"

info() { printf "\033[1;34m==> %s\033[0m\n" "$1"; }
ok()   { printf "\033[1;32m  ✓ %s\033[0m\n" "$1"; }

# Source the palette
source "$THEME_DIR/vesper.sh"

# Collect all variables for substitution
VARS=(
  THEME_NAME BG FG ACCENT
  SURFACE0 SURFACE1 SURFACE2 SURFACE3 SURFACE4
  DIM SUBTLE COMMENT
  BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE
  BRIGHT_BLACK BRIGHT_RED BRIGHT_GREEN BRIGHT_YELLOW
  BRIGHT_BLUE BRIGHT_MAGENTA BRIGHT_CYAN BRIGHT_WHITE
)

# Build a sed command that replaces all {{VAR}} placeholders
SED_ARGS=()
for var in "${VARS[@]}"; do
  SED_ARGS+=(-e "s|{{${var}}}|${!var}|g")
done

stamp() {
  local template="$1"
  local output="$2"
  sed "${SED_ARGS[@]}" "$template" > "$output"
}

info "Generating $THEME_NAME theme"

# Ghostty
stamp "$THEME_DIR/templates/ghostty.conf" "$DOTFILES/ghostty/.config/ghostty/config"
ok "ghostty"

# Warp
stamp "$THEME_DIR/templates/warp.yaml" "$DOTFILES/warp/.warp/themes/Vesper.yaml"
ok "warp"

# Yazi
stamp "$THEME_DIR/templates/yazi.toml" "$DOTFILES/yazi/.config/yazi/theme.toml"
ok "yazi"

# btop
mkdir -p "$DOTFILES/btop/.config/btop/themes"
stamp "$THEME_DIR/templates/btop.theme" "$DOTFILES/btop/.config/btop/themes/vesper.theme"
ok "btop"

# fzf (generates a sourceable shell snippet)
stamp "$THEME_DIR/templates/fzf.sh" "$DOTFILES/zsh/.config/vesper-fzf.sh"
ok "fzf"

# lsd
mkdir -p "$DOTFILES/lsd/.config/lsd"
stamp "$THEME_DIR/templates/lsd.yaml" "$DOTFILES/lsd/.config/lsd/colors.yaml"
ok "lsd"

# Cursor (VS Code color theme extension)
CURSOR_EXT="$DOTFILES/cursor/.cursor/extensions/vesper-custom/themes"
mkdir -p "$CURSOR_EXT"
stamp "$THEME_DIR/templates/cursor-theme.json" "$CURSOR_EXT/vesper-custom-color-theme.json"

# Extension manifest
cat > "$DOTFILES/cursor/.cursor/extensions/vesper-custom/package.json" << 'MANIFEST'
{
  "name": "vesper-custom",
  "displayName": "Vesper Custom",
  "version": "1.0.0",
  "engines": { "vscode": "^1.60.0" },
  "categories": ["Themes"],
  "contributes": {
    "themes": [
      {
        "label": "Vesper Custom",
        "uiTheme": "vs-dark",
        "path": "./themes/vesper-custom-color-theme.json"
      }
    ]
  }
}
MANIFEST
ok "cursor"

info "Done — restow any changed packages to apply"
