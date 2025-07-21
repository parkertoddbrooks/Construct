# CONSTRUCT Pattern System

Root of CONSTRUCT's AI-native pattern system with Claude SDK integration for generating context-aware CLAUDE.md files.

## Structure
- `plugins/` - Individual pattern files (the actual patterns) organized by 10 categories
- `lib/` - Pattern utilities and shared functions (future)
- `templates/` - Configuration templates for projects

## Enhanced Categorization System

CONSTRUCT now uses a comprehensive 10-category system powered by Claude SDK for intelligent pattern extraction:

- **Core Categories**: architectural/, cross-platform/, frameworks/, languages/, platforms/, tooling/
- **Enhanced Categories**: ui/, performance/, quality/, configuration/

This system can handle comprehensive projects with design tokens, quality gates, and professional standards.

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
- `/init` integration - Enhances Anthropic's init with AI-native patterns
- `init-construct.sh` - Claude SDK-powered intelligent pattern extraction
- Projects via `.construct/patterns.yaml` configuration

## AI-Native Features

- **Intelligent Extraction**: Claude SDK analyzes CLAUDE.md files to detect patterns
- **Category Detection**: Automatically categorizes patterns into appropriate directories
- **Cross-Platform Support**: Bash 3+ compatibility for macOS, Linux, Windows WSL
- **Fallback Handling**: Graceful degradation when Claude SDK is unavailable