# Quick Start Guide

Get up and running with Construct in 5 minutes.

## 1. Setup (2 minutes)

```bash
# Clone Construct
git clone https://github.com/yourusername/construct.git TodoApp
cd TodoApp

# Run setup
./construct-setup

# When prompted, enter your project name
Please enter your project name: TodoApp

# Load the new commands
source ~/.zshrc  # or restart terminal
```

## 2. First Command (30 seconds)

```bash
# Update CLAUDE.md to see your project state
construct-update
```

You'll see:
- ✅ Current project structure
- ✅ Available components
- ✅ No violations (yet!)
- ✅ Active PRD

## 3. Open in Xcode (30 seconds)

```bash
open TodoApp.xcodeproj
```

Your project is ready with:
- MVVM architecture
- Example feature to learn from
- Design tokens configured
- Git hooks installed

## 4. Create Your First Feature (2 minutes)

Let's create a Todo List feature:

```bash
# First, check what exists
construct-before TodoListView

# Create the feature
construct-new TodoListView
```

This creates:
- `TodoListView.swift` - The SwiftUI view
- `TodoListViewModel.swift` - Business logic with @MainActor
- `TodoListTokens.swift` - Design tokens for responsive UI

## 5. See Construct in Action (30 seconds)

Try to break the rules:

### Attempt 1: Add a hardcoded value

In `TodoListView.swift`, try adding:
```swift
.frame(width: 200, height: 100)  // ❌ Will be caught!
```

### Attempt 2: Commit the violation

```bash
git add .
git commit -m "feat: Add TodoList"
```

Watch Construct protect you:
```
🏗️  Construct Pre-Commit Checks
================================
Running architecture check... ❌
  Found hardcoded values in:
    - TodoListView.swift
  
❌ Some checks failed
Run 'construct-check' for detailed violation report
```

### Fix and Proceed

Replace with tokens:
```swift
.frame(width: tokens.listWidth, height: tokens.itemHeight)  // ✅
```

Now it commits successfully!

## What Just Happened?

You've experienced the Pentagram Construct:

1. **Vision** - Your PRD defined the TodoList feature
2. **Memory** - CLAUDE.md tracked your progress  
3. **Prediction** - `construct-before` showed what existed
4. **Protection** - Git hooks caught the violation
5. **Learning** - The system now knows your patterns

## Next Steps (Your Journey Begins)

### 1. Explore the Example Feature
Open `Template/iOS-App/Features/Example/ExampleView.swift` to see:
- Proper MVVM structure
- Token usage
- Accessibility patterns
- Multi-layer backgrounds

### 2. Understand Your Tools

Quick reference:
```bash
construct-update    # Start your day with this
construct-check     # Verify architecture
construct-before    # Before creating anything
construct-session   # When Claude says ~90% context
```

### 3. Build Your First Real Feature

1. Update the PRD in `Template/AI/PRDs/current-sprint/`
2. Run `construct-update` to refresh goals
3. Use `construct-before` to check existing code
4. Create with `construct-new`
5. Follow the patterns from Example

### 4. Work with AI

When using Claude/Cursor/Copilot:
1. They read CLAUDE.md automatically
2. They understand your patterns
3. They won't suggest anti-patterns
4. Trust their suggestions (they follow rules)

## Common First-Day Issues

### "Command not found"
```bash
source ~/.zshrc  # Reload shell config
```

### "I want to organize files differently"
Trust The Process. The structure is proven.

### "The checks seem strict"
They prevent future pain. Embrace them.

### "Can I skip the tokens?"
No. Tokens make responsive UI automatic.

## Your First Hour Checklist

- [ ] Setup complete
- [ ] Commands working
- [ ] Xcode project opens
- [ ] Example feature examined
- [ ] First violation caught and fixed
- [ ] First successful commit
- [ ] CLAUDE.md understood

## Pro Tips for Day 1

1. **Read the Example**: It's your best teacher
2. **Don't Fight the System**: It knows better
3. **Use Commands**: They're faster than manual
4. **Check Often**: `construct-check` is your friend
5. **Update Regularly**: `construct-update` keeps AI smart

## Get Help

- Run `construct-help` for command help
- Check `docs/` for deep dives
- Read error messages - they guide you
- Trust The Process - it works

## You're Ready!

You now know enough to be productive with Construct. The system will teach you the rest as you build.

Remember: **Trust The Process.**

---

Next: [Your First Feature](first-feature.md) - A deeper dive into building with Construct.