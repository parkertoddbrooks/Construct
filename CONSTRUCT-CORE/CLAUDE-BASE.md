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

### ❌ DON'T: Universal Anti-patterns
- Hardcoded values that should be configurable
- Silent failures without error reporting
- Breaking changes without proper versioning
- Security vulnerabilities (exposed secrets, unvalidated inputs)
- Code without proper testing
- Undocumented complex logic

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