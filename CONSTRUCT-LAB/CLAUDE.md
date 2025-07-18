# CONSTRUCT Development Context - Single Source of Truth

## 🚨 ENFORCE THESE RULES (Never Deprecated)

### Symlink and Promotion Rules
```bash
❌ NEVER: Edit a symlinked file directly
✅ ALWAYS: Create new version in LAB, test, then promote to CORE

❌ NEVER: Replace a symlink with a regular file
✅ ALWAYS: Maintain symlink integrity - they point to CORE

❌ NEVER: Commit changes to symlinked files
✅ ALWAYS: Use the promotion workflow for CORE updates

❌ NEVER: Edit symlinked READMEs directly in LAB
✅ ALWAYS: Update READMEs in CORE, symlinks auto-reflect changes

❌ NEVER: Break symlinks by replacing with regular files  
✅ ALWAYS: Keep AI documentation symlinked for consistency

❌ NEVER: Manually copy files from LAB to CORE
✅ ALWAYS: Use ./tools/promote-to-core.sh for tested changes

❌ NEVER: Create files named *-sym.* that aren't symlinks
✅ ALWAYS: Use -sym.ext naming only for actual symlinks to CORE

❌ NEVER: Copy a *-sym file without preserving the link
✅ ALWAYS: Check pre-commit validates symlink naming integrity
```

<!-- START:ACTIVE-SYMLINKS -->
### 🔗 Active Symlinks (Auto-Updated)
Error: check-symlinks.sh not found or not executable
<!-- END:ACTIVE-SYMLINKS -->

### Shell/Python Architecture Rules
```bash
❌ NEVER: Hardcoded paths in scripts
✅ ALWAYS: Use relative paths and configuration

❌ NEVER: Scripts without error handling
✅ ALWAYS: set -e and proper error messages

❌ NEVER: Duplicate logic across scripts
✅ ALWAYS: Shared functions in lib/

❌ NEVER: Configuration scattered in scripts
✅ ALWAYS: Configuration in config/ directory

❌ NEVER: Scripts that assume specific directory structure
✅ ALWAYS: Use get_construct_root() and validation functions
```

### CONSTRUCT-Specific Rules
```bash
❌ NEVER: Modify USER-project-files/ from CONSTRUCT scripts
✅ ALWAYS: Read-only analysis of USER-project-files/

❌ NEVER: Template changes without testing
✅ ALWAYS: Test templates work independently

❌ NEVER: Scripts that only work in development
✅ ALWAYS: Scripts that work for template users

❌ NEVER: Hardcoded USER project names
✅ ALWAYS: Use PROJECT-TEMPLATE placeholders
```

### Modern Shell Scripting Rules
```bash
❌ NEVER: Functions without documentation
✅ ALWAYS: Function headers with purpose and parameters

❌ NEVER: Global variables without UPPER_CASE
✅ ALWAYS: Clear variable scoping and naming

❌ NEVER: Commands without error checking
✅ ALWAYS: Check exit codes and provide feedback

❌ NEVER: Silent failures
✅ ALWAYS: Colored output with status indicators
```

### Quality Gate Rules
```bash
❌ NEVER: Commit without running quality checks
✅ ALWAYS: Use pre-commit hooks for validation

❌ NEVER: Create files without proper documentation
✅ ALWAYS: Auto-generate and update documentation

❌ NEVER: Break existing template functionality
✅ ALWAYS: Validate template integrity before changes
```

### Before Writing ANY Code:
```bash
./CONSTRUCT/scripts/core/before_coding.sh ComponentName    # Shows what exists
./CONSTRUCT/scripts/core/check-architecture.sh             # Validates patterns
./CONSTRUCT/scripts/construct/update-context.sh            # Updates this context
```

