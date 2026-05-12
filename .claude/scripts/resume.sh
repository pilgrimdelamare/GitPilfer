#!/usr/bin/env bash
# resume.sh — legge session.json e stampa il contesto di ripresa per Claude Code.
# Uso: bash .claude/scripts/resume.sh

set -euo pipefail

SESSION="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../session.json"

if [[ ! -f "$SESSION" ]]; then
  echo "Errore: session.json non trovato in $(dirname "$SESSION")" >&2
  exit 1
fi

# Estrai i campi con python3 (stdlib, zero dipendenze)
python3 - "$SESSION" <<'PYEOF'
import json, sys

with open(sys.argv[1]) as f:
    s = json.load(f)

stato = s.get("stato", {})
tasks = s.get("task_list", [])
mini  = s.get("mini_claude_attivo", "n/d")
note  = s.get("note", "").strip()

print("=" * 50)
print(f"  RIPRESA SESSIONE — {s.get('progetto', '?')}")
print("=" * 50)
print(f"  Codice stato : {stato.get('codice', '?')}")
print(f"  Step         : {stato.get('step', '?')} / {stato.get('totale', '?')}")
print(f"  Task corrente: {stato.get('task', '?')}")
print(f"  Mini-CLAUDE  : {mini}")
print(f"  Aggiornato   : {s.get('ultimo_aggiornamento', '?')}")

if tasks:
    print()
    print("  Task list:")
    for t in tasks:
        simbolo = "[x]" if t.get("status") == "done" else "[ ]"
        print(f"    {simbolo} {t.get('id','?')}. {t.get('nome','?')}  [{t.get('status','?')}]")

if note:
    print()
    print(f"  Note: {note}")

print("=" * 50)
PYEOF
