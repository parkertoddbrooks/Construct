# Development Context

{{CONSTRUCT:HEADER}}

## Core Development Principles

These universal principles apply to ALL development work:

### ✅ DO: Foundation Rules
- **Never break existing tests** - Changes must maintain backward compatibility
- **Document why, not what** - Code should be self-explanatory, comments explain reasoning
- **Error handling is mandatory** - All failure modes must be handled gracefully
- **Security first** - Never expose secrets, validate all inputs, follow security best practices
- **Performance awareness** - Consider impact of changes on system performance
- **Version control discipline** - Clear commits, meaningful messages, atomic changes

### ✅ DO: Testing Philosophy
- **Test behavior, not implementation** - Tests should survive refactoring
- **Fast tests run frequently** - Unit tests in milliseconds, integration tests in seconds
- **Test names describe scenarios** - `test_user_cannot_purchase_without_payment_method`
- **One assertion per test** - Each test verifies one specific behavior
- **Test edge cases explicitly** - Empty sets, nulls, boundary values, error conditions
- **Tests as living documentation** - Tests show how code is meant to be used

### ✅ DO: Documentation Standards
- **README explains why** - Why this project exists, what problem it solves
- **Code documents how** - Clear variable names, function signatures
- **Comments explain why** - Why this approach, not what the code does
- **Examples over exposition** - Show usage patterns with working examples
- **Keep docs near code** - Documentation lives where developers work
- **Document decisions** - ADRs (Architecture Decision Records) for significant choices

### ❌ DON'T: Universal Anti-patterns
- Hardcoded values that should be configurable
- Silent failures without error reporting
- Breaking changes without proper versioning
- Security vulnerabilities (exposed secrets, unvalidated inputs)
- Code without proper testing
- Undocumented complex logic
- Copy-paste programming without understanding
- Premature optimization over clarity
- Ignoring error cases ("happy path only")
- Global mutable state
- Deep nesting (arrow anti-pattern)
- Mixed levels of abstraction in one function

### 🔄 DO: Continuous Improvement
- **Patterns over repetition** - Extract common patterns for reuse
- **Automate tedious tasks** - If you do it twice, script it
- **Learn from failures** - Post-mortems without blame
- **Refactor mercilessly** - Leave code better than you found it
- **Measure what matters** - Performance, quality, user satisfaction
- **Iterate based on feedback** - Ship small, learn fast

## Pattern System

{{CONSTRUCT:PATTERNS}}

## Development Guidelines

{{CONSTRUCT:GUIDELINES}}

## Project Structure

{{CONSTRUCT:STRUCTURE}}

## Code Examples

{{CONSTRUCT:EXAMPLES}}

## Quick Commands

{{CONSTRUCT:COMMANDS}}

## Current Context

<!-- START:CURRENT-STRUCTURE -->
### 📊 Current Project State (Auto-Updated)
*Run `construct-update` to populate*
<!-- END:CURRENT-STRUCTURE -->

{{CONSTRUCT:CONTEXT}}

## AI Assistance

{{CONSTRUCT:AI_GUIDANCE}}

---

*This context is dynamically generated based on active patterns. To update, run the appropriate context refresh command for your project.*