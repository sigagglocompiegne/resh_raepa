/*RAEPA V1.2*/
/*Creation du squelette de la structure des données (table, séquence, trigger,...) 
au standard RAEPA, adapté pour répondre à tous types de réseaux */
/*init_bd_resh_10_standard_raepa.sql */
/*PostGIS*/

/* GeoCompiegnois - http://geo.compiegnois.fr/ */
/* Auteurs : Florent Vanhoutte, Léandre Béron  */



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        DROP                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

--vue
DROP VIEW IF EXISTS raepa.raepa_canalaep_l;
DROP VIEW IF EXISTS raepa.raepa_canalass_l;
DROP VIEW IF EXISTS raepa.raepa_apparaep_p;
DROP VIEW IF EXISTS raepa.raepa_apparass_p;
DROP VIEW IF EXISTS raepa.raepa_ouvraep_p;
DROP VIEW IF EXISTS raepa.raepa_ouvrass_p;
DROP VIEW IF EXISTS raepa.raepa_reparaep_p;
DROP VIEW IF EXISTS raepa.raepa_reparass_p;

-- fkey

ALTER TABLE IF EXISTS raepa.raepa_metadonnees DROP CONSTRAINT IF EXISTS val_raepa_qualite_anpose_fkey;
ALTER TABLE IF EXISTS raepa.raepa_metadonnees DROP CONSTRAINT IF EXISTS val_raepa_qualite_geoloc_xy_fkey;
ALTER TABLE IF EXISTS raepa.raepa_metadonnees DROP CONSTRAINT IF EXISTS val_raepa_qualite_geoloc_z_fkey;
ALTER TABLE IF EXISTS raepa.raepa_canal DROP CONSTRAINT IF EXISTS val_raepa_materiau_fkey;
ALTER TABLE IF EXISTS raepa.raepa_canal DROP CONSTRAINT IF EXISTS val_raepa_mode_circulation_fkey;
ALTER TABLE IF EXISTS raepa.raepa_canalaep DROP CONSTRAINT IF EXISTS val_raepa_cat_canal_ae_fkey;
ALTER TABLE IF EXISTS raepa.raepa_canalaep DROP CONSTRAINT IF EXISTS val_raepa_fonc_canal_ae_fkey;
ALTER TABLE IF EXISTS raepa.raepa_canalass DROP CONSTRAINT IF EXISTS val_raepa_cat_reseau_ass_fkey;
ALTER TABLE IF EXISTS raepa.raepa_canalass DROP CONSTRAINT IF EXISTS val_raepa_cat_canal_ass_fkey;
ALTER TABLE IF EXISTS raepa.raepa_canalass DROP CONSTRAINT IF EXISTS val_raepa_fonc_canal_ass_fkey;
ALTER TABLE IF EXISTS raepa.raepa_noeud DROP CONSTRAINT IF EXISTS val_raepa_id_canamont_fkey;
ALTER TABLE IF EXISTS raepa.raepa_noeud DROP CONSTRAINT IF EXISTS val_raepa_id_canaval_fkey;
ALTER TABLE IF EXISTS raepa.raepa_noeud DROP CONSTRAINT IF EXISTS val_raepa_id_canppale_fkey;
 
ALTER TABLE IF EXISTS raepa.raepa_apparaep DROP CONSTRAINT IF EXISTS val_raepa_cat_app_ae_fkey;
ALTER TABLE IF EXISTS raepa.raepa_apparass DROP CONSTRAINT IF EXISTS val_raepa_cat_reseau_ass_fkey;
ALTER TABLE IF EXISTS raepa.raepa_apparass DROP CONSTRAINT IF EXISTS val_raepa_fonc_app_ass_fkey;
ALTER TABLE IF EXISTS raepa.raepa_ouvraep DROP CONSTRAINT IF EXISTS val_raepa_fonc_ouv_ae_fkey;
ALTER TABLE IF EXISTS raepa.raepa_ouvrass DROP CONSTRAINT IF EXISTS val_raepa_cat_reseau_ass_fkey;
ALTER TABLE IF EXISTS raepa.raepa_ouvrass DROP CONSTRAINT IF EXISTS val_raepa_fonc_ouv_ass_fkey;
ALTER TABLE IF EXISTS raepa.raepa_repar DROP CONSTRAINT IF EXISTS val_raepa_support_incident_fkey;
ALTER TABLE IF EXISTS raepa.raepa_repar DROP CONSTRAINT IF EXISTS val_raepa_defaillance_fkey;

--suppression des fkey rajoutés sur la classe raepa_metadonnees, pour répondre au lien entre les informations de l'objet et la géométrie associée
ALTER TABLE IF EXISTS raepa.raepa_appar DROP CONSTRAINT IF EXISTS val_raepa_idnoeud_fkey;
ALTER TABLE IF EXISTS raepa.raepa_metadonnees DROP CONSTRAINT IF EXISTS val_raepa_idcana_fkey;
ALTER TABLE IF EXISTS raepa.raepa_metadonnees DROP CONSTRAINT IF EXISTS val_raepa_idnoeud_fkey;

ALTER TABLE IF EXISTS raepa.raepa_repar DROP CONSTRAINT IF EXISTS val_raepa_idouvrage_fkey;





-- classe
DROP TABLE IF EXISTS raepa.raepa_objet; --classe initialement appelé metadonnées, mais qui n'était pas nommé de manière pertinente

DROP TABLE IF EXISTS raepa.raepa_repar;

DROP TABLE IF EXISTS raepa.raepa_troncon;
DROP TABLE IF EXISTS raepa.raepa_canal;
DROP TABLE IF EXISTS raepa.raepa_canalaep;
DROP TABLE IF EXISTS raepa.raepa_canalass;

DROP TABLE IF EXISTS raepa.raepa_noeud;
DROP TABLE IF EXISTS raepa.raepa_appar;
DROP TABLE IF EXISTS raepa.raepa_apparaep;
DROP TABLE IF EXISTS raepa.raepa_apparass;
DROP TABLE IF EXISTS raepa.raepa_ouvr;
DROP TABLE IF EXISTS raepa.raepa_ouvraep;
DROP TABLE IF EXISTS raepa.raepa_ouvrass;




-- domaine de valeur
DROP TABLE IF EXISTS raepa.val_raepa_materiau ;
DROP TABLE IF EXISTS raepa.val_raepa_mode_circulation;

DROP TABLE IF EXISTS raepa.val_raepa_cat_canal_ae;
DROP TABLE IF EXISTS raepa.val_raepa_fonc_canal_ae; 
DROP TABLE IF EXISTS raepa.val_raepa_fonc_app_ae;
DROP TABLE IF EXISTS raepa.val_raepa_fonc_ouv_ae;

DROP TABLE IF EXISTS raepa.val_raepa_typ_reseau_ass;
DROP TABLE IF EXISTS raepa.val_raepa_cat_canal_ass;
DROP TABLE IF EXISTS raepa.val_raepa_fonc_canal_ass;
DROP TABLE IF EXISTS raepa.val_raepa_fonc_app_ass;
DROP TABLE IF EXISTS raepa.val_raepa_fonc_ouv_ass;


DROP TABLE IF EXISTS raepa.val_raepa_type_defaillance;
DROP TABLE IF EXISTS raepa.val_raepa_support_reparation;

DROP TABLE IF EXISTS raepa.val_raepa_qualite_geoloc;
DROP TABLE IF EXISTS raepa.val_raepa_qualite_anpose;


-- sequence
DROP SEQUENCE IF EXISTS raepa.raepa_idraepa;
DROP SEQUENCE IF EXISTS raepa.raepa_idrepar;
DROP SEQUENCE IF EXISTS raepa.raepa_idgeom;


-- schema
DROP SCHEMA IF EXISTS raepa;
 


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                       SCHEMA                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################
  
CREATE SCHEMA raepa;

COMMENT ON SCHEMA raepa
  IS 'Réseaux humides au standard RAEPA';

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                DOMAINES DE VALEURS                                                           ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################





-- ##############################################################
-- ##                          AEP/ASS                         ##
-- ############################################################## 
/* correspond au listes de valeurs des attributs en liens avec les classes AEP et ASS */



--###################################   MATERIAU   #########################################################################
-- Table: raepa.val_raepa_materiau

-- DROP TABLE raepa.val_raepa_materiau;


CREATE TABLE raepa.val_raepa_materiau
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT raepa_materiau_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.val_raepa_materiau
  IS 'Matériau constitutif des tuyaux composant une canalisation';
COMMENT ON COLUMN raepa.val_raepa_materiau.code IS 'Code de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation';
COMMENT ON COLUMN raepa.val_raepa_materiau.valeur IS 'Valeur de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation';
COMMENT ON COLUMN raepa.val_raepa_materiau.definition IS 'Définition de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation';

