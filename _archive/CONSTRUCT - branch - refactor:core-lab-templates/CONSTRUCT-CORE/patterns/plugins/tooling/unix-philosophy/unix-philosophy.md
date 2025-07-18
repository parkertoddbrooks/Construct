# [UNIX] The Linus Torvalds & Alan Cox Way

## When to Use
- When designing any tool or system
- When tempted to create complex abstractions
- When standard Unix tools already solve the problem
- When reviewing code for unnecessary complexity

## Core Philosophy

### Use Standard Tools
```bash
# ❌ WRONG: Custom hash validation logic
HASH=$(calculate_complex_hash "$FILE")
if [ "$HASH" = "$STORED_HASH" ]; then...

# ✅ RIGHT: Use shasum like everyone else
shasum -a 256 -c checksums.txt
```

### Simple > Clever
```bash
# ❌ WRONG: Clever one-liner nobody can read
find . -name "*.sh" -print0 | xargs -0 -I {} bash -c 'grep -l "pattern" "{}" && echo "{}" | sed "s/.*\///" | awk "{print \$1}"'

# ✅ RIGHT: Clear and obvious
for file in *.sh; do
    if grep -q "pattern" "$file"; then
        basename "$file"
    fi
done
```

### Do One Thing Well
```bash
# ❌ WRONG: Swiss army knife function
function process_file() {
    validate_file "$1"
    transform_content "$1"
    generate_report "$1"
    send_notifications "$1"
}

# ✅ RIGHT: Separate concerns
validate_file "$1"
transform_content "$1" 
generate_report "$1"
# Let another tool handle notifications
```

## The Torvalds Test

Before implementing anything, ask:
1. Does a standard Unix tool already do this?
2. Can I solve this with a pipeline of simple tools?
3. Will someone understand this in 6 months?
4. Am I being clever or being clear?

## The Cox Principles

### Fail Loudly
```bash
# ❌ WRONG: Silent failure
command 2>/dev/null || true

# ✅ RIGHT: Fail with clear error
if ! command; then
    echo "Error: Command failed" >&2
    exit 1
fi
```

### Don't Reinvent the Wheel
```bash
# ❌ WRONG: Custom file monitoring
while true; do
    check_if_file_changed
    sleep 1
done

# ✅ RIGHT: Use inotify/fswatch
fswatch -o file.txt | xargs -n1 -I{} echo "File changed"
```

### Text Streams are Universal
```bash
# ❌ WRONG: Binary protocols between tools
./tool1 --output-format=binary | ./tool2 --input-format=binary

# ✅ RIGHT: Plain text that humans can debug
./tool1 | ./tool2
```

## Common Anti-Patterns

### The "Not Invented Here" Syndrome
```bash
# ❌ WRONG: Custom JSON parser in bash
parse_json() {
    # 100 lines of sed/awk madness
}

# ✅ RIGHT: Use jq
jq '.field' file.json
```

### Over-Engineering
```bash
# ❌ WRONG: Configuration framework for 3 settings
class ConfigManager:
    def __init__(self):
        self.load_yaml()
        self.validate_schema()
        self.apply_transformations()

# ✅ RIGHT: Source a simple file
source config.sh
```

### Abstraction Addiction
```bash
# ❌ WRONG: Wrapper around wrapper around wrapper
my_grep() { custom_grep "$@"; }
custom_grep() { enhanced_grep "$@"; }
enhanced_grep() { grep "$@"; }

# ✅ RIGHT: Just use grep
grep "$pattern" "$file"
```

## Real Examples

### File Checksums
```bash
# The Torvalds way
sha256sum *.tar.gz > SHA256SUMS
sha256sum -c SHA256SUMS
```

### Process Management
```bash
# The Cox way
pidof myprocess || echo "Process not running"
kill $(pidof myprocess) 2>/dev/null || true
```

### Log Analysis
```bash
# Unix philosophy
tail -f app.log | grep ERROR | cut -d' ' -f2- 
```

## Rules to Live By

1. **Write programs that do one thing and do it well**
2. **Write programs to work together**
3. **Write programs to handle text streams**
4. **Choose portability over efficiency**
5. **Store data in flat text files**
6. **Use software leverage**
7. **Avoid captive user interfaces**

## The Ultimate Test

If Linus Torvalds would say:
> "Christ people. This is just shit. Use the standard tools."

Then you're doing it wrong.

If Alan Cox would say:
> "Why does this need to be more complex than cat and grep?"

Then you're over-engineering.

## Summary

**Before writing any code, check if:**
- `grep`, `sed`, `awk` can do it
- `find`, `xargs` can process it
- `sort`, `uniq`, `cut` can transform it
- `diff`, `patch` can manage changes
- `tar`, `gzip` can package it
- `shasum`, `gpg` can verify it

**The Unix way is the right way.**