# PRD: CONSTRUCT Template Repository System
**The Self-Enforcing Swift Architecture Foundation**

**Date**: 2025-06-30  
**Version**: 3.0  
**Status**: Active Development

## Executive Summary

CONSTRUCT is a GitHub template repository that provides a complete AI-powered Swift development foundation. Users get immediate access to production-ready architecture, AI integration tools, and self-enforcing quality standards through the Pentagram Construct system - all personalized with a single setup command.

## Vision Statement

"Every Swift developer should start from a position of strength, with architecture that enforces itself, AI tools that understand their codebase, and quality standards that prevent technical debt before it begins."

## Problem Statement

### Current Developer Pain Points

1. **Starting From Scratch Fatigue**
   - Every new project rebuilds basic architecture
   - Hours spent on boilerplate setup
   - Inconsistent patterns across projects

2. **Architecture Drift Crisis**
   - Good intentions degrade into technical debt
   - Manual enforcement fails at scale
   - Code reviews catch issues too late

3. **AI Tool Limitations**
   - AI suggests anti-patterns without project context
   - Lost context between development sessions
   - No understanding of project-specific patterns

4. **Swift 6 Adoption Barriers**
   - Modern concurrency patterns unclear
   - Migration complexity overwhelming
   - Legacy patterns persist

5. **Quality Inconsistency**
   - Accessibility treated as afterthought
   - Performance issues discovered late
   - Manual quality checks missed

## Solution: Repository-as-Product

### Core Concept

CONSTRUCT **IS** the product users get. No template extraction, no copying files - the repository itself becomes their personalized development foundation.

**User Flow:**
1. Click "Use this template" on GitHub
2. Clone their new repository
3. Run `./construct-setup` (personalizes USER-PROJECT/)
4. Start building with full CONSTRUCT ecosystem

### Repository Structure

```
CONSTRUCT/                          # What users get
├── CONSTUCT-DEV/                  # Template development
│   ├── Templates/                 # Source templates
│   │   ├── AI/                   # AI tools templates
│   │   └── iOS-App/              # Xcode project template
│   └── AI/todo/                   # Development tasks
├── CONSTUCT-DOCS/                 # Documentation
├── USER-PROJECT/                  # User's workspace
│   ├── AI/                       # Personalized AI tools
│   ├── CLAUDE.md                 # Project context
│   └── scripts/                  # Development scripts
├── construct-setup                # Personalization script
└── README.md                     # User-facing docs
```

## Core Features

### 1. Instant Personalization

**Setup Process:**
```bash
./construct-setup
> What is the name of your project? MyAwesomeApp
✓ Updated USER-PROJECT/CLAUDE.md with project context
✓ Created USER-PROJECT/MyAwesomeApp.xcodeproj from templates
✓ Installed shell aliases (pointing to USER-PROJECT/)
✓ Made USER-PROJECT/scripts/ executable
✓ Setup complete! Start building: cd USER-PROJECT/
```

**Result:**
- Personalized Xcode project with proper naming
- AI context file with project-specific information
- Executable development scripts
- Shell aliases for workflow commands

### 2. Pentagram Construct System

#### Vision (PRD-Driven Development)
- Product requirements drive architecture decisions
- Sprint goals visible in AI context
- Can't accidentally build wrong features
- Requirements enforced at commit time

#### Memory (Living Documentation)
- CLAUDE.md updates automatically with project state
- Never loses context between sessions
- AI always knows current patterns and decisions
- Documentation that's always current

#### Prediction (Pre-Code Guidance)
- Shows existing components before creating new ones
- Suggests reusable patterns from codebase
- Prevents duplicate code and violations
- AI understands project structure

#### Protection (Automated Enforcement)
- Git hooks prevent architecture violations
- Quality gates enforced at commit time
- Can't merge code that breaks patterns
- Swift 6 compliance required

#### Learning (Pattern Evolution)
- Extracts patterns from actual codebase
- Tracks violations and improvements over time
- System gets smarter as project grows
- Evolves with development decisions

### 3. AI-Native Development

**Enhanced CLAUDE.md Features:**
- Project-specific architectural guidance
- Real-time violation tracking
- Component discovery system
- Session continuity at 90% context
- Multi-AI platform compatibility

**Prevents Common AI Mistakes:**
- Business logic in Views
- @State for business data
- Direct service access from Views
- Configuration hardcoded in Swift

### 4. Production-Ready Foundation

**Swift 6 Patterns:**
- @MainActor for all ViewModels
- Modern async/await throughout
- Proper actor isolation
- Sendable conformance

**Professional UI Standards:**
- Background flash prevention patterns
- Accessibility built-in from day one
- Responsive design token system
- Performance optimization patterns

### 5. Development Workflow

**Shell Commands (all point to USER-PROJECT/):**
```bash
construct-check      # Architecture compliance
construct-new        # Create features from templates  
construct-update     # Refresh AI documentation
construct-before     # Pre-coding guidance
construct-session    # Context preservation at 90%
```

## Technical Architecture

### Template Repository Benefits

**For Users:**
- Clean, disconnected project from day one
- No CONSTRUCT development artifacts
- Full ownership of their codebase
- Standard git workflow for their project

**For Contributors:**
- Clear separation of concerns
- Standard fork/PR workflow for CONSTRUCT improvements
- No confusion about where code belongs
- Focus on infrastructure development

### Setup Script Responsibilities

