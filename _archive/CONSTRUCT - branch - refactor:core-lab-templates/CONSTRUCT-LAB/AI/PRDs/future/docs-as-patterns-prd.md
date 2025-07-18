# PRD: Documentation as Patterns

## Overview
Enable SDK and third-party documentation to be seamlessly integrated into CONSTRUCT's pattern system using a simple naming convention, extending CONSTRUCT's dynamic context assembly to include reference material exactly when developers need it.

## Problem Statement
Developers using CONSTRUCT need SDK documentation in their context when working with third-party integrations. Currently, they must manually search and paste relevant docs, breaking the flow and adding friction to development with AI assistants. This contradicts CONSTRUCT's vision of "context > prompts" where the right information should automatically appear based on what you're doing.

## Solution
Use the existing pattern system with a `.docs.md` naming convention to automatically load relevant SDK documentation based on context triggers, treating docs as specialized patterns that provide reference material rather than enforceable rules.

## Strategic Alignment
This feature directly supports CONSTRUCT's core philosophy:
- **Dynamic > Static**: Docs load based on current work, not manual inclusion
- **Context Engineering**: Fills context window with precisely needed SDK references
- **Pattern Ecosystem**: Extends the plugin system naturally to documentation
- **Zero Friction**: Eliminates manual doc searching during AI sessions

## Implementation Details

### Directory Structure
```
patterns/integration/
├── stripe/
│   ├── stripe.md          # Integration patterns (existing)
│   ├── stripe.docs.md     # SDK reference docs (new)
│   └── stripe.yaml        # Metadata for both files
├── firebase/
│   ├── firebase.md
│   ├── firebase.docs.md
│   └── firebase.yaml
└── revenuecat/
    ├── revenuecat.md
    ├── revenuecat.docs.md
    └── revenuecat.yaml
```

### Pattern Configuration
The existing YAML files will define triggers for documentation loading:

```yaml
# stripe.yaml
name: stripe
version: 1.0.0
sdk_version: "5.0+"
description: "Stripe integration patterns and SDK documentation"
tags: ["payments", "ios", "swift"]
dependencies: []
triggers:
  # When to load integration patterns
  integration:
    files: ["**/StripeService.swift", "**/PaymentViewModel.swift"]
  # When to load SDK docs
  docs:
    files: ["**/Stripe*.swift", "**/Payment*.swift"]
    mentions: ["stripe.", "PaymentIntent", "Customer", "Subscription"]
    priority: 2  # Lower priority than base patterns
```

### Trigger Types and Behavior

| Trigger Type | Example | When It Loads Docs | Priority |
|--------------|---------|-------------------|----------|
| File Patterns | `**/Stripe*.swift` | When editing matching files | High |
| Mentions | `stripe.`, `PaymentIntent` | When keywords appear in recent changes | Medium |
| Dependencies | If `integration/stripe` is active | Always for base patterns, docs on demand | Low |
| Git Context | Recent commits touching payment code | When working in payment-related areas | Medium |

### Conflict Resolution
When multiple integrations trigger docs loading:
```bash
# Pseudocode for prioritization
if multiple_docs_triggered; then
    # 1. Check file being edited
    prioritize_by_current_file
    
    # 2. Check recent git mentions
    if still_multiple; then
        prioritize_by_git_diff_mentions
    fi
    
    # 3. Use priority scores from YAML
    if still_multiple; then
        sort_by_priority_score
        load_top_2_only  # Prevent context bloat
    fi
fi
```

### Documentation Format Template
All `.docs.md` files should follow this consistent structure for quality and maintainability:

```markdown
# [SDK Name] SDK Patterns

## Overview
Brief description of the SDK and its primary use cases

## Quick Reference
Most commonly used methods and patterns

## [Feature/Category Name]
### Description
What this feature does and when to use it

### Code Example
```swift
// Create a payment intent
let paymentIntent = try await stripe.paymentIntents.create(
    amount: 2000,      // Amount in cents
    currency: "usd",
    metadata: ["order_id": "12345"]
)
```

### Best Practices
- Always handle STPError for Stripe-specific errors
- Use idempotency keys for critical operations
- Store customer IDs, not payment methods

### Common Errors
- `invalid_request_error`: Missing required parameters
- `authentication_error`: Invalid API key
- `rate_limit_error`: Too many requests

### Version-Specific Notes
- v5.0+: Uses async/await patterns
- v4.x: Uses completion handlers (deprecated)
```

