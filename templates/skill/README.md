# Skill Template

Use this template to create a new Agent Skill for Mux (and any tool supporting the [Agent Skills spec](https://agentskills.io/specification)).

## Quick Start

1. Copy the template:
   ```bash
   cp -r templates/skill skills/my-new-skill
   mv skills/my-new-skill/SKILL.md.tmpl skills/my-new-skill/SKILL.md
   ```

2. Edit `skills/my-new-skill/SKILL.md`:
   - Set `name` to match the directory name
   - Write a clear `description` (shown in the skills index)
   - Add `triggers` (slash-commands that activate the skill)
   - Write the markdown body with full instructions

3. Optional subdirectories:
   - `scripts/` — executable helpers (Python, Bash, JS)
   - `references/` — additional documentation
   - `assets/` — templates, schemas, data files

4. Install: `bash scripts/install.sh`
