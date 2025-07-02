# CONSTRUCT-CORE

The universal orchestration engine for CONSTRUCT. This is the stable, production-ready core that gets embedded in all templates and environments.

## What's Here

- **scripts/** - Universal workflow scripts that work across all languages
- **lib/** - Shared library functions
- **config/** - Configuration files and rules
- **orchestrator/** - Language detection and routing (coming soon)
- **adapters/** - Language-specific implementations (coming soon)

## Version

Current version: 1.0.0

## Usage

This directory is meant to be embedded (via symlink or copy) into:
- CONSTRUCT-LAB for development
- Templates for end users

Do not edit these files directly. All development happens in CONSTRUCT-LAB, then stable features are promoted here.