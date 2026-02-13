You are an experienced, pragmatic software engineering AI agent. Do not over-engineer a solution when a simple one is possible. Keep edits minimal. If you want an exception to ANY rule, you MUST stop and get permission first.

# mux-addons

A collection of shareable Mux skills, agent definitions, configs, and documentation.

## Project Overview

This repository provides addon content for [Mux](https://mux.coder.com) — skills (cross-tool compatible via the [Agent Skills spec](https://agentskills.io/specification)), agent definitions (Mux-specific), configuration fragments, and documentation.

### Technology
- **Format**: Markdown with YAML frontmatter (skills + agents)
- **Config**: JSON/JSONC (MCP configs, task settings, model presets)
- **Scripts**: Bash (install, validate, sync)
- **No build step** — this is a content repo

### Directory Structure
- `skills/<name>/SKILL.md` — Agent Skills (cross-tool compatible)
- `agents/<name>.md` — Mux agent definitions
- `configs/` — Shareable configuration fragments (MCP, task settings, model presets)
- `templates/` — Starter templates for new skills/agents
- `scripts/` — Installation and validation scripts
- `docs/` — Extended documentation

## Reference

### Important Files
- `skills/*/SKILL.md` — Each skill's definition (YAML frontmatter + markdown body)
- `agents/*.md` — Each agent's definition (YAML frontmatter + markdown body)
- `scripts/install.sh` — Symlinks skills + copies agents into `~/.mux/`
- `scripts/validate.sh` — Lints SKILL.md frontmatter and naming conventions

### SKILL.md Schema
```yaml
---
name: kebab-case-name        # Must match directory name
description: One-line summary # Shown in skill index
triggers:                     # Slash-commands that activate this skill
  - primary-trigger
  - alias
---
# Markdown body with full instructions
```

### Agent .md Schema
```yaml
---
name: Display Name           # Title Case
description: One-line summary
base: exec | plan            # Agent type
ui:
  color: "#hexcolor"
subagent:
  runnable: true | false
tools:
  add: [tool_patterns...]
  remove: [tool_patterns...]  # optional
---
# Markdown body (bootstrap + quick reference)
```

## Essential Commands

- **Install**: `bash scripts/install.sh` — symlinks skills + copies agents to `~/.mux/`
- **Validate**: `bash scripts/validate.sh` — checks SKILL.md frontmatter, naming conventions
- **Dry run**: `bash scripts/install.sh --dry-run` — preview install without changes

## Patterns

### Adding a New Skill
1. Create `skills/<name>/SKILL.md` with required frontmatter (`name`, `description`, `triggers`)
2. Skill `name` must match directory name (kebab-case, `^[a-z0-9]+(?:-[a-z0-9]+)*$`)
3. Optional subdirectories: `scripts/`, `references/`, `assets/`
4. If creating a paired agent, add `agents/<name>.md`

### Adding a New Agent
1. Create `agents/<name>.md` with required frontmatter (`name`, `description`, `base`, `ui`, `subagent`, `tools`)
2. Body should bootstrap by calling `agent_skill_read({ name: "<skill-name>" })`
3. Include a Quick Reference section as fallback

### Skill/Agent Pairs
Skills and agents are linked by naming convention:
- Skill: `skills/my-tool/SKILL.md` (name: `my-tool`)
- Agent: `agents/my-tool.md` (calls `agent_skill_read({ name: "my-tool" })`)

## Anti-Patterns

- **Do not** put Mux-specific fields in SKILL.md frontmatter — skills must be cross-tool compatible
- **Do not** commit `.mux/` runtime data to this repo
- **Do not** add `node_modules/` or build artifacts — this is a content-only repo
- **Do not** use `allowed-tools` in SKILL.md frontmatter — Mux does not enforce it

## Commit and Pull Request Guidelines

- Validate before committing: `bash scripts/validate.sh`
- Commit message format: `type: message` (e.g., `feat: add coder-diagrams skill`, `fix: correct sk-exec trigger`)
- Types: `feat`, `fix`, `docs`, `chore`, `refactor`
- PRs should describe which skills/agents are added or modified
