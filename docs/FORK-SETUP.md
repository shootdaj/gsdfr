# GSD Fork — shootdaj/gsdfr

Personal fork of [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done). This is the single source of GSD across all machines.

**Do NOT install GSD from npm. Always clone this fork.**

## Architecture

```
gsd-build/get-shit-done (upstream)    ← official releases
        ↕ git fetch upstream
shootdaj/gsdfr (GitHub)               ← your fork = your GSD distribution
        ↕ git clone / git pull
~/.claude/get-shit-done (any machine) ← local install
```

## Fresh Install (new machine)

Run this on any machine to set up GSD from your fork:

```bash
# 1. Clone the fork
git clone git@github.com:shootdaj/gsdfr.git ~/.claude/get-shit-done

# 2. Add upstream remote
cd ~/.claude/get-shit-done
git remote add upstream https://github.com/gsd-build/get-shit-done.git

# 3. Create runtime symlinks (repo structure ≠ runtime paths)
ln -sf get-shit-done/workflows workflows
ln -sf get-shit-done/templates templates
ln -sf get-shit-done/references references
ln -sf get-shit-done/bin/gsd-tools.cjs bin/gsd-tools.cjs
ln -sf get-shit-done/bin/lib bin/lib
ln -sf get-shit-done/VERSION VERSION

# 4. Install hooks
cp hooks/gsd-*.js ~/.claude/hooks/

# 5. Install agents
cp agents/gsd-*.md ~/.claude/agents/

# 6. Wire hooks into settings.json (if not already there)
# Check ~/.claude/settings.json — hooks should reference:
#   ~/.claude/hooks/gsd-check-update.js (SessionStart)
#   ~/.claude/hooks/gsd-prompt-guard.js (PreToolUse)
#   ~/.claude/hooks/gsd-statusline.js (Notification)
# If missing, run the official installer once to wire them, then re-clone fork on top.
```

### One-liner (after first setup)

For machines where you've already set up Claude Code and just need GSD:

```bash
git clone git@github.com:shootdaj/gsdfr.git ~/.claude/get-shit-done && cd ~/.claude/get-shit-done && git remote add upstream https://github.com/gsd-build/get-shit-done.git && ln -sf get-shit-done/workflows workflows && ln -sf get-shit-done/templates templates && ln -sf get-shit-done/references references && ln -sf get-shit-done/bin/gsd-tools.cjs bin/gsd-tools.cjs && ln -sf get-shit-done/bin/lib bin/lib && ln -sf get-shit-done/VERSION VERSION && cp hooks/gsd-*.js ~/.claude/hooks/ && cp agents/gsd-*.md ~/.claude/agents/
```

## Updating

When GSD shows "update available" in Claude Code, run `/gsd:update`. The fork-aware update workflow will:

1. `git fetch upstream` — check for new official releases
2. Show changelog diff
3. `git merge upstream/main` — merge upstream, preserving your customizations
4. Copy updated hooks/agents to `~/.claude/hooks/` and `~/.claude/agents/`
5. `git push origin main` — push merged result to your fork

Other machines get the update on next `git pull`:

```bash
cd ~/.claude/get-shit-done && git pull
```

## Syncing Across Machines

Your fork is the single source of truth. The workflow:

**Machine A (where you make changes):**
```bash
cd ~/.claude/get-shit-done
# make changes
git commit -am "description"
git push origin main
```

**Machine B (pull changes):**
```bash
cd ~/.claude/get-shit-done
git pull origin main
# Copy updated hooks/agents if they changed
cp hooks/gsd-*.js ~/.claude/hooks/
cp agents/gsd-*.md ~/.claude/agents/
```

Changes take effect immediately — Claude Code reads these files live.

## Directory Structure

```
~/.claude/get-shit-done/              ← git clone of shootdaj/gsdfr
├── get-shit-done/                    ← runtime files (from upstream)
│   ├── bin/gsd-tools.cjs
│   ├── workflows/
│   ├── templates/
│   └── references/
├── agents/                           ← agent definitions → copied to ~/.claude/agents/
├── hooks/                            ← hook scripts → copied to ~/.claude/hooks/
├── docs/                             ← your docs (this file, etc.)
├── bin/
│   ├── install.js                    ← official installer (unused with fork)
│   ├── gsd-tools.cjs → symlink      ← runtime compatibility
│   └── lib → symlink
├── workflows → symlink               ← runtime compatibility
├── templates → symlink
├── references → symlink
└── VERSION → symlink
```

Symlinks exist because GSD's runtime references `~/.claude/get-shit-done/bin/gsd-tools.cjs` (root level) but the repo stores it at `get-shit-done/bin/gsd-tools.cjs` (nested).

## What's Customized

### Active
- **Fork-aware update workflow** (`get-shit-done/workflows/update.md`): Git merge instead of npm install. Preserves customizations across updates.
- **Self-check acceptance criteria re-run** (`get-shit-done/workflows/execute-plan.md`): Self-check re-runs ALL acceptance criteria and plan-level verification before finalizing SUMMARY. Upstream PR: gsd-build/get-shit-done#1959.

### Planned
- **Plan expansion pass** (gsd-build/get-shit-done#2006): Post-planner agent that cross-references task actions against project rules and expands shallow descriptions with full algorithms.

## Troubleshooting

### GSD commands not working after clone
Check symlinks: `ls -la ~/.claude/get-shit-done/bin/gsd-tools.cjs` — should point to `../get-shit-done/bin/gsd-tools.cjs`. If broken, re-run the symlink commands from the install section.

### Hooks not firing
Check `~/.claude/settings.json` for hook entries referencing `~/.claude/hooks/gsd-*.js`. If missing, run the official installer once (`npx get-shit-done-cc --global`), then re-clone your fork on top.

### Merge conflicts on update
Resolve normally in `~/.claude/get-shit-done`, then `git add -A && git commit && git push`. Your customizations are regular commits — standard git conflict resolution applies.

### Starting fresh
```bash
mv ~/.claude/get-shit-done ~/.Trash/
# Re-run the fresh install steps above
```
