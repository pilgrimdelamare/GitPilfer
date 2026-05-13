---
name: GitPilfer
description: Prima di scrivere codice, cerca su GitHub se esiste gia una soluzione. Gestisce stato sessione, mini-CLAUDE e ripresa del lavoro tra sessioni. Attiva automaticamente in ogni progetto.
---

# GitPilfer — Skill di Claude Code

## Comportamento automatico all'avvio

All'inizio di ogni sessione, controlla se `.claude/session.json` esiste nel progetto corrente.

### Primo avvio (session.json non esiste)

1. Leggi `CLAUDE.md` nella root del progetto
2. Analizza struttura e obiettivi del progetto
3. Crea `.claude/session.json` con stato iniziale:
   ```json
   {
     "stato": "ST:F0/0:init",
     "tipo_attivo": null,
     "task_corrente": null,
     "step_corrente": 0,
     "step_totale": 0,
     "note": [],
     "ultima_modifica": "<ISO timestamp>"
   }
   ```
4. Crea i mini-CLAUDE in `.claude/`:
   - `CLAUDE.feature.md` — workflow CERCA/ADATTA/SCRIVI per nuove feature
   - `CLAUDE.fix.md` — fast track per bug e crash
   - `CLAUDE.refactor.md` — regole per refactor sicuro
5. Aggiungi la riga `Codice stato: ST:F0/0:init` in `CLAUDE.md`
6. Comunica all'utente:
   - Cosa hai creato
   - Qual e il primo task

### Sessioni successive (session.json esiste)

1. Leggi `.claude/session.json`
2. Carica il mini-CLAUDE corrispondente al tipo attivo
3. Comunica all'utente:
   - Codice stato attuale
   - Step corrente / totale
   - Task in corso
   - Prossima azione

---

## Comandi interni

Questi comandi vengono chiamati da te (Claude), non dall'utente.

### /pilfer-search

**Input:** keyword di ricerca

**Comportamento:**
1. Se `gh` e disponibile: esegui `gh search repos <keyword> --sort stars --limit 10` e `gh search code <keyword> --limit 5`
2. Se `gh` non e disponibile: usa `curl` sull'API pubblica GitHub:
   ```
   curl "https://api.github.com/search/repositories?q=<keyword>&sort=stars&per_page=10"
   ```
   (no auth, limite 60 req/ora)

**Output:** lista candidati con:
- Nome repo e URL
- Stelle
- Data ultimo commit
- Licenza

**Contesto:** isolato — non caricare il resto del progetto

---

### /pilfer-checkpoint

**Input:** codice stato (es. `ST:F2/5:rate-limiter`), nota opzionale

**Comportamento:**
1. Aggiorna `.claude/session.json` con il nuovo stato
2. Trova e aggiorna la riga `Codice stato:` in `CLAUDE.md`
3. Se nota fornita, aggiungila all'array `note` in session.json

**Contesto:** isolato

---

### /pilfer-resume

**Comportamento:**
1. Leggi `.claude/session.json`
2. Stampa riepilogo:
   - Codice stato
   - Task corrente
   - Step corrente / totale
   - Ultime note
   - Prossima azione suggerita

**Contesto:** isolato

---

## Workflow CERCA/ADATTA/SCRIVI

Per ogni task di tipo **feature**, prima di scrivere codice:

1. Chiama `/pilfer-search` con keyword pertinente al task
2. Valuta ogni candidato con questi criteri:
   - Stelle > 200
   - Ultimo commit < 6 mesi fa
   - Dipendenze nuove introdotte <= 3
   - Licenza MIT o Apache 2.0
   - La parte utile e estraibile senza portarsi dietro tutto il repo
3. **Se candidato valido trovato:** adatta ed estrai solo la parte necessaria; cita la fonte in un commento
4. **Se nessun candidato valido:** scrivi da zero
5. Al completamento del task, chiama `/pilfer-checkpoint` con il codice aggiornato

---

## Formato codice stato

```
ST:<tipo><step>/<totale>:<task>
```

| Tipo | Significato |
|------|-------------|
| F    | Feature     |
| X    | Fix         |
| R    | Refactor    |

**Esempi:**
- `ST:F2/5:rate-limiter` — feature step 2 di 5, task: rate-limiter
- `ST:X1/1:crash-auth` — fix step 1 di 1, task: crash-auth
- `ST:R3/4:cleanup` — refactor step 3 di 4, task: cleanup

---

## Checkpoint automatici

- Dopo ogni task completato: chiama `/pilfer-checkpoint`
- Ogni 15 minuti se il task e ancora in corso: chiama `/pilfer-checkpoint` con nota "parziale — lavoro in corso"

---

## Contenuto mini-CLAUDE

### CLAUDE.feature.md

```markdown
# Workflow Feature

Per ogni nuova feature:

1. CERCA — chiama /pilfer-search con keyword pertinente
2. VALUTA candidati (stelle, eta, licenza, dipendenze, estraibilita)
3. ADATTA se trovato qualcosa di valido, altrimenti SCRIVI da zero
4. Testa il risultato
5. CHECKPOINT — chiama /pilfer-checkpoint con codice aggiornato
```

### CLAUDE.fix.md

```markdown
# Workflow Fix

Fast track per bug e crash:

1. Identifica la causa radice — non fare assunzioni
2. Scrivi il fix minimo necessario — niente refactor contestuale
3. Verifica che il bug sia risolto
4. CHECKPOINT — chiama /pilfer-checkpoint con codice ST:X<step>/<totale>:<task>
```

### CLAUDE.refactor.md

```markdown
# Workflow Refactor

Regole per refactor sicuro:

1. Non cambiare comportamento — solo struttura
2. Un cambiamento alla volta — commit atomici
3. I test devono passare prima e dopo ogni step
4. CHECKPOINT — chiama /pilfer-checkpoint dopo ogni step completato
```