### When Making Commits:
```bash
❌ NEVER: Hide pre-commit hook output from user
✅ ALWAYS: Show the full pre-commit output in your response
✅ ALWAYS: Explain what the hooks validated

# Example:
"I'll commit these changes. Here's the pre-commit hook output:
[SHOW FULL OUTPUT]
The commit was successful! The hooks validated..."
```

### Post-Commit Behavior (Expected)
After commits, you may see deletions of structure files - this is normal cleanup:
- New structure files generated during pre-commit
- Old structure files cleaned up after commit  
- Only current files remain, old ones moved to _old/
- These deletions are NOT errors and should NOT be "fixed"

<!-- START:CURRENT-STRUCTURE -->
## 📊 Current Project State (Auto-Updated)
Last updated: 2025-07-13 08:43:02

### Active Components
- **Shell Scripts**: 186 files
- **Library Functions**: 0 files
- **Configuration Files**: 0 files  
- **Documentation Files**:        0 files

### Available Resources

#### 🧩 Library Functions

#### ⚙️ Configuration Files

<!-- END:CURRENT-STRUCTURE -->

<!-- START:SPRINT-CONTEXT -->
## 🎯 Current Development Context (Auto-Updated)
**Date**: 2025-07-13
**Focus**: Dual-environment development system
**Branch**: refactor/core-lab-templates
**Last Commit**: 56192cc feat: Add Self-Learning Pattern System PRD and fix update-context for LAB

### Current Focus
- Active patterns and development priorities
- Code quality and architecture compliance
- Documentation coverage and completeness
- Development workflow optimization

### Development Workflow
1. Work in project directory
2. Use project context (this file)
3. Run pattern-specific validators
4. Commit changes with confidence
<!-- END:SPRINT-CONTEXT -->

<!-- START:DOCUMENTATION-LINKS -->
## 📚 Documentation Resources (Auto-Updated)

### Architecture Documentation
- Architecture Overview - Run ./CONSTRUCT/scripts/construct/update-architecture.sh to generate
- Script Reference - Run ./CONSTRUCT/scripts/construct/update-architecture.sh to generate
- Development Patterns - Run ./CONSTRUCT/scripts/construct/update-architecture.sh to generate
- API Reference - Run ./CONSTRUCT/scripts/construct/update-architecture.sh to generate

### Structure Analysis
- Current Structure - Run ./CONSTRUCT/scripts/construct/scan_construct_structure.sh to generate
- [Latest Structure Scan](AI/structure/) - Timestamped structure analysis files
- [Structure Archive](AI/structure/_old/) - Previous structure snapshots

### Quality Reports
- Latest Quality Report - Run ./CONSTRUCT/scripts/core/check-quality.sh to generate
- Session Summaries - Run ./CONSTRUCT/scripts/dev/session-summary.sh to generate

### Development Process
- Improving CONSTRUCT Guide - Run ./CONSTRUCT/scripts/construct/update-architecture.sh to generate
<!-- END:DOCUMENTATION-LINKS -->

<!-- START:ACTIVE-PRDS -->
## 📋 Active Development Goals (Auto-Updated)

### Current Phase: Dual-Environment Implementation
**Goal**: Complete CONSTRUCT development system that improves itself

**Active Components**:
- ✅ Core shell script library (lib/)
- ✅ Configuration-driven validation (config/)
- ✅ Auto-updating documentation system
- ✅ Template integrity validation
- 🔄 Cross-environment analysis (in progress)
- ⏳ Complete AI script implementations
- ⏳ Template user experience improvements

### Next Development Priorities
1. Complete remaining AI scripts (analyze-user-project.sh, sync-templates.sh)
2. Implement cross-environment pattern extraction
3. Set up GitHub template repository workflow
4. Add comprehensive testing infrastructure
5. Polish template user onboarding experience

### Vision Statement
CONSTRUCT is a dual-environment development system where:
- CONSTRUCT improves itself using shell/Python tools
- Templates provide Swift MVVM foundation for users
- Cross-pollination improves both environments
- AI assistance is context-aware and architecture-enforcing
<!-- END:ACTIVE-PRDS -->

