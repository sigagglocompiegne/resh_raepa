/*RAEPA V1.2*/
/*Implémentation locale du RAEPA et extension de la structure des données (table, séquence, trigger,...) sur la base du pivot du standard RAEPA */
/*init_bd_resh_20_extension_raepa.sql */
/*PostGIS*/

/* GeoCompiegnois - http://geo.compiegnois.fr/ */
/* Auteur : Florent Vanhoutte */

/*
Principe : ne pas altérer le standard, mais ajouter des classes, attributs modifiés ou étendus en conséquence pour éviter une perte d'information entre le SI des exploitants et celui de la collectivité.
Cela permet de garantir à la fois une livraison RAEPA et des livrables complémentaires pour les échanges locaux.
*/


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      RENOMMER                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- vue

ALTER VIEW IF EXISTS raepa.raepa_canalaep_l SET SCHEMA x_opendata;
ALTER VIEW IF EXISTS x_opendata.raepa_canalaep_l RENAME TO xopendata_geo_v_raepa_canalaep_l; 
ALTER VIEW IF EXISTS raepa.raepa_canalass_l SET SCHEMA x_opendata;
ALTER VIEW IF EXISTS x_opendata.raepa_canalass_l RENAME TO xopendata_geo_v_raepa_canalass_l;
ALTER VIEW IF EXISTS raepa.raepa_apparaep_p SET SCHEMA x_opendata;
ALTER VIEW IF EXISTS x_opendata.raepa_apparaep_p RENAME TO xopendata_geo_v_raepa_apparaep_p;
ALTER VIEW IF EXISTS raepa.raepa_apparass_p SET SCHEMA x_opendata;
ALTER VIEW IF EXISTS x_opendata.raepa_apparass_p RENAME TO xopendata_geo_v_raepa_apparass_p;
ALTER VIEW IF EXISTS raepa.raepa_ouvraep_p SET SCHEMA x_opendata;
ALTER VIEW IF EXISTS x_opendata.raepa_ouvraep_p RENAME TO xopendata_geo_v_raepa_ouvraep_p;
ALTER VIEW IF EXISTS raepa.raepa_ouvraep_p SET SCHEMA x_opendata;
ALTER VIEW IF EXISTS x_opendata.raepa_ouvraep_p RENAME TO xopendata_geo_v_raepa_ouvraep_p;
ALTER VIEW IF EXISTS raepa.raepa_ouvrass_p SET SCHEMA x_opendata;
ALTER VIEW IF EXISTS x_opendata.raepa_ouvrass_p RENAME TO xopendata_geo_v_raepa_ouvrass_p;
ALTER VIEW IF EXISTS raepa.raepa_ouvrass_p SET SCHEMA x_opendata;
ALTER VIEW IF EXISTS x_opendata.raepa_ouvrass_p RENAME TO xopendata_geo_v_raepa_ouvrass_p;
ALTER VIEW IF EXISTS raepa.raepa_reparaep_p SET SCHEMA x_opendata;
ALTER VIEW IF EXISTS x_opendata.raepa_reparaep_p RENAME TO xopendata_geo_v_raepa_reparaep_p;
ALTER VIEW IF EXISTS raepa.raepa_reparass_p SET SCHEMA x_opendata;
ALTER VIEW IF EXISTS x_opendata.raepa_reparass_p RENAME TO xopendata_geo_v_raepa_reparass_p;


-- fkey

