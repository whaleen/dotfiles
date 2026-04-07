#!/bin/bash
# theme-switch — regenerate all non-Ghostty tools for a given palette.
# Called manually or by the LaunchAgent watching GlobalPreferences.plist.
#
# Usage: theme-switch [dark|light|auto]
#   auto (default) — reads macOS appearance, skips if mode hasn't changed

set -e

THEME_DIR="$(cd "$(dirname "$0")" && pwd)"
STATE_FILE="$HOME/.local/state/whaleen-theme"

# ── Resolve palette ───────────────────────────────────────────────────────────
REQUESTED="${1:-auto}"

if [[ "$REQUESTED" == "auto" ]]; then
  MODE=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")
  [[ "$MODE" == "Dark" ]] && PALETTE="dark" || PALETTE="light"
else
  PALETTE="$REQUESTED"
fi

case "$PALETTE" in
  dark|light) ;;
  *) echo "Usage: theme-switch [dark|light|auto]" >&2; exit 1 ;;
esac

# ── Skip if mode hasn't changed (LaunchAgent fires on any GlobalPrefs write) ──
mkdir -p "$(dirname "$STATE_FILE")"
LAST=$(cat "$STATE_FILE" 2>/dev/null || echo "")
if [[ "$REQUESTED" == "auto" && "$PALETTE" == "$LAST" ]]; then
  exit 0
fi

# ── Regenerate ────────────────────────────────────────────────────────────────
echo "$(date '+%H:%M:%S') switching to $PALETTE"
"$THEME_DIR/generate.sh" --palette="$PALETTE"
echo "$PALETTE" > "$STATE_FILE"

# ── Reload live processes ─────────────────────────────────────────────────────
if pgrep -x sketchybar &>/dev/null; then
  sketchybar --reload
fi
