# CONSTRUCT Development Context

## Universal Development Principles

These core principles apply to ALL development work, regardless of language or platform:

### ✅ DO: Foundation Rules
- **Never break existing tests** - Changes must maintain backward compatibility
- **Document why, not what** - Code should be self-explanatory, comments explain reasoning
- **Error handling is mandatory** - All failure modes must be handled gracefully
- **Security first** - Never expose secrets, validate all inputs, follow security best practices
- **Performance awareness** - Consider impact of changes on system performance

### ❌ DON'T: Universal Anti-patterns
- Hardcoded values that should be configurable
- Silent failures without error reporting
- Breaking changes without proper versioning
- Security vulnerabilities (exposed secrets, unvalidated inputs)
- Code without proper testing

## Multi-Context Awareness

This context system understands your entire project ecosystem. When you mention files, entities, or tasks, I'll automatically apply the appropriate patterns based on:

- **File extensions** (*.swift, *.cs, *.ts, *.sh, etc.)
- **Directory structure** (CONSTRUCT/**, Models/, Services/, etc.)
- **Project type** (iOS app, web API, full-stack application)
- **Task context** (adding features, fixing bugs, refactoring)

## Pattern System Overview

Your development patterns are organized as plugins that can be mixed and matched based on your project needs:

### Base Patterns (Always Active)
- Universal development principles
- Security and performance standards
- Documentation requirements
- Testing standards

### Language Patterns
- Swift/iOS development patterns
- C#/.NET backend patterns
- TypeScript/JavaScript patterns
- Shell scripting standards

### Architectural Patterns
- MVVM for client applications
- Clean Architecture for backends
- Microservices patterns
- API design standards

### Cross-Platform Patterns
- Model synchronization across stack
- API contract management
- Multi-language coordination

### Tooling Patterns
- CONSTRUCT development workflow
- CI/CD pipeline standards
- Development tools and scripts

## How Pattern Selection Works

Patterns are automatically activated based on your project configuration and the files you're working with. You can also explicitly enable/disable patterns by updating your project's pattern configuration.

### Dynamic Context Application
When you mention specific tasks or files, I'll automatically focus on the relevant patterns:

- Working on a Swift View → Swift language + MVVM patterns
- Updating an API endpoint → Backend patterns + cross-platform considerations
- Writing shell scripts → Shell scripting + tooling patterns
- CONSTRUCT development → CONSTRUCT-specific workflow patterns

## Development Quality Standards

### Code Quality
- All code must be readable and maintainable
- Follow language-specific style guides and conventions
- Use appropriate design patterns for the context
- Implement proper error handling and logging

### Testing Requirements
- Unit tests for business logic
- Integration tests for API endpoints
- UI tests for critical user flows
- Performance tests for bottlenecks

### Documentation Standards
- README files for all projects and major components
- API documentation for public interfaces
- Architectural decision records for significant choices
- Code comments for complex logic or business rules

### Security Standards
- Never commit secrets or API keys
- Validate all user inputs
- Use parameterized queries for database access
- Implement proper authentication and authorization
- Follow OWASP guidelines for web applications

## Pattern Configuration

Below you'll see which patterns are currently active for your project. You can toggle patterns on/off by editing your project's `.construct/patterns.yaml` file and regenerating this context.

To modify patterns:
1. Edit `.construct/patterns.yaml` for project-specific rules
2. Create new plugins in `CONSTRUCT-LAB/patterns/plugins/` for reusable patterns
3. Run `construct-patterns regenerate` to update this file

**Remember**: This file is generated automatically. Don't edit it directly - use the pattern configuration system instead.