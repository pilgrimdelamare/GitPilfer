# stato-codici.md — Dizionario formato codici stato

## Formato

```
ST:<tipo><step>/<totale>:<task>
```

## Campi

| Campo     | Descrizione                                              | Valori        |
|-----------|----------------------------------------------------------|---------------|
| `ST:`     | Prefisso fisso — identifica un codice stato GitPilfer    | fisso         |
| `<tipo>`  | Tipo di sessione                                         | F, X, R       |
| `<step>`  | Step corrente (0 = non iniziato)                         | intero ≥ 0    |
| `<totale>`| Numero totale di step                                    | intero ≥ 1    |
| `<task>`  | Nome breve del task corrente (kebab-case)                | stringa       |

## Tipi

| Codice | Tipo     | Quando usarlo                                    |
|--------|----------|--------------------------------------------------|
| `F`    | Feature  | Nuova funzionalità, aggiunta di file/script      |
| `X`    | Fix      | Correzione bug, hotfix                           |
| `R`    | Refactor | Ristrutturazione senza cambio di comportamento   |

## Esempi

| Codice              | Significato                                          |
|---------------------|------------------------------------------------------|
| `ST:F0/5:init`      | Feature, non ancora iniziata, 5 step totali          |
| `ST:F2/5:setup-sh`  | Feature, step 2 di 5, task corrente: setup.sh        |
| `ST:F5/5:docs`      | Feature completata, ultimo step: docs                |
| `ST:X1/1:readme`    | Fix in un solo step, task: readme                    |
| `ST:R3/4:scripts`   | Refactor, step 3 di 4, task: scripts                 |

## Regole

1. Il codice stato in `CLAUDE.md` e in `session.json` devono essere **sempre sincronizzati**.
2. Aggiorna tramite `checkpoint.sh` — mai a mano (rischio disallineamento).
3. `step=0` indica che il task non è ancora iniziato (stato iniziale).
4. Quando tutti gli step sono completati, il codice rimane sull'ultimo task finché non inizia una nuova sessione.
