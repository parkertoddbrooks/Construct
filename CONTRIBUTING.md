# Contributing to Construct

First off, thank you for considering contributing to Construct! It's people like you that make Construct such a great tool for the Swift community.

## Code of Conduct

By participating in this project, you are expected to uphold our Code of Conduct:
- Be respectful and inclusive
- Welcome newcomers and help them get started
- Focus on constructive criticism
- Respect differing viewpoints and experiences

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples**
- **Describe the behavior you observed and expected**
- **Include screenshots if relevant**
- **Note your environment** (macOS version, Xcode version, Swift version)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

- **Use a clear and descriptive title**
- **Provide a detailed description of the proposed enhancement**
- **Explain why this enhancement would be useful**
- **List any alternatives you've considered**

### Pull Requests

1. **Fork the repo** and create your branch from `main`
2. **Follow the existing code style** - Construct enforces its own standards!
3. **Write meaningful commit messages** following the pattern:
   ```
   type: Brief description
   
   Longer explanation if needed.
   ```
   Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

4. **Add tests** if applicable
5. **Update documentation** if you're changing functionality
6. **Run Construct checks** before submitting:
   ```bash
   construct-check
   construct-protect
   ```

## Development Setup

1. Fork and clone the repository:
   ```bash
   git clone https://github.com/yourusername/construct.git
   cd construct
   ```

2. Create a feature branch:
   ```bash
   git checkout -b feat/amazing-feature
   ```

3. Make your changes following Construct patterns

4. Test your changes:
   ```bash
   ./construct-setup  # Test setup process
   construct-check    # Verify no violations
   ```

5. Commit your changes:
   ```bash
   git commit -m "feat: Add amazing feature"
   ```

6. Push to your fork:
   ```bash
   git push origin feat/amazing-feature
   ```

7. Open a Pull Request

## What We're Looking For

### High Priority

- **Additional quality checks** for Swift 6 patterns
- **More example features** showcasing best practices
- **IDE integrations** (VS Code, Xcode extensions)
- **Performance optimizations** for large codebases
- **Documentation improvements** and examples

### Good First Issues

Look for issues labeled `good first issue` - these are great for newcomers:
- Documentation fixes
- Adding new design tokens
- Simple shell script improvements
- Example code additions

### Feature Ideas

- New commands for common workflows
- Additional AI platform support
- Enhanced metrics and reporting
- Team collaboration features
- CI/CD integrations

## Style Guides

### Shell Scripts

- Use bash (not sh)
- Include proper error handling
- Add helpful comments
- Use consistent formatting
- Follow existing patterns in `Template/AI/scripts/`

### Swift Code

- Follow Construct's own standards!
- Use design tokens, not hardcoded values
- Proper MVVM separation
- @MainActor on ViewModels
- Accessibility from the start

### Documentation

- Clear, concise writing
- Include code examples
- Explain the "why", not just the "how"
- Keep it up to date

## Testing

### Manual Testing

Test your changes with a fresh project:

```bash
# Create test project
cp -r construct test-construct
cd test-construct
./construct-setup

# Test your changes
construct-update
construct-check
# etc.
```

### Automated Testing

Run the test suite:

```bash
./scripts/run-tests.sh
```

## Commit Message Guidelines

We follow conventional commits:

```
feat: Add new command for component generation
fix: Resolve issue with Swift 6 detection
docs: Update installation guide for macOS 14
style: Format shell scripts consistently
refactor: Simplify update-context logic
test: Add tests for MVVM validation
chore: Update dependencies
```

### DECISION Tags

For architectural decisions, use `DECISION:` in your commit:

```
feat: Add component caching system

DECISION: Cache discovered components to improve performance
on large codebases. Cache invalidates on file changes.
```

## Questions?

Feel free to:
- Open an issue for discussion
- Ask in our Discord community
- Tweet [@construct_swift](https://twitter.com/construct_swift)

## Recognition

Contributors will be:
- Listed in our README
- Mentioned in release notes
- Invited to our contributors Discord channel
- Eligible for Construct swag (for significant contributions)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Trust The Process** - and thank you for contributing to make it even better!