This template ensures:
- Consistent structure across all SDK docs
- Quick access to common patterns
- Error handling guidance
- Version compatibility notes
- Easy parsing for future automation

## Step-by-Step Implementation Guide

### Phase 1: Update Pattern Assembly (Day 1)

1. **Modify `assemble-claude.sh`** to recognize `.docs.md` files:
   ```bash
   # In process_plugin function, after loading main pattern:
   if [ -f "$docs_file" ]; then
       echo -e "\n## SDK Documentation\n" >> "$output_file"
       cat "$docs_file" >> "$output_file"
   fi
   ```

2. **Update pattern loading logic** to check triggers:
   - Load main patterns based on `triggers.integration`
   - Load docs patterns based on `triggers.docs`
   - Only include docs when relevant (files match or keywords mentioned)

3. **Test with mock patterns**:
   ```bash
   # Create test pattern
   mkdir -p patterns/integration/test-sdk
   echo "# Test Integration" > patterns/integration/test-sdk/test-sdk.md
   echo "# Test SDK Docs" > patterns/integration/test-sdk/test-sdk.docs.md
   
   # Verify assembly
   construct-patterns regenerate
   grep "Test SDK Docs" CLAUDE.md
   ```

### Phase 2: Create Initial Doc Patterns (Day 2)

1. **Create Stripe documentation pattern**:
   ```bash
   cd CONSTRUCT-LAB/patterns/integration/stripe
   touch stripe.docs.md
   ```

2. **Extract key SDK patterns** from official docs:
   - Payment Intent lifecycle
   - Customer management
   - Subscription handling
   - Error patterns
   - Best practices

3. **Format as actionable patterns**:
   - Include code examples
   - Show common gotchas
   - Provide Swift/iOS specific guidance

### Phase 3: Smart Loading Implementation (Day 3)

1. **Enhance context detection** in `assemble-claude.sh`:
   ```bash
   # Check if working on payment files
   if find . -name "*.swift" -newer "$CLAUDE_MD" | grep -qE "(Stripe|Payment)"; then
       include_stripe_docs=true
   fi
   
   # Handle false positives
   # Exclude generic names like PaymentHelper unless they import Stripe
   if [ "$include_stripe_docs" = true ]; then
       if ! grep -r "import Stripe" --include="*.swift" .; then
           include_stripe_docs=false
       fi
   fi
   ```

2. **Add mention detection with context**:
   ```bash
   # Check recent git changes for SDK mentions
   if git diff --cached | grep -qE "stripe\.|PaymentIntent|Customer"; then
       include_stripe_docs=true
   fi
   
   # Also check current working file
   if [ -n "$CLAUDE_CURRENT_FILE" ]; then
       if grep -qE "stripe\.|PaymentIntent" "$CLAUDE_CURRENT_FILE"; then
           include_stripe_docs=true
       fi
   fi
   ```

3. **Implement selective loading with analytics**:
   - Only load docs when triggers match
   - Keep base patterns always active
   - Add docs at end of context for easy reference
   - Log usage for pattern learning:
   ```bash
   # Track doc usage for self-improvement
   if [ "$include_stripe_docs" = true ]; then
       echo "$(date): stripe-docs loaded" >> .construct/analytics/doc-usage.log
   fi
   ```

### Phase 4: Testing & Validation (Day 4)

1. **Create comprehensive test scenarios**:
   ```bash
   # Scenario 1: Working on Stripe integration
   touch PaymentService.swift
   echo "import Stripe" >> PaymentService.swift
   construct-patterns regenerate
   # Verify: Stripe docs should be included
   
   # Scenario 2: Working on unrelated feature  
   touch UserProfile.swift
   construct-patterns regenerate
   # Verify: Stripe docs should NOT be included
   
   # Scenario 3: False positive test
   touch PaymentHelper.swift  # Generic name
   construct-patterns regenerate
   # Verify: Stripe docs NOT included without import
   
   # Scenario 4: Multiple SDK conflict
   touch StripeService.swift FirebaseAnalytics.swift
   construct-patterns regenerate
   # Verify: Both docs loaded with proper prioritization
   ```