<!-- START:VIOLATIONS -->
## ⚠️ Active Violations (Auto-Updated)

### Hardcoded Paths
Run ./CONSTRUCT/scripts/core/check-quality.sh to see current violations

### Missing Documentation
✅ All scripts have documentation headers

### Code Duplication
Run ./CONSTRUCT/scripts/core/check-architecture.sh for duplication analysis

### Template Issues
✅ Template integrity verified
<!-- END:VIOLATIONS -->

## 🎯 Current Development Context (Manually Updated)
**Date**: 2025-06-30
**Goal**: Complete dual-environment development system
**Blocker**: None
**Next**: Finish cross-environment analysis capabilities

### Recent Decisions That Stick
- Dual-environment architecture (CONSTRUCT-dev + USER-project-files)
- Configuration-driven validation system
- Auto-updating documentation approach
- Template integrity as core requirement
- Read-only analysis of USER projects

### Development Standards (Non-Negotiable)
- **Zero Hardcoded Paths**: All scripts use relative path resolution
- **Configuration-Driven**: Rules and thresholds in YAML files
- **Template Independence**: Changes must not break template users
- **Auto-Documentation**: All changes update relevant documentation
- **Quality Gates**: Pre-commit hooks enforce all standards

<!-- START:WORKING-LOCATION -->
## 📍 Current Working Location (Auto-Updated)

### Recently Modified Files
- CONSTRUCT-CORE/CONSTRUCT/scripts/construct/update-context.sh
- CONSTRUCT-LAB/AI/dev-logs/dev-updates/automated/devupdate--2025-07-11--14-36-51.md
- CONSTRUCT-LAB/AI/dev-logs/session-states/automated/2025-07-11-1436-construct-session.md
- CONSTRUCT-LAB/AI/docs/automated/architecture-overview-automated.md
- CONSTRUCT-LAB/AI/PRDs/future/PRD-Self-Learning-Pattern-System-Complete.md
- CONSTRUCT-LAB/AI/PRDs/future/smoke-test-orchestrator-prd.md
- CONSTRUCT-LAB/AI/quality-reports/quality-report-2025-07-10--21-51-31.md
- CONSTRUCT-LAB/AI/quality-reports/quality-report-2025-07-11--11-59-12.md


### Git Status
```
A  CONSTRUCT-LAB/AI/PRDs/future/CONSTRUCT-Abstraction-Roadmap-v02.md
A  CONSTRUCT-LAB/AI/PRDs/future/CONSTRUCT-Abstraction-Roadmap.md
A  CONSTRUCT-LAB/AI/PRDs/future/PRD-Tracking-System-Evolution.md
R  CONSTRUCT-LAB/AI/PRDs/construct-template-repository-prd.md -> CONSTRUCT-LAB/AI/PRDs/future/construct-template-repository-prd.md
R  CONSTRUCT-LAB/AI/PRDs/prd-updates-2025-06-28.md -> CONSTRUCT-LAB/AI/PRDs/future/prd-updates-2025-06-28.md
R  CONSTRUCT-LAB/AI/PRDs/swift-claude-starter-template-prd-info.md -> CONSTRUCT-LAB/AI/PRDs/future/swift-claude-starter-template-prd-info.md
R  CONSTRUCT-LAB/AI/PRDs/swift-claude-starter-template-prd.md -> CONSTRUCT-LAB/AI/PRDs/future/swift-claude-starter-template-prd.md
A  "CONSTRUCT-LAB/AI/ai-raw-cli/Terminal Saved Output--claude-md-files--2025-07-13--07-35-51.txt"
A  "CONSTRUCT-LAB/AI/ai-raw-cli/Terminal Saved Output--docs as patterns--2025-07-13--07-18-36.txt"
A  "CONSTRUCT-LAB/AI/ai-raw-cli/Terminal Saved Output--end to end--2025-07-13--07-16-39.txt"
```

