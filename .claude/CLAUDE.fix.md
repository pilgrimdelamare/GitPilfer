# CLAUDE.fix.md — Workflow: fix rapido

> Mini-CLAUDE operativo. Contiene SOLO il workflow, zero contesto progetto.
> Il contesto sta in CLAUDE.md. Non sovrapporre.

---

## Sanity check (PRIMA di iniziare)

Rileggi CLAUDE.md sezione 1 e verifica:
- [ ] Il fix è limitato al problema segnalato, niente refactor non richiesto
- [ ] Non si toccano file irrilevanti

---

## Workflow fast-track fix

### 1. DIAGNOSI

Identifica la causa radice prima di toccare qualsiasi file:
- Leggi il file incriminato
- Riproduci il problema mentalmente o via test
- Scrivi qui la causa: `___`

### 2. PATCH

Backup obbligatorio:
```bash
cp <file> <file>.bak.$(date +%Y%m%d%H%M%S)
```

Applica la patch minima necessaria:
- Solo le righe che causano il problema
- Zero modifiche estetiche o di stile non richieste

### 3. VERIFICA

- [ ] Il fix risolve il problema segnalato
- [ ] Non introduce regressioni nei flussi vicini
- [ ] Il file rispetta ancora le convenzioni (set -euo pipefail, $HOME, ecc.)

---

## Checkpoint

```bash
bash .claude/scripts/checkpoint.sh "ST:X<step>/<tot>:<task>"
```

---

## Definizione di "done"

- [ ] Causa radice identificata e documentata
- [ ] Patch applicata — minima, chirurgica
- [ ] Verificato che il problema non si ripresenta
- [ ] Checkpoint salvato
