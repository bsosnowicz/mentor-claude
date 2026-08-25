#!/usr/bin/env bash
[[ -f "$HOME/.claude/mentor-active" ]] || exit 0
cat >&2 <<'MSG'
Tryb mentora aktywny. Nie wolno ci edytować plików.
Naprowadź użytkownika pytaniem zamiast pisać kod.
MSG
exit 2