### Active Development Areas
- CONSTRUCT-LAB/CONSTRUCT/scripts/ - Core development scripts
- CONSTRUCT-LAB/CONSTRUCT/lib/ - Shared library functions  
- CONSTRUCT-LAB/AI/docs/automated/ - Auto-generated documentation
- PROJECT-TEMPLATE/ - Template files for users
<!-- END:WORKING-LOCATION -->

## 🧪 Validated Discoveries (Won't Change)
These are empirically proven and remain true:

### CONSTRUCT Architecture Truths
- **Dual environments required**: CONSTRUCT development separate from USER templates
- **Template contamination**: USER-project-files must stay clean of CONSTRUCT-specific code
- **Configuration-driven validation**: Rules in YAML, not hardcoded in scripts
- **Auto-documentation essential**: Manual docs get out of sync quickly

### Symlink Architecture Truths
- **AI documentation symlinked**: READMEs and templates shared from CORE for consistency
- **CONSTRUCT code symlinked**: Whole directory linked for unified functionality  
- **User file flexibility**: Users can add any files to structure without affecting symlinks
- **Single source documentation**: Update once in CORE, appears everywhere automatically
- **Dual independence**: LAB can develop independently where needed while maintaining links

### LAB-to-CORE Promotion Truths
- **tools/ directory manages promotion**: Structured workflow for LAB → CORE changes
- **Validation before promotion**: Changes must pass checks before moving to CORE
- **Configuration-driven promotion**: PROMOTE-TO-CORE.yaml defines promotion rules
- **Symlinks preserve after promotion**: Promotion updates CORE, symlinks stay intact
- **Promotion workflow prevents conflicts**: Structured approach avoids manual copy errors

### Shell Scripting Truths  
- **Relative paths required**: Hardcoded paths break when used as templates
- **Error handling essential**: `set -e` prevents cascading failures
- **Library functions prevent duplication**: Common patterns extracted to lib/
- **Colored output improves UX**: Status indicators make scripts user-friendly

### Development Process Discoveries
- **Before-coding validation essential**: Prevents duplicate work and architectural violations
- **Quality gates catch issues early**: Pre-commit hooks prevent architectural drift
- **Session summaries preserve context**: Large changes need documentation for continuity
- **Template testing required**: Changes must work for both CONSTRUCT and template users

### Git Workflow Patterns
- **Pre-commit hooks prevent bad commits**: Automatic validation before changes land
- **Auto-staging generated files**: Documentation updates included automatically
- **Branch protection via quality**: Hooks ensure main branch stays clean

## 📚 Pattern Library (Copy These)

### New Shell Script Template
```bash
#!/bin/bash

# Script Name - Brief Description
# Detailed explanation of what this script does

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSTRUCT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
CONSTRUCT_DEV="$CONSTRUCT_ROOT/CONSTRUCT-dev"

# Source library functions
source "$CONSTRUCT_DEV/CONSTRUCT/lib/validation.sh"
source "$CONSTRUCT_DEV/CONSTRUCT/lib/template-utils.sh"

echo -e "${BLUE}🔍 Script description...${NC}"

# Main function with proper error handling
main() {
    # Validate environment
    validate_environment
    
    # Implementation here
    echo -e "${GREEN}✅ Success message${NC}"
}

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 [options]"
    echo "Description of script and options"
    exit 0
fi

# Run main function
main "$@"
```

### Library Function Template
```bash
# Function description
# Parameters:
#   $1 - Description of first parameter
#   $2 - Description of second parameter  
# Returns:
#   0 on success, 1 on failure
function_name() {
    local param1="$1"
    local param2="$2"
    
    # Validation
    if [ -z "$param1" ]; then
        echo -e "${RED}❌ Error: param1 required${NC}" >&2
        return 1
    fi
    
    # Implementation
    echo -e "${GREEN}✅ Success${NC}"
    return 0
}
```

