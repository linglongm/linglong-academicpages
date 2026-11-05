#!/usr/bin/env bash
# Generates images/og-image.png, the 1200x630 card shown when someone shares
# a link to the site (iMessage, Slack, LinkedIn, ...). It is used by
# _includes/seo.html via `og_image` in _config.yml.
#
# Layout: name, area and a one-line intro on the left, photo on the right.
#
# Usage (from anywhere):   bash scripts/make-og-image.sh
# Requires: ImageMagick 7 (`magick`) and the DejaVu Sans fonts.
#
# To change the card, edit the settings below and run the script again.
set -euo pipefail

# ---- Content -------------------------------------------------------------
NAME="Linglong Meng"
AREA="Programming languages · Formal verification"
INTRO="CS Ph.D. student at the University of Delaware"   # wraps if too long
PHOTO="images/linglong-dragon.jpg"

# ---- Colours -------------------------------------------------------------
ACCENT="#2f6bd1"      # top strip, area
DARK="#333333"        # name
GREY="#6f6f6f"        # intro
BORDER="#e3e3e3"      # photo outline

# ---- Fonts ---------------------------------------------------------------
FONT_DIR="${FONT_DIR:-/usr/share/fonts/truetype/dejavu}"
BOLD="$FONT_DIR/DejaVuSans-Bold.ttf"
REGULAR="$FONT_DIR/DejaVuSans.ttf"

# ---- Geometry ------------------------------------------------------------
W=1200; H=630; STRIP=12; MARGIN=70
S=360; R=36           # photo size and corner radius
GAP=60                # space between text and photo
TEXT_W=$(( W - 2*MARGIN - S - GAP ))

# --------------------------------------------------------------------------
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$REPO_ROOT/images/og-image.png"

# Vertical centre of the area below the strip, as a gravity offset.
CY=$(( STRIP / 2 ))

magick -size "${W}x${H}" xc:white \
  -fill "$ACCENT" -draw "rectangle 0,0 $W,$((STRIP - 1))" \
  \( -background none \
     \( +size -font "$BOLD" -pointsize 76 -fill "$DARK" label:"$NAME" \) \
     \( -size 1x22 xc:none \) \
     \( -size "${TEXT_W}x" -font "$REGULAR" -pointsize 28 -fill "$ACCENT" caption:"$AREA" \) \
     \( -size 1x30 xc:none \) \
     \( -size "${TEXT_W}x" -font "$REGULAR" -pointsize 40 -fill "$GREY" caption:"$INTRO" \) \
     +size -gravity West -append -trim +repage \) \
  -gravity West -geometry "+$MARGIN+$CY" -compose Over -composite \
  \( "$REPO_ROOT/$PHOTO" -resize "${S}x${S}^" -gravity center -extent "${S}x${S}" \
     \( -size "${S}x${S}" xc:none -fill white -draw "roundrectangle 0,0 $((S-1)),$((S-1)) $R,$R" \) \
     -alpha set -compose DstIn -composite -compose Over \
     -fill none -stroke "$BORDER" -strokewidth 3 \
     -draw "roundrectangle 1,1 $((S-2)),$((S-2)) $R,$R" \) \
  -gravity East -geometry "+$MARGIN+$CY" -composite \
  -depth 8 "$OUT"
echo "wrote $OUT"
