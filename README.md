# CONSTRUCT

CONSTRUCT is a GitHub template repository that gives you a complete Swift development foundation with AI-powered architecture enforcement.

## What You Get

When you use CONSTRUCT, you get:

1. **Complete Swift Project** - Ready-to-build iOS and Watch apps
2. **AI Development Tools** - Scripts that understand your codebase  
3. **Self-Enforcing Architecture** - Prevents bad patterns automatically
4. **Design System Foundation** - Responsive tokens from day one

### 1. Get Your Project
Click "Use this template" on the CONSTRUCT GitHub repo. This creates your own repository with all the CONSTRUCT tools.

### 2. Personalize It
```bash
cd YourProject
./construct-setup
# Enter your project name when prompted
```

This renames everything to match your project and sets up your development environment.

### 3. Start Building
```bash
cd USER-project-files/
./AI/scripts/update-context.sh    # Updates AI with your project state
./AI/scripts/check-architecture.sh # Validates your code patterns
```

Your AI assistant (Claude, Cursor, etc.) now understands your project architecture and will suggest the right patterns.

## The AI Integration

CONSTRUCT creates a living `CLAUDE.md` file that auto-updates with:
- Your current component counts
- Architecture violations to avoid  
- Available design tokens and patterns
- Recent development context

This means your AI always knows:
- What components already exist (avoid duplicates)
- Which patterns to follow (MVVM, design tokens)
- What violations to prevent (hardcoded values, business logic in Views)

## Architecture Enforcement

CONSTRUCT prevents common mistakes:

❌ **Prevents**: Business logic in SwiftUI Views  
✅ **Enforces**: ViewModels handle business logic

❌ **Prevents**: Hardcoded values like `.frame(width: 200)`  
✅ **Enforces**: Design tokens like `.frame(width: tokens.buttonWidth)`

❌ **Prevents**: @State for business data  
✅ **Enforces**: @Published properties in ViewModels

## Your Development Workflow

### Daily Development
```bash
# Start your day
./AI/scripts/update-context.sh      # Refresh AI context

# Before creating something new  
./AI/scripts/before_coding.sh LoginView  # Shows what exists

# After making changes
./AI/scripts/check-architecture.sh  # Validate patterns
```

### When Context Gets Full (~90%)
```bash
./AI/scripts/session-summary.sh     # Preserve context
# Start fresh AI session
./AI/scripts/update-context.sh      # Load current state
```

## Project Structure

Your personalized project includes:

```
YourProject/
├── USER-project-files/           # Your Swift development workspace
│   ├── AI/                      # AI tools and context
│   │   ├── CLAUDE.md           # Auto-updating AI context
│   │   └── scripts/            # Development workflow scripts
│   ├── PROJECT-name/           # Your actual Xcode project
│   │   ├── YourApp.xcodeproj  # Ready to build
│   │   ├── iOS-App/           # iOS application code
│   │   └── Watch-App/         # Watch application code
│   └── scripts/               # Development utilities
└── CONSTRUCT-docs/             # This documentation
```

## Why CONSTRUCT Works

**Traditional Approach**:
- Start from scratch each time
- AI suggests random patterns
- Architecture drifts over time
- Manual code reviews catch issues late

**CONSTRUCT Approach**:
- Start with production-ready foundation
- AI understands your specific patterns
- Architecture enforces itself automatically  
- Issues prevented before they're written

## Getting Help

- **Commands**: See [CONSTRUCT-docs/commands.md](CONSTRUCT-docs/commands.md) for all available scripts
- **Issues**: Report problems on the CONSTRUCT GitHub repository
- **Patterns**: Check your auto-updating `CLAUDE.md` for current project patterns