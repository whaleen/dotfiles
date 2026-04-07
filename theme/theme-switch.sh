#!/bin/bash
# theme-switch — regenerate all non-Ghostty tools for a given palette
# Usage: theme-switch [dark|light|auto]
#
# Ghostty switches automatically via macOS appearance — no action needed.
# This script handles: yazi, btop, fzf, lsd, lazygit, sketchybar, warp, cursor, pemguin.

set -e

THEME_DIR="$(cd "$(dirname "$0")" && pwd)"

PALETTE="${1:-auto}"
if [[ "$PALETTE" == "auto" ]]; then
  MODE=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")
  [[ "$MODE" == "Dark" ]] && PALETTE="dark" || PALETTE="light"
fi

case "$PALETTE" in
  dark|light) ;;
  *) echo "Usage: theme-switch [dark|light|auto]" >&2; exit 1 ;;
esac

echo "Switching to $PALETTE palette..."
"$THEME_DIR/generate.sh" --palette="$PALETTE"

# Reload running apps
if pgrep -x sketchybar &>/dev/null; then
  sketchybar --reload
  echo "  ✓ sketchybar reloaded"
fi

if pgrep -x yazi &>/dev/null; then
  echo "  ↻ yazi: restart any open instances to pick up new theme"
fi

echo "Done. Restart btop, lazygit, and any fzf sessions to see changes."
