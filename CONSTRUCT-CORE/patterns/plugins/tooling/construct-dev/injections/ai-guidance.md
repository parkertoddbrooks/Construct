## AI Guidance for CONSTRUCT Development

### 🤖 Working with CONSTRUCT

When working on CONSTRUCT framework:
1. **Read the room**: Check auto-sections in CLAUDE.md files
2. **Respect symlinks**: Never edit -sym files directly
3. **Use the tools**: Scripts exist for common tasks
4. **Pattern first**: Check if pattern exists before creating
5. **Context matters**: Update context before major work
6. **Test in LAB**: All experiments happen in LAB first

### Where Code Belongs - Quick Reference

**Scripts** (CONSTRUCT/scripts/):
- `core/` - Core functionality (check-quality, check-architecture, etc.)
- `construct/` - CONSTRUCT-specific tools (update-context, check-symlinks, etc.)
- `dev/` - Development workflows (session-summary, setup-aliases, etc.)
- `workspace/` - Workspace management (create-project, import-project, etc.)

**Library Functions** (CONSTRUCT/lib/):
- Reusable functions across scripts
- Common validation patterns
- Template management utilities
- File analysis and pattern detection

**Configuration** (CONSTRUCT/config/):
- Validation rules and thresholds
- Quality gates and standards
- YAML-based rule definitions
- No hardcoded values in scripts

**Documentation** (AI/docs/):
- Auto-generated architecture overviews
- Script references and usage guides
- Development patterns and standards
- Session summaries and decision logs

### Common AI Mistakes to Avoid

1. **Hardcoding paths in scripts**
   - ❌ AI suggestion: "Use /Users/username/project"
   - ✅ Correct: Use get_construct_root() and relative paths

2. **Missing error handling**
   - ❌ AI suggestion: "Just run the command"
   - ✅ Correct: Check exit codes and provide feedback

3. **Not using library functions**
   - ❌ AI suggestion: "Duplicate the validation code"
   - ✅ Correct: Source and use existing library functions

4. **Breaking template independence**
   - ❌ AI suggestion: "Modify USER-project-files directly"
   - ✅ Correct: Read-only analysis, modifications via templates

5. **Editing symlinked files**
   - ❌ AI suggestion: "Edit the README in LAB"
   - ✅ Correct: Edit in CORE, symlinks auto-update

### When Manual Updates ARE Acceptable

```bash
# ✅ CORRECT: Manual configuration
# Manual strategic decisions, architectural choices
# User-specific goals and priorities

# ❌ WRONG: Manual status tracking
# File counts, git status, structure analysis
# These should auto-update via scripts
```

### AI Session Best Practices

1. **On Session Start**:
   - Run `construct-update` to refresh auto-sections
   - Check "Current Development Context" for immediate goals
   - Review "Active Violations" for issues to avoid
   - Check documentation links for detailed architecture info

2. **When Context Remaining Falls to 10% or Below**:
   - **Alert user at EVERY response when ≤10% remains**: 
     - At 10%: "⚠️ Context at 90% used (10% remaining) - prepare to wrap up"
     - At 8%: "⚠️ Context at 92% used (8% remaining) - time to generate session summary"
     - At 5%: "🚨 URGENT: Only 5% context remaining - run session summary NOW"
     - At 3%: "🚨 CRITICAL: 3% context left - this may be the last full response"
   - **Tell user to run**: `construct-session-summary`
   - **After summary generates**: Remind user to start fresh Claude session
   - **Key message**: "Session summary saved. Please start a new Claude session to continue with full context."
   - **Also remind**: "Consider creating a dev-log if you've completed significant work:
     - Template: `AI/dev-logs/_devupdate-prompt.md`
     - Create as: `AI/dev-logs/devupdate-XX.md`"

3. **When Creating Code**:
   - Check "Available Resources" section first
   - Use "Pattern Library" templates
   - Never violate "ENFORCE THESE RULES" section
   - Run architecture check before finalizing
   - Ensure template independence is maintained

4. **When Discovering New Truths**:
   - Add to "Validated Discoveries" if universally true
   - Update "Current Development Context" if project-specific
   - Move old truths to "Historical Context" if deprecated
   - Update auto-sections via update-context.sh

### CONSTRUCT-Specific AI Guidance

When AI is asked about CONSTRUCT development:

1. **Architecture Questions**:
   - LAB is for experimentation, CORE is for stable code
   - Symlinks maintain consistency between environments
   - Templates must work independently of CONSTRUCT

2. **Script Development**:
   - Always use relative paths from CONSTRUCT_ROOT
   - Include proper error handling (set -e)
   - Add colored output for user feedback
   - Document functions with purpose and parameters

3. **Pattern System**:
   - Patterns live in patterns/plugins/
   - Each pattern has its own validators and generators
   - Pattern configuration via patterns.yaml
   - CLAUDE.md is generated, never edited manually

4. **Quality Standards**:
   - All scripts need --help output
   - Functions need documentation headers
   - Configuration belongs in config/ not scripts
   - Pre-commit hooks enforce standards

### Interactive Rails Mode

When working with interactive scripts that use the Rails pattern:

1. **Rails Pattern Explanation**:
   - Scripts run interactively to guide users through complex tasks
   - Present prompts naturally like "What component are you creating?"
   - Accept user input and provide smart responses

2. **Example Flow**:
   ```
   Script: "🔍 What component are you creating?"
   User: "payment processing service"
   Script: "✅ Found related patterns: PaymentService, TransactionHandler"
   Script: "📋 Would you like to see existing payment components? (y/n)"
   ```

3. **When AI Encounters Rails Scripts**:
   - Let the script guide the conversation
   - Provide natural responses to prompts
   - Don't try to bypass the interactive flow
   - Trust the script's decision logic

### Remember

The goal is to create self-improving development environments where AI assistance gets smarter with every commit. CONSTRUCT development should follow its own patterns and standards, serving as the exemplar for projects using CONSTRUCT.