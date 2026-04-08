#!/bin/bash
# Install GSD from shootdaj/gsdfr
# Usage: curl -sL https://raw.githubusercontent.com/shootdaj/gsdfr/main/scripts/install.sh | bash

set -e

REPO="https://github.com/shootdaj/gsdfr.git"
TMPDIR=$(mktemp -d)

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " GSD Installer"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check dependencies
for cmd in git node; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Error: $cmd is not installed."
        exit 1
    fi
done

# Clone fork to temp directory
echo "Fetching latest..."
git clone --depth 1 "$REPO" "$TMPDIR/gsdfr" 2>&1 | grep -v "^$"
echo ""

# Run installer
echo "Running installer..."
cd "$TMPDIR/gsdfr"
node bin/install.js --claude --global
echo ""

# Clean up temp clone
rm -rf "$TMPDIR"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Done"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Update:  /gsd:update (inside Claude Code)"
echo "  Or:      re-run this script"
echo ""
