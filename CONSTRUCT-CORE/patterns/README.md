# CONSTRUCT Pattern System

Root of CONSTRUCT's modular pattern system for generating context-aware CLAUDE.md files.

## Structure
- `plugins/` - Individual pattern files (the actual patterns) organized by category
- `lib/` - Pattern utilities and shared functions (future)
- `templates/` - Configuration templates for projects

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