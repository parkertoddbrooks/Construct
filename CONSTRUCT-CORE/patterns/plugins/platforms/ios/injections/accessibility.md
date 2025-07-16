## iOS Accessibility Requirements

### Image Accessibility
```swift
❌ NEVER: Image without .accessibilityLabel
✅ ALWAYS: Descriptive labels for all images

// Examples
Image(systemName: "star.fill")
    .accessibilityLabel("Favorite")
    
Image("user-avatar")
    .accessibilityLabel("User profile photo")
```

### Button Accessibility
```swift
❌ NEVER: Button without accessible text or label
✅ ALWAYS: Clear button purposes with text or accessibilityLabel

// Icon-only buttons need labels
Button(action: deleteItem) {
    Image(systemName: "trash")
}
.accessibilityLabel("Delete item")
```

### Dynamic Type Support
```swift
❌ NEVER: Fixed font sizes (.font(.system(size: 17)))
✅ ALWAYS: Dynamic Type support (.font(.body), .font(.title))

// Use semantic font styles
Text("Title").font(.title)
Text("Body").font(.body)
Text("Caption").font(.caption)
```

### State Indication
```swift
❌ NEVER: Color as only indicator of state
✅ ALWAYS: Multiple indicators (color + icon + text)

// Bad: Only color indicates selected state
Circle()
    .fill(isSelected ? .blue : .gray)

// Good: Multiple indicators
HStack {
    Circle()
        .fill(isSelected ? .blue : .gray)
    Text(isSelected ? "Selected" : "Not selected")
    if isSelected {
        Image(systemName: "checkmark")
    }
}
.accessibilityLabel(isSelected ? "Selected" : "Not selected")
```

### Accessibility Checklist
- [ ] All images have meaningful labels
- [ ] All interactive elements are accessible
- [ ] Text supports Dynamic Type
- [ ] State changes are announced to VoiceOver
- [ ] Color is never the sole indicator
- [ ] Gestures have accessible alternatives
- [ ] Custom controls work with Switch Control

### Testing Requirements
- Test with VoiceOver enabled
- Test with Dynamic Type at largest setting
- Test with Reduce Motion enabled
- Test with Switch Control
- Test with color filters (for color blindness)