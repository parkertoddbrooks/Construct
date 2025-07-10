# iOS UI Component Library Patterns

## Overview
This pattern enforces best practices for creating reusable iOS UI components using SwiftUI.

## Rules

### Component Structure
```swift
❌ NEVER: Hardcoded values in components
✅ ALWAYS: Use tokens and configuration

❌ NEVER: Business logic in UI components
✅ ALWAYS: Pure UI components with data passed in

❌ NEVER: Components without preview providers
✅ ALWAYS: Include PreviewProvider for all components
```

### Accessibility
```swift
❌ NEVER: Components without accessibility labels
✅ ALWAYS: Provide meaningful accessibility labels

❌ NEVER: Fixed font sizes
✅ ALWAYS: Support Dynamic Type

❌ NEVER: Color as only indicator
✅ ALWAYS: Multiple indicators (color + icon + text)
```

### Reusability
```swift
❌ NEVER: Components tied to specific data models
✅ ALWAYS: Generic components with protocols/generics

❌ NEVER: Components with external dependencies
✅ ALWAYS: Self-contained components

❌ NEVER: Hardcoded styling
✅ ALWAYS: Configurable appearance via modifiers
```

## Examples

### ✅ Good: Reusable Component
```swift
// Reusable button component
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(0.8)
                }
                Text(title)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppColors.primary)
            .foregroundColor(.white)
            .cornerRadius(Tokens.cornerRadius)
        }
        .disabled(isLoading)
        .accessibilityLabel(title)
        .accessibilityHint("Double tap to activate")
    }
}

// Preview provider
struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PrimaryButton(title: "Sign In", action: {})
                .previewDisplayName("Default")
            
            PrimaryButton(title: "Loading...", action: {}, isLoading: true)
                .previewDisplayName("Loading State")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
```

### ❌ Bad: Non-reusable Component
```swift
struct LoginButton: View {
    @ObservedObject var viewModel: LoginViewModel  // Tied to specific VM
    
    var body: some View {
        Button(action: {
            viewModel.login()  // Business logic in component
        }) {
            Text("Login")
                .frame(width: 200, height: 44)  // Hardcoded values
                .background(Color.blue)  // Hardcoded color
        }
        // Missing accessibility
        // No preview provider
    }
}
```

## Component Categories

### Basic Components
- Buttons (Primary, Secondary, Tertiary)
- Text Fields (Standard, Secure, Search)
- Labels (Title, Body, Caption)
- Cards (Standard, Compact, Expanded)

### Complex Components
- Lists (Standard, Grouped, Sectioned)
- Navigation (Tab bars, Headers, Toolbars)
- Overlays (Sheets, Alerts, Toasts)
- Loading States (Spinners, Skeletons, Progress)

## Integration
This pattern ensures:
- Consistent UI across the application
- Accessible components by default
- Reusable component library
- Easy testing and preview