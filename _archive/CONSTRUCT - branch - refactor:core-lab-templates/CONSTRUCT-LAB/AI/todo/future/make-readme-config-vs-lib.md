The Difference Between lib/ and config/

  lib/ Directory (Library Functions)

  - Purpose: Contains reusable shell/bash code that scripts can source and use
  - What's in it: Actual bash functions that do work
  - For: CONSTRUCT's own development scripts (shell/bash)
  - Examples from common-patterns.sh:
    - find_shell_scripts() - finds .sh files
    - create_temp_dir() - creates temporary directories
    - safe_grep_count() - grep with error handling
    - archive_existing_files() - moves files to _old directory

  config/ Directory (Configuration Rules)

  - Purpose: Contains YAML files that define rules, standards, and thresholds
  - What's in it: Configuration data that scripts read to know what to validate
  - For: Both CONSTRUCT development AND user projects (multi-language)
  - Examples:
    - mvvm-rules.yaml - Swift/iOS MVVM architecture rules
    - quality-gates.yaml - Quality standards for both shell scripts and Swift code

  To Answer Your Questions:

  1. "Are these just for CONSTRUCT?"
    - lib/ → YES, just for CONSTRUCT's shell scripts
    - config/ → NO, for both CONSTRUCT and user projects
  2. "Is /config/ where Swift, and C#, etc coding best practices and patterns go?"
    - YES! Exactly. The config directory holds language-specific rules:
        - mvvm-rules.yaml already has Swift patterns
      - You could add csharp-rules.yaml, typescript-rules.yaml, etc.
      - These are read by validation scripts to check code quality
  3. Common patterns look OK?
    - Yes, the patterns are good - they reduce duplication across scripts
    - They follow the CONSTRUCT philosophy of reusable functions

  In Summary:

  - lib/ = Executable code (bash functions)
  - config/ = Rules and standards (YAML data)
  - lib/ = How to do things (implementation)
  - config/ = What standards to enforce (validation rules)