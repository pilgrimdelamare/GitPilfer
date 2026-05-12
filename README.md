# GitPilfer

Structured session system for Claude Code.

Allows Claude Code to:
- resume work across sessions without losing context
- reuse code from GitHub instead of writing from scratch
- track project state with compact, readable status codes

---

## How it works

```
CLAUDE.md          ← project context + current status code
.claude/
  CLAUDE.*.md      ← mini-CLAUDEs: operational workflows (one per task type)
  session.json     ← machine state (synced with CLAUDE.md)
  scripts/
    setup.sh       ← installs GitPilfer into an existing project
    resume.sh      ← prints the resume context
    checkpoint.sh  ← updates session.json + status code in CLAUDE.md
docs/
  stato-codici.md  ← status code format dictionary
  mini-claude.md   ← how to create custom mini-CLAUDEs
snippets/
  index.json       ← reusable snippet cache
  add-snippet.sh   ← adds a snippet to the cache
  mark-tested.sh   ← marks a snippet as tested
```

---

## Install into an existing project

```bash
# Clone GitPilfer
git clone https://github.com/pilgrimdelamare/GitPilfer.git

# Install into your project
bash GitPilfer/.claude/scripts/setup.sh /path/to/your-project
```

Then fill in `CLAUDE.md` with your project context.

---

## Resume a session

```bash
bash .claude/scripts/resume.sh
```

Prints: status code, current step, task, active mini-CLAUDE.

---

## Save a checkpoint

```bash
bash .claude/scripts/checkpoint.sh "ST:F2/5:setup-sh"
bash .claude/scripts/checkpoint.sh "ST:X1/1:readme" "fix applied"
```

Updates `session.json` and the status code in `CLAUDE.md`.

---

## Status code format

```
ST:<type><step>/<total>:<task>
```

| Type | Meaning  |
|------|----------|
| `F`  | Feature  |
| `X`  | Fix      |
| `R`  | Refactor |

Examples: `ST:F2/5:setup-sh` — `ST:X1/1:readme` — `ST:R3/4:scripts`

See `docs/stato-codici.md` for the full reference.

---

## Requirements

- `bash`
- `python3` / `python` (stdlib: json, re, sys) — auto-detected
- `git`
- `curl`
- `gh` (GitHub CLI) — optional, for snippet search on GitHub

Zero npm/pip dependencies. Works on any Unix machine with bash.

---

## License

MIT

---

---

# GitPilfer — Italiano

Sistema di sessioni strutturate per Claude Code.

Permette a Claude Code di:
- riprendere il lavoro tra sessioni senza perdere contesto
- riciclare codice da GitHub invece di scriverlo da zero
- mantenere lo stato del progetto in forma compatta e leggibile

---

## Come funziona

```
CLAUDE.md          ← contesto progetto + codice stato corrente
.claude/
  CLAUDE.*.md      ← mini-CLAUDE: workflow operativi (uno per tipo di task)
  session.json     ← stato macchina (sincronizzato con CLAUDE.md)
  scripts/
    setup.sh       ← installa GitPilfer in un progetto esistente
    resume.sh      ← stampa il contesto di ripresa
    checkpoint.sh  ← aggiorna session.json + codice stato in CLAUDE.md
docs/
  stato-codici.md  ← dizionario formato codici stato
  mini-claude.md   ← come creare mini-CLAUDE custom
snippets/
  index.json       ← cache snippet riutilizzabili
  add-snippet.sh   ← aggiunge uno snippet alla cache
  mark-tested.sh   ← marca uno snippet come testato
```

---

## Installazione in un progetto esistente

```bash
# Clona GitPilfer
git clone https://github.com/pilgrimdelamare/GitPilfer.git

# Installa nel tuo progetto
bash GitPilfer/.claude/scripts/setup.sh /percorso/tuo-progetto
```

Poi compila `CLAUDE.md` con il contesto del tuo progetto.

---

## Riprendere una sessione

```bash
bash .claude/scripts/resume.sh
```

Stampa: codice stato, step corrente, task, mini-CLAUDE attivo.

---

## Salvare un checkpoint

```bash
bash .claude/scripts/checkpoint.sh "ST:F2/5:setup-sh"
bash .claude/scripts/checkpoint.sh "ST:X1/1:readme" "fix applicato"
```

Aggiorna `session.json` e il codice stato in `CLAUDE.md`.

---

## Formato codice stato

```
ST:<tipo><step>/<totale>:<task>
```

| Tipo | Significato |
|------|-------------|
| `F`  | Feature     |
| `X`  | Fix         |
| `R`  | Refactor    |

Esempi: `ST:F2/5:setup-sh` — `ST:X1/1:readme` — `ST:R3/4:scripts`

Vedi `docs/stato-codici.md` per il dizionario completo.

---

## Requisiti

- `bash`
- `python3` / `python` (stdlib: json, re, sys) — rilevato automaticamente
- `git`
- `curl`
- `gh` (GitHub CLI) — opzionale, per la ricerca snippet su GitHub

Zero dipendenze npm/pip. Funziona su qualsiasi macchina Unix con bash.

---

## Licenza

MIT
