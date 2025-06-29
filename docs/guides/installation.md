# Installation Guide

## Prerequisites

Before installing Construct, ensure you have:

- **macOS 13.0+** (Ventura or later)
- **Xcode 15.0+** (with Swift 6 support)
- **Git** installed and configured
- **Bash** shell (default on macOS)
- **GitHub account** (for cloning)

## Quick Install

```bash
# Clone Construct
git clone https://github.com/yourusername/construct.git MyAwesomeApp
cd MyAwesomeApp

# Run setup
./construct-setup

# Load aliases (or restart terminal)
source ~/.zshrc  # or ~/.bashrc

# Start building!
construct-update
```

## Detailed Installation Steps

### 1. Clone the Repository

Choose your project name and clone Construct:

```bash
git clone https://github.com/yourusername/construct.git YourProjectName
cd YourProjectName
```

### 2. Run the Setup Script

The setup script configures everything automatically:

```bash
./construct-setup
```

This will:
- ✅ Check prerequisites
- ✅ Initialize git repository
- ✅ Install git hooks
- ✅ Configure shell aliases
- ✅ Create initial CLAUDE.md
- ✅ Set up Xcode project
- ✅ Create directory structure
- ✅ Generate first sprint PRD

### 3. Configure Your Shell

The setup script adds aliases to your shell configuration. To use them immediately:

```bash
# For Zsh (default on modern macOS)
source ~/.zshrc

# For Bash
source ~/.bashrc
```

Or simply restart your terminal.

### 4. Verify Installation

Run these commands to verify everything is working:

```bash
# Check that aliases are loaded
construct-cd  # Should take you to project root

# Update CLAUDE.md
construct-update  # Should show success message

# Check architecture
construct-check  # Should show no violations
```

### 5. Open in Xcode

Open your new project:

```bash
open YourProjectName.xcodeproj
```

## Shell Aliases

Construct adds these aliases to your shell:

### Navigation
- `construct-cd` - Go to project root
- `construct-ios` - Go to iOS app directory
- `construct-watch` - Go to Watch app directory

### Core Tools
- `construct-update` - Update CLAUDE.md with current state
- `construct-check` - Check architecture compliance
- `construct-before [Component]` - Pre-coding discovery
- `construct-new [Component]` - Create from template

### Quality & Monitoring
- `construct-scan` - Document MVVM structure
- `construct-protect` - Run quality checks
- `construct-learn` - Analyze patterns
- `construct-session` - Generate session summary

### AI Integration
- `construct-export` - Export rules for AI tools
- `construct-vision` - PRD workflow management

## Directory Structure

After installation, your project will have:

```
YourProjectName/
├── Template/
│   ├── iOS-App/          # iOS application
│   ├── Watch-App/        # watchOS app (optional)
│   ├── Tests/            # Test suites
│   └── AI/               # Construct system
│       ├── scripts/      # Automation tools
│       ├── docs/         # Documentation
│       ├── PRDs/         # Product requirements
│       └── dev-logs/     # Development logs
├── CLAUDE.md             # AI context file
├── construct-setup       # Setup script
└── .git/
    └── hooks/            # Git hooks
```

## Customization

### Project Name

If you cloned with the name "Construct", the setup script will ask for your project name:

```bash
Please enter your project name: MyAwesomeApp
```

### Git Configuration

Construct respects your existing git configuration. If you have a `.git` directory, it won't reinitialize.

### Shell Configuration

If you use a shell other than Zsh or Bash, manually add the aliases from the setup script to your shell's configuration file.

## Troubleshooting

### "Command not found" after installation

**Solution**: Source your shell configuration or restart terminal:
```bash
source ~/.zshrc  # or ~/.bashrc
```

### "Permission denied" when running scripts

**Solution**: Make scripts executable:
```bash
chmod +x construct-setup
chmod +x Template/AI/scripts/*.sh
```

### Xcode won't open project

**Solution**: Ensure Xcode is installed:
```bash
xcode-select --install
```

### Git hooks not working

**Solution**: Check hook permissions:
```bash
chmod +x .git/hooks/pre-commit
```

## Next Steps

1. **Read the Quick Start Guide**: [Quick Start](quick-start.md)
2. **Create your first feature**: [Your First Feature](first-feature.md)
3. **Understand the architecture**: [MVVM with Swift 6](../architecture/mvvm-swift6.md)
4. **Learn the commands**: [Command Reference](../tools/commands.md)

## Updating Construct

To update to the latest version:

```bash
# Add Construct as upstream
git remote add construct https://github.com/yourusername/construct.git

# Fetch and merge updates
git fetch construct
git merge construct/main --allow-unrelated-histories
```

## Uninstalling

To remove Construct aliases from your shell:

1. Edit `~/.zshrc` or `~/.bashrc`
2. Remove the section between `# Construct aliases` comments
3. Source the file or restart terminal

**Trust The Process.**