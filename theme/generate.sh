#!/bin/bash
set -e

THEME_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES="$(dirname "$THEME_DIR")"

info() { printf "\033[1;34m==> %s\033[0m\n" "$1"; }
ok()   { printf "\033[1;32m  ✓ %s\033[0m\n" "$1"; }
die()  { printf "\033[1;31mError: %s\033[0m\n" "$1"; exit 1; }

# ── Parse arguments ───────────────────────────────────────────────────────────
PALETTE="dark"
for arg in "$@"; do
  case "$arg" in
    --palette=*) PALETTE="${arg#--palette=}" ;;
  esac
done

# ── Source palette ────────────────────────────────────────────────────────────
load_palette() {
  local name="$1"
  case "$name" in
    dark|light) source "$THEME_DIR/palettes/${name}.sh" ;;
    auto)
      local mode
      mode=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")
      [[ "$mode" == "Dark" ]] && load_palette dark || load_palette light
      ;;
    *) die "Unknown palette '$name'. Use: dark, light, auto, or all." ;;
  esac
}

# ── Derive secondary variables ────────────────────────────────────────────────
derive_vars() {
  sb()    { echo "0xFF${1#\#}"; }
  sb_40() { echo "0x40${1#\#}"; }
  BG_SB=$(sb "$BG");     BG_SB_40=$(sb_40 "$BG")
  FG_SB=$(sb "$FG");     ACCENT_SB=$(sb "$ACCENT"); ACCENT_SB_40=$(sb_40 "$ACCENT")

  lua_col() { echo "0xFF${1#\#}"; }
  BG_LUA=$(lua_col "$BG");       FG_LUA=$(lua_col "$FG")
  ACCENT_LUA=$(lua_col "$ACCENT")
  SURFACE0_LUA=$(lua_col "$SURFACE0"); SURFACE1_LUA=$(lua_col "$SURFACE1")
  SURFACE2_LUA=$(lua_col "$SURFACE2"); SURFACE3_LUA=$(lua_col "$SURFACE3")
  SURFACE4_LUA=$(lua_col "$SURFACE4")
  DIM_LUA=$(lua_col "$DIM");     SUBTLE_LUA=$(lua_col "$SUBTLE")
  ACCENT_LUA_40="0x66${ACCENT#\#}"; BG_LUA_F0="0xf0${BG#\#}"
}

# ── Build sed substitution args ───────────────────────────────────────────────
build_sed_args() {
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
    WARP_DETAILS
  )
  SED_ARGS=()
  for var in "${VARS[@]}"; do
    SED_ARGS+=(-e "s|{{${var}}}|${!var}|g")
  done
}

stamp() {
  local template="$1" output="$2"
  sed "${SED_ARGS[@]}" "$template" > "$output"
}

# ── Generate all outputs for a single palette ─────────────────────────────────
generate_one() {
  local palette_name="$1"
  load_palette "$palette_name"
  derive_vars
  build_sed_args

  local label="$THEME_NAME ($palette_name)"
  info "Generating $label"

  # Ghostty — write named theme file directly to live location (not stowed)
  local ghostty_themes="$HOME/.config/ghostty/themes"
  mkdir -p "$ghostty_themes"
  stamp "$THEME_DIR/templates/ghostty.conf" "$ghostty_themes/whaleen-${palette_name}"
  ok "ghostty (whaleen-${palette_name})"

  # Skip the rest for non-primary palette in "all" mode — other tools get the dark pass
  [[ "$palette_name" != "dark" && "$PALETTE" == "all" ]] && return

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

  # fzf
  stamp "$THEME_DIR/templates/fzf.sh" "$DOTFILES/zsh/.config/whaleen-fzf.sh"
  ok "fzf"

  # lsd
  mkdir -p "$DOTFILES/lsd/.config/lsd"
  stamp "$THEME_DIR/templates/lsd.yaml" "$DOTFILES/lsd/.config/lsd/colors.yaml"
  ok "lsd"

  # Cursor — generate both dark and light theme files
  local cursor_ext="$DOTFILES/cursor/.cursor/extensions/whaleen/themes"
  mkdir -p "$cursor_ext"
  stamp "$THEME_DIR/templates/cursor-theme.json" "$cursor_ext/whaleen-dark-color-theme.json"
  ok "cursor (dark)"

  # Pemguin
  stamp "$THEME_DIR/templates/pemguin.toml" "$DOTFILES/pemguin/.pemguin.toml"
  ok "pemguin"

  # Lazygit
  mkdir -p "$DOTFILES/lazygit/.config/lazygit"
  stamp "$THEME_DIR/templates/lazygit.yaml" "$DOTFILES/lazygit/.config/lazygit/config.yml"
  ok "lazygit"

  # Sketchybar
  stamp "$THEME_DIR/templates/sketchybar-colors.sh"  "$DOTFILES/sketchybar/.config/sketchybar/colors.sh"
  stamp "$THEME_DIR/templates/sketchybar-colors.lua" "$DOTFILES/sketchybar/.config/sketchybar/colors.lua"
  ok "sketchybar"
}

# ── Generate Cursor light theme (needs its own palette pass) ──────────────────
generate_cursor_light() {
  load_palette light
  derive_vars
  build_sed_args
  local cursor_ext="$DOTFILES/cursor/.cursor/extensions/whaleen/themes"
  stamp "$THEME_DIR/templates/cursor-theme.json" "$cursor_ext/whaleen-light-color-theme.json"
  ok "cursor (light)"
}

# ── Update Cursor extension manifest to register both themes ──────────────────
write_cursor_manifest() {
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
        "label": "Whaleen Dark",
        "uiTheme": "vs-dark",
        "path": "./themes/whaleen-dark-color-theme.json"
      },
      {
        "label": "Whaleen Light",
        "uiTheme": "vs",
        "path": "./themes/whaleen-light-color-theme.json"
      }
    ]
  }
}
MANIFEST
  ok "cursor (manifest)"
}

# ── Main ──────────────────────────────────────────────────────────────────────
case "$PALETTE" in
  all)
    generate_one dark
    generate_one light
    generate_cursor_light
    write_cursor_manifest
    ;;
  auto)
    local mode
    mode=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")
    [[ "$mode" == "Dark" ]] && generate_one dark || generate_one light
    generate_one dark   # always generate both ghostty themes
    generate_one light
    ;;
  dark|light)
    generate_one "$PALETTE"
    # Always generate both Ghostty themes so switching works without re-running
    if [[ "$PALETTE" == "dark" ]]; then
      load_palette light; derive_vars; build_sed_args
      stamp "$THEME_DIR/templates/ghostty.conf" \
            "$HOME/.config/ghostty/themes/whaleen-light"
      ok "ghostty (whaleen-light)"
    else
      load_palette dark; derive_vars; build_sed_args
      stamp "$THEME_DIR/templates/ghostty.conf" \
            "$HOME/.config/ghostty/themes/whaleen-dark"
      ok "ghostty (whaleen-dark)"
    fi
    generate_cursor_light
    write_cursor_manifest
    ;;
esac

info "Done. Ghostty switches automatically. Run 'theme-switch light|dark' for other tools."
