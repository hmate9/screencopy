# ScreenCopy

ScreenCopy is a small native macOS menu bar app for copying a selected screen region to the clipboard.

Click the menu bar icon, drag a rectangle with macOS's native screenshot picker, then paste the image anywhere that accepts clipboard images.

## Features

- Native menu bar utility built with Swift and AppKit.
- One-click region capture to clipboard.
- Uses macOS `screencapture -i -c` for the selection UI and clipboard write.
- Optional per-user login startup through a LaunchAgent.
- No telemetry, networking, cloud sync, screenshot history, or background uploads.

## Requirements

- macOS 13 or newer.
- Xcode command line tools with Swift available.
- Screen Recording permission when macOS prompts for it.

Install command line tools if needed:

```sh
xcode-select --install
```

## Quick Start

Build the app bundle:

```sh
./scripts/build.sh
```

Run it without installing:

```sh
open build/ScreenCopy.app
```

Install it for the current user and start it at login:

```sh
./scripts/install.sh
```

Uninstall the login item and app bundle:

```sh
./scripts/uninstall.sh
```

## Usage

- Left-click the ScreenCopy menu bar icon to start area capture.
- Drag the region to copy.
- Paste into Preview, Notes, Messages, Slack, or another image-capable app.
- Right-click the icon for `Capture Area`, `Screen Recording Settings`, and `Quit ScreenCopy`.

If capture does not start or the clipboard is empty, open `Screen Recording Settings` from the menu and allow ScreenCopy. macOS may require quitting and reopening the app after changing that permission.

## How It Works

ScreenCopy is an AppKit `LSUIElement` app, so it appears only in the menu bar and not in the Dock. The app launches `/usr/sbin/screencapture -i -c` when capture starts:

- `-i` opens macOS's interactive selection picker.
- `-c` writes the selected image directly to the clipboard.

The installer copies `ScreenCopy.app` to `~/Applications` and registers `~/Library/LaunchAgents/com.mate.screencopy.plist` with `RunAtLoad` so launchd starts it when the user logs in.

## Privacy

ScreenCopy does not save screenshots to disk. Captured images go to the macOS clipboard through the system screenshot tool. The app does not send data over the network.

macOS controls Screen Recording permission. You can review or remove that permission in System Settings.

## Project Structure

- `Package.swift` defines the Swift package, executable target, shared core target, and tests.
- `Sources/ScreenCopy` contains the AppKit menu bar app.
- `Sources/ScreenCopyCore` contains testable command configuration.
- `Tests/ScreenCopyCoreTests` verifies the native screenshot command arguments.
- `Packaging/Info.plist` is copied into the generated `.app` bundle.
- `scripts/build.sh` compiles the Swift executable and assembles `build/ScreenCopy.app`.
- `scripts/install.sh` copies the app to `~/Applications` and installs `~/Library/LaunchAgents/com.mate.screencopy.plist`.
- `scripts/uninstall.sh` removes the per-user LaunchAgent and installed app.
- `.github/workflows/ci.yml` runs tests, builds the app bundle, and validates scripts and plists on pull requests.
- `.github/ISSUE_TEMPLATE`, `.github/PULL_REQUEST_TEMPLATE.md`, and `.github/dependabot.yml` provide public repository maintenance defaults.

## Verification

Run the automated checks:

```sh
swift test
./scripts/build.sh
bash -n scripts/*.sh
plutil -lint Packaging/Info.plist build/ScreenCopy.app/Contents/Info.plist
```

Manual check:

1. Run `./scripts/install.sh`.
2. Click the menu bar icon.
3. Select a screen region.
4. Paste into Preview, Notes, Messages, Slack, or another image-capable app.
5. Log out and back in, then confirm the menu bar icon appears again.

## Contributing

See `CONTRIBUTING.md`.

## Security

See `SECURITY.md`.

## License

ScreenCopy is available under the MIT License. See `LICENSE`.
