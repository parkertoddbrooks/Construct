# PRD: Swift + Claude Starter Template
**The Ultimate iOS/WatchOS Development Foundation**

**Last Updated**: 2025-06-28  
**Version**: 2.0

## Executive Summary

A production-ready Swift project template that combines MVVM architecture, design tokens, Claude AI integration, Swift 6 patterns, accessibility enforcement, and automated architecture enforcement through the 5-Layer Defense System. Fork and start building professional iOS/WatchOS apps with best practices enforced from day one.

## Vision

"Start every Swift project from a position of strength, with architecture that enforces itself and AI assistance that understands your codebase."

## Problem Statement

### Current Pain Points
1. **Starting from Scratch** - Every new project reinvents basic architecture
2. **Architecture Drift** - Good intentions degrade into technical debt
3. **AI Context Loss** - Claude starts fresh without understanding patterns
4. **AI Suggests Anti-Patterns** - AI tools often suggest business logic in Views
5. **Inconsistent Standards** - Each developer interprets best practices differently
6. **Manual Enforcement** - Code reviews catch issues too late
7. **Swift 6 Migration** - Projects aren't ready for modern concurrency
8. **Accessibility Afterthought** - Not built in from the start

### Target Users
- Swift developers starting new iOS/WatchOS projects
- Teams wanting consistent architecture across projects
- Developers using Claude/AI assistants for development
- Anyone wanting production-ready foundation from day one

## Core Features

### 1. Pre-Built MVVM Architecture

#### Structure
```
SwiftClaudeStarter/
├── iOS/
│   ├── App/
│   │   ├── AppDelegate.swift
│   │   ├── SceneDelegate.swift
│   │   └── AppCoordinator.swift
│   ├── Core/
│   │   ├── DesignSystem/
│   │   │   ├── Tokens/
│   │   │   ├── Colors.swift
│   │   │   ├── Spacing.swift
│   │   │   └── Typography.swift
│   │   ├── Navigation/
│   │   └── Extensions/
│   ├── Features/
│   │   └── Example/
│   │       ├── ExampleView.swift
│   │       ├── ExampleViewModel.swift
│   │       └── ExampleDesignTokens.swift
│   └── Shared/
│       ├── Components/
│       ├── Services/
│       └── Models/
├── WatchOS/ (optional)
├── Tests/
└── AI/
    ├── CLAUDE.md                # Enhanced with AI guidance
    ├── PRDs/                    # Product Requirements
    │   ├── current-sprint/      # Active development
    │   ├── full-app/           # Product vision
    │   └── future/             # Upcoming features
    ├── scripts/
    │   ├── update-context.sh    # Updates CLAUDE.md
    │   ├── before_coding.sh     # Pre-coding checks
    │   ├── check-architecture.sh # Compliance verification
    │   ├── check-quality.sh     # 11 quality checks
    │   ├── check-accessibility.sh # UI/UX compliance
    │   ├── session-summary.sh   # Context preservation
    │   ├── export-ai-rules.sh   # Export for any AI tool
    │   └── setup-aliases.sh     # Install commands
    ├── dev-logs/
    │   └── session-states/      # Auto-generated summaries
    ├── docs/
    │   ├── standards/
    │   │   ├── swiftui-standards.md
    │   │   └── swift6-mvvm-patterns.md  # AI guidance
    │   ├── automated/           # Auto-updated docs
    │   └── 4-layer-defense-system.md     # With automated backups
    └── structure/               # Architecture snapshots
```

#### Included Examples
- Complete MVVM feature example
- Reusable component library
- Service layer with protocols
- Coordinator navigation pattern
- Repository pattern for data

### 2. Design Token System

