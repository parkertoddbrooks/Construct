## SwiftUI Visual Quality Patterns

### Critical: Background Flash Prevention

**MANDATORY**: SwiftUI rendering race conditions cause white flash artifacts that completely undermine professional visual quality.

```swift
// ❌ NEVER USE - Single background causes flashes
Color.black.ignoresSafeArea()

// ✅ ALWAYS USE - Multi-layer prevents flashes
ZStack {
    Color.black
        .ignoresSafeArea(.all, edges: .all)
    Color.black
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
}
```

### Why This Happens
- SwiftUI's rendering pipeline has timing issues
- Single backgrounds can be removed/redrawn during transitions
- Sheet presentations and animations are particularly vulnerable
- The multi-layer approach ensures at least one background is always rendered

### Quality Gates Before ANY UI Commit
- [ ] Test all animations for white flashes
- [ ] Test sheet presentations and drag gestures
- [ ] Verify background coverage during view transitions
- [ ] Confirm no white artifacts on device edges

### Visual Debugging Techniques
- Use `.background(Color.red.opacity(0.3))` to debug layout bounds
- Test components in different container sizes
- Use Xcode's Debug View Hierarchy
- Enable "Flash Updated Regions" in simulator

### Empirical Testing Requirements
- Visual quality must be tested on actual devices
- Simulator behavior differs from device behavior
- Dark mode apps are especially sensitive to flash issues
- Test with both light and dark system settings