**Current Issues to Solve:**
1. Missing ConstructTemplate.xcodeproj in templates
2. Shell aliases need to point to USER-PROJECT/
3. Personalization should be in-place, not copying
4. Must work for template users (not CONSTRUCT development)

**Setup Script Must:**
- Ask for project name
- Update USER-PROJECT/CLAUDE.md with project context
- Create USER-PROJECT/{ProjectName}.xcodeproj from CONSTUCT-DEV/Templates/
- Set up shell aliases pointing to USER-PROJECT/
- Make USER-PROJECT/scripts/ executable
- Keep USER-PROJECT/ directory name unchanged

### Directory Strategy

**CONSTUCT-DEV/**: Template development only
- Templates for AI tools and Xcode projects
- Development todos and documentation
- Infrastructure for CONSTRUCT itself

**USER-PROJECT/**: User's development workspace
- Gets personalized by setup script
- Where users build their applications
- Contains their project-specific AI context

**Root Level**: Clean project interface
- User-facing documentation
- Setup script
- Standard open-source files

## Implementation Requirements

### Phase 1: Core Setup (Critical)

**Missing Components:**
1. **ConstructTemplate.xcodeproj**
   - Create complete Xcode project template in CONSTUCT-DEV/Templates/iOS-App/
   - Include all Swift files from current structure
   - Proper iOS 15.0+ configuration
   - Swift 6 language settings

2. **Setup Script Enhancement**
   - Update construct-setup to work with new structure
   - Implement project name collection and replacement
   - Create Xcode project from template
   - Set up USER-PROJECT/ personalization

3. **Shell Alias Configuration**
   - All aliases must point to USER-PROJECT/ directory
   - Scripts must be made executable during setup
   - Commands must work from any directory

### Phase 2: AI Integration

4. **CLAUDE.md Template**
   - Create comprehensive template in CONSTUCT-DEV/Templates/AI/
   - Include project-specific placeholder replacement
   - Architectural guidance specific to user's project

5. **Script Development**
   - Implement missing scripts referenced by aliases
   - Focus on USER-PROJECT/ context awareness
   - Quality and architecture checking tools

### Phase 3: GitHub Template Setup

6. **Repository Configuration**
   - Enable GitHub template repository
   - Update README for template usage
   - Create CONTRIBUTING.md for CONSTRUCT development
   - Branch protection for quality control

## Success Criteria

### User Experience
- [ ] Template users get working project in under 5 minutes
- [ ] No CONSTRUCT development artifacts in user projects
- [ ] All construct-* commands work immediately after setup
- [ ] AI context properly personalized for user's project

### Developer Experience  
- [ ] CONSTRUCT contributors have clear development path
- [ ] Template development isolated from user experience
- [ ] Easy to test changes without affecting template users

### Technical Quality
- [ ] Setup script completes without errors
- [ ] Generated Xcode project opens and builds
- [ ] All shell aliases functional
- [ ] AI integration working from day one

## Differentiation

### vs Traditional Templates
- **Traditional**: Copy files, user modifies
- **CONSTRUCT**: Repository IS the product, minimal personalization

### vs Framework Libraries
- **Libraries**: External dependency
- **CONSTRUCT**: Full ownership, no dependencies

### vs Manual Setup
- **Manual**: Hours of configuration
- **CONSTRUCT**: 5-minute personalized setup

## Benefits

### For Users
1. **Immediate Productivity**: Ready-to-build foundation
2. **Architecture Confidence**: Self-enforcing patterns
3. **AI Partnership**: Tools that understand their codebase
4. **Professional Quality**: Production-ready standards
5. **Future-Proof**: Swift 6 and modern patterns

### For CONSTRUCT
1. **Clean Separation**: Template vs development concerns
2. **Standard Workflow**: Familiar GitHub patterns
3. **Easy Contribution**: Clear infrastructure focus
4. **Quality Control**: Template integrity maintained

### For Swift Community
1. **Raises Standards**: Better default architecture
2. **AI Integration**: Better tooling cooperation
3. **Knowledge Sharing**: Best practices encoded
4. **Time Savings**: Faster project starts

## Risks & Mitigations

### Risk: Template Contamination
**Mitigation**: Clear directory separation, automated testing

### Risk: User Confusion
**Mitigation**: Clear documentation, example workflows

### Risk: Maintenance Burden
**Mitigation**: Automated updates, community contributions

## Timeline

### Week 1: Foundation
- [ ] Create ConstructTemplate.xcodeproj
- [ ] Update construct-setup script
- [ ] Test basic personalization flow

### Week 2: Integration
- [ ] Implement missing AI scripts
- [ ] Shell alias configuration
- [ ] CLAUDE.md template system

### Week 3: Polish
- [ ] GitHub template repository setup
- [ ] Documentation updates
- [ ] User experience testing

### Week 4: Launch
- [ ] Community feedback integration
- [ ] Final testing and validation
- [ ] Public release preparation

## Call to Action

**For Users**: "Stop starting from zero. Get a production-ready Swift foundation with AI integration in 5 minutes."

**For Contributors**: "Help build the future of Swift development. Contribute to infrastructure that helps thousands of developers."

**For the Community**: "Raise the standard for Swift project foundations. Make good architecture the default, not the exception."

---

**Repository**: Will become GitHub template  
**Target Launch**: Q3 2025  
**Success Metric**: 1,000 template uses in first 6 months