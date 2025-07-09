# CONSTRUCT Scripts

## Purpose

Core CONSTRUCT tools and master orchestration scripts that coordinate pattern-based validation across projects.

## Script Categories

### Master Orchestrators
These scripts coordinate pattern-specific validators:
- `check-quality.sh` - Orchestrates code quality validation
- `check-architecture.sh` - Orchestrates architecture validation
- `check-documentation.sh` - Orchestrates documentation validation

### Core Infrastructure
Essential CONSTRUCT functionality:
- `assemble-claude.sh` - Assembles CLAUDE.md from patterns
- `update-context.sh` - Updates project context files
- `before_coding.sh` - Pre-coding search and discovery
- `check-symlinks.sh` - Validates symlink integrity
- `workspace-status.sh` - Multi-project status overview

### Project Management
- `create-project.sh` - Create new projects with patterns
- `import-project.sh` - Import existing projects
- `construct-patterns.sh` - Pattern management interface

### Development Tools
- `session-summary.sh` - Creates session summaries
- `commit-with-review.sh` - Enhanced commit workflow
- `generate-devupdate.sh` - Generate development updates

## How Scripts Work

1. **Accept PROJECT_DIR**: All scripts accept a project directory parameter
2. **Detect Context**: Determine project type and active patterns
3. **Run Base Checks**: Perform universal validations
4. **Delegate to Patterns**: Call pattern-specific validators
5. **Aggregate Results**: Combine and report findings

## Usage Examples

```bash
# Check quality in current directory
./check-quality.sh

# Check architecture in specific project
./check-architecture.sh Projects/MyApp/ios

# Update context for a project
./update-context.sh Projects/MyBackend

# Search before creating new code
./before_coding.sh UserViewModel
```

## Integration with Patterns

Scripts work with `/patterns/` validators:
- Master scripts orchestrate
- Pattern validators do specific checks
- Results are aggregated and reported

## Best Practices

1. Always run from project root when possible
2. Use relative paths for portability
3. Check exit codes for automation
4. Run before committing changes