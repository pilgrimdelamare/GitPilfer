#!/usr/bin/env bash
# setup.sh — installa la struttura GitPilfer in un progetto esistente.
# Uso: bash setup.sh [percorso_progetto]
# Se percorso_progetto è omesso, usa la directory corrente.

set -euo pipefail

PROGETTO="${1:-$(pwd)}"
GITPILFER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Verifica che la directory target esista
if [[ ! -d "$PROGETTO" ]]; then
  echo "Errore: directory '$PROGETTO' non trovata." >&2
  exit 1
fi

echo "==> Installazione GitPilfer in: $PROGETTO"

# Crea struttura .claude/
mkdir -p "$PROGETTO/.claude/scripts"
mkdir -p "$PROGETTO/docs"
mkdir -p "$PROGETTO/snippets"

# Copia i mini-CLAUDE (template workflow)
for f in CLAUDE.feature.md CLAUDE.fix.md CLAUDE.refactor.md; do
  if [[ -f "$GITPILFER_DIR/.claude/$f" ]]; then
    cp "$GITPILFER_DIR/.claude/$f" "$PROGETTO/.claude/$f"
    echo "    copiato: .claude/$f"
  fi
done

# Copia gli script operativi
for s in resume.sh checkpoint.sh; do
  if [[ -f "$GITPILFER_DIR/.claude/scripts/$s" ]]; then
    cp "$GITPILFER_DIR/.claude/scripts/$s" "$PROGETTO/.claude/scripts/$s"
    chmod +x "$PROGETTO/.claude/scripts/$s"
    echo "    copiato: .claude/scripts/$s"
  fi
done

# Inizializza session.json se non esiste già
SESSION="$PROGETTO/.claude/session.json"
if [[ ! -f "$SESSION" ]]; then
  TIMESTAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  cat > "$SESSION" <<JSON
{
  "version": "1.0",
  "progetto": "$(basename "$PROGETTO")",
  "stato": {
    "codice": "ST:F0/1:init",
    "tipo": "F",
    "step": 0,
    "totale": 1,
    "task": "init"
  },
  "task_list": [],
  "mini_claude_attivo": ".claude/CLAUDE.feature.md",
  "ultimo_aggiornamento": "$TIMESTAMP",
  "note": ""
}
JSON
  echo "    creato: .claude/session.json"
fi

# Inizializza snippets/index.json se non esiste
SNIPPET_IDX="$PROGETTO/snippets/index.json"
if [[ ! -f "$SNIPPET_IDX" ]]; then
  echo '{"snippets": []}' > "$SNIPPET_IDX"
  echo "    creato: snippets/index.json"
fi

# Copia gli script snippets
for s in add-snippet.sh mark-tested.sh; do
  if [[ -f "$GITPILFER_DIR/snippets/$s" ]]; then
    cp "$GITPILFER_DIR/snippets/$s" "$PROGETTO/snippets/$s"
    chmod +x "$PROGETTO/snippets/$s"
    echo "    copiato: snippets/$s"
  fi
done

# Copia CLAUDE.md template se non esiste già nel progetto
if [[ ! -f "$PROGETTO/CLAUDE.md" ]]; then
  cp "$GITPILFER_DIR/CLAUDE.md" "$PROGETTO/CLAUDE.md"
  echo "    copiato: CLAUDE.md (da compilare)"
fi

echo ""
echo "==> GitPilfer installato con successo."
echo "    Prossimo passo: compila CLAUDE.md con il contesto del tuo progetto."
echo "    Poi esegui: bash .claude/scripts/resume.sh"
