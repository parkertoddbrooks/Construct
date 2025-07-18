│                                                                                                                                                  │
│ Here is Claude's plan:                                                                                                                           │
│ ╭──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮ │
│ │ Plan: Update Core Scripts & Migrate scripts-new to scripts                                                                                   │ │
│ │                                                                                                                                              │ │
│ │ Phase 1: Prepare scripts-new for migration                                                                                                   │ │
│ │                                                                                                                                              │ │
│ │ 1. Verify scripts-new has all validator location updates                                                                                     │ │
│ │   - Check that check-quality.sh, check-architecture.sh, check-documentation.sh in scripts-new/ properly reference                            │ │
│ │ patterns/plugins/*/validators/                                                                                                               │ │
│ │   - Ensure backward compatibility is maintained (checking both new and old locations)                                                        │ │
│ │ 2. Test scripts-new functionality                                                                                                            │ │
│ │   - Run key scripts from scripts-new/ to ensure they work correctly                                                                          │ │
│ │   - Verify they find validators in the new plugin locations                                                                                  │ │
│ │   - Test with a sample project that has patterns.yaml                                                                                        │ │
│ │                                                                                                                                              │ │
│ │ Phase 2: Backup current scripts directory                                                                                                    │ │
│ │                                                                                                                                              │ │
│ │ 1. Create backup                                                                                                                             │ │
│ │   - Copy scripts/ to scripts-backup-[timestamp]/                                                                                             │ │
│ │   - Document what's in the old scripts for reference                                                                                         │ │
│ │                                                                                                                                              │ │
│ │ Phase 3: Migrate scripts-new to scripts                                                                                                      │ │
│ │                                                                                                                                              │ │
│ │ 1. Move all contents                                                                                                                         │ │
│ │   - Delete current scripts/ directory                                                                                                        │ │
│ │   - Rename scripts-new/ to scripts/                                                                                                          │ │
│ │ 2. Clean up references to scripts-new                                                                                                        │ │
│ │   - Update scripts-new/README.md to remove migration notices                                                                                 │ │
│ │   - Update any internal script references from scripts-new to scripts                                                                        │ │
│ │                                                                                                                                              │ │
│ │ Phase 4: Verify everything works                                                                                                             │ │
│ │                                                                                                                                              │ │
│ │ 1. Test critical paths                                                                                                                       │ │
│ │   - Run pre-commit hook (it already points to scripts/)                                                                                      │ │
│ │   - Test construct-update, construct-check aliases                                                                                           │ │
│ │   - Run check-quality.sh with a project                                                                                                      │ │
│ │   - Verify interactive support works                                                                                                         │ │
│ │ 2. Update documentation                                                                                                                      │ │
│ │   - Remove references to scripts-new from documentation                                                                                      │ │
│ │   - Update interactive-scripts.md if needed                                                                                                  │ │
│ │   - Update any other docs mentioning the migration                                                                                           │ │
│ │                                                                                                                                              │ │
│ │ Phase 5: Clean up                                                                                                                            │ │
│ │                                                                                                                                              │ │
│ │ 1. Remove old validator directories                                                                                                          │ │
│ │   - Delete scripts/patterns/ directory (validators have moved to patterns/plugins/)                                                          │ │
│ │   - Clean up any leftover migration artifacts                                                                                                │ │
│ │ 2. Final verification                                                                                                                        │ │
│ │   - Commit changes                                                                                                                           │ │
│ │   - Run pre-commit hook to ensure everything still works                                                                                     │ │
│ │                                                                                                                                              │ │
│ │ This completes both tasks: the scripts will reference new validator locations (because scripts-new already does) AND we'll have migrated     │ │
│ │ scripts-new to scripts.      