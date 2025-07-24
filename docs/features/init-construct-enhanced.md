# Enhanced init-construct: AI-Native Intelligent Orchestrator

This document explains the enhanced `init-construct.sh` script that provides AI-powered, intelligent initialization for CONSTRUCT projects, working seamlessly with Claude Code's `/init` command.

## 🚀 Major Updates (July 2025)

### AI-Native Architecture
- **Claude SDK Integration**: Full AI-powered analysis replacing regex patterns
- **Intelligent Pattern Detection**: Claude analyzes content for extractable patterns
- **Smart Project Analysis**: AI-driven language and framework detection
- **Three-Level Extraction**: Comprehensive pattern extraction system

### Production Features
- **--dry-run Mode**: Preview changes without modifications
- **Token Bucket Rate Limiting**: Prevents API rate limit violations
- **Response Caching**: Reduces redundant API calls
- **Concurrent Processing**: Parallel category extraction (3 at a time)
- **Configuration System**: YAML-based configuration with environment overrides
- **Log Rotation**: Automatic log management with compression
- **Comprehensive Testing**: Full unit test suite

### Modular Architecture
- **lib/construct-init/common.sh**: Shared utilities, logging, rate limiting
- **lib/construct-init/config.sh**: Configuration management
- **lib/construct-init/pattern-extractor.sh**: Concurrent pattern extraction

## Overview

The enhanced init-construct implements a progressive enhancement approach with intelligent AI-powered analysis:

1. **Mode 1: First-time CONSTRUCT users** - AI-powered plugin recommendations
2. **Mode 2: Existing CONSTRUCT users** - Pattern regeneration from `.construct/patterns.yaml`
3. **Mode 3: Legacy migration** - Three-level AI extraction from existing CLAUDE.md

## Philosophy: Progressive Enhancement

The key principle is to **work WITH /init, not against it**. The system preserves ALL content from `/init` while adding CONSTRUCT's pattern-based enhancements.

```
Stage 1: /init → Creates initial CLAUDE.md with project context
Stage 2: init-construct → AI-enhanced patterns and infrastructure
```

## 🏗️ Unified CONSTRUCT/ Architecture

### Revolutionary Folder Structure
Every project gets the same structure as CONSTRUCT-LAB:

```
myproject/
├── CONSTRUCT/              # ← Unified CONSTRUCT content
│   ├── CONSTRUCT/          # ← Symlink to tools (not tracked)
│   ├── AI/                 # ← Project AI documentation
│   └── patterns/           # ← Project-specific patterns
│       └── plugins/        # ← Extracted patterns
├── .construct/             # ← Pure metadata (hidden)
│   └── patterns.yaml       # ← Configuration
├── src/
└── package.json
```

**Why This Is Genius**:
- **Consistent Architecture**: Same mental model everywhere
- **Clean Separation**: Visible CONSTRUCT content vs hidden metadata
- **Familiar Pattern**: Symlinks for tools (like LAB)
- **Git Friendly**: Tools symlinked, content tracked

## Operating Modes

### Mode 1: First-time CONSTRUCT users (AI Recommendations)

**Detection**: No `.construct/patterns.yaml` file exists

**Flow**:
1. Claude SDK analyzes entire project structure
2. AI detects languages, frameworks, and architectures
3. Recommends patterns with confidence scores
4. Creates `.construct/patterns.yaml` with selections
5. Installs complete CONSTRUCT infrastructure
6. Enhances CLAUDE.md with pattern content

**Example Session**:
```bash
$ /init  # Claude Code creates initial CLAUDE.md
$ construct-init

🚀 CONSTRUCT Integration System
===============================
🔍 Phase 0: Verifying Claude SDK availability...
  ✅ Claude SDK found: claude 0.1.0
  ℹ️  Using system prompts to enforce structured output

🔍 Phase 1: Assessing project state...
  ✅ CLAUDE.md exists
  🧠 Analyzing CLAUDE.md content with AI...
  🤖 Analyzing with Claude SDK (30s timeout)...
  📝 Custom patterns detected (AI confidence: 0.85)
    Type: project-specific, Reason: Contains SwiftUI patterns

🛠️ Phase 2: Installing missing CONSTRUCT infrastructure...
  🏗️ Creating unified CONSTRUCT/ folder structure...
  🔗 Linking CONSTRUCT tools (live repo mode)...
  ✅ AI documentation structure installed
  ✅ Pattern configuration installed
  ✅ Git hooks installed

🧠 Phase 4: AI-Native project analysis...
  🔍 Analyzing project structure with AI...
  ✓ AI analysis complete
  📋 Project type: iOS SwiftUI application
  🔤 Detected languages: swift 
  🔌 Recommended plugins: tooling/shell-scripting cross-platform/model-sync
  📊 Confidence level: 90%
```

