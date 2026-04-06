#!/bin/bash
set -e

THEME_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES="$(dirname "$THEME_DIR")"

info() { printf "\033[1;34m==> %s\033[0m\n" "$1"; }
ok()   { printf "\033[1;32m  ✓ %s\033[0m\n" "$1"; }

# Source the palette
source "$THEME_DIR/whaleen.sh"

# Derive sketchybar shell variants (0xAARRGGBB string format)
sb()    { echo "0xFF${1#\#}"; }
sb_40() { echo "0x40${1#\#}"; }
BG_SB=$(sb "$BG")
BG_SB_40=$(sb_40 "$BG")
FG_SB=$(sb "$FG")
ACCENT_SB=$(sb "$ACCENT")
ACCENT_SB_40=$(sb_40 "$ACCENT")

# Derive Lua color variants (0xFFRRGGBB integer format — no quotes in output)
lua_col() { echo "0xFF${1#\#}"; }
BG_LUA=$(lua_col "$BG")
FG_LUA=$(lua_col "$FG")
ACCENT_LUA=$(lua_col "$ACCENT")
SURFACE0_LUA=$(lua_col "$SURFACE0")
SURFACE1_LUA=$(lua_col "$SURFACE1")
SURFACE2_LUA=$(lua_col "$SURFACE2")
SURFACE3_LUA=$(lua_col "$SURFACE3")
SURFACE4_LUA=$(lua_col "$SURFACE4")
DIM_LUA=$(lua_col "$DIM")
SUBTLE_LUA=$(lua_col "$SUBTLE")
ACCENT_LUA_40="0x66${ACCENT#\#}"
BG_LUA_F0="0xf0${BG#\#}"

# Collect all variables for substitution
VARS=(
  THEME_NAME BG FG ACCENT
  SURFACE0 SURFACE1 SURFACE2 SURFACE3 SURFACE4
  DIM SUBTLE COMMENT
  BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE
  BRIGHT_BLACK BRIGHT_RED BRIGHT_GREEN BRIGHT_YELLOW
  BRIGHT_BLUE BRIGHT_MAGENTA BRIGHT_CYAN BRIGHT_WHITE
  BG_SB BG_SB_40 FG_SB ACCENT_SB ACCENT_SB_40
  BG_LUA FG_LUA ACCENT_LUA ACCENT_LUA_40 BG_LUA_F0
  SURFACE0_LUA SURFACE1_LUA SURFACE2_LUA SURFACE3_LUA SURFACE4_LUA
  DIM_LUA SUBTLE_LUA
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
stamp "$THEME_DIR/templates/warp.yaml" "$DOTFILES/warp/.warp/themes/Whaleen.yaml"
ok "warp"

# Yazi
stamp "$THEME_DIR/templates/yazi.toml" "$DOTFILES/yazi/.config/yazi/theme.toml"
ok "yazi"

# btop
mkdir -p "$DOTFILES/btop/.config/btop/themes"
stamp "$THEME_DIR/templates/btop.theme" "$DOTFILES/btop/.config/btop/themes/whaleen.theme"
ok "btop"

# fzf (generates a sourceable shell snippet)
stamp "$THEME_DIR/templates/fzf.sh" "$DOTFILES/zsh/.config/whaleen-fzf.sh"
ok "fzf"

# lsd
mkdir -p "$DOTFILES/lsd/.config/lsd"
stamp "$THEME_DIR/templates/lsd.yaml" "$DOTFILES/lsd/.config/lsd/colors.yaml"
ok "lsd"

# Cursor (VS Code color theme extension)
CURSOR_EXT="$DOTFILES/cursor/.cursor/extensions/whaleen/themes"
mkdir -p "$CURSOR_EXT"
stamp "$THEME_DIR/templates/cursor-theme.json" "$CURSOR_EXT/whaleen-color-theme.json"

# Extension manifest
cat > "$DOTFILES/cursor/.cursor/extensions/whaleen/package.json" << 'MANIFEST'
{
  "name": "whaleen",
  "displayName": "Whaleen",
  "version": "1.0.0",
  "engines": { "vscode": "^1.60.0" },
  "categories": ["Themes"],
  "contributes": {
    "themes": [
      {
        "label": "Whaleen",
        "uiTheme": "vs-dark",
        "path": "./themes/whaleen-color-theme.json"
      }
    ]
  }
}
MANIFEST
ok "cursor"

# Sketchybar — generate only the colors files, Lua config is static
stamp "$THEME_DIR/templates/sketchybar-colors.sh" "$DOTFILES/sketchybar/.config/sketchybar/colors.sh"
stamp "$THEME_DIR/templates/sketchybar-colors.lua" "$DOTFILES/sketchybar/.config/sketchybar/colors.lua"
ok "sketchybar"

info "Done — restow any changed packages to apply"
