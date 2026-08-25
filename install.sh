#!/usr/bin/env bash
# Instaluje claude-mentor na tej maszynie: symlinkuje hooki/skill/komendy do
# ~/.claude/ i scala settings-hooks.json z istniejącym ~/.claude/settings.json.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

mkdir -p "$CLAUDE_DIR/hooks" "$CLAUDE_DIR/skills" "$CLAUDE_DIR/commands"
chmod +x "$REPO_DIR/hooks/mentor-guard.sh"

link() {
  local src="$1" dst="$2"
  if [[ -L "$dst" ]]; then
    rm -f "$dst"
  elif [[ -e "$dst" ]]; then
    echo "UWAGA: $dst już istnieje i nie jest symlinkiem — pomijam, sprawdź ręcznie." >&2
    return
  fi
  ln -s "$src" "$dst"
  echo "symlink: $dst -> $src"
}

link "$REPO_DIR/hooks/mentor-guard.sh" "$CLAUDE_DIR/hooks/mentor-guard.sh"
link "$REPO_DIR/skills/mentor" "$CLAUDE_DIR/skills/mentor"

for f in "$REPO_DIR"/commands/*.md; do
  link "$f" "$CLAUDE_DIR/commands/$(basename "$f")"
done

# Scal blok hooks z settings-hooks.json do istniejącego settings.json, bez nadpisywania.
SETTINGS="$CLAUDE_DIR/settings.json"
HOOKS_BLOCK="$REPO_DIR/settings-hooks.json"

python3 - "$SETTINGS" "$HOOKS_BLOCK" <<'PYEOF'
import json, sys, os

settings_path, hooks_path = sys.argv[1], sys.argv[2]

settings = {}
if os.path.exists(settings_path) and os.path.getsize(settings_path) > 0:
    with open(settings_path) as f:
        settings = json.load(f)

with open(hooks_path) as f:
    new_hooks = json.load(f)["hooks"]

settings.setdefault("hooks", {})

for event, entries in new_hooks.items():
    existing_entries = settings["hooks"].setdefault(event, [])
    for entry in entries:
        matcher = entry.get("matcher")
        target = next((e for e in existing_entries if e.get("matcher") == matcher), None)
        if target is None:
            existing_entries.append(entry)
            continue
        target.setdefault("hooks", [])
        for h in entry.get("hooks", []):
            if h not in target["hooks"]:
                target["hooks"].append(h)

with open(settings_path, "w") as f:
    json.dump(settings, f, indent=2, ensure_ascii=False)
    f.write("\n")

print(f"settings.json zaktualizowany: {settings_path}")
PYEOF

echo "Gotowe. Włącz mentora komendą /mentor-on, wyłącz przez /mentor-off."
