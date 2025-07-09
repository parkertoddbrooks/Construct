# 🚀 DEVELOPMENT NOTICE

## New Script Organization

**STATUS**: This directory contains the NEW, reorganized scripts.

**IMPORTANT**: 
- This is where active development happens
- Will replace `/scripts/` once migration is complete
- Already has interactive support for Claude Code

## Directory Structure:

```
scripts-new/
├── core/               # Core functionality
│   ├── before_coding.sh
│   ├── check-architecture.sh
│   ├── check-documentation.sh
│   ├── check-quality.sh
│   └── construct-patterns.sh
│
├── dev/                # Development workflows
│   ├── commit-with-review.sh
│   ├── generate-devupdate.sh
│   ├── pre-commit-review.sh
│   ├── session-summary.sh
│   └── setup-aliases.sh
│
├── workspace/          # Workspace management
│   ├── create-project.sh      ✅ Has interactive support
│   ├── import-project.sh      
│   ├── import-component.sh    
│   ├── workspace-status.sh
│   └── workspace-update.sh
│
├── patterns/           # Pattern validators
│   └── {pattern-name}/
│       ├── validate-quality.sh
│       └── validate-architecture.sh
│
└── construct/          # CONSTRUCT-specific
    ├── assemble-claude.sh
    ├── check-symlinks.sh
    ├── scan_project_structure.sh
    ├── update-architecture.sh
    └── update-context.sh
```

## Interactive Support Status:

✅ **Has Interactive Support:**
- `workspace/create-project.sh`

⏳ **Needs Interactive Support:**
- `workspace/import-project.sh`
- `workspace/import-component.sh`
- `dev/generate-devupdate.sh`
- `dev/session-summary.sh`
- Any other scripts with user prompts

## For Developers:

**To add interactive support to a script:**
1. Source the library: `source "$CONSTRUCT_CORE/CONSTRUCT/lib/interactive-support.sh"`
2. Define prompts function: `show_my_prompts() { ... }`
3. Add check: `if should_show_prompts "$@"; then ...`
4. Use `get_input_with_default()` instead of `read`

**Before migrating to `/scripts/`:**
- [ ] All scripts have interactive support
- [ ] All scripts tested in Claude Code
- [ ] Pre-commit hooks updated to use new paths
- [ ] Documentation updated

---
Last Updated: 2025-01-09
Migration Owner: @parker