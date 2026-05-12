#!/usr/bin/env bash
# checkpoint.sh — aggiorna session.json e il codice stato in CLAUDE.md.
# Uso: bash .claude/scripts/checkpoint.sh "ST:F<step>/<tot>:<task>" [note]
#
# Esempi:
#   bash .claude/scripts/checkpoint.sh "ST:F2/5:setup-sh"
#   bash .claude/scripts/checkpoint.sh "ST:X1/1:readme" "fix applicato, testato ok"

set -euo pipefail

CODICE="${1:-}"
NOTE="${2:-}"

if [[ -z "$CODICE" ]]; then
  echo "Uso: checkpoint.sh \"ST:<tipo><step>/<tot>:<task>\" [note]" >&2
  exit 1
fi

# Valida formato codice stato
if ! echo "$CODICE" | grep -qE '^ST:[FXR][0-9]+/[0-9]+:.+$'; then
  echo "Errore: formato codice non valido. Atteso: ST:<F|X|R><step>/<tot>:<task>" >&2
  exit 1
fi

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$SCRIPTS_DIR/.."
PROGETTO_DIR="$CLAUDE_DIR/.."
SESSION="$CLAUDE_DIR/session.json"
CLAUDE_MD="$PROGETTO_DIR/CLAUDE.md"

# Verifica esistenza file
if [[ ! -f "$SESSION" ]]; then
  echo "Errore: $SESSION non trovato." >&2
  exit 1
fi
if [[ ! -f "$CLAUDE_MD" ]]; then
  echo "Errore: $CLAUDE_MD non trovato." >&2
  exit 1
fi

TIMESTAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

# Aggiorna session.json via python3
python3 - "$SESSION" "$CODICE" "$NOTE" "$TIMESTAMP" <<'PYEOF'
import json, sys, re

session_path, codice, note, timestamp = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]

# Parsa il codice stato
m = re.match(r'^ST:([FXR])(\d+)/(\d+):(.+)$', codice)
if not m:
    print("Errore nel parsing del codice stato.", file=sys.stderr)
    sys.exit(1)

tipo, step, totale, task = m.group(1), int(m.group(2)), int(m.group(3)), m.group(4)

with open(session_path) as f:
    s = json.load(f)

s["stato"]["codice"]  = codice
s["stato"]["tipo"]    = tipo
s["stato"]["step"]    = step
s["stato"]["totale"]  = totale
s["stato"]["task"]    = task
s["ultimo_aggiornamento"] = timestamp
if note:
    s["note"] = note

# Aggiorna status nella task_list se il task corrisponde a un nome
for t in s.get("task_list", []):
    if t.get("nome", "").replace(" ", "-").lower() == task.lower():
        t["status"] = "in_progress"

with open(session_path, "w") as f:
    json.dump(s, f, indent=2, ensure_ascii=False)

print(f"session.json aggiornato: {codice}")
PYEOF

# Aggiorna la riga "Codice stato:" in CLAUDE.md
if grep -q "^\*\*Codice stato:\*\*" "$CLAUDE_MD"; then
  # Su macOS sed richiede '' dopo -i, su Linux non serve — usiamo python3 per portabilità
  python3 - "$CLAUDE_MD" "$CODICE" <<'PYEOF'
import sys, re

path, codice = sys.argv[1], sys.argv[2]

with open(path) as f:
    content = f.read()

content = re.sub(
    r'(\*\*Codice stato:\*\*\s*)(`[^`]*`)',
    f'\\1`{codice}`',
    content
)

with open(path, "w") as f:
    f.write(content)

print(f"CLAUDE.md aggiornato: codice stato -> {codice}")
PYEOF
else
  echo "Attenzione: riga 'Codice stato' non trovata in CLAUDE.md — aggiorna manualmente." >&2
fi

echo "Checkpoint salvato: $CODICE @ $TIMESTAMP"
