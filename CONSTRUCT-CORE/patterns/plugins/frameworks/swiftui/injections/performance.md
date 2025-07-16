## SwiftUI Performance Patterns

### List Performance
```swift
❌ NEVER: VStack/HStack with 50+ static items
✅ ALWAYS: LazyVStack/LazyHStack for lists

❌ NEVER: ForEach without id parameter or unstable IDs
✅ ALWAYS: ForEach with Identifiable or stable id: \.property
```

### Why These Matter

**LazyVStack/LazyHStack**: 
- Regular stacks create all views immediately
- Lazy stacks only create visible views
- Critical for performance with large datasets

**Stable IDs in ForEach**:
- SwiftUI uses IDs to track view identity
- Unstable IDs cause unnecessary redraws
- Can lead to animation glitches and poor performance

### Performance Checklist
- [ ] Use lazy stacks for any list over 10 items
- [ ] Ensure all ForEach loops have stable identifiers
- [ ] Profile with Instruments for scroll performance
- [ ] Test on older devices (performance floor)