# CLAUDE.refactor.md — Workflow: refactor

> Mini-CLAUDE operativo. Contiene SOLO il workflow, zero contesto progetto.
> Il contesto sta in CLAUDE.md. Non sovrapporre.

---

## Sanity check (PRIMA di iniziare)

Rileggi CLAUDE.md sezione 1 e verifica:
- [ ] Il refactor non cambia il comportamento esterno degli script
- [ ] L'obiettivo del refactor è definito chiaramente
- [ ] Non si introducono dipendenze non approvate

---

## Regole refactor

1. **Un cambiamento alla volta** — non mescolare refactor diversi in un solo step
2. **Test prima e dopo** — verifica che il comportamento sia invariato
3. **Backup prima di ogni file toccato:**
   ```bash
   cp <file> <file>.bak.$(date +%Y%m%d%H%M%S)
   ```
4. **Non rinominare** funzioni o variabili senza aggiornare tutti i riferimenti
5. **Non estrarre** funzioni helper se usate in un solo posto

---

## Workflow

### 1. MAPPA

Prima di toccare qualcosa, elenca tutti i file coinvolti:
```
File da modificare:
  - [ ] <file1>
  - [ ] <file2>
```

### 2. ESEGUI

Per ogni file nella mappa:
1. Backup
2. Applica il singolo cambiamento
3. Verifica che gli altri file che dipendono da esso non si rompano

### 3. CONSOLIDA

- [ ] Rimuovi i `.bak` se tutto funziona (o archiviali)
- [ ] Aggiorna documentazione se i nomi/comportamenti pubblici sono cambiati

---

## Checkpoint

```bash
bash .claude/scripts/checkpoint.sh "ST:R<step>/<tot>:<task>"
```

---

## Definizione di "done"

- [ ] Comportamento esterno invariato
- [ ] Tutti i riferimenti aggiornati
- [ ] Nessun file irrilevante toccato
- [ ] Checkpoint salvato
