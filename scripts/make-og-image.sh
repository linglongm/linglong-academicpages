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
SUBTITLE="CS Ph.D. student at the University of Delaware"
TAGLINE="Programming languages · Formal verification"   # leave "" to hide
PILLS=("Publications" "Humanities")                    # match the site menu
DOMAIN="linglongmeng.com"
PHOTO="images/linglong-profile.jpeg"   # shown bottom-right; leave "" to hide

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
  -font "$REGULAR" -pointsize 44 -fill "$GREY" -annotate +70+215 "$SUBTITLE"
)
if [[ -n "$TAGLINE" ]]; then
  args+=(-font "$REGULAR" -pointsize 34 -fill "$GREY" -annotate +70+275 "$TAGLINE")
fi
# Divider stops short of the photo when there is one.
RULE_END=1130; [[ -n "$PHOTO" ]] && RULE_END=790
args+=(-stroke "$RULE" -strokewidth 2 -draw "line 70,330 $RULE_END,330" -stroke none)

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

# Photo: 280x280 with rounded corners and a thin border, bottom-right.
if [[ -n "$PHOTO" ]]; then
  S=280; R=28; PX=850; PY=300
  args+=(
    \( "$REPO_ROOT/$PHOTO" -resize "${S}x${S}^" -gravity center -extent "${S}x${S}"
       \( -size "${S}x${S}" xc:none -fill white -draw "roundrectangle 0,0 $((S-1)),$((S-1)) $R,$R" \)
       -alpha set -compose DstIn -composite \)
    -gravity NorthWest -geometry "+$PX+$PY" -compose Over -composite
    -fill none -stroke "$RULE" -strokewidth 2
    -draw "roundrectangle $PX,$PY $((PX+S-1)),$((PY+S-1)) $R,$R" -stroke none
  )
fi

magick "${args[@]}" -depth 8 "$OUT"
echo "wrote $OUT"
