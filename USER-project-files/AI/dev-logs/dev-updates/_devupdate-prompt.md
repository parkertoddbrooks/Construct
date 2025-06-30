# Dev Update Template & Instructions

## Purpose
Dev Updates serve as comprehensive status reports that combine management visibility with technical handoff documentation. They function as expanded commit messages that enable project tracking and knowledge transfer.

## When to Create
- After completing a feature or significant technical work
- At the end of development sprints or work sessions
- Before handing off work to another developer
- When major infrastructure changes are made
- As preparation for code reviews

## File Naming Convention
`devupdate-XX.md` where XX is the sequential number (01, 02, 03, etc.)

## Template Structure

### 1. Sprint Summary (Manager Level)
```markdown
## Sprint Summary
**Date**: YYYY-MM-DD
**Focus**: [One-line description of primary work]
**Status**: [✅ Complete / ⚠️ In Progress / ❌ Blocked]
```

### 2. What We Shipped (Deliverables)
- Bulleted list of completed features/fixes
- User-facing changes
- Infrastructure improvements
- Measurable outcomes

### 3. What We Discovered (Learning & Insights)
#### Technical Insights
- New knowledge gained
- Platform quirks discovered
- Best practices identified
#### Performance Impact
- Build time changes
- Runtime performance effects
- Resource usage implications

### 4. Risk & Impact Assessment (Project Management)
#### What Could Break
- Potential failure points
- Dependencies affected
- User impact scenarios
#### Technical Debt Incurred
- Shortcuts taken
- Cleanup needed later
- Code quality compromises
#### Dependencies & Blockers
- What's unblocked for other developers
- New dependencies created
- Work that's ready for handoff

### 5. Quality & Testing (QA Focus)
#### Code Review Focus Areas
- Specific files/functions to examine
- Complex logic requiring extra attention
- Security considerations
#### Testing Coverage
- What's been tested (✅)
- What needs testing (⚠️)
- Known edge cases
#### Known Issues
- Bugs that still need fixing
- Limitations in current implementation
- Temporary workarounds

### 6. Implementation Details (Technical Deep Dive)
- Code snippets for complex implementations
- Architecture decisions and rationale
- Configuration changes
- Database schema updates
- API changes

### 7. Forward Planning (Next Sprint Prep)
#### Ready for Next Sprint
- Features/tasks ready for pickup
- Prerequisites completed
- Dependencies resolved
#### What's Blocked
- Issues preventing progress
- External dependencies needed
- Decisions required
#### Integration Points
- Coordination needed with other systems
- Cross-team dependencies
- Deployment considerations

### 8. Effort Analysis (Velocity Tracking)
- Estimated vs actual time spent
- Velocity impact (faster/slower development)
- Learning curve effects
- Process improvements identified

### 9. Handoff Readiness (Knowledge Transfer)
- Documentation completeness
- Environment setup requirements
- Skill prerequisites for next developer
- Readiness assessment for continuation

## Writing Guidelines

### Tone & Audience
- **Managers**: Clear status, risks, and timeline impact
- **Developers**: Technical details and implementation guidance
- **QA**: Testing focus areas and known issues
- **Future Self**: Enough context to remember decisions months later

### Content Principles
- **Actionable**: Each section should enable specific next actions
- **Honest**: Include failures, blockers, and technical debt
- **Specific**: Avoid vague statements, include file names and line numbers
- **Forward-Looking**: Focus on what this enables for future work

### Required Elements
- All major code changes must be documented
- Performance impacts must be assessed
- Handoff readiness must be evaluated
- Known issues must be catalogued

### Optional Enhancements
- Screenshots for UI changes
- Performance benchmarks
- Code snippets for complex logic
- Architecture diagrams

## Quality Checklist
- [ ] Can a manager understand project status from Sprint Summary?
- [ ] Can another developer continue the work from Implementation Details?
- [ ] Are all risks and technical debt items identified?
- [ ] Is the impact on other team members clear?
- [ ] Are testing requirements specified?
- [ ] Is the effort analysis helpful for future estimation?

## Examples of Good vs Poor Content

### Good
- "Waveform fade gradients use absolute positioning at x=7.5 and x=width-7.5, will break on screens != 440px width"
- "Build time improved 15% after removing submodule overhead, but created dependency on responsive design work"

### Poor  
- "Added some visual improvements"
- "Fixed various issues"
- "Everything works fine"

## Integration with Development Workflow
1. Create dev update at end of feature work
2. Use dev update to prepare for code review
3. Reference dev update in pull request description
4. Archive completed dev updates for project retrospectives
5. Use forward planning section to inform next sprint planning