# CONSTRUCT Development Tests

This directory contains tests for CONSTRUCT's own shell scripts and utilities.

## Test Structure

```
tests/
├── lib/                    # Tests for lib/ functions
│   ├── test-file-analysis.sh
│   ├── test-template-utils.sh
│   └── test-validation.sh
├── scripts/               # Tests for AI/scripts/
│   ├── test-update-context.sh
│   ├── test-check-architecture.sh
│   └── test-analyze-user-project.sh
├── integration/           # End-to-end tests
│   ├── test-setup-flow.sh
│   └── test-template-generation.sh
└── fixtures/              # Test data and mock files
    ├── mock-user-project/
    └── sample-swift-files/
```

## Running Tests

```bash
# Run all tests
./run-all-tests.sh

# Run specific test category
./run-tests.sh lib
./run-tests.sh scripts
./run-tests.sh integration

# Run specific test
./tests/lib/test-file-analysis.sh
```

## Test Standards

### Shell Script Tests
- Use `bash` test framework or simple assertions
- Test both success and failure cases
- Mock external dependencies
- Test with various input scenarios

### Integration Tests
- Test complete workflows end-to-end
- Validate template generation works
- Test USER-project-files analysis
- Verify CONSTRUCT development workflows

### Test Data
- Use fixtures for consistent test scenarios
- Mock Swift files with known patterns
- Sample MVVM violations for testing detection
- Clean and contaminated template examples

## Adding New Tests

When adding new functionality to CONSTRUCT:

1. **Create corresponding test file**
2. **Test success and failure paths**
3. **Include edge cases**
4. **Update this README**

Example test structure:
```bash
#!/bin/bash
# Test file-analysis.sh functions

source "../lib/file-analysis.sh"

test_find_swift_files() {
    # Test implementation
}

test_check_mvvm_violations() {
    # Test implementation  
}

# Run tests
test_find_swift_files
test_check_mvvm_violations
```

This ensures CONSTRUCT development maintains quality while building quality tools for users.