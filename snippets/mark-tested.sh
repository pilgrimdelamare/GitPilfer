#!/usr/bin/env bash
# mark-tested.sh — marca uno snippet come testato in snippets/index.json
# Uso: bash snippets/mark-tested.sh <snippet-id>

set -euo pipefail

SNIPPETS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INDEX="$SNIPPETS_DIR/index.json"
ID="${1:-}"

if [[ -z "$ID" ]]; then
  echo "Uso: mark-tested.sh <snippet-id>" >&2
  exit 1
fi

python3 - "$INDEX" "$ID" <<'PYEOF'
import json, sys

index_path, snip_id = sys.argv[1], sys.argv[2]

with open(index_path) as f:
    idx = json.load(f)

trovato = False
for s in idx["snippets"]:
    if s.get("id") == snip_id:
        s["tested"] = True
        trovato = True
        break

if not trovato:
    print(f"Errore: snippet '{snip_id}' non trovato.", file=sys.stderr)
    sys.exit(1)

with open(index_path, "w") as f:
    json.dump(idx, f, indent=2, ensure_ascii=False)

print(f"Snippet '{snip_id}' marcato come testato.")
PYEOF
