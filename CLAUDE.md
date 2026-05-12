# CLAUDE.md — GitPilfer

> Sistema di sessioni strutturate per Claude Code.
> Riferimento pubblico: github.com/pilgrimdelamare/GitPilfer

---

## ⚡ REGOLE CRITICHE

1. **Backup prima di toccare qualsiasi file esistente:**
   ```bash
   cp <file> <file>.bak.$(date +%Y%m%d%H%M%S)
   ```
2. **Mai riscrivere file per intero** — solo patch chirurgiche
3. **Mai toccare file non rilevanti al task**
4. **Mai installare dipendenze senza dichiararle prima**
5. **Se hai dubbi su un approccio — fermati e chiedi**

---

## 1. Contesto del progetto

**Obiettivo:**
GitPilfer è un sistema di template + script che permette a Claude Code di riprendere il lavoro tra sessioni, riciclare codice da GitHub invece di scriverlo da zero, e mantenere lo stato del progetto in forma compatta.

**Come funziona:**
- `CLAUDE.md` (questo file) contiene contesto progetto, stato corrente e puntatore di sessione
- I mini-CLAUDE in `.claude/` contengono i workflow operativi (uno per tipo di task)
- Claude Code carica `CLAUDE.md` + il mini-CLAUDE attivo — niente di più
- Lo stato viene scritto come codice compatto dopo ogni task e ad ogni checkpoint
- Ad ogni riavvio Code legge il codice stato e riprende esattamente da dove era

**Formato codice stato:**
```
ST:<tipo><step>/<totale>:<task>
```
Esempi:
- `ST:F2/5:setup-sh` → Feature, step 2 di 5, task corrente: setup.sh
- `ST:X1/1:readme` → Fix, step 1 di 1, task: readme
- `ST:R3/4:scripts` → Refactor, step 3 di 4, task: scripts

Tipi: `F` = feature, `X` = fix, `R` = refactor

**Stack:**
- Linguaggi: Bash, Markdown
- Dipendenze: `python3` (stdlib only), `gh` (GitHub CLI), `curl`, `git`
- Deploy: nessuno — è un repo di template
- Vincoli: zero dipendenze npm/pip, deve funzionare su qualsiasi macchina Unix con bash

**Struttura target del repo:**
```
GitPilfer/
  README.md
  CLAUDE.md                    ← questo file (template da compilare per ogni progetto)
  .claude/
    CLAUDE.feature.md          ← workflow CERCA/ADATTA/SCRIVI
    CLAUDE.fix.md              ← fast track fix
    CLAUDE.refactor.md         ← regole refactor
    session.json               ← stato macchina corrente
    scripts/
      setup.sh                 ← installa GitPilfer in un progetto esistente
      resume.sh                ← legge session.json e stampa il contesto di ripresa
      checkpoint.sh            ← aggiorna session.json e il codice stato in CLAUDE.md
  docs/
    stato-codici.md            ← dizionario formato codici stato
    mini-claude.md             ← come creare mini-CLAUDE custom
  snippets/                    ← cache snippet globale (init via setup.sh)
    index.json
    add-snippet.sh
    mark-tested.sh
```

**Convenzioni:**
- Naming: `kebab-case` per file e cartelle
- Lingua script: Bash
- Lingua documentazione: Italiano
- Lingua commenti nel codice: Italiano
- Ogni script inizia con `set -euo pipefail`
- Ogni script ha un commento di intestazione che spiega cosa fa

---

## 2. Stato attuale

**Ultimo aggiornamento:** 2025-05-12

**Codice stato:** `ST:F3/3:test-setup`

- [x] `setup.sh` — installa struttura in un progetto esistente
- [x] `resume.sh` — legge session.json, stampa contesto di ripresa
- [x] `checkpoint.sh` — aggiorna session.json + codice stato in CLAUDE.md
- [x] mini-CLAUDE files — CLAUDE.feature.md, CLAUDE.fix.md, CLAUDE.refactor.md
- [x] documentazione — README.md, docs/

**Ultimo punto fermo:** feature completa, tutti gli script testati e funzionanti

**Prossimo task:** nessuno — prima feature completata

---

## 3. Istruzioni di sessione

**Per riprendere il lavoro:**
```bash
bash .claude/scripts/resume.sh
```

**Per salvare lo stato dopo un task:**
```bash
bash .claude/scripts/checkpoint.sh "ST:F<step>/<tot>:<task>"
```

**Sanity check** (esegui all'inizio di ogni nuovo mini-CLAUDE):
Rileggi la sezione 1 di questo file e verifica che il task pianificato sia coerente con obiettivo e vincoli del progetto.

**Mini-CLAUDE attivo:** `.claude/CLAUDE.feature.md`

---

## 4. Note specifiche del progetto

**Decisioni architetturali:**
- [2025-05-12] `session.json` è il cuore del sistema — contiene lo stato macchina in forma strutturata, CLAUDE.md contiene solo il codice stato human-readable. I due devono sempre essere sincronizzati da `checkpoint.sh`
- [2025-05-12] Nessuna dipendenza esterna oltre a python3 stdlib e gh CLI — il sistema deve funzionare out of the box su qualsiasi macchina Unix
- [2025-05-12] I mini-CLAUDE non contengono contesto progetto — solo workflow. CLAUDE.md non contiene workflow — solo contesto. Nessuna sovrapposizione.
- [2025-05-12] Il sanity check avviene **prima** di iniziare ogni nuovo mini-CLAUDE, non dopo
- [2025-05-12] Gli script rilevano Python dinamicamente: `python3 → python → py` — necessario su Windows dove `python3` è intercettato dall'App Alias del Microsoft Store
- [2025-05-12] Tutti i `open()` Python usano `encoding="utf-8"` esplicito — obbligatorio su Windows (default cp1252 rompe caratteri non-ASCII)
- [2025-05-12] `gh` CLI si autentica via `GH_TOKEN` in `$HOME/.bash_profile` — non usare `gh auth login` (richiede scope `read:org` non sempre disponibile)

**Cose da non fare:**
- [2025-05-12] Non usare `~` nei path degli script — usare `$HOME`
- [2025-05-12] Non mettere regole operative in CLAUDE.md base — stanno nei mini-CLAUDE
- [2025-05-12] Non generare i mini-CLAUDE dinamicamente — sono template statici definiti a priori
- [2025-05-12] Non usare `python3` hardcoded negli script — usare il rilevatore dinamico già presente in resume.sh e checkpoint.sh

**Dipendenze già approvate:**
- `python3` / `python` / `py` (stdlib: json, re, sys, os) — rilevato dinamicamente
- `gh` (GitHub CLI) — auth via `GH_TOKEN`
- `curl`
- `git`

**Dipendenze vietate:**
- [2025-05-12] qualsiasi package npm o pip — motivo: zero dipendenze, massima portabilità

---

*Ultima modifica: 2025-05-12 — prima sessione completa*
