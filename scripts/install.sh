#!/usr/bin/env bash
# Builds DailyMate (release) and installs it as /Applications/DailyMate.app.
# Re-run it to update. Your data is not inside the app bundle — it lives in
# ~/Library/Containers/com.dailymate.dailyMate — so replacing the app keeps it.
#
#   scripts/install.sh               build, then install
#   scripts/install.sh --skip-build  install the last release build
#   scripts/install.sh --open        ... and launch it afterwards
set -euo pipefail
cd "$(dirname "$0")/.."

APP="DailyMate.app"
BUILT="build/macos/Build/Products/Release/$APP"
DEST="/Applications/$APP"
skip_build=false
open_after=false
for arg in "$@"; do
  case "$arg" in
    --skip-build) skip_build=true ;;
    --open) open_after=true ;;
    *) echo "Unknown option: $arg" >&2; exit 2 ;;
  esac
done

if ! $skip_build; then
  flutter build macos --release
fi
if [[ ! -d "$BUILT" ]]; then
  echo "No release build at $BUILT — run without --skip-build." >&2
  exit 1
fi

if pgrep -x DailyMate >/dev/null; then
  echo "Quitting the running DailyMate…"
  osascript -e 'quit app "DailyMate"' >/dev/null 2>&1 || true
  for _ in $(seq 1 20); do
    pgrep -x DailyMate >/dev/null || break
    sleep 0.5
  done
  if pgrep -x DailyMate >/dev/null; then
    echo "DailyMate is still running. Quit it (⌘Q) and run this again." >&2
    exit 1
  fi
fi

# Replace only the app bundle; never touch the data container.
if [[ -d "$DEST" ]]; then
  rm -rf "$DEST"
fi
ditto "$BUILT" "$DEST"
# ditto keeps the build's dates, and macOS keys its icon cache on the bundle's
# date: without this, Finder and the Dock keep showing the previous icon.
touch "$DEST"
echo "Installed $DEST ($(defaults read "$DEST/Contents/Info" CFBundleShortVersionString))"

if $open_after; then
  open "$DEST"
fi
