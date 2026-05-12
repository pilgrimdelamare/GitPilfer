# mini-claude.md — Come creare mini-CLAUDE custom

## Cos'è un mini-CLAUDE

Un mini-CLAUDE è un file Markdown che contiene **solo il workflow operativo** per un tipo di task. Non contiene contesto di progetto (quello sta in `CLAUDE.md`).

Claude Code carica `CLAUDE.md` + il mini-CLAUDE attivo indicato nella sezione 3 di `CLAUDE.md`. Niente di più.

## Struttura base

```markdown
# CLAUDE.<nome>.md — Workflow: <descrizione breve>

> Mini-CLAUDE operativo. Contiene SOLO il workflow, zero contesto progetto.

---

## Sanity check (PRIMA di iniziare)

Rileggi CLAUDE.md sezione 1 e verifica:
- [ ] ...

---

## Workflow

### 1. <primo step>
...

### 2. <secondo step>
...

---

## Checkpoint

bash .claude/scripts/checkpoint.sh "ST:<tipo><step>/<tot>:<task>"

---

## Definizione di "done"

- [ ] ...
```

## Regole

1. **Zero contesto progetto** — niente stack, obiettivi, decisioni architetturali. Quello sta in `CLAUDE.md`.
2. **Zero overlap con CLAUDE.md** — se una regola è in `CLAUDE.md`, non duplicarla qui.
3. **Sanity check sempre in cima** — deve essere la prima cosa che Claude legge.
4. **Definizione di done sempre in fondo** — criteri chiari e verificabili.
5. **Template statici** — i mini-CLAUDE non vengono generati dinamicamente. Creali a priori per i workflow ricorrenti.

## Mini-CLAUDE inclusi in GitPilfer

| File                    | Quando usarlo                              |
|-------------------------|--------------------------------------------|
| `CLAUDE.feature.md`     | Nuova feature — usa il pattern CERCA/ADATTA/SCRIVI |
| `CLAUDE.fix.md`         | Fix rapido — diagnosi + patch minima       |
| `CLAUDE.refactor.md`    | Refactor — un cambiamento alla volta       |

## Come attivare un mini-CLAUDE

In `CLAUDE.md`, sezione 3, aggiorna la riga:
```
**Mini-CLAUDE attivo:** `.claude/CLAUDE.<nome>.md`
```

## Come creare un mini-CLAUDE custom

1. Copia `CLAUDE.feature.md` come base
2. Rinomina: `.claude/CLAUDE.<nome>.md`
3. Adatta il workflow al tipo di task
4. Aggiorna `CLAUDE.md` sezione 3 per attivarlo
