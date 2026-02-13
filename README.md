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
