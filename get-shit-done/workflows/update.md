<purpose>
Pull latest GSD from fork and update hooks/agents.
Upstream sync happens automatically via GitHub Action — this just pulls the result.
</purpose>

<process>

<step name="pull">
Pull latest from fork:

```bash
cd "$HOME/.claude/get-shit-done"
BEFORE=$(cat get-shit-done/VERSION 2>/dev/null || echo "0.0.0")
git pull origin main 2>&1
AFTER=$(cat get-shit-done/VERSION 2>/dev/null || echo "0.0.0")
```

**If pull fails:**
```
Pull failed. Check your network or SSH keys.
```
Exit.
</step>

<step name="update_hooks_and_agents">
Copy any changed hooks and agents:

```bash
cd "$HOME/.claude/get-shit-done"

UPDATED_HOOKS=""
for hook in hooks/gsd-*.js; do
  [ -f "$hook" ] || continue
  BASENAME=$(basename "$hook")
  INSTALLED="$HOME/.claude/hooks/$BASENAME"
  if [ ! -f "$INSTALLED" ] || ! diff -q "$hook" "$INSTALLED" > /dev/null 2>&1; then
    cp "$hook" "$INSTALLED"
    UPDATED_HOOKS="$UPDATED_HOOKS $BASENAME"
  fi
done

UPDATED_AGENTS=""
for agent in agents/gsd-*.md; do
  [ -f "$agent" ] || continue
  BASENAME=$(basename "$agent")
  INSTALLED="$HOME/.claude/agents/$BASENAME"
  if [ ! -f "$INSTALLED" ] || ! diff -q "$agent" "$INSTALLED" > /dev/null 2>&1; then
    cp "$agent" "$INSTALLED"
    UPDATED_AGENTS="$UPDATED_AGENTS $BASENAME"
  fi
done
```
</step>

<step name="clear_cache">
```bash
rm -f "$HOME/.claude/cache/gsd-update-check.json"
```
</step>

<step name="report">
```
## GSD Updated

**Before:** {BEFORE}
**After:** {AFTER}
**Hooks updated:** {UPDATED_HOOKS or "none"}
**Agents updated:** {UPDATED_AGENTS or "none"}

Source: shootdaj/gsdfr (upstream auto-synced daily)
```
</step>

</process>
