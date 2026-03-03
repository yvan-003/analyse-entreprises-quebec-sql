# Enonce Projet - SQL Data Analyst (REQ Quebec)

## 1) Contexte (simulation entreprise)
Tu es Data Analyst dans une equipe "Intelligence economique".
La direction te demande de construire un mini socle analytique SQL a partir du Registre des entreprises du Quebec (REQ) pour produire un portrait economique fiable et reutilisable.

Le besoin n est pas juste de "faire des requetes".
Le besoin est de livrer un pipeline clair:
- donnees brutes -> donnees fiables -> analyses business -> objets reutilisables.

## 2) Mission
Concevoir et documenter une base SQL qui repond a 3 questions metier:
1. Quels secteurs dominent par region ?
2. Quel est l age moyen des entreprises actives par region et secteur ?
3. Quelle est la repartition actives vs radiees par region et secteur ?

## 3) Donnees disponibles
Fichiers bruts (local):
- `JeuDonnees/Entreprise.csv`
- `JeuDonnees/Etablissements.csv`
- `JeuDonnees/Nom.csv`
- `JeuDonnees/DomaineValeur.csv`
- `JeuDonnees/FusionScissions.csv`
- `JeuDonnees/ContinuationsTransformations.csv`

## 4) Livrables attendus
1. Scripts SQL dans le dossier `sql/` (ordre impose ci-dessous).
2. README projet a jour (objectif, methode, resultats).
3. Notes de validation (qualite et performance) dans `docs/`.

## 5) Ordre de travail impose (et pourquoi)

### `sql/01_schema.sql`
Objectif:
- definir la structure cible (staging + analytique).

Pourquoi ce fichier existe:
- sans schema, tu ne controles ni types, ni cles, ni qualite.

Questions a te poser:
1. Quelle table est la table centrale (grain principal) ?
2. Quelles tables sont multi-lignes par `NEQ` ?
3. Quelles colonnes sont obligatoires ?
4. Quelles cles et index minimum faut-il des le debut ?

Resultat attendu:
- tables `stg_*` + tables analytiques creees proprement.

---

### `sql/02_ingestion.sql`
Objectif:
- charger les CSV dans les tables staging.

Pourquoi ce fichier existe:
- l ingestion est une etape a part entiere (reproductible, verifiable).

Questions a te poser:
1. Le chargement est-il complet (volumetrie attendue) ?
2. Y a-t-il des nulls sur les colonnes critiques ?
3. Y a-t-il des doublons sur l identifiant attendu ?
4. Les formats de dates et codes sont-ils valides ?

Resultat attendu:
- donnees brutes chargees + controles de base executes.

---

### `sql/03_cleaning.sql`
Objectif:
- transformer les donnees brutes en donnees analytiques fiables.

Pourquoi ce fichier existe:
- les donnees brutes ne sont pas directement exploitables metier.

Questions a te poser:
1. Comment harmoniser les statuts (active/radiee/autres) ?
2. Quelle regle pour choisir un nom "en vigueur" ?
3. Comment traiter les valeurs manquantes sans biaiser l analyse ?
4. Quelles colonnes derivees sont utiles (age, classes) ?

Resultat attendu:
- table analytique propre (ex: `entreprise_clean`).

---

### `sql/04_analysis.sql`
Objectif:
- repondre clairement aux 3 questions metier.

Pourquoi ce fichier existe:
- c est la partie "valeur business" visible par les decideurs.

Questions a te poser:
1. Quelle definition exacte de "dominant" (volume, part, top N) ?
2. Quelle population inclure (actives uniquement ou non) ?
3. Les resultats sont-ils stables et expliquables ?
4. Quels KPI doivent apparaitre dans le README ?

Resultat attendu:
- requetes finales lisibles (CTE + window functions + KPI).

---

### `sql/05_views_indexes.sql`
Objectif:
- rendre les analyses reutilisables et plus performantes.

Pourquoi ce fichier existe:
- en contexte pro, on ne relance pas toujours les memes grosses requetes ad hoc.

Questions a te poser:
1. Quelles sorties doivent devenir des `VIEW` ?
2. Quels index aident vraiment les requetes critiques ?
3. Comment prouver l impact (EXPLAIN avant/apres) ?

Resultat attendu:
- vues metier + index justifies + mini preuve de performance.

## 6) Contraintes de qualite (Definition of Done)
Le projet est "done" si:
1. Les 5 scripts s executent dans l ordre sans action manuelle cachee.
2. Les controles qualite sont presents (volumes, nulls, doublons, coherence codes).
3. Les 3 questions metier ont des reponses SQL explicites.
4. Le README contient des resultats chiffres et 2-3 insights clairs.
5. Les objets reutilisables (views) existent et les index sont justifies.

## 7) Criteres d evaluation 
1. Rigueur technique (schema, cles, checks): 30%
2. Qualite des transformations (nettoyage + regles): 25%
3. Pertinence business des analyses: 25%
4. Documentation et reproductibilite: 20%

## 8) Methode de travail recommandee
Pour chaque script:
1. Ecrire un brouillon.
2. Executer et verifier.
3. Corriger.
4. Commit avec message clair.
5. Mettre a jour README si un resultat metier est ajoute.

cadence:
- Jour 1-2: schema
- Jour 3-4: ingestion
- Jour 5-6: cleaning
- Jour 7-8: analyses
- Jour 9: views/indexes + README final

## 9) Point cle 
Ce projet doit raconter une histoire simple:
"Je sais prendre une source brute volumineuse, la structurer, la fiabiliser, et en extraire des insights metier reproductibles avec SQL."
