-- 02_ingestion.sql
-- Chargement CSV + checks de base

\echo '=== DEBUT INGESTION ==='
\timing on

-- Reset staging
TRUNCATE TABLE stg_entreprise, stg_etablissements, stg_nom, stg_domaine_valeur;

-- Load CSV
\copy stg_entreprise     FROM '/Users/paulyvanseka/Documents/projet sql/JeuDonnees/Entreprise.csv'     WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy stg_etablissements FROM '/Users/paulyvanseka/Documents/projet sql/JeuDonnees/Etablissements.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy stg_nom            FROM '/Users/paulyvanseka/Documents/projet sql/JeuDonnees/Nom.csv'            WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy stg_domaine_valeur FROM '/Users/paulyvanseka/Documents/projet sql/JeuDonnees/DomaineValeur.csv'  WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

-- Row counts
\echo '=== VOLUMETRIE ==='
SELECT 'stg_entreprise' AS table_name, COUNT(*) AS nb_lignes FROM stg_entreprise
UNION ALL
SELECT 'stg_etablissements', COUNT(*) FROM stg_etablissements
UNION ALL
SELECT 'stg_nom', COUNT(*) FROM stg_nom
UNION ALL
SELECT 'stg_domaine_valeur', COUNT(*) FROM stg_domaine_valeur
ORDER BY table_name;

-- Nulls sur cles
\echo '=== NULLS CRITIQUES ==='
SELECT 'stg_entreprise.neq_null' AS check_name, COUNT(*) AS nb
FROM stg_entreprise
WHERE NULLIF(TRIM(neq), '') IS NULL
UNION ALL
SELECT 'stg_nom.neq_null', COUNT(*)
FROM stg_nom
WHERE NULLIF(TRIM(neq), '') IS NULL
UNION ALL
SELECT 'stg_etablissements.neq_null', COUNT(*)
FROM stg_etablissements
WHERE NULLIF(TRIM(neq), '') IS NULL;

-- Doublons NEQ
\echo '=== DOUBLONS NEQ (stg_entreprise) ==='
SELECT COUNT(*) AS nb_neq_en_doublon
FROM (
    SELECT neq
    FROM stg_entreprise
    GROUP BY neq
    HAVING COUNT(*) > 1
) d;

-- Distribution statuts
\echo '=== DISTRIBUTION STATUTS ==='
SELECT cod_stat_immat, COUNT(*) AS nb
FROM stg_entreprise
GROUP BY cod_stat_immat
ORDER BY nb DESC;

\echo '=== FIN INGESTION ==='