#### Pre-configured Tokens
```swift
// Responsive from day one
struct AppDesignTokens {
    static let responsive = AppDesignTokens(screenSize: UIScreen.main.bounds.size)
    
    // Spacing
    var spacingXS: CGFloat { screenWidth * 0.02 }
    var spacingS: CGFloat { screenWidth * 0.04 }
    var spacingM: CGFloat { screenWidth * 0.06 }
    
    // Typography
    var fontSizeBody: CGFloat { max(16, screenHeight * 0.022) }
    var fontSizeHeading: CGFloat { max(24, screenHeight * 0.035) }
    
    // Components
    var buttonHeight: CGFloat { max(44, screenHeight * 0.06) }
    var cornerRadius: CGFloat { 12 }
}
```

### 3. 5-Layer Defense System (with PRD Integration)

#### Layer 0: Strategic Planning (PRD-Driven Development)
- **PRD Integration** - Product requirements drive architecture
- `AI/PRDs/` structure for current-sprint, full-app, future
- Auto-extracted to CLAUDE.md for constant visibility
- `swift-before` checks PRD alignment before creating components
- `swift-check` verifies PRD requirements are met
- Sprint planning workflow with architecture pre-planning

#### Layer 1: Smart Documentation
- **CLAUDE.md** with auto-updating sections:
  - Current project structure and metrics
  - Active PRDs with sprint goals
  - Architecture violations tracking
  - Pattern library from actual code
  - Recent decisions and sprint context
- **Architecture docs** auto-update with implementation status
- **Session summaries** at 90% context for continuity

#### Layer 2: Pre-Coding Guidance
- `swift-before ComponentName` - Shows:
  - Existing similar components
  - PRD alignment check
  - Available design tokens
  - Required files checklist
  - Template generation commands
- Component reuse discovery
- Pattern suggestions from codebase

#### Layer 3: Architecture Enforcement
- **Git hooks** prevent violations at commit time
- **Quality gates** enforced:
  - No hardcoded values (must use tokens)
  - MVVM compliance (Views need ViewModels)
  - No direct navigation (use Coordinators)
  - Background flash prevention patterns
  - No Constants enums (forbidden pattern)
  - iOS configuration in proper places (not in code)
- **PRD compliance** verification:
  - Implementation matches requirements
  - Performance targets checked (e.g., <50ms latency)
  - Required integrations verified
- **iOS-specific checks**:
  - Device orientation in Xcode settings/Info.plist
  - Permissions have usage descriptions
  - Build settings not in code
  - Configuration stays in configuration files

#### Layer 4: Continuous Monitoring
- **Architecture health** tracking:
  - `swift-scan` - MVVM structure documentation
  - `swift-quality` - SwiftUI quality checks
  - Violation trends over time
- **Automated updates**:
  - `swift-update` - Refresh all documentation
  - `swift-arch` - Update architecture status
  - `swift-full` - Complete system update
- **Session preservation**:
  - Auto-triggered at 90% context
  - Captures decisions and progress
  - Enables seamless handoffs

### 4. Claude AI Integration

#### Enhanced CLAUDE.md
```markdown
# Project Context for Claude

## 🚨 Enforce These Rules
[Auto-populated with project standards including:]
- MVVM architecture patterns
- Token-first development
- No hardcoded values
- iOS configuration placement
- Swift 6 concurrency (@MainActor, async/await)
- State management rules (@State vs @Published)
- Modern SwiftUI patterns
- Accessibility requirements
- Performance patterns

## 📊 Current State (Auto-Updated)
[Real-time project metrics, component counts]

## 📋 Active Product Requirements (Auto-Updated)
### Current Sprint
- Active PRD with key goals
- Sprint branch and focus areas

### North Star Vision
- Link to full product vision

### Upcoming Features
- List from future PRDs

## 🧰 Available Components
[Always current component list]

## 📚 Pattern Library
[Extracted from actual code]

## ⚠️ Active Violations
[Current architecture issues to avoid]

## 📍 Working Location
[Recent files and git status]

## 🤖 AI Architectural Guidance

### Where Code Belongs
[Quick reference table showing View/ViewModel/Service/Model]

### Common AI Mistakes to Avoid
1. Business logic in Views
2. @State for business data
3. Direct Service access
4. Configuration in code

### When @State IS Acceptable
[Clear examples of UI-only state]

## 🤖 Claude Instructions
### When Context Reaches 90%:
1. Alert user: "⚠️ Context at 90% - time to generate session summary"
2. Tell user to run: `swift-session` or `run-session-summary`
3. Remind to start fresh Claude session
```

