-- 04_analysis.sql
-- Objectif: repondre aux questions business avec requetes presentables

\echo '=== DEBUT ANALYSE ==='
\timing on

-- =========================================================
-- A) SEGMENTATION REGION + SECTEUR
-- =========================================================

\echo '--- A1: Nombre d entreprises actives par region ---'
SELECT
    dr.region_name,
    COUNT(*) AS nb_entreprises_actives
FROM entreprise_clean ec
JOIN dim_statut ds ON ds.statut_code = ec.statut_code
LEFT JOIN dim_region dr ON dr.region_id = ec.region_id
WHERE ds.is_active = TRUE
GROUP BY dr.region_name
ORDER BY nb_entreprises_actives DESC
LIMIT 30;

\echo '--- A2: Top 10 secteurs (global) parmi les actives ---'
SELECT
    dsec.secteur_label,
    COUNT(*) AS nb_entreprises_actives
FROM entreprise_clean ec
JOIN dim_statut ds ON ds.statut_code = ec.statut_code
LEFT JOIN dim_secteur dsec ON dsec.secteur_code = ec.secteur_code
WHERE ds.is_active = TRUE
GROUP BY dsec.secteur_label
ORDER BY nb_entreprises_actives DESC
LIMIT 10;

-- =========================================================
-- B) LONGEVITE
-- =========================================================

\echo '--- B1: Age moyen des entreprises actives par region ---'
SELECT
    dr.region_name,
    ROUND(AVG(ec.age_entreprise)::numeric, 2) AS age_moyen
FROM entreprise_clean ec
JOIN dim_statut ds ON ds.statut_code = ec.statut_code
LEFT JOIN dim_region dr ON dr.region_id = ec.region_id
WHERE ds.is_active = TRUE
  AND ec.age_entreprise IS NOT NULL
GROUP BY dr.region_name
ORDER BY age_moyen DESC
LIMIT 30;

\echo '--- B2: Distribution des classes d age (actives) ---'
SELECT
    ec.age_classe,
    COUNT(*) AS nb,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM entreprise_clean ec
JOIN dim_statut ds ON ds.statut_code = ec.statut_code
WHERE ds.is_active = TRUE
GROUP BY ec.age_classe
ORDER BY
    CASE ec.age_classe
        WHEN '0-2' THEN 1
        WHEN '3-5' THEN 2
        WHEN '6-10' THEN 3
        WHEN '10+' THEN 4
        ELSE 5
    END;

-- =========================================================
-- C) CLASSEMENTS (WINDOW FUNCTIONS)
-- =========================================================

\echo '--- C1: Top 5 secteurs par region (actives) ---'
WITH secteur_region AS (
    SELECT
        dr.region_name,
        dsec.secteur_label,
        COUNT(*) AS nb_entreprises
    FROM entreprise_clean ec
    JOIN dim_statut ds ON ds.statut_code = ec.statut_code
    LEFT JOIN dim_region dr ON dr.region_id = ec.region_id
    LEFT JOIN dim_secteur dsec ON dsec.secteur_code = ec.secteur_code
    WHERE ds.is_active = TRUE
    GROUP BY dr.region_name, dsec.secteur_label
),
classement AS (
    SELECT
        region_name,
        secteur_label,
        nb_entreprises,
        RANK() OVER (
            PARTITION BY region_name
            ORDER BY nb_entreprises DESC
        ) AS rang_region,
        ROUND(
            100.0 * nb_entreprises
            / SUM(nb_entreprises) OVER (PARTITION BY region_name),
            2
        ) AS part_region_pct
    FROM secteur_region
)
SELECT
    region_name,
    rang_region,
    secteur_label,
    nb_entreprises,
    part_region_pct
FROM classement
WHERE rang_region <= 5
ORDER BY region_name, rang_region, nb_entreprises DESC;

\echo '--- C2: Top 20 entreprises (approx.) par taille d effectif ---'
-- On decode cod_intval_emplo_que via stg_domaine_valeur
SELECT
    ec.neq,
    ec.nom_entreprise,
    ec.intervalle_employes_code,
    dv.val_dom_fran AS intervalle_employes_label,
    dr.region_name,
    ds.statut_label
FROM entreprise_clean ec
LEFT JOIN stg_domaine_valeur dv
    ON dv.typ_dom_val = 'INTVAL_EMPLO_QUE'
   AND dv.cod_dom_val = ec.intervalle_employes_code
LEFT JOIN dim_region dr ON dr.region_id = ec.region_id
LEFT JOIN dim_statut ds ON ds.statut_code = ec.statut_code
WHERE ec.intervalle_employes_code IS NOT NULL
ORDER BY
    CASE ec.intervalle_employes_code
        WHEN 'L' THEN 15
        WHEN 'K' THEN 14
        WHEN 'J' THEN 13
        WHEN 'I' THEN 12
        WHEN 'H' THEN 11
        WHEN 'G' THEN 10
        WHEN 'F' THEN 9
        WHEN 'E' THEN 8
        WHEN 'D' THEN 7
        WHEN 'C' THEN 6
        WHEN 'B' THEN 5
        WHEN 'A' THEN 4
        WHEN 'O' THEN 3
        WHEN 'N' THEN 2
        WHEN 'P' THEN 1
        ELSE 0
    END DESC,
    ec.nom_entreprise
LIMIT 20;

-- =========================================================
-- D) QUALITE / NETTOYAGE MESURABLE
-- =========================================================

\echo '--- D1: Nulls date de constitution (avant vs apres) ---'
SELECT
    'staging' AS etape,
    COUNT(*) AS total,
    COUNT(*) FILTER (
        WHERE NULLIF(TRIM(dat_consti), '') IS NULL
    ) AS date_constitution_null,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE NULLIF(TRIM(dat_consti), '') IS NULL) / COUNT(*),
        2
    ) AS pct_null
FROM stg_entreprise
UNION ALL
SELECT
    'clean' AS etape,
    COUNT(*) AS total,
    COUNT(*) FILTER (
        WHERE date_constitution IS NULL
    ) AS date_constitution_null,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE date_constitution IS NULL) / COUNT(*),
        2
    ) AS pct_null
FROM entreprise_clean;

\echo '--- D2: Repartition active vs non active (clean) ---'
SELECT
    CASE
        WHEN ds.is_active THEN 'active'
        ELSE 'non_active'
    END AS statut_business,
    COUNT(*) AS nb,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM entreprise_clean ec
JOIN dim_statut ds ON ds.statut_code = ec.statut_code
GROUP BY
    CASE
        WHEN ds.is_active THEN 'active'
        ELSE 'non_active'
    END
ORDER BY nb DESC;

\echo '=== FIN ANALYSE ==='