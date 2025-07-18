# CONSTRUCT Orchestrator

## Purpose

The orchestrator provides intelligent language detection and routing to ensure the right tools are used for the right context.

## How It Works

1. **Detection**: Analyzes file extensions, project structure, and configuration files
2. **Routing**: Routes commands to appropriate language-specific adapters
3. **Context**: Maintains awareness of multi-language projects

## Components (Coming Soon)

- `detect-language.sh` - Identifies project type and languages
- `route-command.sh` - Routes commands to appropriate adapters
- `context-manager.sh` - Manages multi-language context switching

## Example Flow

```bash
# User runs a command
construct check-quality

# Orchestrator detects context
# - Finds .swift files → Routes to Swift adapter
# - Finds .cs files → Routes to C# adapter
# - Finds CONSTRUCT scripts → Routes to shell adapter

# Each adapter runs appropriate tools
# Results are aggregated and reported
```

## Integration

The orchestrator works with:
- `/adapters/` - Language-specific implementations
- `/scripts/` - Core CONSTRUCT tools
- `/patterns/` - Pattern validators for each language

## Future Enhancements

- Automatic language detection from file content
- Multi-language project support (iOS + backend)
- Intelligent command suggestion based on context