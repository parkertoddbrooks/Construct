## Validated Development Discoveries

These are empirically proven truths about CONSTRUCT development:

### 🏗️ CONSTRUCT Architecture Truths

1. **Dual environments required**: CONSTRUCT development separate from USER templates
2. **Template contamination**: USER-project-files must stay clean of CONSTRUCT-specific code  
3. **Configuration-driven validation**: Rules in YAML, not hardcoded in scripts
4. **Auto-documentation essential**: Manual docs get out of sync quickly
5. **Before-coding validation essential**: Prevents duplicate work and violations
6. **Quality gates catch issues early**: Pre-commit hooks prevent drift
7. **Session summaries preserve context**: Large changes need documentation
8. **Template testing required**: Changes must work for both CONSTRUCT and users

### 🔗 Symlink Architecture Truths

1. **Symlinks maintain consistency**: Changes in CORE automatically reflect in LAB
2. **Never edit symlinked files**: Always edit source in CORE
3. **Symlink naming convention**: *-sym.ext files are always symlinks
4. **Pre-commit validates integrity**: Broken symlinks fail commits
5. **Promotion workflow required**: LAB changes promote to CORE via tools

### 🚀 LAB-to-CORE Promotion Truths

1. **LAB is experimental**: All new features start in LAB
2. **CORE is stable**: Only tested, proven code goes to CORE
3. **Promotion requires validation**: Tools ensure quality before promotion
4. **Manifest controls promotion**: PROMOTE-TO-CORE.yaml defines what moves
5. **Symlinks auto-update**: After promotion, LAB reflects new CORE state

### 📜 Shell Scripting Truths

1. **Exit codes matter**: 0 = success, >0 = number of issues found
2. **Colors improve UX**: Red for errors, green for success, yellow for warnings
3. **Help is mandatory**: All scripts must support --help
4. **Library functions reduce duplication**: Common patterns belong in lib/
5. **Absolute paths from CONSTRUCT_ROOT**: Scripts work from any directory

### 🔄 Development Process Discoveries

1. **Context degrades quickly**: Regular updates keep AI effective
2. **Patterns emerge from use**: Don't over-design, let patterns develop
3. **Documentation generates trust**: Clear docs reduce cognitive load
4. **Automation prevents drift**: Manual processes always decay
5. **Examples teach better than rules**: Show correct patterns in action

### 🎯 Git Workflow Patterns

1. **Pre-commit hooks prevent bad commits**: Quality gates stop issues early
2. **Auto-staging generated files**: Structure files update automatically
3. **Branch protection via quality**: Bad code can't merge
4. **Clear commit messages required**: Future you needs context
5. **Atomic commits preferred**: One logical change per commit