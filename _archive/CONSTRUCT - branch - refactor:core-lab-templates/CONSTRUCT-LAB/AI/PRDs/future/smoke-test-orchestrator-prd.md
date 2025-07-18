# PRD: Smoke Test Orchestrator Pattern for CONSTRUCT

## Executive Summary

Create a CONSTRUCT pattern plugin that orchestrates existing open-source test runners (Jest, Playwright, Hurl, etc.) to provide unified smoke testing capabilities with AI-optimized error reporting. This follows CONSTRUCT's Unix philosophy of leveraging existing tools rather than reinventing them.

## Problem Statement

CONSTRUCT projects currently lack a standardized way to:
1. Run all critical smoke tests with a single command
2. Orchestrate different test runners (UI, API, unit) cohesively
3. Capture comprehensive failure context for AI debugging
4. Maintain smoke tests as executable documentation
5. Ensure critical paths are tested without complex configuration

## Goals

### Primary Goals
1. **Zero-Configuration Testing**: Detect and run existing tests automatically
2. **Unified Orchestration**: Single command runs all test types
3. **AI-Optimized Reporting**: Capture maximum context for AI debugging
4. **Pattern Integration**: Seamless fit with CONSTRUCT's pattern system

### Secondary Goals
1. **Convention Over Configuration**: Smart defaults, optional customization
2. **Test Runner Agnostic**: Work with any testing framework
3. **CI/CD Ready**: Standard exit codes and reporting formats
4. **Living Documentation**: Tests document critical functionality

## Non-Goals
1. Replace existing test frameworks (we orchestrate, not replace)
2. Test generation (future enhancement)
3. Full test suite management (focus on smoke tests only)
4. Performance testing (separate concern)
5. Creating new test runners (use existing tools)

## User Stories

### As a Developer
- I want to run all smoke tests with one command
- I want to use my existing test frameworks
- I want clear reports when tests fail
- I want minimal configuration overhead

### As an AI Assistant
- I need comprehensive error context to diagnose failures
- I need structured reports in markdown format
- I need to understand what was tested and why it failed
- I need actionable suggestions for fixes

### As a DevOps Engineer
- I want standard exit codes for CI/CD integration
- I want test results in common formats (JUnit XML)
- I want parallel execution for speed
- I want reliable timeout handling

## Technical Design

### Architecture Overview

```
CONSTRUCT-CORE/patterns/plugins/testing/smoke-test-orchestrator/
├── smoke-test-orchestrator.md          # Pattern documentation
├── smoke-test-orchestrator.yaml        # Plugin metadata
├── validators/
│   ├── quality.sh                     # Validates test quality
│   ├── coverage.sh                    # Ensures critical paths tested
│   └── architecture.sh                # Checks test organization
├── generators/
│   └── init-smoke-tests.sh            # Generate initial test structure
└── tools/
    └── construct-smoke/
        ├── smoke.sh                    # Main orchestrator
        ├── lib/
        │   ├── runner-detection.sh     # Auto-detect test runners
        │   ├── test-discovery.sh       # Find tests by convention
        │   ├── parallel-executor.sh    # Run tests in parallel
        │   └── ai-reporter.sh          # Generate AI reports
        └── runners/                    # Runner adapters
            ├── jest.sh                 # Jest adapter
            ├── playwright.sh           # Playwright adapter
            ├── cypress.sh              # Cypress adapter
            ├── hurl.sh                 # Hurl adapter
            ├── pytest.sh               # Pytest adapter
            └── bats.sh                 # Bats adapter
```

### Pattern Configuration

The pattern uses existing `.construct/patterns.yaml` with optional configuration:

