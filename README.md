# Dutch Date Parser & Generator in Prolog (DCG & CLP(FD))

Een bidirectionele parser en datumgenerator geschreven in **SWI-Prolog** met behulp van **Definite Clause Grammars (DCG)** en de **CLP(FD)** (Constraint Logic Programming over Finite Domains) bibliotheek.

Dit project parseert natuurlijke Nederlandstalige datumaanduidingen naar gestructureerde datumtermen en kan dankzij constraint-logica ook omgekeerd datums genereren vanuit gestructureerde data.

---

## Functionaliteiten

- **DCG Parsing:** Natuurlijke verwerking van Nederlandse datumstructuren (bv. `[vrijdag, 31, januari, 2025]`).
- **Bidirectioneel / Reversibel via CLP(FD):** Werkt in beide richtingen:
  - Tekst $\rightarrow$ `date(DagVanWeek, Dag, Maand, Jaar)`
  - `date(DagVanWeek, Dag, Maand, Jaar)` $\rightarrow$ Tekst
  - Validatie van beide representaties tegelijk.
- **Geavanceerde Datumexpressies:**
  - *Gespecificeerde dagen:* `"de [specificatie] dag van [maand] [jaar]"` (bv. *de laatste dag van november 2025*).
  - *Relatieve weekdagen:* `"de [specificatie] [weekdag] van [maand] [jaar]"` (bv. *de eerste maandag van februari 2021*).
  - *Wekelijkse formuleringen:* `"de [weekdag] van de [specificatie] week van [maand] [jaar]"` (bv. *de dinsdag van de eerste week van juli 2016*).
- **Sakamoto's Algoritme:** Bepaling van de juiste weekdag ($0 = \text{zondag}, \dots, 6 = \text{zaterdag}$) rekening houdend met schrikkeljaren.
- **Kalender- & Schrikkeljaarvalidatie:** Correcte afhandeling van 28, 29, 30 en 31 dagen per maand op basis van gregoriaanse schrikkeljaarregels.

---

## Gebruikte Technologieën & Bibliotheken

- **SWI-Prolog**
- `library(lists)`
- `library(clpfd)` (voor declaratieve wiskunde en domeinrestricties zonder instantiatiefouten)

---

## Voorbeelden & Gebruik

Laad het bestand in SWI-Prolog:

```prolog
swipl template.pl
