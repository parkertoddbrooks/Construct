# PRD: Context-Aware Context Engineering for CONSTRUCT

**Product Requirements Document**  
**Version**: 2.0  
**Date**: 2025-07-18  
**Author**: CONSTRUCT Team  
**Status**: Future Development

## 🆕 NEW THINKING: Building on construct-init Infrastructure Foundation

**CRITICAL UPDATE**: This context-aware engineering system now builds on the enhanced `construct-init` orchestrator that provides a reliable foundation of complete infrastructure in every project.

**Key Integration Points**:
- **Infrastructure Foundation**: Context engineering works because construct-init guarantees every project has complete, working CONSTRUCT setup
- **Pattern System Integration**: Can reliably load and optimize patterns because construct-init ensures valid .construct/patterns.yaml exists
- **Usage Analytics Foundation**: Can track pattern usage because construct-init validates all scripts work
- **Learning System Reliability**: Analytics and learning work because infrastructure is consistent across all projects

**Enhanced Capabilities**:
- Context optimization works immediately in any project (infrastructure guaranteed)
- Usage analytics are consistent (all projects have same CONSTRUCT interface)
- Learning algorithms have reliable data (construct-init ensures data sources exist)
- Context compression is predictable (pattern structure guaranteed by construct-init)

**This provides the reliable foundation** that makes advanced context engineering possible - without complete infrastructure, the learning and optimization systems couldn't function reliably.

## Executive Summary

CONSTRUCT will pioneer "Context-Aware Context Engineering" - an intelligent system that dynamically optimizes what information is loaded into Claude's context window based on the task at hand, learning from usage patterns, and continuously improving its selections. This builds on the infrastructure foundation provided by construct-init to create truly adaptive AI assistance.

## Problem Statement

### Current Challenges
1. **Context Window Waste**: Loading 1240+ lines for every session, regardless of task
2. **Information Overload**: Developers must process irrelevant sections
3. **Static Loading**: Same context for bug fixes and major refactors
4. **No Learning**: System doesn't improve based on what's actually used
5. **One-Size-Fits-None**: Can't optimize for different developer needs

### Karpathy's Insight
> "Context engineering is the delicate art and science of filling the context window with just the right information for the next step."

Currently, CONSTRUCT fills the window with ALL information, not the RIGHT information.

## Proposed Solution

### Core Innovation: Adaptive Context Loading

Implement the 4 core techniques of context engineering:

1. **Writing Context** ✅ (Already implemented)
   - CLAUDE.md saves crucial info
   - Pattern system stores reusable knowledge

2. **Selecting Context** 🆕 (New capability)
   - Task-based loading
   - File-based inference
   - Usage-based optimization

3. **Compressing Context** 🆕 (New capability)
   - Automatic summarization
   - Smart trimming
   - Progressive disclosure

4. **Isolating Context** 🆕 (New capability)
   - Task-specific contexts
   - Multi-stage loading
   - Modular sections

## Detailed Requirements

### 1. Task-Based Context Loading

#### Command Interface
```bash
# Minimal contexts for specific tasks
construct-init --task=bugfix      # Only essential rules + recent changes
construct-init --task=feature     # Full patterns + architecture
construct-init --task=refactor    # Architecture + quality standards
construct-init --task=review      # Quality gates + violations
construct-init --task=debug       # Error patterns + troubleshooting

# Auto-detect from git
construct-init --auto             # Infer from staged changes
```

#### Task Profiles
Each task type has a profile defining:
- Required sections (always load)
- Optional sections (load on demand)
- Compressed sections (summaries only)
- Excluded sections (never load)

### 2. Dynamic Context Selection

#### File-Based Inference
```yaml
# .construct/context-rules.yaml
rules:
  - pattern: "*.sh"
    load:
      - patterns/shell-scripting
      - patterns/shell-quality
      - examples/shell
    exclude:
      - examples/python
      - patterns/web
  
  - pattern: "patterns/**/*.yaml"
    load:
      - patterns/pattern-system
      - guidelines/pattern-validation
```

#### Smart Selection Algorithm
1. Analyze files in working directory
2. Check recent git changes
3. Review open issues/PRs
4. Apply context rules
5. Load only relevant sections

### 3. Context Compression

#### Automatic Summarization
```markdown
<!-- Instead of 200 lines of examples -->
## Code Examples (Compressed)
Available examples: Shell scripting, Python patterns, Config validation
Use `construct-expand --examples=shell` to load specific examples
```

#### Progressive Disclosure
```markdown
## 🎯 Immediate Context
- Current task: Feature development
- Active violations: 2 hardcoded paths
- Recent changes: 5 files in /scripts
- Critical rules: No symlink editing

## 📚 Extended Context
<details>
<summary>Development Guidelines (42 sections)</summary>
[Click to expand]
</details>

<details>
<summary>Code Examples (15 patterns)</summary>
[Click to expand]
</details>
```

#### Smart Trimming
- Remove fixed violations
- Archive old PRDs
- Summarize long histories
- Compress repetitive sections

### 4. Context Usage Analytics

#### Session Tracking
```bash
# Start tracking
export CONSTRUCT_TRACK_CONTEXT=true

# During session, CONSTRUCT logs:
- Which sections are accessed
- How often they're referenced
- Which prevent errors
- What's never used
```

#### Usage Analysis
```bash
construct-analyze-context --last=10
> Most used sections:
>   - Shell scripting rules: 85% of sessions
>   - Symlink warnings: Prevented 12 errors
>   - Python examples: Never accessed
> 
> Recommendations:
>   - Always load shell rules
>   - Move Python examples to optional
>   - Highlight symlink warnings
```

