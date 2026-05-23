#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PRODUCT_NAME="ScreenCopy"
APP_NAME="$PRODUCT_NAME.app"
LABEL="com.mate.screencopy"
INSTALL_DIR="${SCREENCOPY_INSTALL_DIR:-$HOME/Applications}"
APP_PATH="$INSTALL_DIR/$APP_NAME"
APP_EXECUTABLE="$APP_PATH/Contents/MacOS/$PRODUCT_NAME"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
PLIST_PATH="$LAUNCH_AGENTS_DIR/$LABEL.plist"
LOG_DIR="$HOME/Library/Logs/ScreenCopy"
SERVICE_DOMAIN="gui/$(id -u)"

"$ROOT_DIR/scripts/build.sh" release >/dev/null

mkdir -p "$INSTALL_DIR" "$LAUNCH_AGENTS_DIR" "$LOG_DIR"
rm -rf "$APP_PATH"
cp -R "$ROOT_DIR/build/$APP_NAME" "$APP_PATH"

if [[ ! -x "$APP_EXECUTABLE" ]]; then
  echo "Installed app executable is missing: $APP_EXECUTABLE" >&2
  exit 1
fi

# LaunchAgents run after the user logs in, which is the earliest useful time
# for a GUI menu bar app that writes to that user's clipboard.
rm -f "$PLIST_PATH"
/usr/bin/plutil -create xml1 "$PLIST_PATH"
/usr/bin/plutil -insert Label -string "$LABEL" "$PLIST_PATH"
/usr/bin/plutil -insert ProgramArguments -array "$PLIST_PATH"
/usr/bin/plutil -insert ProgramArguments.0 -string "$APP_EXECUTABLE" "$PLIST_PATH"
/usr/bin/plutil -insert RunAtLoad -bool YES "$PLIST_PATH"
/usr/bin/plutil -insert KeepAlive -bool NO "$PLIST_PATH"
/usr/bin/plutil -insert LimitLoadToSessionType -string Aqua "$PLIST_PATH"
/usr/bin/plutil -insert StandardOutPath -string "$LOG_DIR/launchd.out.log" "$PLIST_PATH"
/usr/bin/plutil -insert StandardErrorPath -string "$LOG_DIR/launchd.err.log" "$PLIST_PATH"
/usr/bin/plutil -lint "$PLIST_PATH" >/dev/null

/bin/launchctl bootout "$SERVICE_DOMAIN" "$PLIST_PATH" >/dev/null 2>&1 || true
/bin/launchctl bootstrap "$SERVICE_DOMAIN" "$PLIST_PATH"
/bin/launchctl enable "$SERVICE_DOMAIN/$LABEL"
/bin/launchctl kickstart -k "$SERVICE_DOMAIN/$LABEL" >/dev/null 2>&1 || true

echo "Installed $APP_PATH"
echo "Configured login startup with $PLIST_PATH"