### Mode 2: Existing User (Pattern Regeneration)

**Detection**: `.construct/patterns.yaml` exists

**Flow**:
1. Reads existing pattern configuration
2. Preserves ALL content from `/init` in CLAUDE.md
3. Regenerates pattern sections with latest content
4. Updates infrastructure if needed
5. Validates all components

### Mode 3: Legacy Migration (Three-Level Extraction)

**Detection**: CLAUDE.md exists with extractable patterns

**AI-Powered Three-Level Extraction**:

#### Level 1: Complete Blob Extraction
```bash
📦 Level 1: Complete blob extraction...
📋 Extracting complete project patterns...
✅ Complete project patterns extracted
```
- Extracts ALL project-specific content
- Creates `extracted-{project}-all` plugin
- Preserves full context for other levels

#### Level 2: Categorized Extraction (Concurrent)
```bash
🗂️ Level 2: Categorized pattern extraction (concurrent)...
📁 Starting architectural extraction... (1/10)
📁 Starting frameworks extraction... (2/10)
📁 Starting languages extraction... (3/10)
⏳ Waiting for all extractions to complete...
✅ All category extractions completed
```
- Processes 10 categories in parallel (max 3 concurrent)
- AI analyzes content for each category
- Creates focused pattern plugins
- Token bucket prevents rate limiting

#### Level 3: Uncategorized Patterns
```bash
📌 Level 3: Uncategorized pattern extraction...
✅ Uncategorized patterns extracted
```
- Extracts REMAINDER content not in categories
- Captures project-specific details
- Ensures nothing is lost

## Command-Line Options

### --dry-run Mode
Preview all changes without making modifications:
```bash
$ construct-init --dry-run

🚀 CONSTRUCT Integration System
===============================
🔍 Running in DRY-RUN mode - no changes will be made

[DRY-RUN] Would create script_log.txt
[DRY-RUN] Would backup CLAUDE.md to CLAUDE.md.backup
[DRY-RUN] Would extract complete patterns to: CONSTRUCT/patterns/plugins/extracted-MyProject-all/
[DRY-RUN] Would extract patterns for categories: architectural frameworks languages...
```

### --verbose Mode
Enable detailed debug output:
```bash
$ construct-init --verbose

🔍 Loaded common.sh module with token bucket and caching
🔍 Loaded pattern-extractor.sh module
🔍 Loaded config.sh module
🔍 Claude API call attempt 1/3
🔍 Consumed API token (remaining: 9)
🔍 Cache miss for key a1b2c3d4...
```

### --help
Display usage information:
```bash
$ construct-init --help

Usage: construct-init [OPTIONS]

Options:
  --dry-run    Preview changes without making them
  --verbose    Enable verbose output
  --help       Show this help message

Environment variables:
  CONSTRUCT_CATEGORIES         Comma-separated list of categories to extract
  CONSTRUCT_TOKEN_BUCKET_SIZE  Token bucket size (default: 10)
  CONSTRUCT_TOKEN_REFILL_RATE  Token refill rate (default: 2)
  CONSTRUCT_CACHE_MAX_AGE      Cache TTL in seconds (default: 3600)
  MAX_CONCURRENT               Max concurrent extractions (default: 3)
```

## Technical Implementation

### AI-Native Project Analysis

The script uses Claude SDK for intelligent detection:

```bash
# Claude analyzes project files and structure
Project files found:
./src/App.swift
./src/ViewModels/MainViewModel.swift
./Package.swift

Config files found:
./Package.swift

# AI returns structured analysis
{
  "detected_languages": ["swift"],
  "detected_frameworks": ["swiftui"],
  "recommended_patterns": {
    "languages": ["swift"],
    "plugins": ["tooling/shell-scripting", "architectural/mvvm-ios"]
  },
  "confidence": {
    "languages": 0.95,
    "recommendations": 0.90
  },
  "project_description": "iOS SwiftUI application with MVVM architecture"
}
```

### Token Bucket Rate Limiting

Prevents API rate limit violations:
```bash
# Configuration (environment or config.yaml)
CONSTRUCT_TOKEN_BUCKET_SIZE=10    # Max burst capacity
CONSTRUCT_TOKEN_REFILL_RATE=2     # Tokens per second

# During execution
🔍 Consumed API token (remaining: 9)
🔍 Consumed API token (remaining: 8)
🔍 Rate limit: waiting for tokens (available: 0)
🔍 Consumed API token (remaining: 1)
```

### Response Caching

Reduces redundant API calls:
```bash
# Cache configuration
CONSTRUCT_CACHE_DIR=~/.cache/construct
CONSTRUCT_CACHE_MAX_AGE=3600  # 1 hour

# Cache behavior
🔍 Cache miss for key a1b2c3d4...
🔍 Saved to cache: a1b2c3d4...
🔍 Cache hit for key a1b2c3d4... (age: 120s)
```

