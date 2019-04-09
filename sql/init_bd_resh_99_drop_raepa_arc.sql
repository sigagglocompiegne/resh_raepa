/*RAEPA V1.2*/
/*Revision et extension locale du squelette de la structure des données (table, séquence, trigger,...) du standard RAEPA */
/*init_bd_resh_99_drop_raepa_arc.sql */
/*PostGIS*/

/* GeoCompiegnois - http://geo.compiegnois.fr/ */
/* Auteur : Florent Vanhoutte */



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        DROP                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- vue
-- implémentation arc
DROP VIEW IF EXISTS x_opendata.xopendata_geo_v_raepa_canalaep_l;
DROP VIEW IF EXISTS x_opendata.xopendata_geo_v_raepa_canalass_l;
DROP VIEW IF EXISTS x_opendata.xopendata_geo_v_raepa_apparaep_p;
DROP VIEW IF EXISTS x_opendata.xopendata_geo_v_raepa_apparass_p;
DROP VIEW IF EXISTS x_opendata.xopendata_geo_v_raepa_ouvraep_p;
DROP VIEW IF EXISTS x_opendata.xopendata_geo_v_raepa_ouvrass_p;
DROP VIEW IF EXISTS x_opendata.xopendata_geo_v_raepa_reparaep_p;
DROP VIEW IF EXISTS x_opendata.xopendata_geo_v_raepa_reparass_p;

-- fkey
-- implémentation arc
ALTER TABLE IF EXISTS m_reseau_humide.an_raepa_metadonnees DROP CONSTRAINT IF EXISTS lt_raepa_qualite_anpose_fkey;
ALTER TABLE IF EXISTS m_reseau_humide.an_raepa_metadonnees DROP CONSTRAINT IF EXISTS lt_raepa_qualite_geoloc_xy_fkey;
ALTER TABLE IF EXISTS m_reseau_humide.an_raepa_metadonnees DROP CONSTRAINT IF EXISTS lt_raepa_qualite_geoloc_z_fkey;
ALTER TABLE IF EXISTS m_reseau_humide.geo_raepa_canal DROP CONSTRAINT IF EXISTS lt_raepa_materiau_fkey;
ALTER TABLE IF EXISTS m_reseau_humide.geo_raepa_canal DROP CONSTRAINT IF EXISTS lt_raepa_mode_circulation_fkey;
ALTER TABLE IF EXISTS m_reseau_humide.an_raepa_canalaep DROP CONSTRAINT IF EXISTS lt_raepa_cat_canal_ae_fkey;
ALTER TABLE IF EXISTS m_reseau_humide.an_raepa_canalaep DROP CONSTRAINT IF EXISTS lt_raepa_fonc_canal_ae_fkey;
ALTER TABLE IF EXISTS m_reseau_humide.an_raepa_canalass DROP CONSTRAINT IF EXISTS lt_raepa_cat_reseau_ass_fkey;
ALTER TABLE IF EXISTS m_reseau_humide.an_raepa_canalass DROP CONSTRAINT IF EXISTS lt_raepa_cat_canal_ass_fkey;
ALTER TABLE IF EXISTS m_reseau_humide.an_raepa_canalass DROP CONSTRAINT IF EXISTS lt_raepa_fonc_canal_ass_fkey;
ALTER TABLE IF EXISTS m_reseau_humide.an_raepa_apparaep DROP CONSTRAINT IF EXISTS lt_raepa_cat_app_ae_fkey;
ALTER TABLE IF EXISTS m_reseau_humide.an_raepa_apparass DROP CONSTRAINT IF EXISTS lt_raepa_cat_reseau_ass_fkey;
ALTER TABLE IF EXISTS m_reseau_humide.an_raepa_apparass DROP CONSTRAINT IF EXISTS lt_raepa_cat_app_ass_fkey;
ALTER TABLE IF EXISTS m_reseau_humide.an_raepa_ouvraep DROP CONSTRAINT IF EXISTS lt_raepa_cat_ouv_ae_fkey;
ALTER TABLE IF EXISTS m_reseau_humide.an_raepa_ouvrass DROP CONSTRAINT IF EXISTS lt_raepa_cat_reseau_ass_fkey;
ALTER TABLE IF EXISTS m_reseau_humide.an_raepa_ouvrass DROP CONSTRAINT IF EXISTS lt_raepa_cat_ouv_ass_fkey;
ALTER TABLE IF EXISTS m_reseau_humide.geo_raepa_repar DROP CONSTRAINT IF EXISTS lt_raepa_support_incident_fkey;
ALTER TABLE IF EXISTS m_reseau_humide.geo_raepa_repar DROP CONSTRAINT IF EXISTS lt_raepa_defaillance_fkey;

