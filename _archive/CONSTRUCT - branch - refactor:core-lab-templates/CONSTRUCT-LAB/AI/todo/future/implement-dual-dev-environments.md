# Implement Dual Development Environments

## Overview
Create parallel AI-assisted development workflows for both CONSTRUCT-dev/ (shell/Python) and USER-project-files/ (Swift) with identical patterns but domain-specific intelligence.

## Goal
Both directories should be self-aware development environments with auto-updating AI context and intelligent workflow scripts.

## CURRENT STATUS & NEXT STEPS

### ✅ COMPLETED Phase 1: CONSTRUCT-dev Scripts (4/9 done)
**ALL scripts working and tested**:
- [x] `update-context.sh` - ✅ WORKING: Auto-updates CONSTRUCT dev context
- [x] `check-architecture.sh` - ✅ WORKING: Validates shell patterns, finds real issues  
- [x] `before_coding.sh` - ✅ WORKING: Searches existing functions before creating
- [x] `session-summary.sh` - ✅ WORKING: Creates CONSTRUCT dev session summaries

### 🚧 IMMEDIATE NEXT: Complete CONSTRUCT-dev Scripts (5 remaining)
**SOURCE**: `/USER-project-files/AI/scripts/` → adapt for CONSTRUCT development

**PRIORITY ORDER**:
1. [ ] `check-accessibility.sh` → `check-documentation.sh` (documentation coverage)
2. [ ] `scan_mvvm_structure.sh` → `scan_construct_structure.sh` (populates /AI/structure/)
3. [ ] `check-quality.sh` → adapt for shell script quality  
4. [ ] `setup-aliases.sh` → CONSTRUCT development aliases
5. [ ] `update-architecture.sh` → CONSTRUCT architecture docs

### Phase 2: USER-project-files Scripts (CLEAN UP - 9 scripts)
**TASK**: Remove RUN-specific hardcoded paths, make CONSTRUCT-generic

### Phase 2: USER-project-files Scripts (CLEAN UP)
**TASK**: Remove RUN-specific hardcoded paths, make CONSTRUCT-generic

**Scripts to Clean**:
- [ ] `update-context.sh` - Remove `/RUN/xcode/RUN` paths, make USER-project-files aware
- [ ] `check-architecture.sh` - Make Swift MVVM generic for any CONSTRUCT project
- [ ] `check-accessibility.sh` - Generic Swift accessibility checking
- [ ] `check-quality.sh` - Generic Swift quality gates
- [ ] `scan_mvvm_structure.sh` - Generic Swift MVVM analysis
- [ ] `session-summary.sh` - Generic Swift project sessions
- [ ] `setup-aliases.sh` - CONSTRUCT user aliases
- [ ] `update-architecture.sh` - Generic Swift architecture docs
- [ ] `before_coding.sh` - Generic Swift component search
  - Suggest reusable patterns
  - Prevent duplicate implementations

- [ ] Create `USER-project-files/scripts/session-summary.sh`
  - Generate Swift development session summaries
  - Preserve context for user project work
  - Track feature development progress

### Phase 3: Cross-Environment Integration
- [ ] Create `CONSTRUCT-dev/AI/scripts/analyze-user-project.sh`
  - Analyze USER-project-files/ from CONSTRUCT development perspective
  - Extract patterns for template improvements
  - Check template-user alignment
  - Generate insights for CONSTRUCT enhancement

- [ ] Implement dual-context update
  - Single command that updates both environments
  - Maintains separation but allows coordination
  - Cross-references improvements and discoveries

### Phase 4: Auto-updating CLAUDE.md Files
- [ ] Implement auto-sections in `CONSTRUCT-dev/AI/CLAUDE.md`
  - Current CONSTRUCT development state
  - Shell script quality metrics
  - Library function usage
  - Template integrity status
  - Recent development decisions

- [ ] Implement auto-sections in `USER-project-files/CLAUDE.md`
  - Swift project architecture state
  - Component counts and patterns
  - MVVM compliance status
  - Design system usage
  - Recent feature development

### Phase 5: Shell Aliases and Integration
- [ ] Create construct-dev aliases for CONSTRUCT-dev workflow
  ```bash
  alias construct-dev-update="./CONSTRUCT-dev/AI/scripts/update-context.sh"
  alias construct-dev-check="./CONSTRUCT-dev/AI/scripts/check-architecture.sh"
  alias construct-dev-before="./CONSTRUCT-dev/AI/scripts/before_coding.sh"
  ```

- [ ] Update existing construct aliases for USER-project-files
  ```bash
  alias construct-update="./USER-project-files/scripts/update-context.sh"
  alias construct-check="./USER-project-files/scripts/check-architecture.sh" 
  alias construct-before="./USER-project-files/scripts/before_coding.sh"
  ```

## Success Criteria

### Functional Requirements
- [ ] Both environments have identical workflow patterns
- [ ] CLAUDE.md files auto-update with relevant context
- [ ] Scripts understand their respective domains (shell vs Swift)
- [ ] Cross-environment analysis works without contamination
- [ ] Developers can work on CONSTRUCT and user projects simultaneously

### Quality Requirements
- [ ] Scripts follow established error handling patterns
- [ ] Configuration-driven validation (using config/ YAML files)
- [ ] Proper testing for all new scripts
- [ ] Documentation for dual-environment workflow

### User Experience
- [ ] Clear separation between CONSTRUCT dev and user dev contexts
- [ ] Intuitive command naming and aliasing
- [ ] Helpful error messages and guidance
- [ ] Consistent output formatting across environments

## Benefits

1. **Recursive Improvement**: CONSTRUCT improves itself using its own methodology
2. **Domain Expertise**: Each environment understands its architectural patterns
3. **Consistent Experience**: Same workflow, different domains
4. **Meta-Development**: Build CONSTRUCT infrastructure with CONSTRUCT tools
5. **Clear Separation**: No confusion about development context

## Implementation Notes

- Use existing lib/ functions where possible
- Follow configuration-driven approach with YAML files
- Ensure scripts work from any directory (proper path resolution)
- Test with both CONSTRUCT development and user scenarios
- Document new patterns for community contributors

## Timeline

- **Week 1**: Phase 1 (CONSTRUCT-dev scripts)
- **Week 2**: Phase 2 (USER-project-files scripts)  
- **Week 3**: Phase 3 (Cross-environment integration)
- **Week 4**: Phase 4 (Auto-updating contexts)
- **Week 5**: Phase 5 (Aliases and polish)

This creates the foundation for truly intelligent, self-aware development environments that understand their respective domains while working together seamlessly.