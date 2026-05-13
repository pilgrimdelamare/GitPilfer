# GitPilfer

A Claude Code skill that searches GitHub for existing solutions before writing code from scratch, and maintains session state across conversations.

What it does:
- Searches GitHub for reusable code before starting any feature task
- Saves session state after each task with a compact status code (e.g. `ST:F2/5:rate-limiter`)
- Resumes work between sessions without losing context
- Creates task-specific workflow files (mini-CLAUDEs) on first run in a project

## Benchmark

Same project, built with and without GitPilfer:

| | With GitPilfer | Without |
|---|---|---|
| User messages | 3 | 12 |
| Tokens used | ~12k | ~20k |

**75% fewer messages. 40% fewer tokens.**
See [PriceWatch](https://github.com/pilgrimdelamare/pricewatch) — a real project built with GitPilfer in 3 messages.

---

## Install

### Claude Code

```bash
git clone https://github.com/pilgrimdelamare/GitPilfer.git
cp -r GitPilfer/gitpilfer ~/.claude/skills/
```

GitPilfer activates automatically in every Claude Code session on any project.

### Windsurf — global (all projects)

Open **Settings → Cascade → Global Rules** and paste the content of `gitpilfer/SKILL.md`.

### Windsurf — single project

Create a `.windsurfrules` file in the project root:

```bash
git clone https://github.com/pilgrimdelamare/GitPilfer.git
cat GitPilfer/gitpilfer/SKILL.md > /path/to/your-project/.windsurfrules
```

---

## Set up a new project

1. Copy `CLAUDE.md` from this repo into the root of your project
2. Fill in the sections:

```markdown
## Obiettivo
One sentence describing what the project does.

## Stack
- Linguaggio: Python
- Framework: FastAPI
- DB: PostgreSQL

## File chiave
- `src/main.py`: entry point
- `src/models.py`: data models

## Codice stato
`ST:F0/0:init`

## Stato attuale
**Ultimo punto fermo:** —
**Prossimo task:** —

## Note specifiche
- 2025-05-13: decided against using SQLAlchemy, too heavy
```

3. Start a Claude Code session — GitPilfer will initialize automatically.

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

Examples:
- `ST:F2/5:rate-limiter` — feature, step 2 of 5, working on rate limiter
- `ST:X1/1:crash-auth` — fix, step 1 of 1, auth crash
- `ST:R3/4:cleanup` — refactor, step 3 of 4, cleanup

---

## Requirements

- `bash`
- `curl`
- `gh` (GitHub CLI) — optional, falls back to `curl` against the public GitHub API

Zero npm/pip dependencies. Works on any Unix machine with bash.

---

## License

MIT

---

---

# GitPilfer — Italiano

Una skill per Claude Code che cerca su GitHub soluzioni esistenti prima di scrivere codice da zero, e mantiene lo stato della sessione tra conversazioni.

Cosa fa:
- Cerca su GitHub codice riutilizzabile prima di iniziare qualsiasi task di tipo feature
- Salva lo stato dopo ogni task con un codice compatto (es. `ST:F2/5:rate-limiter`)
- Riprende il lavoro tra sessioni senza perdere contesto
- Crea file di workflow specifici per tipo di task (mini-CLAUDE) al primo avvio in un progetto

## Benchmark

Stesso progetto, costruito con e senza GitPilfer:

| | Con GitPilfer | Senza |
|---|---|---|
| Messaggi utente | 3 | 12 |
| Token usati | ~12k | ~20k |

**75% di messaggi in meno. 40% di token in meno.**
Vedi [PriceWatch](https://github.com/pilgrimdelamare/pricewatch) — un progetto reale costruito con GitPilfer in 3 messaggi.

---

## Installazione

### Claude Code

```bash
git clone https://github.com/pilgrimdelamare/GitPilfer.git
cp -r GitPilfer/gitpilfer ~/.claude/skills/
```

GitPilfer si attiva automaticamente in ogni sessione di Claude Code su qualsiasi progetto.

### Windsurf — globale (tutti i progetti)

Apri **Settings → Cascade → Global Rules** e incolla il contenuto di `gitpilfer/SKILL.md`.

### Windsurf — singolo progetto

Crea un file `.windsurfrules` nella root del progetto:

```bash
git clone https://github.com/pilgrimdelamare/GitPilfer.git
cat GitPilfer/gitpilfer/SKILL.md > /percorso/tuo-progetto/.windsurfrules
```

---

## Configurare un nuovo progetto

1. Copia `CLAUDE.md` da questo repo nella root del tuo progetto
2. Compila le sezioni:

```markdown
## Obiettivo
Una frase che descrive cosa fa il progetto.

## Stack
- Linguaggio: Python
- Framework: FastAPI
- DB: PostgreSQL

## File chiave
- `src/main.py`: entry point
- `src/models.py`: modelli dati

## Codice stato
`ST:F0/0:init`

## Stato attuale
**Ultimo punto fermo:** —
**Prossimo task:** —

## Note specifiche
- 2025-05-13: scelta di non usare SQLAlchemy, troppo pesante
```

3. Avvia una sessione Claude Code — GitPilfer si inizializza automaticamente.

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

Esempi:
- `ST:F2/5:rate-limiter` — feature, step 2 di 5, task: rate-limiter
- `ST:X1/1:crash-auth` — fix, step 1 di 1, crash auth
- `ST:R3/4:cleanup` — refactor, step 3 di 4, cleanup

---

## Requisiti

- `bash`
- `curl`
- `gh` (GitHub CLI) — opzionale, fallback su `curl` contro l'API pubblica GitHub

Zero dipendenze npm/pip. Funziona su qualsiasi macchina Unix con bash.

---

## Licenza

MIT