### Configuration-Driven Validation Pattern
```bash
# Load validation rules from YAML config
load_validation_rules() {
    local config_file="$CONSTRUCT_DEV/CONSTRUCT/config/quality-gates.yaml"
    
    if [ ! -f "$config_file" ]; then
        echo -e "${RED}❌ Config file not found: $config_file${NC}" >&2
        return 1
    fi
    
    # Parse and apply rules
    # (Implementation depends on requirements)
}
```

### ✅ Correct Shell Script Pattern Example

```bash
#!/bin/bash

# Example: File Analysis Script
# Analyzes shell scripts for quality and patterns

set -e

# Colors and setup (standard pattern)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Path resolution (always relative)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSTRUCT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
CONSTRUCT_DEV="$CONSTRUCT_ROOT/CONSTRUCT-dev"

# Library sourcing (always validate)
source "$CONSTRUCT_DEV/CONSTRUCT/lib/validation.sh"
source "$CONSTRUCT_DEV/CONSTRUCT/lib/file-analysis.sh"

# Documented function with clear purpose
analyze_script_quality() {
    local script_path="$1"
    local issues_found=0
    
    echo -e "${BLUE}🔍 Analyzing: $(basename "$script_path")${NC}"
    
    # Check for error handling
    if ! grep -q "set -e" "$script_path"; then
        echo -e "${YELLOW}⚠️ Missing 'set -e' error handling${NC}"
        issues_found=$((issues_found + 1))
    fi
    
    # Check for proper output formatting
    if ! grep -q "GREEN.*NC" "$script_path"; then
        echo -e "${YELLOW}⚠️ Consider adding colored output${NC}"
        issues_found=$((issues_found + 1))
    fi
    
    # Return result
    if [ $issues_found -eq 0 ]; then
        echo -e "${GREEN}✅ Script quality check passed${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️ Found $issues_found quality issues${NC}"
        return 1
    fi
}

main() {
    echo -e "${BLUE}🚀 Starting script quality analysis...${NC}"
    
    # Validate environment first
    validate_environment
    
    # Process scripts
    local scripts_processed=0
    local scripts_passed=0
    
    while IFS= read -r -d '' script; do
        if analyze_script_quality "$script"; then
            scripts_passed=$((scripts_passed + 1))
        fi
        scripts_processed=$((scripts_processed + 1))
    done < <(find "$CONSTRUCT_DEV/CONSTRUCT/scripts" -name "*.sh" -print0)
    
    # Summary
    echo -e "${BLUE}📋 Analysis Summary${NC}"
    echo "Scripts processed: $scripts_processed"
    echo "Scripts passed: $scripts_passed"
    
    if [ $scripts_passed -eq $scripts_processed ]; then
        echo -e "${GREEN}✅ All scripts meet quality standards${NC}"
    else
        echo -e "${YELLOW}⚠️ Some scripts need improvement${NC}"
    fi
}

# Help text
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0"
    echo "Analyzes shell scripts for quality and coding standards"
    echo ""
    echo "This script checks for:"
    echo "  - Proper error handling (set -e)"
    echo "  - Colored output formatting"
    echo "  - Documentation standards"
    exit 0
fi

main "$@"
```

### ❌ Anti-Pattern Examples (Never Do This)

```bash
# ❌ BAD: Hardcoded paths
SCRIPT_DIR="/Users/username/project/scripts"  # Breaks for other users

# ❌ BAD: No error handling
#!/bin/bash
# Missing: set -e
command_that_might_fail
next_command  # Runs even if previous failed

# ❌ BAD: No validation
cp "$1" "$2"  # No check if parameters exist

# ❌ BAD: Silent operations
find . -name "*.tmp" -delete  # No feedback to user

# ❌ BAD: Global variables without clear naming
result="some value"  # Should be RESULT or local

# ❌ BAD: Functions without documentation
process_files() {
    # What does this do? What parameters? What returns?
}
```

