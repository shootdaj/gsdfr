<purpose>
Check for GSD updates from upstream, show changelog, merge into fork, and update hooks/agents.
This is the fork-aware version — uses git merge instead of npm install to preserve local customizations.
</purpose>

<required_reading>
Read all files referenced by the invoking prompt's execution_context before starting.
</required_reading>

<process>

<step name="get_installed_version">
Read the current installed version:

```bash
cat "$HOME/.claude/get-shit-done/get-shit-done/VERSION" 2>/dev/null || cat "$HOME/.claude/get-shit-done/VERSION" 2>/dev/null || echo "0.0.0"
```
</step>

<step name="check_upstream">
Fetch upstream and check for new commits:

```bash
cd "$HOME/.claude/get-shit-done"
git fetch upstream 2>/dev/null

# Get upstream version
UPSTREAM_VERSION=$(git show upstream/main:get-shit-done/VERSION 2>/dev/null || echo "unknown")
INSTALLED_VERSION=$(cat get-shit-done/VERSION 2>/dev/null || echo "0.0.0")

echo "INSTALLED=$INSTALLED_VERSION"
echo "UPSTREAM=$UPSTREAM_VERSION"

# Count new commits
NEW_COMMITS=$(git rev-list HEAD..upstream/main --count 2>/dev/null || echo "0")
echo "NEW_COMMITS=$NEW_COMMITS"
```

**If NEW_COMMITS == 0:**
```
## GSD Update

**Installed:** X.Y.Z
**Upstream:** X.Y.Z

You're up to date. No new upstream changes.
```
Exit.
</step>

<step name="show_changes_and_confirm">
**If updates available**, show what's new:

```bash
cd "$HOME/.claude/get-shit-done"

# Show upstream changelog diff
git diff HEAD..upstream/main -- CHANGELOG.md 2>/dev/null | grep "^+" | grep -v "^+++" | head -40
```

Display:

```
## GSD Update Available (Fork)

**Installed:** {INSTALLED_VERSION}
**Upstream:** {UPSTREAM_VERSION}
**New commits:** {NEW_COMMITS}

### What's New
────────────────────────────────────────────────────────────
{changelog diff}
────────────────────────────────────────────────────────────

This will merge upstream changes into your fork. Your customizations are preserved.
If there are conflicts, you'll resolve them inline.
```

Use AskUserQuestion:
- Question: "Proceed with update?"
- Options:
  - "Yes, merge upstream"
  - "No, cancel"

**If user cancels:** Exit.
</step>

<step name="merge_upstream">
Merge upstream into fork:

```bash
cd "$HOME/.claude/get-shit-done"
git merge upstream/main -m "merge: upstream GSD $(git show upstream/main:get-shit-done/VERSION)"
```

**If merge succeeds (no conflicts):**
```
✓ Merged upstream successfully.
```

Push to fork:
```bash
git push origin main
```

**If merge has conflicts:**
```
## Merge Conflicts

The following files have conflicts between your customizations and upstream:

{list conflicted files}

Resolve the conflicts, then:
  cd ~/.claude/get-shit-done
  git add -A
  git commit
  git push origin main
```
Exit and let user resolve.
</step>

<step name="update_hooks_and_agents">
After successful merge, check if hooks or agents need updating:

```bash
cd "$HOME/.claude/get-shit-done"

# Compare repo hooks with installed hooks
for hook in hooks/gsd-*.js; do
  BASENAME=$(basename "$hook")
  INSTALLED="$HOME/.claude/hooks/$BASENAME"
  if [ -f "$INSTALLED" ]; then
    if ! diff -q "$hook" "$INSTALLED" > /dev/null 2>&1; then
      echo "STALE_HOOK: $BASENAME"
      cp "$hook" "$INSTALLED"
      echo "UPDATED: $BASENAME"
    fi
  fi
done

# Compare repo agents with installed agents
for agent in agents/gsd-*.md; do
  BASENAME=$(basename "$agent")
  INSTALLED="$HOME/.claude/agents/$BASENAME"
  if [ -f "$INSTALLED" ]; then
    if ! diff -q "$agent" "$INSTALLED" > /dev/null 2>&1; then
      echo "STALE_AGENT: $BASENAME"
      cp "$agent" "$INSTALLED"
      echo "UPDATED: $BASENAME"
    fi
  fi
done
```

Report what was updated.
</step>

<step name="clear_cache">
Clear update cache so the session hook doesn't re-prompt:

```bash
rm -f "$HOME/.claude/cache/gsd-update-check.json"
```
</step>

<step name="report">
```
## GSD Update Complete (Fork)

**Previous:** {INSTALLED_VERSION}
**Updated to:** {UPSTREAM_VERSION}
**Commits merged:** {NEW_COMMITS}
**Hooks updated:** {list or "none"}
**Agents updated:** {list or "none"}

Your customizations are preserved. Changes pushed to shootdaj/gsdfr.
```
</step>

</process>
