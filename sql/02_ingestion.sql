-- 02_ingestion.sql
-- Objectif: charger les CSV dans les tables staging + controles qualite de base

\echo '=== DEBUT INGESTION ==='
\timing on

-- 1) Rejouable: on vide les tables staging avant rechargement
TRUNCATE TABLE stg_entreprise, stg_etablissements, stg_nom, stg_domaine_valeur;

-- 2) Chargement des CSV (client-side avec \copy)
\copy stg_entreprise     FROM '/Users/paulyvanseka/Documents/projet sql/JeuDonnees/Entreprise.csv'     WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy stg_etablissements FROM '/Users/paulyvanseka/Documents/projet sql/JeuDonnees/Etablissements.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy stg_nom            FROM '/Users/paulyvanseka/Documents/projet sql/JeuDonnees/Nom.csv'            WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy stg_domaine_valeur FROM '/Users/paulyvanseka/Documents/projet sql/JeuDonnees/DomaineValeur.csv'  WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

-- 3) Controle volumetrie
\echo '=== VOLUMETRIE ==='
SELECT 'stg_entreprise' AS table_name, COUNT(*) AS nb_lignes FROM stg_entreprise
UNION ALL
SELECT 'stg_etablissements', COUNT(*) FROM stg_etablissements
UNION ALL
SELECT 'stg_nom', COUNT(*) FROM stg_nom
UNION ALL
SELECT 'stg_domaine_valeur', COUNT(*) FROM stg_domaine_valeur
ORDER BY table_name;

-- 4) Controle nulls sur cles critiques
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

-- 5) Controle doublons sur la table qui devrait etre 1 ligne par entreprise
\echo '=== DOUBLONS NEQ (stg_entreprise) ==='
SELECT COUNT(*) AS nb_neq_en_doublon
FROM (
    SELECT neq
    FROM stg_entreprise
    GROUP BY neq
    HAVING COUNT(*) > 1
) d;

-- 6) Controle distribution des statuts (utile pour la suite business)
\echo '=== DISTRIBUTION STATUTS ==='
SELECT cod_stat_immat, COUNT(*) AS nb
FROM stg_entreprise
GROUP BY cod_stat_immat
ORDER BY nb DESC;

\echo '=== FIN INGESTION ==='