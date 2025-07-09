# ⚠️ DEVELOPMENT NOTICE

## Script Migration in Progress

**STATUS**: This directory contains the OLD script organization.

**IMPORTANT**: 
- Active development is happening in `/scripts-new/`
- Scripts here are still used by pre-commit hooks and some workflows
- DO NOT update these scripts directly

## Current State:

### What's Using This Directory:
- Pre-commit hooks (`.git/hooks/pre-commit`)
- Some existing workflows
- Legacy references

### Migration Plan:
1. All new development happens in `/scripts-new/`
2. `/scripts-new/` has better organization:
   - `core/` - Core functionality scripts
   - `dev/` - Development workflow scripts
   - `workspace/` - Workspace management scripts
   - `patterns/` - Pattern-specific validators
   - `construct/` - CONSTRUCT-specific tools

3. Once `/scripts-new/` is fully tested, it will replace this directory

## For Developers:

**If you need to update a script:**
1. Check if it exists in `/scripts-new/` first
2. Update the version in `/scripts-new/`
3. DO NOT update the version here unless critical

**If adding new functionality:**
- Always add to `/scripts-new/` in the appropriate subdirectory
- Follow the new organization structure

---
Last Updated: 2025-01-09
Migration Owner: @parker