INSERT INTO raepa.val_raepa_materiau(
            code, valeur, definition)
    VALUES
('00','Indéterminé','Canalisation composée de tuyaux dont le matériau est inconnu'),
('01','Acier','Canalisation composée de tuyaux d''acier'),
('02','Amiante-ciment','Canalisation composée de tuyaux d''amiante-ciment'),
('03','Béton âme tôle','Canalisation composée de tuyaux de béton âme tôle'),
('04','Béton armé','Canalisation composée de tuyaux de béton armé'),
('05','Béton fibré','Canalisation composée de tuyaux de béton fibré'),
('06','Béton non armé','Canalisation composée de tuyaux de béton non armé'),
('07','Cuivre','Canalisation composée de tuyaux de cuivre'),
('08','Fibre ciment','Canalisation composée de tuyaux de fibre ciment'),
('09','Fibre de verre','Canalisation composée de tuyaux de fibre de verre'),
('10','Fibrociment','Canalisation composée de tuyaux de fibrociment'),
('11','Fonte ductile','Canalisation composée de tuyaux de fonte ductile'),
('12','Fonte grise','Canalisation composée de tuyaux de fonte grise'),
('13','Grès','Canalisation composée de tuyaux de grès'),
('14','Maçonné','Canalisation maçonnée'),
('15','Meulière','Canalisation construite en pierre meulière'),
('16','PEBD','Canalisation composée de tuyaux de polyéthylène basse densité'),
('17','PEHD annelé','Canalisation composée de tuyaux de polyéthylène haute densité annelés'),
('18','PEHD lisse','Canalisation composée de tuyaux de polyéthylène haute densité lisses'),
('19','Plomb','Canalisation composée de tuyaux de plomb'),
('20','PP annelé','Canalisation composée de tuyaux de polypropylène annelés'),
('21','PP lisse','Canalisation composée de tuyaux de polypropylène lisses'),
('22','PRV A','Canalisation composée de polyester renforcé de fibre de verre (série A)'),
('23','PRV B','Canalisation composée de polyester renforcé de fibre de verre (série B)'),
('24','PVC ancien','Canalisation composée de tuyaux de polychlorure de vinyle posés avant 1980'),
('25','PVC BO','Canalisation composée de tuyaux de polychlorure de vinyle bi-orienté'),
('26','PVC U annelé','Canalisation composée de tuyaux de polychlorure de vinyle rigide annelés'),
('27','PVC U lisse','Canalisation composée de tuyaux de polychlorure de vinyle rigide lisses'),
('28','Tôle galvanisée','Canalisation construite en tôle galvanisée'),
('99','Autre','Canalisation composée de tuyaux dont le matériau ne figure pas dans la liste ci-dessus');




--###################################   MODE CIRCULATION          ######################################################################
-- Table: raepa.val_raepa_mode_circulation

-- DROP TABLE raepa.val_raepa_mode_circulation;

CREATE TABLE raepa.val_raepa_mode_circulation
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT raepa_mode_circulation_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.val_raepa_mode_circulation
  IS 'Modalité de circulation de l''eau dans une canalisation';
COMMENT ON COLUMN raepa.val_raepa_mode_circulation.code IS 'Code de la liste énumérée relative au mode de circualtion de l''eau dans une canalisation';
COMMENT ON COLUMN raepa.val_raepa_mode_circulation.valeur IS 'Valeur de la liste énumérée relative au mode de circualtion de l''eau dans une canalisation';
COMMENT ON COLUMN raepa.val_raepa_mode_circulation.definition IS 'Définition de la liste énumérée relative au mode de circualtion de l''eau dans une canalisation';

INSERT INTO raepa.val_raepa_mode_circulation(
            code, valeur, definition)
    VALUES
('00','Indéterminé','Mode de circulation inconnu'),
('01','Gravitaire','L''eau s''écoule par l''effet de la pesanteur dans la canalisation en pente'),
('02','Forcé','L''eau circule sous pression dans la canalisation grâce à un système de pompage'),
('03','Sous-vide','L''eau circule par l''effet de la mise sous vide de la canalisation par une centrale d''aspiration'),
('99','Autre','L''eau circule tantôt dans un des modes ci-dessus tantôt dans un autre');







-- ###################
-- ##      AEP      ##
-- ################### 
/* correspond au listes de valeurs des attributs en liens avec la classe AEP */




--###################################   CATEGORIE CANALISATION AE         ######################################################################
-- Table: raepa.val_raepa_cat_canal_ae

-- DROP TABLE raepa.val_raepa_cat_canal_ae;

CREATE TABLE raepa.val_raepa_cat_canal_ae
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT raepa_cat_canal_ae_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.val_raepa_cat_canal_ae
  IS 'Nature des eaux véhiculées par une canalisation d''adduction d''eau';
COMMENT ON COLUMN raepa.val_raepa_cat_canal_ae.code IS 'Code de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''adduction d''eau';
COMMENT ON COLUMN raepa.val_raepa_cat_canal_ae.valeur IS 'Valeur de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''adduction d''eau';
COMMENT ON COLUMN raepa.val_raepa_cat_canal_ae.definition IS 'Définition de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''adduction d''eau';

INSERT INTO raepa.val_raepa_cat_canal_ae(
            code, valeur, definition)
    VALUES
('00','Indéterminée','Nature des eaux véhiculées par la canalisation inconnue'),
('01','Eau brute','Canalisation véhiculant de l''eau brute'),
('02','Eau potable','Canalisation véhiculant de l''eau potable'),
('99','Autre','Canalisation véhiculant tantôt de l''eau brute, tantôt de l''eau potable');





--###################################   FONCTION CANALISATION AE          ######################################################################
-- Table: raepa.val_raepa_fonc_canal_ae

-- DROP TABLE raepa.val_raepa_fonc_canal_ae;

CREATE TABLE raepa.val_raepa_fonc_canal_ae
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT raepa_fonc_canal_ae_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.val_raepa_fonc_canal_ae
  IS 'Fonction dans le réseau d''une canalisation d''adduction d''eau';
COMMENT ON COLUMN raepa.val_raepa_fonc_canal_ae.code IS 'Code de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''adduction d''eau';
COMMENT ON COLUMN raepa.val_raepa_fonc_canal_ae.valeur IS 'Valeur de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''adduction d''eau';
COMMENT ON COLUMN raepa.val_raepa_fonc_canal_ae.definition IS 'Définition de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''adduction d''eau';

INSERT INTO raepa.val_raepa_fonc_canal_ae(
            code, valeur, definition)
    VALUES
('00','Indéterminée','Fonction de la canalisation dans le réseau inconnue'),
('01','Transport','Canalisation de transport'),
('02','Distribution','Canalisation de distribution'),
('99','Autre','Canalisation dont la fonction dans le réseau ne figure pas dans la liste ci-dessus');




--###################################   APPAREILLAGE AE TYPE          ######################################################################
-- Table: raepa.val_raepa_fonc_app_ae

-- DROP TABLE raepa.val_raepa_fonc_app_ae;

CREATE TABLE raepa.val_raepa_fonc_app_ae                     
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT raepa_fonc_app_ae_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.val_raepa_fonc_app_ae
  IS 'Type d''un appareillage d''adduction d''eau';
COMMENT ON COLUMN raepa.val_raepa_fonc_app_ae.code IS 'Code de la liste énumérée relative au type d''un appareillage d''adduction d''eau';
COMMENT ON COLUMN raepa.val_raepa_fonc_app_ae.valeur IS 'Valeur de la liste énumérée relative au type d''un appareillage d''adduction d''eau';
COMMENT ON COLUMN raepa.val_raepa_fonc_app_ae.definition IS 'Définition de la liste énumérée relative au type d''un appareillage d''adduction d''eau';

INSERT INTO raepa.val_raepa_fonc_app_ae(
            code, valeur, definition)
    VALUES
('00','Indéterminé','Type d''appareillage inconnu'),
('01','Point de branchement','Piquage de branchement individuel'),
('02','Ventouse','Ventouse d''adduction d''eau'),
('03','Vanne','Vanne d''adduction d''eau'),
('04','Vidange','Vidange d''adduction d''eau'),
('05','Régulateur de pression','Régulateur de pression'),
('06','Hydrant','Poteau de défense contre l''incendie'),
('07','Compteur','Appareil de mesure des volumes transités'),
('08','Débitmètre','Appareil de mesure des débits transit'),
('99','Autre','Appareillage dont le type ne figure pas dans la liste ci-dessus');





--###################################   OUVRAGE AE TYPE          ######################################################################
-- Table: raepa.val_raepa_fonc_ouv_ae

