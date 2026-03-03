# Quebec Enterprise Registry SQL Analytics / Portrait economique des entreprises du Quebec (SQL)

English and French versions are available below.

- [English](#english)
- [Francais](#francais)

## English

### Project Overview
SQL analytics project based on Quebec Enterprise Registry (REQ) open data.
The objective is to build a reproducible economic profile of businesses by sector (SCIAN) and region.

### Business Questions
1. Which sectors dominate each region?
2. What is the average age of active businesses by region and sector?
3. What is the active vs inactive business distribution across regions and sectors?

### KPIs
- Total number of businesses
- Number of active businesses
- Share of inactive businesses
- Average age of active businesses

### Data Source
- Quebec Enterprise Registry (REQ)
- Data notes and file inventory: `data/README_data.md`

### Repository Structure
- `data/` : data notes and local data context
- `sql/` : schema, ingestion, cleaning, analysis, views/indexes
- `docs/` : model diagrams, query outputs, screenshots

### SQL Execution Order
1. `sql/01_schema.sql`
2. `sql/02_ingestion.sql`
3. `sql/03_cleaning.sql`
4. `sql/04_analysis.sql`
5. `sql/05_views_indexes.sql`

### Deliverables
- Clean analytical dataset
- SQL query pack answering key business questions
- Reusable views for reporting
- Performance notes (EXPLAIN before/after indexing)

## Francais

### Contexte du projet
Projet SQL base sur les donnees ouvertes du Registre des entreprises du Quebec (REQ).
L objectif est de produire un portrait economique reproductible des entreprises par secteur (SCIAN) et par region.

### Questions business
1. Quels secteurs dominent dans chaque region ?
2. Quel est l age moyen des entreprises actives par region et secteur ?
3. Quelle est la repartition entreprises actives vs radiees par region et secteur ?

### KPIs
- Nombre total d entreprises
- Nombre d entreprises actives
- Part d entreprises radiees
- Age moyen des entreprises actives

### Source des donnees
- Registre des entreprises du Quebec (REQ)
- Notes data et inventaire local: `data/README_data.md`

### Structure du depot
- `data/` : notes sur les donnees et contexte local
- `sql/` : schema, ingestion, nettoyage, analyse, vues/index
- `docs/` : schema de donnees, sorties SQL, captures

### Ordre d execution SQL
1. `sql/01_schema.sql`
2. `sql/02_ingestion.sql`
3. `sql/03_cleaning.sql`
4. `sql/04_analysis.sql`
5. `sql/05_views_indexes.sql`

### Livrables
- Dataset analytique nettoye
- Pack de requetes SQL orientees metier
- Vues reutilisables pour reporting
- Notes de performance (EXPLAIN avant/apres index)
