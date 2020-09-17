/*RAEPA V1.2*/
/*Creation du squelette de la structure des données (table, séquence, trigger,...) au standard RAEPA */
/*init_bd_resh_10_standard_raepa.sql */
/*PostGIS*/

/* GeoCompiegnois - https://geo.compiegnois.fr/ */
/* Auteur : Florent Vanhoutte, reprit par Léandre Béron*/

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        DROP                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################
-- vue
DROP MATERIALIZED VIEW IF EXISTS raepa.raepa_canalaep_l;
DROP MATERIALIZED VIEW IF EXISTS raepa.raepa_canalass_l;
DROP MATERIALIZED VIEW IF EXISTS raepa.raepa_apparaep_p;
DROP MATERIALIZED VIEW IF EXISTS raepa.raepa_apparass_p;
DROP MATERIALIZED VIEW IF EXISTS raepa.raepa_ouvraep_p;
DROP MATERIALIZED VIEW IF EXISTS raepa.raepa_ouvrass_p;
DROP MATERIALIZED VIEW IF EXISTS raepa.raepa_reparaep_p;
DROP MATERIALIZED VIEW IF EXISTS raepa.raepa_reparass_p;
-- fkey
ALTER TABLE IF EXISTS raepa.metadonnees_raepa DROP CONSTRAINT IF EXISTS val_raepa_qualite_anpose_fkey;
ALTER TABLE IF EXISTS raepa.metadonnees_raepa DROP CONSTRAINT IF EXISTS val_raepa_qualite_geoloc_xy_fkey;
ALTER TABLE IF EXISTS raepa.metadonnees_raepa DROP CONSTRAINT IF EXISTS val_raepa_qualite_geoloc_z_fkey;
ALTER TABLE IF EXISTS raepa.canalisation DROP CONSTRAINT IF EXISTS val_raepa_materiau_fkey;
ALTER TABLE IF EXISTS raepa.canalisation DROP CONSTRAINT IF EXISTS val_raepa_mode_circulation_fkey;
ALTER TABLE IF EXISTS raepa.canalisation_ae DROP CONSTRAINT IF EXISTS val_raepa_cat_canal_ae_fkey;
ALTER TABLE IF EXISTS raepa.canalisation_ae DROP CONSTRAINT IF EXISTS val_raepa_fonc_canal_ae_fkey;
ALTER TABLE IF EXISTS raepa.canalisation_ass DROP CONSTRAINT IF EXISTS val_raepa_typ_reseau_ass_fkey;
ALTER TABLE IF EXISTS raepa.canalisation_ass DROP CONSTRAINT IF EXISTS val_raepa_cat_canal_ass_fkey;
ALTER TABLE IF EXISTS raepa.canalisation_ass DROP CONSTRAINT IF EXISTS val_raepa_fonc_canal_ass_fkey;
ALTER TABLE IF EXISTS raepa.appareillage_ae DROP CONSTRAINT IF EXISTS val_raepa_fonc_app_ae_fkey;
ALTER TABLE IF EXISTS raepa.appareillage_ass DROP CONSTRAINT IF EXISTS val_raepa_typ_reseau_ass_fkey;
ALTER TABLE IF EXISTS raepa.appareillage_ass DROP CONSTRAINT IF EXISTS val_raepa_fonc_app_ass_fkey;
ALTER TABLE IF EXISTS raepa.ouvrage_ae DROP CONSTRAINT IF EXISTS val_raepa_fonc_ouv_ae_fkey;
ALTER TABLE IF EXISTS raepa.ouvrage_ass DROP CONSTRAINT IF EXISTS val_raepa_typ_reseau_ass_fkey;
ALTER TABLE IF EXISTS raepa.ouvrage_ass DROP CONSTRAINT IF EXISTS val_raepa_fonc_ouv_ass_fkey;
ALTER TABLE IF EXISTS raepa.reparation DROP CONSTRAINT IF EXISTS val_raepa_support_incident_fkey;
ALTER TABLE IF EXISTS raepa.reparation DROP CONSTRAINT IF EXISTS val_raepa_defaillance_fkey;
ALTER TABLE IF EXISTS raepa.noeud DROP CONSTRAINT IF EXISTS val_raepa_idcanamont_fkey;
ALTER TABLE IF EXISTS raepa.noeud DROP CONSTRAINT IF EXISTS val_raepa_idcanaval_fkey;
-- classe
DROP TABLE IF EXISTS raepa.metadonnees_raepa;
DROP TABLE IF EXISTS raepa.canalisation;
DROP TABLE IF EXISTS raepa.canalisation_ae;
DROP TABLE IF EXISTS raepa.canalisation_ass;
DROP TABLE IF EXISTS raepa.noeud;
DROP TABLE IF EXISTS raepa.appareillage;
DROP TABLE IF EXISTS raepa.appareillage_ae;
DROP TABLE IF EXISTS raepa.appareillage_ass;
DROP TABLE IF EXISTS raepa.ouvrage;
DROP TABLE IF EXISTS raepa.ouvrage_ae;
DROP TABLE IF EXISTS raepa.ouvrage_ass;
DROP TABLE IF EXISTS raepa.reparation;
-- domaine de valeur
DROP TABLE IF EXISTS raepa.val_raepa_materiau;
DROP TABLE IF EXISTS raepa.val_raepa_mode_circulation;
DROP TABLE IF EXISTS raepa.val_raepa_qualite_anpose;
DROP TABLE IF EXISTS raepa.val_raepa_qualite_geoloc;
DROP TABLE IF EXISTS raepa.val_raepa_support_incident;
DROP TABLE IF EXISTS raepa.val_raepa_defaillance;
DROP TABLE IF EXISTS raepa.val_raepa_cat_canal_ae;
DROP TABLE IF EXISTS raepa.val_raepa_fonc_canal_ae;
DROP TABLE IF EXISTS raepa.val_raepa_fonc_app_ae;
DROP TABLE IF EXISTS raepa.val_raepa_fonc_ouv_ae;
DROP TABLE IF EXISTS raepa.val_raepa_typ_reseau_ass;
DROP TABLE IF EXISTS raepa.val_raepa_cat_canal_ass;
DROP TABLE IF EXISTS raepa.val_raepa_fonc_canal_ass;
DROP TABLE IF EXISTS raepa.val_raepa_fonc_app_ass;
DROP TABLE IF EXISTS raepa.val_raepa_fonc_ouv_ass;
-- sequence
DROP SEQUENCE IF EXISTS raepa.raepa_idraepa;
DROP SEQUENCE IF EXISTS raepa.raepa_idrepar;
-- schema
DROP SCHEMA IF EXISTS raepa;

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                       SCHEMA                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################
-- Schema: raepa
-- DROP SCHEMA raepa;
CREATE SCHEMA raepa;
COMMENT ON SCHEMA raepa
  IS 'Réseaux humides au standard RAEPA';

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                DOMAINES DE VALEURS                                                           ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################
-- ###################
-- ##    AEP/ASS    ##
-- ################### 
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

