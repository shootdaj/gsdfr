# GSD Fork Setup

This is a personal fork of [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done) with custom modifications.

## How It Works

```
gsd-build/get-shit-done (upstream)    ← official GSD releases
        ↕ git fetch upstream
shootdaj/gsdfr (origin)               ← your fork on GitHub
        ↕ git pull / git push
~/.claude/get-shit-done (local)       ← what Claude Code actually uses
```

GSD reads files from `~/.claude/get-shit-done/`. Hooks in `~/.claude/settings.json` and agents in `~/.claude/agents/` reference paths inside this directory. The fork replaces the official install with a git-managed version.

## Directory Structure

The upstream repo has a nested structure — runtime files live in `get-shit-done/` subdirectory:

```
~/.claude/get-shit-done/
├── get-shit-done/          ← actual runtime files
│   ├── bin/gsd-tools.cjs
│   ├── workflows/
│   ├── templates/
│   └── references/
├── agents/                 ← agent definitions (installed to ~/.claude/agents/)
├── hooks/                  ← hook scripts (installed to ~/.claude/hooks/)
├── bin/
│   ├── install.js          ← official installer
│   ├── gsd-tools.cjs → ../get-shit-done/bin/gsd-tools.cjs  ← symlink
│   └── lib → ../get-shit-done/bin/lib                       ← symlink
├── workflows → get-shit-done/workflows                      ← symlink
├── templates → get-shit-done/templates                      ← symlink
├── references → get-shit-done/references                    ← symlink
└── VERSION → get-shit-done/VERSION                          ← symlink
```

The symlinks at the root level exist because hooks and workflows reference paths like `~/.claude/get-shit-done/bin/gsd-tools.cjs` (root level), but the repo stores them at `get-shit-done/bin/gsd-tools.cjs` (nested). Symlinks bridge the two.

## Pulling Upstream Updates

```bash
cd ~/.claude/get-shit-done
git fetch upstream
git merge upstream/main
git push origin main
```

If there are conflicts (your changes vs upstream), resolve them normally. Your customizations are commits on `main` — they merge cleanly as long as you're not modifying the same lines upstream changed.

## Making Custom Changes

```bash
cd ~/.claude/get-shit-done

# Edit the file (runtime files are in get-shit-done/ subdirectory)
vim get-shit-done/workflows/execute-plan.md

# Commit and push
git add -A
git commit -m "feat: description of change"
git push origin main
```

Changes take effect immediately — Claude Code reads from these files on every invocation.

## What's Customized

Track all customizations here so you know what to watch for during upstream merges:

### Active Customizations
- **Self-check acceptance criteria re-run** (`get-shit-done/workflows/execute-plan.md`): Self-check step re-runs ALL `<acceptance_criteria>` from every task and plan-level `<verification>` commands before finalizing SUMMARY. Upstream PR: gsd-build/get-shit-done#1959.

### Planned Customizations
- **Plan expansion pass** (gsd-build/get-shit-done#2006): Post-planner agent that cross-references task actions against project rules and expands shallow descriptions with full algorithms.

## Reinstalling After Problems

If something breaks, restore from the official installer:

```bash
# Remove the fork
mv ~/.claude/get-shit-done ~/.Trash/

# Reinstall official
npx gsd-install  # or whatever the official install command is

# Then re-clone your fork on top
mv ~/.claude/get-shit-done ~/.claude/get-shit-done-official
git clone git@github.com:shootdaj/gsdfr.git ~/.claude/get-shit-done

# Re-create symlinks
cd ~/.claude/get-shit-done
ln -sf get-shit-done/workflows workflows
ln -sf get-shit-done/templates templates
ln -sf get-shit-done/references references
ln -sf get-shit-done/bin/gsd-tools.cjs bin/gsd-tools.cjs
ln -sf get-shit-done/bin/lib bin/lib
ln -sf get-shit-done/VERSION VERSION
```

## Hooks and Agents

Hooks (`~/.claude/hooks/gsd-*.js`) and agents (`~/.claude/agents/gsd-*.md`) are separate files installed outside the `get-shit-done/` directory. They're updated by the official GSD installer, not by git pulls. If upstream adds new hooks/agents, you may need to run the installer once to pick them up, then re-link the fork.
