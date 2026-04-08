# GSD Fork — shootdaj/gsdfr

Personal fork of [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done). Single source of GSD across all machines.

**Do NOT install GSD from npm. Use the fork installer.**

## Architecture

```
gsd-build/get-shit-done (upstream)       ← official releases
        ↕ auto-synced daily (GitHub Action)
shootdaj/gsdfr (GitHub)                  ← your fork
        ↕ git push              ↕ install script
~/Code/gsdfr/ (dev)       ~/.claude/ (runtime)
  you work here             installed by bin/install.js
```

- **`~/Anshul/Code/gsdfr/`** — development repo. Make changes here, commit, push.
- **`shootdaj/gsdfr` on GitHub** — your fork. Central distribution point. Auto-syncs upstream daily.
- **`~/.claude/`** — runtime install on each machine. Installed via the official `bin/install.js` from the fork.

## Install (any machine)

```bash
curl -sL https://raw.githubusercontent.com/shootdaj/gsdfr/main/scripts/install.sh | bash
```

This clones the fork to a temp dir, runs the official installer (`bin/install.js --claude --global`), which sets up everything: commands, hooks, agents, settings.json wiring. Same as the official install, just from your fork.

## Update

Inside Claude Code: `/gsd:update`

Or re-run the installer:
```bash
curl -sL https://raw.githubusercontent.com/shootdaj/gsdfr/main/scripts/install.sh | bash
```

Upstream changes are auto-merged into the fork daily via GitHub Action. Updates just pull the latest merged result.

## Development

All changes happen in `~/Anshul/Code/gsdfr/`:

```bash
cd ~/Anshul/Code/gsdfr

# Make changes
vim get-shit-done/workflows/execute-plan.md

# Commit and push
git add -A
git commit -m "feat: description"
git push origin main

# Update local runtime
curl -sL https://raw.githubusercontent.com/shootdaj/gsdfr/main/scripts/install.sh | bash
```

For development on a new machine:
```bash
git clone git@github.com:shootdaj/gsdfr.git ~/Anshul/Code/gsdfr
cd ~/Anshul/Code/gsdfr
git remote add upstream https://github.com/gsd-build/get-shit-done.git
```

## What's Customized

### Active
- **Fork-aware update workflow** (`get-shit-done/workflows/update.md`): Re-runs fork installer instead of npm install.
- **Self-check acceptance criteria re-run** (`get-shit-done/workflows/execute-plan.md`): Re-runs ALL acceptance criteria before finalizing SUMMARY. Upstream PR: gsd-build/get-shit-done#1959.
- **Auto-sync GitHub Action** (`.github/workflows/sync-upstream.yml`): Merges upstream daily at 6:17 UTC.

### Planned
- **Plan expansion pass** (gsd-build/get-shit-done#2006): Post-planner agent that expands shallow task descriptions with full algorithms from project rules.

## Troubleshooting

### Something broke after update
Re-run the installer: `curl -sL ... | bash`

### Hooks not firing
The installer wires `~/.claude/settings.json` automatically. If still broken, check the file manually for `gsd-` hook entries.

### Merge conflict in auto-sync
The GitHub Action will fail. You'll get a notification. Resolve in `~/Anshul/Code/gsdfr`:
```bash
git fetch upstream
git merge upstream/main
# resolve conflicts
git push origin main
```

### Starting completely fresh
```bash
# Re-run installer — it handles backups
curl -sL https://raw.githubusercontent.com/shootdaj/gsdfr/main/scripts/install.sh | bash
```
