-- 03_cleaning.sql
-- Construction couche analytique

\echo '=== DEBUT CLEANING ==='
\timing on

BEGIN;

-- Reset analytique
TRUNCATE TABLE entreprise_clean;
TRUNCATE TABLE dim_region, dim_secteur, dim_statut RESTART IDENTITY CASCADE;

-- Ajout colonne age_classe (si absente)
ALTER TABLE entreprise_clean
ADD COLUMN IF NOT EXISTS age_classe TEXT;

-- Dimension statut
INSERT INTO dim_statut (statut_code, statut_label, is_active)
SELECT DISTINCT
    TRIM(cod_dom_val) AS statut_code,
    TRIM(val_dom_fran) AS statut_label,
    CASE WHEN TRIM(cod_dom_val) = 'IM' THEN TRUE ELSE FALSE END AS is_active
FROM stg_domaine_valeur
WHERE TRIM(typ_dom_val) = 'STAT_IMMAT'
  AND NULLIF(TRIM(cod_dom_val), '') IS NOT NULL;

-- Fallback statut
INSERT INTO dim_statut (statut_code, statut_label, is_active)
VALUES ('UNK', 'Statut inconnu', FALSE)
ON CONFLICT (statut_code) DO NOTHING;

-- Dimension secteur
INSERT INTO dim_secteur (secteur_code, secteur_label)
SELECT DISTINCT
    TRIM(cod_dom_val) AS secteur_code,
    TRIM(val_dom_fran) AS secteur_label
FROM stg_domaine_valeur
WHERE TRIM(typ_dom_val) = 'ACT_ECON'
  AND NULLIF(TRIM(cod_dom_val), '') IS NOT NULL;

-- Fallback secteur
INSERT INTO dim_secteur (secteur_code, secteur_label)
VALUES ('UNK', 'Secteur inconnu')
ON CONFLICT (secteur_code) DO NOTHING;

-- Dimension region
INSERT INTO dim_region (region_name)
SELECT DISTINCT
    UPPER(TRIM(nom_loclt_consti)) AS region_name
FROM stg_entreprise
WHERE NULLIF(TRIM(nom_loclt_consti), '') IS NOT NULL;

-- Fallback region
INSERT INTO dim_region (region_name)
VALUES ('[INCONNUE]')
ON CONFLICT (region_name) DO NOTHING;

-- Build entreprise_clean
WITH nom_priorise AS (
    SELECT
        TRIM(neq) AS neq,
        TRIM(nom_assuj) AS nom_assuj,
        stat_nom,
        typ_nom_assuj,
        NULLIF(TRIM(dat_init_nom_assuj), '') AS dat_init_nom_assuj,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(neq)
            ORDER BY
                CASE WHEN stat_nom = 'V' THEN 0 ELSE 1 END,
                CASE
                    WHEN typ_nom_assuj = 'M' THEN 0
                    WHEN typ_nom_assuj = 'N' THEN 1
                    ELSE 2
                END,
                NULLIF(TRIM(dat_init_nom_assuj), '') DESC
        ) AS rn
    FROM stg_nom
    WHERE NULLIF(TRIM(neq), '') IS NOT NULL
      AND NULLIF(TRIM(nom_assuj), '') IS NOT NULL
),
nom_final AS (
    SELECT neq, nom_assuj AS nom_entreprise
    FROM nom_priorise
    WHERE rn = 1
),
entreprise_preparee AS (
    SELECT
        TRIM(e.neq) AS neq,
        COALESCE(NULLIF(TRIM(e.cod_stat_immat), ''), 'UNK') AS statut_code,
        COALESCE(NULLIF(TRIM(e.cod_act_econ_cae), ''), 'UNK') AS secteur_code_raw,
        COALESCE(NULLIF(UPPER(TRIM(e.nom_loclt_consti)), ''), '[INCONNUE]') AS region_name,
        CASE
            WHEN NULLIF(TRIM(e.dat_consti), '') ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
            THEN TRIM(e.dat_consti)::DATE
            ELSE NULL
        END AS date_constitution,
        NULLIF(TRIM(e.cod_intval_emplo_que), '') AS intervalle_employes_code,
        NULLIF(TRIM(e.cod_forme_juri), '') AS forme_juridique_code
    FROM stg_entreprise e
    WHERE NULLIF(TRIM(e.neq), '') IS NOT NULL
),
entreprise_enrichie AS (
    SELECT
        ep.neq,
        COALESCE(nf.nom_entreprise, '[NOM_INCONNU]') AS nom_entreprise,
        CASE WHEN ds.statut_code IS NULL THEN 'UNK' ELSE ep.statut_code END AS statut_code,
        CASE WHEN dsec.secteur_code IS NULL THEN 'UNK' ELSE ep.secteur_code_raw END AS secteur_code,
        dr.region_id,
        ep.date_constitution,
        ep.intervalle_employes_code,
        ep.forme_juridique_code
    FROM entreprise_preparee ep
    LEFT JOIN nom_final nf ON nf.neq = ep.neq
    LEFT JOIN dim_statut ds ON ds.statut_code = ep.statut_code
    LEFT JOIN dim_secteur dsec ON dsec.secteur_code = ep.secteur_code_raw
    LEFT JOIN dim_region dr ON dr.region_name = ep.region_name
)
INSERT INTO entreprise_clean (
    neq,
    nom_entreprise,
    statut_code,
    secteur_code,
    region_id,
    date_constitution,
    age_entreprise,
    age_classe,
    intervalle_employes_code,
    forme_juridique_code
)
SELECT
    ee.neq,
    ee.nom_entreprise,
    ee.statut_code,
    ee.secteur_code,
    ee.region_id,
    ee.date_constitution,
    CASE
        WHEN ee.date_constitution IS NOT NULL AND ee.date_constitution <= CURRENT_DATE
        THEN DATE_PART('year', AGE(CURRENT_DATE, ee.date_constitution))::INT
        ELSE NULL
    END AS age_entreprise,
    CASE
        WHEN ee.date_constitution IS NULL THEN NULL
        WHEN DATE_PART('year', AGE(CURRENT_DATE, ee.date_constitution)) < 0 THEN NULL
        WHEN DATE_PART('year', AGE(CURRENT_DATE, ee.date_constitution)) <= 2 THEN '0-2'
        WHEN DATE_PART('year', AGE(CURRENT_DATE, ee.date_constitution)) <= 5 THEN '3-5'
        WHEN DATE_PART('year', AGE(CURRENT_DATE, ee.date_constitution)) <= 10 THEN '6-10'
        ELSE '10+'
    END AS age_classe,
    ee.intervalle_employes_code,
    ee.forme_juridique_code
FROM entreprise_enrichie ee;

COMMIT;

-- Checks post-cleaning
\echo '=== CONTROLES CLEANING ==='
SELECT COUNT(*) AS nb_entreprises_clean FROM entreprise_clean;

SELECT statut_code, COUNT(*) AS nb
FROM entreprise_clean
GROUP BY statut_code
ORDER BY nb DESC;

SELECT age_classe, COUNT(*) AS nb
FROM entreprise_clean
GROUP BY age_classe
ORDER BY age_classe;

\echo '=== FIN CLEANING ==='
