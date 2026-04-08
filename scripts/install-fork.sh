#!/bin/bash
# Install GSD from shootdaj/gsdfr fork
# Usage: curl -sL https://raw.githubusercontent.com/shootdaj/gsdfr/main/scripts/install-fork.sh | bash

set -e

REPO="git@github.com:shootdaj/gsdfr.git"
UPSTREAM="https://github.com/gsd-build/get-shit-done.git"
INSTALL_DIR="$HOME/.claude/get-shit-done"
HOOKS_DIR="$HOME/.claude/hooks"
AGENTS_DIR="$HOME/.claude/agents"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " GSD Fork Installer (shootdaj/gsdfr)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check for git
if ! command -v git &>/dev/null; then
    echo "Error: git is not installed."
    exit 1
fi

# Check for existing installation
if [ -d "$INSTALL_DIR" ]; then
    if [ -d "$INSTALL_DIR/.git" ]; then
        echo "Fork already installed. Pulling latest..."
        cd "$INSTALL_DIR"
        git pull origin main
        echo ""
    else
        echo "Existing non-git GSD installation found. Backing up..."
        BACKUP="$INSTALL_DIR-backup-$(date +%Y%m%d-%H%M%S)"
        mv "$INSTALL_DIR" "$BACKUP"
        echo "Backed up to: $BACKUP"
        echo ""
    fi
fi

# Clone if not already a git repo
if [ ! -d "$INSTALL_DIR/.git" ]; then
    echo "Cloning fork..."
    git clone "$REPO" "$INSTALL_DIR"
    cd "$INSTALL_DIR"
    git remote add upstream "$UPSTREAM" 2>/dev/null || true
    echo ""
fi

cd "$INSTALL_DIR"

# Create runtime symlinks
echo "Setting up runtime symlinks..."
ln -sf get-shit-done/workflows workflows 2>/dev/null || true
ln -sf get-shit-done/templates templates 2>/dev/null || true
ln -sf get-shit-done/references references 2>/dev/null || true
ln -sf get-shit-done/bin/gsd-tools.cjs bin/gsd-tools.cjs 2>/dev/null || true
ln -sf get-shit-done/bin/lib bin/lib 2>/dev/null || true
ln -sf get-shit-done/VERSION VERSION 2>/dev/null || true

# Install hooks
echo "Installing hooks..."
mkdir -p "$HOOKS_DIR"
for hook in hooks/gsd-*.js; do
    [ -f "$hook" ] || continue
    cp "$hook" "$HOOKS_DIR/"
    echo "  $(basename "$hook")"
done

# Install agents
echo "Installing agents..."
mkdir -p "$AGENTS_DIR"
for agent in agents/gsd-*.md; do
    [ -f "$agent" ] || continue
    cp "$agent" "$AGENTS_DIR/"
    echo "  $(basename "$agent")"
done

# Verify
VERSION=$(cat get-shit-done/VERSION 2>/dev/null || echo "unknown")
TOOLS_OK="no"
if [ -f "bin/gsd-tools.cjs" ]; then
    TOOLS_OK="yes"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " GSD Fork Installed"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Version:    $VERSION"
echo "  Location:   $INSTALL_DIR"
echo "  Fork:       shootdaj/gsdfr"
echo "  Tools OK:   $TOOLS_OK"
echo "  Hooks:      $HOOKS_DIR/gsd-*.js"
echo "  Agents:     $AGENTS_DIR/gsd-*.md"
echo ""
echo "  Note: Check ~/.claude/settings.json for hook wiring."
echo "  If hooks aren't firing, run the official installer once"
echo "  to wire settings.json, then re-run this script."
echo ""
echo "  To update:  /gsd:update (inside Claude Code)"
echo "  Or:         cd ~/.claude/get-shit-done && git pull"
echo ""
