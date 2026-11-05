#!/usr/bin/env bash
# Generates images/og-image.png, the 1200x630 card shown when someone shares
# a link to the site (iMessage, Slack, LinkedIn, ...). It is used by
# _includes/seo.html via `og_image` in _config.yml.
#
# Usage (from anywhere):   bash scripts/make-og-image.sh
# Requires: ImageMagick 7 (`magick`) and the DejaVu Sans fonts.
#
# To change the card, edit the settings below and run the script again.
set -euo pipefail

# ---- Text ----------------------------------------------------------------
TITLE="Linglong Meng"
SUBTITLE="CIS Ph.D. student at the University of Delaware"
TAGLINE="Programming languages · Formal verification"   # leave "" to hide
PILLS=("Publications" "Humanities")                    # match the site menu
DOMAIN="linglongmeng.com"

# ---- Colours -------------------------------------------------------------
ACCENT="#2f6bd1"      # top strip
DARK="#333333"        # title, domain chip
GREY="#6f6f6f"        # subtitle, tagline
PILL_BG="#eaeefa"
PILL_TEXT="#3366cc"
RULE="#e3e3e3"        # divider line

# ---- Fonts ---------------------------------------------------------------
FONT_DIR="${FONT_DIR:-/usr/share/fonts/truetype/dejavu}"
BOLD="$FONT_DIR/DejaVuSans-Bold.ttf"
REGULAR="$FONT_DIR/DejaVuSans.ttf"

# --------------------------------------------------------------------------
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$REPO_ROOT/images/og-image.png"

# Width in pixels of a piece of text, so pills fit their labels.
text_width() { magick -font "$1" -pointsize "$2" label:"$3" -format %w info:; }

args=(
  -size 1200x630 xc:white
  -fill "$ACCENT" -draw "rectangle 0,0 1200,12"
  -font "$BOLD"    -pointsize 76 -fill "$DARK" -annotate +70+130 "$TITLE"
  -font "$REGULAR" -pointsize 36 -fill "$GREY" -annotate +70+210 "$SUBTITLE"
)
if [[ -n "$TAGLINE" ]]; then
  args+=(-font "$REGULAR" -pointsize 30 -fill "$GREY" -annotate +70+262 "$TAGLINE")
fi
args+=(-stroke "$RULE" -strokewidth 2 -draw "line 70,330 1130,330" -stroke none)

# Pills, laid out left to right with 24px of padding on each side.
x=70
for label in "${PILLS[@]}"; do
  w=$(( $(text_width "$BOLD" 28 "$label") + 48 ))
  args+=(-fill "$PILL_BG" -draw "roundrectangle $x,392 $((x + w)),452 30,30"
         -font "$BOLD" -pointsize 28 -fill "$PILL_TEXT" -annotate "+$((x + 24))+433" "$label")
  x=$(( x + w + 18 ))
done

# Domain chip, sized to the domain text.
w=$(( $(text_width "$BOLD" 28 "$DOMAIN") + 68 ))
args+=(-fill "$DARK" -draw "roundrectangle 70,510 $((70 + w)),560 25,25"
       -font "$BOLD" -pointsize 28 -fill white -annotate +104+546 "$DOMAIN")

magick "${args[@]}" -depth 8 "$OUT"
echo "wrote $OUT"
