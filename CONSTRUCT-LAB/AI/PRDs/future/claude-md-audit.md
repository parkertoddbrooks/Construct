# CLAUDE.md Audit Report

## Overview
This audit analyzes all four existing CLAUDE.md files to identify:
1. Universal content that belongs in CLAUDE-BASE.md
2. Language-specific content for pattern plugins
3. CONSTRUCT-specific content for construct-dev plugin
4. Unique content in each file

## File Analysis

### 1. CONSTRUCT-CORE/CLAUDE-BASE.md
**Purpose**: Universal development principles (already exists)
**Size**: ~50 lines
**Status**: Good foundation, needs enhancement

**Universal Content (Keep/Enhance)**:
- ✅ Foundation Rules (never break tests, document why, error handling)
- ✅ Universal Anti-patterns (hardcoded values, silent failures)
- ✅ Multi-Context Awareness concept
- ✅ Pattern System Overview structure
- ✅ Base Patterns concept

**Needs Enhancement**:
- Add injection points for pattern content
- Add more universal principles (version control, testing)
- Structure for dynamic sections

### 2. CONSTRUCT-CORE/CLAUDE.md
**Purpose**: Swift/iOS template for user projects
**Size**: ~860 lines
**Status**: Heavily iOS-specific, needs complete extraction

**iOS/Swift-Specific Content (Extract to patterns/plugins/languages/swift/)**:
- ❌ Swift 6 Concurrency Rules
- ❌ State Management (MVVM) with SwiftUI specifics
- ❌ Modern SwiftUI patterns (iOS 15+)
- ❌ Swift Performance Patterns
- ❌ SwiftUI Accessibility Requirements
- ❌ Swift/SwiftUI code examples
- ❌ iOS Configuration Rules (Info.plist, Xcode)
- ❌ Swift-specific anti-patterns

**Universal Content (Move to CLAUDE-BASE.md)**:
- ✅ "ENFORCE THESE RULES" concept (make language-agnostic)
- ✅ Architecture validation concept
- ✅ Quick commands structure
- ✅ Auto-updated sections concept
- ✅ Pattern library structure

**Dynamic Sections (Keep structure, make content pattern-driven)**:
- <!-- START:CURRENT-STRUCTURE -->
- <!-- START:SPRINT-CONTEXT -->
- <!-- START:RECENT-DECISIONS -->
- <!-- START:PATTERN-LIBRARY -->
- <!-- START:ACTIVE-PRDS -->
- <!-- START:VIOLATIONS -->
- <!-- START:WORKING-LOCATION -->

### 3. CONSTRUCT/CLAUDE.md (Root)
**Purpose**: Created by /init, current CONSTRUCT development guide
**Size**: ~300 lines
**Status**: Good overview, will be enhanced by patterns

**Content Analysis**:
- ✅ Architecture Overview - Keep as base
- ✅ Key Concepts - Keep as base
- ✅ Quick Start - Make pattern-driven
- ✅ Pattern System explanation - Keep as base
- ✅ Common tasks - Make pattern-driven

**What Happens to This**:
- Becomes the target for two-stage init
- Gets enhanced with construct-dev patterns
- No manual editing after enhancement

### 4. CONSTRUCT-LAB/CLAUDE.md
**Purpose**: CONSTRUCT development context
**Size**: ~865 lines
**Status**: Rich with CONSTRUCT-specific patterns

**CONSTRUCT-Specific Content (Extract to patterns/plugins/tooling/construct-dev/)**:
- ❌ Symlink and Promotion Rules
- ❌ Shell/Python Architecture Rules
- ❌ CONSTRUCT-Specific Rules
- ❌ Modern Shell Scripting Rules
- ❌ Quality Gate Rules
- ❌ Validated Discoveries (CONSTRUCT-specific)
- ❌ Pattern Library (Shell script templates)
- ❌ LAB-to-CORE Promotion patterns
- ❌ CONSTRUCT Architecture Truths

**Universal Concepts (Move to CLAUDE-BASE.md)**:
- ✅ Before Writing ANY Code concept
- ✅ Development Process Discoveries structure
- ✅ Quick Commands concept
- ✅ AI Architectural Guidance structure

**Dynamic Sections (Same as CORE/CLAUDE.md)**:
- All auto-updated sections

## Content Mapping Plan

### To CLAUDE-BASE.md (Universal)
```markdown
# Development Context
{{CONSTRUCT:HEADER}}

## Core Principles
- Never break existing functionality
- Document why, not what
- Error handling is mandatory
- Security first
- Performance awareness
- Version control best practices
- Testing philosophy

## Pattern System
{{CONSTRUCT:PATTERNS}}

## Development Guidelines
{{CONSTRUCT:GUIDELINES}}

## Architecture Rules
{{CONSTRUCT:ARCHITECTURE}}

## Quick Commands
{{CONSTRUCT:COMMANDS}}

## Project Structure
{{CONSTRUCT:STRUCTURE}}

## Current Context
{{CONSTRUCT:CONTEXT}}

## AI Guidance
{{CONSTRUCT:AI_GUIDANCE}}
```

### To patterns/plugins/languages/swift/
- All Swift syntax rules
- iOS configuration guidelines
- SwiftUI patterns
- MVVM implementation details
- Swift-specific examples
- Performance patterns
- Accessibility requirements

### To patterns/plugins/platform/ios/
- Xcode configuration
- Info.plist guidelines
- Device orientation rules
- App permissions
- Launch screen setup

### To patterns/plugins/tooling/construct-dev/
- Symlink management
- LAB-to-CORE promotion
- Dual-environment architecture
- Shell scripting standards
- CONSTRUCT-specific workflows
- Development discoveries
- Before-coding validation

### To patterns/plugins/architecture/mvvm/
- Generic MVVM principles
- View/ViewModel separation
- State management patterns
- Business logic placement

## Key Insights

1. **Heavy Duplication**: All files have similar auto-updated sections
2. **iOS Bias**: CORE/CLAUDE.md is 80% iOS-specific
3. **Good Structure**: Dynamic sections concept is solid
4. **Clear Separation**: Easy to identify what's universal vs specific

## Migration Priority

1. **High Priority**:
   - Extract Swift/iOS content from CORE/CLAUDE.md
   - Extract CONSTRUCT-dev content from LAB/CLAUDE.md
   - Enhance CLAUDE-BASE.md with universal sections

2. **Medium Priority**:
   - Create pattern plugins
   - Build two-stage init system
   - Update scripts to work with new structure

3. **Low Priority**:
   - Archive old files
   - Update documentation
   - Create migration tools

## Next Steps

1. Create enhanced CLAUDE-BASE.md with injection points
2. Create construct-dev pattern plugin
3. Create swift pattern plugin
4. Build construct-init script
5. Test two-stage initialization