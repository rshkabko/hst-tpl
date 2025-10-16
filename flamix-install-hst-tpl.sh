#!/usr/bin/env bash
set -euo pipefail

ZIP_URL="https://github.com/rshkabko/hst-tpl/archive/refs/heads/main.zip"
MODE="soft"  # soft | replace

# Parse args
if [[ "${1:-}" == "--replace" ]]; then
  MODE="replace"
elif [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  echo "Usage: $0 [--replace]"
  echo "  (no flag)  soft copy (no deletions)"
  echo "  --replace  mirror with deletions (per top-level dir)"
  exit 0
fi

TMPDIR="$(mktemp -d)"
ZIPFILE="$TMPDIR/src.zip"
trap 'rm -rf "$TMPDIR"' EXIT

echo "Downloading archive..."
curl -fsSL -L "$ZIP_URL" -o "$ZIPFILE"

echo "Extracting to tmp..."
unzip -oq "$ZIPFILE" -d "$TMPDIR"
ROOT="$(find "$TMPDIR" -mindepth 1 -maxdepth 1 -type d | head -n1)"

echo "Cleaning up unnecessary files..."
find "$ROOT" -type f \( -name ".gitignore" -o -name "flamix-install-hst-tpl.sh" -o -name "README.md" -o -name ".DS_Store" \) -print -delete

echo "Copying to root ($MODE)..."
if [[ "$MODE" == "soft" ]]; then
  rsync -a "$ROOT/" /
else
  # Safer per top-level tree mirror with --delete
  shopt -s nullglob dotglob
  for top in "$ROOT"/*; do
    base="/$(basename "$top")"
    if [[ -d "$top" ]]; then
      rsync -a --delete "$top"/ "$base"/
    else
      rsync -a --delete "$top" "$base"
    fi
  done
  shopt -u nullglob dotglob
fi

echo "Deleting temporary files..."
rm -f "$ZIPFILE"
rm -rf "$TMPDIR"

echo "Done."