### Configuration System

Flexible configuration with multiple sources:

```yaml
# .construct/config.yaml
api:
  token_bucket_size: 10
  token_refill_rate: 2
  max_retries: 3
  timeout: 30

cache:
  directory: ~/.cache/construct
  max_age: 3600
  cleanup_days: 7

extraction:
  max_concurrent: 3
  categories:
    - architectural
    - frameworks
    - languages
    # ... more categories

logging:
  level: info
  file: ~/.construct/logs/init.log
  rotate_size: 10485760
  keep_count: 5
```

### Modular Architecture

#### lib/construct-init/common.sh
- Logging functions with rotation
- Token bucket implementation
- Cache management
- Claude SDK retry logic
- Temp file cleanup handlers

#### lib/construct-init/config.sh
- YAML configuration parsing
- Environment variable overrides
- Default configuration values
- Multi-location config search

#### lib/construct-init/pattern-extractor.sh
- Concurrent extraction logic
- Category-specific processing
- Pattern metadata creation
- Progress tracking

## Integration with Workspace Scripts

### create-project.sh
```bash
# Two-stage initialization for new projects
create-project.sh MyApp
cd Projects/MyApp
/init                    # Stage 1: Base CLAUDE.md
construct-init           # Stage 2: AI enhancement
```

### import-project.sh
```bash
# Migration path for existing projects
import-project.sh /path/to/existing/project
cd Projects/ImportedProject
construct-init           # AI extracts patterns
```

## Error Handling

The script includes comprehensive error handling:

1. **Claude SDK Failures**: Retry with exponential backoff
2. **Rate Limiting**: Token bucket prevents violations
3. **Timeouts**: Cross-platform timeout handling
4. **Cache Errors**: Graceful degradation
5. **File Permissions**: Pre-checks before modifications
6. **Cleanup**: Trap handlers for temp files

## Best Practices

### For New Projects
1. Always run `/init` first to establish base context
2. Run `construct-init` immediately after for AI enhancement
3. Review generated `.construct/patterns.yaml`
4. Commit infrastructure to version control

### For Existing Projects
1. Use `--dry-run` first to preview changes
2. Review three-level extraction results
3. Check `CONSTRUCT/patterns/plugins/` for extracted patterns
4. Validate with `construct-check`

### Performance Optimization
1. Use caching for repeated runs
2. Limit categories with `CONSTRUCT_CATEGORIES` env var
3. Adjust `MAX_CONCURRENT` for your system
4. Monitor token bucket with `--verbose`

## Testing

Comprehensive test suite available:
```bash
# Run all unit tests
./CONSTRUCT-CORE/CONSTRUCT/tests/run-unit-tests.sh

# Test specific module
./CONSTRUCT-CORE/CONSTRUCT/tests/unit/test-common.sh
./CONSTRUCT-CORE/CONSTRUCT/tests/unit/test-config.sh
./CONSTRUCT-CORE/CONSTRUCT/tests/unit/test-pattern-extractor.sh
```

## Troubleshooting

### Common Issues

**"Claude SDK is required but not found"**
- Install Claude SDK: https://docs.anthropic.com/claude/docs/claude-sdk
- CONSTRUCT is AI-Native and requires Claude SDK

**"jq is required for JSON parsing"**
- Install jq for JSON parsing
- Required for AI analysis results

**Rate limiting issues**
- Adjust `CONSTRUCT_TOKEN_BUCKET_SIZE`
- Increase delays between calls
- Use cache to reduce API calls

### Debug Mode
```bash
# Enable full debug output
DEBUG=1 construct-init --verbose

# Check logs
tail -f ~/.construct/logs/construct-init.log
```

## Recent Improvements

### From Latest Commits:
1. **Complete Test Suite** (commit 6eed99e)
   - Unit tests for all modules
   - Test framework with assertions
   - Mock support for testing

2. **Three-Level Extraction** (commit a279359)
   - Complete blob extraction
   - Concurrent categorized extraction
   - Remainder pattern extraction

3. **Major Refactoring** (commit 859d4b5)
   - Modular architecture
   - Token bucket rate limiting
   - Response caching system

4. **AI-Native Implementation** (commit 3f7478e)
   - Claude SDK integration
   - Cross-platform timeouts
   - Intelligent orchestration

## Related Documentation

- [assemble-claude.md](./assemble-claude.md) - Pattern assembly engine
- [Library Documentation](../../CONSTRUCT-CORE/CONSTRUCT/lib/README.md) - Module reference
- [CLAUDE-BASE Template](../core/claude-base-template.md) - Base template system
- [Interactive Scripts](./interactive-scripts.md) - Claude Code integration