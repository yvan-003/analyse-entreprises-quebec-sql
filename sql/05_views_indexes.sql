-- 05_views_indexes.sql
-- Objectif: vues reutilisables + optimisation + mini validation perf

\echo '=== DEBUT VIEWS + INDEXES ==='
\timing on

-- =========================================================
-- 1) INDEXES (if not exists)
-- =========================================================

-- Filtres frequents
CREATE INDEX IF NOT EXISTS idx_ec_statut_code ON entreprise_clean(statut_code);
CREATE INDEX IF NOT EXISTS idx_ec_secteur_code ON entreprise_clean(secteur_code);
CREATE INDEX IF NOT EXISTS idx_ec_region_id ON entreprise_clean(region_id);
CREATE INDEX IF NOT EXISTS idx_ec_date_constitution ON entreprise_clean(date_constitution);
CREATE INDEX IF NOT EXISTS idx_ec_age_classe ON entreprise_clean(age_classe);

-- Jointure utile pour les noms
CREATE INDEX IF NOT EXISTS idx_sn_neq_stat_typ ON stg_nom(neq, stat_nom, typ_nom_assuj);

-- =========================================================
-- 2) VIEWS METIER
-- =========================================================

DROP VIEW IF EXISTS vw_entreprises_actives;
CREATE VIEW vw_entreprises_actives AS
SELECT
    ec.neq,
    ec.nom_entreprise,
    dr.region_name,
    dsec.secteur_label,
    ec.age_entreprise,
    ec.age_classe,
    ec.intervalle_employes_code,
    ds.statut_label
FROM entreprise_clean ec
JOIN dim_statut ds ON ds.statut_code = ec.statut_code
LEFT JOIN dim_region dr ON dr.region_id = ec.region_id
LEFT JOIN dim_secteur dsec ON dsec.secteur_code = ec.secteur_code
WHERE ds.is_active = TRUE;

DROP VIEW IF EXISTS vw_top_secteurs_par_region;
CREATE VIEW vw_top_secteurs_par_region AS
WITH base AS (
    SELECT
        UPPER(TRIM(REGEXP_REPLACE(COALESCE(dr.region_name, '[INCONNUE]'), E'[\\n\\r\\t]+', ' ', 'g'))) AS region_name_clean,
        COALESCE(dsec.secteur_label, '[SECTEUR_INCONNU]') AS secteur_label,
        COUNT(*) AS nb_entreprises
    FROM entreprise_clean ec
    JOIN dim_statut ds ON ds.statut_code = ec.statut_code
    LEFT JOIN dim_region dr ON dr.region_id = ec.region_id
    LEFT JOIN dim_secteur dsec ON dsec.secteur_code = ec.secteur_code
    WHERE ds.is_active = TRUE
    GROUP BY 1, 2
),
classement AS (
    SELECT
        region_name_clean,
        secteur_label,
        nb_entreprises,
        RANK() OVER (PARTITION BY region_name_clean ORDER BY nb_entreprises DESC) AS rang_region,
        ROUND(
            100.0 * nb_entreprises
            / SUM(nb_entreprises) OVER (PARTITION BY region_name_clean),
            2
        ) AS part_region_pct
    FROM base
)
SELECT
    region_name_clean,
    rang_region,
    secteur_label,
    nb_entreprises,
    part_region_pct
FROM classement
WHERE rang_region <= 5;

DROP VIEW IF EXISTS vw_age_moyen_par_region;
CREATE VIEW vw_age_moyen_par_region AS
SELECT
    UPPER(TRIM(REGEXP_REPLACE(COALESCE(dr.region_name, '[INCONNUE]'), E'[\\n\\r\\t]+', ' ', 'g'))) AS region_name_clean,
    ROUND(AVG(ec.age_entreprise)::numeric, 2) AS age_moyen,
    COUNT(*) AS nb_entreprises_avec_age
FROM entreprise_clean ec
JOIN dim_statut ds ON ds.statut_code = ec.statut_code
LEFT JOIN dim_region dr ON dr.region_id = ec.region_id
WHERE ds.is_active = TRUE
  AND ec.age_entreprise IS NOT NULL
GROUP BY 1;

-- =========================================================
-- 3) MINI VALIDATION PERFORMANCE
-- =========================================================

\echo '--- PERF 1: count actives par region (EXPLAIN ANALYZE) ---'
EXPLAIN ANALYZE
SELECT
    dr.region_name,
    COUNT(*) AS nb
FROM entreprise_clean ec
JOIN dim_statut ds ON ds.statut_code = ec.statut_code
LEFT JOIN dim_region dr ON dr.region_id = ec.region_id
WHERE ds.is_active = TRUE
GROUP BY dr.region_name
ORDER BY nb DESC;

\echo '--- PERF 2: age moyen des actives (EXPLAIN ANALYZE) ---'
EXPLAIN ANALYZE
SELECT
    dr.region_name,
    ROUND(AVG(ec.age_entreprise)::numeric, 2) AS age_moyen
FROM entreprise_clean ec
JOIN dim_statut ds ON ds.statut_code = ec.statut_code
LEFT JOIN dim_region dr ON dr.region_id = ec.region_id
WHERE ds.is_active = TRUE
  AND ec.age_entreprise IS NOT NULL
GROUP BY dr.region_name
ORDER BY age_moyen DESC;

-- =========================================================
-- 4) CHECKS RAPIDES
-- =========================================================

\echo '--- CHECK VIEWS ---'
SELECT COUNT(*) AS nb_actives FROM vw_entreprises_actives;
SELECT COUNT(*) AS nb_lignes_top5 FROM vw_top_secteurs_par_region;
SELECT COUNT(*) AS nb_regions_age FROM vw_age_moyen_par_region;

\echo '=== FIN VIEWS + INDEXES ==='