ALTER TABLE raepa.raepa_metadonnees RENAME CONSTRAINT val_raepa_qualite_anpose_fkey TO lt_raepa_qualite_anpose_fkey;
ALTER TABLE raepa.raepa_metadonnees RENAME CONSTRAINT val_raepa_qualite_geoloc_xy_fkey TO lt_raepa_qualite_geoloc_xy_fkey;
ALTER TABLE raepa.raepa_metadonnees RENAME CONSTRAINT val_raepa_qualite_geoloc_z_fkey TO lt_raepa_qualite_geoloc_z_fkey;
ALTER TABLE raepa.raepa_canal RENAME CONSTRAINT val_raepa_materiau_fkey TO lt_raepa_materiau_fkey;
ALTER TABLE raepa.raepa_canal RENAME CONSTRAINT val_raepa_mode_circulation_fkey TO lt_raepa_mode_circulation_fkey;
ALTER TABLE raepa.raepa_canalaep RENAME CONSTRAINT val_raepa_cat_canal_ae_fkey TO lt_raepa_cat_canal_ae_fkey;
ALTER TABLE raepa.raepa_canalaep RENAME CONSTRAINT val_raepa_fonc_canal_ae_fkey TO lt_raepa_fonc_canal_ae_fkey;
ALTER TABLE raepa.raepa_canalass RENAME CONSTRAINT val_raepa_cat_reseau_ass_fkey TO lt_raepa_cat_reseau_ass_fkey;
ALTER TABLE raepa.raepa_canalass RENAME CONSTRAINT val_raepa_cat_canal_ass_fkey TO lt_raepa_cat_canal_ass_fkey;
ALTER TABLE raepa.raepa_canalass RENAME CONSTRAINT val_raepa_fonc_canal_ass_fkey TO lt_raepa_fonc_canal_ass_fkey;
ALTER TABLE raepa.raepa_apparaep RENAME CONSTRAINT val_raepa_cat_app_ae_fkey TO lt_raepa_cat_app_ae_fkey;
ALTER TABLE raepa.raepa_apparass RENAME CONSTRAINT val_raepa_cat_reseau_ass_fkey TO lt_raepa_cat_reseau_ass_fkey;
ALTER TABLE raepa.raepa_apparass RENAME CONSTRAINT val_raepa_cat_app_ass_fkey TO lt_raepa_cat_app_ass_fkey;
ALTER TABLE raepa.raepa_ouvraep RENAME CONSTRAINT val_raepa_cat_ouv_ae_fkey TO lt_raepa_cat_ouv_ae_fkey;
ALTER TABLE raepa.raepa_ouvrass RENAME CONSTRAINT val_raepa_cat_reseau_ass_fkey TO lt_raepa_cat_reseau_ass_fkey;
ALTER TABLE raepa.raepa_ouvrass RENAME CONSTRAINT val_raepa_cat_ouv_ass_fkey TO lt_raepa_cat_ouv_ass_fkey;
ALTER TABLE raepa.raepa_repar RENAME CONSTRAINT val_raepa_support_incident_fkey TO lt_raepa_support_incident_fkey;
ALTER TABLE raepa.raepa_repar RENAME CONSTRAINT val_raepa_defaillance_fkey TO lt_raepa_defaillance_fkey;


-- classe

ALTER TABLE IF EXISTS raepa.raepa_metadonnees RENAME TO an_raepa_metadonnees;
ALTER TABLE IF EXISTS raepa.raepa_canal RENAME TO geo_raepa_canal;
ALTER TABLE IF EXISTS raepa.raepa_canalaep RENAME TO an_raepa_canalaep;
ALTER TABLE IF EXISTS raepa.raepa_canalass RENAME TO an_raepa_canalass;
ALTER TABLE IF EXISTS raepa.raepa_noeud RENAME TO geo_raepa_noeud;
ALTER TABLE IF EXISTS raepa.raepa_appar RENAME TO an_raepa_appar;
ALTER TABLE IF EXISTS raepa.raepa_apparaep RENAME TO an_raepa_apparaep;
ALTER TABLE IF EXISTS raepa.raepa_apparass RENAME TO an_raepa_apparass;
ALTER TABLE IF EXISTS raepa.raepa_ouvr RENAME TO an_raepa_ouvr;
ALTER TABLE IF EXISTS raepa.raepa_ouvraep RENAME TO an_raepa_ouvraep;
ALTER TABLE IF EXISTS raepa.raepa_ouvrass RENAME TO an_raepa_ouvrass;
ALTER TABLE IF EXISTS raepa.raepa_repar RENAME TO geo_raepa_repar;

-- domaine de valeur

