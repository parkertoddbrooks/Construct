# iOS Platform Pattern

## iOS Configuration Rules

### App Configuration
```
❌ NEVER: Device orientation in code (App.swift, View.onAppear, etc.)
✅ ALWAYS: Device orientation in Xcode project settings or Info.plist

❌ NEVER: App permissions configured in code
✅ ALWAYS: App permissions in Info.plist with proper descriptions

❌ NEVER: Build settings or capabilities in code
✅ ALWAYS: Build settings in Xcode configuration

❌ NEVER: Launch screen setup in code
✅ ALWAYS: Launch screen via Storyboard or Info.plist

Configuration belongs in configuration files, not in code!
```

### Info.plist Requirements
```xml
<!-- Camera Permission -->
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to scan QR codes</string>

<!-- Location Permission -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to show nearby places</string>

<!-- Notifications -->
<key>NSUserNotificationsUsageDescription</key>
<string>This app sends notifications about important updates</string>
```

## iOS-Specific Commands

### Development Commands
```bash
# iOS project navigation
construct-ios         # Go to iOS app directory
construct-watch       # Go to Watch app directory

# Build and test
construct-build-ios   # Build iOS app
construct-test-ios    # Run iOS tests

# Validation
construct-check       # Validates iOS patterns
construct-protect     # Checks iOS quality standards
```

## Project Structure

### Standard iOS App Structure
```
YourApp/
├── YourApp/           # Main iOS app
│   ├── App/          # App lifecycle
│   ├── Features/     # Feature modules
│   ├── Services/     # Business logic
│   ├── Models/       # Data models
│   ├── Resources/    # Assets, Localizable.strings
│   └── Info.plist    # App configuration
├── YourAppWatch/      # Watch app (if applicable)
├── YourAppTests/      # Unit tests
└── YourAppUITests/    # UI tests
```

## Build Configuration

### Schemes and Configurations
- **Debug**: Development builds with debugging enabled
- **Release**: Production builds with optimizations
- **TestFlight**: Beta testing configuration
- **AppStore**: Final distribution build

### Required Capabilities
```
✅ Push Notifications (if using notifications)
✅ Background Modes (if needed)
✅ HealthKit (if accessing health data)
✅ Sign in with Apple (if using Apple ID)
```

## App Store Requirements

### Metadata
- App name (30 characters max)
- Subtitle (30 characters max)
- Keywords (100 characters max)
- Description (4000 characters max)
- Screenshots for all device sizes

### Review Guidelines
- No private APIs
- Accurate app description
- Functional sign-in credentials for review
- Complete all permission descriptions
- No placeholder content

## Performance Guidelines

### Memory Management
- Monitor memory usage in Instruments
- Profile for memory leaks
- Use weak references appropriately
- Clean up observers and timers

### Battery Usage
- Minimize background activity
- Use efficient location updates
- Batch network requests
- Respect Low Power Mode

## Development Tools

### Xcode Integration
- Use Xcode's built-in refactoring tools
- Leverage Interface Builder for Launch Screen
- Profile with Instruments
- Test on real devices

### Debugging
- Use Xcode's View Debugger
- Memory Graph Debugger for leaks
- Network Link Conditioner for testing
- Console app for system logs

## Platform-Specific Considerations

### iOS Version Support
- Target iOS 15+ for modern SwiftUI
- Check availability for newer APIs
- Provide fallbacks when needed
- Test on minimum supported version

### Device Considerations
- Support all screen sizes
- Handle safe areas properly
- Test on both iPhone and iPad
- Consider landscape orientation

### WatchOS Integration
- Keep Watch app lightweight
- Use complications effectively
- Handle connectivity properly
- Test on real Apple Watch