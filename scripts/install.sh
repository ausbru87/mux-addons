#!/usr/bin/env bash
set -euo pipefail

# Install mux-addons: symlink skills + copy agents into ~/.mux/
#
# Usage:
#   bash scripts/install.sh            # Install
#   bash scripts/install.sh --dry-run  # Preview without changes
#   bash scripts/install.sh --remove   # Uninstall

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
MUX_DIR="${MUX_HOME:-$HOME/.mux}"
MODE="${1:-install}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info()  { echo -e "${GREEN}✓${NC} $*"; }
warn()  { echo -e "${YELLOW}⚠${NC} $*"; }
error() { echo -e "${RED}✗${NC} $*" >&2; }
dry()   { echo -e "  ${YELLOW}[dry-run]${NC} $*"; }

install_skills() {
    local count=0
    mkdir -p "$MUX_DIR/skills"
    for skill_dir in "$REPO_DIR"/skills/*/; do
        [ -f "$skill_dir/SKILL.md" ] || continue
        local name
        name=$(basename "$skill_dir")
        local target="$MUX_DIR/skills/$name"
        if [[ "$MODE" == "--dry-run" ]]; then
            dry "ln -sfn $skill_dir → $target"
        else
            ln -sfn "$skill_dir" "$target"
            info "Linked skill: $name"
        fi
        ((count++))
    done
    echo "  Skills: $count"
}

install_agents() {
    local count=0
    mkdir -p "$MUX_DIR/agents"
    for agent_file in "$REPO_DIR"/agents/*.md; do
        [ -f "$agent_file" ] || continue
        local name
        name=$(basename "$agent_file")
        local target="$MUX_DIR/agents/$name"
        if [[ "$MODE" == "--dry-run" ]]; then
            dry "cp $agent_file → $target"
        else
            cp "$agent_file" "$target"
            info "Installed agent: $name"
        fi
        ((count++))
    done
    echo "  Agents: $count"
}

remove_skills() {
    for skill_dir in "$REPO_DIR"/skills/*/; do
        [ -f "$skill_dir/SKILL.md" ] || continue
        local name
        name=$(basename "$skill_dir")
        local target="$MUX_DIR/skills/$name"
        if [ -L "$target" ]; then
            rm "$target"
            info "Removed skill symlink: $name"
        fi
    done
}

remove_agents() {
    for agent_file in "$REPO_DIR"/agents/*.md; do
        [ -f "$agent_file" ] || continue
        local name
        name=$(basename "$agent_file")
        local target="$MUX_DIR/agents/$name"
        if [ -f "$target" ]; then
            rm "$target"
            info "Removed agent: $name"
        fi
    done
}

echo "╔══════════════════════════════════════╗"
echo "║       mux-addons installer           ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "  Repo:   $REPO_DIR"
echo "  Target: $MUX_DIR"
echo "  Mode:   $MODE"
echo ""

case "$MODE" in
    install|--dry-run)
        install_skills
        install_agents
        echo ""
        if [[ "$MODE" == "--dry-run" ]]; then
            warn "Dry run complete. Re-run without --dry-run to install."
        else
            info "Done! Restart Mux to pick up changes."
        fi
        ;;
    --remove|--uninstall)
        remove_skills
        remove_agents
        echo ""
        info "Uninstalled. Restart Mux to apply."
        ;;
    *)
        error "Unknown mode: $MODE"
        echo "Usage: $0 [--dry-run|--remove]"
        exit 1
        ;;
esac
