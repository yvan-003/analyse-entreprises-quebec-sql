-- 01_schema.sql
-- Projet REQ - Etape 1: definir le schema (staging + analytique)

BEGIN;

-- 0) Rejouable: on supprime les objets si ils existent deja
DROP TABLE IF EXISTS entreprise_clean CASCADE;
DROP TABLE IF EXISTS dim_region CASCADE;
DROP TABLE IF EXISTS dim_secteur CASCADE;
DROP TABLE IF EXISTS dim_statut CASCADE;
DROP TABLE IF EXISTS stg_domaine_valeur CASCADE;
DROP TABLE IF EXISTS stg_nom CASCADE;
DROP TABLE IF EXISTS stg_etablissements CASCADE;
DROP TABLE IF EXISTS stg_entreprise CASCADE;

-- 1) Staging tables: brut, colonnes en TEXT pour eviter les erreurs d import
CREATE TABLE stg_entreprise (
    neq TEXT,
    ind_fail TEXT,
    dat_immat TEXT,
    cod_regim_juri TEXT,
    cod_intval_emplo_que TEXT,
    dat_cess_prevu TEXT,
    cod_stat_immat TEXT,
    cod_forme_juri TEXT,
    dat_stat_immat TEXT,
    cod_regim_juri_consti TEXT,
    dat_depo_declr TEXT,
    an_decl TEXT,
    an_prod TEXT,
    dat_limit_prod TEXT,
    an_prod_pre TEXT,
    dat_limit_prod_pre TEXT,
    dat_maj_index_nom TEXT,
    cod_act_econ_cae TEXT,
    no_act_econ_assuj TEXT,
    desc_act_econ_assuj TEXT,
    cod_act_econ_cae2 TEXT,
    no_act_econ_assuj2 TEXT,
    desc_act_econ_assuj2 TEXT,
    nom_loclt_consti TEXT,
    dat_consti TEXT,
    ind_conven_unmn_actnr TEXT,
    ind_ret_tout_pouvr TEXT,
    ind_limit_resp TEXT,
    dat_deb_resp TEXT,
    dat_fin_resp TEXT,
    objet_soc TEXT,
    no_mtr_volont TEXT,
    adr_domcl_adr_disp TEXT,
    adr_domcl_lign1_adr TEXT,
    adr_domcl_lign2_adr TEXT,
    adr_domcl_lign3_adr TEXT,
    adr_domcl_lign4_adr TEXT
);

CREATE TABLE stg_etablissements (
    neq TEXT,
    no_suf_etab TEXT,
    ind_etab_princ TEXT,
    ind_salon_bronz TEXT,
    ind_vente_tabac_detl TEXT,
    ind_disp TEXT,
    lign1_adr TEXT,
    lign2_adr TEXT,
    lign3_adr TEXT,
    lign4_adr TEXT,
    cod_act_econ TEXT,
    desc_act_econ_etab TEXT,
    no_act_econ_etab TEXT,
    cod_act_econ2 TEXT,
    desc_act_econ_etab2 TEXT,
    no_act_econ_etab2 TEXT,
    nom_etab TEXT
);

CREATE TABLE stg_nom (
    neq TEXT,
    nom_assuj TEXT,
    nom_assuj_lang_etrng TEXT,
    stat_nom TEXT,
    typ_nom_assuj TEXT,
    dat_init_nom_assuj TEXT,
    dat_fin_nom_assuj TEXT
);

CREATE TABLE stg_domaine_valeur (
    typ_dom_val TEXT,
    cod_dom_val TEXT,
    val_dom_fran TEXT
);

-- 2) Dimensions analytiques
CREATE TABLE dim_statut (
    statut_code TEXT PRIMARY KEY,
    statut_label TEXT NOT NULL,
    is_active BOOLEAN NOT NULL
);

CREATE TABLE dim_secteur (
    secteur_code TEXT PRIMARY KEY,
    secteur_label TEXT NOT NULL
);

-- Dans le MVP, region_name viendra de nom_loclt_consti 
CREATE TABLE dim_region (
    region_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    region_name TEXT NOT NULL UNIQUE
);

-- 3) Table analytique centrale
CREATE TABLE entreprise_clean (
    neq TEXT PRIMARY KEY,
    nom_entreprise TEXT,
    statut_code TEXT NOT NULL REFERENCES dim_statut(statut_code),
    secteur_code TEXT REFERENCES dim_secteur(secteur_code),
    region_id BIGINT REFERENCES dim_region(region_id),
    date_constitution DATE,
    age_entreprise INTEGER,
    intervalle_employes_code TEXT,
    forme_juridique_code TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 4) Index de base (jointures + filtres frequents)
CREATE INDEX idx_stg_nom_neq ON stg_nom(neq);
CREATE INDEX idx_stg_etablissements_neq ON stg_etablissements(neq);
CREATE INDEX idx_stg_entreprise_neq ON stg_entreprise(neq);

CREATE INDEX idx_entreprise_clean_statut ON entreprise_clean(statut_code);
CREATE INDEX idx_entreprise_clean_secteur ON entreprise_clean(secteur_code);
CREATE INDEX idx_entreprise_clean_region ON entreprise_clean(region_id);
CREATE INDEX idx_entreprise_clean_date_constitution ON entreprise_clean(date_constitution);

COMMIT;
