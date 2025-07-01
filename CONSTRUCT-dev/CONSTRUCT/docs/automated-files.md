# CONSTRUCT Development Automated Files

This document lists all files that are automatically generated or updated by CONSTRUCT development scripts.

## Auto-Updated Files

### 1. CLAUDE.md (Auto-Updated Sections)
**Script**: `./CONSTRUCT/scripts/update-context.sh`  
**File**: `/CONSTRUCT-dev/CLAUDE.md`  
**Updates**: Appends auto-generated sections with current development state
- Current component counts (shell scripts, libraries, configs)
- Git status and branch information
- Template health status
- Available development tools
- Last updated timestamps

### 2. Quality Reports
**Script**: `./CONSTRUCT/scripts/check-quality.sh`  
**Location**: `/CONSTRUCT-dev/AI/dev-logs/check-quality/`  
**Creates**: `quality-report-YYYY-MM-DD--HH-MM-SS.md`
- Timestamped quality analysis reports
- Shell script syntax validation results
- Configuration file validation checks
- Code duplication analysis
- Library function documentation coverage

### 3. Structure Analysis
**Script**: `./CONSTRUCT/scripts/scan_construct_structure.sh`  
**Location**: `/CONSTRUCT-dev/AI/structure/`  
**Creates**: `construct-structure-YYYY-MM-DD--HH-MM-SS.md`  
**Updates**: `current-structure.md`
- Complete shell script inventory
- Library function analysis and counts
- Configuration file mapping
- Directory structure documentation
- Development insights and metrics

### 4. Architecture Documentation
**Script**: `./CONSTRUCT/scripts/update-architecture.sh`  
**Location**: `/CONSTRUCT-dev/AI/docs/automated/`  
**Creates**: Five comprehensive architecture documents with `-automated.md` suffix
- `architecture-overview-automated.md` - System architecture and principles
- `script-reference-automated.md` - Complete script and library documentation
- `development-patterns-automated.md` - Coding standards and patterns
- `improving-CONSTRUCT-guide-automated.md` - Development status dashboard
- `api-reference-automated.md` - Library function API documentation
**Backups**: Stored in `/CONSTRUCT-dev/AI/docs/automated/_old/`

### 5. Session Summaries
**Script**: `./CONSTRUCT/scripts/session-summary.sh`  
**Location**: `/CONSTRUCT-dev/AI/dev-logs/session-states/`  
**Creates**: Session state files when context reaches capacity
- Development session preservation
- Context summaries for continuity
- Work progress documentation

### 6. Backup Files
**Various Scripts**: Multiple scripts create backup files  
**Pattern**: `*.backup-YYYYMMDD-HHMMSS`  
**Purpose**: Preserve previous versions when updating existing files
- Configuration file backups
- Documentation version preservation
- Safe update mechanisms

## File Naming Conventions

### Timestamped Files
All automated files use consistent timestamp format:
- **Date**: `YYYY-MM-DD`
- **Time**: `HH-MM-SS`
- **Example**: `quality-report-2025-06-30--15-35-12.md`

### Backup Files
Backup files append timestamp to original filename:
- **Pattern**: `original-file.backup-YYYYMMDD-HHMMSS`
- **Example**: `CLAUDE.md.backup-20250630-153512`

## Automated File Management

### Old File Handling
- **Structure scans**: Moved to `_old/` directory automatically
- **Quality reports**: Retained indefinitely for historical analysis
- **Backups**: Created before any file updates

### File Rotation
- No automatic deletion - files preserved for historical analysis
- Manual cleanup can be performed if needed
- Timestamped files allow easy identification of recent vs old

## Development Workflow Integration

### Daily Development
1. `./CONSTRUCT/scripts/update-context.sh` - Updates CLAUDE.md with current state
2. `./CONSTRUCT/scripts/check-quality.sh` - Generates quality report
3. `./CONSTRUCT/scripts/scan_construct_structure.sh` - Updates structure analysis

### Session Management
- `./CONSTRUCT/scripts/session-summary.sh` - Creates session state when context full
- Automated backups before major updates
- Continuous documentation of development progress

## Benefits of Automated Files

### Development Tracking
- **Historical Record**: Complete timeline of development progress
- **Quality Metrics**: Continuous quality assessment and improvement
- **Structure Evolution**: Documentation of architectural changes

### Context Preservation
- **AI Context**: Always current development state for AI assistance
- **Session Continuity**: Preserved context across development sessions
- **Knowledge Retention**: Automated documentation prevents knowledge loss

### Quality Assurance
- **Continuous Validation**: Regular quality checks with historical comparison
- **Issue Tracking**: Timestamped reports show quality trends
- **Regression Detection**: Historical data enables comparison

---

**Note**: All automated files are designed to preserve development history while maintaining current state information for optimal AI-assisted development workflows.