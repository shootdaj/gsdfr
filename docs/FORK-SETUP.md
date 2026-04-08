# GSD Fork — shootdaj/gsdfr

Personal fork of [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done). Single source of GSD across all machines.

**Do NOT install GSD from npm. Do NOT edit files in `~/.claude/get-shit-done/` directly.**

## Architecture

```
gsd-build/get-shit-done (upstream)       ← official releases
        ↕ git fetch upstream
shootdaj/gsdfr (GitHub)                  ← your fork
        ↕ git push              ↕ git pull
~/Code/gsdfr/ (dev)       ~/.claude/get-shit-done/ (runtime)
  you work here              never edit directly
```

- **`~/Anshul/Code/gsdfr/`** — development repo. Make changes here, commit, push.
- **`shootdaj/gsdfr` on GitHub** — your fork. Central distribution point.
- **`~/.claude/get-shit-done/`** — runtime install on each machine. Pulls from GitHub. Never edit directly.

## Development Workflow

All changes happen in `~/Anshul/Code/gsdfr/`:

```bash
cd ~/Anshul/Code/gsdfr

# Make changes
vim get-shit-done/workflows/execute-plan.md

# Commit and push
git add -A
git commit -m "feat: description"
git push origin main

# Update the local runtime install
cd ~/.claude/get-shit-done
git pull origin main
```

## Pulling Upstream GSD Updates

From the dev repo:

```bash
cd ~/Anshul/Code/gsdfr
git fetch upstream
git merge upstream/main
git push origin main

# Then update runtime
cd ~/.claude/get-shit-done
git pull origin main
```

Or just use `/gsd:update` inside Claude Code — the fork-aware update workflow handles it.

## Fresh Install (new machine)

```bash
curl -sL https://raw.githubusercontent.com/shootdaj/gsdfr/main/scripts/install-fork.sh | bash
```

This clones the fork to `~/.claude/get-shit-done/`, creates symlinks, installs hooks and agents. Re-running it just does `git pull`.

For development on that machine, also clone the dev copy:
```bash
git clone git@github.com:shootdaj/gsdfr.git ~/Anshul/Code/gsdfr
cd ~/Anshul/Code/gsdfr
git remote add upstream https://github.com/gsd-build/get-shit-done.git
```

## Directory Structure

```
~/.claude/get-shit-done/              ← runtime install (clone of fork)
├── get-shit-done/                    ← runtime files
│   ├── bin/gsd-tools.cjs
│   ├── workflows/
│   ├── templates/
│   └── references/
├── agents/                           ← → copied to ~/.claude/agents/
├── hooks/                            ← → copied to ~/.claude/hooks/
├── bin/gsd-tools.cjs → symlink
├── workflows → symlink
├── templates → symlink
├── references → symlink
└── VERSION → symlink
```

Symlinks bridge the nested repo structure to the flat paths GSD's runtime expects.

## What's Customized

### Active
- **Fork-aware update workflow** (`get-shit-done/workflows/update.md`): Git merge instead of npm install.
- **Self-check acceptance criteria re-run** (`get-shit-done/workflows/execute-plan.md`): Re-runs ALL acceptance criteria before finalizing SUMMARY. Upstream PR: gsd-build/get-shit-done#1959.

### Planned
- **Plan expansion pass** (gsd-build/get-shit-done#2006): Post-planner agent that expands shallow task descriptions with full algorithms from project rules.

## Troubleshooting

### Runtime not picking up changes
```bash
cd ~/.claude/get-shit-done && git pull origin main
```

### Symlinks broken
```bash
cd ~/.claude/get-shit-done
ln -sf get-shit-done/workflows workflows
ln -sf get-shit-done/templates templates
ln -sf get-shit-done/references references
ln -sf get-shit-done/bin/gsd-tools.cjs bin/gsd-tools.cjs
ln -sf get-shit-done/bin/lib bin/lib
ln -sf get-shit-done/VERSION VERSION
```

### Hooks not firing
Check `~/.claude/settings.json` for hook entries. If missing, run the official installer once to wire them, then re-run `install-fork.sh`.

### Starting fresh
```bash
mv ~/.claude/get-shit-done ~/.Trash/
curl -sL https://raw.githubusercontent.com/shootdaj/gsdfr/main/scripts/install-fork.sh | bash
```
