# CONSTRUCT

CONSTRUCT is a meta-framework that teaches how to build self-improving development systems. It provides both the tools and the philosophy for creating projects that get better with use.

## What is CONSTRUCT?

CONSTRUCT demonstrates a new development philosophy:
- **Living Documentation** - Docs that evolve from generic to specific through real experience
- **Distributed Quality** - Quality control that travels with the code
- **Self-Improving Systems** - Projects that learn from their own development

## The Three-Layer Architecture

```
CONSTRUCT/
├── CONSTRUCT-CORE/        # Stable, universal tools and templates
├── CONSTRUCT-LAB/         # Development and experimentation space
└── TEMPLATES/             # Production-ready project starters
```

### CONSTRUCT-CORE
The stable foundation containing:
- Universal orchestration tools
- Promotion system for quality control
- Templates for new projects
- Core documentation and philosophy

### CONSTRUCT-LAB
Your experimentation workspace:
- Test new features and improvements
- Develop with full CONSTRUCT tooling
- Explicit promotion path to CORE
- Safe space to break things

### TEMPLATES
Ready-to-use project templates:
- Currently: Swift/iOS with MVVM architecture
- Includes AI integration (CLAUDE.md)
- Self-enforcing architecture patterns
- Living documentation system

## Getting Started

### For Template Users (Swift/iOS Project)

1. **Use the Template**
   ```bash
   # Use GitHub's template feature or clone
   git clone https://github.com/yourusername/construct
   cd construct/TEMPLATES/swift-ios
   ```

2. **Set Up Your Project**
   ```bash
   ./construct-setup
   # Enter your project name when prompted
   ```

3. **Start Building**
   ```bash
   ./AI/scripts/update-context.sh    # Updates AI context
   ./AI/scripts/check-architecture.sh # Validates patterns
   ```

### For CONSTRUCT Contributors

1. **Fork CONSTRUCT**
   ```bash
   git clone https://github.com/yourusername/construct-fork
   cd construct-fork
   ```

2. **Work in LAB**
   ```bash
   cd CONSTRUCT-LAB/experiments/
   # Create new features
   ```

3. **Promote to CORE**
   ```bash
   # Add to promotion manifest
   vim ../PROMOTE-TO-CORE.yaml
   
   # Validate and promote
   ../tools/validate-promotion.sh
   ../tools/promote-to-core.sh
   ```

## The Philosophy

### Living Documentation
Documentation starts generic but evolves through real experience:
```
Static Template + Real Development + Discoveries = Living Truth
```

Every project builds its own wisdom through use.

### Distributed Quality
Quality control isn't centralized - it travels with the code:
- Every fork includes the promotion system
- Quality gates run locally before commits
- PRs arrive pre-validated
- Standards self-propagate

### Self-Improvement
CONSTRUCT uses its own methodology:
- LAB for experimentation
- Promotion system for quality
- Living docs for knowledge capture
- The system that builds systems

## Core Workflows

### The Promotion System
Nothing enters CORE by accident:
```bash
# 1. Develop in LAB
cd CONSTRUCT-LAB/experiments/
vim new-feature.sh

# 2. Test thoroughly
./new-feature.sh

# 3. Declare promotion
vim ../PROMOTE-TO-CORE.yaml

# 4. Validate
../tools/validate-promotion.sh

# 5. Promote
../tools/promote-to-core.sh
```

### Living Documentation Flow
```bash
# Start with template
./construct-setup

# Discover project truths
# ... development happens ...

# Document discoveries
vim AI/CLAUDE.md  # Add to "Validated Discoveries"

# Auto-update sections
./AI/scripts/update-context.sh
```

## For Different Audiences

### If You Want a Swift/iOS Project
- Go to `TEMPLATES/swift-ios/`
- Run `construct-setup`
- Start building with AI assistance

### If You Want to Improve CONSTRUCT
- Work in `CONSTRUCT-LAB/`
- Use the promotion system
- Submit pre-validated PRs

### If You Want to Create New Templates
- Study the Swift template structure
- Build in LAB first
- Promote to CORE/TEMPLATES
- Share with the community

### If You Want the Philosophy
- Read `CONSTRUCT-CORE/docs/distributed-quality-philosophy.md`
- Study the promotion system
- Apply patterns to your projects

## Key Documentation

### Core Philosophy
- [Distributed Quality Philosophy](CONSTRUCT-CORE/docs/distributed-quality-philosophy.md)
- [Promotion System Guide](CONSTRUCT-CORE/docs/promotion-system-guide.md)
- [Living Documentation Philosophy](CONSTRUCT-CORE/docs/living-documentation-philosophy.md) *(coming soon)*

### Quick References
- [Promotion Quick Reference](CONSTRUCT-LAB/docs/promotion-quick-reference.md)
- [Commands Reference](CONSTRUCT-CORE/docs/commands-readme.md)

### For Swift/iOS Development
- See `TEMPLATES/swift-ios/README.md`
- Check `AI/CLAUDE.md` after setup

## The Meta-Beauty

CONSTRUCT is:
- **A system that improves itself** (using LAB/CORE workflow)
- **A teacher that travels with code** (distributed quality)
- **A philosophy made tangible** (living documentation)

It's not just tools - it's a new way of thinking about how software should be built.

## Getting Help

- **Issues**: Report on the CONSTRUCT GitHub repository
- **Philosophy**: Read the docs in `CONSTRUCT-CORE/docs/`
- **Templates**: Check template-specific READMEs
- **Promotion**: See `CONSTRUCT-LAB/docs/promotion-quick-reference.md`

---

*"The best systems are those that teach you how to build better systems."*