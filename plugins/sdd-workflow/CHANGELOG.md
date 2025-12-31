# Changelog

All notable changes to the SDD Workflow plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2024-12-23

### Added
- MCP reference and management commands (`/mcp`, `/mcp-add`, `/mcp-load`)
- Enhanced setup wizard with constitution and CLAUDE.md templates
- Marketplace readiness improvements

### Changed
- Updated plugin.json schema to follow official standards
- Improved documentation structure

## [1.1.0] - 2024-12-XX

### Added
- Save/resume workflow commands (`/save`, `/resume`)
- Code review command (`/review`)
- E2E test generation command (`/e2e-test`)

### Changed
- Enhanced GCRV refinement loop with better iteration tracking
- Improved spec and plan templates

## [1.0.0] - 2024-12-XX

### Added
- Initial release with 15 core commands
- Spec-driven development workflow
- GCRV refinement loop
- Beads task tracking integration
- Research automation (codebase + web)
- Constitution template for architectural constraints
- Setup wizard
- Quality checklist
- Commit workflow

### Commands
- `/setup` - Interactive setup wizard
- `/research` - Codebase + web research
- `/clarify` - Clarifying questions
- `/spec` - Define contract (WHAT)
- `/plan` - Define approach (HOW)
- `/implement` - Execute with GCRV
- `/refine` - Ad-hoc refinement
- `/validate` - Verify implementation
- `/checklist` - Quality check
- `/commit` - Commit workflow
- `/test-fix` - Fix errors

[1.2.0]: https://github.com/tectonic-technologies/claude-sdd-plugin/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/tectonic-technologies/claude-sdd-plugin/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/tectonic-technologies/claude-sdd-plugin/releases/tag/v1.0.0
