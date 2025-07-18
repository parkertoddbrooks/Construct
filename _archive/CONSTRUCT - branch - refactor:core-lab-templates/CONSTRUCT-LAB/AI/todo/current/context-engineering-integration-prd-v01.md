# PRD: Context Engineering Integration for CONSTRUCT

## Overview

This PRD defines how CONSTRUCT's existing context engineering system (scripts, auto-sections, pre-commit hooks) integrates with the new pattern system. Following Andrej Karpathy's insight that "context engineering" is the art of filling the context window with just the right information, we must preserve and enhance what already works.

## Problem Statement

The current CONSTRUCT system has evolved sophisticated context engineering:
- Dynamic auto-sections that update with project state
- Pre-commit hooks that refresh context before commits
- Scripts that analyze and report violations
- Session management for context window optimization

The pattern system must enhance, not replace, this context engineering. We need to:
1. Preserve all working scripts and their purposes
2. Integrate pattern generation with dynamic context
3. Maintain the balance of static rules + dynamic state
4. Keep context windows optimized with relevant information

## Goals

### Primary Goals
- Preserve all existing script functionality
- Enhance context engineering with pattern modularity
- Maintain backward compatibility for existing projects
- Create clear migration path that doesn't break workflows
- Document each script's role in context engineering

### Non-Goals
- Not replacing working scripts with pattern system
- Not removing dynamic context capabilities
- Not forcing immediate migration of CONSTRUCT-LAB
- Not breaking existing pre-commit workflows

## Context Engineering Philosophy

### What is Context Engineering?
Per Karpathy: "The delicate art and science of filling the context window with just the right information for the next step."

### CONSTRUCT's Context Layers

1. **Static Context** (Pattern System)
   - Universal principles (CLAUDE-BASE.md)
   - Language-specific patterns
   - Architectural patterns
   - Project-specific rules

2. **Dynamic Context** (Scripts & Auto-sections)
   - Current project structure
   - Recent changes and commits
   - Active violations
   - Git status and branches
   - Session summaries

3. **Tool Context** (Script Outputs)
   - Architecture check results
   - Quality validation findings
   - Documentation coverage
   - Structure scans

4. **Historical Context** (Logs & Summaries)
   - Dev-logs from previous sessions
   - Decision records
   - Migration history

## Script-by-Script Integration Plan

### 1. update-context.sh
**Purpose**: Refreshes auto-sections with current project state
**Context Engineering Role**: Provides real-time project awareness

**Integration**:
- Continue updating auto-sections in CLAUDE.md
- For pattern-based projects, append dynamic sections after generated content
- Add new section markers that pattern system preserves:
  ```markdown
  <!-- START:DYNAMIC-CONTEXT -->
  <!-- END:DYNAMIC-CONTEXT -->
  ```

**Implementation Steps**:
1. Modify assemble-claude.sh to preserve dynamic sections
2. Update update-context.sh to detect pattern-based projects
3. Create hybrid CLAUDE.md structure

### 2. check-architecture.sh
**Purpose**: Validates development patterns and finds violations
**Context Engineering Role**: Provides quality feedback in context

**Integration**:
- Works with both manual and pattern-based CLAUDE.md
- Validates against active patterns
- Results feed into VIOLATIONS auto-section

**Implementation Steps**:
1. Add pattern awareness to architecture checks
2. Validate custom_rules from patterns.yaml
3. Report pattern conflicts

### 3. scan_construct_structure.sh
**Purpose**: Documents current file structure
**Context Engineering Role**: Provides structural awareness

**Integration**:
- Continues to work unchanged
- Output feeds into CURRENT-STRUCTURE section
- Helps identify needed patterns

**Implementation Steps**:
1. No changes needed - works as-is
2. Consider adding pattern suggestions based on structure

### 4. session-summary.sh
**Purpose**: Preserves context across Claude sessions
**Context Engineering Role**: Manages context window continuity

**Integration**:
- Works with both systems
- Captures pattern configuration changes
- Preserves decision rationale

**Implementation Steps**:
1. Add pattern configuration to summary
2. Track pattern evolution decisions

### 5. pre-commit hooks
**Purpose**: Ensures fresh context before commits
**Context Engineering Role**: Maintains context accuracy

**Integration**:
- Continues running all update scripts
- For pattern projects, also validates pattern integrity
- Updates both static and dynamic sections

**Implementation Steps**:
1. Add construct-patterns validate to pre-commit
2. Ensure proper ordering of updates

### 6. check-quality.sh
**Purpose**: Validates code quality standards
**Context Engineering Role**: Provides quality metrics in context

