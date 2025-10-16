#!/usr/bin/env bash
set -euo pipefail

ZIP_URL="https://github.com/rshkabko/hst-tpl/archive/refs/heads/main.zip"
TMPDIR="$(mktemp -d)"
MODE="soft"

if [[ "${1:-}" == "--replace" ]]; then
  MODE="replace"
fi

echo "Downloading archive..."
curl -fsSL -L "$ZIP_URL" -o "$TMPDIR/src.zip"

echo "Extracting to tmp..."
unzip -oq "$TMPDIR/src.zip" -d "$TMPDIR"
ROOT="$(find "$TMPDIR" -mindepth 1 -maxdepth 1 -type d | head -n1)"

echo "Cleaning up unnecessary files..."
find "$ROOT" -type f \( \
  -name ".gitignore" -o \
  -name "flamix-install-hst-tpl.sh" -o \
  -name "README.md" -o \
  -name ".DS_Store" \
\) -print -delete

if [[ "$MODE" == "soft" ]]; then
  echo "Copying to root (soft overwrite)..."
  rsync -a "$ROOT/" /
else
  echo "Copying to root (force replace)..."
  rsync -a --inplace "$ROOT/" /
fi

echo "Cleaning temporary files..."
rm -rf "$TMPDIR"

echo "Done."
