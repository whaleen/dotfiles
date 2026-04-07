#!/bin/bash
# Whaleen — light palette
# Edit this file, then run ./theme/generate.sh --palette=light to propagate everywhere.

THEME_NAME="Whaleen"

# Core
BG="#F8F6FF"
FG="#1A1A2E"
ACCENT="#6A4DB8"

# Surfaces — get progressively darker (more contrast against light BG)
SURFACE0="#ECEAF6"
SURFACE1="#E2DFEF"
SURFACE2="#D5D1E8"
SURFACE3="#C8C4DF"
SURFACE4="#BBB6D5"

# Muted text — must all be dark enough to read on #F8F6FF
# In light mode: dimmer means DARKER toward the midpoint, not lighter
# SUBTLE=6.5:1, DIM=4.5:1, COMMENT=3.5:1 — intentional hierarchy
SUBTLE="#4A4A62"
DIM="#696980"
COMMENT="#88889E"

# Normal (ANSI 0–7) — saturated darker versions for light background legibility
BLACK="#1A1A2E"
RED="#AA3825"
GREEN="#246644"
YELLOW="#7A5010"
BLUE="#4A4098"
MAGENTA="#802870"
CYAN="#962848"
WHITE="#C8C4DC"

# Bright (ANSI 8–15) — more vivid, still legible on light bg
BRIGHT_BLACK="#696980"
BRIGHT_RED="#C04030"
BRIGHT_GREEN="#147848"
BRIGHT_YELLOW="#6848C0"
BRIGHT_BLUE="#6258A8"
BRIGHT_MAGENTA="#984088"
BRIGHT_CYAN="#B03060"
BRIGHT_WHITE="#1A1A2E"

# Tool-specific
WARP_DETAILS="lighter"
