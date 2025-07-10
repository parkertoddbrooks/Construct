# Pattern Configuration Templates

Contains templates for pattern system configuration files.

## Contents
- `patterns.yaml` - Template for project pattern configuration

## Purpose
When initializing a project with CONSTRUCT patterns, this template is copied to `.construct/patterns.yaml` and customized to specify which patterns are active.

## Usage Flow
1. `construct-patterns init` copies template to project
2. User/script selects appropriate patterns
3. `construct-patterns regenerate` uses config to build CLAUDE.md
4. AI reads generated CLAUDE.md for project-specific context