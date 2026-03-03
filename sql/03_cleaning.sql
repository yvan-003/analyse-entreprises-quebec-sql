-- 03_cleaning.sql
-- Objectif: transformer les donnees staging en donnees analytiques.

-- TODO: normaliser texte (trim, case)
-- TODO: harmoniser statut (active / radiee)
-- TODO: nettoyer champs geo (ville/region/code postal) si disponible
-- TODO: gerer nulls critiques avec regles explicites
-- TODO: creer age_entreprise
-- TODO: creer classes d age (0-2, 3-5, 6-10, 10+)

-- Bonnes pratiques:
-- - Utiliser CTE pour clarifier les etapes.
-- - Documenter chaque regle metier en commentaire court.
