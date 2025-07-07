Looking at these three documents in relation to the new pattern system plan, here's what should be integrated vs. left out:

## From `unified-claude-todo.md`:

### **LEAVE OUT** (Superseded by pattern system):
- ❌ The entire symlink approach for CLAUDE.md
- ❌ "One CLAUDE.md file serves all contexts" 
- ❌ Phase 2: Implement Symlink Structure
- ❌ The vision of symlinked CLAUDE.md everywhere

### **INTEGRATE**:
- ✅ Current State Analysis - still need to audit existing CLAUDE.md files
- ✅ Content consolidation approach (but for creating plugins, not one file)
- ✅ The context detection concepts (now implemented via `context-detect.sh`)
- ✅ Testing methodology (adapted for pattern system)

## From `CONSTRUCT-RESTRUCTURE-PLAN-04.md`:

### **KEEP AS-IS** (Already integrated):
- ✅ Template-first architecture
- ✅ LAB/CORE/TEMPLATES structure
- ✅ Promotion system
- ✅ Symlinks for CONSTRUCT directory and docs
- ✅ Power user vs template user distinction

### **INTEGRATE**:
- ✅ AI/template-structure/ concept (for storing pattern templates)
- ✅ create-project.sh enhancements (already updated with pattern selection)
- ✅ Adapter system (aligns with language pattern plugins)

## From `claude-md-mitigation-strategies.md`:

### **ALREADY INTEGRATED** (via pattern system):
- ✅ Complexity mitigation (solved by plugins)
- ✅ Size management (each plugin is focused)
- ✅ Conflict prevention (patterns have explicit scopes)
- ✅ Context detection (via `context-detect.sh`)

### **STILL RELEVANT**:
- ✅ Change impact documentation
- ✅ Version control practices
- ✅ Testing protocols
- ✅ Progressive disclosure concepts (for individual plugins)

## Key Reconciliation Points:

1. **CLAUDE.md Generation vs Symlinks**: The pattern system completely replaces the symlink approach from `unified-claude-todo.md`

2. **AI Structure**: From RESTRUCTURE-PLAN-04, adapt `AI/template-structure/` to store:
   - Pattern plugin templates
   - Default patterns.yaml templates
   - Pattern examples

3. **Context Intelligence**: The ideas from all three docs are now implemented through:
   - Pattern plugins with scopes
   - context-detect.sh for dynamic selection
   - patterns.yaml for configuration

## Recommended Updates to Pattern System Plan:

1. **Add to Phase 1**:
   ```bash
   # Align with RESTRUCTURE-PLAN-04
   mkdir -p AI/template-structure/patterns/
   mkdir -p AI/template-structure/examples/
   ```

2. **Add Testing Section** (from unified-claude-todo.md):
   - Test pattern extraction from existing CLAUDE.md files
   - Verify all existing rules are captured in plugins
   - Test multi-language scenarios

3. **Add Migration Guide** (reconciling old approaches):
   - For projects using symlinked CLAUDE.md
   - For projects with monolithic CLAUDE.md
   - Clear deprecation of symlink approach

The pattern system essentially achieves all the goals of the original three documents but in a more flexible, maintainable way.