-- Table: raepa.val_raepa_support_incident
-- DROP TABLE raepa.val_raepa_support_incident;
CREATE TABLE raepa.val_raepa_support_incident
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT raepa_support_incident_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE raepa.val_raepa_support_incident
  IS 'Type d''élément de réseau concerné par un incident';
COMMENT ON COLUMN raepa.val_raepa_support_incident.code IS 'Code de la liste énumérée relative au type d''élément de réseau concerné par une réparation';
COMMENT ON COLUMN raepa.val_raepa_support_incident.valeur IS 'Valeur de la liste énumérée relative au type d''élément de réseau concerné par une réparation';
COMMENT ON COLUMN raepa.val_raepa_support_incident.definition IS 'Définition de la liste énumérée relative au type d''élément de réseau concerné par une réparation';

INSERT INTO raepa.val_raepa_support_incident(
            code, valeur, definition)
    VALUES
('01','Canalisation','Réparation sur une canalisation'),
('02','Appareillage','Réparation d''un appareillage'),
('03','Ouvrage','Réparation d''un ouvrage');

-- Table: raepa.val_raepa_defaillance
-- DROP TABLE raepa.val_raepa_defaillance;
CREATE TABLE raepa.val_raepa_defaillance
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT raepa_defaillance_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE raepa.val_raepa_defaillance
  IS 'Type de défaillance ayant rendu nécessaire une réparation';
COMMENT ON COLUMN raepa.val_raepa_defaillance.code IS 'Code de la liste énumérée relative au type de défaillance';
COMMENT ON COLUMN raepa.val_raepa_defaillance.valeur IS 'Valeur de la liste énumérée relative au type de défaillance';
COMMENT ON COLUMN raepa.val_raepa_defaillance.definition IS 'Définition de la liste énumérée relative au type de défaillance';

