# CONSTRUCT Core Scripts

The universal orchestration engine for CONSTRUCT. This is the stable, production-ready core that provides intelligent development assistance through dynamic context engineering.

## What's Here

### Core Scripts (`scripts/`)
- **construct/** - AI-powered project initialization and pattern extraction
  - `init-construct.sh` - Claude SDK-powered intelligent project analyzer
  - `assemble-claude.sh` - Pattern assembly engine
- **workspace/** - Project management and organization
  - `create-project.sh` - Create new CONSTRUCT-managed projects
  - `import-project.sh` - Import existing projects with AI analysis
  - `workspace-status.sh` - View all managed projects
  - `workspace-update.sh` - Update all project contexts
- **validation/** - Quality and architecture checks
  - `check-architecture.sh` - Validate pattern compliance
  - `check-quality.sh` - Code quality validation
  - `check-documentation.sh` - Documentation coverage
- **update/** - Context and documentation management
  - `update-context.sh` - Refresh CLAUDE.md dynamic sections
  - `update-architecture.sh` - Generate architecture docs

### Libraries (`lib/`)
- **construct-init/** - AI orchestration libraries
  - `common.sh` - Claude SDK integration, streaming, caching
  - `pattern-extractor.sh` - Three-level pattern extraction
- **validation/** - Shared validation functions
- **patterns/** - Pattern management utilities

### Configuration (`config/`)
- Pattern rules and validators
- Architecture definitions
- Quality standards

## Key Features

### AI-Native Intelligence
The breakthrough `init-construct.sh` script uses Claude SDK to:
- Analyze existing CLAUDE.md files for project knowledge
- Extract patterns into reusable components
- Generate focused, project-specific context
- Support both quick (default) and deep (--extract) analysis modes

### Pattern System
- Dynamic loading based on current work
- Project-specific patterns take priority
- Brief references, not pattern dumps
- Real-time context awareness

### Quality Gates
- Pre-commit hooks for validation
- Architecture compliance checks
- Documentation generation
- Context freshness maintenance

## Version

Current version: 2.0.0 (AI-Native Orchestrator)

## Usage

This directory is designed to be:
- **Symlinked** from CONSTRUCT-LAB for development
- **Embedded** in user projects via import-project.sh
- **Promoted to** from LAB when features stabilize

## Development Workflow

1. **Never edit these files directly** - Use CONSTRUCT-LAB
2. **Test in LAB first** - All experiments happen there
3. **Promote when stable** - Use promotion workflow
4. **Maintain compatibility** - Don't break existing projects