ALTER TABLE IF EXISTS raepa.val_raepa_materiau RENAME TO lt_raepa_materiau;
ALTER TABLE IF EXISTS raepa.val_raepa_mode_circulation RENAME TO lt_raepa_mode_circulation;
ALTER TABLE IF EXISTS raepa.val_raepa_qualite_anpose RENAME TO lt_raepa_qualite_anpose;
ALTER TABLE IF EXISTS raepa.val_raepa_qualite_geoloc RENAME TO lt_raepa_qualite_geoloc;
ALTER TABLE IF EXISTS raepa.val_raepa_support_incident RENAME TO lt_raepa_support_incident;
ALTER TABLE IF EXISTS raepa.val_raepa_defaillance RENAME TO lt_raepa_defaillance;
ALTER TABLE IF EXISTS raepa.val_raepa_cat_canal_ae RENAME TO lt_raepa_cat_canal_ae;
ALTER TABLE IF EXISTS raepa.val_raepa_fonc_canal_ae RENAME TO lt_raepa_fonc_canal_ae;
ALTER TABLE IF EXISTS raepa.val_raepa_cat_app_ae RENAME TO lt_raepa_cat_app_ae;
ALTER TABLE IF EXISTS raepa.val_raepa_cat_ouv_ae RENAME TO lt_raepa_cat_ouv_ae;
ALTER TABLE IF EXISTS raepa.val_raepa_cat_reseau_ass RENAME TO lt_raepa_cat_reseau_ass;
ALTER TABLE IF EXISTS raepa.val_raepa_cat_canal_ass RENAME TO lt_raepa_cat_canal_ass;
ALTER TABLE IF EXISTS raepa.val_raepa_fonc_canal_ass RENAME TO lt_raepa_fonc_canal_ass;
ALTER TABLE IF EXISTS raepa.val_raepa_cat_app_ass RENAME TO lt_raepa_cat_app_ass;
ALTER TABLE IF EXISTS raepa.val_raepa_cat_ouv_ass RENAME TO lt_raepa_cat_ouv_ass;

-- sequence

ALTER SEQUENCE IF EXISTS raepa.raepa_idraepa RENAME TO raepa_idraepa_seq;
ALTER SEQUENCE IF EXISTS raepa.raepa_idrepar RENAME TO raepa_idrepar_seq;


-- schema

ALTER SCHEMA raepa RENAME TO m_raepa;


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                    COMMENTAIRES                                                              ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- domaine de valeur

-- lt_raepa_qualite_geoloc

UPDATE m_raepa.lt_raepa_qualite_geoloc
  SET definition = 'Classe de précision supérieure à 1,50 m ou précision inconnue' WHERE code = '03'; -- précision que si la qualite de geoloc n'est pas connue, alors on classe en C



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                DOMAINES DE VALEURS                                                           ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- ###################
-- ##    AEP/ASS    ##
-- ################### 


-- création d'un nouveau domaine de valeur pour la gestion des matériaux et intégrant l'appariemment avec le domaine correspondant dans le standard RAEPA

-- Table: m_raepa.lt_raepa_materiau2

-- DROP TABLE m_raepa.lt_raepa_materiau2;


