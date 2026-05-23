# Contributing

Thanks for taking the time to improve ScreenCopy.

## Local Setup

Requirements:

- macOS 13 or newer.
- Xcode command line tools.

Run the core checks before opening a pull request:

```sh
swift test
./scripts/build.sh
bash -n scripts/*.sh
plutil -lint Packaging/Info.plist
```

For UI changes, also run the app and verify the manual capture flow:

```sh
open build/ScreenCopy.app
```

Then click the menu bar icon, select a region, and paste into an image-capable app.

## Development Guidelines

- Keep the app focused on fast region capture to the clipboard.
- Prefer native macOS APIs and tools over new dependencies.
- Avoid adding telemetry, networking, screenshot storage, or cloud behavior.
- Keep scripts idempotent and safe to rerun.
- Update `README.md` when commands, permissions, project structure, or user-visible behavior changes.
- Add or update tests for logic that can be verified without interactive macOS UI.

## Pull Requests

Include:

- What changed.
- Why it changed.
- The verification commands you ran.
- Any manual UI checks you could not perform.
