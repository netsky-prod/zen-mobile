# Zen Security Mobile

Privacy protection client for Android and iOS using sing-box.

## Features

- VLESS protocol support with WebSocket transport
- TUN mode (routes all traffic through VPN)
- Casa de Papel inspired design
- Auto-download sing-box engine
- Traffic statistics

## Building

### Prerequisites

- Flutter 3.24+
- Android SDK (for Android builds)
- Xcode (for iOS builds, macOS only)

### Local Build

```bash
# Get dependencies
flutter pub get

# Build Android APK
flutter build apk --release

# Build iOS (unsigned)
flutter build ios --release --no-codesign
```

### GitHub Actions Build

Push a tag starting with `v` to trigger automatic builds:

```bash
git tag v1.0.0
git push origin v1.0.0
```

The workflow will build both APK and IPA, then create a GitHub release.

## Installation

### Android

1. Download APK from [Releases](../../releases)
2. Enable "Install from unknown sources" in settings
3. Install the APK

### iOS (via AltStore/Sideloadly)

1. Download IPA from [Releases](../../releases)
2. Install AltStore on your device
3. Sideload the IPA using AltStore or Sideloadly

Note: Free Apple IDs require re-signing every 7 days.

## Architecture

```
┌─────────────────────────────┐
│   Flutter UI (Dart)         │
├─────────────────────────────┤
│   Platform Channel          │
├─────────────────────────────┤
│   libbox (sing-box)         │
├─────────────────────────────┤
│   VpnService / NetworkExt   │
└─────────────────────────────┘
```

## TODO

- [ ] Integrate libbox for actual VPN functionality
- [ ] Add iOS NetworkExtension implementation
- [ ] Traffic statistics display
- [ ] Kill switch support
- [ ] Split tunneling

## License

CC BY-NC 4.0

