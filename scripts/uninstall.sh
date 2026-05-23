#!/usr/bin/env bash
set -euo pipefail

PRODUCT_NAME="ScreenCopy"
LABEL="com.mate.screencopy"
INSTALL_DIR="${SCREENCOPY_INSTALL_DIR:-$HOME/Applications}"
APP_PATH="$INSTALL_DIR/$PRODUCT_NAME.app"
PLIST_PATH="$HOME/Library/LaunchAgents/$LABEL.plist"
SERVICE_DOMAIN="gui/$(id -u)"

/bin/launchctl bootout "$SERVICE_DOMAIN" "$PLIST_PATH" >/dev/null 2>&1 || true
rm -f "$PLIST_PATH"
rm -rf "$APP_PATH"

echo "Removed $APP_PATH"
echo "Removed $PLIST_PATH"
