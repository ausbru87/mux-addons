# Authoring Agents

Agent definitions are **Mux-specific** configuration files that define custom agents with specific tools, UI styling, and base behavior. They pair with skills to create purpose-built AI agents.

## Anatomy of an Agent

Agent definitions live at `agents/<name>.md` — a single markdown file with YAML frontmatter.

```yaml
---
name: My Agent
description: One-line description
base: exec
ui:
  color: "#6366f1"
subagent:
  runnable: true
tools:
  add:
    - file_read
    - bash
---

# Agent body (bootstrap + quick reference)
```

## Frontmatter Fields

### `name` (string, required)
Display name shown in the Mux UI. Use Title Case (e.g., "SK Exec", "OPSX Spec").

### `description` (string, required)
One-line description shown in the agent selector.

### `base` (string, required)
Base agent type that determines default behavior:

| Base | Purpose | Default Behavior |
|------|---------|-----------------|
| `exec` | Implementation, code changes | Can spawn sub-agents, focused on execution |
| `plan` | Planning, research, specification | Web access, focused on investigation |

### `ui.color` (string)
Hex color for the agent's UI display (e.g., `"#6366f1"` for indigo, `"#10b981"` for emerald).

### `subagent.runnable` (boolean)
Whether this agent can be spawned as a sub-agent by other agents. Usually `true`.

### `tools.add` (list of strings)
Tool name patterns to add to the agent. Supports regex patterns:

```yaml
tools:
  add:
    - file_read            # Exact match
    - "file_edit_.*"       # Regex: all file_edit tools
    - bash
    - task                 # Sub-agent spawning
    - "task_.*"            # Sub-agent management
    - agent_skill_read     # Skill loading
    - agent_skill_read_file
```

### `tools.remove` (list of strings, optional)
Tool name patterns to remove. Commonly used by `plan` agents to remove task tools:

```yaml
tools:
  remove:
    - task
    - "task_.*"
```

## Agent/Skill Pairing Convention

Agents and skills are linked by naming convention:

```
agents/my-tool.md          →  skills/my-tool/SKILL.md
  (Mux-specific config)         (Cross-tool instructions)
```

The agent body bootstraps by loading its skill:

```markdown
## Load Full Instructions

Before starting, load the detailed workflow:

\`\`\`
agent_skill_read({ name: "my-tool" })
\`\`\`
```

### Why Separate?

- **Skills** are cross-tool compatible (work with Claude Code, Cursor, etc.)
- **Agents** are Mux-specific (tools, UI, base type)
- Separating them maximizes portability while enabling Mux-specific features

## Body Content

The agent body serves two purposes:

1. **Bootstrap**: Load the full skill instructions
2. **Quick Reference**: Condensed cheat sheet in case skill loading fails or for quick reminders

```markdown
# My Agent

Brief description.

## Load Full Instructions

agent_skill_read({ name: "my-skill" })

## Quick Reference

**Workflow:**
1. Step one
2. Step two

**Key constraints:**
- Constraint one
- Constraint two
```

## Agent Type Patterns

### Exec Agent Pattern
For implementation agents that can orchestrate sub-agents:

```yaml
base: exec
tools:
  add:
    - file_read
    - "file_edit_.*"
    - bash
    - task
    - "task_.*"
    - agent_skill_read
    - agent_skill_read_file
```

### Plan Agent Pattern
For specification/research agents with web access but no sub-agent spawning:

```yaml
base: plan
tools:
  add:
    - file_read
    - "file_edit_.*"
    - bash
    - web_fetch
    - web_search
    - agent_skill_read
    - agent_skill_read_file
  remove:
    - task
    - "task_.*"
```

## Where Agents Are Loaded From

Mux discovers agent definitions from:
- `.mux/agents/<name>.md` — workspace-local
- `~/.mux/agents/<name>.md` — global

The install script copies agents to `~/.mux/agents/`.

## Template

```bash
cp templates/agent/agent.md.tmpl agents/my-agent.md
# Edit agents/my-agent.md
```

## Scoped Instructions

Agent `.md` files support scoped instruction headings (same as `AGENTS.md`):

```markdown
## Model: claude-opus.*
Instructions only active when this agent runs with a matching model.

## Tool: bash
Instructions appended to the bash tool's description.
```
