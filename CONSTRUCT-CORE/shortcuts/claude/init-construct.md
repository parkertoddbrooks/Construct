# Init CONSTRUCT

This shortcut runs the CONSTRUCT initialization script to transform any project into a fully CONSTRUCT-enabled environment.

## What This Does

1. **Verifies Claude SDK** is installed
2. **Analyzes your project** structure and existing CLAUDE.md
3. **Installs CONSTRUCT infrastructure**:
   - Creates CONSTRUCT/ folder with tools
   - Sets up AI documentation structure
   - Installs git hooks for validation
4. **Extracts patterns** from existing CLAUDE.md
5. **Detects project technologies** and recommends patterns
6. **Enhances your CLAUDE.md** with pattern system

## Usage

Run this from any directory within CONSTRUCT or a project directory containing a CLAUDE.md file.

## Task

Find the CONSTRUCT root directory (look for parent directories containing CONSTRUCT-CORE), then run:
`CONSTRUCT-CORE/CONSTRUCT/scripts/construct/init-construct.sh`

Execute this script from the current working directory without changing directories.