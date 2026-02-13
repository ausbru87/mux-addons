#!/usr/bin/env bash
set -euo pipefail

# Validate mux-addons: check SKILL.md frontmatter, naming conventions, and agent definitions
#
# Usage: bash scripts/validate.sh

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ERRORS=0
WARNINGS=0

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

pass()  { echo -e "  ${GREEN}✓${NC} $*"; }
fail()  { echo -e "  ${RED}✗${NC} $*"; ((ERRORS++)); }
warn_() { echo -e "  ${YELLOW}⚠${NC} $*"; ((WARNINGS++)); }

echo "Validating mux-addons..."
echo ""

# --- Validate Skills ---
echo "Skills:"
for skill_dir in "$REPO_DIR"/skills/*/; do
    dir_name=$(basename "$skill_dir")

    # Check SKILL.md exists
    if [ ! -f "$skill_dir/SKILL.md" ]; then
        fail "$dir_name: missing SKILL.md"
        continue
    fi

    # Check directory name format (kebab-case)
    if ! [[ "$dir_name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
        fail "$dir_name: directory name must be kebab-case (^[a-z0-9]+(-[a-z0-9]+)*$)"
    fi

    # Check frontmatter exists
    if ! head -1 "$skill_dir/SKILL.md" | grep -q '^---$'; then
        fail "$dir_name: SKILL.md missing YAML frontmatter (must start with ---)"
        continue
    fi

    # Extract frontmatter
    frontmatter=$(sed -n '1,/^---$/p' "$skill_dir/SKILL.md" | tail -n +2 | head -n -1)

    # Check required fields
    if ! echo "$frontmatter" | grep -q '^name:'; then
        fail "$dir_name: SKILL.md missing required 'name' field"
    else
        # Check name matches directory
        skill_name=$(echo "$frontmatter" | grep '^name:' | sed 's/^name:[[:space:]]*//')
        if [ "$skill_name" != "$dir_name" ]; then
            fail "$dir_name: SKILL.md name '$skill_name' does not match directory name '$dir_name'"
        else
            pass "$dir_name: name matches directory"
        fi
    fi

    if ! echo "$frontmatter" | grep -q '^description:'; then
        fail "$dir_name: SKILL.md missing required 'description' field"
    else
        pass "$dir_name: has description"
    fi

    if ! echo "$frontmatter" | grep -q '^triggers:'; then
        warn_ "$dir_name: SKILL.md missing 'triggers' field (optional but recommended)"
    else
        pass "$dir_name: has triggers"
    fi

    # Check file size (max 1MB)
    file_size=$(wc -c < "$skill_dir/SKILL.md")
    if [ "$file_size" -gt 1048576 ]; then
        fail "$dir_name: SKILL.md exceeds 1MB limit ($file_size bytes)"
    fi
done

echo ""

# --- Validate Agents ---
echo "Agents:"
for agent_file in "$REPO_DIR"/agents/*.md; do
    [ -f "$agent_file" ] || continue
    file_name=$(basename "$agent_file" .md)

    # Check directory name format
    if ! [[ "$file_name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
        fail "$file_name: file name must be kebab-case"
    fi

    # Check frontmatter exists
    if ! head -1 "$agent_file" | grep -q '^---$'; then
        fail "$file_name: missing YAML frontmatter"
        continue
    fi

    # Extract frontmatter
    frontmatter=$(sed -n '1,/^---$/p' "$agent_file" | tail -n +2 | head -n -1)

    # Check required fields
    for field in name description base; do
        if ! echo "$frontmatter" | grep -q "^${field}:"; then
            fail "$file_name: missing required '$field' field"
        else
            pass "$file_name: has $field"
        fi
    done

    # Check for matching skill
    if [ -d "$REPO_DIR/skills/$file_name" ]; then
        pass "$file_name: matching skill found"
    else
        warn_ "$file_name: no matching skill directory at skills/$file_name/"
    fi
done

echo ""

# --- Summary ---
echo "════════════════════════════════"
if [ "$ERRORS" -gt 0 ]; then
    echo -e "${RED}FAILED${NC}: $ERRORS error(s), $WARNINGS warning(s)"
    exit 1
else
    echo -e "${GREEN}PASSED${NC}: 0 errors, $WARNINGS warning(s)"
    exit 0
fi
