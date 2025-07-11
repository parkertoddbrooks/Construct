#!/bin/bash

# CONSTRUCT Development Pattern - Architecture Generator
# Generates CONSTRUCT-specific architecture documentation

set -e

PROJECT_DIR="${1:-.}"

cat << 'EOF'
## CONSTRUCT Development Architecture

CONSTRUCT uses a three-layer architecture:

### 1. CONSTRUCT-CORE
- Universal orchestration engine (stable, production-ready)
- Language-agnostic tools that work everywhere
- Stable, versioned releases
- Embedded in both LAB and TEMPLATES via symlinks

### 2. CONSTRUCT-LAB
- Development and experimentation environment
- Test new features and improvements
- Contains all development artifacts and history
- Uses CONSTRUCT-CORE for its own operations

### 3. TEMPLATES
- Clean, production-ready starting points
- Currently: swift-ios (more coming)
- Each template embeds CONSTRUCT-CORE
- No development artifacts, just what users need

### Directory Structure

```
CONSTRUCT/
├── CONSTRUCT-CORE/              # Universal orchestration engine
│   ├── orchestrator/           # Language detection and routing
│   ├── adapters/              # Language-specific implementations
│   ├── scripts/               # Core workflow scripts
│   │   ├── core/             # General-purpose orchestrators
│   │   ├── construct/        # CONSTRUCT-specific tools
│   │   ├── workspace/        # Workspace management
│   │   ├── dev/              # Development tools
│   │   └── patterns/         # Pattern validators
│   ├── lib/                   # Shared library functions
│   ├── config/                # Core configuration
│   └── VERSION                # Semantic versioning
├── CONSTRUCT-LAB/              # Development environment
│   ├── AI/                    # Development context and tools
│   │   ├── CLAUDE.md         # Auto-updating development context
│   │   ├── structure/        # Architecture snapshots
│   │   ├── todo/            # Development planning
│   │   └── dev-logs/        # Session documentation
│   ├── CONSTRUCT -> ../CONSTRUCT-CORE  # Symlink to core
│   └── experiments/          # New feature development
└── TEMPLATES/                  # Production-ready templates
    └── swift-ios/             # Swift/iOS template
        ├── AI/                # Template AI context
        ├── CONSTRUCT -> ../../CONSTRUCT-CORE  # Symlink
        └── swift/             # Swift project files
```

### Self-Improving System
- CONSTRUCT uses its own methodology to improve itself
- AI-assisted development workflows for both shell and Swift code
- Automated quality gates and architecture enforcement
- Continuous documentation updates

### Architecture Principles

#### Dual Environment Design
- **Separation of Concerns**: CONSTRUCT development vs user development
- **Identical Patterns**: Same workflow commands across different domains
- **Domain Expertise**: Each environment understands its architectural patterns
- **Cross-Pollination**: Insights from one environment improve the other

#### Pattern-Based Architecture
- All functionality delivered through patterns
- Scripts are orchestrators that delegate to patterns
- Patterns bring their own validators, generators, and documentation
- CONSTRUCT itself uses patterns for its development
EOF