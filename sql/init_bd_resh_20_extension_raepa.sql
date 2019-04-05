/*RAEPA V1.2*/
/*Implémentation locale du RAEPA et extension de la structure des données (table, séquence, trigger,...) sur la base du pivot du standard RAEPA */
/*init_bd_resh_20_extension_raepa.sql */
/*PostGIS*/

/* GeoCompiegnois - http://geo.compiegnois.fr/ */
/* Auteur : Florent Vanhoutte */



/*
Principe : ne pas altérer les attributs ou liste mais ajouter des attributs, voir recréer le même attribut avec une liste adaptée.
Cela permettra de garantir à la fois une livraison RAEPA et une livraison adaptative RAEPA étendu
*/


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      RENOMMER                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- vue

ALTER VIEW IF EXISTS m_reseau_humide.raepa_canalaep_l RENAME TO geo_v_raepa_canalaep_l;
ALTER VIEW IF EXISTS m_reseau_humide.raepa_canalass_l RENAME TO geo_v_raepa_canalass_l;
ALTER VIEW IF EXISTS m_reseau_humide.raepa_apparaep_p RENAME TO geo_v_raepa_apparaep_p;
ALTER VIEW IF EXISTS m_reseau_humide.raepa_apparass_p RENAME TO geo_v_raepa_apparass_p;
ALTER VIEW IF EXISTS m_reseau_humide.raepa_ouvraep_p RENAME TO geo_v_raepa_ouvraep_p;
ALTER VIEW IF EXISTS m_reseau_humide.raepa_ouvrass_p RENAME TO geo_v_raepa_ouvrass_p;
ALTER VIEW IF EXISTS m_reseau_humide.raepa_reparaep_p RENAME TO geo_v_raepa_reparaep_p;
ALTER VIEW IF EXISTS m_reseau_humide.raepa_reparass_p RENAME TO geo_v_raepa_reparass_p;


-- fkey

ALTER TABLE m_reseau_humide.raepa_metadonnees RENAME CONSTRAINT val_raepa_qualite_anpose_fkey TO lt_raepa_qualite_anpose_fkey;
ALTER TABLE m_reseau_humide.raepa_metadonnees RENAME CONSTRAINT val_raepa_qualite_geoloc_xy_fkey TO lt_raepa_qualite_geoloc_xy_fkey;
ALTER TABLE m_reseau_humide.raepa_metadonnees RENAME CONSTRAINT val_raepa_qualite_geoloc_z_fkey TO lt_raepa_qualite_geoloc_z_fkey;
ALTER TABLE m_reseau_humide.raepa_canal RENAME CONSTRAINT val_raepa_materiau_fkey TO lt_raepa_materiau_fkey;
ALTER TABLE m_reseau_humide.raepa_canal RENAME CONSTRAINT val_raepa_mode_circulation_fkey TO lt_raepa_mode_circulation_fkey;
ALTER TABLE m_reseau_humide.raepa_canalaep RENAME CONSTRAINT val_raepa_cat_canal_ae_fkey TO lt_raepa_cat_canal_ae_fkey;
ALTER TABLE m_reseau_humide.raepa_canalaep RENAME CONSTRAINT val_raepa_fonc_canal_ae_fkey TO lt_raepa_fonc_canal_ae_fkey;
ALTER TABLE m_reseau_humide.raepa_canalass RENAME CONSTRAINT val_raepa_cat_reseau_ass_fkey TO lt_raepa_cat_reseau_ass_fkey;
ALTER TABLE m_reseau_humide.raepa_canalass RENAME CONSTRAINT val_raepa_cat_canal_ass_fkey TO lt_raepa_cat_canal_ass_fkey;
ALTER TABLE m_reseau_humide.raepa_canalass RENAME CONSTRAINT val_raepa_fonc_canal_ass_fkey TO lt_raepa_fonc_canal_ass_fkey;
ALTER TABLE m_reseau_humide.raepa_apparaep RENAME CONSTRAINT val_raepa_cat_app_ae_fkey TO lt_raepa_cat_app_ae_fkey;
ALTER TABLE m_reseau_humide.raepa_apparass RENAME CONSTRAINT val_raepa_cat_reseau_ass_fkey TO lt_raepa_cat_reseau_ass_fkey;
ALTER TABLE m_reseau_humide.raepa_apparass RENAME CONSTRAINT val_raepa_cat_app_ass_fkey TO lt_raepa_cat_app_ass_fkey;
ALTER TABLE m_reseau_humide.raepa_ouvraep RENAME CONSTRAINT val_raepa_cat_ouv_ae_fkey TO lt_raepa_cat_ouv_ae_fkey;
ALTER TABLE m_reseau_humide.raepa_ouvrass RENAME CONSTRAINT val_raepa_cat_reseau_ass_fkey TO lt_raepa_cat_reseau_ass_fkey;
ALTER TABLE m_reseau_humide.raepa_ouvrass RENAME CONSTRAINT val_raepa_cat_ouv_ass_fkey TO lt_raepa_cat_ouv_ass_fkey;
ALTER TABLE m_reseau_humide.raepa_repar RENAME CONSTRAINT val_raepa_support_incident_fkey TO lt_raepa_support_incident_fkey;
ALTER TABLE m_reseau_humide.raepa_repar RENAME CONSTRAINT val_raepa_defaillance_fkey TO lt_raepa_defaillance_fkey;


