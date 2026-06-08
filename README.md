# AltTab Unchained

[![AltTab screenshot](docs/public/demo/frontpage.jpg)](docs/public/demo/frontpage.jpg)

This repository is a fork of [lwouis/alt-tab-macos](https://github.com/lwouis/alt-tab-macos), cloned from the upstream `v10.12.0` source and modified for a local, privacy-preserving build.

AltTab brings Windows-style alt-tab window switching to macOS. This fork keeps the core switching behavior while removing network-facing update, crash-reporting, feedback, support, and paid/support-related surfaces from the app build.

## What changed

- Removed Sparkle from CocoaPods and disabled the Sparkle update feed/settings. This build does not check for, download, or install updates.
- Removed AppCenter crash reporting from CocoaPods and replaced the crash-reporting hook with a local stub.
- Disabled the in-app feedback submission path and removed feedback/support/update entries from the menu and settings UI.
- Removed external support/project links from the About/settings surfaces.
- Defaulted update checks, crash reporting, and start-at-login to off.
- Kept Screen Recording and Accessibility support available so thumbnails and window switching can work after macOS grants permissions to the locally signed app.

## Paid/support surfaces

This fork removes paid/support-related app surfaces from the local build. In this `v10.12.0` source tree, no active Lemon Squeezy or license-validation client was found in the app code; payment-related material appears in website/docs content rather than the built app path changed here.

The intent is not to impersonate the upstream project or its official binaries. This is a GPL-licensed fork for local builds under a different repository/name.

## Network behavior

The modified app build should not contact upstream update, crash-reporting, or feedback endpoints. Window thumbnails still require macOS Screen Recording permission, but that is local OS capture permission rather than telemetry.

## Building

Install CocoaPods dependencies, then build the workspace:

```sh
pod install
xcodebuild -workspace alt-tab-macos.xcworkspace -scheme Debug -configuration Debug build
```

For stable macOS privacy permissions, sign the resulting app with a stable local Apple Development or Developer ID certificate before installing it. TCC permissions such as Accessibility and Screen Recording are tied to the app's code-signing identity, not just its bundle identifier.

## License

Upstream AltTab is published under the GNU General Public License v3.0. This fork keeps that license; see [LICENSE](LICENSE).