-- DROP TABLE raepa.val_raepa_fonc_ouv_ae;

CREATE TABLE raepa.val_raepa_fonc_ouv_ae
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT raepa_cat_ouv_ae_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.val_raepa_fonc_ouv_ae
  IS 'Type d''un ouvrage d''adduction d''eau';
COMMENT ON COLUMN raepa.val_raepa_fonc_ouv_ae.code IS 'Code de la liste énumérée relative au type d''un ouvrage d''adduction d''eau';
COMMENT ON COLUMN raepa.val_raepa_fonc_ouv_ae.valeur IS 'Valeur de la liste énumérée relative au type d''un ouvrage d''adduction d''eau';
COMMENT ON COLUMN raepa.val_raepa_fonc_ouv_ae.definition IS 'Définition de la liste énumérée relative au type d''un ouvrage d''adduction d''eau';

INSERT INTO raepa.val_raepa_fonc_ouv_ae(
            code, valeur, definition)
    VALUES
('00','Indéterminé','Type d''ouvrage inconnu'),
('01','Station de pompage','Station de pompage d''eau potable'),
('02','Station de traitement','Station de traitement d''eau potable'),
('03','Réservoir','Réservoir d''eau potable'),
('04','Chambre de comptage','Chambre de comptage'),
('05','Captage','Captage'),
('99','Autre','Ouvrage dont le type ne figure pas dans la liste ci-dessus');






-- ###################
-- ##      ASS      ##
-- ###################
/* correspond au listes de valeurs des attributs en liens avec la classe ASS */ 

--###################################   CATEGORIE CANALISATION ASS          ################################################################
-- Table: raepa.val_raepa_cat_canal_ass

-- DROP TABLE raepa.val_raepa_cat_canal_ass;

CREATE TABLE raepa.val_raepa_cat_canal_ass
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT raepa_cat_canal_ass_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);


COMMENT ON TABLE raepa.val_raepa_cat_canal_ass
  IS 'Nature des eaux véhiculées par une canalisation d''assainissement collectif';
COMMENT ON COLUMN raepa.val_raepa_cat_canal_ass.code IS 'Code de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''assainissement collectif';
COMMENT ON COLUMN raepa.val_raepa_cat_canal_ass.valeur IS 'Valeur de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''assainissement collectif';
COMMENT ON COLUMN raepa.val_raepa_cat_canal_ass.definition IS 'Définition de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''assainissement collectif';

INSERT INTO raepa.val_raepa_cat_canal_ass(
            code, valeur, definition)
    VALUES
('00','Indéterminée','Nature des eaux véhiculées par la canalisation inconnue'),
('01','Eaux pluviales','Canalisation véhiculant des eaux pluviales'),
('02','Eaux usées','Canalisation véhiculant des eaux usées'),
('03','Unitaire','Canalisation véhiculant des eaux usées et pluviales en fonctionnement normal'),
('99','Autre','Canalisation véhiculant tantôt des eaux pluviales, tantôt des eaux usées');



--###################################   FONCTION CANALISATION ASS          #################################################################
-- Table: raepa.val_raepa_fonc_canal_ass

-- DROP TABLE raepa.val_raepa_fonc_canal_ass;

CREATE TABLE raepa.val_raepa_fonc_canal_ass
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT raepa_fonc_canal_ass_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.val_raepa_fonc_canal_ass
  IS 'Fonction dans le réseau d''une canalisation d''assainissement collectif';
COMMENT ON COLUMN raepa.val_raepa_fonc_canal_ass.code IS 'Code de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''assainissement collectif';
COMMENT ON COLUMN raepa.val_raepa_fonc_canal_ass.valeur IS 'Valeur de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''assainissement collectif';
COMMENT ON COLUMN raepa.val_raepa_fonc_canal_ass.definition IS 'Définition de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''assainissement collectif';

INSERT INTO raepa.val_raepa_fonc_canal_ass(
            code, valeur, definition)
    VALUES
('00','Indéterminée','Fonction de la canalisation dans le réseau inconnue'),
('01','Transport','Canalisation de transport'),
('02','Collecte','Canalisation de collecte'),
('99','Autre','Canalisation dont la fonction dans le réseau ne figure pas dans la liste ci-dessus');



--###################################   TYPE RESEAU ASS (mais aussi utilisé dans autres classes)   #########################################
-- Table: raepa.val_raepa_typ_reseau_ass

-- DROP TABLE raepa.val_raepa_typ_reseau_ass;

CREATE TABLE raepa.val_raepa_typ_reseau_ass
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT raepa_cat_reseau_ass_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);


COMMENT ON TABLE raepa.val_raepa_typ_reseau_ass
  IS 'Type de réseau d''assainissement collectif';
COMMENT ON COLUMN raepa.val_raepa_typ_reseau_ass.code IS 'Code de la liste énumérée relative au type de réseau d''assainissement collectif';
COMMENT ON COLUMN raepa.val_raepa_typ_reseau_ass.valeur IS 'Valeur de la liste énumérée relative au type de réseau d''assainissement collectif';
COMMENT ON COLUMN raepa.val_raepa_typ_reseau_ass.definition IS 'Définition de la liste énumérée relative au type de réseau d''assainissement collectif';

INSERT INTO raepa.val_raepa_typ_reseau_ass(
            code, valeur, definition)
    VALUES
('01','Pluvial','Réseau de collecte de seules eaux pluviales'),
('02','Eaux usées','Réseau de collecte de seules eaux usées'),
('03','Unitaire','Réseau de collecte des eaux usées et des eaux pluviales');

--###################################   APPAREILLAGE ASS TYPE         ######################################################################
-- Table: raepa.val_raepa_fonc_app_ass

-- DROP TABLE raepa.val_raepa_fonc_app_ass;

CREATE TABLE raepa.val_raepa_fonc_app_ass
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT raepa_fonc_app_ass_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.val_raepa_fonc_app_ass
  IS 'Type d''un appareillage d''assainissement collectif';
COMMENT ON COLUMN raepa.val_raepa_fonc_app_ass.code IS 'Code de la liste énumérée relative au type d''un appareillage d''assainissement collectif';
COMMENT ON COLUMN raepa.val_raepa_fonc_app_ass.valeur IS 'Valeur de la liste énumérée relative au type d''un appareillage d''assainissement collectif';
COMMENT ON COLUMN raepa.val_raepa_fonc_app_ass.definition IS 'Définition de la liste énumérée relative au type d''un appareillage d''assainissement collectif';

INSERT INTO raepa.val_raepa_fonc_app_ass(
            code, valeur, definition)
    VALUES
('00','Indéterminé','Type d''appareillage inconnu'),
('01','Point de branchement','Piquage de branchement individuel'),
('02','Ventouse','Ventouse d''assainissement'),
('03','Vanne','Vanne d''assainissement'),
('04','Débitmètre','Appareil de mesure des débits transités'),
('99','Autre','Appareillage dont le type ne figure pas dans la liste ci-dessus');



--###################################   OUVRAGE ASS TYPE          ##########################################################################
-- Table: raepa.val_raepa_fonc_ouv_ass

-- DROP TABLE raepa.val_raepa_fonc_ouv_ass;

CREATE TABLE raepa.val_raepa_fonc_ouv_ass
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT raepa_fonc_ouv_ass_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.val_raepa_fonc_ouv_ass
  IS 'Type d''un ouvrage d''assainissement collectif';
COMMENT ON COLUMN raepa.val_raepa_fonc_ouv_ass.code IS 'Code de la liste énumérée relative au type d''un ouvrage d''assainissement collectif';
COMMENT ON COLUMN raepa.val_raepa_fonc_ouv_ass.valeur IS 'Valeur de la liste énumérée relative au type d''un ouvrage d''assainissement collectif';
COMMENT ON COLUMN raepa.val_raepa_fonc_ouv_ass.definition IS 'Définition de la liste énumérée relative au type d''un ouvrage d''assainissement collectif';

INSERT INTO raepa.val_raepa_fonc_ouv_ass(
            code, valeur, definition)
    VALUES
('00','Indéterminé','Type d''ouvrage inconnu'),
('01','Station de pompage','Station de pompage d''eaux usées et/ou pluviales'),
('02','Station d''épuration','Station de traitement d''eaux usées'),
('03','Bassin de stockage','Ouvrage de stockage d''eaux usées et/ou pluviales'),
('04','Déversoir d''orage','Ouvrage de décharge du trop-plein d''effluents d''une canalisation d''assainissement collectif  vers un milieu naturel récepteur'),
('05','Rejet','Rejet (exutoire) dans le milieu naturel d''eaux usées et/ou pluviales'),
('06','Regard','Regard'),
('07','Avaloir','Avaloir'),
('99','Autre','Ouvrage dont le type ne figure pas dans la liste ci-dessus');