#### Learning System
```bash
# Learn from past sessions
construct-init --learn

# Applies learned optimizations:
> Loading frequently used sections...
> Compressing rarely used content...
> Excluding never-accessed sections...
> Context size: 320 lines (was 1240)
```

### 5. Multi-Stage Context Architecture

#### Context Modules
```
CONSTRUCT-CORE/
├── context/
│   ├── immediate/          # Always loaded
│   │   ├── rules.md       # Critical rules
│   │   ├── state.md       # Current state
│   │   └── focus.md       # Active task
│   ├── extended/          # Load on demand
│   │   ├── guidelines/    # Development guidelines
│   │   ├── examples/      # Code examples
│   │   └── patterns/      # Pattern docs
│   └── reference/         # External links
│       ├── architecture.md
│       └── troubleshooting.md
```

#### Loading Strategy
```python
# Pseudo-code for context loading
def load_context(task_type, working_files, history):
    context = []
    
    # Always load immediate
    context.extend(load_immediate())
    
    # Task-specific loading
    profile = get_task_profile(task_type)
    context.extend(load_sections(profile.required))
    
    # File-based loading
    patterns = analyze_working_files(working_files)
    context.extend(load_relevant_patterns(patterns))
    
    # History-based optimization
    if history:
        usage = analyze_usage(history)
        context = optimize_based_on_usage(context, usage)
    
    # Compress if needed
    if len(context) > threshold:
        context = compress_context(context)
    
    return context
```

### 6. Implementation Phases

#### Phase 1: Task-Based Loading (Q1 2025)
- Implement task profiles
- Create --task flag for construct-init
- Basic immediate/extended separation

#### Phase 2: Dynamic Selection (Q2 2025)
- File-based inference
- Git integration
- Context rules engine

#### Phase 3: Compression (Q3 2025)
- Auto-summarization
- Progressive disclosure
- Smart trimming

#### Phase 4: Analytics & Learning (Q4 2025)
- Usage tracking
- Pattern learning
- Optimization recommendations

### 7. Success Metrics

#### Quantitative
- **Context Size Reduction**: 70% smaller for typical tasks
- **Time to First Action**: 50% faster session starts
- **Error Prevention**: Same or better than full context
- **Context Relevance**: 90%+ of loaded content used

#### Qualitative
- Developers report less cognitive overload
- Faster task completion
- Better focus on relevant information
- System improves over time

### 8. Technical Architecture

#### Context Service
```bash
# New service for context management
CONSTRUCT/lib/context-engine/
├── selector.sh        # Selects relevant sections
├── compressor.sh      # Compresses content
├── analyzer.sh        # Analyzes usage
├── learner.sh         # Learns patterns
└── profiles/          # Task profiles
```

#### Storage Format
```yaml
# .construct/context-state.yaml
sessions:
  - id: "2025-07-16-001"
    task: "bugfix"
    loaded_sections: ["rules", "violations", "recent"]
    accessed_sections: ["rules", "violations"]
    errors_prevented: 2
    duration: 1800
    
usage_patterns:
  shell_rules:
    access_rate: 0.85
    error_prevention: 12
    recommendation: "always_load"
```

### 9. User Experience

#### Progressive Onboarding
```bash
# First time: Full context (current behavior)
construct-init

# System suggests optimization
> Based on your session, try: construct-init --task=feature

# Eventually graduates to full automation
construct-init --auto
```

#### Manual Override
```bash
# Force full context
construct-init --full

# Load specific sections
construct-init --sections=patterns,examples

# Exclude sections
construct-init --exclude=historical,deprecated
```

### 10. Migration Strategy

1. **Backward Compatible**: Current CLAUDE.md continues to work
2. **Opt-in Features**: Users choose when to adopt smart loading
3. **Gradual Learning**: System improves without disrupting workflow
4. **Data Preservation**: All content remains accessible

## Benefits

### For Developers
- **Faster Start**: Less to read, quicker to productive work
- **Better Focus**: Only see what's relevant to current task
- **Reduced Cognitive Load**: No information overload
- **Personalized Experience**: Adapts to individual patterns

### For AI (Claude)
- **More Working Memory**: Smaller context = more room for code
- **Higher Relevance**: Every loaded line has purpose
- **Better Performance**: Less distraction, better focus
- **Continuous Improvement**: Gets smarter over time

### For CONSTRUCT
- **Pioneer Status**: First to implement true context engineering
- **Measurable Value**: Quantifiable improvements in efficiency
- **Learning System**: Accumulates knowledge about effective context
- **Competitive Advantage**: Unique capability in AI tooling space

## Risks and Mitigations

### Risk: Missing Critical Information
**Mitigation**: 
- Conservative defaults
- Always load safety-critical rules
- Easy access to full context
- Learn from errors

### Risk: Over-Compression
**Mitigation**:
- User-controlled compression levels
- Preserve full content, just reorganize
- Undo/expand capabilities

### Risk: Learning Wrong Patterns
**Mitigation**:
- Require statistical significance
- User confirmation for major changes
- Reset/retrain options

## Conclusion

Context-Aware Context Engineering transforms CONSTRUCT from a static knowledge base to an intelligent, adaptive system that learns and improves. By implementing the four core techniques of context engineering with a learning layer, CONSTRUCT will deliver exactly the right information at the right time, making AI-assisted development more efficient and effective.

This isn't just an optimization - it's a fundamental evolution in how development environments work with AI, setting the stage for truly intelligent development assistance.

## Next Steps

1. Review and approve PRD
2. Create technical design document
3. Build prototype with task-based loading
4. Test with real developers
5. Iterate based on usage data
6. Roll out progressively

---

*"The best context is not the most complete context - it's the most relevant context."*