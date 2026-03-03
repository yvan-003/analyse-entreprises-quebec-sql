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

## Results (to be updated)
- Total enterprises processed: TBD
- Active enterprises: TBD
- Inactive enterprises ratio: TBD
- Average business age: TBD

## Key Insights (to be updated)
- Regional sector concentration findings: TBD
- Business longevity patterns: TBD
- Data quality improvements after cleaning: TBD

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

### Resultats (a mettre a jour)
- Nombre total d entreprises traitees: TBD
- Nombre d entreprises actives: TBD
- Ratio d entreprises radiees: TBD
- Age moyen des entreprises actives: TBD

### Insights cles (a mettre a jour)
- Concentration sectorielle par region: TBD
- Tendances de longevite des entreprises: TBD
- Amelioration de la qualite des donnees apres nettoyage: TBD