2. **AI interaction testing**:
   - Query: "How do I create a PaymentIntent?"
   - Verify: AI references the loaded Stripe docs correctly
   - Query: "What's the error handling pattern?"
   - Verify: AI uses the Common Errors section from docs
   - Track response quality metrics

3. **Performance and scalability testing**:
   - Measure CLAUDE.md size with/without docs
   - Test with large docs (>10k lines)
   - Ensure assembly time <2 seconds
   - Verify no impact on non-integration work
   - Set context size limits:
   ```bash
   # Prevent context bloat
   MAX_DOC_SIZE=5000  # lines
   if [ $(wc -l < "$docs_file") -gt $MAX_DOC_SIZE ]; then
       # Load summary version instead
       use_summary_docs=true
   fi
   ```

### Phase 5: Documentation Tool & Pattern Learning (Future)

**Initial Implementation**: Basic doc management
```bash
# Future tool specifications:
construct-docs create stripe --from-url https://stripe.com/docs/api
construct-docs update stripe --version 5.0
construct-docs extract firebase --from-repo https://github.com/firebase/firebase-ios-sdk
construct-docs validate stripe  # Check code examples still compile
```

**Tool Architecture**:
- **Input Sources**: URL scraping, GitHub repos, PDF parsing
- **Output Format**: Structured `.docs.md` following template
- **Extraction Logic**: 
  - Identify code examples and their context
  - Extract method signatures and parameters
  - Capture error codes and handling patterns
  - Parse version-specific changes
- **Validation**: Optionally compile code examples to ensure accuracy

**Pattern Learning Integration**:
```bash
# Auto-suggest docs based on usage
construct-patterns analyze
# Output: "Detected 15 uses of Firebase Auth without docs. Add with: construct add docs/firebase-auth"

# Track which docs sections are most accessed
construct-analytics report docs
# Output: "Stripe PaymentIntent section accessed 45 times this week"
```

## Success Criteria & Metrics

### Quantitative Metrics
1. **Performance Impact**: Assembly time remains <2 seconds
2. **Context Efficiency**: Docs add <20% to CLAUDE.md size when loaded
3. **Accuracy**: >90% precision in loading relevant docs (no false positives)
4. **Developer Time Saved**: 80% reduction in manual doc searching
5. **Adoption Rate**: 50% of projects using SDK integrations adopt docs patterns within first month

### Qualitative Goals
1. **Zero new infrastructure** - Uses existing pattern system
2. **Context-aware loading** - Docs only appear when relevant
3. **Simple format** - Plain markdown, no complex structure
4. **Easy maintenance** - Update docs by editing text files
5. **AI Response Quality** - Measurable improvement in SDK-related queries

## Validation Requirements

### Core Validation Philosophy
While docs are primarily read-only reference material, optional validation can enhance quality and enable advanced features.

### Minimal Required Validation
In `check-architecture.sh`:
- `.docs.md` files exist when `.yaml` references them
- File format is valid markdown
- Basic structure follows template

### Optional Advanced Validators
Create as separate tools in pattern directories:
```bash
patterns/integration/stripe/validators/
├── validate-code-examples.sh    # Compile Swift examples
├── validate-api-versions.sh     # Check SDK version compatibility
└── generate-summary.sh          # Create condensed version for large docs
```

Benefits of optional validators:
- **Code Example Validation**: Ensures examples compile with current SDK
- **Version Checking**: Alerts when SDK updates might invalidate docs
- **Summary Generation**: Auto-creates condensed versions for context efficiency

### Integration with Generators
Validators can enable generators:
```bash
# If code examples are valid, generator can create:
patterns/integration/stripe/generators/
├── create-payment-stub.sh       # Generate PaymentIntent boilerplate
├── create-error-handler.sh      # Generate error handling from docs
└── visualize-payment-flow.sh    # Create diagram from docs
```

This approach:
- Maintains Unix philosophy (simple text files)
- Enables optional sophistication
- Ties to README's validator/generator pattern
- Supports future automation

## Rollout Plan & Integration Strategy

### Phase 1: Core Implementation (Week 1)
- Modify `assemble-claude.sh` for `.docs.md` recognition
- Implement basic trigger detection
- Create first doc pattern (Stripe) as proof of concept
- **Integration**: Works with existing `construct-patterns regenerate`