```yaml
# Required: Enable the pattern
plugins:
  - testing/smoke-test-orchestrator

# Optional: Customize behavior
smoke_tests:
  # Test discovery
  discovery:
    tags: ["smoke", "critical"]         # Only run tagged tests
    patterns: ["*.smoke.*", "*.e2e.*"]  # File patterns to match
    exclude: ["*.skip.*", "temp/*"]     # Patterns to exclude
  
  # Execution
  execution:
    timeout: 300                        # Global timeout (seconds)
    parallel: true                      # Run runners in parallel
    fail_fast: false                    # Continue after first failure
    retry: 1                            # Retry failed tests once
  
  # Reporting
  reporting:
    capture_screenshots: true           # For UI tests
    capture_logs: true                  # Application logs
    capture_network: true               # API requests/responses
    ai_suggestions: true                # Include fix suggestions
    formats: ["markdown", "junit"]      # Output formats
```

### Runner Detection Algorithm

```bash
# Pseudocode for runner detection
detect_runners() {
    runners=[]
    
    # JavaScript/TypeScript projects
    if exists("package.json"):
        if has_dependency("jest"): runners.add("jest")
        if has_dependency("playwright"): runners.add("playwright")
        if has_dependency("cypress"): runners.add("cypress")
        if has_dependency("vitest"): runners.add("vitest")
    
    # Python projects
    if exists("requirements.txt") or exists("pyproject.toml"):
        if has_dependency("pytest"): runners.add("pytest")
        if has_dependency("unittest"): runners.add("unittest")
    
    # API testing
    if exists("*.hurl") or has_dependency("hurl"): runners.add("hurl")
    if exists("postman_collection.json"): runners.add("newman")
    
    # Shell testing
    if exists("*.bats") or has_dependency("bats"): runners.add("bats")
    
    return runners
}
```

### Test Discovery Convention

```bash
# Default test patterns by runner
JEST_PATTERNS="**/*.{test,spec}.{js,jsx,ts,tsx}"
PLAYWRIGHT_PATTERNS="**/e2e/**/*.{test,spec}.{js,ts}"
CYPRESS_PATTERNS="**/cypress/integration/**/*.{js,ts}"
PYTEST_PATTERNS="**/test_*.py **/*_test.py"
HURL_PATTERNS="**/*.hurl"
BATS_PATTERNS="**/*.bats"

# Tag-based filtering (if configured)
if has_config("tags"):
    filter_by_tags(tests, config.tags)
```

### AI Report Format

```markdown
# Smoke Test Failure Report

**Date**: 2025-07-11 14:23:45
**Project**: MyApp
**Status**: FAILED (2 of 15 tests failed)

## Summary
- ✅ 13 tests passed
- ❌ 2 tests failed
- ⏭️ 0 tests skipped
- ⏱️ Total duration: 45.3s

## Failed Tests

### 1. User Login Flow (Playwright)
**File**: `tests/e2e/auth/login.spec.ts:23`
**Duration**: 5.2s
**Error**: Element not found: button[data-test="submit"]

#### Error Context
```javascript
// Line 23
await page.click('button[data-test="submit"]');
         ^
ElementNotFoundError: No element matches selector "button[data-test="submit"]"
```

#### Visual Evidence
![Screenshot](./smoke-reports/login-failure-1.png)

#### DOM at Failure
```html
<form class="login-form">
  <input type="email" value="test@example.com" />
  <input type="password" value="***" />
  <button type="submit" class="btn-primary">Sign In</button>
</form>
```

#### Network Activity
- POST /api/auth/validate (200 OK, 125ms)
- GET /api/user/profile (pending)

#### AI Analysis & Suggestions
1. **Selector Change**: The submit button doesn't have the expected `data-test` attribute
   - Current selector: `button[data-test="submit"]`
   - Found similar: `button[type="submit"]` with text "Sign In"
   - Suggested fix: `await page.click('button[type="submit"]')`

2. **Possible Causes**:
   - Recent UI refactor may have removed test attributes
   - Check commit history for changes to login form
   - Consider using more resilient selectors

### 2. API Health Check (Hurl)
**File**: `tests/api/health.hurl:8`
**Duration**: 30.1s (timeout)
**Error**: Request timeout

#### Request Details
```hurl
GET http://localhost:3000/api/health
Accept: application/json

