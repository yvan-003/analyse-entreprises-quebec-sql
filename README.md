# Quebec Enterprise Registry SQL Analytics / Portrait economique des entreprises du Quebec (SQL)

English and French versions are available below.

- [English](#english)
- [Francais](#francais)

## English

### Project Overview
SQL analytics project based on Quebec Enterprise Registry (REQ) open data.
The objective is to build a reproducible economic profile of businesses by sector (SCIAN) and region.
Detailed assignment brief: `docs/ENONCE_PROJET_REQ.md`.

## Business Objectives
1. Identify the sectors that dominate each region.
2. Measure average business age by region and sector.
3. Compare active vs inactive business distribution across regions and sectors.

## Scope and Data Source
- Source: Registre des entreprises du Quebec (REQ), Donnees Quebec.
- Main entities: enterprise, establishment, names, and reference domain values.
- Local data inventory and notes: `data/README_data.md`.

## Technical Stack
- PostgreSQL
- SQL (CTE, window functions, views, indexing)
- Optional: Power BI for final visualization layer

## Methodology
1. Raw ingestion into staging tables.
2. Data quality controls (row counts, null checks, duplicate checks).
3. Cleaning and business-rule standardization.
4. Analytical modeling for regional and sector-level reporting.
5. Reusable views and performance tuning with indexes.

## Repository Structure
- `data/` : data notes and ingestion context
- `sql/01_schema.sql` : table design (staging + analytics)
- `sql/02_ingestion.sql` : CSV loading and ingestion checks
- `sql/03_cleaning.sql` : normalization and feature engineering
- `sql/04_analysis.sql` : business analysis queries
- `sql/05_views_indexes.sql` : reusable views and indexing strategy
- `docs/` : model diagram, query outputs, and screenshots

## Execution Order
1. `sql/01_schema.sql`
2. `sql/02_ingestion.sql`
3. `sql/03_cleaning.sql`
4. `sql/04_analysis.sql`
5. `sql/05_views_indexes.sql`

## Deliverables
- Clean analytical dataset for business reporting
- SQL query pack answering key business questions
- Reusable views for recurring analysis
- Performance notes (EXPLAIN before/after indexes)

## Results
- Total enterprises processed: 2,903,373
- Active enterprises (IM): 1,133,196 (39.03%)
- Non-active enterprises: 1,770,177 (60.97%)
- Null `date_constitution`: 1,193,645 (41.11%)
- Rows in `vw_top_secteurs_par_region`: 1,863
- Regions in `vw_age_moyen_par_region`: 771

## Key Insights
- The active vs non-active split is imbalanced toward non-active entities (60.97%).
- A significant share of companies has missing constitution dates (41.11%), which impacts longevity metrics.
- The region and sector dimensions remain highly granular in the raw source, requiring normalization choices for reporting.

## Portfolio Assets
- Add SQL output screenshots in `docs/screenshots/`.
- Add a short demo video link in this README (Loom/YouTube unlisted).
- Presentation script template: `docs/PRESENTATION_VIDEO.md`.
- Recommended screenshots:
  - schema execution (`01_schema.sql`)
  - ingestion controls (`02_ingestion.sql`)
  - cleaning controls (`03_cleaning.sql`)
  - analysis outputs (`04_analysis.sql`)
  - explain analyze + view checks (`05_views_indexes.sql`)

## Francais

### Contexte du projet
Projet SQL base sur les donnees ouvertes du Registre des entreprises du Quebec (REQ).
Objectif: produire un portrait economique reproductible des entreprises actives vs radiees par secteur (SCIAN) et par geographie.
Enonce detaille du projet: `docs/ENONCE_PROJET_REQ.md`.

### Questions business
1. Quels secteurs dominent par region ?
2. Quel est l age moyen des entreprises actives par region et secteur ?
3. Quelle est la repartition actives vs radiees par region et secteur ?

### Perimetre et source des donnees
- Source: Registre des entreprises du Quebec (REQ), Donnees Quebec.
- Entites principales: entreprise, etablissement, noms, et table de reference des codes.
- Inventaire local des donnees: `data/README_data.md`.

### Stack technique
- PostgreSQL
- SQL (CTE, window functions, views, indexation)
- Optionnel: Power BI pour la visualisation finale

### Methodologie
1. Ingestion brute en tables de staging.
2. Controles qualite (volumetrie, nulls, doublons).
3. Nettoyage et standardisation des regles metier.
4. Modelisation analytique pour le reporting region/secteur.
5. Vues reutilisables et optimisation avec index.

### Structure du depot
- `data/` : notes data et contexte d ingestion
- `sql/01_schema.sql` : modele de tables (staging + analytique)
- `sql/02_ingestion.sql` : chargement CSV et checks d ingestion
- `sql/03_cleaning.sql` : normalisation et variables derivees
- `sql/04_analysis.sql` : requetes d analyse metier
- `sql/05_views_indexes.sql` : vues reutilisables et strategie d index
- `docs/` : schema, sorties de requetes et captures

### Ordre d execution
1. `sql/01_schema.sql`
2. `sql/02_ingestion.sql`
3. `sql/03_cleaning.sql`
4. `sql/04_analysis.sql`
5. `sql/05_views_indexes.sql`

### Livrables
- Dataset analytique propre pour le reporting
- Pack de requetes SQL repondant aux questions metier
- Vues reutilisables pour analyses recurrentes
- Notes de performance (EXPLAIN avant/apres index)

### Resultats
- Nombre total d entreprises traitees: 2 903 373
- Entreprises actives (IM): 1 133 196 (39,03 %)
- Entreprises non actives: 1 770 177 (60,97 %)
- Valeurs nulles sur `date_constitution`: 1 193 645 (41,11 %)
- Lignes dans `vw_top_secteurs_par_region`: 1 863
- Regions dans `vw_age_moyen_par_region`: 771

### Insights cles
- La repartition actives vs non actives est fortement orientee vers les non actives (60,97 %).
- Une part importante des dates de constitution est absente (41,11 %), ce qui influence les analyses de longevite.
- Les dimensions region/secteur sont tres granulaires dans la source brute et demandent des choix de normalisation pour le reporting.

### Assets Portfolio
- Ajouter les captures SQL dans `docs/screenshots/`.
- Ajouter un lien vers une video courte de demo (Loom/YouTube non liste).
- Script de presentation: `docs/PRESENTATION_VIDEO.md`.
- Captures recommandees:
  - execution schema (`01_schema.sql`)
  - controles ingestion (`02_ingestion.sql`)
  - controles cleaning (`03_cleaning.sql`)
  - sorties analyse (`04_analysis.sql`)
  - explain analyze + controles des vues (`05_views_indexes.sql`)