-- classe
-- implementation arc
DROP TABLE IF EXISTS m_reseau_humide.an_raepa_metadonnees;
DROP TABLE IF EXISTS m_reseau_humide.geo_raepa_canal;
DROP TABLE IF EXISTS m_reseau_humide.an_raepa_canalaep;
DROP TABLE IF EXISTS m_reseau_humide.an_raepa_canalass;
DROP TABLE IF EXISTS m_reseau_humide.geo_raepa_noeud;
DROP TABLE IF EXISTS m_reseau_humide.an_raepa_appar;
DROP TABLE IF EXISTS m_reseau_humide.an_raepa_apparaep;
DROP TABLE IF EXISTS m_reseau_humide.an_raepa_apparass;
DROP TABLE IF EXISTS m_reseau_humide.an_raepa_ouvr;
DROP TABLE IF EXISTS m_reseau_humide.an_raepa_ouvraep;
DROP TABLE IF EXISTS m_reseau_humide.an_raepa_ouvrass;
DROP TABLE IF EXISTS m_reseau_humide.geo_raepa_repar;

-- domaine de valeur
-- implementation arc
DROP TABLE IF EXISTS m_reseau_humide.lt_raepa_materiau;
DROP TABLE IF EXISTS m_reseau_humide.lt_raepa_mode_circulation;
DROP TABLE IF EXISTS m_reseau_humide.lt_raepa_qualite_anpose;
DROP TABLE IF EXISTS m_reseau_humide.lt_raepa_qualite_geoloc;
DROP TABLE IF EXISTS m_reseau_humide.lt_raepa_support_incident;
DROP TABLE IF EXISTS m_reseau_humide.lt_raepa_defaillance;
DROP TABLE IF EXISTS m_reseau_humide.lt_raepa_cat_canal_ae;
DROP TABLE IF EXISTS m_reseau_humide.lt_raepa_fonc_canal_ae;
DROP TABLE IF EXISTS m_reseau_humide.lt_raepa_cat_app_ae;
DROP TABLE IF EXISTS m_reseau_humide.lt_raepa_cat_ouv_ae;
DROP TABLE IF EXISTS m_reseau_humide.lt_raepa_cat_reseau_ass;
DROP TABLE IF EXISTS m_reseau_humide.lt_raepa_cat_canal_ass;
DROP TABLE IF EXISTS m_reseau_humide.lt_raepa_fonc_canal_ass;
DROP TABLE IF EXISTS m_reseau_humide.lt_raepa_cat_app_ass;
DROP TABLE IF EXISTS m_reseau_humide.lt_raepa_cat_ouv_ass;
-- extention arc
DROP TABLE IF EXISTS m_reseau_humide.lt_raepa_materiau2;
DROP TABLE IF EXISTS m_reseau_humide.lt_raepa_forme_canal;

-- sequence
-- implementation arc
DROP SEQUENCE IF EXISTS m_reseau_humide.raepa_idraepa_seq;
DROP SEQUENCE IF EXISTS m_reseau_humide.raepa_idrepar_seq;
