# claude-mentor

Przełączalny tryb mentora programowania dla Claude Code — blokuje edycję plików, gdy jest aktywny, i prowadzi przez `/plan`, `/sprawdz` oraz pytania w trakcie zamiast pisać kod za ciebie.

## Instalacja na nowej maszynie

Sklonuj to repo i uruchom `./install.sh` — utworzy symlinki w `~/.claude/` (hooks, skill `mentor`, komendy) i doda blok `hooks` z `settings-hooks.json` do istniejącego `~/.claude/settings.json`, scalając go z tym, co już tam jest.

## Komendy

- `/mentor-on` — włącza tryb mentora (blokuje Edit/Write/NotebookEdit) i pyta, nad czym dziś pracujesz.
- `/mentor-off` — wyłącza tryb mentora.
- `/plan` — tryb ustalania planu przed kodem.
- `/sprawdz` — tryb code review na `git diff` po napisaniu kodu.
- `/pytanie` — pytanie w trakcie pracy, odpowiedź konceptem, nie kodem.

## Wymagania

`bash`, `python3` (do scalania JSON w `install.sh`; używa `jq`, jeśli jest dostępne).
