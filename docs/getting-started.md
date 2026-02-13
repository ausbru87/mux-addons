# Getting Started with mux-addons

## Prerequisites

- [Mux](https://mux.coder.com) installed and running
- Git
- Bash (for install scripts)

## Quick Install

```bash
# Clone the repo
git clone https://github.com/ausbru87/mux-addons.git
cd mux-addons

# Install skills + agents
bash scripts/install.sh

# Restart Mux to pick up changes
```

## What Gets Installed

The install script does two things:

1. **Symlinks skills** from `skills/<name>/` → `~/.mux/skills/<name>/`
   - Skills are symlinked (not copied) so updates are instant after `git pull`
   - Mux discovers skills from `~/.mux/skills/` at startup

2. **Copies agents** from `agents/<name>.md` → `~/.mux/agents/<name>.md`
   - Agent definitions are copied (they're small single files)
   - Re-run install after pulling changes to update agents

## Verify Installation

After restarting Mux:

1. **Check skills**: Type `/` in chat — you should see the installed skill triggers (e.g., `/speckit`, `/openspec`, `/coder-diagrams`)
2. **Check agents**: Open the agent selector — you should see the installed agents (e.g., SK Spec, OPSX Exec)

## Install Individual Skills

If you only want specific skills, use the `npx skills` CLI:

```bash
npx skills add https://github.com/ausbru87/mux-addons --skill sk-spec
npx skills add https://github.com/ausbru87/mux-addons --skill opsx-exec
```

This installs to `~/.agents/skills/` (the universal cross-tool path).

## Uninstall

```bash
bash scripts/install.sh --remove
```

## Updating

```bash
bash scripts/sync.sh
# This runs: git pull --ff-only && bash scripts/install.sh
```

## Next Steps

- [Authoring Skills](authoring-skills.md) — Create your own skills
- [Authoring Agents](authoring-agents.md) — Create custom agent definitions
- [Skill Reference](skill-reference.md) — Full SKILL.md schema documentation
- [Architecture](architecture.md) — How Mux loads skills, agents, and configs
