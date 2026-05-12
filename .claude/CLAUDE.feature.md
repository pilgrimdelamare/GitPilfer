# CLAUDE.feature.md — Workflow: nuova feature

> Mini-CLAUDE operativo. Contiene SOLO il workflow, zero contesto progetto.
> Il contesto sta in CLAUDE.md. Non sovrapporre.

---

## Sanity check (PRIMA di iniziare)

Rileggi CLAUDE.md sezione 1 e verifica:
- [ ] Il task pianificato è coerente con obiettivo e vincoli del progetto
- [ ] Non si introducono dipendenze non approvate
- [ ] Il naming segue le convenzioni (kebab-case, lingua italiana per doc)

---

## Workflow CERCA → ADATTA → SCRIVI

### 1. CERCA (prima di scrivere codice da zero)

Cerca snippet riutilizzabili nella cache locale:
```bash
cat snippets/index.json
```

Se non trovi nulla di utile, cerca su GitHub:
```bash
# Pattern di ricerca consigliati
gh search code "<keyword>" --language=bash --limit=5
gh search repos "<keyword>" --language=shell --sort=stars --limit=5
```

Criteri di selezione snippet da GitHub:
- Licenza compatibile (MIT, Apache, public domain)
- Ultima modifica < 2 anni
- Testato (stelle, fork, issues attive)

### 2. ADATTA

Prima di usare codice esterno:
- [ ] Verifica che rispetti le convenzioni del progetto (set -euo pipefail, $HOME invece di ~)
- [ ] Rimuovi parti non necessarie
- [ ] Aggiungi commento di intestazione in italiano
- [ ] Aggiungi alla cache se riutilizzabile: `bash snippets/add-snippet.sh`

### 3. SCRIVI

Solo se non esiste nulla di adattabile:
- Scrivi da zero rispettando le convenzioni in CLAUDE.md
- Patch chirurgica: tocca solo i file necessari
- Backup prima di modificare file esistenti:
  ```bash
  cp <file> <file>.bak.$(date +%Y%m%d%H%M%S)
  ```

---

## Checkpoint

Dopo ogni task completato:
```bash
bash .claude/scripts/checkpoint.sh "ST:F<step>/<tot>:<task>"
```

---

## Definizione di "done"

- [ ] Script eseguibile (`chmod +x`)
- [ ] Testato in locale con caso base e caso di errore
- [ ] Commento di intestazione presente
- [ ] `set -euo pipefail` nella prima riga dopo shebang
- [ ] Nessun `~` nei path — solo `$HOME`
- [ ] Checkpoint salvato
