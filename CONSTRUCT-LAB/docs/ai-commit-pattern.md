# AI Commit Output Pattern

When making commits, always show the full pre-commit hook output to the user.

## Pattern to Follow:

```
I'll commit the changes now. Here's the pre-commit hook output:

[FULL HOOK OUTPUT HERE]

The commit was successful! The hooks:
- ✅ Validated architecture 
- ✅ Updated documentation
- ✅ Ran quality checks
- etc.
```

## Why This Matters:
- User sees the validation process
- Transparency in what hooks are doing
- Confirms quality checks passed
- Shows what files were auto-generated

## DO NOT:
- Just say "committed successfully"
- Hide the hook output
- Summarize without showing the actual output