## CONSTRUCT Development Commands

### 🛠️ Core Development Workflow

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

### 🔍 Discovery Commands

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

### 🏗️ Architecture Commands

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

### 🔄 LAB/CORE Workflow Commands

```bash
# Check symlink integrity
./CONSTRUCT/scripts/construct/check-symlinks.sh

# Validate changes for promotion
./tools/validate-promotion.sh

# Promote tested changes to CORE
./tools/promote-to-core.sh

# Update promotion manifest
vim PROMOTE-TO-CORE.yaml
```

### 🧪 Testing Commands

```bash
# Run all quality checks
construct-quality

# Test specific pattern
construct-check --pattern shell-scripting

# Validate before commit
construct-check && construct-quality && construct-docs
```

### 📊 Reporting Commands

```bash
# Generate development update
./CONSTRUCT/scripts/dev/generate-devupdate.sh

# Create session summary
construct-session-summary

# View current violations
construct-check --report

# Architecture overview
construct-arch --overview
```