INSERT INTO raepa.val_raepa_defaillance(
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

-- ###################
-- ##      AEP      ##
-- ################### 
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

-- Table: raepa.val_raepa_fonc_app_ae
-- DROP TABLE raepa.val_raepa_fonc_app_ae;
CREATE TABLE raepa.val_raepa_fonc_app_ae
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT raepa_cat_app_ae_pkey PRIMARY KEY (code)
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

-- Table: raepa.val_raepa_fonc_app_ass
-- DROP TABLE raepa.val_raepa_fonc_app_ass;
CREATE TABLE raepa.val_raepa_fonc_app_ass
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT raepa_cat_app_ass_pkey PRIMARY KEY (code)
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

-- Table: raepa.val_raepa_fonc_ouv_ass
-- DROP TABLE raepa.val_raepa_fonc_ouv_ass;
CREATE TABLE raepa.val_raepa_fonc_ouv_ass
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT raepa_cat_ouv_ass_pkey PRIMARY KEY (code)
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
-- ################################################################ CLASSE METADONNEES RAEPA ##############################################
-- Table: raepa.metadonnees_raepa
-- DROP TABLE raepa.metadonnees_raepa;
CREATE TABLE raepa.metadonnees_raepa
(
  idraepa character varying(254) NOT NULL,
  qualglocxy character varying(2) NOT NULL, -- fkey vers domaine de valeur
  qualglocz character varying(2) NOT NULL, -- fkey vers domaine de valeur
  datemaj date NOT NULL,
  sourmaj character varying(100) NOT NULL,
  dategeoloc date,
  sourgeoloc character varying(100),
  sourattrib character varying(100),
  qualannee character varying(2), -- information à renseignée uniquement si anposedeb=anposfin pour une canalisation ou un noeud, fkey vers domaine de valeur
  CONSTRAINT metadonnees_raepa_pkey PRIMARY KEY (idraepa)  
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE raepa.metadonnees_raepa
  IS 'Classe décrivant les métadonnées utilisées dans le modèle de données pour qualifier les informations des classes géographiques';
COMMENT ON COLUMN raepa.metadonnees_raepa.idraepa IS 'identifiant de l''entité RAEPA';  
COMMENT ON COLUMN raepa.metadonnees_raepa.qualglocxy IS 'Qualité de la géolocalisation planimétrique (XY)';
COMMENT ON COLUMN raepa.metadonnees_raepa.qualglocz IS 'Qualité de la géolocalisation altimétrique (Z)';
COMMENT ON COLUMN raepa.metadonnees_raepa.datemaj IS 'Date de la dernière mise à jour';
COMMENT ON COLUMN raepa.metadonnees_raepa.sourmaj IS 'Source utilisée pour la dernière mise à jour';
COMMENT ON COLUMN raepa.metadonnees_raepa.dategeoloc IS 'Date de la géolocalisation';
COMMENT ON COLUMN raepa.metadonnees_raepa.sourgeoloc IS 'Source de la géolocalisation';
COMMENT ON COLUMN raepa.metadonnees_raepa.sourattrib IS 'Auteur de la saisie des données attributaires (lorsque différent de l''auteur de la géolocalisation)';
COMMENT ON COLUMN raepa.metadonnees_raepa.qualannee IS 'Fiabilité de l''année de pose ou de mise en service';

-- #################################################################### CLASSE CANALISATION ###############################################
-- Table: raepa.canalisation
-- DROP TABLE raepa.canalisation;
CREATE TABLE raepa.canalisation
(
  idcana character varying(254) NOT NULL,
  mouvrage character varying(100), 
  gexploit character varying(100),  
  enservice character varying(1),
  branchemnt character varying(1),  
  materiau character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  diametre integer,  
  anfinpose character varying(4),
  modecirc character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur    
  idnini character varying(254),
  idnterm character varying(254),
  idcanppale character varying(254),
  andebpose character varying(4),
  longcana integer,    -- unité en mètre et de type entier, pourquoi cette simplification  ?
  nbranche integer,
  geom geometry(LineString,2154),
  CONSTRAINT canalisation_pkey PRIMARY KEY (idcana)  
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE raepa.canalisation
  IS 'Tronçon de conduite';
COMMENT ON COLUMN raepa.canalisation.idcana IS 'Identifiant de la canalisation';
COMMENT ON COLUMN raepa.canalisation.mouvrage IS 'Maître d''ouvrage du réseau';
COMMENT ON COLUMN raepa.canalisation.gexploit IS 'Gestionnaire exploitant du réseau';
COMMENT ON COLUMN raepa.canalisation.enservice IS 'Canalisation en service (O/N)';
COMMENT ON COLUMN raepa.canalisation.branchemnt IS 'Canalisation de branchement individuel (O/N)';
COMMENT ON COLUMN raepa.canalisation.materiau IS 'Matériau de la canalisation';
COMMENT ON COLUMN raepa.canalisation.diametre IS 'Diamètre nominal de la canalisation (en millimètres)';
COMMENT ON COLUMN raepa.canalisation.anfinpose IS 'Année marquant la fin de la période de pose de la canalisation';
COMMENT ON COLUMN raepa.canalisation.modecirc IS 'Mode de circulation de l''eau à l''intérieur de la canalisation';
COMMENT ON COLUMN raepa.canalisation.idnini IS 'Identifiant du noeud de début de la canalisation';
COMMENT ON COLUMN raepa.canalisation.idnterm IS 'Identifiant du noeud de fin de la canalisation';
COMMENT ON COLUMN raepa.canalisation.idcanppale IS 'Identifiant de la canalisation principale';
COMMENT ON COLUMN raepa.canalisation.andebpose IS 'Année marquant le début de la période de pose de la canalisation';
COMMENT ON COLUMN raepa.canalisation.longcana IS 'Longueur mesurée de la canalisation (en mètres)';
COMMENT ON COLUMN raepa.canalisation.nbranche IS 'Nombre de branchements individuels sur la canalisation';
COMMENT ON COLUMN raepa.canalisation.geom IS 'Géométrie linéaire de l''objet';

ALTER TABLE raepa.canalisation ALTER COLUMN idcana SET DEFAULT nextval('raepa.raepa_idraepa'::regclass);

-- #################################################################### SSCLASSE CANALISATION AEP ###############################################
-- Table: raepa.canalisation_ae
-- DROP TABLE raepa.canalisation_ae;
CREATE TABLE raepa.canalisation_ae
(
  idcana character varying(254) NOT NULL, -- fkey vers attribut idcana de la classe canalisation
  contcanaep character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  fonccanaep character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  profgen numeric (3,2), -- !!!!!! usage pour le DT-DICT qui n'a pas sa spécificité sur un réseau d'ae. L'emploi de la profondeur par rapport à la cote NGF est par ailleurs dangereuse et il aurait été plus pertinent d'utiliser la côte de la génératrice supérieure
  CONSTRAINT canalisation_ae_pkey PRIMARY KEY (idcana)  
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE raepa.canalisation_ae
  IS 'Tronçon de conduite d''adduction d''eau';
COMMENT ON COLUMN raepa.canalisation_ae.idcana IS 'Identifiant de la canalisation';
COMMENT ON COLUMN raepa.canalisation_ae.contcanaep IS 'Catégorie de la canalisation d''adduction d''eau';
COMMENT ON COLUMN raepa.canalisation_ae.fonccanaep IS 'Fonction de la canalisation d''adduction d''eau';
COMMENT ON COLUMN raepa.canalisation_ae.profgen IS 'Profondeur moyenne de la génératrice supérieure de la canalisation (en mètres)';

-- #################################################################### SSCLASSE CANALISATION ASS ###############################################
-- Table: raepa.canalisation_ass
-- DROP TABLE raepa.canalisation_ass;
CREATE TABLE raepa.canalisation_ass
(
  idcana character varying(254) NOT NULL, -- fkey vers attribut idcana de la classe canalisation
  typreseau character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  contcanass character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  fonccanass character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  zamont numeric (6,2),
  zaval numeric (6,2),
  sensecoul character varying(1), -- !!!!!! existe dans le modèle implementé en fichier mais absent du MCD RAEPA
  CONSTRAINT canalisation_ass_pkey PRIMARY KEY (idcana)  
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE raepa.canalisation_ass
  IS 'Tronçon de conduite d''assainissement collectif';
COMMENT ON COLUMN raepa.canalisation_ass.idcana IS 'Identifiant de la canalisation';
COMMENT ON COLUMN raepa.canalisation_ass.typreseau IS 'Type du réseau d''assainissement collectif';
COMMENT ON COLUMN raepa.canalisation_ass.contcanass IS 'Catégorie de la canalisation d''assainissement collectif';
COMMENT ON COLUMN raepa.canalisation_ass.fonccanass IS 'Fonction de la canalisation d''assainissement collectif';
COMMENT ON COLUMN raepa.canalisation_ass.zamont IS 'Altitude à l''extrémité amont (en mètres, référentiel NGF-IGN69)';  
COMMENT ON COLUMN raepa.canalisation_ass.zaval IS 'Altitude à l''extrémité aval (en mètres, référentiel NGF-IGN69)';   
COMMENT ON COLUMN raepa.canalisation_ass.sensecoul IS 'Sens de l''écoulement dans la canalisation d''assainissement collectif';  

-- #################################################################### SUPER CLASSE NOEUD ###############################################
-- Table: raepa.noeud
-- DROP TABLE raepa.noeud;
CREATE TABLE raepa.noeud
(
  idnoeud character varying(254) NOT NULL,
  x numeric(10,3) NOT NULL,
  y numeric(10,3) NOT NULL,
  mouvrage character varying(100),
  gexploit character varying(100),
  anfinpose character varying(4),
  idcanppale character varying(254), -- fkey vers attribut idcana de la classe canalisation. Valeur NULL admise car ne sert à renseigner la cana principale pour un noeud de raccord (piquage) du branchement sur une canalisation principale
  idcanamont character varying(254) NOT NULL, -- fkey vers attribut idcana de la classe canalisation.
  idcanaval character varying(254) NOT NULL, -- fkey vers attribut idcana de la classe canalisation.
  andebpose character varying(4),
  geom geometry(Point,2154),
  CONSTRAINT noeud_pkey PRIMARY KEY (idnoeud) 
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE raepa.noeud
  IS 'Lieu de jonction de plusieurs tronçons de conduite ou de percement d''un tronçon de conduite';
COMMENT ON COLUMN raepa.noeud.idnoeud IS 'Identifiant du noeud';
COMMENT ON COLUMN raepa.noeud.x IS 'Coordonnée X Lambert 93 (en mètres)';
COMMENT ON COLUMN raepa.noeud.y IS 'Coordonnée X Lambert 93 (en mètres)';
COMMENT ON COLUMN raepa.noeud.mouvrage IS 'Maître d''ouvrage du réseau';
COMMENT ON COLUMN raepa.noeud.gexploit IS 'Gestionnaire exploitant du réseau';
COMMENT ON COLUMN raepa.noeud.anfinpose IS 'Année marquant la fin de la période de mise en service de l''appareillage et/ou de l''ouvrage';
COMMENT ON COLUMN raepa.noeud.idcanppale IS 'Identifiant de la canalisation principale en cas de piquage';
COMMENT ON COLUMN raepa.noeud.idcanamont IS 'Identifiant de la canalisation amont';
COMMENT ON COLUMN raepa.noeud.idcanaval IS 'Identifiant de la canalisation aval';
COMMENT ON COLUMN raepa.noeud.andebpose IS 'Année marquant le début de la période de mise en service de l''appareillage et/ou de l''ouvrage';
COMMENT ON COLUMN raepa.noeud.geom IS 'Géométrie ponctuelle de l''objet';

ALTER TABLE raepa.noeud ALTER COLUMN idnoeud SET DEFAULT nextval('raepa.raepa_idraepa'::regclass);

-- #################################################################### CLASSE APPAREILLAGE ###############################################
-- Table: raepa.appareillage
-- DROP TABLE raepa.appareillage;
CREATE TABLE raepa.appareillage
(
  idappareil character varying(254) NOT NULL,
--  idnoeud character varying(254) NOT NULL, -- fkey vers attribut idnoeud de la classe noeud   si on considère qu'un noeud peut avoir plusieurs objets
  idouvrage character varying(254), -- fkey vers attribut idouvrage de la classe ouvrage. Valeur NULL admise car il n'y a pas forcement un ouvrage qui accueille l'appareillage
  diametre integer, -- A PRIORI attribut manquant dans la modélisation à ce niveau car présent dans les gabarits des livrables d'appareillage ae et ass et absent pour les ouvrages
  z numeric(6,2),
  CONSTRAINT appareillage_pkey PRIMARY KEY (idappareil) 
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE raepa.appareillage
  IS 'Appareillage';
COMMENT ON COLUMN raepa.appareillage.idappareil IS 'Identifiant de l''appareillage';
-- COMMENT ON COLUMN raepa.appareillage.idnoeud IS 'Identifiant du noeud';
 COMMENT ON COLUMN raepa.appareillage.idouvrage IS 'Identifiant de l''éventuel ouvrage d''accueil';
 COMMENT ON COLUMN raepa.appareillage.diametre IS 'Diamètre nominal de l''appareillage (en millimètres)';
COMMENT ON COLUMN raepa.appareillage.z IS 'Altitude du noeud (en mètres, Référentiel NGFIGN69)';  
  
-- #################################################################### SSCLASSE APPAREILLAGE AEP ###############################################
-- Table: raepa.appareillage_ae
-- DROP TABLE raepa.appareillage_ae;
CREATE TABLE raepa.appareillage_ae
(
  idappareil character varying(254) NOT NULL, -- fkey vers attribut idappareil de la classe appareillage
  fnappaep character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  CONSTRAINT appareillage_ae_pkey PRIMARY KEY (idappareil) 
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE raepa.appareillage_ae
  IS 'Appareillage d''adduction d''eau';
COMMENT ON COLUMN raepa.appareillage_ae.idappareil IS 'Identifiant de l''appareillage';
COMMENT ON COLUMN raepa.appareillage_ae.fnappaep IS 'Fonction de l''appareillage d''adduction d''eau potable';
  
-- #################################################################### SSCLASSE APPAREILLAGE ASS ###############################################
-- Table: raepa.appareillage_ass
-- DROP TABLE raepa.appareillage_ass;
CREATE TABLE raepa.appareillage_ass
(
  idappareil character varying(254) NOT NULL, -- fkey vers attribut idappareil de la classe appareillage
  typreseau character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  fnappass character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  CONSTRAINT appareillage_ass_pkey PRIMARY KEY (idappareil)  
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE raepa.appareillage_ass
  IS 'Appareillage d''assainissement collectif';
COMMENT ON COLUMN raepa.appareillage_ass.idappareil IS 'Identifiant de l''appareillage';
COMMENT ON COLUMN raepa.appareillage_ass.typreseau IS 'Type du réseau d''assainissement collectif';
COMMENT ON COLUMN raepa.appareillage_ass.fnappass IS 'Fonction de l''appareillage d''assainissement collectif';
  
-- #################################################################### CLASSE OUVRAGE ###############################################
-- Table: raepa.ouvrage
-- DROP TABLE raepa.ouvrage;
CREATE TABLE raepa.ouvrage
(
  idouvrage character varying(254) NOT NULL,
--  idnoeud character varying(254) NOT NULL, -- fkey vers attribut idnoeud de la classe noeud si on considère qu'un noeud peut avoir plusieurs objets
  z numeric(6,2),
  CONSTRAINT ouvrage_pkey PRIMARY KEY (idouvrage) 
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE raepa.ouvrage
  IS 'Ouvrage';
COMMENT ON COLUMN raepa.ouvrage.idouvrage IS 'Identifiant de l''ouvrage';
-- COMMENT ON COLUMN raepa.ouvrage.idnoeud IS 'Identifiant du noeud';
COMMENT ON COLUMN raepa.ouvrage.z IS 'Altitude radier de l''ouvrage (en mètres, Référentiel NGFIGN69)';  

-- #################################################################### SSCLASSE OUVRAGE AE ###############################################
-- Table: raepa.ouvrage_ae
-- DROP TABLE raepa.ouvrage_ae;
CREATE TABLE raepa.ouvrage_ae
(
  idouvrage character varying(254) NOT NULL, -- fkey vers attribut idouvrage de la classe ouvrage
  fnouvaep character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  CONSTRAINT ouvrage_ae_pkey PRIMARY KEY (idouvrage) 
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE raepa.ouvrage_ae
  IS 'Ouvrage d''adduction d''eau';
COMMENT ON COLUMN raepa.ouvrage_ae.idouvrage IS 'Identifiant de l''ouvrage';
COMMENT ON COLUMN raepa.ouvrage_ae.fnouvaep IS 'Fonction de l''ouvrage d''adduction d''eau potable';

-- #################################################################### SSCLASSE OUVRAGE ASS ###############################################
-- Table: raepa.ouvrage_ass
-- DROP TABLE raepa.ouvrage_ass;
CREATE TABLE raepa.ouvrage_ass
(
  idouvrage character varying(254) NOT NULL, -- fkey vers attribut idouvrage de la classe ouvrage
  typreseau character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  fnouvass character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  CONSTRAINT ouvrage_ass_pkey PRIMARY KEY (idouvrage) 
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE raepa.ouvrage_ass
  IS 'Ouvrage d''assainissement collectif';
COMMENT ON COLUMN raepa.ouvrage_ass.idouvrage IS 'Identifiant de l''ouvrage';
COMMENT ON COLUMN raepa.ouvrage_ass.typreseau IS 'Type du réseau d''assainissement collectif';
COMMENT ON COLUMN raepa.ouvrage_ass.fnouvass IS 'Fonction de l''ouvrage d''assainissement collectif';

-- #################################################################### CLASSE REPARATION ###############################################
CREATE TABLE raepa.reparation
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
  CONSTRAINT reparation_pkey PRIMARY KEY (idrepar) 
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE raepa.reparation
  IS 'Lieu d''une intervention sur le réseau effectuée suite à une défaillance dudit réseau';
COMMENT ON COLUMN raepa.reparation.idrepar IS 'Identifiant de la réparation effectuée';
COMMENT ON COLUMN raepa.reparation.x IS 'Coordonnée X Lambert 93 (en mètres)';
COMMENT ON COLUMN raepa.reparation.y IS 'Coordonnée Y Lambert 93 (en mètres)';
COMMENT ON COLUMN raepa.reparation.supprepare IS 'Type de support de la réparation';
COMMENT ON COLUMN raepa.reparation.defreparee IS 'Type de défaillance';
COMMENT ON COLUMN raepa.reparation.idsuprepar IS 'Identifiant du support de la réparation';
COMMENT ON COLUMN raepa.reparation.daterepar IS 'Date de l''intervention en réparation';
COMMENT ON COLUMN raepa.reparation.mouvrage IS 'Maître d''ouvrage de la réparation';
COMMENT ON COLUMN raepa.reparation.geom IS 'Géométrie ponctuelle de l''objet';

ALTER TABLE raepa.reparation ALTER COLUMN idrepar SET DEFAULT nextval('raepa.raepa_idrepar'::regclass);

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                           FKEY (clé étrangère)                                                               ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################
-- ID
-- DOMAINE DE VALEUR
-- ############ METADONNEES RAEPA ############
ALTER TABLE raepa.metadonnees_raepa
  ADD CONSTRAINT val_raepa_qualite_anpose_fkey FOREIGN KEY (qualannee)
      REFERENCES raepa.val_raepa_qualite_anpose (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_raepa_qualite_geoloc_xy_fkey FOREIGN KEY (qualglocxy)
      REFERENCES raepa.val_raepa_qualite_geoloc (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,         
  ADD CONSTRAINT val_raepa_qualite_geoloc_z_fkey FOREIGN KEY (qualglocz)
      REFERENCES raepa.val_raepa_qualite_geoloc (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;   

-- ############ NOEUD ############
ALTER TABLE raepa.noeud
  ADD CONSTRAINT val_raepa_idcanamont_fkey FOREIGN KEY (idcanamont)
      REFERENCES raepa.canalisation (idcana) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_raepa_idcanaval_fkey FOREIGN KEY (idcanaval)
      REFERENCES raepa.canalisation (idcana) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- ############ CANALISATION ############
-- ************ RAEPA_CANAL ************  
ALTER TABLE raepa.canalisation
  ADD CONSTRAINT val_raepa_materiau_fkey FOREIGN KEY (materiau)
      REFERENCES raepa.val_raepa_materiau (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_raepa_mode_circulation_fkey FOREIGN KEY (modecirc)
      REFERENCES raepa.val_raepa_mode_circulation (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
    
-- ************ RAEPA_CANAL_AEP ************       
ALTER TABLE raepa.canalisation_ae
  ADD CONSTRAINT val_raepa_cat_canal_ae_fkey FOREIGN KEY (contcanaep)
      REFERENCES raepa.val_raepa_cat_canal_ae (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,           
  ADD CONSTRAINT val_raepa_fonc_canal_ae_fkey FOREIGN KEY (fonccanaep)
      REFERENCES raepa.val_raepa_fonc_canal_ae (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
      
-- ************ RAEPA_CANAL_ASS ************   
ALTER TABLE raepa.canalisation_ass
  ADD CONSTRAINT val_raepa_typ_reseau_ass_fkey FOREIGN KEY (typreseau)
      REFERENCES raepa.val_raepa_typ_reseau_ass (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT val_raepa_cat_canal_ass_fkey FOREIGN KEY (contcanass)
      REFERENCES raepa.val_raepa_cat_canal_ass (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,           
  ADD CONSTRAINT val_raepa_fonc_canal_ass_fkey FOREIGN KEY (fonccanass)
      REFERENCES raepa.val_raepa_fonc_canal_ass (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- ############ APPAREILLAGE ############
-- ************ RAEPA_APPAR_AEP ************  
ALTER TABLE raepa.appareillage_ae
  ADD CONSTRAINT val_raepa_fonc_app_ae_fkey FOREIGN KEY (fnappaep)
      REFERENCES raepa.val_raepa_fonc_app_ae (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;   

-- ************ RAEPA_APPAR_ASS ************  
ALTER TABLE raepa.appareillage_ass
  ADD CONSTRAINT val_raepa_typ_reseau_ass_fkey FOREIGN KEY (typreseau)
      REFERENCES raepa.val_raepa_typ_reseau_ass (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,        
  ADD CONSTRAINT val_raepa_fonc_app_ass_fkey FOREIGN KEY (fnappass)
      REFERENCES raepa.val_raepa_fonc_app_ass (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;                     
 
-- ############ OUVRAGE ############
-- ************ RAEPA_OUVR_AEP ************  
ALTER TABLE raepa.ouvrage_ae
  ADD CONSTRAINT val_raepa_fonc_ouv_ae_fkey FOREIGN KEY (fnouvaep)
      REFERENCES raepa.val_raepa_fonc_ouv_ae (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;   

-- ************ RAEPA_OUVR_ASS ************  
ALTER TABLE raepa.ouvrage_ass
  ADD CONSTRAINT val_raepa_typ_reseau_ass_fkey FOREIGN KEY (typreseau)
      REFERENCES raepa.val_raepa_typ_reseau_ass (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,        
  ADD CONSTRAINT val_raepa_fonc_ouv_ass_fkey FOREIGN KEY (fnouvass)
      REFERENCES raepa.val_raepa_fonc_ouv_ass (code) MATCH SIMPLE

      ON UPDATE NO ACTION ON DELETE NO ACTION;  

-- ############ REPARATION ############
-- ************ RAEPA_REPAR ************       
ALTER TABLE raepa.reparation
  ADD CONSTRAINT val_raepa_support_incident_fkey FOREIGN KEY (supprepare)
      REFERENCES raepa.val_raepa_support_incident (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,        
  ADD CONSTRAINT val_raepa_defaillance_fkey FOREIGN KEY (defreparee)
      REFERENCES raepa.val_raepa_defaillance (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
 
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        VUES                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################
-- #################################################################### VUE CANALISATION AEP ###############################################
-- View: raepa.raepa_canalaep_l
-- DROP VIEW raepa.raepa_canalaep_l;
CREATE MATERIALIZED VIEW raepa.raepa_canalaep_l AS 
 SELECT 
  a.idcana,
  g.mouvrage,
  g.gexploit, 
  g.enservice,
  g.branchemnt,
  g.materiau,
  g.diametre,  
  g.anfinpose,
  g.modecirc,
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
  
FROM raepa.canalisation_ae a
LEFT JOIN raepa.canalisation g ON g.idcana = a.idcana
LEFT JOIN raepa.metadonnees_raepa m ON a.idcana = m.idraepa
ORDER BY a.idcana;

COMMENT ON MATERIALIZED VIEW raepa.raepa_canalaep_l
  IS 'Canalisation d''adduction d''eau';
 
-- #################################################################### VUE CANALISATION ASS ###############################################
-- View: raepa.raepa_canalass_l
-- DROP VIEW raepa.raepa_canalass_l;
CREATE MATERIALIZED VIEW raepa.raepa_canalass_l AS 
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
  g.modecirc,
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
  
FROM raepa.canalisation_ass a
LEFT JOIN raepa.canalisation g ON g.idcana = a.idcana
LEFT JOIN raepa.metadonnees_raepa m ON a.idcana = m.idraepa
ORDER BY a.idcana;

COMMENT ON MATERIALIZED VIEW raepa.raepa_canalass_l
  IS 'Canalisation d''assainissement collectif';

-- #################################################################### VUE APPAREILLAGE AEP ###############################################
-- View: raepa.raepa_apparaep_p
-- DROP VIEW raepa.raepa_apparaep_p;
CREATE MATERIALIZED VIEW raepa.raepa_apparaep_p AS 
 SELECT
  ab.idappareil,
  g.x,
  g.y,
  g.mouvrage,
  g.gexploit,
  ab.fnappaep,
  g.anfinpose,
  a.diametre ::integer, -- A PRIORI soit : attribut manquant dans la modélisation à ce niveau car présent dans les gabarits des livrables d'appareillage ae et ass et absent pour les ouvrages / soit : attribut implémenté et qui ne devrait pas l'être / MCD
  g.idcanamont,
  g.idcanaval,  
  g.idcanppale,
  g.idnoeud as idouvrage,  -- prb si on gère séquence unique de noeud sans géré sequence ouvrage et appareil
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

FROM raepa.appareillage_ae ab
LEFT JOIN raepa.noeud g ON g.idnoeud = ab.idappareil
LEFT JOIN raepa.appareillage a ON a.idappareil = ab.idappareil
LEFT JOIN raepa.metadonnees_raepa m ON ab.idappareil = m.idraepa
ORDER BY ab.idappareil;

COMMENT ON MATERIALIZED VIEW raepa.raepa_apparaep_p
  IS 'Appareillage d''adduction d''eau';

-- #################################################################### VUE APPAREILLAGE ASS ###############################################
-- View: raepa.raepa_apparass_p
-- DROP VIEW raepa.raepa_apparass_p;
CREATE MATERIALIZED VIEW raepa.raepa_apparass_p AS 
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
  g.idnoeud as idouvrage,  -- prb si on gère séquence unique de noeud sans géré sequence ouvrage et appareil
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

FROM raepa.appareillage_ass ab
LEFT JOIN raepa.noeud g ON g.idnoeud = ab.idappareil
LEFT JOIN raepa.appareillage a ON a.idappareil = ab.idappareil
LEFT JOIN raepa.metadonnees_raepa m ON ab.idappareil = m.idraepa
ORDER BY ab.idappareil;

COMMENT ON MATERIALIZED VIEW raepa.raepa_apparass_p
  IS 'Appareillage d''assanissement collectif';

-- #################################################################### VUE OUVRAGE AEP ###############################################
-- View: raepa.raepa_ouvraep_p
-- DROP VIEW raepa.raepa_ouvraep_p;
CREATE MATERIALIZED VIEW raepa.raepa_ouvraep_p AS 
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

FROM raepa.ouvrage_ae ab
LEFT JOIN raepa.noeud g ON g.idnoeud = ab.idouvrage
LEFT JOIN raepa.ouvrage a ON a.idouvrage = ab.idouvrage
LEFT JOIN raepa.metadonnees_raepa m ON ab.idouvrage = m.idraepa
ORDER BY ab.idouvrage;

COMMENT ON MATERIALIZED VIEW raepa.raepa_ouvraep_p
  IS 'Ouvrage d''adduction d''eau';

-- #################################################################### VUE OUVRAGE ASS ###############################################
-- View: raepa.raepa_ouvrass_p
-- DROP VIEW raepa.raepa_ouvrass_p;
CREATE MATERIALIZED VIEW raepa.raepa_ouvrass_p AS 
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

FROM raepa.ouvrage_ass ab
LEFT JOIN raepa.noeud g ON g.idnoeud = ab.idouvrage
LEFT JOIN raepa.ouvrage a ON a.idouvrage = ab.idouvrage
LEFT JOIN raepa.metadonnees_raepa m ON ab.idouvrage = m.idraepa
ORDER BY ab.idouvrage;

COMMENT ON MATERIALIZED VIEW raepa.raepa_ouvrass_p
  IS 'Ouvrage d''assainissement collectif';

-- #################################################################### VUE REPARATION AEP ###############################################
-- View: raepa.raepa_reparaep_p
-- DROP VIEW raepa.raepa_reparaep_p;
CREATE MATERIALIZED VIEW raepa.raepa_reparaep_p AS 
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

FROM raepa.reparation g
-- voir comment gérer le WHERE pour récup uniquement AEP
ORDER BY g.idrepar;

COMMENT ON MATERIALIZED VIEW raepa.raepa_reparaep_p
  IS 'Reparation du réseau d''adduction d''eau';

-- #################################################################### VUE REPARATION ASS ###############################################
-- View: raepa.raepa_reparass_p
-- DROP VIEW raepa.raepa_reparass_p;
CREATE MATERIALIZED VIEW raepa.raepa_reparass_p AS 
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

FROM raepa.reparation g
-- voir comment gérer le WHERE pour récup uniquement ASS
ORDER BY g.idrepar;

COMMENT ON MATERIALIZED VIEW raepa.raepa_reparass_p
  IS 'Reparation du réseau d''assainissement collectif';