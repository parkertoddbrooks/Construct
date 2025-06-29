# Working with AI

How to leverage AI assistants effectively with Construct.

## Overview

Construct is built for AI-native development. Your AI assistant (Claude, Cursor, Copilot) understands your architecture through CLAUDE.md and follows your patterns automatically.

## How AI Integration Works

### 1. Context Awareness

When you run `construct-update`, it updates CLAUDE.md with:
- Current project structure
- Available components
- Active violations
- Recent patterns
- Sprint goals

AI reads this and understands your project instantly.

### 2. Pattern Recognition

The AI learns from:
- Your existing code patterns
- Extracted common properties
- Architectural decisions
- Team conventions

### 3. Guided Suggestions

AI won't suggest anti-patterns because CLAUDE.md explicitly states:
- What to NEVER do
- What to ALWAYS do
- Where code belongs
- Common mistakes to avoid

## Working with Claude

### Starting a Session

1. **Always run first:**
   ```bash
   construct-update
   ```

2. **Claude automatically reads CLAUDE.md** and knows:
   - Your architecture rules
   - Available components
   - Current sprint goals
   - What patterns to follow

### Best Practices with Claude

#### Be Specific
```
❌ "Create a login screen"
✅ "Create a login feature following our MVVM pattern with tokens"
```

#### Reference Existing Code
```
❌ "Make a new component"
✅ "Create a component similar to ExampleView"
```

#### Leverage Context
```
❌ "What's the button style?"
✅ "Use our existing button styles from the pattern library"
```

### Session Management

When Claude says context is ~90% full:

1. **Run immediately:**
   ```bash
   construct-session
   ```

2. **Start fresh session** with the generated summary

3. **Run in new session:**
   ```bash
   construct-update
   ```

## Working with Cursor

### Setup

1. **Export rules for Cursor:**
   ```bash
   construct-export --cursor
   ```

2. **This creates `.cursorrules`** with:
   - Your project patterns
   - Current conventions
   - Architecture rules
   - Anti-patterns to avoid

### Cursor Features

#### Auto-complete
Cursor will suggest code that matches your patterns:
```swift
// Type: "struct "
// Cursor suggests: "struct FeatureView: View {"
// Because it knows your naming conventions
```

#### Refactoring
Cursor understands your architecture:
```swift
// Select business logic in a View
// Cursor suggests: "Move to ViewModel"
```

#### Generation
Ask Cursor to generate code:
```
"Create a new feature called ProfileView"
// Cursor creates View, ViewModel, and Tokens
```

### Keeping Cursor Updated

```bash
# After significant changes
construct-export --cursor

# Cursor reloads rules automatically
```

## Working with GitHub Copilot

### Setup

1. **Export rules:**
   ```bash
   construct-export --copilot
   ```

2. **Creates `.github/copilot-rules.md`**

### Copilot Integration

#### In-line Suggestions
```swift
// Type: "@Published var "
// Copilot suggests: "@Published private(set) var items: [Item] = []"
// It learned your patterns
```

#### Comment-Driven Development
```swift
// MARK: - Load data from service
// Copilot generates the entire method following your patterns
```

## Multi-AI Workflow

### Use Each Tool's Strengths

#### Claude - Architecture & Design
- "How should I structure this feature?"
- "Review this code for pattern compliance"
- "Explain our architecture to a new developer"

#### Cursor - Rapid Development
- Quick refactoring
- Auto-completion
- Multi-file changes

#### Copilot - Code Generation
- Boilerplate code
- Test generation
- Documentation

### Example Workflow

1. **Plan with Claude:**
   ```
   "I need to add a payment feature. What's our approach?"
   ```

2. **Generate with Cursor:**
   ```
   "Create PaymentView following our patterns"
   ```

3. **Complete with Copilot:**
   ```swift
   // Fill in the service methods
   ```

## AI Anti-Patterns to Avoid

### ❌ Don't Accept Without Review

Even with Construct, review AI suggestions:
```swift
// AI might suggest:
class Service {
    static let shared = Service()  // ❌ We use dependency injection
}
```

### ❌ Don't Skip Construct Tools

```bash
# Bad workflow
AI: "Here's the code"
You: *paste and commit*

# Good workflow  
AI: "Here's the code"
You: construct-check  # Verify it follows patterns
You: git commit       # Hooks ensure quality
```

### ❌ Don't Let AI Drive Architecture

```
❌ "AI, design my app architecture"
✅ "AI, implement this feature following our architecture"
```

## Advanced AI Features

### Dynamic Rule Export

```bash
# Export current state as rules
construct-export --format yaml

# Output includes:
# - Recent patterns
# - Team conventions  
# - Current violations to avoid
# - Performance benchmarks
```

### AI-Friendly Documentation

CLAUDE.md sections designed for AI:
- **Common AI Mistakes** - Prevents bad suggestions
- **Where Code Belongs** - Clear boundaries
- **Pattern Library** - Copy/paste examples
- **Anti-Patterns** - What not to do

### Context Preservation

The session summary includes:
- What you were working on
- Decisions made
- Problems solved
- Next steps

AI in next session continues seamlessly.

## Measuring AI Effectiveness

### Before Construct
- AI suggests anti-patterns
- Inconsistent code style
- Architecture drift
- Manual review needed

### With Construct
- AI follows your patterns
- Consistent suggestions
- Architecture enforced
- Automatic validation

### Metrics to Track
```bash
# See AI impact
construct-learn --ai-metrics

# Shows:
# - Acceptance rate of AI suggestions
# - Violations caught from AI code
# - Time saved with AI assistance
```

## Tips for Success

### 1. Keep Context Fresh
```bash
# Start of day
construct-update

# After merges
construct-update

# Before AI sessions
construct-update
```

### 2. Teach AI Your Patterns
```bash
# Document decisions
git commit -m "feat: Add caching

DECISION: Use actor pattern for thread-safe cache"

# AI learns and follows
```

### 3. Use AI for Discovery
```
"What components exist for user profiles?"
"Show me our button styles"
"What's our error handling pattern?"
```

### 4. Let AI Enforce Standards
```
"Review this PR for architecture compliance"
"Does this follow our MVVM pattern?"
"Check accessibility in this view"
```

## Common Issues

### AI Suggests Old Patterns

**Solution:** Update context
```bash
construct-update
construct-export --cursor  # Or your AI tool
```

### AI Ignores Project Structure

**Solution:** Be explicit
```
"Create this in Template/iOS-App/Features/..."
"Follow our TaskListView example"
```

### AI Generates Violations

**Solution:** Always verify
```bash
construct-check
construct-protect
```

## The Future of AI + Construct

### Coming Soon
- Real-time AI feedback in IDE
- Automatic PR reviews
- AI-generated tests
- Pattern learning from team

### Your Feedback Matters
- What AI tools do you use?
- What patterns should AI enforce?
- How can we improve integration?

## Conclusion

Construct makes AI a true development partner:
- AI understands your architecture
- Suggestions follow your patterns
- Quality is automatically enforced
- Context is never lost

The combination of human creativity, AI assistance, and Construct's enforcement creates a development environment where great code is inevitable.

**Trust The Process - and let AI help you follow it.**

---

Next: Explore [Architecture Patterns](../architecture/mvvm-swift6.md) to understand what AI is enforcing.