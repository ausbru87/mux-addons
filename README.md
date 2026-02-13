# mux-addons

A collection of shareable skills, agent definitions, configs, and documentation for [Mux](https://mux.coder.com).

Skills follow the open [Agent Skills specification](https://agentskills.io/specification) and are compatible with any tool that supports it. Agent definitions are Mux-specific.

## Quick Install

```bash
git clone https://github.com/ausbru87/mux-addons.git
cd mux-addons
bash scripts/install.sh
# Restart Mux to pick up changes
```

> **What does `install.sh` do?** It symlinks each `skills/<name>/` into `~/.mux/skills/` (so updates are instant after `git pull`) and copies each `agents/<name>.md` into `~/.mux/agents/`. That's it — no build step, no dependencies.

## Using the Addons

After installing and restarting Mux, you get new **skills**, **agents**, and **configs** you can use immediately.

### 1. Use a Skill (slash commands)

Skills activate via slash commands in any Mux chat. Type `/` and you'll see the installed triggers:

```
/speckit          → Spec-driven development workflow (explore → specify → plan → tasks)
/openspec         → OpenSpec fluid specification workflow  
/coder-diagrams   → Generate Coder architecture diagrams
/sk-exec          → TDD implementation with parallel sub-agents
/opsx-exec        → OpenSpec batched execution with verification
```

**Example — start a spec-driven feature:**
```
You:  /speckit
Mux:  [loads sk-spec skill, enters specification mode]
You:  I want to add OAuth2 login to our API
Mux:  [guides you through explore → specify → plan → tasks]
```

**Example — generate a Coder diagram:**
```
You:  /coder-diagrams
Mux:  [loads coder-diagrams skill]
You:  Show me a K8s deployment architecture for Coder with workspace proxies
Mux:  [produces a Mermaid diagram with control plane, data plane, and proxy relay]
```

### 2. Use a Custom Agent (agent selector)

Agents appear in the Mux agent dropdown (top of the chat). Each agent is pre-configured with the right tools and behavior for its job:

| Pick this agent... | When you want to... |
|---------------------|---------------------|
| **SK Spec** | Plan a feature with spec-driven development (TDD, constitutional enforcement) |
| **SK Exec** | Implement spec-kit tasks with strict TDD and parallel sub-agents |
| **OPSX Spec** | Specify a change using OpenSpec's fluid, iterative workflow |
| **OPSX Exec** | Execute OpenSpec tasks with batched parallelism and verification |
| **Coder Diagrams** | Generate infrastructure diagrams for Coder deployments |

Agents load their paired skill automatically — just select the agent and start chatting.

### 3. Apply Configuration Presets

The `configs/` directory contains ready-to-use configuration fragments. These aren't installed automatically — you pick what you need.

#### Model presets

Set which model and thinking level an agent uses. Edit `~/.mux/config.json` or use the Mux settings UI:

```bash
# See what's available
cat configs/model-presets/fast.json      # Sonnet + low thinking (quick iteration)
cat configs/model-presets/balanced.json   # Sonnet + medium thinking (general dev)
cat configs/model-presets/deep.json       # Opus + xhigh thinking (complex planning)
```

To apply a preset, add it to `~/.mux/config.json` under `agentAiDefaults`:

```jsonc
{
  "agentAiDefaults": {
    // Use deep thinking for specification agents
    "sk-spec": {
      "modelString": "anthropic:claude-opus-4-6",
      "thinkingLevel": "xhigh"
    },
    // Use fast preset for execution agents
    "sk-exec": {
      "modelString": "anthropic:claude-sonnet-4-20250514",
      "thinkingLevel": "low"
    }
  }
}
```

#### Task settings

Control sub-agent parallelism and output compaction:

```bash
cat configs/task-settings/default.json
```

```jsonc
{
  "taskSettings": {
    "maxParallelAgentTasks": 10,    // How many sub-agents can run at once
    "maxTaskNestingDepth": 5,       // How deep sub-agents can nest
    "bashOutputCompactionMinLines": 10,
    "bashOutputCompactionMaxKeptLines": 40
  }
}
```

Merge these values into the `taskSettings` key in `~/.mux/config.json`.

#### MCP servers

Add external tool servers (Model Context Protocol):

```bash
# Copy to global config
cp configs/mcp/coder.jsonc ~/.mux/mcp.jsonc

# Or to a specific project
cp configs/mcp/coder.jsonc /path/to/project/.mux/mcp.jsonc
```

### 4. Verify Everything Works

```bash
# Check the install
bash scripts/install.sh --dry-run    # Preview what would be installed

# Validate skill/agent files
bash scripts/validate.sh             # Lint frontmatter and naming conventions
```

After restarting Mux:
1. Type `/` in chat — installed skill triggers should appear
2. Open the agent selector — installed agents should be listed
3. Select an agent (e.g., SK Spec) and start a conversation — it should load its skill automatically

## What's Inside

### Skills

Cross-tool compatible Agent Skills — usable with Mux, Claude Code, Cursor, and any tool supporting the [Agent Skills spec](https://agentskills.io/specification).

| Skill | Triggers | Description |
|-------|----------|-------------|
| [`coder-diagrams`](skills/coder-diagrams/SKILL.md) | `/coder-diagrams`, `/coder-diagram` | Coder infrastructure and architecture diagram generation with Mermaid |
| [`opsx-exec`](skills/opsx-exec/SKILL.md) | `/opsx-exec`, `/opsx-apply` | OpenSpec execution — dependency-batched implementation with parallel sub-agents and verification |
| [`opsx-spec`](skills/opsx-spec/SKILL.md) | `/openspec`, `/opsx-spec`, `/opsx` | OpenSpec specification — fluid iterative workflow with artifact dependency tracking |
| [`sk-exec`](skills/sk-exec/SKILL.md) | `/sk-exec`, `/speckit-implement` | spec-kit execution — TDD implementation with strict enforcement and parallel sub-agent orchestration |
| [`sk-spec`](skills/sk-spec/SKILL.md) | `/speckit`, `/sk-spec`, `/spec-driven` | spec-kit specification — explore, specify, plan, and task breakdown with strict constitutional enforcement |

### Agents

Mux-specific agent definitions that pair with skills above.

| Agent | Base | Color | Description |
|-------|------|-------|-------------|
| [Coder Diagrams](agents/coder-diagrams.md) | `plan` | 🔵 `#2563eb` | Coder infrastructure and architecture diagram generation |
| [OPSX Exec](agents/opsx-exec.md) | `exec` | 🟢 `#10b981` | OpenSpec execution with verification |
| [OPSX Spec](agents/opsx-spec.md) | `plan` | 🟢 `#10b981` | OpenSpec fluid specification workflow |
| [SK Exec](agents/sk-exec.md) | `exec` | 🟣 `#6366f1` | spec-kit TDD execution with parallel sub-agents |
| [SK Spec](agents/sk-spec.md) | `plan` | 🟣 `#6366f1` | spec-kit specification — constitutional spec-driven development |

### Configs

Shareable configuration fragments for Mux.

| Config | Description |
|--------|-------------|
| [`configs/mcp/coder.jsonc`](configs/mcp/coder.jsonc) | Coder MCP server configuration |
| [`configs/task-settings/default.json`](configs/task-settings/default.json) | Balanced task settings (parallelism, nesting, compaction) |
| [`configs/model-presets/fast.json`](configs/model-presets/fast.json) | Sonnet + low thinking — quick iteration |
| [`configs/model-presets/balanced.json`](configs/model-presets/balanced.json) | Sonnet + medium thinking — general development |
| [`configs/model-presets/deep.json`](configs/model-presets/deep.json) | Opus + xhigh thinking — complex planning |

## Repository Structure

```
mux-addons/
├── skills/                     # Agent Skills (cross-tool compatible)
│   ├── coder-diagrams/
│   ├── opsx-exec/
│   ├── opsx-spec/
│   ├── sk-exec/
│   └── sk-spec/
├── agents/                     # Mux agent definitions
│   ├── coder-diagrams.md
│   ├── opsx-exec.md
│   ├── opsx-spec.md
│   ├── sk-exec.md
│   └── sk-spec.md
├── configs/                    # Shareable config fragments
│   ├── mcp/                    # MCP server configs
│   ├── task-settings/          # Task settings presets
│   └── model-presets/          # Model + thinking level combos
├── templates/                  # Starter templates
│   ├── skill/                  # New skill skeleton
│   └── agent/                  # New agent skeleton
├── scripts/                    # Tooling
│   ├── install.sh              # Install to ~/.mux/
│   ├── validate.sh             # Lint skills + agents
│   └── sync.sh                 # Pull + re-install
└── docs/                       # Extended documentation
    ├── getting-started.md
    ├── authoring-skills.md
    ├── authoring-agents.md
    ├── skill-reference.md
    └── architecture.md
```

## Install Individual Skills

You can install individual skills using the `npx skills` CLI (works with any compatible tool):

```bash
npx skills add https://github.com/ausbru87/mux-addons --skill sk-spec
npx skills add https://github.com/ausbru87/mux-addons --skill coder-diagrams
```

## Creating Your Own

### New Skill

```bash
cp -r templates/skill skills/my-new-skill
mv skills/my-new-skill/SKILL.md.tmpl skills/my-new-skill/SKILL.md
# Edit skills/my-new-skill/SKILL.md
bash scripts/validate.sh   # Check it passes
bash scripts/install.sh    # Install to ~/.mux/
```

See [docs/authoring-skills.md](docs/authoring-skills.md) for details.

### New Agent

```bash
cp templates/agent/agent.md.tmpl agents/my-agent.md
# Edit agents/my-agent.md
bash scripts/install.sh
```

See [docs/authoring-agents.md](docs/authoring-agents.md) for details.

## Updating

```bash
bash scripts/sync.sh
# Equivalent to: git pull --ff-only && bash scripts/install.sh
```

## Uninstalling

```bash
bash scripts/install.sh --remove
```

## Documentation

| Doc | Description |
|-----|-------------|
| [Getting Started](docs/getting-started.md) | Install, verify, update |
| [Authoring Skills](docs/authoring-skills.md) | Create cross-tool compatible skills |
| [Authoring Agents](docs/authoring-agents.md) | Create Mux agent definitions |
| [Skill Reference](docs/skill-reference.md) | Complete SKILL.md schema reference |
| [Architecture](docs/architecture.md) | How Mux loads skills, agents, and configs |

## License

[Apache-2.0](LICENSE)