-- classe

ALTER TABLE IF EXISTS m_reseau_humide.raepa_metadonnees RENAME TO an_raepa_metadonnees;
ALTER TABLE IF EXISTS m_reseau_humide.raepa_canal RENAME TO geo_raepa_canal;
ALTER TABLE IF EXISTS m_reseau_humide.raepa_canalaep RENAME TO an_raepa_canalaep;
ALTER TABLE IF EXISTS m_reseau_humide.raepa_canalass RENAME TO an_raepa_canalass;
ALTER TABLE IF EXISTS m_reseau_humide.raepa_noeud RENAME TO geo_raepa_noeud;
ALTER TABLE IF EXISTS m_reseau_humide.raepa_appar RENAME TO an_raepa_appar;
ALTER TABLE IF EXISTS m_reseau_humide.raepa_apparaep RENAME TO an_raepa_apparaep;
ALTER TABLE IF EXISTS m_reseau_humide.raepa_apparass RENAME TO an_raepa_apparass;
ALTER TABLE IF EXISTS m_reseau_humide.raepa_ouvr RENAME TO an_raepa_ouvr;
ALTER TABLE IF EXISTS m_reseau_humide.raepa_ouvraep RENAME TO an_raepa_ouvraep;
ALTER TABLE IF EXISTS m_reseau_humide.raepa_ouvrass RENAME TO an_raepa_ouvrass;
ALTER TABLE IF EXISTS m_reseau_humide.raepa_repar RENAME TO geo_raepa_repar;

-- domaine de valeur

ALTER TABLE IF EXISTS m_reseau_humide.val_raepa_materiau RENAME TO lt_raepa_materiau;
ALTER TABLE IF EXISTS m_reseau_humide.val_raepa_mode_circulation RENAME TO lt_raepa_mode_circulation;
ALTER TABLE IF EXISTS m_reseau_humide.val_raepa_qualite_anpose RENAME TO lt_raepa_qualite_anpose;
ALTER TABLE IF EXISTS m_reseau_humide.val_raepa_qualite_geoloc RENAME TO lt_raepa_qualite_geoloc;
ALTER TABLE IF EXISTS m_reseau_humide.val_raepa_support_incident RENAME TO lt_raepa_support_incident;
ALTER TABLE IF EXISTS m_reseau_humide.val_raepa_defaillance RENAME TO lt_raepa_defaillance;
ALTER TABLE IF EXISTS m_reseau_humide.val_raepa_cat_canal_ae RENAME TO lt_raepa_cat_canal_ae;
ALTER TABLE IF EXISTS m_reseau_humide.val_raepa_fonc_canal_ae RENAME TO lt_raepa_fonc_canal_ae;
ALTER TABLE IF EXISTS m_reseau_humide.val_raepa_cat_app_ae RENAME TO lt_raepa_cat_app_ae;
ALTER TABLE IF EXISTS m_reseau_humide.val_raepa_cat_ouv_ae RENAME TO lt_raepa_cat_ouv_ae;
ALTER TABLE IF EXISTS m_reseau_humide.val_raepa_cat_reseau_ass RENAME TO lt_raepa_cat_reseau_ass;
ALTER TABLE IF EXISTS m_reseau_humide.val_raepa_cat_canal_ass RENAME TO lt_raepa_cat_canal_ass;
ALTER TABLE IF EXISTS m_reseau_humide.val_raepa_fonc_canal_ass RENAME TO lt_raepa_fonc_canal_ass;
ALTER TABLE IF EXISTS m_reseau_humide.val_raepa_cat_app_ass RENAME TO lt_raepa_cat_app_ass;
ALTER TABLE IF EXISTS m_reseau_humide.val_raepa_cat_ouv_ass RENAME TO lt_raepa_cat_ouv_ass;

-- sequence

ALTER SEQUENCE IF EXISTS m_reseau_humide.raepa_idraepa RENAME TO raepa_idraepa_seq;
ALTER SEQUENCE IF EXISTS m_reseau_humide.raepa_idrepar RENAME TO raepa_idrepar_seq;




-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                    COMMENTAIRES                                                              ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- domaine de valeur

-- lt_raepa_qualite_geoloc

UPDATE m_reseau_humide.lt_raepa_qualite_geoloc SET definition = 'Classe de précision supérieure à 1,50 m ou précision inconnue' WHERE code = '03'; -- précision que si la qualite de geoloc n'est pas connue, alors on classe en C


/*



*/
