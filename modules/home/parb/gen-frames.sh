#!/usr/bin/env nix-shell
#! nix-shell -i bash -p librsvg imagemagick chafa nixos-icons
# Regenerate frames.txt: the NixOS snowflake rotating through 60 degrees (its
# rotational symmetry, so the loop is seamless), rendered to ASCII with chafa.
# Frames are separated by a line containing only "---".
set -euo pipefail
cd "$(dirname "$0")"

N=12 W=40 H=20
SVG=$(nix-build '<nixpkgs>' -A nixos-icons --no-out-link)/share/icons/hicolor/scalable/apps/nix-snowflake.svg
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

rsvg-convert -w 400 -h 400 -b white "$SVG" -o "$TMP/base.png"
: >frames.txt
for ((i = 0; i < N; i++)); do
  magick "$TMP/base.png" -background white -distort SRT "$((i * 60 / N))" \
    -gravity center -extent 400x400 "$TMP/f.png"
  chafa --symbols ascii --size "${W}x${H}" --colors none --fg-only --invert --work 9 "$TMP/f.png" |
    sed 's/[[:space:]]*$//' >>frames.txt
  ((i < N - 1)) && echo '---' >>frames.txt
done
