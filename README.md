# Portrait economique des entreprises du Quebec (SQL)

Projet portfolio SQL pour demonstrer des competences de Data Analyste:
- ingestion de donnees brutes
- controle qualite
- nettoyage
- analyse business avec SQL avance
- restitution reproductible (README + scripts)

## Questions business cibles
1. Quels secteurs (SCIAN) dominent par region ?
2. Quel est l age moyen des entreprises actives par region et secteur ?
3. Quelle est la repartition active vs radiee par region et secteur ?

## KPIs a publier
- Nombre total d entreprises
- Nombre d entreprises actives
- Pourcentage d entreprises radiees
- Age moyen des entreprises actives

## Source des donnees
- Registre des entreprises du Quebec (REQ)
- Voir [data/README_data.md](data/README_data.md) pour le detail des fichiers

## Structure du projet
- `data/` : documentation data + echantillons eventuels
- `sql/` : scripts SQL (schema, ingestion, cleaning, analyses, views/indexes)
- `docs/` : schema, captures de resultats, notes

## Ordre d execution SQL
1. `sql/01_schema.sql`
2. `sql/02_ingestion.sql`
3. `sql/03_cleaning.sql`
4. `sql/04_analysis.sql`
5. `sql/05_views_indexes.sql`

## Mode apprentissage (progressif)
Tu ecris les requetes. Je fais la revue technique a chaque etape:
- logique SQL
- qualite des filtres
- performance
- lisibilite et structure

## Prochaine etape
Commencer par `sql/01_schema.sql`:
- definir les tables de staging
- definir les tables nettoyees (dim/fact ou table clean)
- preciser les cles primaires / cles de jointure