CREATE TABLE m_raepa.lt_raepa_materiau2
(
  code character varying(5) NOT NULL,
  code_open character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT raepa_materiau2_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepa_materiau2
  IS 'Matériau constitutif des tuyaux composant une canalisation';
COMMENT ON COLUMN m_raepa.lt_raepa_materiau2.code IS 'Code de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation';
COMMENT ON COLUMN m_raepa.lt_raepa_materiau2.code_open IS 'Equivalence du code au standard RAEPA pour la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation';
COMMENT ON COLUMN m_raepa.lt_raepa_materiau2.valeur IS 'Valeur de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation';
COMMENT ON COLUMN m_raepa.lt_raepa_materiau2.definition IS 'Définition de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation';

INSERT INTO m_raepa.lt_raepa_materiau2(
            code, code_open, valeur, definition)
    VALUES
('00-00','00','Indéterminé','Canalisation composée de tuyaux dont le matériau est inconnu'),
('01-00','01','Acier','Canalisation composée de tuyaux d''acier'),
('02-00','02','Amiante-ciment','Canalisation composée de tuyaux d''amiante-ciment'),
('03-00','99','Béton','Canalisation composée de tuyaux de béton'),
('03-01','03','Béton âme tôle','Canalisation composée de tuyaux de béton âme tôle'),
('03-02','04','Béton armé','Canalisation composée de tuyaux de béton armé'),
('03-03','05','Béton fibré','Canalisation composée de tuyaux de béton fibré'),
('03-04','06','Béton non armé','Canalisation composée de tuyaux de béton non armé'),
('03-99','99','Béton autre','Canalisation composée de tuyaux de béton d''un autre type'),
('04-00','07','Cuivre','Canalisation composée de tuyaux de cuivre'),
('05-00','99','Fibre','Canalisation composée de tuyaux de fibre'),
('05-01','08','Fibre ciment','Canalisation composée de tuyaux de fibre ciment'),
('05-02','09','Fibre de verre','Canalisation composée de tuyaux de fibre de verre'),
('05-03','10','Fibrociment','Canalisation composée de tuyaux de fibrociment'),
('05-99','99','Fibre autre','Canalisation composée de tuyaux de fibre d''un autre type'),
('06-00','99','Fonte','Canalisation composée de tuyaux de fonte'),
('06-01','11','Fonte ductile','Canalisation composée de tuyaux de fonte ductile'),
('06-02','12','Fonte grise','Canalisation composée de tuyaux de fonte grise'),
('06-99','99','Fonte autre','Canalisation composée de tuyaux de fonte d''un autre type'),
('07-00','13','Grès','Canalisation composée de tuyaux de grès'),
('08-00','14','Maçonné','Canalisation maçonnée'),
('09-00','15','Meulière','Canalisation construite en pierre meulière'),    -- voir si meulière est à considérer comme un sous type de maçonnée ou pas,
('10-00','99','PE','Canalisation composée de tuyaux de polyéthylène'),
('10-10','16','PEBD','Canalisation composée de tuyaux de polyéthylène basse densité'),
('10-20','99','PEHD','Canalisation composée de tuyaux de polyéthylène haute densité'),
('10-21','17','PEHD annelé','Canalisation composée de tuyaux de polyéthylène haute densité annelés'),
('10-22','18','PEHD lisse','Canalisation composée de tuyaux de polyéthylène haute densité lisses'),
('10-99','99','PE autre','Canalisation composée de tuyaux de polyéthylène d''un autre type'),
('11-00','19','Plomb','Canalisation composée de tuyaux de plomb'),
('12-00','99','PP','Canalisation composée de tuyaux de polypropylène'),
('12-01','20','PP annelé','Canalisation composée de tuyaux de polypropylène annelés'),
('12-02','21','PP lisse','Canalisation composée de tuyaux de polypropylène lisses'),
('12-99','99','PP autre','Canalisation composée de tuyaux de polypropylène d''un autre type'),
('13-00','99','PRV','Canalisation composée de polyester renforcé de fibre de verre'),
('13-01','22','PRV A','Canalisation composée de polyester renforcé de fibre de verre (série A)'),
('13-02','23','PRV B','Canalisation composée de polyester renforcé de fibre de verre (série B)'),
('13-99','99','PRV autre','Canalisation composée de tuyaux de polyester renforcé de fibre de verre d''un autre type'),
('14-00','99','PVC','Canalisation composée de tuyaux de polychlorure de vinyle'),
('14-10','24','PVC ancien','Canalisation composée de tuyaux de polychlorure de vinyle posés avant 1980'),
('14-20','25','PVC BO','Canalisation composée de tuyaux de polychlorure de vinyle bi-orienté'),
('14-30','99','PVC U','Canalisation composée de tuyaux de polychlorure de vinyle rigide'),
('14-31','26','PVC U annelé','Canalisation composée de tuyaux de polychlorure de vinyle rigide annelés'),
('14-32','27','PVC U lisse','Canalisation composée de tuyaux de polychlorure de vinyle rigide lisses'),
('14-99','99','PVC autre','Canalisation composée de tuyaux de polychlorure de vinyle d''un autre type'),
('15-00','99','Tôle','Canalisation construite en tôle'),
('15-01','28','Tôle galvanisée','Canalisation construite en tôle galvanisée'),
('15-99','99','Tôle autre','Canalisation construite en tôle d''un autre type'),
('99-00','99','Autre','Canalisation composée de tuyaux dont le matériau ne figure pas dans la liste ci-dessus');


-- création d'un nouveau domaine de valeur pour gérer la forme de la section de la canalisation

-- Table: m_raepa.lt_raepa_forme_canal

-- DROP TABLE m_raepa.lt_raepa_forme_canal;

CREATE TABLE m_raepa.lt_raepa_forme_canal
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT raepa_forme_canal_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepa_forme_canal
  IS 'Forme de la section d''une canalisation d''eau';
COMMENT ON COLUMN m_raepa.lt_raepa_forme_canal.code IS 'Code de la liste énumérée relative au type de forme de la section d''une canalisation d''eau';
COMMENT ON COLUMN m_raepa.lt_raepa_forme_canal.valeur IS 'Valeur de la liste énumérée relative au type de forme de la section d''une canalisation d''eau';
COMMENT ON COLUMN m_raepa.lt_raepa_forme_canal.definition IS 'Définition de la liste énumérée relative au type de forme de la section d''une canalisation d''eau';

INSERT INTO m_raepa.lt_raepa_forme_canal(
            code, valeur, definition)
    VALUES
('00','Indéterminé','Type de forme d''une section de canalisation inconnu'),
('01','Circulaire','Forme de la section de la canalisation circulaire'),
('02','Ovoïde','Forme de la section de la canalisation en ovoïde'),
('03','Dalot','Forme de la section de la canalisation en dalot'),
('99','Autre','Forme de la section de la canalisation dont le type ne figure pas dans la liste ci-dessus');



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                  CLASSE OBJET                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################



-- #################################################################### CLASSE CANALISATION ###############################################

ALTER TABLE m_raepa.geo_raepa_canal
  ADD COLUMN materiau2 character varying(5) NOT NULL DEFAULT '00-00', -- nouveau domaine de valeur adapté pour une saisie d'un type et d'un sosu-type de matériau,
  ADD COLUMN forme character varying(2) NOT NULL DEFAULT '00', -- ajout d'un attribut commun AEP/ASS pour décrire la forme de la section d'une canalisation
  ADD COLUMN zgensup numeric(6,2); -- ajout d'un attribut commun AEP/ASS pour obtenir la côte NGF moyenne sur le troncon de canalisation de la génératrice supérieure (idéalement, il faudrait plutôt des points de détection sur une longueur importante du segment de canalisation)

COMMENT ON COLUMN m_raepa.geo_raepa_canal.materiau2 IS 'Matériau de la canalisation';  
COMMENT ON COLUMN m_raepa.geo_raepa_canal.forme IS 'Forme de la section de la canalisation';  
COMMENT ON COLUMN m_raepa.geo_raepa_canal.zgensup IS 'Côte NGF moyennne de la génératrice supérieure';


-- #################################################################### CLASSE NOEUD ###############################################

ALTER TABLE m_raepa.geo_raepa_noeud
  ADD COLUMN symbole character varying(254), -- ajout d'un attribut commun AEP/ASS pour gérer le symbole à utiliser pour la représentation cartographique, celui-ci dépend du type/ss type d'ouvrage/appareillage
  ADD COLUMN angle numeric(5,2) NOT NULL DEFAULT 0; -- ajout d'un attribut commun AEP/ASS pour gérer l'angle de rotation du symbole ponctuel utilisé pour la représentation
 
COMMENT ON COLUMN m_raepa.geo_raepa_noeud.symbole IS 'Symbole utilisé pour la représentation cartographique';  
COMMENT ON COLUMN m_raepa.geo_raepa_noeud.angle IS 'Angle en degré décimaux utilisé pour la rotation du symbole';  


/*



*/
