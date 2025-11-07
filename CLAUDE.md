# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Cometta is an iOS application built with SwiftUI. The project uses a standard Xcode project structure (.xcodeproj) without external dependency managers like CocoaPods or Swift Package Manager.

**Bundle Identifier**: `vav.space.Cometta`
**Supported Platforms**: iOS (iPhone and iPhone Simulator)

## Project Structure

- `Cometta/ComettaApp.swift` - Main app entry point using the `@main` attribute
- `Cometta/ContentView.swift` - Root view of the application
- `Cometta/Assets.xcassets/` - Asset catalog for images, colors, and app icons

## Build and Run Commands

### Building the project
```bash
xcodebuild -project Cometta.xcodeproj -scheme Cometta -configuration Debug
```

### Building for release
```bash
xcodebuild -project Cometta.xcodeproj -scheme Cometta -configuration Release
```

### Clean build folder
```bash
xcodebuild clean -project Cometta.xcodeproj -scheme Cometta
```

### Running on simulator
```bash
# List available simulators
xcrun simctl list devices available

# Build and run on specific simulator (replace DEVICE_ID)
xcodebuild -project Cometta.xcodeproj -scheme Cometta -destination 'platform=iOS Simulator,id=DEVICE_ID'
```

### Running tests
```bash
xcodebuild test -project Cometta.xcodeproj -scheme Cometta -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Architecture Notes

The app follows the standard SwiftUI app lifecycle:
- Uses `@main` attribute on `ComettaApp` struct conforming to the `App` protocol
- `WindowGroup` scene container provides the main UI window
- `ContentView` is injected as the root view

The project uses automatic Info.plist generation (`GENERATE_INFOPLIST_FILE = YES`), so there is no separate Info.plist file to edit.

## Development Workflow

When adding new Swift files, ensure they are added to the Cometta target in Xcode. The project does not currently use any external dependencies or frameworks beyond the standard iOS SDK and SwiftUI.
