# CONSTRUCT Pattern Injection Protocol Specification

## Overview
This document defines how patterns inject content into CLAUDE.md during the two-stage initialization process.

## Injection Points

### Core Injection Points
These markers in CLAUDE-BASE.md are replaced with pattern-specific content:

```markdown
{{CONSTRUCT:HEADER}}         # Project-specific header
{{CONSTRUCT:PATTERNS}}       # List of active patterns
{{CONSTRUCT:GUIDELINES}}     # Pattern-specific guidelines
{{CONSTRUCT:EXAMPLES}}       # Language-specific examples
{{CONSTRUCT:CONTEXT}}        # Dynamic context sections
{{CONSTRUCT:STRUCTURE}}      # Project structure info
{{CONSTRUCT:COMMANDS}}       # Quick command reference
{{CONSTRUCT:AI_GUIDANCE}}    # AI-specific instructions
```

### Pattern Content Structure
Each pattern provides content for injection points:

```
patterns/plugins/languages/swift/
├── injections/
│   ├── guidelines.md      # For {{CONSTRUCT:GUIDELINES}}
│   ├── examples.md        # For {{CONSTRUCT:EXAMPLES}}
│   ├── commands.md        # For {{CONSTRUCT:COMMANDS}}
│   └── ai-guidance.md     # For {{CONSTRUCT:AI_GUIDANCE}}
```

## Injection Process

### 1. Read Phase
```bash
# Read current CLAUDE.md (from /init)
current_content=$(cat CLAUDE.md)

# Read CLAUDE-BASE.md template
base_template=$(cat CLAUDE-BASE.md)

# Read patterns.yaml
patterns=$(parse_patterns patterns.yaml)
```

### 2. Collection Phase
For each active pattern:
1. Check for injection files
2. Collect content by injection point
3. Merge with existing content

### 3. Assembly Phase
```bash
# For each injection point
for marker in {{CONSTRUCT:*}}; do
    # Collect content from all patterns
    content=$(collect_content_for "$marker" "$patterns")
    
    # Replace marker with collected content
    base_template=$(replace_marker "$base_template" "$marker" "$content")
done
```

### 4. Enhancement Phase
```bash
# Preserve any custom content from current CLAUDE.md
custom_sections=$(extract_custom_sections "$current_content")

# Combine base template with custom content
enhanced_content=$(combine "$base_template" "$custom_sections")

# Write enhanced CLAUDE.md
echo "$enhanced_content" > CLAUDE.md
```

## Content Merging Rules

### Pattern Priority
When multiple patterns provide content for the same injection point:
1. Language patterns first
2. Architecture patterns second
3. Tool patterns third
4. Custom rules last

### Content Format
Each pattern's content should be self-contained:
```markdown
## Pattern Name

Content for this pattern...
```

### Conflict Resolution
- No conflicts for list-based content (guidelines, examples)
- For single-value content (header), last pattern wins
- Custom rules always append, never replace

## Dynamic Sections

### Base Template Sections
These sections are part of CLAUDE-BASE.md and populated by update-context.sh:
```markdown
<!-- START:CURRENT-STRUCTURE -->
<!-- END:CURRENT-STRUCTURE -->
```

### Context Injection Sections
These sections are injected via {{CONSTRUCT:CONTEXT}} and populated by update-context.sh:
```markdown
<!-- START:ACTIVE-SYMLINKS -->
<!-- END:ACTIVE-SYMLINKS -->

<!-- START:SPRINT-CONTEXT -->
<!-- END:SPRINT-CONTEXT -->

<!-- START:VIOLATIONS -->
<!-- END:VIOLATIONS -->

<!-- START:WORKING-LOCATION -->
<!-- END:WORKING-LOCATION -->

<!-- START:DOCUMENTATION-LINKS -->
<!-- END:DOCUMENTATION-LINKS -->

<!-- START:ACTIVE-PRDS -->
<!-- END:ACTIVE-PRDS -->
```

### Pattern-Specific Dynamic Sections
Patterns can define their own dynamic sections:
```markdown
<!-- START:PATTERN:swift:examples -->
<!-- END:PATTERN:swift:examples -->
```

## Example: Swift Pattern Injection

### Pattern Structure
```
patterns/plugins/languages/swift/
├── injections/
│   ├── guidelines.md
│   ├── examples.md
│   └── commands.md
```

### guidelines.md
```markdown
## Swift Development Guidelines

### 🚨 ENFORCE THESE RULES
- Always use `guard` for early returns
- Never force unwrap optionals in production
- Prefer `async/await` over completion handlers
```

### examples.md
```markdown
## Swift Code Examples

### Correct MVVM Pattern
\```swift
@MainActor
class ViewModel: ObservableObject {
    @Published var state: State = .initial
}
\```
```

### Result in CLAUDE.md
After injection, these sections appear at their respective markers.

## Implementation Notes

### Phase 1 (Current)
- Simple marker replacement
- Single-level pattern merging
- Basic conflict resolution

### Phase 2 (Future)
- Nested pattern inheritance
- Smart content merging
- Pattern composition

### Phase 3 (Advanced)
- Conditional injections
- Context-aware content
- Dynamic pattern loading

## Testing Protocol

### Unit Tests
1. Test each injection point separately
2. Test pattern loading
3. Test content merging
4. Test conflict resolution

### Integration Tests
1. Test full two-stage init flow
2. Test with multiple patterns
3. Test with conflicting patterns
4. Test regeneration

### User Tests
1. Test with real projects
2. Test error messages
3. Test help documentation
4. Test edge cases

## Error Handling

### Missing Pattern Files
- Warning, not error
- Continue with other patterns
- Log missing patterns

### Invalid Injection Content
- Skip invalid content
- Warning in output
- Continue processing

### Corrupted CLAUDE.md
- Restore from backup
- Clear error message
- Recovery instructions