# TODO: Implement Living Documentation System

## Overview
Transform static documentation templates into living documents that evolve with the project through real development experience.

## Core Concept
```
Static Docs + Real Development + Auto-Updates = Living Truth
```

## Tasks

### 1. Create Template Starter Documentation
- [ ] Create `TEMPLATES/swift-ios/AI/CLAUDE.md.starter`
  - Basic section structure (no content)
  - Placeholders for discoveries
  - Links to how auto-updates work
  
- [ ] Create `TEMPLATES/swift-ios/AI/docs/initial-best-practices.md`
  - Generic Swift/SwiftUI best practices (like the examples provided)
  - Starting point, not final truth
  
- [ ] Create `TEMPLATES/swift-ios/AI/docs/architecture-guide.md`
  - Initial architecture patterns (MVVM, VIPER, etc.)
  - Template for documenting architectural decisions

### 2. Update construct-setup Script
- [ ] Modify `construct-setup` to:
  - Copy CLAUDE.md.starter → CLAUDE.md
  - Initialize with project name and date
  - Set up auto-update markers
  - Create initial directory structure
  - Guide user to start documenting discoveries

### 3. Create Living Documentation Guide
- [ ] Create `CONSTRUCT-CORE/docs/living-documentation-philosophy.md`
  - Explain the journey from static → living docs
  - Show examples of how generic rules become project truths
  - Document the "why" behind every rule
  - Include examples from RUN project

### 4. Update Existing Documentation
- [ ] Update `CONSTRUCT-LAB/AI/docs/automated/improving-CONSTRUCT-guide-automated.md`
  - Add section on living documentation philosophy
  - Explain how CLAUDE.md evolves with the project
  
- [ ] Update `CONSTRUCT-CORE/README.md`
  - Add philosophy section about living documentation
  - Explain that templates provide structure, not content
  
- [ ] Update `TEMPLATES/swift-ios/README.md` (create if needed)
  - Explain that this is a starting point
  - Guide users to let documentation evolve with their project
  - Link to living documentation philosophy

### 5. Create Example Transformation Documentation
- [ ] Create `CONSTRUCT-LAB/AI/docs/examples/static-to-living-examples.md`
  - Show real examples of how generic rules transform
  - Include before/after from RUN project
  - Document the discoveries that led to each transformation

### 6. Implement Discovery Capture System
- [ ] Create script `CONSTRUCT-CORE/scripts/capture-discovery.sh`
  - Helps users document new discoveries
  - Prompts for the "why" behind rules
  - Adds to appropriate section in CLAUDE.md
  
- [ ] Create script `CONSTRUCT-CORE/scripts/promote-discovery.sh`
  - Promotes validated discoveries to enforcement rules
  - Helps maintain the evolution trail

## Key Principles to Document

1. **Documentation reflects reality, not intentions**
   - Auto-sections show what exists
   - Manual sections show wisdom gained

2. **Every rule has a story**
   - Not just what, but why
   - Include the context of discovery

3. **Templates provide machinery, not content**
   - Structure for capturing truths
   - Tools for maintaining living docs
   - Starting references, not final answers

4. **Evolution is the goal**
   - Static docs are just the beginning
   - Real value comes from development experience
   - Each project builds its own truth

## Success Criteria
- [ ] New users understand that CLAUDE.md will grow with their project
- [ ] Clear examples show the transformation from generic to specific
- [ ] Tools exist to capture and promote discoveries
- [ ] Philosophy is documented and integrated throughout CONSTRUCT

## Notes
- Reference the SwiftCatalyst and RUN examples as "before and after"
- Emphasize that the most valuable documentation is discovered, not prescribed
- Make it clear that CONSTRUCT provides the engine for living documentation