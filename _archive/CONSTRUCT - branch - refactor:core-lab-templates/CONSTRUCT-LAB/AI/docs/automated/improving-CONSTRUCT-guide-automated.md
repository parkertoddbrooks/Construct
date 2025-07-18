## Improving CONSTRUCT Guide

This guide explains how to contribute to and improve the CONSTRUCT system.

### Understanding CONSTRUCT Architecture

CONSTRUCT follows a three-layer architecture:

1. **CONSTRUCT-CORE**: Universal orchestration engine (stable, production-ready)
2. **CONSTRUCT-LAB**: Development environment for improving CONSTRUCT
3. **Projects**: User projects managed by CONSTRUCT

### Development Workflow

#### 1. Setting Up Development Environment

```bash
# Always work in CONSTRUCT-LAB for development
cd CONSTRUCT-LAB

# Update context before starting
./CONSTRUCT/scripts/update-context.sh

# Check current architecture compliance
./CONSTRUCT/scripts/check-architecture.sh
```

#### 2. Before Coding

```bash
# Get guidance before creating new components
./CONSTRUCT/scripts/before_coding.sh ComponentName

# This provides:
# - Naming conventions
# - Required patterns
# - Integration points
# - Testing requirements
```

#### 3. Development Process

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Develop in LAB**
   - All new code goes in CONSTRUCT-LAB first
   - Use symlinks to test with CORE functionality
   - Never edit symlinked files directly

3. **Test Thoroughly**
   - Run quality checks: `./CONSTRUCT/scripts/check-quality.sh`
   - Test with sample projects
   - Validate documentation coverage

4. **Update Documentation**
   - Keep CLAUDE.md current
   - Document new patterns
   - Update architecture if needed

### Adding New Features

#### Creating New Scripts

1. **Follow Standard Structure**
   - Use template from development-patterns.md
   - Include proper error handling
   - Add colored output for clarity

2. **Add to Appropriate Directory**
   - `scripts/construct/`: CONSTRUCT-specific tools
   - `scripts/core/`: General-purpose orchestrators
   - `scripts/workspace/`: Multi-project management
   - `scripts/dev/`: Development utilities

3. **Document Thoroughly**
   - Add --help option
   - Include purpose in header comments
   - Update script reference

#### Creating New Patterns

1. **Develop Pattern Plugin**
   ```bash
   # Create in LAB patterns directory
   mkdir -p patterns/category/my-pattern
   touch patterns/category/my-pattern/my-pattern.md
   touch patterns/category/my-pattern/my-pattern.yaml
   ```

2. **Define Pattern Structure**
   - Clear instructions in .md file
   - Validators in validators/ subdirectory
   - Generators in generators/ subdirectory
   - Configuration in .yaml file

3. **Test Pattern**
   - Apply to test project
   - Run validators
   - Check generated content

#### Adding Library Functions

1. **Create in Appropriate Library**
   - `lib/common-patterns.sh`: Shared utilities
   - `lib/validation.sh`: Validation functions
   - `lib/file-analysis.sh`: File parsing
   - `lib/template-utils.sh`: Template management

2. **Follow Documentation Standards**
   ```bash
   # Purpose: Clear description of function
   # Parameters: $1 - parameter description
   # Returns: 0 on success, 1 on failure
   function_name() {
       local param="$1"
       # Implementation
   }
   ```

### Promotion Workflow

#### When to Promote

Promote from LAB to CORE when:
- Feature is thoroughly tested
- Documentation is complete
- No breaking changes to existing functionality
- Approved by review process

#### How to Promote

1. **Add to Promotion Manifest**
   ```yaml
   # PROMOTE-TO-CORE.yaml
   files_to_promote:
     - source: scripts/my-new-script.sh
       dest: CONSTRUCT/scripts/my-new-script.sh
   ```

2. **Run Promotion**
   ```bash
   ./CONSTRUCT-LAB/tools/promote-to-core.sh
   ```

3. **Validate Results**
   - Check CORE functionality
   - Ensure symlinks still work
   - Run integration tests

4. **Commit Changes**
   ```bash
   git add .
   git commit -m "feat: Promote new-feature to CORE"
   ```

### Contributing Patterns

#### Code Quality Standards

- No hardcoded paths
- Proper error handling
- Consistent formatting
- Clear variable names
- Comprehensive comments

#### Testing Requirements

- Unit tests for functions
- Integration tests for scripts
- Documentation examples
- Error case handling

#### Documentation Standards

- Clear purpose statements
- Usage examples
- Parameter descriptions
- Return value documentation
- Integration notes

### Common Tasks

#### Adding Configuration Options

1. Update relevant YAML in `config/`
2. Modify scripts to read new options
3. Document configuration changes
4. Test with various values

#### Improving Error Messages

1. Use consistent format
2. Provide actionable feedback
3. Include relevant context
4. Suggest next steps

#### Enhancing Performance

1. Profile slow operations
2. Optimize file operations
3. Cache repeated calculations
4. Parallelize where possible

### Debugging Tips

#### Common Issues

1. **Symlink Problems**
   - Run: `./CONSTRUCT/scripts/check-symlinks.sh`
   - Never edit symlinked files
   - Recreate if broken

2. **Path Issues**
   - Always use relative paths
   - Source from SCRIPT_DIR
   - Test from different directories

3. **Permission Errors**
   - Ensure scripts are executable
   - Check file ownership
   - Validate directory access

#### Debug Mode

```bash
# Enable debug output
set -x

# Or selectively debug
[[ "$DEBUG" == "true" ]] && set -x
```

### Best Practices

1. **Start Small**
   - Make incremental changes
   - Test frequently
   - Get feedback early

2. **Think Universally**
   - Consider multiple use cases
   - Design for extensibility
   - Avoid language-specific assumptions

3. **Document Everything**
   - Why, not just what
   - Examples over descriptions
   - Keep docs with code

4. **Test Thoroughly**
   - Happy path and errors
   - Different environments
   - Integration scenarios

---

*Generated by CONSTRUCT pattern system*
