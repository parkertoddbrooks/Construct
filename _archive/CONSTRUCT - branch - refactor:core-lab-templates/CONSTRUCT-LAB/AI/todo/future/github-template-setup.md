# GitHub Template Repository Setup

## Overview
Set up CONSTRUCT as a GitHub template repository to cleanly separate template usage from CONSTRUCT development contributions.

## GitHub Repository Configuration

### 1. Enable Template Repository
- Go to CONSTRUCT repo settings on GitHub
- Check "Template repository" checkbox
- This adds "Use this template" button instead of "Fork" for template users

### 2. Branch Protection
- Protect `main` branch
- Require PR reviews for CONSTRUCT development
- Restrict direct pushes to maintain quality

### 3. Repository Description
Update to clearly indicate dual purpose:
```
"AI-powered Swift architecture system. Click 'Use this template' to start a new project, or fork to contribute to CONSTRUCT development."
```

## User Workflows

### Template Users (Building Apps)
1. Click "Use this template" on GitHub
2. Create new repo with their project name
3. Clone their repo: `git clone https://github.com/user/MyAwesomeApp.git`
4. Run `./construct-setup` to personalize USER-PROJECT/
5. Work in USER-PROJECT/, push to their own repo
6. No connection to original CONSTRUCT repo

### CONSTRUCT Contributors (Improving CONSTRUCT)
1. Fork CONSTRUCT repo normally
2. Clone fork: `git clone https://github.com/contributor/construct.git`
3. Work in CONSTRUCT-DEV/ directory
4. Make improvements to CONSTRUCT infrastructure
5. PR back to original CONSTRUCT repo
6. Standard open-source contribution workflow

## Directory Access Patterns

### Template Users Work In:
- `/USER-PROJECT/` - Their personalized project space
- Generated Xcode project, AI tools, scripts

### CONSTRUCT Contributors Work In:
- `/CONSTRUCT-DEV/` - Templates, tools, infrastructure
- `/CONSTRUCT-DOCS/` - Documentation
- Root level files (README, setup script)

## Setup Script Modifications

### For Template Users
- Script should NOT detach from origin (they already have clean repo)
- Focus on personalizing USER-PROJECT/ content
- Set up aliases pointing to USER-PROJECT/
- Create Xcode project from templates

### For Contributors  
- Script should work for CONSTRUCT development
- May need different mode: `./construct-setup --dev-mode`
- Sets up CONSTRUCT development environment

## Benefits

### Clean Separation
- Template users can't accidentally PR app code to CONSTRUCT
- CONSTRUCT contributors focus on infrastructure improvements
- No confusion about where code belongs

### Standard Workflow
- Follows GitHub template repository conventions  
- Familiar to developers (same as Next.js, create-react-app)
- Clear mental model for both use cases

### Maintainable
- PRs to CONSTRUCT are infrastructure improvements only
- USER-PROJECT/ serves as example of working setup
- Easy to accept/reject contributions based on purpose

## Implementation Steps

1. **GitHub Settings**
   - [ ] Enable template repository
   - [ ] Set up branch protection
   - [ ] Update repository description
   - [ ] Create issue templates for both user types

2. **Documentation Updates**
   - [ ] Update README with template usage instructions
   - [ ] Create CONTRIBUTING.md with contributor guidelines  
   - [ ] Add workflow diagrams showing both paths

3. **Setup Script Enhancement**
   - [ ] Ensure works for template users
   - [ ] Consider dev-mode for contributors
   - [ ] Test both workflows thoroughly

4. **Testing**
   - [ ] Test "Use this template" workflow end-to-end
   - [ ] Test contributor fork/PR workflow
   - [ ] Validate USER-PROJECT/ personalization works

## Success Criteria

- [ ] Template users get clean, disconnected projects
- [ ] Contributors can improve CONSTRUCT infrastructure
- [ ] No confusion about where to push code
- [ ] Standard GitHub template repository behavior
- [ ] Both workflows well documented and tested

## Notes

This approach follows industry standards for template repositories while maintaining the ability to accept contributions to CONSTRUCT itself. The key is clear documentation and distinct directory purposes.