-- ##########################
-- ##      REPARATION      ##
-- ##########################
/* correspond au listes de valeurs des attributs en liens avec la classe REPARATION */ 

--###################################   SUPPORT INCIDENT         ######################################################################
-- Table: raepa.val_raepa_support_reparation

-- DROP TABLE raepa.val_raepa_support_reparation;

CREATE TABLE raepa.val_raepa_support_reparation
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT raepa_support_reparation_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.val_raepa_support_reparation
  IS 'Type d''élément de réseau concerné par un incident';
COMMENT ON COLUMN raepa.val_raepa_support_reparation.code IS 'Code de la liste énumérée relative au type d''élément de réseau concerné par une réparation';
COMMENT ON COLUMN raepa.val_raepa_support_reparation.valeur IS 'Valeur de la liste énumérée relative au type d''élément de réseau concerné par une réparation';
COMMENT ON COLUMN raepa.val_raepa_support_reparation.definition IS 'Définition de la liste énumérée relative au type d''élément de réseau concerné par une réparation';

INSERT INTO raepa.val_raepa_support_reparation(
            code, valeur, definition)
    VALUES
('01','Canalisation','Réparation sur une canalisation'),
('02','Appareillage','Réparation d''un appareillage'),
('03','Ouvrage','Réparation d''un ouvrage');



--###################################   TYPE DEFAILLANCE         ######################################################################
-- Table: raepa.val_raepa_defaillance

-- DROP TABLE raepa.val_raepa_type_defaillance;

CREATE TABLE raepa.val_raepa_type_defaillance
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT raepa_type_defaillance_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.val_raepa_type_defaillance
  IS 'Type de défaillance ayant rendu nécessaire une réparation';
COMMENT ON COLUMN raepa.val_raepa_type_defaillance.code IS 'Code de la liste énumérée relative au type de défaillance';
COMMENT ON COLUMN raepa.val_raepa_type_defaillance.valeur IS 'Valeur de la liste énumérée relative au type de défaillance';
COMMENT ON COLUMN raepa.val_raepa_type_defaillance.definition IS 'Définition de la liste énumérée relative au type de défaillance';

INSERT INTO raepa.val_raepa_type_defaillance(
            code, valeur, definition)
VALUES
('00','Indéterminé','Défaillance de type inconnu'),
('01','Casse longitudinale','Canalisation fendue sur sa longueur'),
('02','Casse nette','Canalisation cassée'),
('03','Déboîtement','Déboîtement de tuyau(x) de la canalisation'),
('04','Fissure','Canalisation fissurée'),
('05','Joint','Joint défectueux'),
('06','Percement','Canalisation percée'),
('99','Autre','Défaillance dont le type ne figure pas dans la liste ci-dessus');








-- ###########################
-- ##      METADONNEES      ##
-- ###########################
/* correspond au listes de valeurs des attributs en liens avec la classe METADONNEES */
 
--###################################   QUALITE GEOLOCALISATION    ######################################################################
-- Table: raepa.val_raepa_qualite_geoloc

-- DROP TABLE raepa.val_raepa_qualite_geoloc;

CREATE TABLE raepa.val_raepa_qualite_geoloc
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT raepa_qualite_geoloc_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.val_raepa_qualite_geoloc
  IS 'Classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';
COMMENT ON COLUMN raepa.val_raepa_qualite_geoloc.code IS 'Code de la liste énumérée relative à la classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';
COMMENT ON COLUMN raepa.val_raepa_qualite_geoloc.valeur IS 'Valeur de la liste énumérée relative à la classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';
COMMENT ON COLUMN raepa.val_raepa_qualite_geoloc.definition IS 'Définition de la liste énumérée relative à la classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';

INSERT INTO raepa.val_raepa_qualite_geoloc(
            code, valeur, definition)
    VALUES
('01','Classe A','Classe de précision inférieure 40 cm'),
('02','Classe B','Classe de précision supérieure à 40 cm et inférieure à 1,50 m'),
('03','Classe C','Classe de précision supérieure à 1,50 m');


--###################################   QUALITE ANNEE POSE         ######################################################################
-- Table: raepa.val_raepa_qualite_anpose

-- DROP TABLE raepa.val_raepa_qualite_anpose;

CREATE TABLE raepa.val_raepa_qualite_anpose
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT raepa_qualite_anpose_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.val_raepa_qualite_anpose
  IS 'Qualité de l''information "année de pose" ou "année de mise en service" d''un équipement';
COMMENT ON COLUMN raepa.val_raepa_qualite_anpose.code IS 'Code de la liste énumérée relative à la qualité de l''information "année de pose" ou "année de mise en service" d''un équipement';
COMMENT ON COLUMN raepa.val_raepa_qualite_anpose.valeur IS 'Valeur de la liste énumérée relative à la qualité de l''information "année de pose" ou "année de mise en service" d''un équipement';
COMMENT ON COLUMN raepa.val_raepa_qualite_anpose.definition IS 'Définition de la liste énumérée relative à la qualité de l''information "année de pose" ou "année de mise en service" d''un équipement';

INSERT INTO raepa.val_raepa_qualite_anpose(
            code, valeur, definition)
    VALUES
('00','Indéterminé','Information ou qualité de l''information inconnue'),
('01','Certaine','Année constatée durant les travaux de pose'),
('02','Récolement','Année reprise sur plans de récolement'),
('03','Projet','Année reprise sur plans de projet'),
('04','Mémoire','Année issue de souvenir(s) individuel(s)'),
('05','Déduite','Année déduite du matériau ou de l''état de l''équipement');

 
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                     SEQUENCE                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################
-- Sequence: raepa.raepa_idraepa

-- DROP SEQUENCE raepa.raepa_idraepa;

CREATE SEQUENCE raepa.raepa_idraepa
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
/* Dans la séquence ci-dessous, elle permet d'utiliser un identifiant propre aux geometries.
En effet, dans une optique d'harmonisation et de stockage, nous ne stockerons pas 3 mêmes géométries 
ponctuelles pour 1 ouvrage et 2 appareillages qui sont présents sur une même position.
Un attribut supplémentaire sera alors ajouté à la classe raepa_app, référençant le noeud 
auquel il est attibué, idem avec atribut référençant la canalisation.*/

-- Sequence: raepa.raepa_idgeom

-- DROP SEQUENCE raepa.raepa_idgeom;

CREATE SEQUENCE raepa.raepa_idgeom
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

-- Sequence: raepa.raepa_idrepar

-- DROP SEQUENCE raepa.raepa_idrepar;

CREATE SEQUENCE raepa.raepa_idrepar
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;




-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                  CLASSE OBJET                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################
/* correspond aux classes du MCD du modèle RAEPA */
/* remarque : quelques oublis d'attributs sur la Partie MCD qui sont présent sur la partie C, ont donc été rajouté */


--###################################   CLASSE TRONCON        ######################################################################

-- Table: raepa.raepa_troncon