**Integration**:
- Validates against pattern-defined standards
- Reports to VIOLATIONS section
- Works with custom_rules

**Implementation Steps**:
1. Read quality rules from patterns
2. Integrate with pattern-specific standards

### 7. workspace-status.sh
**Purpose**: Shows multi-project status
**Context Engineering Role**: Provides workspace-wide context

**Integration**:
- Shows pattern usage across projects
- Indicates manual vs pattern-based projects
- Tracks migration status

**Implementation Steps**:
1. Add pattern configuration display
2. Show context engineering metrics

## Hybrid CLAUDE.md Structure

For pattern-based projects that need dynamic context:

```markdown
<!-- GENERATED SECTION - DO NOT EDIT -->
# CONSTRUCT Development Context

[Pattern-generated content here]

<!-- END GENERATED SECTION -->

<!-- START:DYNAMIC-CONTEXT -->
<!-- Auto-updated by scripts - changes preserved -->

## 📊 Current Project State
[Auto-updated sections]

## 🎯 Active Sprint Context
[Current work focus]

## ⚠️ Active Violations
[Real-time issues]

<!-- END:DYNAMIC-CONTEXT -->
```

## Migration Strategy

### Phase 1: Create Compatibility Layer
1. Update pattern system to preserve dynamic sections
2. Ensure all scripts work with both formats
3. Test with Projects/TestProject

### Phase 2: Document Script Roles
1. Create CONTEXT-ENGINEERING.md guide
2. Document each script's purpose
3. Explain static vs dynamic context

### Phase 3: Gradual Migration
1. Start with new projects using hybrid approach
2. Migrate existing projects when ready
3. CONSTRUCT-LAB migrates last as proof

### Phase 4: Enhance Context Engineering
1. Add context size optimization
2. Implement relevance scoring
3. Create context debugging tools

## Technical Architecture

### Context Resolution Order
```
1. CLAUDE-BASE.md (universal)
2. Pattern plugins (modular)
3. Custom rules (project-specific)
4. Dynamic sections (real-time)
5. Tool outputs (on-demand)
```

### Context Window Management
- Static patterns: ~30% of context
- Dynamic state: ~20% of context
- Recent changes: ~20% of context
- Tool outputs: ~20% of context
- Reserve: ~10% for conversation

## Success Metrics

1. **Zero Breakage**: All existing scripts continue working
2. **Context Quality**: Better signal-to-noise in CLAUDE.md
3. **Migration Success**: Projects migrate without workflow disruption
4. **Developer Satisfaction**: Context helps not hinders
5. **Performance**: Faster context updates with caching

## Implementation Checklist

### Immediate Actions
- [ ] Copy CONSTRUCT-LAB/CLAUDE.md for backup
- [ ] Create CONTEXT-ENGINEERING.md documentation
- [ ] Update assemble-claude.sh for dynamic sections
- [ ] Test hybrid approach with TestProject

### Script Updates
- [ ] update-context.sh - Add pattern awareness
- [ ] check-architecture.sh - Validate against patterns
- [ ] scan_construct_structure.sh - No changes needed
- [ ] session-summary.sh - Include pattern config
- [ ] pre-commit hooks - Add pattern validation
- [ ] check-quality.sh - Use pattern standards
- [ ] workspace-status.sh - Show pattern usage

### Documentation
- [ ] Context engineering philosophy
- [ ] Script integration guide
- [ ] Migration playbook
- [ ] Pattern + dynamic section examples

## Risks & Mitigations

### Risk: Dynamic sections break pattern system
**Mitigation**: Clear section markers, preserve on regeneration

### Risk: Context becomes too large
**Mitigation**: Context size monitoring, relevance scoring

### Risk: Scripts become too complex
**Mitigation**: Maintain single responsibility, clear interfaces

### Risk: Migration confusion
**Mitigation**: Clear documentation, gradual rollout

## Key Principles

1. **Preserve What Works** - Don't break existing workflows
2. **Enhance Don't Replace** - Pattern system adds to context engineering
3. **Static + Dynamic** - Both types of context are essential
4. **Right Information** - Not all information, just what's needed
5. **Developer First** - Make it easier, not harder

## Next Steps

1. Review and approve this PRD
2. Create backup of CONSTRUCT-LAB/CLAUDE.md
3. Implement Phase 1 compatibility layer
4. Test with Projects/TestProject
5. Document learnings and iterate

---

**Status**: Draft
**Priority**: High (blocks pattern system rollout)
**Complexity**: Medium (mostly integration work)
**Key Innovation**: Preserving context engineering while adding modularity