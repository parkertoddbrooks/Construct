# CONSTRUCT 🏗️

**Dynamic context engineering for AI-powered development**

## The Context Problem

Claude Code changed everything. Unlike Cursor, Windsurf, and other VS Code forks that bolt AI onto 20-year-old IDE paradigms, Claude Code understood something fundamental: **the future of development isn't about editing code, it's about managing context**.

When I built my first app with Claude Code, I realized I only used two tools: Claude Code for development and GitHub Desktop for diffs. No file trees. No syntax highlighting. No extensions. As Indragie Karunaratne [discovered](https://www.indragie.com/blog/i-shipped-a-macos-app-built-entirely-by-claude-code) shipping a macOS app: "I have to imagine that there is a future in which IDEs look nothing like they do today." The centerpiece isn't a code editor anymore - it's context management and feedback loops.

But there's still friction. Every Claude Code session starts the same way: "We use MVVM architecture." "Swift files go here." "Follow these naming conventions." You paste in your `CLAUDE.md` file and hope for the best. Tools like [SwiftCatalyst](https://github.com/danielraffel/SwiftCatalyst) and Ray Fernando's [Swift Cursor Rules](https://www.rayfernando.ai/swift-cursor-rules) pioneered static rules for better AI assistance. But even the best static rules can't solve the core problem: **context needs to be dynamic**.

As Andrej Karpathy [points out](https://x.com/karpathy/status/1937902205765607626), we need "context engineering" not "prompt engineering." The art is filling the context window with exactly the right information for the task at hand. CONSTRUCT was born from this realization - while building an app with Claude Code, I was spending more time teaching it my patterns than actually building. The solution wasn't better static rules. The solution was making context aware of what I'm actually doing.

## What CONSTRUCT Does

CONSTRUCT dynamically assembles the perfect context based on your current task:

```yaml
# .construct/patterns.yaml
patterns:
  - languages/swift
  - architectural/mvvm-ios
  - integrations/stripe
  - ui/ios/standard-components
```

When you edit a Swift file, Claude gets Swift patterns. When you switch to shell scripts, it gets bash patterns. When you mention "User model", it knows to check all platforms where that model exists. **Your AI assistant finally understands context switching**.

## Features

### 🧠 Self-Improving Pattern System
- **Dynamic Context Assembly**: Loads relevant patterns based on what you're working on
- **Pattern Learning**: Identifies repeated code structures and suggests new patterns
- **Validation Feedback**: Patterns improve based on real usage
- **Smart Detection**: Automatically recognizes your tech stack and suggests patterns

### 🔌 Pattern Plugin Ecosystem (Like Homebrew for AI Context)
- **Browse & Install**: `construct search swift` finds all Swift patterns
- **Community Taps**: Share patterns without central approval
- **Private Registries**: Host company-specific patterns
- **Version Management**: Track pattern updates and dependencies

Each pattern includes:
- **📝 Rules**: The actual context and examples for AI
- **🚨 Validators**: MANDATORY enforcement scripts ensuring patterns are followed
- **🏗️ Generators**: Create boilerplate code or visualizations from patterns

**Core Principle**: Every pattern must have a validator. No pattern without enforcement.

### ⚡ One-Click Everything
- **Integrations**: `construct add integration/stripe` - full MVVM-compliant integration
- **UI Components**: `construct add ui/ios/settings-screen` - complete, architected screens
- **Features**: `construct add feature/user-auth` - entire feature implementations
- **Cross-Platform**: Patterns that keep your models in sync across iOS/Android/Web

### 🏗️ Real Architecture Support
- **MVVM, VIPER, Clean Architecture**: First-class support for real patterns
- **Vendor Best Practices**: Integrations that follow vendor recommendations
- **Your Patterns**: Customize everything to match your team's style
- **Generated Code That Looks Hand-Written**: No obvious AI tells

## Installation

### Quick Start
```bash
# Clone CONSTRUCT
git clone https://github.com/yourusername/construct.git
cd construct

# For new projects
./CONSTRUCT-CORE/CONSTRUCT/scripts/create-project.sh MyApp

# For existing projects
./CONSTRUCT-CORE/CONSTRUCT/scripts/import-project.sh ../YourProject
cd Projects/YourProject
./CONSTRUCT-CORE/CONSTRUCT/scripts/construct/init-construct.sh  # AI analyzes and enhances with patterns

# Optional: Full three-level pattern extraction (slower but more sophisticated)
./CONSTRUCT-CORE/CONSTRUCT/scripts/construct/init-construct.sh --extract
```

### Using CONSTRUCT
```bash
# Manage patterns in your project
construct-patterns list                    # View available patterns
construct-patterns show                    # Show current configuration
construct-patterns regenerate              # Update CLAUDE.md from patterns

# Update context and validate
construct-update         # Refresh dynamic context
construct-check          # Validate architecture
construct-quality        # Check code quality
```

Now Claude Code knows your architecture, your patterns, your preferences - automatically.

## Built-in Patterns

### 🛠️ Core Patterns
- **Languages**: Swift, TypeScript, Python, C#, Go, Rust, Kotlin
- **Architectures**: MVVM, VIPER, Clean Architecture, MVC, MVP
- **Platforms**: iOS, macOS, watchOS, Android, Web, React Native

### 🚀 Enterprise Integrations
Stop copy-pasting vendor sample code. One command, proper architecture:

- **Analytics**: Mixpanel, Amplitude, PostHog, Segment
- **Payments**: Stripe, RevenueCat, Apple Pay, Google Pay
- **Auth**: Auth0, Firebase Auth, Supabase, Clerk
- **Chat**: Intercom, Zendesk, Crisp, Drift
- **Monitoring**: Sentry, Bugsnag, Rollbar, LogRocket
- **Push**: OneSignal, Firebase, APNS, FCM

### 🎨 UI Component Library
Complete screens and components, in your architecture:

- **Screens**: Onboarding, Settings, Profile, Login, Subscription
- **Components**: Forms, Lists, Navigation, Loading States
- **Patterns**: Error Handling, Empty States, Pull-to-Refresh
- **Animations**: Transitions, Gestures, Haptics

## How It Works

### 1. AI-Native Integration (`construct-init`)
CONSTRUCT's breakthrough is the **AI-Native Intelligent Orchestrator** that uses Claude SDK to understand your project:

```bash
cd YourProject
./CONSTRUCT-CORE/CONSTRUCT/scripts/construct/init-construct.sh
```

**What the AI-Native Orchestrator does:**
- **Intelligent Pattern Extraction**: Uses Claude SDK to analyze existing CLAUDE.md for project-specific knowledge
- **Automatic Language Detection**: Analyzes codebase and recommends appropriate patterns
- **Unified Architecture**: Creates same folder structure as CONSTRUCT-LAB for consistency
- **Focused Assembly**: Generates project-focused CLAUDE.md (not pattern dumps)

### 2. Pattern Configuration
```yaml
# .construct/patterns.yaml (auto-generated + customizable)
languages: ["python", "swift"]  # Auto-detected
plugins: [
  "project-custom",             # Extracted from your CLAUDE.md
  "languages/python", 
  "tooling/shell-scripting"
]
```

### 3. Dynamic Context Assembly
CONSTRUCT intelligently loads relevant patterns:
- **Project Knowledge First**: Your extracted patterns take priority
- **Contextual Loading**: Brief pattern references, not full dumps
- **Real-time Awareness**: Patterns understand current project state

### 3. Pattern Development
Create patterns that capture your team's knowledge:
```bash
cd CONSTRUCT-LAB
./tools/create-pattern.sh "integration/new-service"
# Edit pattern, test with projects, share with community
```

### 4. Complete Infrastructure Installation
The AI-Native Orchestrator installs everything needed:

**Installed automatically:**
- **CONSTRUCT/** → Unified project structure with tools
- **CONSTRUCT/AI/** → Documentation and analysis structure  
- **CONSTRUCT/patterns/plugins/** → Project-specific pattern space
- **Git hooks** → Quality validation on commits
- **Pattern configuration** → Auto-detected + extractable rules

**Validation & Quality:**
- **Pre-commit hooks**: Ensure code quality before commits
- **Architecture validation**: Check compliance with patterns
- **Context updates**: Keep AI assistance current with project state

## Real Impact

### Before CONSTRUCT
- Start every Claude session explaining your architecture and patterns
- Manually paste CLAUDE.md hoping AI understands your context
- Lose project-specific knowledge when switching between projects
- Fight with static rules that don't understand your current task

### With CONSTRUCT
```bash
# One-time setup extracts and preserves your project knowledge
./CONSTRUCT-CORE/CONSTRUCT/scripts/construct/init-construct.sh

# AI always knows your architecture, patterns, and current context
# Your extracted project knowledge appears prominently in CLAUDE.md
```
Done. Claude understands your project like you wrote the documentation yourself.

## Architecture (The Homebrew Model)

```
CONSTRUCT/
├── CONSTRUCT-CORE/     # Stable patterns (like brew formulae)
├── CONSTRUCT-LAB/      # Pattern development (like brew taps)
└── Projects/           # Your managed projects
```

Just like Homebrew:
- **CORE = Formulae**: Stable, proven patterns everyone uses
- **LAB = Taps**: Experimental patterns, company-specific patterns
- **No Gatekeepers**: Fork, modify, share without asking permission
- **Natural Selection**: Best patterns get adopted, bad ones fade away

Pattern structure:
```
patterns/integration/stripe/
├── pattern.md           # Rules and context for AI
├── metadata.yaml        # Version, dependencies
├── validators/
│   ├── check-service.sh # Ensures proper service layer
│   └── check-models.sh  # Validates data models
└── generators/
    ├── create-service.sh   # Generate Stripe service
    └── create-viewmodel.sh # Generate payment UI
```

## Requirements
- macOS 12.0+ or Linux (Windows via WSL)
- Git
- Claude Code, Cursor, or any AI assistant
- yq (`brew install yq`)

## Philosophy
- **Context > Prompts**: Right information beats clever wording
- **Dynamic > Static**: Adapt to what developers are actually doing
- **Patterns > Templates**: Composable, evolvable, shareable
- **Community > Committee**: Best patterns win, not "official" ones

## Contributing

The LAB environment is where patterns are born:
1. Notice a pattern in your code
2. Extract it to CONSTRUCT-LAB
3. Test with real projects
4. Share with the community

No gatekeepers. No committees. If it works, it's good.

## Status & Roadmap

### ✅ **Phase 1 Complete: AI-Native Orchestrator (Step 2)**
- **Intelligent Pattern Extraction**: Claude SDK analyzes and preserves project knowledge
- **Unified Architecture**: Same folder structure as CONSTRUCT-LAB
- **Automatic Integration**: Two-stage setup (`/init` → `construct-init`)
- **Focused Assembly**: Project-first CLAUDE.md generation
- **Complete Infrastructure**: Tools, hooks, patterns, validation

### 🚧 **Phase 2: Core Infrastructure (Steps 3-4)**
- Pattern System Enhancement
- Context Engineering Automation
- Advanced pattern registry and template system

### 🔮 **Coming Soon**
- 🌐 Web-based pattern browser
- 🎯 VSCode & Cursor extensions  
- 📦 Single `construct` CLI tool
- 📊 Pattern analytics dashboard
- 🔄 Automatic pattern updates

## License

MIT - Good developer tools should be free.

---

Built from real pain, tested in production, shared with love. The AI-Native Orchestrator breakthrough means your AI assistant finally understands your project without you explaining it every session.

**Ready to give your AI assistant project memory?** The AI-Native integration is complete and ready to transform how you work with Claude.