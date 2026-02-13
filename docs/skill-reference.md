# Skill Reference

Complete reference for the SKILL.md file format, based on the [Agent Skills specification](https://agentskills.io/specification).

## File Format

SKILL.md is a markdown file with YAML frontmatter:

```
---
<YAML frontmatter>
---

<Markdown body>
```

## Frontmatter Schema

### Required Fields

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `name` | string | 1–64 chars, `^[a-z0-9]+(?:-[a-z0-9]+)*$` | Skill identifier. Must match parent directory name. No consecutive hyphens. |
| `description` | string | 1–1024 chars | What the skill does and when to use it. Shown in the skills index. |

### Optional Fields

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `triggers` | list[string] | — | Slash-commands that activate the skill |
| `license` | string | — | License name or reference to bundled file |
| `compatibility` | string | Max 500 chars | Environment requirements |
| `metadata` | map[string, string] | — | Arbitrary key-value pairs (author, version, etc.) |
| `advertise` | boolean | Mux-specific | `false` to hide from system prompt index |

### Notes

- Unknown keys are ignored by Mux
- `allowed-tools` is tolerated but NOT enforced by Mux
- Frontmatter must start and end with `---` on their own lines

## Body

The markdown body contains the full skill instructions. There are no format restrictions, but recommended structure:

```markdown
# Skill Name

## When to Use
Trigger conditions and activation criteria.

## Workflow
Step-by-step instructions (numbered).

## Key Concepts
Terminology, patterns, important context.

## Examples
Concrete usage scenarios with inputs/outputs.

## Quick Reference
Condensed cheat sheet.
```

### Size Limits

- **Maximum file size**: 1MB (enforced by Mux)
- **Recommended body**: Under 500 lines
- **Move large content** to `references/` subdirectory

## Directory Structure

```
<skill-name>/
├── SKILL.md          # Required
├── scripts/          # Optional: executable code
│   ├── helper.py
│   └── setup.sh
├── references/       # Optional: additional docs
│   ├── api.md
│   └── examples.md
└── assets/           # Optional: templates, schemas
    ├── template.json
    └── schema.yaml
```

### Accessing Subdirectory Files

From within a skill's context, the agent can read supporting files:

```
agent_skill_read_file({ name: "my-skill", filePath: "references/api.md" })
agent_skill_read_file({ name: "my-skill", filePath: "scripts/helper.py" })
```

`filePath` must be relative to the skill directory (no absolute paths, no `..` traversal).

## Discovery

Skills are discovered from these paths (first match wins):

| Priority | Path | Scope |
|----------|------|-------|
| 1 | `.mux/skills/<name>/SKILL.md` | Workspace-local |
| 2 | `~/.mux/skills/<name>/SKILL.md` | Global (Mux) |
| 3 | `~/.agents/skills/<name>/SKILL.md` | Universal (cross-tool) |
| 4 | Built-in | Shipped with Mux |

### Loading Phases

1. **Index** (startup): Only frontmatter is parsed. Skills appear in the `<agent-skills>` system prompt block (~50–100 tokens each).
2. **Activate** (on demand): Full body loaded via `agent_skill_read()` or slash command.
3. **Resource** (as needed): Supporting files loaded via `agent_skill_read_file()`.

## Validation

Run the validation script to check all skills:

```bash
bash scripts/validate.sh
```

Checks performed:
- SKILL.md exists in each skill directory
- Directory name is valid kebab-case
- Required frontmatter fields present (`name`, `description`)
- `name` matches directory name
- File size under 1MB

## Cross-Tool Compatibility

The Agent Skills spec is supported by multiple tools:

| Tool | Discovery Path |
|------|---------------|
| Mux | `.mux/skills/`, `~/.mux/skills/` |
| Claude Code | `.claude/skills/` |
| Universal | `~/.agents/skills/` |

To maximize portability:
- Keep SKILL.md content tool-agnostic
- Don't reference Mux-specific APIs in skill bodies
- Put Mux-specific behavior in agent definitions (`agents/*.md`)
- Use `advertise: false` (Mux-specific) only when needed

## Installing Skills from External Repos

```bash
npx skills add https://github.com/owner/repo --skill skill-name
```

This downloads a skill from a GitHub repo into `~/.agents/skills/` (or the configured path).

## Validating with skills-ref

For formal validation against the Agent Skills spec:

```bash
npx skills-ref validate ./skills/my-skill
```