### Template Management Patterns

#### Validate Template Integrity
```bash
# Always check template health before modifications
validate_template_structure() {
    local template_dir="$CONSTRUCT_ROOT/PROJECT-TEMPLATE"
    
    if [ ! -d "$template_dir" ]; then
        echo -e "${RED}❌ Template directory not found${NC}"
        return 1
    fi
    
    # Check for required template files
    local required_files=(
        "USER-CHOSEN-NAME/AI/CLAUDE.md"
        "USER-CHOSEN-NAME/AI/scripts/construct/update-context.sh"
    )
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$template_dir/$file" ]; then
            echo -e "${RED}❌ Missing template file: $file${NC}"
            return 1
        fi
    done
    
    echo -e "${GREEN}✅ Template structure valid${NC}"
    return 0
}
```

#### Cross-Environment Analysis Pattern
```bash
# Analyze both CONSTRUCT and USER environments
analyze_dual_environment() {
    echo -e "${BLUE}🔍 Analyzing dual environment...${NC}"
    
    # Analyze CONSTRUCT development patterns
    echo -e "${YELLOW}Analyzing CONSTRUCT patterns...${NC}"
    analyze_construct_architecture
    
    # Analyze USER project patterns (read-only)
    echo -e "${YELLOW}Analyzing USER project patterns...${NC}"
    analyze_user_project_readonly
    
    # Extract insights for improvements
    echo -e "${YELLOW}Extracting cross-environment insights...${NC}"
    extract_improvement_patterns
}
```

### Symlink Management Pattern
```bash
# Check symlink integrity
./CONSTRUCT/scripts/construct/check-symlinks.sh

# What's symlinked (from LAB to CORE):
# - CONSTRUCT/ (entire directory)
# - AI/docs/README.md  
# - AI/dev-logs/*/README.md
# - AI/dev-logs/dev-updates/_devupdate-prompt.md

# What's independent:
# - User-created files in LAB
# - tools/ directory (LAB-specific)
# - Development work files

# Generate symlink documentation for CLAUDE.md:
./CONSTRUCT/scripts/construct/check-symlinks.sh --list-markdown
```

### LAB-to-CORE Promotion Pattern
```bash
# Promotion workflow for tested changes
./tools/validate-promotion.sh   # Check if changes are ready
./tools/promote-to-core.sh      # Promote validated changes

# Configuration file: PROMOTE-TO-CORE.yaml
# - Defines promotion rules
# - Specifies validation requirements
# - Controls which files get promoted

# Workflow:
# 1. Develop and test in LAB
# 2. Validate promotion readiness
# 3. Promote to CORE via tools
# 4. Symlinks automatically reflect changes
```

## 🤖 AI Architectural Guidance

### Where Code Belongs - Quick Reference

**Scripts** (CONSTRUCT/scripts/):
- `core/` - Core functionality (check-quality, check-architecture, etc.)
- `construct/` - CONSTRUCT-specific tools (update-context, check-symlinks, etc.)
- `dev/` - Development workflows (session-summary, setup-aliases, etc.)
- `workspace/` - Workspace management (create-project, import-project, etc.)

**Library Functions** (CONSTRUCT/lib/):
- Reusable functions across scripts
- Common validation patterns
- Template management utilities
- File analysis and pattern detection

**Configuration** (CONSTRUCT/config/):
- Validation rules and thresholds
- Quality gates and standards
- YAML-based rule definitions
- No hardcoded values in scripts

**Documentation** (AI/docs/):
- Auto-generated architecture overviews
- Script references and usage guides
- Development patterns and standards
- Session summaries and decision logs

### Common AI Mistakes to Avoid