#### Session Summary Integration
- Automated session preservation at 90% context
- Captures work history, decisions, and current state
- Works as "context bridge" with CLAUDE.md
- Enables seamless session transitions

#### AI-Friendly Features
- Clear file organization
- Comprehensive documentation
- Pattern examples
- Architecture rules
- Component discovery
- Multi-AI platform support (Cursor, Copilot, Claude)
- Dynamic rule generation from project state

### 5. Visual Quality Standards

#### Background Flash Prevention
- Multi-layer background patterns included
- Sheet presentation templates  
- Animation-safe view structures
- Quality gates in pre-commit hooks

#### Quality Enforcement (`swift-quality`)
- Checks for hardcoded values
- Prevents Constants enums (forbidden pattern)
- Verifies token usage (>10 usages minimum)
- MARK organization verification
- Background flash prevention patterns
- Modern async/await enforcement
- @MainActor usage verification
- Business logic detection in Views
- @State misuse detection
- Modern SwiftUI pattern checks
- Performance pattern validation

#### Accessibility Enforcement (`swift-accessibility`)
- Images require accessibility labels
- Buttons need clear purposes
- Dynamic Type support (no fixed fonts)
- Minimum tap targets (44x44pt)
- Multiple indicators (not just color)
- VoiceOver navigation support
- Loading state labels
- Professional UI quality checks

#### Professional UI Patterns
```swift
// All views include flash-safe backgrounds
struct ExampleView: View {
    var body: some View {
        ZStack {
            // Multi-layer background (prevents flashes)
            AppColors.background
                .ignoresSafeArea(.all, edges: .all)
            AppColors.background
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
            
            // Content here
        }
    }
}
```

### 6. Example Features

#### 1. Login Feature (Complete MVVM)
- LoginView with tokens
- LoginViewModel with validation
- LoginService with mock/real
- Navigation integration
- Error handling

#### 2. Settings Feature
- Demonstrates preferences
- Toggle components
- List layouts
- Navigation patterns

#### 3. Data List Feature
- Repository pattern
- Pagination
- Pull to refresh
- Empty states
- Loading states

### 7. Swift 6 & Modern Patterns

#### Swift 6 Concurrency
- @MainActor on all ViewModels
- async/await throughout
- Proper actor isolation
- No completion handlers
- Sendable conformance

#### Modern SwiftUI
- NavigationStack (not NavigationView)
- @Observable macro ready (iOS 17+)
- .task modifier for async work
- LazyVStack/LazyHStack for performance
- Stable ForEach identifiers

#### MVVM Clarity
- Clear separation of concerns
- Comprehensive pattern examples
- Anti-pattern examples (what NOT to do)
- Where code belongs quick reference
- Common AI mistakes prevention

### 8. Testing Foundation

#### Included Tests
- ViewModel unit tests with @MainActor
- Service mock patterns
- UI testing setup
- Snapshot testing ready
- Performance benchmarks
- Accessibility tests

#### Testing Utilities
```swift
// Easy ViewModel testing
class MockService: ServiceProtocol {
    var shouldFail = false
    var delay: TimeInterval = 0
    
    func fetchData() async throws -> [Model] {
        // Configurable mock behavior
    }
}
```

### 9. Development Tools

#### Shell Commands
```bash
# Project setup
swift-setup          # Initial configuration

# Sprint Planning (PRD workflow)
swift-sprint-plan    # Create new sprint PRD
swift-prd           # Open current sprint PRD
swift-prd-check     # Search PRDs for alignment

# Development
swift-before Feature # Check before creating (PRD alignment + existing code)
swift-new Feature    # Create new feature from template
swift-check         # Architecture & PRD compliance
swift-quality       # 11 comprehensive quality checks
swift-accessibility # UI/UX compliance checks
swift-update        # Update CLAUDE.md (includes PRDs)
swift-arch          # Update architecture docs
swift-full          # All updates and checks

# Session Management
swift-session       # Generate session summary (auto at 90%)
swift-claude        # Open CLAUDE.md for context

# AI Integration
swift-export-rules   # Export rules for any AI tool
swift-export-cursor  # Generate .cursorrules
swift-sync-ide       # Sync with IDE settings

# Testing
swift-test          # Run all tests
swift-coverage      # Coverage report

# Monitoring
swift-scan          # Document MVVM structure
swift-violations    # Show current violations
```