HTTP/1.1 200
[Asserts]
jsonpath "$.status" == "healthy"
```

#### Error Context
- Request sent to: http://localhost:3000/api/health
- Timeout after: 30s
- No response received

#### AI Analysis & Suggestions
1. **Service Not Running**: The API server may not be running
   - Check if service is started: `lsof -i :3000`
   - Start service: `npm run dev` or `docker-compose up`

2. **Wrong Port/URL**: 
   - Verify API is on port 3000
   - Check environment configuration

## Test Environment
- **OS**: macOS 14.0
- **Node**: v20.11.0
- **Test Runners**: jest@29.7.0, playwright@1.40.1, hurl@4.2.0

## Reproduction Steps
```bash
# To reproduce these failures:
construct-smoke test --filter=failed

# Or run specific tests:
npm run test:e2e -- tests/e2e/auth/login.spec.ts
hurl tests/api/health.hurl
```

## Next Steps
1. Fix button selector in login test
2. Ensure API server is running before tests
3. Consider adding pre-test health checks
```

### Runner Adapters

Each runner adapter translates generic commands to runner-specific ones:

```bash
# jest.sh adapter example
run_tests() {
    local pattern="$1"
    local options="$2"
    
    # Build Jest command
    cmd="npx jest"
    
    # Add pattern if provided
    [[ -n "$pattern" ]] && cmd="$cmd $pattern"
    
    # Add smoke test filtering
    if [[ "$options" =~ "tags" ]]; then
        cmd="$cmd --testNamePattern='smoke|critical'"
    fi
    
    # Add coverage
    [[ "$options" =~ "coverage" ]] && cmd="$cmd --coverage"
    
    # Execute with error handling
    $cmd --json > jest-results.json 2>&1
}
```

## Implementation Plan

### Phase 1: Core Framework (Week 1)
1. Create pattern plugin structure
2. Implement runner detection logic
3. Build test discovery system
4. Create basic orchestration script

### Phase 2: Runner Adapters (Week 2)
1. Jest adapter with result parsing
2. Playwright adapter with screenshot capture
3. Hurl adapter for API tests
4. Pytest adapter for Python projects
5. Bats adapter for shell scripts

### Phase 3: AI Reporting (Week 3)
1. Failure context capture system
2. Markdown report generator
3. AI suggestion engine
4. Screenshot/log aggregation

### Phase 4: Advanced Features (Week 4)
1. Parallel execution support
2. Test retry mechanism
3. JUnit XML output
4. Pre-commit integration

### Phase 5: Testing & Documentation (Week 5)
1. Create example projects
2. Write comprehensive tests
3. Document all features
4. Create migration guides

## Step-by-Step Implementation Guide

### 1. Create Plugin Structure
```bash
# In CONSTRUCT-LAB for development
cd CONSTRUCT-LAB/patterns/plugins/testing
mkdir -p smoke-test-orchestrator/{validators,generators,tools/construct-smoke/{lib,runners}}

# Create plugin files
touch smoke-test-orchestrator/smoke-test-orchestrator.md
touch smoke-test-orchestrator/smoke-test-orchestrator.yaml
```

### 2. Write Plugin Metadata
```yaml
# smoke-test-orchestrator.yaml
name: smoke-test-orchestrator
version: 1.0.0
description: Orchestrates existing test runners for unified smoke testing
author: CONSTRUCT Team
category: testing
validators:
  - quality      # Validates test quality
  - coverage     # Ensures critical paths tested
  - architecture # Checks test organization
generators:
  - init-smoke-tests # Helps set up initial tests
tags:
  - testing
  - quality
  - automation
  - ai-friendly
min_construct_version: 2.0.0
```

### 3. Implement Runner Detection
```bash
# tools/construct-smoke/lib/runner-detection.sh
#!/bin/bash
set -e

detect_javascript_runners() {
    local project_dir="$1"
    local runners=()
    
    if [[ -f "$project_dir/package.json" ]]; then
        # Check for various test runners
        grep -q '"jest"' "$project_dir/package.json" && runners+=("jest")
        grep -q '"playwright"' "$project_dir/package.json" && runners+=("playwright")
        grep -q '"cypress"' "$project_dir/package.json" && runners+=("cypress")
        grep -q '"vitest"' "$project_dir/package.json" && runners+=("vitest")
    fi
    
    echo "${runners[@]}"
}
```

