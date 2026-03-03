# Quebec Enterprise Registry SQL Analytics

SQL analytics project built on Quebec Enterprise Registry (REQ) open data.
Goal: produce a reproducible economic profile of active vs inactive businesses by sector (SCIAN) and geography.

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
