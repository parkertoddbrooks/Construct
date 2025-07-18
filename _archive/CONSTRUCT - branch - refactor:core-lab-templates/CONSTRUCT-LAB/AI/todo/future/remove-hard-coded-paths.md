> don't do an codings. why are there hardcoded paths in check-documentation.sh?

⏺ You're absolutely right to question this! Looking at the check-documentation.sh script, it has hardcoded paths like:

  local dev_files=("AI/todo/future/implement-dual-dev-environments.md" "AI/docs/automated/improving-CONSTRUCT-guide-automated.md")

  This violates the core CONSTRUCT principle of no hardcoded paths. Here's why this is problematic:

  1. Breaks when files move - As we just experienced, when the pre-commit hooks reorganized files, the hardcoded path broke
  2. Not configuration-driven - These should be in a YAML config file, not hardcoded in the script
  3. Maintenance nightmare - Every time the structure changes, you have to update the script
  4. Against our own rules - CLAUDE.md explicitly states:
  ❌ NEVER: Hardcoded paths in scripts
  ✅ ALWAYS: Use relative paths and configuration

  The check-documentation.sh script should instead:
  - Read expected documentation from a config file (like config/required-docs.yaml)
  - Use patterns to find documentation dynamically
  - Or at least use variables/arrays defined at the top of the script

  This is exactly the kind of issue our quality checks should catch - but ironically, it's in the quality check script itself! The
  script is checking for documentation but doing it in a way that violates our architectural principles.