### Phase 2: Pattern Creation (Week 2)
- Create doc patterns for top 5 integrations (Stripe, Firebase, RevenueCat, Mixpanel, Sentry)
- Test trigger accuracy and refine detection logic
- **Integration**: Available via pattern plugin system

### Phase 3: Real-World Testing (Week 3)
- Deploy to 3-5 active projects using these SDKs
- Measure performance impact and false positive rate
- Gather developer feedback on doc quality and relevance
- **Integration**: Community can start creating their own `.docs.md` patterns

### Phase 4: Optimization & Learning (Week 4)
- Refine triggers based on usage analytics
- Implement conflict resolution for multiple SDKs
- Add pattern learning suggestions
- **Integration**: Ties into future pattern analytics dashboard

### Phase 5: Automation Tools (Month 2+)
- Build `construct-docs` extraction tool
- Create validators for code example checking
- Implement auto-update notifications for SDK changes
- **Integration**: Part of broader CLI tool ecosystem

### How This Fits the Pattern Ecosystem
```bash
# Installing docs with patterns
construct add integration/stripe          # Gets stripe.md + stripe.docs.md
construct add integration/stripe --no-docs # Just integration patterns

# Community taps can include docs
construct tap add company/internal
construct add @company/internal-sdk      # Includes private SDK docs

# Future web browser integration
# Pattern browser shows "includes SDK docs" badge
# Can preview doc quality before installing
```

## Open Questions & Edge Cases

### Primary Questions

1. **Default inclusion vs. trigger-based?**
   - **Recommendation**: Only on triggers to avoid context bloat
   - **Rationale**: Aligns with Karpathy's "fill context with just the right information"
   - **Future**: Could add `always_include: true` flag for critical docs

2. **SDK version handling?**
   - **Recommendation**: Start with single version in YAML, manual updates
   - **Evolution Path**: 
     - Phase 1: `sdk_version: "5.0+"` in YAML
     - Phase 2: Multiple versions with subdirectories
     - Phase 3: Auto-detection from package.json/Podfile
   - **Conflict Resolution**: Warn if project uses v4 but docs are v5

3. **Multiple active SDKs?**
   - **Recommendation**: Load top 2 by priority to prevent bloat
   - **Configuration Option**: `max_docs_loaded: 2` in patterns.yaml
   - **Smart Loading**: Prioritize based on current file > recent commits > mentions

### Edge Cases to Consider

4. **Large documentation files?**
   - Create `.docs-summary.md` for quick reference
   - Full docs load only with explicit flag
   - Auto-generate summaries with future tooling

5. **Conflicting information across SDKs?**
   - Example: Both Stripe and PayPal have "Customer" objects
   - Solution: Prefix sections with SDK name in context
   - Future: Namespace awareness in AI responses

6. **Offline/private documentation?**
   - Support local file references in YAML
   - Enable private company taps with internal docs
   - Respect IP and licensing constraints

7. **Non-code documentation?**
   - Architecture diagrams, flow charts, etc.
   - Recommendation: Support markdown-embedded diagrams
   - Future: Generate visualizations from docs

## Summary

This PRD extends CONSTRUCT's dynamic context engineering to SDK documentation through a simple `.docs.md` naming convention. By treating docs as specialized patterns, we enable automatic loading of relevant API references exactly when developers need them, eliminating manual documentation searches during AI-assisted development.

### Key Innovations
- **Zero Infrastructure**: Leverages existing pattern system completely
- **Context-Aware Triggers**: Docs appear based on actual work, not manual inclusion
- **Unix Simplicity**: Just text files with smart loading logic
- **Pattern Learning**: Analytics drive continuous improvement
- **Community Scalable**: Anyone can contribute docs patterns

### Expected Impact
- 80% reduction in time spent searching SDK documentation
- Immediate improvement in AI response quality for integration work
- Natural extension of CONSTRUCT's pattern plugin ecosystem
- Foundation for future automation and intelligence features

This implementation embodies CONSTRUCT's core philosophy: the future of development isn't about editing code, it's about managing context. By making SDK documentation dynamically available based on what you're actually doing, we move closer to truly intelligent development environments.