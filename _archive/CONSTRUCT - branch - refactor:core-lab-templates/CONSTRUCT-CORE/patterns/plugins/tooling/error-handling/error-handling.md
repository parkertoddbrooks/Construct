## [TOOLING] Error and Warning Handling Protocol

### When to Use
- Any time you encounter an error, warning, or unexpected behavior
- Before making "quick fixes" that might have broader impact
- When debugging complex systems with multiple components

### Critical Rules

#### ✅ DO: Stop and Discuss
- **ALWAYS** pause when encountering errors or warnings
- **NEVER** make assumptions about root causes
- **ALWAYS** discuss the full context before fixing
- **INVESTIGATE** the underlying system before changing code

#### ❌ DON'T: Quick Fix Without Understanding
- **NEVER** suppress warnings without understanding them
- **NEVER** apply fixes that might break other components
- **NEVER** assume a simple fix is the right solution
- **NEVER** proceed without user input on complex errors

### Protocol for Error Handling

#### Step 1: Stop and Assess
```
When you encounter an error:
1. STOP - Don't immediately try to fix it
2. DOCUMENT - What exactly is the error/warning?
3. CONTEXT - What were we trying to accomplish?
4. SCOPE - What systems might be affected?
```

#### Step 2: Communicate with User
```
Tell the user:
- Exactly what error/warning occurred
- What command/action triggered it
- What the error message means
- Potential impact of different solutions
- Ask: "How would you like to proceed?"
```

#### Step 3: Analyze Before Acting
```
Before making changes:
- Understand the root cause
- Consider all affected systems
- Identify potential side effects
- Propose solution with trade-offs explained
```

### Examples

#### ✅ CORRECT Response to Error
```
❌ Error encountered: "yq: command not found"

Context: We were testing pattern validation system
Impact: Pattern system cannot read YAML configurations
Root cause: Missing dependency

This affects:
- All pattern operations
- Multi-repo workspace commands  
- Custom rules processing

Options:
1. Install yq (recommended) - enables full functionality
2. Skip YAML features for now - limited functionality
3. Mock yq responses for testing - temporary solution

How would you like to proceed?
```

#### ❌ WRONG Response to Error
```
❌ "Let me just install yq for you..."
❌ "I'll skip the YAML validation..."
❌ "Let me work around this error..."
```

### CONSTRUCT-Specific Considerations

#### Multi-Component Impact Assessment
```
Before changing any code in CONSTRUCT:
1. Check if change affects CORE vs LAB
2. Verify impact on existing projects
3. Consider symlink integrity
4. Test pattern resolution chains
5. Validate workspace registry effects
```

#### Cascading Effect Prevention
```
Ask these questions:
- Does this fix break existing workflows?
- Will this change affect other projects using CONSTRUCT?
- Are there configuration files that need updating?
- Do symlinks need to be maintained?
- Will this impact the promotion system?
```

### Warning Escalation

#### When to Escalate to User
- **Any** error that stops core functionality
- Warnings that indicate configuration issues
- Missing dependencies that affect system behavior
- Unexpected behavior in multi-repo operations
- Permission or file system issues
- Git repository conflicts or issues

#### Communication Template
```
🚨 [ERROR/WARNING]: Brief description

**What happened**: Detailed explanation
**Context**: What we were doing when this occurred
**Impact**: What functionality is affected
**Root cause**: Best assessment of underlying issue

**Potential solutions**:
1. Option A - pros/cons
2. Option B - pros/cons  
3. Option C - pros/cons

**Recommendation**: Which option and why

**Question**: How would you like to proceed?
```

### CONSTRUCT Architecture Safety

#### Symlink System Safety
```
Before modifying any symlinked files or directories:
- Verify symlink integrity will be maintained
- Check that both LAB and target directories are considered
- Ensure promotion system remains functional
```

#### Multi-Repository Awareness
```
Before changes affecting workspace:
- Consider impact on Projects/ directory structure
- Verify registry.yaml compatibility
- Test with both monorepo and multi-repo projects
- Check git independence is maintained
```

### Code Quality Gates

#### Pre-Change Checklist
- [ ] Error/warning fully understood
- [ ] Root cause identified
- [ ] Impact assessment completed
- [ ] User consulted on approach
- [ ] Solution tested in isolation
- [ ] Integration testing planned
- [ ] Documentation updated
- [ ] Rollback plan identified