### 4. Create Main Orchestrator
```bash
# tools/construct-smoke/smoke.sh
#!/bin/bash
set -e

# Main smoke test orchestrator
source "$(dirname "$0")/lib/runner-detection.sh"
source "$(dirname "$0")/lib/test-discovery.sh"
source "$(dirname "$0")/lib/ai-reporter.sh"

PROJECT_DIR="${1:-.}"
COMMAND="${2:-test}"

main() {
    echo "🔍 Detecting test runners..."
    local runners=($(detect_all_runners "$PROJECT_DIR"))
    
    echo "📋 Found runners: ${runners[*]}"
    
    echo "🏃 Running smoke tests..."
    run_all_tests "${runners[@]}"
    
    echo "📊 Generating report..."
    generate_ai_report
}

main "$@"
```

### 5. Test the Implementation
```bash
# Create test project
cd CONSTRUCT-LAB
./CONSTRUCT/scripts/workspace/create-project.sh TestApp web

# Add smoke test pattern
cd Projects/TestApp
echo "plugins:
  - testing/smoke-test-orchestrator" >> .construct/patterns.yaml

# Create sample tests
mkdir -p tests/e2e
cat > tests/e2e/smoke.spec.js << 'EOF'
describe('Smoke Tests', () => {
  test('app loads', () => {
    expect(true).toBe(true);
  });
});
EOF

# Run smoke tests
construct-smoke test
```

### 6. Create Validators
```bash
# validators/quality.sh
#!/bin/bash
# Validates smoke test quality
check_test_naming
check_test_organization
check_assertions
```

### 7. Document Pattern
```markdown
# smoke-test-orchestrator.md
# Smoke Test Orchestrator Pattern

Orchestrates existing test runners to provide unified smoke testing...
[Full documentation following CONSTRUCT pattern format]
```

### 8. Integration Test
```bash
# Test with multiple project types
test_with_react_app
test_with_python_api
test_with_cli_tool
verify_ai_reports
```

### 9. Promote to CORE
```bash
# After testing in LAB
cd CONSTRUCT-LAB
./tools/validate-promotion.sh
./tools/promote-to-core.sh patterns/plugins/testing/smoke-test-orchestrator
```

## Success Metrics

### Adoption Metrics
- 50% of CONSTRUCT projects adopt within 3 months
- Average setup time < 5 minutes
- 90% of projects use zero configuration

### Quality Metrics
- Smoke test execution < 5 minutes
- False positive rate < 5%
- AI fix suggestion accuracy > 70%

### Developer Experience
- Single command execution
- Clear, actionable reports
- Seamless CI/CD integration

## Risks and Mitigations

### Risk: Test Runner Compatibility
**Mitigation**: Start with most common runners, add adapters incrementally

### Risk: Performance with Large Test Suites
**Mitigation**: Smart filtering, parallel execution, configurable timeouts

### Risk: Maintenance Burden
**Mitigation**: Minimal abstraction, delegate to native runners

### Risk: Breaking Changes in Test Runners
**Mitigation**: Version detection, compatibility modes

## Future Enhancements

### Version 2.0
- Visual regression testing integration
- Test result trending
- Flakiness detection
- Auto-retry for flaky tests

### Version 3.0
- AI-powered test generation
- Predictive failure analysis
- Cross-project test insights
- Self-healing test selectors

## Conclusion

The Smoke Test Orchestrator pattern brings unified testing to CONSTRUCT while following core principles:
- **Unix Philosophy**: Orchestrate existing tools
- **Pattern-Based**: Fits naturally in pattern system
- **Zero Configuration**: Works out of the box
- **AI-First**: Optimized for AI debugging

This pattern enables developers to maintain quality with minimal overhead while providing AI assistants with the context needed to help fix issues quickly.