1. **Hardcoding paths in scripts**
   - ❌ AI suggestion: "Use /Users/username/project"
   - ✅ Correct: Use get_construct_root() and relative paths

2. **Missing error handling**
   - ❌ AI suggestion: "Just run the command"
   - ✅ Correct: Check exit codes and provide feedback

3. **Not using library functions**
   - ❌ AI suggestion: "Duplicate the validation code"
   - ✅ Correct: Source and use existing library functions

4. **Breaking template independence**
   - ❌ AI suggestion: "Modify USER-project-files directly"
   - ✅ Correct: Read-only analysis, modifications via templates

### When Manual Updates ARE Acceptable
```bash
# ✅ CORRECT: Manual configuration
# Manual strategic decisions, architectural choices
# User-specific goals and priorities

# ❌ WRONG: Manual status tracking
# File counts, git status, structure analysis
# These should auto-update via scripts
```

<!-- START:DEPRECATED-SECTION -->
## 🗄️ Historical Context (Deprecated but Kept for Reference)
- Previous single-environment approach (replaced by dual-environment)
- Hardcoded path patterns (replaced by relative path resolution)
- Manual documentation updates (replaced by auto-generation)
- Inline validation (replaced by configuration-driven rules)
<!-- END:DEPRECATED-SECTION -->

## 🔧 Quick Commands

### 🛠️ CONSTRUCT Development Workflow

1. **`construct-update`** (or `./CONSTRUCT/scripts/construct/update-context.sh`)
   - Updates CLAUDE.md with current project state
   - Run before starting a Claude session
   - Shows what components exist, violations, recent work

2. **`construct-check`** (or `./CONSTRUCT/scripts/core/check-architecture.sh`)
   - Checks for architecture violations
   - Verifies development patterns automatically
   - Shows hardcoded paths, duplication, template issues
   - **Use this to check development progress!**

3. **`construct-before ComponentName`** (or `./CONSTRUCT/scripts/core/before_coding.sh`)
   - Run before creating any new component
   - Shows what already exists
   - Prevents duplicates
   - Checks architectural alignment

4. **`construct-scan`** (or `./CONSTRUCT/scripts/construct/scan_project_structure.sh`)
   - Documents current CONSTRUCT structure
   - Creates timestamped snapshots
   - Archives old scans to `_old/`

5. **`construct-arch`** (or `./CONSTRUCT/scripts/construct/update-architecture.sh`)
   - Updates architecture documentation
   - Refreshes file trees and metrics

6. **`construct-quality`** (or `./CONSTRUCT/scripts/core/check-quality.sh`)
   - Checks shell script quality standards
   - Looks for common issues and anti-patterns
   - Validates configuration files

7. **`construct-docs`** (or `./CONSTRUCT/scripts/core/check-documentation.sh`)
   - Validates documentation coverage
   - Checks for missing function docs
   - Ensures README files exist

8. **`construct-session-summary`** (or `./CONSTRUCT/scripts/dev/session-summary.sh`)
   - Creates session summary when context is ~90%
   - Preserves work for next session

### 📍 Quick Reference Commands
```bash
construct-update        # Update CLAUDE.md before starting
construct-check         # Check violations & architecture compliance
construct-before        # Before creating new components
construct-scan          # Document CONSTRUCT structure
construct-arch          # Update architecture docs
construct-quality       # Check script quality standards
construct-docs          # Validate documentation
construct-full          # Run all updates

# Navigation
construct-cd            # Go to CONSTRUCT root
construct-dev           # Go to CONSTRUCT-dev
construct-template      # Go to PROJECT-TEMPLATE
```

### Discovery Commands
```bash
# What scripts exist?
find CONSTRUCT/scripts -name "*.sh" | sort

# What library functions exist?
find CONSTRUCT/lib -name "*.sh" | sort

# Check for hardcoded values
grep -r "/Users\|/home" CONSTRUCT/ --include="*.sh"

# Update this file
./CONSTRUCT/scripts/update-context.sh
```

