# Plan Video (2 a 3 minutes)

## Objectif
Presenter rapidement le projet SQL de facon claire pour recruteurs.

## Script recommande
1. Contexte (20s)
- "Projet SQL sur le Registre des entreprises du Quebec pour produire un portrait economique region/secteur."

2. Volume et pipeline (30s)
- "J ai traite 2,9M lignes avec un pipeline en 5 scripts: schema, ingestion, cleaning, analyse, views/indexes."

3. Qualite des donnees (35s)
- "Verification des nulls, doublons, volumetrie."
- "Aucun doublon NEQ dans la table entreprise."
- "41,11% des dates de constitution sont manquantes."

4. Resultats business (45s)
- "1 133 196 entreprises actives (39,03%) vs 1 770 177 non actives (60,97%)."
- "Top secteurs par region et age moyen par region via vues SQL reutilisables."

5. Industrialisation (25s)
- "Creation de vues metier + index + verification performance avec EXPLAIN ANALYZE."

6. Conclusion (15s)
- "Projet reproductible, documente, oriente metier et pret a etre etendu en dashboard BI."

## Captures a montrer
- `docs/screenshots/01_schema.png`
- `docs/screenshots/02_ingestion.png`
- `docs/screenshots/03_cleaning.png`
- `docs/screenshots/04_analysis.png`
- `docs/screenshots/05_views_indexes.png`
