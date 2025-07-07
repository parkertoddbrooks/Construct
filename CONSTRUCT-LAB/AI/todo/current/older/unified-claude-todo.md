# TODO: Implement Unified CLAUDE.md System

## Vision
One CLAUDE.md file that serves as the single source of truth for both using CONSTRUCT and developing CONSTRUCT, symlinked everywhere it's needed.

## Current State Analysis
- [ ] Verify current CLAUDE.md locations:
  - [ ] Check `/CONSTRUCT-CORE/CLAUDE.md` exists
  - [ ] Check `/CONSTRUCT-LAB/CLAUDE.md` exists (might be different content currently)
  - [ ] Document any project-specific CLAUDE.md files
  - [ ] Note differences between existing files

## Phase 1: Consolidate Content

### 1.1 Merge Existing CLAUDE.md Files
- [ ] Review CONSTRUCT-LAB/CLAUDE.md for CONSTRUCT development rules
- [ ] Review CONSTRUCT-CORE/CLAUDE.md for project development rules
- [ ] Identify unique content from each
- [ ] Create merged structure that includes both contexts

### 1.2 Create Unified CLAUDE.md Structure
```markdown
# UNIFIED CONSTRUCT CONTEXT

## Universal Principles
- [ ] Core development philosophy
- [ ] Quality standards
- [ ] Documentation requirements

## Project Development Context
- [ ] Swift/iOS patterns (MVVM, SwiftUI best practices)
- [ ] C#/.NET patterns (Clean Architecture, DI)
- [ ] Web patterns (React, TypeScript)
- [ ] Cross-platform considerations

## CONSTRUCT Development Context
- [ ] Symlink management rules
- [ ] Promotion workflow (LAB → CORE)
- [ ] Script modification patterns
- [ ] Testing requirements

## Contextual Intelligence
- [ ] "When working on X, these rules apply" sections
- [ ] File pattern recognition rules
- [ ] Task-based context switching
```

## Phase 2: Implement Symlink Structure

### 2.1 Remove Existing Files
- [ ] Backup current CLAUDE.md files:
  ```bash
  cp CONSTRUCT-LAB/CLAUDE.md CONSTRUCT-LAB/CLAUDE.md.backup
  cp YourProject/CLAUDE.md YourProject/CLAUDE.md.backup
  ```
- [ ] Remove non-source files:
  ```bash
  rm CONSTRUCT-LAB/CLAUDE.md
  rm YourProject/CLAUDE.md
  ```

### 2.2 Create Symlinks
- [ ] Create LAB symlink:
  ```bash
  cd CONSTRUCT-LAB
  ln -s ../CONSTRUCT-CORE/CLAUDE.md ./CLAUDE.md
  ```
- [ ] Create project symlinks:
  ```bash
  cd YourProject
  ln -s ../CONSTRUCT/CONSTRUCT-CORE/CLAUDE.md ./CLAUDE.md
  ```

### 2.3 Update construct-setup.sh
- [ ] Modify setup script to create symlink instead of copying:
  ```bash
  # Instead of: cp $CONSTRUCT_CORE/CLAUDE.md ./
  ln -s $CONSTRUCT_CORE/CLAUDE.md ./CLAUDE.md
  ```

## Phase 3: Content Organization

### 3.1 Smart Sections
- [ ] Add context detection rules:
  ```markdown
  ## Context Detection
  
  ### When you see these patterns, apply these rules:
  - `*.swift`, `*.xcodeproj` → Swift/iOS context
  - `CONSTRUCT/**/*.sh` → CONSTRUCT development context
  - `pre-commit`, `hooks`, `CI/CD` → Infrastructure context
  ```

### 3.2 Living Documentation
- [ ] Add sections that will be updated by automation:
  ```markdown
  ## Current Project State
  <!-- Auto-updated by CONSTRUCT -->
  - Component count: X
  - Last architectural decision: Y
  - Active patterns: Z
  ```

### 3.3 Cross-Cutting Concerns
- [ ] Document how changes propagate:
  ```markdown
  ## System Intelligence
  
  When updating the User model:
  1. C# model in backend-api/Models/User.cs
  2. Swift model in ios-app/Models/User.swift
  3. TypeScript interface in web/types/User.ts
  4. Consider migrations and API versioning
  ```

## Phase 4: Test the System

### 4.1 Verify Symlinks
- [ ] Check all symlinks resolve correctly:
  ```bash
  ls -la CONSTRUCT-LAB/CLAUDE.md
  ls -la YourProject/CLAUDE.md
  ```

### 4.2 Test Claude Code Understanding
- [ ] Open Claude Code in project directory
- [ ] Ask about Swift development (should work)
- [ ] Ask about pre-commit hooks (should understand CONSTRUCT context)
- [ ] Ask about cross-platform updates (should know all layers)

### 4.3 Test Updates
- [ ] Make an update to CONSTRUCT-CORE/CLAUDE.md
- [ ] Verify change appears in all symlinked locations
- [ ] Confirm Claude Code picks up changes

## Phase 5: Document the System

### 5.1 Update README
- [ ] Document the unified context system
- [ ] Explain the symlink architecture
- [ ] Provide examples of how it works

### 5.2 Create Migration Guide
- [ ] For users with existing CONSTRUCT installations
- [ ] For projects with custom CLAUDE.md files
- [ ] For merging custom rules into the unified system

## Phase 6: Future Enhancements

### 6.1 Automated Context Updates
- [ ] Script to update "Current Project State" section
- [ ] Hook into git commits to track decisions
- [ ] Component inventory automation

### 6.2 Context Validation
- [ ] Linter for CLAUDE.md syntax
- [ ] Verify all referenced files exist
- [ ] Check for conflicting rules

## Success Criteria
- [ ] One CLAUDE.md file serves all contexts
- [ ] No manual context switching needed
- [ ] Claude Code understands both project and CONSTRUCT development
- [ ] Updates propagate everywhere automatically
- [ ] System is simpler than before

## Notes
- Keep the backup files until system is proven stable
- Consider versioning CLAUDE.md itself
- Document any custom additions needed for specific projects