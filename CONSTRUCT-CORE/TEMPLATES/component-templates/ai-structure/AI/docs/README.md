# AI Documentation Directory

This directory contains **context and documentation FOR the AI assistant** to understand and work with CONSTRUCT development.

## Purpose

The AI/docs/ directory serves as the AI's knowledge base about:
- Development patterns the AI should follow
- Architecture rules for AI to enforce  
- Current project state for AI understanding
- Auto-generated documentation that keeps the AI informed

## Directory Structure

```
AI/docs/
├── README.md                    # This file
├── automated/                   # Auto-generated architecture documentation
│   ├── _old/                   # Backup files from updates
│   ├── architecture-overview-automated.md
│   ├── script-reference-automated.md
│   ├── development-patterns-automated.md
│   ├── improving-CONSTRUCT-guide-automated.md
│   └── api-reference-automated.md
└── [manual docs]               # Manual AI guidance documents (if any)
```

## Key Files

### Auto-Generated Documentation (`automated/`)
These files are **automatically generated** by `./CONSTRUCT/scripts/construct/update-architecture.sh`:

- **`architecture-overview-automated.md`** - Complete system architecture and design principles
- **`script-reference-automated.md`** - Documentation of all scripts and library functions  
- **`development-patterns-automated.md`** - Coding standards and patterns for CONSTRUCT
- **`improving-CONSTRUCT-guide-automated.md`** - Current development status and metrics
- **`api-reference-automated.md`** - Detailed API documentation for library functions

### Root AI Context (`../CLAUDE.md`)
The main AI context file that auto-updates with current development state.

## How AI Uses This Documentation

### For Development Assistance
- **Architecture Understanding**: AI learns CONSTRUCT's dual-environment design
- **Pattern Enforcement**: AI suggests code that follows established patterns
- **Component Awareness**: AI knows what scripts and functions already exist
- **Quality Standards**: AI applies documented coding standards

### For Code Generation
- **Template Following**: AI generates code matching existing patterns
- **Library Usage**: AI suggests appropriate library functions
- **Configuration Integration**: AI understands config-driven validation
- **Error Handling**: AI follows established error handling patterns

### For Architecture Guidance
- **Design Decisions**: AI understands architectural principles
- **Best Practices**: AI applies documented development patterns
- **Quality Gates**: AI knows what validation checks to recommend
- **Documentation Standards**: AI maintains documentation consistency

## Difference from Human Documentation

### AI/docs/ (This Directory)
- **Audience**: AI assistant
- **Purpose**: Enable AI to understand and enforce CONSTRUCT patterns
- **Content**: Technical implementation details, coding standards, current state
- **Updates**: Mostly auto-generated, kept current with implementation

### /docs/ (Human Documentation)  
- **Audience**: Human developers
- **Purpose**: Help humans use and contribute to CONSTRUCT
- **Content**: User guides, tutorials, setup instructions, conceptual explanations
- **Updates**: Manually maintained, focused on user experience

## Maintenance

### Automatic Updates
The `automated/` directory is kept current by:
```bash
./CONSTRUCT/scripts/construct/update-architecture.sh
```
Run automatically during git pre-commit hooks.

### Manual Updates
Add manual AI guidance documents directly to `AI/docs/` (not in `automated/` subdirectory).

### Backup Management
- Backups stored in `automated/_old/`
- No automatic cleanup - files preserved for history
- Timestamped for easy identification

## Integration with Development Workflow

### Daily Development
1. AI reads current context from `../CLAUDE.md`
2. AI references patterns from `automated/development-patterns-automated.md`
3. AI suggests components from `automated/script-reference-automated.md`
4. AI enforces architecture from `automated/architecture-overview-automated.md`

### Quality Assurance
- AI applies standards from automated documentation
- AI suggests library functions from API reference
- AI validates against documented patterns
- AI recommends fixes based on quality standards

---

**Note**: This directory enables AI-assisted development by providing comprehensive, current documentation of CONSTRUCT's architecture, patterns, and implementation details.