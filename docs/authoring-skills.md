# Authoring Skills

Skills are the primary way to extend Mux (and other AI coding tools) with domain-specific knowledge and workflows. They follow the open [Agent Skills specification](https://agentskills.io/specification).

## Anatomy of a Skill

```
skills/my-skill/
├── SKILL.md          # Required: frontmatter + instructions
├── scripts/          # Optional: executable helpers
├── references/       # Optional: additional documentation
└── assets/           # Optional: templates, schemas, data
```

### SKILL.md Structure

Every skill has a single required file: `SKILL.md`. It contains:

1. **YAML frontmatter** — metadata for discovery and indexing
2. **Markdown body** — full instructions injected when the skill is loaded

```yaml
---
name: my-skill
description: One-line description shown in the skills index
triggers:
  - my-skill
  - alias
---

# My Skill

Full instructions go here...
```

## Required Frontmatter Fields

### `name` (string, required)
- Must match the parent directory name exactly
- Pattern: `^[a-z0-9]+(?:-[a-z0-9]+)*$` (kebab-case, no consecutive hyphens)
- Maximum: 64 characters

### `description` (string, required)
- Shown in the skills index in the system prompt
- Budget: ~100 tokens (keep concise)
- Maximum: 1024 characters
- Should describe what the skill does AND when to use it

### `triggers` (list of strings, recommended)
- Slash-commands that activate the skill (e.g., `/my-skill`)
- First trigger is typically the skill name
- Additional entries are aliases

## Optional Frontmatter Fields

### `license` (string)
License name or reference to a bundled license file.

### `compatibility` (string, max 500 chars)
Environment requirements (e.g., "Requires Node.js 18+", "Needs Docker").

### `metadata` (map of string → string)
Arbitrary key-value pairs for tooling:
```yaml
metadata:
  author: your-name
  version: "1.0.0"
  category: development
```

### `advertise` (boolean, Mux-specific)
Set to `false` to hide from the system prompt skills index. The skill is still invokable via slash command or `agent_skill_read()`.

## Body Content Guidelines

### Structure
Organize your skill body with clear markdown headings:

```markdown
# Skill Name

## When to Use
Describe trigger conditions.

## Workflow
Numbered steps the agent should follow.

## Key Concepts
Important terminology and patterns.

## Examples
Show typical usage scenarios.

## Quick Reference
Condensed cheat sheet for experienced users.
```

### Best Practices

1. **Be specific** — Vague instructions produce vague behavior
2. **Use examples** — Show concrete inputs/outputs
3. **Include edge cases** — What should the agent do in unusual situations?
4. **Keep it focused** — One skill = one concern
5. **Size budget** — Keep under 500 lines; move reference material to `references/`

### Supporting Files

Use `agent_skill_read_file()` to load supporting files:

```
# In the skill body:
For detailed API reference, load:
agent_skill_read_file({ name: "my-skill", filePath: "references/api.md" })
```

Organize by directory:
- `scripts/` — Executable code (Python, Bash, JS) the agent can run
- `references/` — Additional documentation, specs, examples
- `assets/` — Templates, schemas, data files

## How Skills Are Loaded

### Discovery (startup)
Mux scans these paths and parses only frontmatter (`name` + `description`):

| Priority | Path | Scope |
|----------|------|-------|
| 1 (highest) | `.mux/skills/<name>/SKILL.md` | Workspace-local |
| 2 | `~/.mux/skills/<name>/SKILL.md` | Global (Mux) |
| 3 | `~/.agents/skills/<name>/SKILL.md` | Universal (cross-tool) |
| 4 (lowest) | Built-in | Shipped with Mux |

First match wins on name collision.

### Activation (on demand)
When triggered (via slash command or `agent_skill_read()`), the full SKILL.md body is loaded into the agent's context window.

### Resource loading (as needed)
The agent can load files from skill subdirectories via `agent_skill_read_file()`.

## Testing Your Skill

1. Place your skill in `skills/<name>/SKILL.md`
2. Run `bash scripts/install.sh` to symlink into `~/.mux/skills/`
3. Restart Mux
4. Type `/<trigger>` in chat to activate
5. Iterate on the content based on agent behavior

## Validation

```bash
bash scripts/validate.sh
```

This checks:
- SKILL.md exists in each skill directory
- Directory names are kebab-case
- Frontmatter has required fields (`name`, `description`)
- `name` matches directory name
- File size is under 1MB

## Template

Use the starter template:

```bash
cp -r templates/skill skills/my-new-skill
mv skills/my-new-skill/SKILL.md.tmpl skills/my-new-skill/SKILL.md
# Edit skills/my-new-skill/SKILL.md
```

## Cross-Tool Compatibility

Skills following the Agent Skills spec work with any compatible tool:
- **Mux** — discovered from `.mux/skills/` and `~/.mux/skills/`
- **Claude Code** — discovered from `.claude/skills/` (via Agent Skills spec)
- **Other tools** — discovered from `~/.agents/skills/` (universal path)

Keep Mux-specific behavior in agent definitions (`agents/*.md`), not in skills.
