# Mux Architecture: Skills, Agents, and Configs

How Mux discovers, loads, and uses skills, agents, and configuration files.

## Overview

```
┌──────────────────────────────────────────────────────────────┐
│                      Mux System Prompt                       │
├──────────────────────────────────────────────────────────────┤
│  Prelude (identity, rendering, memory)                       │
│  Environment (workspace path, runtime type)                  │
│  Custom Instructions (from AGENTS.md)                        │
│  Agent Skills Index (name + description per skill)           │
│  MCP Servers (configured server names)                       │
│  Agent Definition (if custom agent selected)                 │
└──────────────────────────────────────────────────────────────┘
```

## Skills Lifecycle

### 1. Discovery (Startup)

Mux scans skill directories and parses YAML frontmatter only:

```
~/.mux/skills/sk-spec/SKILL.md  →  { name: "sk-spec", description: "..." }
~/.mux/skills/opsx-exec/SKILL.md  →  { name: "opsx-exec", description: "..." }
```

These are injected into the system prompt as an `<agent-skills>` XML block.

### 2. Activation (On Demand)

When a skill is needed (via `/trigger` or `agent_skill_read()`), the full SKILL.md body is loaded into the agent's context window.

### 3. Resource Loading (As Needed)

The agent can load supporting files from skill subdirectories:

```
agent_skill_read_file({ name: "my-skill", filePath: "references/api.md" })
```

## Agents Lifecycle

### 1. Registration (Startup)

Mux reads `.md` files from `~/.mux/agents/` (and `.mux/agents/` for workspace-local). Each file's frontmatter determines:

- Display name and description
- Base type (`exec` or `plan`)
- UI color
- Available tools
- Whether it can be spawned as a sub-agent

### 2. Selection

Users select agents from the agent dropdown in the Mux UI.

### 3. Execution

When selected, the agent definition's frontmatter configures the agent's capabilities, and the body content is included as agent-specific instructions. The body typically bootstraps by loading its paired skill.

## Configuration Layers

### Instruction Files (AGENTS.md)

```
~/.mux/AGENTS.md           →  Global instructions (all agents, all projects)
<workspace>/AGENTS.md      →  Workspace instructions (this project only)
```

Both support:
- `## Model: <regex>` — active only for matching models
- `## Tool: <tool_name>` — appended to tool descriptions

### MCP Servers

```
~/.mux/mcp.jsonc           →  Global MCP config
.mux/mcp.jsonc             →  Per-project MCP config
.mux/mcp.local.jsonc       →  Local override (gitignored)
```

Servers start lazily, idle-timeout after 10 minutes, and hot-reload on config changes.

### Task Settings

Configured in `~/.mux/config.json` under `taskSettings`:

```json
{
  "taskSettings": {
    "maxParallelAgentTasks": 10,
    "maxTaskNestingDepth": 5,
    "bashOutputCompactionMinLines": 10,
    "bashOutputCompactionMinTotalBytes": 4096,
    "bashOutputCompactionMaxKeptLines": 40
  }
}
```

### Model Defaults

Per-agent model preferences in `~/.mux/config.json`:

```json
{
  "agentAiDefaults": {
    "sk-spec": {
      "modelString": "anthropic:claude-opus-4-6",
      "thinkingLevel": "xhigh"
    }
  },
  "subagentAiDefaults": {
    "exec": {
      "modelString": "anthropic:claude-sonnet-4-20250514",
      "thinkingLevel": "medium"
    }
  }
}
```

## File Precedence

### Skills (first match wins)
1. `.mux/skills/<name>/SKILL.md` (workspace-local)
2. `~/.mux/skills/<name>/SKILL.md` (global)
3. `~/.agents/skills/<name>/SKILL.md` (universal)
4. Built-in

### Agents
1. `.mux/agents/<name>.md` (workspace-local)
2. `~/.mux/agents/<name>.md` (global)

### Instructions
1. Agent definition body
2. Workspace `AGENTS.md`
3. Global `~/.mux/AGENTS.md`

### MCP
1. `.mux/mcp.local.jsonc` (local override)
2. `.mux/mcp.jsonc` (per-project)
3. `~/.mux/mcp.jsonc` (global)

## How This Repo Integrates

The `scripts/install.sh` script connects this repo to Mux:

```
mux-addons/skills/<name>/  ──symlink──▶  ~/.mux/skills/<name>/
mux-addons/agents/<name>.md  ──copy──▶  ~/.mux/agents/<name>.md
```

Skills are **symlinked** so `git pull` immediately updates them. Agents are **copied** because they're small single files and copying avoids symlink edge cases with the agents directory.

After installation, restart Mux to pick up:
- New skills in the skills index
- New agents in the agent selector
- Updated skill/agent content
