#!/usr/bin/env bash
# add-snippet.sh — aggiunge uno snippet alla cache locale snippets/index.json
# Uso: bash snippets/add-snippet.sh --id <id> --file <percorso> --desc <descrizione> [--tags tag1,tag2] [--source <url>]

set -euo pipefail

SNIPPETS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INDEX="$SNIPPETS_DIR/index.json"

ID=""
FILE=""
DESC=""
TAGS=""
SOURCE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --id)     ID="$2";     shift 2 ;;
    --file)   FILE="$2";   shift 2 ;;
    --desc)   DESC="$2";   shift 2 ;;
    --tags)   TAGS="$2";   shift 2 ;;
    --source) SOURCE="$2"; shift 2 ;;
    *) echo "Argomento sconosciuto: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$ID" || -z "$FILE" || -z "$DESC" ]]; then
  echo "Uso: add-snippet.sh --id <id> --file <percorso> --desc <descrizione> [--tags tag1,tag2] [--source <url>]" >&2
  exit 1
fi

if [[ ! -f "$FILE" ]]; then
  echo "Errore: file '$FILE' non trovato." >&2
  exit 1
fi

TIMESTAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

# Individua il binario Python 3 disponibile (compatibile Windows e Unix)
PYTHON=""
for _py in python3 python py; do
  if command -v "$_py" &>/dev/null && "$_py" -c "import sys; assert sys.version_info[0]>=3" 2>/dev/null; then
    PYTHON="$_py"
    break
  fi
done
[[ -n "$PYTHON" ]] || { echo "Errore: Python 3 non trovato." >&2; exit 1; }

$PYTHON - "$INDEX" "$ID" "$FILE" "$DESC" "$TAGS" "$SOURCE" "$TIMESTAMP" <<'PYEOF'
import json, sys

index_path, snip_id, file_path, desc, tags_str, source, timestamp = sys.argv[1:]

with open(index_path) as f:
    idx = json.load(f)

if any(s.get("id") == snip_id for s in idx["snippets"]):
    print(f"Errore: snippet con id '{snip_id}' già presente.", file=sys.stderr)
    sys.exit(1)

tags = [t.strip() for t in tags_str.split(",") if t.strip()] if tags_str else []

idx["snippets"].append({
    "id":       snip_id,
    "file":     file_path,
    "desc":     desc,
    "tags":     tags,
    "source":   source,
    "tested":   False,
    "aggiunto": timestamp
})

with open(index_path, "w") as f:
    json.dump(idx, f, indent=2, ensure_ascii=False)

print(f"Snippet '{snip_id}' aggiunto a index.json")
PYEOF
