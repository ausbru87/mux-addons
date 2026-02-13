# Agent Template

Use this template to create a new Mux agent definition. Agents are Mux-specific — they define the UI, tools, and base behavior for an agent.

## Quick Start

1. Copy the template:
   ```bash
   cp templates/agent/agent.md.tmpl agents/my-agent.md
   ```

2. Edit `agents/my-agent.md`:
   - Set `name` (Title Case display name)
   - Set `description`
   - Set `base` to `exec` (for implementation) or `plan` (for planning/research)
   - Choose a `ui.color`
   - Configure `tools.add` and optionally `tools.remove`
   - Update the body to reference the corresponding skill

3. Install: `bash scripts/install.sh`

## Agent Types

| Base | Purpose | Typical Tools |
|------|---------|---------------|
| `exec` | Implementation, code changes | `task`, `task_.*`, `bash`, file tools |
| `plan` | Planning, research, specification | `web_fetch`, `web_search`, file tools |

**Convention**: `exec` agents get task tools (can spawn sub-agents); `plan` agents get web tools but task tools are removed.