-- DROP TABLE raepa.raepa_troncon;
CREATE TABLE raepa.raepa_troncon
(
  idtroncon character varying(254) NOT NULL,
  geom geometry(LineString,2154),
  CONSTRAINT raepa_troncon_pkey PRIMARY KEY (idtroncon)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.raepa_troncon
  IS 'Tronçon de réseau';
COMMENT ON COLUMN raepa.raepa_troncon.idtroncon IS 'Identifiant du tronçon';
COMMENT ON COLUMN raepa.raepa_troncon.geom IS 'Géométrie linéaire de l''objet';

ALTER TABLE raepa.raepa_troncon ALTER COLUMN idtroncon SET DEFAULT nextval('raepa.raepa_idgeom'::regclass);


--###################################   CLASSE CANALISATION        ######################################################################

-- Table: raepa.raepa_canal

-- DROP TABLE raepa.raepa_canal;

CREATE TABLE raepa.raepa_canal
(
  idcana character varying(254) NOT NULL,
  mouvrage character varying(100),-- peut être rattaché directement à la superclasse raepa_objet si tous les réseaux ont cette information
  gexploit character varying(100),-- peut être rattaché directement à la superclasse raepa_objet si tous les réseaux ont cette information  
  enservice character varying(1),
  branchemnt character varying(1),           
  materiau character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  diametre integer,  
  anfinpose character varying(4), -- ne figure pas sur le MCD mais présent dans les livrables AE et ASS
  modecircu character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur    
  idnini character varying(254), --fkey vers identifiant du noeud initial
  idnterm character varying(254), --fkey vers identifiant du noeud terminal
  idcanppale character varying(254), -- fkey vers identifiant de la canalisation principale
  andebpose character varying(4),
  longcana integer,    -- unité en mètre et de type entier, pourquoi cette simplification  ?
  nbranche integer,    -- ne figure pas sur partie MCD mais présent sur les livrables AE et ASS
  CONSTRAINT raepa_canal_pkey PRIMARY KEY (idcana)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.raepa_canal
  IS 'Tronçon de conduite';
COMMENT ON COLUMN raepa.raepa_canal.idcana IS 'Identifiant de la canalisation';
COMMENT ON COLUMN raepa.raepa_canal.mouvrage IS 'Maître d''ouvrage du réseau';
COMMENT ON COLUMN raepa.raepa_canal.gexploit IS 'Gestionnaire exploitant du réseau';
COMMENT ON COLUMN raepa.raepa_canal.enservice IS 'Canalisation en service (O/N)';
COMMENT ON COLUMN raepa.raepa_canal.branchemnt IS 'Canalisation de branchement individuel (O/N)';
COMMENT ON COLUMN raepa.raepa_canal.materiau IS 'Matériau de la canalisation';
COMMENT ON COLUMN raepa.raepa_canal.diametre IS 'Diamètre nominal de la canalisation (en millimètres)';
COMMENT ON COLUMN raepa.raepa_canal.anfinpose IS 'Année marquant la fin de la période de pose de la canalisation';
COMMENT ON COLUMN raepa.raepa_canal.modecircu IS 'Mode de circulation de l''eau à l''intérieur de la canalisation';
COMMENT ON COLUMN raepa.raepa_canal.idnini IS 'Identifiant du noeud de début de la canalisation';
COMMENT ON COLUMN raepa.raepa_canal.idnterm IS 'Identifiant du noeud de fin de la canalisation';
COMMENT ON COLUMN raepa.raepa_canal.idcanppale IS 'Identifiant de la canalisation principale';
COMMENT ON COLUMN raepa.raepa_canal.andebpose IS 'Année marquant le début de la période de pose de la canalisation';
COMMENT ON COLUMN raepa.raepa_canal.longcana IS 'Longueur mesurée de la canalisation (en mètres)';
COMMENT ON COLUMN raepa.raepa_canal.nbranche IS 'Nombre de branchements individuels sur la canalisation';





--###################################   CANALISATION AEP           ######################################################################
-- Table: raepa.raepa_canalaep

-- DROP TABLE raepa.raepa_canalaep;

CREATE TABLE raepa.raepa_canalaep
(
  idcana character varying(254) NOT NULL, -- fkey vers attribut idcana de la classe canalisation
  contcanaep character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  fonccanaep character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  profgen numeric (3,2), -- !!!!!! usage pour le DT-DICT qui n'a pas sa spécificité sur un réseau d'ae. L'emploi de la profondeur par rapport à la cote NGF est par ailleurs dangereuse et il aurait été plus pertinent d'utiliser la côte de la génératrice supérieure
  CONSTRAINT raepa_canalaep_pkey PRIMARY KEY (idcana)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.raepa_canalaep
  IS 'Tronçon de conduite d''adduction d''eau';
COMMENT ON COLUMN raepa.raepa_canalaep.idcana IS 'Identifiant de la canalisation';
COMMENT ON COLUMN raepa.raepa_canalaep.contcanaep IS 'Catégorie de la canalisation d''adduction d''eau';
COMMENT ON COLUMN raepa.raepa_canalaep.fonccanaep IS 'Fonction de la canalisation d''adduction d''eau';
COMMENT ON COLUMN raepa.raepa_canalaep.profgen IS 'Profondeur moyenne de la génératrice supérieure de la canalisation (en mètres)';




--###################################   CANALISATION ASS           ######################################################################
-- Table: raepa.raepa_canalass

-- DROP TABLE raepa.raepa_canalass;

CREATE TABLE raepa.raepa_canalass
(
  idcana character varying(254) NOT NULL, -- fkey vers attribut idcana de la classe canalisation
  typreseau character varying(2) NOT NULL, --fkey vers domaine de valeur
  contcanass character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  fonccanass character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  zamont numeric (6,3),
  zaval numeric (6,3),
  sensecoul character varying(1), -- !!!!!! existe dans le modèle implementé en fichier mais absent du MCD RAEPA
  CONSTRAINT raepa_canalass_pkey PRIMARY KEY (idcana)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.raepa_canalass
  IS 'Tronçon de conduite d''assainissement collectif';
COMMENT ON COLUMN raepa.raepa_canalass.idcana IS 'Identifiant de la canalisation';
COMMENT ON COLUMN raepa.raepa_canalass.typreseau IS 'Type du réseau d''assainissement collectif';
COMMENT ON COLUMN raepa.raepa_canalass.contcanass IS 'Catégorie de la canalisation d''assainissement collectif';
COMMENT ON COLUMN raepa.raepa_canalass.fonccanass IS 'Fonction de la canalisation d''assainissement collectif';
COMMENT ON COLUMN raepa.raepa_canalass.zamont IS 'Altitude à l''extrémité amont (en mètres, référentiel NGF-IGN69)';  
COMMENT ON COLUMN raepa.raepa_canalass.zaval IS 'Altitude à l''extrémité aval (en mètres, référentiel NGF-IGN69)';   
COMMENT ON COLUMN raepa.raepa_canalass.sensecoul IS 'Sens de l''écoulement dans la canalisation d''assainissement collectif';



--###################################   NOEUD                      ######################################################################

-- Table: raepa.raepa_noeud

-- DROP TABLE raepa.raepa_noeud;

CREATE TABLE raepa.raepa_noeud
(
  idnoeud character varying(254) NOT NULL,
  x numeric(10,3) NOT NULL,           
  y numeric(11,3) NOT NULL,           
  mouvrage character varying(100),-- peut être rattaché directement à la superclasse raepa_objet si tous les réseaux ont cette information
  gexploit character varying(100),-- peut être rattaché directement à la superclasse raepa_objet si tous les réseaux ont cette information
  anfinpose character varying(4),
  idtramont character varying (254) NOT NULL, -- fkey vers attribut idtroncon du tronçon principal.
  idtraval character varying (254), -- fkey vers attribut idtroncon de la classe tronçon. Valeur NULL admise car pas forcément de tronçon en aval 
  idtrppale character varying(254),-- fkey vers attribut idcana de la classe canalisation. Valeur NULL admise car ne sert à renseigner le tronçon principal pour un noeud de raccord (piquage) du branchement sur un tronçon principal
  anmesinf character varying(4), --cela signifie que le début de mise en service est le même pour tous les appareils d'un même noeud...
  geom geometry(Point,2154),
  CONSTRAINT raepa_noeud_pkey PRIMARY KEY (idnoeud) 
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.raepa_noeud
  IS 'Lieu de jonction de plusieurs tronçons de conduite ou de percement d''un tronçon de conduite';
COMMENT ON COLUMN raepa.raepa_noeud.idnoeud IS 'Identifiant du noeud';
COMMENT ON COLUMN raepa.raepa_noeud.x IS 'Coordonnée X Lambert 93 (en mètres)';
COMMENT ON COLUMN raepa.raepa_noeud.y IS 'Coordonnée Y Lambert 93 (en mètres)';
COMMENT ON COLUMN raepa.raepa_noeud.mouvrage IS 'Maître d''ouvrage du réseau';
COMMENT ON COLUMN raepa.raepa_noeud.gexploit IS 'Gestionnaire exploitant du réseau';
COMMENT ON COLUMN raepa.raepa_noeud.anfinpose IS 'Année marquant la fin de la période de mise en service de l''appareillage et/ou de l''ouvrage';
COMMENT ON COLUMN raepa.raepa_noeud.idtramont IS 'Identifiant du tronçon amont';
COMMENT ON COLUMN raepa.raepa_noeud.idtraval IS 'Identifiant du tronçon aval';
COMMENT ON COLUMN raepa.raepa_noeud.idtrppale IS 'Identifiant du tronçon principal en cas de piquage';
COMMENT ON COLUMN raepa.raepa_noeud.anmesinf IS 'Année marquant le début de la période de mise en service de l''appareillage et/ou de l''ouvrage';
COMMENT ON COLUMN raepa.raepa_noeud.geom IS 'Géométrie ponctuelle de l''objet';

ALTER TABLE raepa.raepa_noeud ALTER COLUMN idnoeud SET DEFAULT nextval('raepa.raepa_idgeom'::regclass);



--###################################   CLASSE APPAREILLAGE               ######################################################################

-- Table: raepa.raepa_appar

-- DROP TABLE raepa.raepa_appar;

CREATE TABLE raepa.raepa_appar
(
  idappareil character varying(254) NOT NULL,
  idnoeud character varying (254) NOT NULL, -- fkey vers attribut idnoeud de la classe noeud, puisque plusieurs appareillages peuvent être au même endroit
  idouvrage character varying(254), -- fkey vers attribut idouvrage de la classe ouvrage. Valeur NULL admise car il n'y a pas forcement un ouvrage qui accueille l'appareillage
  diametre integer, -- A PRIORI attribut manquant dans la modélisation à ce niveau car présent dans les gabarits des livrables d'appareillage ae et ass et absent pour les ouvrages
  z numeric(6,2),
  CONSTRAINT raepa_appar_pkey PRIMARY KEY (idappareil) 
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.raepa_appar
  IS 'Appareillage';
COMMENT ON COLUMN raepa.raepa_appar.idappareil IS 'Identifiant de l''appareillage';
COMMENT ON COLUMN raepa.raepa_appar.idnoeud IS 'Identifiant du noeud';
COMMENT ON COLUMN raepa.raepa_appar.idouvrage IS 'Identifiant de l''éventuel ouvrage d''accueil';
COMMENT ON COLUMN raepa.raepa_appar.diametre IS 'Diamètre nominal de l''appareillage (en millimètres)';
COMMENT ON COLUMN raepa.raepa_appar.z IS 'Altitude du noeud (en mètres, Référentiel NGFIGN69)';


 
--###################################   APPAREILLAGE AEP            ######################################################################

-- Table: raepa.raepa_apparaep

-- DROP TABLE raepa.raepa_apparaep;

CREATE TABLE raepa.raepa_apparaep
(
  idappareil character varying(254) NOT NULL, -- fkey vers attribut idappareil de la classe appareillage
  fnappaep character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  CONSTRAINT raepa_apparaep_pkey PRIMARY KEY (idappareil) 
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.raepa_apparaep
  IS 'Appareillage d''adduction d''eau';
COMMENT ON COLUMN raepa.raepa_apparaep.idappareil IS 'Identifiant de l''appareillage';
COMMENT ON COLUMN raepa.raepa_apparaep.fnappaep IS 'Fonction de l''appareillage d''adduction d''eau potable';


--###################################   APPAREILLAGE ASS           ######################################################################

-- Table: raepa.raepa_apparass

-- DROP TABLE raepa.raepa_apparass;

CREATE TABLE raepa.raepa_apparass
(
  idappareil character varying(254) NOT NULL, -- fkey vers attribut idappareil de la classe appareillage
  typreseau character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  fnappass character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  CONSTRAINT raepa_apparass_pkey PRIMARY KEY (idappareil)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.raepa_apparass
  IS 'Appareillage d''assainissement collectif';
COMMENT ON COLUMN raepa.raepa_apparass.idappareil IS 'Identifiant de l''appareillage';
COMMENT ON COLUMN raepa.raepa_apparass.typreseau IS 'Type du réseau d''assainissement collectif';
COMMENT ON COLUMN raepa.raepa_apparass.fnappass IS 'Fonction de l''appareillage d''assainissement collectif';

--###################################   OUVRAGE                    ######################################################################

-- Table: raepa.raepa_ouvr

-- DROP TABLE raepa.raepa_ouvr;

CREATE TABLE raepa.raepa_ouvr
(
  idouvrage character varying(254) NOT NULL,
--  idnoeud character varying(254) NOT NULL, -- fkey vers attribut idnoeud de la classe noeud
  z numeric(6,2),
  CONSTRAINT raepa_ouvr_pkey PRIMARY KEY (idouvrage) 
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.raepa_ouvr
  IS 'Ouvrage';
COMMENT ON COLUMN raepa.raepa_ouvr.idouvrage IS 'Identifiant de l''ouvrage';
-- COMMENT ON COLUMN raepa.raepa_ouvr.idnoeud IS 'Identifiant du noeud';
COMMENT ON COLUMN raepa.raepa_ouvr.z IS 'Altitude radier de l''ouvrage (en mètres, Référentiel NGFIGN69)';
 
--###################################   OUVRAGE AE                 ######################################################################
-- Table: raepa.raepa_ouvraep

-- DROP TABLE raepa.raepa_ouvraep;

CREATE TABLE raepa.raepa_ouvraep
(
  idouvrage character varying(254) NOT NULL, -- fkey vers attribut idouvrage de la classe ouvrage
  fnouvaep character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  CONSTRAINT raepa_ouvraep_pkey PRIMARY KEY (idouvrage) 
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.raepa_ouvraep
  IS 'Ouvrage d''adduction d''eau';
COMMENT ON COLUMN raepa.raepa_ouvraep.idouvrage IS 'Identifiant de l''ouvrage';
COMMENT ON COLUMN raepa.raepa_ouvraep.fnouvaep IS 'Fonction de l''ouvrage d''adduction d''eau potable';

--###################################   OUVRAGE ASS                ######################################################################

-- Table: raepa.raepa_ouvrass

-- DROP TABLE raepa.raepa_ouvrass;

CREATE TABLE raepa.raepa_ouvrass
(
  idouvrage character varying(254) NOT NULL, -- fkey vers attribut idouvrage de la classe ouvrage
  typreseau character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  fnouvass character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  CONSTRAINT raepa_ouvrass_pkey PRIMARY KEY (idouvrage) 
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.raepa_ouvrass
  IS 'Ouvrage d''assainissement collectif';
COMMENT ON COLUMN raepa.raepa_ouvrass.idouvrage IS 'Identifiant de l''ouvrage';
COMMENT ON COLUMN raepa.raepa_ouvrass.typreseau IS 'Type du réseau d''assainissement collectif';
COMMENT ON COLUMN raepa.raepa_ouvrass.fnouvass IS 'Fonction de l''ouvrage d''assainissement collectif';

--###################################   REPARATION                 ######################################################################

CREATE TABLE raepa.raepa_repar
(
  idrepar character varying(254) NOT NULL,
  x numeric(10,3) NOT NULL,
  y numeric(11,3) NOT NULL,
  supprepare character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  defreparee character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  idsuprepar character varying(254) NOT NULL, -- fkey vers attribut idraepa de la classe raepa_id
  daterepar date,
  mouvrage character varying(100), -- *******  voir pour privilégier des domaines de valeur  *******
  geom geometry(Point,2154),
  CONSTRAINT raepa_repar_pkey PRIMARY KEY (idrepar) 
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.raepa_repar
  IS 'Lieu d''une intervention sur le réseau effectuée suite à une défaillance dudit réseau';
COMMENT ON COLUMN raepa.raepa_repar.idrepar IS 'Identifiant de la réparation effectuée';
COMMENT ON COLUMN raepa.raepa_repar.x IS 'Coordonnée X Lambert 93 (en mètres)';
COMMENT ON COLUMN raepa.raepa_repar.y IS 'Coordonnée X Lambert 93 (en mètres)';
COMMENT ON COLUMN raepa.raepa_repar.supprepare IS 'Type de support de la réparation';
COMMENT ON COLUMN raepa.raepa_repar.defreparee IS 'Type de défaillance';
COMMENT ON COLUMN raepa.raepa_repar.idsuprepar IS 'Identifiant du support de la réparation';
COMMENT ON COLUMN raepa.raepa_repar.daterepar IS 'Date de l''intervention en réparation';
COMMENT ON COLUMN raepa.raepa_repar.mouvrage IS 'Maître d''ouvrage de la réparation';
COMMENT ON COLUMN raepa.raepa_repar.geom IS 'Géométrie ponctuelle de l''objet';


ALTER TABLE raepa.raepa_repar ALTER COLUMN idrepar SET DEFAULT nextval('raepa.raepa_idrepar'::regclass);

--###################################   METADONNEES RAEPA          ######################################################################

-- Table: raepa.raepa_metadonnees

-- DROP TABLE raepa.raepa_metadonnees;

CREATE TABLE raepa.raepa_metadonnees
(
  idraepa character varying(254) NOT NULL, -- pkey de l'objet
  qualglocxy character varying(2) NOT NULL, -- fkey vers domaine de valeur
  qualglocz character varying(2) NOT NULL, -- fkey vers domaine de valeur
  datemaj date NOT NULL,
  sourmaj character varying(100) NOT NULL,
  dategeoloc date,
  sourgeoloc character varying(100),
  sourattrib character varying(100),
  qualannee character varying(2), -- information à renseignée uniquement si anposedeb=anposfin pour une canalisation ou un noeud, fkey vers domaine de valeur
  idcana character varying (254), --fkey vers l'identifiant de la canalisation
  idnoeud character varying (254), --fkey vers l'identifiant du noeud
  CONSTRAINT raepa_metadonnees_pkey PRIMARY KEY (idraepa)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE raepa.raepa_metadonnees
  IS 'Classe décrivant les métadonnées d''un objet du réseau humide';
COMMENT ON COLUMN raepa.raepa_metadonnees.idraepa IS 'identifiant de l''entité RAEPA';  
COMMENT ON COLUMN raepa.raepa_metadonnees.qualglocxy IS 'Qualité de la géolocalisation planimétrique (XY)';
COMMENT ON COLUMN raepa.raepa_metadonnees.qualglocz IS 'Qualité de la géolocalisation altimétrique (Z)';
COMMENT ON COLUMN raepa.raepa_metadonnees.datemaj IS 'Date de la dernière mise à jour des informations';
COMMENT ON COLUMN raepa.raepa_metadonnees.sourmaj IS 'Source de la mise à jour';
COMMENT ON COLUMN raepa.raepa_metadonnees.dategeoloc IS 'Date de la géolocalisation';
COMMENT ON COLUMN raepa.raepa_metadonnees.sourgeoloc IS 'Auteur de la géolocalisation';
COMMENT ON COLUMN raepa.raepa_metadonnees.sourattrib IS 'Auteur de la saisie des données attributaires (lorsque différent de l''auteur de la géolocalisation)';
COMMENT ON COLUMN raepa.raepa_metadonnees.qualannee IS 'Fiabilité de l''année de pose ou de mise en service';
COMMENT ON COLUMN raepa.raepa_metadonnees.idcana IS 'Identifiant du noeud auxquel sont associées ces informations';
COMMENT ON COLUMN raepa.raepa_metadonnees.idnoeud IS 'Identifiant de la canalisation auxquel sont associées ces informations';

ALTER TABLE raepa.raepa_metadonnees ALTER COLUMN idraepa SET DEFAULT nextval('raepa.raepa_idraepa'::regclass);

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                           FKEY (clé étrangère)                                                               ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################
      


-- ID



-- DOMAINE DE VALEUR

-- ############ METADONNEES RAEPA ############

ALTER TABLE raepa.raepa_metadonnees

  ADD CONSTRAINT val_raepa_qualite_anpose_fkey FOREIGN KEY (qualannee)
      REFERENCES raepa.val_raepa_qualite_anpose (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_raepa_qualite_geoloc_xy_fkey FOREIGN KEY (qualglocxy)
      REFERENCES raepa.val_raepa_qualite_geoloc (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,         
  ADD CONSTRAINT val_raepa_qualite_geoloc_z_fkey FOREIGN KEY (qualglocz)
      REFERENCES raepa.val_raepa_qualite_geoloc (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_raepa_idnoeud_fkey FOREIGN KEY (idnoeud)
      REFERENCES raepa.raepa_noeud (idnoeud) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_raepa_idcana_fkey FOREIGN KEY (idcana)
      REFERENCES raepa.raepa_canal (idcana) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;


-- ############ CANALISATION ############

-- ************ RAEPA_CANAL ************  

ALTER TABLE raepa.raepa_canal

  ADD CONSTRAINT val_raepa_materiau_fkey FOREIGN KEY (materiau)
      REFERENCES raepa.val_raepa_materiau (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_raepa_mode_circulation_fkey FOREIGN KEY (modecircu)
      REFERENCES raepa.val_raepa_mode_circulation (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
    
-- ************ RAEPA_CANAL_AEP ************       
           
ALTER TABLE raepa.raepa_canalaep

  ADD CONSTRAINT val_raepa_cat_canal_ae_fkey FOREIGN KEY (contcanaep)
      REFERENCES raepa.val_raepa_cat_canal_ae (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,           
  ADD CONSTRAINT val_raepa_fonc_canal_ae_fkey FOREIGN KEY (fonccanaep)
      REFERENCES raepa.val_raepa_fonc_canal_ae (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
      
-- ************ RAEPA_CANAL_ASS ************   

ALTER TABLE raepa.raepa_canalass

  ADD CONSTRAINT val_raepa_cat_reseau_ass_fkey FOREIGN KEY (typreseau)
      REFERENCES raepa.val_raepa_typ_reseau_ass (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_raepa_cat_canal_ass_fkey FOREIGN KEY (contcanass)
      REFERENCES raepa.val_raepa_cat_canal_ass (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,           
  ADD CONSTRAINT val_raepa_fonc_canal_ass_fkey FOREIGN KEY (fonccanass)
      REFERENCES raepa.val_raepa_fonc_canal_ass (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- ############ NOEUD ############
ALTER TABLE raepa.raepa_noeud

  ADD CONSTRAINT val_raepa_id_canamont_fkey FOREIGN KEY (idcanamont)
      REFERENCES raepa.raepa_canal (idcana) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_raepa_id_canaval_fkey FOREIGN KEY (idcanaval)
      REFERENCES raepa.raepa_canal (idcana) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_raepa_id_canppale_fkey FOREIGN KEY (idcanppale)
      REFERENCES raepa.raepa_canal (idcana) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- ############ APPAREILLAGE ############
ALTER TABLE raepa.raepa_appar

  ADD CONSTRAINT val_raepa_idnoeud_fkey FOREIGN KEY (idnoeud)
      REFERENCES raepa.raepa_noeud (idnoeud) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_raepa_idouvrage_fkey FOREIGN KEY (idouvrage)
      REFERENCES raepa.raepa_ouvr (idouvrage) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
	  
-- ************ RAEPA_APPAR_AEP ************  

ALTER TABLE raepa.raepa_apparaep

  ADD CONSTRAINT val_raepa_fonc_app_ae_fkey FOREIGN KEY (fnappaep)
      REFERENCES raepa.val_raepa_fonc_app_ae (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;   

-- ************ RAEPA_APPAR_ASS ************  

ALTER TABLE raepa.raepa_apparass

  ADD CONSTRAINT val_raepa_cat_reseau_ass_fkey FOREIGN KEY (typreseau)
      REFERENCES raepa.val_raepa_typ_reseau_ass (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,        
  ADD CONSTRAINT val_raepa_fonc_app_ass_fkey FOREIGN KEY (fnappass)
      REFERENCES raepa.val_raepa_fonc_app_ass (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;                     

 
-- ############ OUVRAGE ############

-- ************ RAEPA_OUVR_AEP ************  

ALTER TABLE raepa.raepa_ouvraep

  ADD CONSTRAINT val_raepa_fonc_ouv_ae_fkey FOREIGN KEY (fnouvaep)
      REFERENCES raepa.val_raepa_fonc_ouv_ae (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;   

-- ************ RAEPA_OUVR_ASS ************  

ALTER TABLE raepa.raepa_ouvrass

  ADD CONSTRAINT val_raepa_cat_reseau_ass_fkey FOREIGN KEY (typreseau)
      REFERENCES raepa.val_raepa_typ_reseau_ass (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,        
  ADD CONSTRAINT val_raepa_cat_ouv_ass_fkey FOREIGN KEY (fnouvass)
      REFERENCES raepa.val_raepa_fonc_ouv_ass (code) MATCH SIMPLE

      ON UPDATE NO ACTION ON DELETE NO ACTION;  


-- ############ REPARATION ############

-- ************ RAEPA_REPAR ************       

ALTER TABLE raepa.raepa_repar

  ADD CONSTRAINT val_raepa_type_defailance_fkey FOREIGN KEY (supprepare)
      REFERENCES raepa.val_raepa_type_defaillance (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,        
  ADD CONSTRAINT val_raepa_defaillance_fkey FOREIGN KEY (defreparee)
      REFERENCES raepa.val_raepa_type_defaillance (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
  
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        VUES                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- #################################################################### VUE CANALISATION AEP ###############################################
        
-- View: raepa.raepa_canalaep_l

-- DROP VIEW raepa.raepa_canalaep_l;

CREATE OR REPLACE VIEW raepa.raepa_canalaep_l AS 
 SELECT 
  a.idcana,
  g.mouvrage,
  g.gexploit, 
  g.enservice,
  g.branchemnt,
  g.materiau,
  g.diametre,  
  g.anfinpose,
  g.modecircu,
  a.contcanaep,
  a.fonccanaep,     
  g.idnini,
  g.idnterm,
  g.idcanppale,
  a.profgen,
  g.andebpose,
  g.longcana,
  g.nbranche,
  m.qualglocxy,
  m.qualglocz, 
  m.datemaj,
  m.sourmaj,
  m.qualannee,
  m.dategeoloc,
  m.sourgeoloc,
  m.sourattrib,
  g.geom
  
FROM raepa.raepa_canalaep a
LEFT JOIN raepa.raepa_canal g ON g.idcana = a.idcana
LEFT JOIN raepa.raepa_metadonnees m ON a.idcana = m.idraepa
ORDER BY a.idcana;

COMMENT ON VIEW raepa.raepa_canalaep_l
  IS 'Canalisation d''adduction d''eau';


-- #################################################################### VUE CANALISATION ASS ###############################################

-- View: raepa.raepa_canalass_l

-- DROP VIEW raepa.raepa_canalass_l;

CREATE OR REPLACE VIEW raepa.raepa_canalass_l AS 
 SELECT 
  a.idcana,
  g.mouvrage,
  g.gexploit, 
  g.enservice,
  g.branchemnt,
  a.typreseau,  
  g.materiau,
  g.diametre,  
  g.anfinpose,
  g.modecircu,
  a.contcanass,
  a.fonccanass,     
  g.idnini,
  g.idnterm,
  g.idcanppale,
  a.zamont,
  a.zaval,
  a.sensecoul,
  g.andebpose,
  g.longcana,
  g.nbranche,
  m.qualglocxy,
  m.qualglocz, 
  m.datemaj,
  m.sourmaj,
  m.qualannee,
  m.dategeoloc,
  m.sourgeoloc,
  m.sourattrib,
  g.geom
  
FROM raepa.raepa_canalass a
LEFT JOIN raepa.raepa_canal g ON g.idcana = a.idcana
LEFT JOIN raepa.raepa_metadonnees m ON a.idcana = m.idraepa
ORDER BY a.idcana;

COMMENT ON VIEW raepa.raepa_canalass_l
  IS 'Canalisation d''assainissement collectif';


-- #################################################################### VUE APPAREILLAGE AEP ###############################################


-- View: raepa.raepa_apparaep_p

-- DROP VIEW raepa.raepa_apparaep_p;

CREATE OR REPLACE VIEW raepa.raepa_apparaep_p AS 
 SELECT
  ab.idappareil,
  g.x,
  g.y,
  g.mouvrage,
  g.gexploit,
  ab.fnappaep,
  g.anfinpose,
  a.diametre ::integer, -- A PRIORI soit : attribut manquant dans la modélisation à ce niveau car présent dans les gabarits des livrables d'appareillage ae et ass et absent pour les ouvrages / soit : attribut implémenté et qui ne devrait pas l'être / MCD
  g idcanamont,
  g idcanaval,  
  g.idcanppale,
  g.idnoeud,
  a.idouvrage,  -- prb si on gère séquence unique de noeud sans gérer sequence ouvrage et appareil
  a.z,
  g.andebpose,      
  m.qualglocxy,
  m.qualglocz, 
  m.datemaj,
  m.sourmaj,
  m.qualannee,
  m.dategeoloc,
  m.sourgeoloc,
  m.sourattrib,
  g.geom

FROM raepa.raepa_apparaep ab 
LEFT JOIN raepa.raepa_appar a ON a.idappareil = ab.idappareil
LEFT JOIN raepa.raepa_noeud g ON g.idnoeud = a.idnoeud
LEFT JOIN raepa.raepa_metadonnees m ON ab.idappareil = m.idraepa
ORDER BY ab.idappareil;

COMMENT ON VIEW raepa.raepa_apparaep_p
  IS 'Appareillage d''adduction d''eau';


-- #################################################################### VUE APPAREILLAGE ASS ###############################################


-- View: raepa.raepa_apparass_p

-- DROP VIEW raepa.raepa_apparass_p;

CREATE OR REPLACE VIEW raepa.raepa_apparass_p AS 
 SELECT
  ab.idappareil,
  g.x,
  g.y,
  g.mouvrage,
  g.gexploit,
  ab.typreseau,
  ab.fnappass,
  g.anfinpose,
  a.diametre ::integer, -- A PRIORI soit : attribut manquant dans la modélisation à ce niveau car présent dans les tables implémentées d'appareillage ae et ass et absent pour les ouvrages / soit : attribut implémenté et qui ne devrait pas l'être / MCD
  g.idcanamont,
  g.idcanaval,  
  g.idcanppale,
  g.idnoeud,
  a.idouvrage,
  a.z,
  g.andebpose,      
  m.qualglocxy,
  m.qualglocz, 
  m.datemaj,
  m.sourmaj,
  m.qualannee,
  m.dategeoloc,
  m.sourgeoloc,
  m.sourattrib,
  g.geom

FROM raepa.raepa_apparass ab
LEFT JOIN raepa.raepa_appar a ON a.idappareil = ab.idappareil
LEFT JOIN raepa.raepa_noeud g ON g.idnoeud = a.idnoeud
LEFT JOIN raepa.raepa_metadonnees m ON ab.idappareil = m.idraepa
ORDER BY ab.idappareil;

COMMENT ON VIEW raepa.raepa_apparass_p
  IS 'Appareillage d''assanissement collectif';



-- #################################################################### VUE OUVRAGE AEP ###############################################

-- View: raepa.raepa_ouvraep_p

-- DROP VIEW raepa.raepa_ouvraep_p;

CREATE OR REPLACE VIEW raepa.raepa_ouvraep_p AS 
 SELECT
  ab.idouvrage,
  g.x,
  g.y,
  g.mouvrage,
  g.gexploit,
  ab.fnouvaep,
  g.anfinpose,
  g.idcanamont,
  g.idcanaval,  
  g.idcanppale,
  a.z,
  g.andebpose,      
  m.qualglocxy,
  m.qualglocz, 
  m.datemaj,
  m.sourmaj,
  m.qualannee,
  m.dategeoloc,
  m.sourgeoloc,
  m.sourattrib,
  g.geom

FROM raepa.raepa_ouvraep ab
LEFT JOIN raepa.raepa_noeud g ON g.idnoeud = ab.idouvrage
LEFT JOIN raepa.raepa_ouvr a ON a.idouvrage = ab.idouvrage
LEFT JOIN raepa.raepa_metadonnees m ON ab.idouvrage = m.idraepa
ORDER BY ab.idouvrage;

COMMENT ON VIEW raepa.raepa_ouvraep_p
  IS 'Ouvrage d''adduction d''eau';


-- #################################################################### VUE OUVRAGE ASS ###############################################

-- View: raepa.raepa_ouvrass_p

-- DROP VIEW raepa.raepa_ouvrass_p;

CREATE OR REPLACE VIEW raepa.raepa_ouvrass_p AS 
 SELECT
  ab.idouvrage,
  g.x,
  g.y,
  g.mouvrage,
  g.gexploit,
  ab.typreseau,
  ab.fnouvass,
  g.anfinpose,
  g.idcanamont,
  g.idcanaval,  
  g.idcanppale,
  a.z,
  g.andebpose,      
  m.qualglocxy,
  m.qualglocz, 
  m.datemaj,
  m.sourmaj,
  m.qualannee,
  m.dategeoloc,
  m.sourgeoloc,
  m.sourattrib,
  g.geom

FROM raepa.raepa_ouvrass ab
LEFT JOIN raepa.raepa_noeud g ON g.idnoeud = ab.idouvrage
LEFT JOIN raepa.raepa_ouvr a ON a.idouvrage = ab.idouvrage
LEFT JOIN raepa.raepa_metadonnees m ON ab.idouvrage = m.idraepa
ORDER BY ab.idouvrage;

COMMENT ON VIEW raepa.raepa_ouvrass_p
  IS 'Ouvrage d''assainissement collectif';


-- #################################################################### VUE REPARATION AEP ###############################################

-- View: raepa.raepa_reparaep_p

-- DROP VIEW raepa.raepa_reparaep_p;

CREATE OR REPLACE VIEW raepa.raepa_reparaep_p AS 
 SELECT
  g.idrepar,
  g.x,
  g.y,
  g.supprepare,
  g.defreparee,
  g.idsuprepar,
  g.daterepar,
  g.mouvrage,
  g.geom

FROM raepa.raepa_repar g
-- voir comment gérer le WHERE pour récup uniquement AEP
ORDER BY g.idrepar;

COMMENT ON VIEW raepa.raepa_reparaep_p
  IS 'Reparation du réseau d''adduction d''eau';


-- #################################################################### VUE REPARATION ASS ###############################################

-- View: raepa.raepa_reparass_p

-- DROP VIEW raepa.raepa_reparass_p;

CREATE OR REPLACE VIEW raepa.raepa_reparass_p AS 
 SELECT
  g.idrepar,
  g.x,
  g.y,
  g.supprepare,
  g.defreparee,
  g.idsuprepar,
  g.daterepar,
  g.mouvrage,
  g.geom

FROM raepa.raepa_repar g
-- voir comment gérer le WHERE pour récup uniquement ASS
ORDER BY g.idrepar;

COMMENT ON VIEW raepa.raepa_reparass_p
  IS 'Reparation du réseau d''assainissement collectif';