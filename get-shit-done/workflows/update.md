<purpose>
Update GSD by re-running the installer.
</purpose>

<process>

<step name="update">
Re-run the installer:

```bash
BEFORE=$(cat "$HOME/.claude/get-shit-done/VERSION" 2>/dev/null || echo "0.0.0")
curl -sL https://raw.githubusercontent.com/shootdaj/gsdfr/main/scripts/install.sh | bash
AFTER=$(cat "$HOME/.claude/get-shit-done/VERSION" 2>/dev/null || echo "0.0.0")
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

Updated from latest.
```
</step>

</process>
