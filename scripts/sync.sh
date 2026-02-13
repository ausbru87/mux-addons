#!/usr/bin/env bash
set -euo pipefail

# Sync mux-addons: pull latest changes and re-install
#
# Usage: bash scripts/sync.sh

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPT_DIR="$REPO_DIR/scripts"

echo "Syncing mux-addons..."
echo ""

# Pull latest
cd "$REPO_DIR"
echo "Pulling latest changes..."
git pull --ff-only
echo ""

# Re-install
echo "Re-installing..."
bash "$SCRIPT_DIR/install.sh"
