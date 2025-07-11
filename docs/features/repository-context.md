# Repository Context in Logs

## Overview

All CONSTRUCT scripts that generate logs, reports, or documentation now include repository context information at the top of their output. This ensures you always know which project and repository the log belongs to, especially important when working with multiple projects.

## Repository Information

Scripts automatically detect and include:
- **Repo**: The repository name (from git remote or directory name)
- **Remote**: The git remote URL or "None (local only)"
- **Branch**: The current git branch

### Example Output

```markdown
# CONSTRUCT Development Session Summary: 2025-07-09 10:22
**Duration**: Since 2025-07-09 10:20:55
**Repo**: my-ios-app
**Remote**: git@github.com:parker/my-ios-app.git
**Branch**: feature/dark-mode
**Context Usage**: ~90% (summary triggered)
```

For local repositories without a remote:
```markdown
**Repo**: test003
**Remote**: None (local only)
**Branch**: main
```

## How It Works

1. **Remote Detection**: Scripts check `git config --get remote.origin.url`
2. **Name Extraction**: Repository name is parsed from the remote URL
3. **Fallback**: If no remote exists, uses the directory name
4. **URL Formats**: Handles both SSH and HTTPS git URLs

### Supported URL Formats
- SSH: `git@github.com:user/repo.git`
- HTTPS: `https://github.com/user/repo.git`
- GitLab, Bitbucket, and other providers work the same way

## Scripts with Repository Context

The following scripts in `/scripts/` include repository context:

### Development Logs
- **session-summary.sh** - Session summaries with repo context
- **generate-devupdate.sh** - Development updates show which repo changed
- **pre-commit-review.sh** - Pre-commit summaries include repo info

### Quality Reports
- **check-quality.sh** - Quality reports identify the repository
- **scan_project_structure.sh** - Structure analysis includes repo details
- **update-architecture.sh** - Architecture docs show repository context

## Implementation Details

### Common Function

All scripts use a shared function from `lib/common-patterns.sh`:

```bash
# Usage: eval $(get_repo_info)
# Sets: REPO_NAME and REMOTE_URL
get_repo_info() {
    local project_dir="${1:-$(pwd)}"
    local remote_url=$(cd "$project_dir" && git config --get remote.origin.url 2>/dev/null || echo "")
    local repo_name=""
    
    if [ -n "$remote_url" ]; then
        # Extract repo name from remote URL
        repo_name=$(echo "$remote_url" | sed 's/.*[:/]\([^/]*\)\.git$/\1/')
        echo "REPO_NAME=\"$repo_name\""
        echo "REMOTE_URL=\"$remote_url\""
    else
        # No remote, use directory name
        repo_name=$(basename "$project_dir")
        echo "REPO_NAME=\"$repo_name\""
        echo "REMOTE_URL=\"None (local only)\""
    fi
}
```

### Usage in Scripts

```bash
# Get repository info
eval $(get_repo_info "$PROJECT_DIR")

# Use in output
cat > "$OUTPUT_FILE" << EOF
# Report Title
**Date**: $(date)
**Repo**: $REPO_NAME
**Remote**: $REMOTE_URL
**Branch**: $(git branch --show-current)
EOF
```

## Benefits

1. **Multi-Project Clarity**: Instantly identify which project a log belongs to
2. **Remote Tracking**: Know if a project is connected to GitHub/GitLab
3. **Context Preservation**: Repository info is preserved in all logs
4. **Dynamic Updates**: If remote changes, logs reflect the new repository

## Future Enhancements

- Include last push/pull timestamps
- Show divergence from remote (ahead/behind)
- Display repository visibility (public/private)
- Add repository size and statistics