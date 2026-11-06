#!/usr/bin/env bash
# Generates the site's favicons (browser tab, bookmarks, phone home screen and
# the icon next to the site in Google results) from one square image.
# They are linked from _includes/head/custom.html and images/manifest.json.
#
# Usage (from anywhere):   bash scripts/make-favicons.sh
# Requires: ImageMagick 7 (`magick`).
#
# To change the icon, point SOURCE at another square image and run again.
set -euo pipefail

SOURCE="images/linglong-dragon.jpg"

# --------------------------------------------------------------------------
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$REPO_ROOT/$SOURCE"
IMG="$REPO_ROOT/images"

# Square-crop the source, then resize to SIZE and write OUT.
icon() { magick "$SRC" -resize "$1x$1^" -gravity center -extent "$1x$1" -strip "$2"; }

icon 32  "$IMG/favicon-32x32.png"
icon 192 "$IMG/favicon-192x192.png"          # Google wants a multiple of 48px
icon 512 "$IMG/favicon-512x512.png"          # manifest.json
icon 180 "$IMG/apple-touch-icon-180x180.png" # iOS home screen

magick "$SRC" -gravity center -extent "%[fx:min(w,h)]x%[fx:min(w,h)]" -strip \
  -define icon:auto-resize=48,32,16 "$IMG/favicon.ico"
# Some crawlers only ever ask for /favicon.ico.
cp "$IMG/favicon.ico" "$REPO_ROOT/favicon.ico"

echo "wrote favicons from $SOURCE"