#### Multi-IDE Support
- **Cursor Integration**: Auto-generate `.cursorrules` from project state
- **GitHub Copilot**: Export compatible rules
- **VS Code**: Live rule updates
- **Xcode**: SwiftPad compatibility

#### Xcode Templates
- Feature.xctemplate (View + ViewModel + Tokens)
- Service.xctemplate (Protocol + Implementation)
- Component.xctemplate (Reusable UI)

### 10. AI Platform Integration

#### Universal AI Rules Export
Generate AI-specific rules from your living project state:

```bash
# Export for different platforms
swift-export-cursor      # Creates .cursorrules
swift-export-copilot     # Creates .github/copilot-rules.md
swift-export-claude      # Updates CLAUDE.md

# Universal export
swift-export-rules --format yaml  # Platform-agnostic
```

#### Dynamic Rule Generation
Unlike static rule files, exported rules include:
- Current project patterns
- Recent architectural decisions
- Known anti-patterns to avoid
- Project-specific conventions
- Team preferences

#### Example Output
```markdown
# Generated Cursor Rules for RUN Project
# Last Updated: 2025-06-27 22:15:00

## Project-Specific Patterns
- Use WatchConnectionManager for all Watch communication
- Background views require multi-layer pattern (see MainView.swift)
- All values must use design tokens (violations: 2 remaining)

## Recent Decisions
- NavigationView breaks Watch state restoration (use ZStack)
- Dual delivery required for Watch data
```

### 11. PRD-Driven Development Workflow

#### Sprint Planning Process
1. **Create Sprint PRD**
   ```bash
   swift-sprint-plan feature-name
   # Creates: AI/PRDs/current-sprint/2025-06-28-feature-name-prd.md
   ```

2. **Define Requirements**
   - User stories and success criteria
   - Architecture decisions
   - Component breakdown
   - Performance requirements

3. **Start Development**
   ```bash
   swift-update  # PRD goals now in CLAUDE.md
   swift-before ComponentName  # Check PRD alignment
   ```

4. **Continuous Compliance**
   - Pre-commit hooks check PRD requirements
   - `swift-check` verifies implementation
   - Architecture can't drift from PRD

#### Benefits
- **No Scope Creep**: Can't accidentally build wrong features
- **Clear Direction**: PRD always visible in CLAUDE.md
- **Traceable**: Every component linked to requirements
- **Quality Built-in**: Requirements enforced automatically

### 12. Documentation

#### Included Guides
1. **Quick Start** - 5-minute setup
2. **Architecture Guide** - MVVM patterns with Swift 6
3. **Token System** - Responsive design
4. **5-Layer Defense** - Complete enforcement system
5. **PRD Workflow** - Sprint planning guide
6. **Claude Integration** - AI-assisted development
7. **AI Platform Setup** - Cursor, Copilot, Claude configuration
8. **Swift 6 Patterns** - Modern concurrency guide
9. **Accessibility Guide** - Professional UI standards
10. **Testing Guide** - Test strategies with @MainActor
11. **Contributing** - Open source guidelines

## Implementation Plan

### Phase 1: Core Template (Week 1-2)
- [ ] Basic project structure
- [ ] MVVM example feature
- [ ] Design token system
- [ ] Navigation coordinator

### Phase 2: Defense System (Week 3)
- [ ] Git hooks with AI-friendly messages
- [ ] Architecture scripts (11 quality checks)
- [ ] Enhanced CLAUDE.md template
- [ ] Automation tools
- [ ] Accessibility checks