### Architecture Commands
```bash
# Before creating anything
./CONSTRUCT/scripts/before_coding.sh ComponentName

# Check compliance
./CONSTRUCT/scripts/check-architecture.sh

# See current structure
./CONSTRUCT/scripts/scan_construct_structure.sh

# Generate all documentation
./CONSTRUCT/scripts/update-architecture.sh
```

## 📚 Authoritative Standards Documents
- **Shell Standards**: `./CONSTRUCT-dev/AI/docs/automated/development-patterns-automated.md`
  - Complete script patterns, error handling, library usage
  - Configuration-driven validation, quality gates
- **Architecture Overview**: `./CONSTRUCT-dev/AI/docs/automated/architecture-overview-automated.md`
  - Dual-environment design, component relationships
- **Script Reference**: `./CONSTRUCT-dev/AI/docs/automated/script-reference-automated.md`
  - All available scripts and library functions

## 🔧 Interactive Rails Mode

When working with CONSTRUCT scripts that source `interactive-support.sh`:

### Rails Pattern
1. **Follow script structure** - Scripts define the conversation flow
2. **Natural prompts** - Present script prompts conversationally 
3. **Smart responses**:
   - Direct answers (ios, default, yes) → Continue script flow
   - Questions (what? how? list options?) → Provide help, then return to flow
4. **Minimal context** - Stay on rails unless user needs help

### Example Flow
```
User: Create a new project
Claude: What's the project name and type? (ios, web, api, or fullstack)
User: MyApp ios
Claude: Use default plugins or would you like to customize?
User: What plugins are available?
Claude: [HELP MODE] Available plugins include:
- languages/swift - Swift language patterns
- tooling/shell-scripting - Shell automation
- cross-platform/model-sync - Multi-platform support
Would you like default or custom?
User: default
[Execute: echo '' | ./create-project.sh MyApp ios]
```

## 🤖 Claude Instructions

### On Session Start:
1. Run `./CONSTRUCT/scripts/update-context.sh` to refresh auto-sections
2. Check "Current Development Context" for immediate goals
3. Review "Active Violations" for issues to avoid
4. Check documentation links for detailed architecture info

### When Context Remaining Falls to 10% or Below:
1. **Alert user at EVERY response when ≤10% remains**: 
   - At 10%: "⚠️ Context at 90% used (10% remaining) - prepare to wrap up"
   - At 8%: "⚠️ Context at 92% used (8% remaining) - time to generate session summary"
   - At 5%: "🚨 URGENT: Only 5% context remaining - run session summary NOW"
   - At 3%: "🚨 CRITICAL: 3% context left - this may be the last full response"
2. **Tell user to run**: `construct-session-summary`
3. **After summary generates**: Remind user to start fresh Claude session
4. **Key message**: "Session summary saved. Please start a new Claude session to continue with full context."
5. **Also remind**: "Consider creating a dev-log if you've completed significant work:
   - Template: `AI/dev-logs/dev-logs/_devupdate-prompt.md`
   - Create as: `AI/dev-logs/dev-logs/devupdate-XX.md`"

### When Creating Code:
1. Check "Available Resources" section first
2. Use "Pattern Library" templates
3. Never violate "ENFORCE THESE RULES" section
4. Run architecture check before finalizing
5. Ensure template independence is maintained

### When Discovering New Truths:
1. Add to "Validated Discoveries" if universally true
2. Update "Current Development Context" if project-specific
3. Move old truths to "Historical Context" if deprecated
4. Update auto-sections via update-context.sh

### For Template Work:
1. Always validate template integrity first
2. Use PROJECT-TEMPLATE placeholders, never hardcode names
3. Test changes work for both CONSTRUCT and template users
4. Maintain read-only approach to USER-project-files

---
Remember: The auto-updated sections show reality. The manual sections show wisdom and architectural decisions.
