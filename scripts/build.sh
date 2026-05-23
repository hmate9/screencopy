#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIGURATION="${1:-release}"
PRODUCT_NAME="ScreenCopy"
APP_DIR="$ROOT_DIR/build/$PRODUCT_NAME.app"
INFO_PLIST="$ROOT_DIR/Packaging/Info.plist"

case "$CONFIGURATION" in
  debug|release) ;;
  *)
    echo "Usage: $0 [debug|release]" >&2
    exit 64
    ;;
esac

swift build -c "$CONFIGURATION" --product "$PRODUCT_NAME"

EXECUTABLE_PATH="$ROOT_DIR/.build/$CONFIGURATION/$PRODUCT_NAME"

rm -rf "$APP_DIR"
mkdir -p "$APP_DIR/Contents/MacOS" "$APP_DIR/Contents/Resources"
cp "$EXECUTABLE_PATH" "$APP_DIR/Contents/MacOS/$PRODUCT_NAME"
cp "$INFO_PLIST" "$APP_DIR/Contents/Info.plist"
chmod +x "$APP_DIR/Contents/MacOS/$PRODUCT_NAME"

/usr/bin/plutil -lint "$APP_DIR/Contents/Info.plist" >/dev/null

echo "$APP_DIR"
