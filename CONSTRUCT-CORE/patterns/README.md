# CONSTRUCT Pattern System

Root of CONSTRUCT's modular pattern system for generating context-aware CLAUDE.md files.

## Structure
- `plugins/` - Individual pattern files (the actual patterns) organized by category
- `lib/` - Pattern utilities and shared functions (future)
- `templates/` - Configuration templates for projects

## 🚨 CRITICAL: Validator Requirement

**Every pattern plugin MUST have validators**. This is a fundamental CONSTRUCT principle:

- **No pattern without enforcement** - Patterns that can't be validated shouldn't exist
- **Validators prove pattern value** - If rules can't be checked, they're just suggestions
- **Quality assurance** - Validators ensure patterns are actually followed
- **Architectural integrity** - Enforceable patterns maintain system design

## Terminology
- **Pattern System**: The overall framework for managing reusable context
- **Pattern Plugins** (or just "patterns"): Individual .md files containing specific rules and guidelines
- **Pattern Configuration**: The patterns.yaml file that specifies which patterns to use

## Purpose
Pattern plugins are selectively combined based on project needs to generate CLAUDE.md files that provide AI with exactly the right context - no more, no less.

## Used By
- `construct-patterns.sh` - Main pattern management script
- `/init` integration - Enhances Anthropic's init with patterns
- Projects via `.construct/patterns.yaml` configuration