### Phase 3: Examples & Tools (Week 4)
- [ ] Three complete features with Swift 6
- [ ] Xcode templates
- [ ] Shell commands
- [ ] Testing utilities
- [ ] AI export functionality

### Phase 4: Documentation & Launch (Week 5)
- [ ] Comprehensive docs with patterns guide
- [ ] Video tutorials
- [ ] GitHub Actions
- [ ] Launch preparation
- [ ] Swift 6 migration guide

## Success Metrics

### Adoption
- 1,000 stars in 6 months
- 100 active forks
- 50 contributors
- Used in 10 production apps

### Quality
- Zero architecture violations in projects using template
- 90% reduction in setup time
- 80% code reuse across features
- 95% test coverage achievable

### Community
- Active Discord/Slack
- Regular updates
- Community contributions
- Tutorial ecosystem

## Technical Requirements

### Minimum Versions
- iOS 15.0+ / WatchOS 8.0+
- Xcode 15.0+ (Swift 6 support)
- Swift 6.0+ (with 5.10 compatibility mode)
- macOS 13.0+ for development

### Dependencies
- Zero external dependencies in core
- Optional integrations documented
- Everything in pure Swift
- SwiftUI + UIKit support

## Open Source Strategy

### License
- MIT License
- Commercial use allowed
- Attribution appreciated

### Repository Structure
```
swift-claude-starter/
├── README.md
├── LICENSE
├── CONTRIBUTING.md
├── .github/
│   ├── ISSUE_TEMPLATE/
│   ├── workflows/
│   └── FUNDING.yml
├── Template/
│   └── [Project Template]
├── Docs/
├── Examples/
└── Tools/
```

### Community Building
1. **Launch**
   - Blog post series
   - YouTube walkthrough
   - Twitter/social campaign
   - Submit to Swift Weekly

2. **Ongoing**
   - Monthly updates
   - Community calls
   - Feature requests
   - Bug bounty program

## Differentiation

### vs. Other Starters
- **Built for AI** - Claude/Cursor/Copilot understand the codebase
- **Self-Enforcing** - Architecture can't drift with pre-commit hooks
- **Production Ready** - Not just a demo, includes accessibility
- **Responsive First** - Tokens from day one
- **Swift 6 Ready** - Modern patterns throughout
- **Zero Dependencies** - Pure Swift solution

### Unique Value
1. **5-Layer Defense** - Product-driven architecture enforcement
2. **PRD Integration** - Requirements drive development, not follow it
3. **AI Understanding** - Enhanced guidance prevents anti-patterns
4. **Living Documentation** - Always current, never stale
5. **Professional Quality** - DAW-level standards with accessibility
6. **Complete Examples** - Real features with Swift 6 patterns
7. **Zero Setup Drift** - Can't break architecture even if you try
8. **Modern Swift** - @MainActor, async/await, Swift 6 ready
9. **AI Export** - Works with any AI tool, not just Claude
10. **Session Continuity** - Never lose context at 90%

## Future Roadmap

### v2.0 - Multi-Platform
- macOS support
- iPad optimizations
- tvOS templates
- Vision Pro ready

### v3.0 - Advanced Features
- Modular architecture
- Micro-frontends
- Server-driven UI
- Real-time sync

### v4.0 - AI Enhancement
- GPT integration
- Code generation
- Automated testing
- Performance optimization

## Call to Action

"Stop starting from zero. Build your next iOS app on a foundation that enforces best practices, prevents AI from suggesting anti-patterns, includes Swift 6 patterns, ensures accessibility, and scales with your ambition. Fork SwiftClaudeStarter and ship better apps faster."

### Why Now?
- Swift 6 is here - start with modern patterns
- AI tools are everywhere - make them work better
- Accessibility is required - build it in from day one
- Architecture drift kills projects - prevent it automatically

---

**Target Launch**: Q2 2025
**Repository**: github.com/[your-username]/swift-claude-starter
**Documentation**: swiftclaudestarter.dev
**Community**: discord.gg/swiftclaude