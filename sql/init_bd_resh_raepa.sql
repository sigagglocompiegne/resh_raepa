-- #################################################################### SUIVI CODE SQL ####################################################################


/*

principes généraux : implémentation en base au plus proche du modèle conceptuel des données, la reconstruction de classe fine plus proche d'un mode fichier à plat, est assurée par des vues

- les classes sont communes AEP, ASS et sont au nombre de:
  - canalisation
  - noeud
  - reparation  
 des sous classes appareillage et ouvrage hèritent de la géométrie de la classe noeud
 la classe noeud est elle même dépendante d'une surclasse AffleurantSymbolePCRS. tout noeud du réseau poosède les mêmes coordonnées x et y que le centre d'un affleurant symbolisé dans le PCRS d'angle de rotation 0, de longueur et de largeur 1
 


__ CANALISATION
  |
  |__ CANA AEP
  |
  |__ CANA ASS
     |
     |__ CANA EU
     |
     |__ CANA EP
     |
     |__ CANA UN ???   
      
__ NOEUD
  |
  |__ NOEUD ( autre) ==> voir si prévu par le MCD
  |
  |__ OUVRAGE
  |  |
  |  |__ OUVRAGE AEP
  |  |
  |  |__ OUVRAGE ASS
  |     |
  |     |__ OUVRAGE specialise ...
  |
  |  
  |
  |__ APPAREILLAGE
     |
     |__ APPAREILLAGE AEP
     |
     |__ APPAREILLAGE ASS
        |
        |__ APPAREILLAGE specialise ...

__ REPARATION


TO DO :

-- gérer les valeurs par défaut pour les différents domaines de valeur
-- prévoir d'étendre les domaines de valeur pour gérer les sscat ouvrage et appareillage ae/ass pour gérer les spécificités
-- prévoir les sous-sous-classes très spécialisées (ex : avaloir par sous type dans le cadre du SDGEP)
-- gérer les fkey sur les id entre classes
-- implémenter les relations (attributs) de la table noeud (ex : id cana amont/aval, ...) et de la classe appareillage (un appar est forcement dans un ouvrage)

*/






-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        DROP                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- vue
DROP VIEW IF EXISTS m_reseau_humide.geo_v_raepa_canalass;
DROP VIEW IF EXISTS m_reseau_humide.geo_v_raepa_canalae;
DROP VIEW IF EXISTS m_reseau_humide.geo_v_raepa_apparaep;
DROP VIEW IF EXISTS m_reseau_humide.geo_v_raepa_apparass;
DROP VIEW IF EXISTS m_reseau_humide.geo_v_raepa_ouvraep;
DROP VIEW IF EXISTS m_reseau_humide.geo_v_raepa_ouvrass;
-- fkey
ALTER TABLE m_reseau_humide.geo_raepa_repar DROP CONSTRAINT IF EXISTS an_raepa_id_fkey;
ALTER TABLE m_reseau_humide.geo_raepa_canal DROP CONSTRAINT IF EXISTS an_raepa_id_fkey;
ALTER TABLE m_reseau_humide.an_raepa_canalae DROP CONSTRAINT IF EXISTS idcana_fkey;
ALTER TABLE m_reseau_humide.an_raepa_canalass DROP CONSTRAINT IF EXISTS idcana_fkey;
ALTER TABLE m_reseau_humide.geo_raepa_noeud DROP CONSTRAINT IF EXISTS idcanppale_fkey;
ALTER TABLE m_reseau_humide.an_raepa_appar DROP CONSTRAINT IF EXISTS idnoeud_fkey;
ALTER TABLE m_reseau_humide.an_raepa_ouvr DROP CONSTRAINT IF EXISTS idnoeud_fkey;
-- classe
DROP TABLE IF EXISTS m_reseau_humide.an_raepa_id;
DROP TABLE IF EXISTS m_reseau_humide.geo_raepa_canal;
DROP TABLE IF EXISTS m_reseau_humide.an_raepa_canalae;
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
-- sequence
DROP SEQUENCE IF EXISTS m_reseau_humide.geo_raepa_repar_id_seq;
DROP SEQUENCE IF EXISTS m_reseau_humide.geo_raepa_canal_id_seq;
DROP SEQUENCE IF EXISTS m_reseau_humide.geo_raepa_noeud_id_seq;
DROP SEQUENCE IF EXISTS m_reseau_humide.an_raepa_appar_id_seq;
DROP SEQUENCE IF EXISTS m_reseau_humide.an_raepa_ouvr_id_seq;

/*

-- #################################################################### SCHEMA  ####################################################################

-- Schema: m_reseau_humide

-- DROP SCHEMA m_reseau_humide;

CREATE SCHEMA m_reseau_humide
  AUTHORIZATION sig_create;

GRANT ALL ON SCHEMA m_reseau_humide TO postgres;
GRANT ALL ON SCHEMA m_reseau_humide TO groupe_sig WITH GRANT OPTION;
COMMENT ON SCHEMA m_reseau_humide
  IS 'Données géographiques métiers sur le thème des réseaux humides';

*/


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                DOMAINES DE VALEURS                                                           ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- ###################
-- ##    AEP/ASS    ##
-- ################### 


-- Table: m_reseau_humide.lt_raepa_materiau

-- DROP TABLE m_reseau_humide.lt_raepa_materiau;


/*
domaine de valeur trop fin, voir pour créer un système de nomenclature emboité (ex : 10=béton, 11=béton âme tôle ...) permettant également de servir de table de passage vers les codes RAEPA
*/


CREATE TABLE m_reseau_humide.lt_raepa_materiau
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT lt_raepa_materiau_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.lt_raepa_materiau
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.lt_raepa_materiau TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.lt_raepa_materiau TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.lt_raepa_materiau TO edit_sig;

COMMENT ON TABLE m_reseau_humide.lt_raepa_materiau
  IS 'Code permettant de décrire le matériau constitutif des tuyaux composant une canalisation';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_materiau.code IS 'Code de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_materiau.valeur IS 'Valeur de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_materiau.definition IS 'Définition de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation';

INSERT INTO m_reseau_humide.lt_raepa_materiau(
            code, valeur, definition)
    VALUES
('00','Indéterminé','Canalisation composée de tuyaux dont le matériau est inconnu'),
('01','Acier','Canalisation composée de tuyaux d''acier'),
('02','Amiante-ciment','Canalisation composée de tuyaux d''amiante-ciment'),
('03','Béton âme tôle','Canalisation composée de tuyaux de béton âme tôle'),
('04','Béton armé','Canalisation composée de tuyaux de béton armé'),
('05','Béton fibré','Canalisation composée de tuyaux de béton fibré'),
('06','Béton non armé','Canalisation composée de tuyaux d''amiante-ciment'),
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


-- Table: m_reseau_humide.lt_raepa_mode_circulation

-- DROP TABLE m_reseau_humide.lt_raepa_mode_circulation;

CREATE TABLE m_reseau_humide.lt_raepa_mode_circulation
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT lt_raepa_mode_circulation_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.lt_raepa_mode_circulation
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.lt_raepa_mode_circulation TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.lt_raepa_mode_circulation TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.lt_raepa_mode_circulation TO edit_sig;

COMMENT ON TABLE m_reseau_humide.lt_raepa_mode_circulation
  IS 'Code permettant de décrire le mode de circulation de l''eau dans une canalisation';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_mode_circulation.code IS 'Code de la liste énumérée relative au mode de circualtion de l''eau dans une canalisation';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_mode_circulation.valeur IS 'Valeur de la liste énumérée relative au mode de circualtion de l''eau dans une canalisation';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_mode_circulation.definition IS 'Définition de la liste énumérée relative au mode de circualtion de l''eau dans une canalisation';

INSERT INTO m_reseau_humide.lt_raepa_mode_circulation(
            code, valeur, definition)
    VALUES
('00','Indéterminé','Mode de circulation inconnu'),
('01','Gravitaire','L''eau s''écoule par l''effet de la pesanteur dans la canalisation en pente'),
('02','Forcé','L''eau circule sous pression dans la canalisation grâce à un système de pompage'),
('03','Sous-vide','L''eau circule par l''effet de la mise sous vide de la canalisation par une centrale d''aspiration'),
('99','Autre','L''eau circule tantôt dans un des modes ci-dessus tantôt dans un autre');


-- Table: m_reseau_humide.lt_raepa_qualite_anpose

-- DROP TABLE m_reseau_humide.lt_raepa_qualite_anpose;

CREATE TABLE m_reseau_humide.lt_raepa_qualite_anpose
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT lt_raepa_qualite_anpose_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.lt_raepa_qualite_anpose
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.lt_raepa_qualite_anpose TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.lt_raepa_qualite_anpose TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.lt_raepa_qualite_anpose TO edit_sig;

COMMENT ON TABLE m_reseau_humide.lt_raepa_qualite_anpose
  IS 'Code permettant de décrire la qualité de l''information "année de pose" ou "année de mise en service" d''un équipement';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_qualite_anpose.code IS 'Code de la liste énumérée relative à la qualité de l''information "année de pose" ou "année de mise en service" d''un équipement';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_qualite_anpose.valeur IS 'Valeur de la liste énumérée relative à la qualité de l''information "année de pose" ou "année de mise en service" d''un équipement';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_qualite_anpose.definition IS 'Définition de la liste énumérée relative à la qualité de l''information "année de pose" ou "année de mise en service" d''un équipement';

INSERT INTO m_reseau_humide.lt_raepa_qualite_anpose(
            code, valeur, definition)
    VALUES
('00','Indéterminé','Information ou qualité de l''information inconnue'),
('01','Certaine','Année constatée durant les travaux de pose'),
('02','Récolement','Année reprise sur plans de récolement'),
('03','Projet','Année reprise sur plans de projet'),
('04','Mémoire','Année issue de souvenir(s) individuel(s)'),
('05','Déduite','Année déduite du matériau ou de l''état de l''équipement');


-- Table: m_reseau_humide.lt_raepa_qualite_geoloc

-- DROP TABLE m_reseau_humide.lt_raepa_qualite_geoloc;

CREATE TABLE m_reseau_humide.lt_raepa_qualite_geoloc
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT lt_raepa_qualite_geoloc_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.lt_raepa_qualite_geoloc
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.lt_raepa_qualite_geoloc TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.lt_raepa_qualite_geoloc TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.lt_raepa_qualite_geoloc TO edit_sig;

COMMENT ON TABLE m_reseau_humide.lt_raepa_qualite_geoloc
  IS 'Code permettant de décrire la classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_qualite_geoloc.code IS 'Code de la liste énumérée relative à la classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_qualite_geoloc.valeur IS 'Valeur de la liste énumérée relative à la classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_qualite_geoloc.definition IS 'Définition de la liste énumérée relative à la classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';

INSERT INTO m_reseau_humide.lt_raepa_qualite_geoloc(
            code, valeur, definition)
    VALUES
('01','Classe A','Classe de précision inférieure 40 cm'),
('02','Classe B','Classe de précision supérieure à 40 cm et inférieure à 1,50 m'),
('03','Classe C','Classe de précision supérieure à 1,50 m');
--(('03','Classe C','Classe de précision supérieure à 1,50 m ou précision inconnue') -- voir si nécessaire de préciser que si la qualite de geoloc n'est pas connue, alors on classe en C;


-- Table: m_reseau_humide.lt_raepa_support_incident

-- DROP TABLE m_reseau_humide.lt_raepa_support_incident;

CREATE TABLE m_reseau_humide.lt_raepa_support_incident
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT lt_raepa_support_incident_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.lt_raepa_support_incident
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.lt_raepa_support_incident TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.lt_raepa_support_incident TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.lt_raepa_support_incident TO edit_sig;

COMMENT ON TABLE m_reseau_humide.lt_raepa_support_incident
  IS 'Code permettant de décrire le type d''élément de réseau concerné par un incident';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_support_incident.code IS 'Code de la liste énumérée relative au type d''élément de réseau concerné par une réparation';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_support_incident.valeur IS 'Valeur de la liste énumérée relative au type d''élément de réseau concerné par une réparation';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_support_incident.definition IS 'Définition de la liste énumérée relative au type d''élément de réseau concerné par une réparation';

INSERT INTO m_reseau_humide.lt_raepa_support_incident(
            code, valeur, definition)
    VALUES
('01','Canalisation','Réparation sur une canalisation'),
('02','Appareillage','Réparation d''un appareillage'),
('03','Ouvrage','Réparation d''un ouvrage');

 

-- Table: m_reseau_humide.lt_raepa_defaillance

-- DROP TABLE m_reseau_humide.lt_raepa_defaillance;

CREATE TABLE m_reseau_humide.lt_raepa_defaillance
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT lt_raepa_defaillance_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.lt_raepa_defaillance
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.lt_raepa_defaillance TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.lt_raepa_defaillance TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.lt_raepa_defaillance TO edit_sig;

COMMENT ON TABLE m_reseau_humide.lt_raepa_defaillance
  IS 'Code permettant de décrire le type de défaillance ayant rendu nécessaire une réparation';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_defaillance.code IS 'Code de la liste énumérée relative au type de défaillance';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_defaillance.valeur IS 'Valeur de la liste énumérée relative au type de défaillance';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_defaillance.definition IS 'Définition de la liste énumérée relative au type de défaillance';

INSERT INTO m_reseau_humide.lt_raepa_defaillance(
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
/*
voir si la liste est suffisante et assez détaillée
*/

-- ###################
-- ##      AEP      ##
-- ################### 

-- Table: m_reseau_humide.lt_raepa_cat_canal_ae

-- DROP TABLE m_reseau_humide.lt_raepa_cat_canal_ae;

CREATE TABLE m_reseau_humide.lt_raepa_cat_canal_ae
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT lt_raepa_cat_canal_ae_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.lt_raepa_cat_canal_ae
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.lt_raepa_cat_canal_ae TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.lt_raepa_cat_canal_ae TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.lt_raepa_cat_canal_ae TO edit_sig;

COMMENT ON TABLE m_reseau_humide.lt_raepa_cat_canal_ae
  IS 'Code permettant de décrire la nature des eaux véhiculées par une canalisation d''adduction d''eau';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_cat_canal_ae.code IS 'Code de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''adduction d''eau';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_cat_canal_ae.valeur IS 'Valeur de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''adduction d''eau';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_cat_canal_ae.definition IS 'Définition de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''adduction d''eau';

INSERT INTO m_reseau_humide.lt_raepa_cat_canal_ae(
            code, valeur, definition)
    VALUES
('00','Indéterminée','Nature des eaux véhiculées par la canalisation inconnue'),
('01','Eau brute','Canalisation véhiculant de l''eau brute'),
('02','Eau potable','Canalisation véhiculant de l''eau potable'),
('99','Autre','Canalisation véhiculant tantôt de l''eau brute, tantôt de l''eau potable');

-- Table: m_reseau_humide.lt_raepa_fonc_canal_ae

-- DROP TABLE m_reseau_humide.lt_raepa_fonc_canal_ae;

CREATE TABLE m_reseau_humide.lt_raepa_fonc_canal_ae
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT lt_raepa_fonc_canal_ae_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.lt_raepa_fonc_canal_ae
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.lt_raepa_fonc_canal_ae TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.lt_raepa_fonc_canal_ae TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.lt_raepa_fonc_canal_ae TO edit_sig;

COMMENT ON TABLE m_reseau_humide.lt_raepa_fonc_canal_ae
  IS 'Code permettant de décrire la fonction dans le réseau d''une canalisation d''adduction d''eau';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_fonc_canal_ae.code IS 'Code de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''adduction d''eau';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_fonc_canal_ae.valeur IS 'Valeur de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''adduction d''eau';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_fonc_canal_ae.definition IS 'Définition de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''adduction d''eau';

INSERT INTO m_reseau_humide.lt_raepa_fonc_canal_ae(
            code, valeur, definition)
    VALUES
('00','Indéterminée','Fonction de la canalisation dans le réseau inconnue'),
('01','Transport','Canalisation de transport'),
('02','Distribution','Canalisation de distribution'),
('99','Autre','Canalisation dont la fonction dans le réseau ne figure pas dans la liste ci-dessus');


-- Table: m_reseau_humide.lt_raepa_cat_app_ae

-- DROP TABLE m_reseau_humide.lt_raepa_cat_app_ae;

CREATE TABLE m_reseau_humide.lt_raepa_cat_app_ae
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT lt_raepa_cat_app_ae_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.lt_raepa_cat_app_ae
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.lt_raepa_cat_app_ae TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.lt_raepa_cat_app_ae TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.lt_raepa_cat_app_ae TO edit_sig;

COMMENT ON TABLE m_reseau_humide.lt_raepa_cat_app_ae
  IS 'Code permettant de décrire le type d''un appareillage d''adduction d''eau';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_cat_app_ae.code IS 'Code de la liste énumérée relative au type d''un appareillage d''adduction d''eau';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_cat_app_ae.valeur IS 'Valeur de la liste énumérée relative au type d''un appareillage d''adduction d''eau';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_cat_app_ae.definition IS 'Définition de la liste énumérée relative au type d''un appareillage d''adduction d''eau';

INSERT INTO m_reseau_humide.lt_raepa_cat_app_ae(
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
/*
voir si la liste est suffisante et assez détaillée
*/

-- Table: m_reseau_humide.lt_raepa_cat_ouv_ae

-- DROP TABLE m_reseau_humide.lt_raepa_cat_ouv_ae;

CREATE TABLE m_reseau_humide.lt_raepa_cat_ouv_ae
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT lt_raepa_cat_ouv_ae_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.lt_raepa_cat_ouv_ae
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.lt_raepa_cat_ouv_ae TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.lt_raepa_cat_ouv_ae TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.lt_raepa_cat_ouv_ae TO edit_sig;

COMMENT ON TABLE m_reseau_humide.lt_raepa_cat_ouv_ae
  IS 'Code permettant de décrire le type d''un ouvrage d''adduction d''eau';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_cat_ouv_ae.code IS 'Code de la liste énumérée relative au type d''un ouvrage d''adduction d''eau';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_cat_ouv_ae.valeur IS 'Valeur de la liste énumérée relative au type d''un ouvrage d''adduction d''eau';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_cat_ouv_ae.definition IS 'Définition de la liste énumérée relative au type d''un ouvrage d''adduction d''eau';

INSERT INTO m_reseau_humide.lt_raepa_cat_ouv_ae(
            code, valeur, definition)
    VALUES
('00','Indéterminé','Type d''ouvrage inconnu'),
('01','Station de pompage','Station de pompage d''eau potable'),
('02','Station de traitement','Station de traitement d''eau potable'),
('03','Réservoir','Réservoir d''eau potable'),
('04','Chambre de comptage','Chambre de comptage'),
('05','Captage','Captage'),
('99','Autre','Ouvrage dont le type ne figure pas dans la liste ci-dessus');
/*
voir si la liste est suffisante et assez détaillée
*/


-- ###################
-- ##      ASS      ##
-- ################### 

-- Table: m_reseau_humide.lt_raepa_cat_reseau_ass

-- DROP TABLE m_reseau_humide.lt_raepa_cat_reseau_ass;

CREATE TABLE m_reseau_humide.lt_raepa_cat_reseau_ass
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT lt_raepa_cat_reseau_ass_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.lt_raepa_cat_reseau_ass
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.lt_raepa_cat_reseau_ass TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.lt_raepa_cat_reseau_ass TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.lt_raepa_cat_reseau_ass TO edit_sig;

COMMENT ON TABLE m_reseau_humide.lt_raepa_cat_reseau_ass
  IS 'Code permettant de décrire le type de réseau d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_cat_reseau_ass.code IS 'Code de la liste énumérée relative au type de réseau d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_cat_reseau_ass.valeur IS 'Valeur de la liste énumérée relative au type de réseau d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_cat_reseau_ass.definition IS 'Définition de la liste énumérée relative au type de réseau d''assainissement collectif';

INSERT INTO m_reseau_humide.lt_raepa_cat_reseau_ass(
            code, valeur, definition)
    VALUES
('01','Pluvial','Réseau de collecte de seules eaux pluviales'),
('02','Eaux usées','Réseau de collecte de seules eaux usées'),
('03','Unitaire','Réseau de collecte des eaux usées et des eaux pluviales');


-- Table: m_reseau_humide.lt_raepa_cat_canal_ass

-- DROP TABLE m_reseau_humide.lt_raepa_cat_canal_ass;

CREATE TABLE m_reseau_humide.lt_raepa_cat_canal_ass
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT lt_raepa_cat_canal_ass_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.lt_raepa_cat_canal_ass
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.lt_raepa_cat_canal_ass TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.lt_raepa_cat_canal_ass TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.lt_raepa_cat_canal_ass TO edit_sig;

COMMENT ON TABLE m_reseau_humide.lt_raepa_cat_canal_ass
  IS 'Code permettant de décrire la nature des eaux véhiculées par une canalisation d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_cat_canal_ass.code IS 'Code de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_cat_canal_ass.valeur IS 'Valeur de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_cat_canal_ass.definition IS 'Définition de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''assainissement collectif';

INSERT INTO m_reseau_humide.lt_raepa_cat_canal_ass(
            code, valeur, definition)
    VALUES
('00','Indéterminée','Nature des eaux véhiculées par la canalisation inconnue'),
('01','Eaux pluviales','Canalisation véhiculant des eaux pluviales'),
('02','Eaux usées','Canalisation véhiculant des eaux usées'),
('03','Unitaire','Canalisation véhiculant des eaux usées et pluviales en fonctionnement normal'),
('99','Autre','Canalisation véhiculant tantôt des eaux pluviales, tantôt des eaux usées');


-- Table: m_reseau_humide.lt_raepa_fonc_canal_ass

-- DROP TABLE m_reseau_humide.lt_raepa_fonc_canal_ass;

CREATE TABLE m_reseau_humide.lt_raepa_fonc_canal_ass
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT lt_raepa_fonc_canal_ass_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.lt_raepa_fonc_canal_ass
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.lt_raepa_fonc_canal_ass TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.lt_raepa_fonc_canal_ass TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.lt_raepa_fonc_canal_ass TO edit_sig;

COMMENT ON TABLE m_reseau_humide.lt_raepa_fonc_canal_ass
  IS 'Code permettant de décrire la fonction dans le réseau d''une canalisation d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_fonc_canal_ass.code IS 'Code de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_fonc_canal_ass.valeur IS 'Valeur de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_fonc_canal_ass.definition IS 'Définition de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''assainissement collectif';

INSERT INTO m_reseau_humide.lt_raepa_fonc_canal_ass(
            code, valeur, definition)
    VALUES
('00','Indéterminée','Fonction de la canalisation dans le réseau inconnue'),
('01','Transport','Canalisation de transport'),
('02','Collecte','Canalisation de collecte'),
('99','Autre','Canalisation dont la fonction dans le réseau ne figure pas dans la liste ci-dessus');


-- Table: m_reseau_humide.lt_raepa_cat_app_ass

-- DROP TABLE m_reseau_humide.lt_raepa_cat_app_ass;

CREATE TABLE m_reseau_humide.lt_raepa_cat_app_ass
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT lt_raepa_cat_app_ass_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.lt_raepa_cat_app_ass
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.lt_raepa_cat_app_ass TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.lt_raepa_cat_app_ass TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.lt_raepa_cat_app_ass TO edit_sig;

COMMENT ON TABLE m_reseau_humide.lt_raepa_cat_app_ass
  IS 'Code permettant de décrire le type d''un appareillage d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_cat_app_ass.code IS 'Code de la liste énumérée relative au type d''un appareillage d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_cat_app_ass.valeur IS 'Valeur de la liste énumérée relative au type d''un appareillage d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_cat_app_ass.definition IS 'Définition de la liste énumérée relative au type d''un appareillage d''assainissement collectif';

INSERT INTO m_reseau_humide.lt_raepa_cat_app_ass(
            code, valeur, definition)
    VALUES
('00','Indéterminé','Type d''appareillage inconnu'),
('01','Point de branchement','Piquage de branchement individuel'),
('02','Ventouse','Ventouse d''assainissement'),
('03','Vanne','Vanne d''assainissement'),
('04','Débitmètre','Appareil de mesure des débits transités'),
('99','Autre','Appareillage dont le type ne figure pas dans la liste ci-dessus');
/*
voir si la liste est suffisante et assez détaillée
*/

-- Table: m_reseau_humide.lt_raepa_cat_ouv_ass

-- DROP TABLE m_reseau_humide.lt_raepa_cat_ouv_ass;

CREATE TABLE m_reseau_humide.lt_raepa_cat_ouv_ass
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  definition character varying(255),
  CONSTRAINT lt_raepa_cat_ouv_ass_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.lt_raepa_cat_ouv_ass
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.lt_raepa_cat_ouv_ass TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.lt_raepa_cat_ouv_ass TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.lt_raepa_cat_ouv_ass TO edit_sig;

COMMENT ON TABLE m_reseau_humide.lt_raepa_cat_ouv_ass
  IS 'Code permettant de décrire le type d''un ouvrage d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_cat_ouv_ass.code IS 'Code de la liste énumérée relative au type d''un ouvrage d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_cat_ouv_ass.valeur IS 'Valeur de la liste énumérée relative au type d''un ouvrage d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.lt_raepa_cat_ouv_ass.definition IS 'Définition de la liste énumérée relative au type d''un ouvrage d''assainissement collectif';

INSERT INTO m_reseau_humide.lt_raepa_cat_ouv_ass(
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
/*
voir si la liste est suffisante et assez détaillée
*/




-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                  CLASSE OBJET                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- #################################################################### CLASSE AN_RAEPA_ID ###############################################

/*
Cette classe constitue une table contrainte pour l'implémentation d'afin d'assurer l'intégrité référentielle de la base sur la classe reparation et l'identification de l'objet support de celle-ci(fkey) 
*/
-- Table: m_reseau_humide.an_raepa_id

-- DROP TABLE m_reseau_humide.an_raepa_id;

CREATE TABLE m_reseau_humide.an_raepa_id
(
  idraepa character varying(254) NOT NULL, -- cumul des id des classes canalisation, noeud, appareillage, ouvrage afin de permettre de servir de référence à une fkey pour la classe réparation
  idexterne character varying(254),
  CONSTRAINT an_raepa_id_pkey PRIMARY KEY (idraepa)  
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.an_raepa_id
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.an_raepa_id TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.an_raepa_id TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.an_raepa_id TO edit_sig;

COMMENT ON TABLE m_reseau_humide.an_raepa_id
  IS 'Classe référencant l''ensemble des identifiants des objets composants les réseaux d''adduction d''eau potable et d''assainissement (RAEPA)';
COMMENT ON COLUMN m_reseau_humide.an_raepa_id.idraepa IS 'Identifiant d''une entité composant les RAEPA';
COMMENT ON COLUMN m_reseau_humide.an_raepa_id.idexterne IS 'Identifiant externe (producteur source) d''une entité composant les RAEPA';  
  
 
  

-- #################################################################### CLASSE CANALISATION ###############################################

-- Table: m_reseau_humide.geo_raepa_canal

-- DROP TABLE m_reseau_humide.geo_raepa_canal;

CREATE TABLE m_reseau_humide.geo_raepa_canal
(
  idcana character varying(254) NOT NULL,
  mouvrage character varying(100), -- *******  voir pour privilégier des domaines de valeur  *******
  gexploit character varying(100), -- *******  voir pour privilégier des domaines de valeur  ******* 
  enservice character varying(1),
  branchemnt character varying(1),  
  materiau character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  diametre integer,  
  anfinpose character varying(4),
  modecircu character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur    
  idnini character varying(254),
  idnterm character varying(254),
  idcanppale bigint,
  andebpose character varying(4),
  longcana integer,    -- unité en mètre et de type entier, pourquoi cette simplification  ?
  nbranche integer,
  qualglocxy character varying(2) NOT NULL, -- fkey vers domaine de valeur
  qualglocz character varying(2) NOT NULL, -- fkey vers domaine de valeur
  datemaj date, -- faut il conserver ce champ si il peut simplement être déduit de date_maj ??
  sourcemaj character varying(100),
  qualannee character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  dategeoloc date,
  sourgeoloc character varying(100),
  sourattrib character varying(100),
  geom geometry(LineString,2154),
  CONSTRAINT geo_raepa_canal_pkey PRIMARY KEY (idcana)  
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.geo_raepa_canal
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.geo_raepa_canal TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.geo_raepa_canal TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.geo_raepa_canal TO edit_sig;

COMMENT ON TABLE m_reseau_humide.geo_raepa_canal
  IS 'Classe décrivant un tronçon de conduite d''eau';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.idcana IS 'Identifiant de la canalisation';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.mouvrage IS 'Maître d''ouvrage du réseau';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.gexploit IS 'Gestionnaire exploitant du réseau';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.enservice IS 'Canalisation en service (O/N)';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.branchemnt IS 'Canalisation de branchement individuel (O/N)';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.materiau IS 'Matériau de la canalisation';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.diametre IS 'Diamètre nominal de la canalisation (en millimètres)';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.anfinpose IS 'Année marquant la fin de la période de pose de la canalisation';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.modecircu IS 'Mode de circulation de l''eau à l''intérieur de la canalisation';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.idnini IS 'Identifiant du noeud de début de la canalisation';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.idnterm IS 'Identifiant du noeud de fin de la canalisation';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.idcanppale IS 'Identifiant de la canalisation principale';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.andebpose IS 'Année marquant le début de la période de pose de la canalisation';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.longcana IS 'Longueur mesurée de canalisation (en mètres)';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.nbranche IS 'Nombre de branchements individuels sur la canalisation';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.qualglocxy IS 'Qualité de la géolocalisation planimétrique (XY)';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.qualglocz IS 'Qualité de la géolocalisation altimétrique (Z)';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.datemaj IS 'Date de la dernière mise à jour des informations';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.sourcemaj IS 'Source de la mise à jour';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.qualannee IS 'Fiabilité de l''année de pose ou de mise en service';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.dategeoloc IS 'Date de la géolocalisation';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.sourgeoloc IS 'Auteur de la géolocalisation';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.sourattrib IS 'Auteur de la saisie des données attributaires (lorsque différent de l''auteur de la géolocalisation)';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_canal.geom IS 'Géométrie linéaire de l''objet';



-- Sequence: m_reseau_humide.geo_raepa_canal_id_seq

-- DROP SEQUENCE m_reseau_humide.geo_raepa_canal_id_seq;

CREATE SEQUENCE m_reseau_humide.geo_raepa_canal_id_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE m_reseau_humide.geo_raepa_canal_id_seq
  OWNER TO sig_create;
GRANT ALL ON SEQUENCE m_reseau_humide.geo_raepa_canal_id_seq TO sig_create;
GRANT SELECT, USAGE ON SEQUENCE m_reseau_humide.geo_raepa_canal_id_seq TO public;

ALTER TABLE m_reseau_humide.geo_raepa_canal ALTER COLUMN idcana SET DEFAULT concat('cana',nextval('m_reseau_humide.geo_raepa_canal_id_seq'::regclass));

-- index spatial

CREATE INDEX geo_raepa_canal_geom_gist ON m_reseau_humide.geo_raepa_canal USING GIST (geom);



-- #################################################################### SSCLASSE CANALISATION AE ###############################################

-- Table: m_reseau_humide.an_raepa_canalae

-- DROP TABLE m_reseau_humide.an_raepa_canalae;

CREATE TABLE m_reseau_humide.an_raepa_canalae
(
  idcana character varying(254) NOT NULL, -- fkey vers attribut idcana de la classe canalisation
  contcanaep character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  fonccanaep character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  profgen numeric (3,2) -- pourquoi dans le standard ceci est placé sur la sous classe cana AE ???
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.an_raepa_canalae
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.an_raepa_canalae TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.an_raepa_canalae TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.an_raepa_canalae TO edit_sig;

COMMENT ON TABLE m_reseau_humide.an_raepa_canalae
  IS 'Sous classe décrivant les propriétés spécifiques d''une canalisation pour un réseau d''adduction d''eau';
COMMENT ON COLUMN m_reseau_humide.an_raepa_canalae.idcana IS 'Identifiant de la canalisation';
COMMENT ON COLUMN m_reseau_humide.an_raepa_canalae.contcanaep IS 'Catégorie de la canalisation d''adduction d''eau';
COMMENT ON COLUMN m_reseau_humide.an_raepa_canalae.fonccanaep IS 'Fonction de la canalisation d''adduction d''eau';
COMMENT ON COLUMN m_reseau_humide.an_raepa_canalae.profgen IS 'Profondeur moyenne de la génératrice supérieure de la canalisation (en mètres)';


-- #################################################################### SSCLASSE CANALISATION ASS ###############################################

-- Table: m_reseau_humide.an_raepa_canalass

-- DROP TABLE m_reseau_humide.an_raepa_canalass;

CREATE TABLE m_reseau_humide.an_raepa_canalass
(
  idcana character varying(254) NOT NULL, -- fkey vers attribut idcana de la classe canalisation
  typreseau character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  contcanass character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  fonccanass character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  zamont numeric (6,2),
  zaval numeric (6,2),
  sensecoul character varying(1)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.an_raepa_canalass
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.an_raepa_canalass TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.an_raepa_canalass TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.an_raepa_canalass TO edit_sig;

COMMENT ON TABLE m_reseau_humide.an_raepa_canalass
  IS 'Sous classe décrivant les propriétés spécifiques d''une canalisation pour un réseau d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.an_raepa_canalass.idcana IS 'Identifiant de la canalisation';
COMMENT ON COLUMN m_reseau_humide.an_raepa_canalass.typreseau IS 'Type du réseau d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.an_raepa_canalass.contcanass IS 'Catégorie de la canalisation d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.an_raepa_canalass.fonccanass IS 'Fonction de la canalisation d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.an_raepa_canalass.zamont IS 'Altitude à l''extrémité amont (en mètres, référentiel NGF-IGN69)';  
COMMENT ON COLUMN m_reseau_humide.an_raepa_canalass.zaval IS 'Altitude à l''extrémité aval (en mètres, référentiel NGF-IGN69)';   
COMMENT ON COLUMN m_reseau_humide.an_raepa_canalass.sensecoul IS 'Sens de l''écoulement dans la canalisation d''assainissement collectif';  


-- #################################################################### SUPER CLASSE NOEUD ###############################################

-- Table: m_reseau_humide.geo_raepa_noeud

-- DROP TABLE m_reseau_humide.geo_raepa_noeud;

CREATE TABLE m_reseau_humide.geo_raepa_noeud
(
  idnoeud character varying(254) NOT NULL,
--  x
--  y  
  mouvrage character varying(100), -- *******  voir pour privilégier des domaines de valeur  *******
  gexploit character varying(100), -- *******  voir pour privilégier des domaines de valeur  *******
  anfinpose character varying(4),
  idcanppale character varying(254), -- fkey vers attribut idcana de la classe canalisation. Valeur NULL admise car ne sert à renseigner la cana principale pour noeud de raccord avec un branchement
  andebpose character varying(4),      
  qualglocxy character varying(2) NOT NULL, -- fkey vers domaine de valeur
  qualglocz character varying(2) NOT NULL, -- fkey vers domaine de valeur
  datemaj date, -- faut il conserver ce champ si il peut simplement être déduit de date_maj ??
  sourcemaj character varying(100),
  qualannee character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  dategeoloc date,
  sourgeoloc character varying(100),
  sourattrib character varying(100),
  geom geometry(Point,2154),
  CONSTRAINT geo_raepa_noeud_pkey PRIMARY KEY (idnoeud) 
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.geo_raepa_noeud
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.geo_raepa_noeud TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.geo_raepa_noeud TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.geo_raepa_noeud TO edit_sig;

COMMENT ON TABLE m_reseau_humide.geo_raepa_noeud
  IS 'Super-classe décrivant une jonction de plusieurs conduites d''eau';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_noeud.idnoeud IS 'Identifiant de la canalisation';
--  x
--  y 
COMMENT ON COLUMN m_reseau_humide.geo_raepa_noeud.mouvrage IS 'Maître d''ouvrage du réseau';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_noeud.gexploit IS 'Gestionnaire exploitant du réseau';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_noeud.anfinpose IS 'Année marquant la fin de la période de mise en service de l''appareillage et/ou de l''ouvrage';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_noeud.idcanppale IS 'Identifiant de la canalisation principale en cas de piquage';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_noeud.andebpose IS 'Année marquant le début de la période de mise en service de l''appareillage et/ou de l''ouvrage';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_noeud.qualglocxy IS 'Qualité de la géolocalisation planimétrique (XY)';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_noeud.qualglocz IS 'Qualité de la géolocalisation altimétrique (Z)';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_noeud.datemaj IS 'Date de la dernière mise à jour des informations';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_noeud.sourcemaj IS 'Source de la mise à jour';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_noeud.qualannee IS 'Fiabilité de l''année de pose ou de mise en service';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_noeud.dategeoloc IS 'Date de la géolocalisation';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_noeud.sourgeoloc IS 'Auteur de la géolocalisation';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_noeud.sourattrib IS 'Auteur de la saisie des données attributaires (lorsque différent de l''auteur de la géolocalisation)';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_noeud.geom IS 'Géométrie ponctuelle de l''objet';


-- Sequence: m_reseau_humide.geo_raepa_noeud_id_seq

-- DROP SEQUENCE m_reseau_humide.geo_raepa_noeud_id_seq;

CREATE SEQUENCE m_reseau_humide.geo_raepa_noeud_id_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE m_reseau_humide.geo_raepa_noeud_id_seq
  OWNER TO sig_create;
GRANT ALL ON SEQUENCE m_reseau_humide.geo_raepa_noeud_id_seq TO sig_create;
GRANT SELECT, USAGE ON SEQUENCE m_reseau_humide.geo_raepa_noeud_id_seq TO public;

ALTER TABLE m_reseau_humide.geo_raepa_noeud ALTER COLUMN idnoeud SET DEFAULT concat('noeud',nextval('m_reseau_humide.geo_raepa_noeud_id_seq'::regclass));


-- index spatial

CREATE INDEX geo_raepa_noeud_geom_gist ON m_reseau_humide.geo_raepa_noeud USING GIST (geom);


-- #################################################################### CLASSE APPAREILLAGE ###############################################

-- Table: m_reseau_humide.an_raepa_appar

-- DROP TABLE m_reseau_humide.an_raepa_appar;

CREATE TABLE m_reseau_humide.an_raepa_appar
(
  idappareil character varying(254) NOT NULL,
  idnoeud character varying(254) NOT NULL, -- fkey vers attribut idnoeud de la classe noeud
  idouvrage character varying(254), -- fkey vers attribut idouvrage de la classe ouvrage. Valeur NULL admise car il n'y a pas forcement un ouvrage qui accueille l'appareillage
-- diametre integer, -- A PRIORI attribut manquant dans la modélisation à ce niveau car présent dans les tables d'appareillage ae et ass et absent pour les ouvrages
  z numeric(6,2),
  CONSTRAINT an_raepa_appar_pkey PRIMARY KEY (idappareil) 
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.an_raepa_appar
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.an_raepa_appar TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.an_raepa_appar TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.an_raepa_appar TO edit_sig;

COMMENT ON TABLE m_reseau_humide.an_raepa_appar
  IS 'Classe décrivant un appareillage abrité dans un ouvrage ou non';
COMMENT ON COLUMN m_reseau_humide.an_raepa_appar.idappareil IS 'Identifiant de l''appareillage';
COMMENT ON COLUMN m_reseau_humide.an_raepa_appar.idnoeud IS 'Identifiant du noeud';
COMMENT ON COLUMN m_reseau_humide.an_raepa_appar.idouvrage IS 'Identifiant de l''éventuel ouvrage d''accueil';
COMMENT ON COLUMN m_reseau_humide.an_raepa_appar.z IS 'Altitude du noeud (en mètres, Référentiel NGFIGN69)';  
  
-- Sequence: m_reseau_humide.an_raepa_appar_id_seq

-- DROP SEQUENCE m_reseau_humide.an_raepa_appar_id_seq;

CREATE SEQUENCE m_reseau_humide.an_raepa_appar_id_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE m_reseau_humide.an_raepa_appar_id_seq
  OWNER TO sig_create;
GRANT ALL ON SEQUENCE m_reseau_humide.an_raepa_appar_id_seq TO sig_create;
GRANT SELECT, USAGE ON SEQUENCE m_reseau_humide.an_raepa_appar_id_seq TO public;

ALTER TABLE m_reseau_humide.an_raepa_appar ALTER COLUMN idappareil SET DEFAULT concat('appar',nextval('m_reseau_humide.an_raepa_appar_id_seq'::regclass));


-- #################################################################### SSCLASSE APPAREILLAGE AE ###############################################

-- Table: m_reseau_humide.an_raepa_apparaep

-- DROP TABLE m_reseau_humide.an_raepa_apparaep;

CREATE TABLE m_reseau_humide.an_raepa_apparaep
(
  idappareil character varying(254) NOT NULL, -- fkey vers attribut idappareil de la classe appareillage
  fnappaep character varying(2) NOT NULL DEFAULT '00' -- fkey vers domaine de valeur
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.an_raepa_apparaep
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.an_raepa_apparaep TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.an_raepa_apparaep TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.an_raepa_apparaep TO edit_sig;

COMMENT ON TABLE m_reseau_humide.an_raepa_apparaep
  IS 'Sous classe décrivant un appareillage d''adduction d''eau abrité dans un ouvrage ou non';
COMMENT ON COLUMN m_reseau_humide.an_raepa_apparaep.idappareil IS 'Identifiant de l''appareillage';
COMMENT ON COLUMN m_reseau_humide.an_raepa_apparaep.fnappaep IS 'Fonction de l''appareillage d''adduction d''eau potable';

  
-- #################################################################### SSCLASSE APPAREILLAGE ASS ###############################################

-- Table: m_reseau_humide.an_raepa_apparass

-- DROP TABLE m_reseau_humide.an_raepa_apparass;

CREATE TABLE m_reseau_humide.an_raepa_apparass
(
  idappareil character varying(254) NOT NULL, -- fkey vers attribut idappareil de la classe appareillage
  typreseau character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  fnappass character varying(2) NOT NULL DEFAULT '00' -- fkey vers domaine de valeur
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.an_raepa_apparass
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.an_raepa_apparass TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.an_raepa_apparass TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.an_raepa_apparass TO edit_sig;

COMMENT ON TABLE m_reseau_humide.an_raepa_apparass
  IS 'Sous classe décrivant un appareillage d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.an_raepa_apparass.idappareil IS 'Identifiant de l''appareillage';
COMMENT ON COLUMN m_reseau_humide.an_raepa_apparass.typreseau IS 'Type du réseau d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.an_raepa_apparass.fnappass IS 'Fonction de l''appareillage d''assainissement collectif';
  

-- #################################################################### CLASSE OUVRAGE ###############################################

-- Table: m_reseau_humide.an_raepa_ouvr

-- DROP TABLE m_reseau_humide.an_raepa_ouvr;

CREATE TABLE m_reseau_humide.an_raepa_ouvr
(
  idouvrage character varying(254) NOT NULL,
  idnoeud character varying(254) NOT NULL, -- fkey vers attribut idnoeud de la classe noeud
  z numeric(6,2),
  CONSTRAINT an_raepa_ouvr_pkey PRIMARY KEY (idouvrage) 
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.an_raepa_ouvr
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.an_raepa_ouvr TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.an_raepa_ouvr TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.an_raepa_ouvr TO edit_sig;

COMMENT ON TABLE m_reseau_humide.an_raepa_ouvr
  IS 'Classe décrivant un ouvrage';
COMMENT ON COLUMN m_reseau_humide.an_raepa_ouvr.idouvrage IS 'Identifiant de l''ouvrage';
COMMENT ON COLUMN m_reseau_humide.an_raepa_ouvr.idnoeud IS 'Identifiant du noeud';
COMMENT ON COLUMN m_reseau_humide.an_raepa_ouvr.z IS 'Altitude radier de l''ouvrage (en mètres, Référentiel NGFIGN69)';  
  
-- Sequence: m_reseau_humide.an_raepa_ouvr_id_seq

-- DROP SEQUENCE m_reseau_humide.an_raepa_ouvr_id_seq;

CREATE SEQUENCE m_reseau_humide.an_raepa_ouvr_id_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE m_reseau_humide.an_raepa_ouvr_id_seq
  OWNER TO sig_create;
GRANT ALL ON SEQUENCE m_reseau_humide.an_raepa_ouvr_id_seq TO sig_create;
GRANT SELECT, USAGE ON SEQUENCE m_reseau_humide.an_raepa_ouvr_id_seq TO public;

ALTER TABLE m_reseau_humide.an_raepa_ouvr ALTER COLUMN idouvrage SET DEFAULT concat('ouvr',nextval('m_reseau_humide.an_raepa_ouvr_id_seq'::regclass));


-- #################################################################### SSCLASSE OUVRAGE AE ###############################################

-- Table: m_reseau_humide.an_raepa_ouvraep

-- DROP TABLE m_reseau_humide.an_raepa_ouvraep;

CREATE TABLE m_reseau_humide.an_raepa_ouvraep
(
  idouvrage character varying(254) NOT NULL, -- fkey vers attribut idouvrage de la classe ouvrage
  fnouvaep character varying(2) NOT NULL DEFAULT '00' -- fkey vers domaine de valeur
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.an_raepa_ouvraep
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.an_raepa_ouvraep TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.an_raepa_ouvraep TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.an_raepa_ouvraep TO edit_sig;

COMMENT ON TABLE m_reseau_humide.an_raepa_ouvraep
  IS 'Sous classe décrivant un ouvrage d''adduction d''eau';
COMMENT ON COLUMN m_reseau_humide.an_raepa_ouvraep.idouvrage IS 'Identifiant de l''ouvrage';
COMMENT ON COLUMN m_reseau_humide.an_raepa_ouvraep.fnouvaep IS 'Fonction de l''ouvrage d''adduction d''eau potable';


-- #################################################################### SSCLASSE OUVRAGE ASS ###############################################

-- Table: m_reseau_humide.an_raepa_ouvrass

-- DROP TABLE m_reseau_humide.an_raepa_ouvrass;

CREATE TABLE m_reseau_humide.an_raepa_ouvrass
(
  idouvrage character varying(254) NOT NULL, -- fkey vers attribut idouvrage de la classe ouvrage
  typreseau character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  fnouvass character varying(2) NOT NULL DEFAULT '00' -- fkey vers domaine de valeur
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.an_raepa_ouvrass
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.an_raepa_ouvrass TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.an_raepa_ouvrass TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.an_raepa_ouvrass TO edit_sig;

COMMENT ON TABLE m_reseau_humide.an_raepa_ouvrass
  IS 'Sous classe décrivant un ouvrage d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.an_raepa_ouvrass.idouvrage IS 'Identifiant de l''ouvrage';
COMMENT ON COLUMN m_reseau_humide.an_raepa_ouvrass.typreseau IS 'Type du réseau d''assainissement collectif';
COMMENT ON COLUMN m_reseau_humide.an_raepa_ouvrass.fnouvass IS 'Fonction de l''ouvrage d''assainissement collectif';


-- #################################################################### CLASSE REPARATION ###############################################


CREATE TABLE m_reseau_humide.geo_raepa_repar
(
  idrepar character varying(254) NOT NULL,
--  x
--  y
  supprepare character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  defreparee character varying(2) NOT NULL DEFAULT '00', -- fkey vers domaine de valeur
  idsuprepar character varying(254) NOT NULL, -- fkey vers attribut idraepa de la classe raepa_id
  daterepart date,
  mouvrage character varying(100), -- *******  voir pour privilégier des domaines de valeur  *******
  geom geometry(Point,2154),
  CONSTRAINT geo_raepa_repar_pkey PRIMARY KEY (idrepar) 
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_reseau_humide.geo_raepa_repar
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_humide.geo_raepa_repar TO sig_create;
GRANT SELECT ON TABLE m_reseau_humide.geo_raepa_repar TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_reseau_humide.geo_raepa_repar TO edit_sig;

COMMENT ON TABLE m_reseau_humide.geo_raepa_repar
  IS 'Classe contenant le lieu d''une intervention sur le réseau effectuées suite à une défaillance dudit réseau';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_repar.idrepar IS 'Identifiant de la réparation effectuée';
-- COMMENT ON COLUMN m_reseau_humide.geo_raepa_repar.x ;
-- COMMENT ON COLUMN m_reseau_humide.geo_raepa_repar.y ;
COMMENT ON COLUMN m_reseau_humide.geo_raepa_repar.supprepare IS 'Type de support de la réparation';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_repar.defreparee IS 'Type de défaillance';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_repar.idsuprepar IS 'Identifiant du support de la réparation';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_repar.daterepart IS 'Date de l''intervention en réparation';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_repar.mouvrage IS 'Maître d''ouvrage de la réparation';
COMMENT ON COLUMN m_reseau_humide.geo_raepa_repar.geom IS 'Géométrie ponctuelle de l''objet';

-- Sequence: m_reseau_humide.geo_raepa_repar_id_seq

-- DROP SEQUENCE m_reseau_humide.geo_raepa_repar_id_seq;

CREATE SEQUENCE m_reseau_humide.geo_raepa_repar_id_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE m_reseau_humide.geo_raepa_repar_id_seq
  OWNER TO sig_create;
GRANT ALL ON SEQUENCE m_reseau_humide.geo_raepa_repar_id_seq TO sig_create;
GRANT SELECT, USAGE ON SEQUENCE m_reseau_humide.geo_raepa_repar_id_seq TO public;

ALTER TABLE m_reseau_humide.geo_raepa_repar ALTER COLUMN idrepar SET DEFAULT concat('repar',nextval('m_reseau_humide.geo_raepa_repar_id_seq'::regclass));

-- index spatial

CREATE INDEX geo_raepa_repar_geom_gist ON m_reseau_humide.geo_raepa_repar USING GIST (geom);





-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                           FKEY (clé étrangère)                                                               ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- ############ CANALISATION ############

-- ************ GEO_RAEPA_CANAL ************  

ALTER TABLE m_reseau_humide.geo_raepa_canal

  ADD CONSTRAINT an_raepa_id_fkey FOREIGN KEY (idcana)
      REFERENCES m_reseau_humide.an_raepa_id (idraepa) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,  
  ADD CONSTRAINT idnini_fkey FOREIGN KEY (idnini)
      REFERENCES m_reseau_humide.geo_raepa_noeud (idnoeud) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT idnterm_fkey FOREIGN KEY (idnterm)
      REFERENCES m_reseau_humide.geo_raepa_noeud (idnoeud) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,      
  ADD CONSTRAINT lt_raepa_materiau_fkey FOREIGN KEY (materiau)
      REFERENCES m_reseau_humide.lt_raepa_materiau (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepa_mode_circulation_fkey FOREIGN KEY (modecircu)
      REFERENCES m_reseau_humide.lt_raepa_mode_circulation (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepa_qualite_anpose_fkey FOREIGN KEY (qualannee)
      REFERENCES m_reseau_humide.lt_raepa_qualite_anpose (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepa_qualite_geoloc_xy_fkey FOREIGN KEY (qualglocxy)
      REFERENCES m_reseau_humide.lt_raepa_qualite_geoloc (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,         
  ADD CONSTRAINT lt_raepa_qualite_geoloc_z_fkey FOREIGN KEY (qualglocz)
      REFERENCES m_reseau_humide.lt_raepa_qualite_geoloc (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;   
      
-- ************ AN_RAEPA_CANAL_AE ************       
           
ALTER TABLE m_reseau_humide.an_raepa_canalae

  ADD CONSTRAINT idcana_fkey FOREIGN KEY (idcana)
      REFERENCES m_reseau_humide.geo_raepa_canal (idcana) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepa_cat_canal_ae_fkey FOREIGN KEY (contcanaep)
      REFERENCES m_reseau_humide.lt_raepa_cat_canal_ae (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,           
  ADD CONSTRAINT lt_raepa_fonc_canal_ae_fkey FOREIGN KEY (fonccanaep)
      REFERENCES m_reseau_humide.lt_raepa_fonc_canal_ae (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
      
-- ************ AN_RAEPA_CANAL_ASS ************   

ALTER TABLE m_reseau_humide.an_raepa_canalass

  ADD CONSTRAINT idcana_fkey FOREIGN KEY (idcana)
      REFERENCES m_reseau_humide.geo_raepa_canal (idcana) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepa_cat_reseau_ass_fkey FOREIGN KEY (typreseau)
      REFERENCES m_reseau_humide.lt_raepa_cat_reseau_ass (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepa_cat_canal_ass_fkey FOREIGN KEY (contcanass)
      REFERENCES m_reseau_humide.lt_raepa_cat_canal_ass (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,           
  ADD CONSTRAINT lt_raepa_fonc_canal_ass_fkey FOREIGN KEY (fonccanass)
      REFERENCES m_reseau_humide.lt_raepa_fonc_canal_ass (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- ############ NOEUD ############

-- ************ GEO_RAEPA_NOEUD ************ 
      
ALTER TABLE m_reseau_humide.geo_raepa_noeud

  ADD CONSTRAINT idcanppale_fkey FOREIGN KEY (idcanppale)
      REFERENCES m_reseau_humide.geo_raepa_canal (idcana) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepa_qualite_anpose_fkey FOREIGN KEY (qualannee)
      REFERENCES m_reseau_humide.lt_raepa_qualite_anpose (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepa_qualite_geoloc_xy_fkey FOREIGN KEY (qualglocxy)
      REFERENCES m_reseau_humide.lt_raepa_qualite_geoloc (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,         
  ADD CONSTRAINT lt_raepa_qualite_geoloc_z_fkey FOREIGN KEY (qualglocz)
      REFERENCES m_reseau_humide.lt_raepa_qualite_geoloc (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- ############ APPAREILLAGE ############
      
-- ************ AN_RAEPA_APPAR ************       

ALTER TABLE m_reseau_humide.an_raepa_appar

  ADD CONSTRAINT idouvrage_fkey FOREIGN KEY (idouvrage)
      REFERENCES m_reseau_humide.an_raepa_ouvr (idouvrage) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT idnoeud_fkey FOREIGN KEY (idnoeud)
      REFERENCES m_reseau_humide.geo_raepa_noeud (idnoeud) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- ************ AN_RAEPA_APPAR_AEP ************  

ALTER TABLE m_reseau_humide.an_raepa_apparaep

  ADD CONSTRAINT lt_raepa_cat_app_ae_fkey FOREIGN KEY (fnappaep)
      REFERENCES m_reseau_humide.lt_raepa_cat_app_ae (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;   

-- ************ AN_RAEPA_APPAR_ASS ************  

ALTER TABLE m_reseau_humide.an_raepa_apparass

  ADD CONSTRAINT lt_raepa_cat_reseau_ass_fkey FOREIGN KEY (typreseau)
      REFERENCES m_reseau_humide.lt_raepa_cat_reseau_ass (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,        
  ADD CONSTRAINT lt_raepa_cat_app_ass_fkey FOREIGN KEY (fnappass)
      REFERENCES m_reseau_humide.lt_raepa_cat_app_ass (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;                     

-- ############ OUVRAGE ############

-- ************ AN_RAEPA_OUVR ************       

ALTER TABLE m_reseau_humide.an_raepa_ouvr

  ADD CONSTRAINT idnoeud_fkey FOREIGN KEY (idnoeud)
      REFERENCES m_reseau_humide.geo_raepa_noeud (idnoeud) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- ************ AN_RAEPA_OUVR_AEP ************  

ALTER TABLE m_reseau_humide.an_raepa_ouvraep

  ADD CONSTRAINT lt_raepa_cat_ouv_ae_fkey FOREIGN KEY (fnouvaep)
      REFERENCES m_reseau_humide.lt_raepa_cat_ouv_ae (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;   

-- ************ AN_RAEPA_APPAR_ASS ************  

ALTER TABLE m_reseau_humide.an_raepa_ouvrass

  ADD CONSTRAINT lt_raepa_cat_reseau_ass_fkey FOREIGN KEY (typreseau)
      REFERENCES m_reseau_humide.lt_raepa_cat_reseau_ass (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,        
  ADD CONSTRAINT lt_raepa_cat_ouv_ass_fkey FOREIGN KEY (fnouvass)
      REFERENCES m_reseau_humide.lt_raepa_cat_ouv_ass (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;  

-- ############ REPARATION ############

-- ************ GEO_RAEPA_REPAR ************       

ALTER TABLE m_reseau_humide.geo_raepa_repar

  ADD CONSTRAINT an_raepa_id_fkey FOREIGN KEY (idsuprepar)
      REFERENCES m_reseau_humide.an_raepa_id (idraepa) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepa_support_incident_fkey FOREIGN KEY (supprepare)
      REFERENCES m_reseau_humide.lt_raepa_support_incident (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,        
  ADD CONSTRAINT lt_raepa_defaillance_fkey FOREIGN KEY (defreparee)
      REFERENCES m_reseau_humide.lt_raepa_defaillance (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;  



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        VUES                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- #################################################################### VUE CANALISATION AE ###############################################

-- View: m_reseau_humide.geo_v_raepa_canalae

-- DROP VIEW m_reseau_humide.geo_v_raepa_canalae;

CREATE OR REPLACE VIEW m_reseau_humide.geo_v_raepa_canalae AS 
 SELECT 
  g.idcana,
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
  g.qualglocxy,
  g.qualglocz, 
  g.datemaj,
  g.sourcemaj,
  g.qualannee,
  g.dategeoloc,
  g.sourgeoloc,
  g.sourattrib,
  g.geom
   
FROM m_reseau_humide.geo_raepa_canal g
RIGHT JOIN m_reseau_humide.an_raepa_canalae a ON g.idcana = a.idcana
ORDER BY g.idcana;

ALTER TABLE m_reseau_humide.geo_v_raepa_canalae
  OWNER TO sig_create;

COMMENT ON VIEW m_reseau_humide.geo_v_raepa_canalae
  IS 'Canalisation d''adduction d''eau';



-- #################################################################### VUE CANALISATION ASS ###############################################

-- View: m_reseau_humide.geo_v_raepa_canalass

-- DROP VIEW m_reseau_humide.geo_v_raepa_canalass;

CREATE OR REPLACE VIEW m_reseau_humide.geo_v_raepa_canalass AS 
 SELECT 
  g.idcana,
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
  g.qualglocxy,
  g.qualglocz, 
  g.datemaj,
  g.sourcemaj,
  g.qualannee,
  g.dategeoloc,
  g.sourgeoloc,
  g.sourattrib,
  g.geom
  
FROM m_reseau_humide.geo_raepa_canal g
RIGHT JOIN m_reseau_humide.an_raepa_canalass a ON g.idcana = a.idcana
ORDER BY g.idcana;

ALTER TABLE m_reseau_humide.geo_v_raepa_canalass
  OWNER TO sig_create;

COMMENT ON VIEW m_reseau_humide.geo_v_raepa_canalass
  IS 'Canalisation d''assainissement collectif';


-- #################################################################### VUE APPAREILLAGE AE ###############################################


-- View: m_reseau_humide.geo_v_raepa_apparaep

-- DROP VIEW m_reseau_humide.geo_v_raepa_apparaep;

CREATE OR REPLACE VIEW m_reseau_humide.geo_v_raepa_apparaep AS 
 SELECT
  g.idnoeud,
  a.idappareil,
--  x
--  y
  g.mouvrage,
  g.gexploit,
  p.fnappaep,
  g.anfinpose,
-- diametre integer, -- A PRIORI soit : attribut manquant dans la modélisation à ce niveau car présent dans les tables implémentées d'appareillage ae et ass et absent pour les ouvrages / soit : attribut implémenté et qui ne devrait pas l'être / MCD
-- idcanamont,
-- idcanaval,  
  g.idcanppale,
  a.idouvrage,
  a.z,
  g.andebpose,      
  g.qualglocxy,
  g.qualglocz, 
  g.datemaj,
  g.sourcemaj,
  g.qualannee,
  g.dategeoloc,
  g.sourgeoloc,
  g.sourattrib,
  g.geom

FROM m_reseau_humide.geo_raepa_noeud g
RIGHT JOIN m_reseau_humide.an_raepa_appar a ON g.idnoeud = a.idnoeud
RIGHT JOIN m_reseau_humide.an_raepa_apparaep p ON p.idappareil = a.idappareil
ORDER BY g.idnoeud;

ALTER TABLE m_reseau_humide.geo_v_raepa_apparaep
  OWNER TO sig_create;

COMMENT ON VIEW m_reseau_humide.geo_v_raepa_apparaep
  IS 'Appareillage d''adduction d''eau';


-- #################################################################### VUE APPAREILLAGE ASS ###############################################


-- View: m_reseau_humide.geo_v_raepa_apparass

-- DROP VIEW m_reseau_humide.geo_v_raepa_apparass;

CREATE OR REPLACE VIEW m_reseau_humide.geo_v_raepa_apparass AS 
 SELECT
  g.idnoeud,
  a.idappareil,
--  x
--  y
  g.mouvrage,
  g.gexploit,
  p.typreseau,
  p.fnappass,
  g.anfinpose,
-- diametre integer, -- A PRIORI soit : attribut manquant dans la modélisation à ce niveau car présent dans les tables implémentées d'appareillage ae et ass et absent pour les ouvrages / soit : attribut implémenté et qui ne devrait pas l'être / MCD
-- idcanamont,
-- idcanaval,  
  g.idcanppale,
  a.idouvrage,
  a.z,
  g.andebpose,      
  g.qualglocxy,
  g.qualglocz, 
  g.datemaj,
  g.sourcemaj,
  g.qualannee,
  g.dategeoloc,
  g.sourgeoloc,
  g.sourattrib,
  g.geom

FROM m_reseau_humide.geo_raepa_noeud g
RIGHT JOIN m_reseau_humide.an_raepa_appar a ON g.idnoeud = a.idnoeud
RIGHT JOIN m_reseau_humide.an_raepa_apparass p ON p.idappareil = a.idappareil
ORDER BY g.idnoeud;

ALTER TABLE m_reseau_humide.geo_v_raepa_apparass
  OWNER TO sig_create;

COMMENT ON VIEW m_reseau_humide.geo_v_raepa_apparass
  IS 'Appareillage d''assainissement collectif';



-- #################################################################### VUE OUVRAGE AE ###############################################


-- View: m_reseau_humide.geo_v_raepa_ouvraep

-- DROP VIEW m_reseau_humide.geo_v_raepa_ouvraep;

CREATE OR REPLACE VIEW m_reseau_humide.geo_v_raepa_ouvraep AS 
 SELECT
  g.idnoeud,
  a.idouvrage,
--  x
--  y
  g.mouvrage,
  g.gexploit,
  p.fnouvaep,
  g.anfinpose,
-- idcanamont,
-- idcanaval,  
  g.idcanppale,  
  a.z,
  g.andebpose,      
  g.qualglocxy,
  g.qualglocz, 
  g.datemaj,
  g.sourcemaj,
  g.qualannee,
  g.dategeoloc,
  g.sourgeoloc,
  g.sourattrib,
  g.geom

FROM m_reseau_humide.geo_raepa_noeud g
RIGHT JOIN m_reseau_humide.an_raepa_ouvr a ON g.idnoeud = a.idnoeud
RIGHT JOIN m_reseau_humide.an_raepa_ouvraep p ON p.idouvrage = a.idouvrage
ORDER BY g.idnoeud;

ALTER TABLE m_reseau_humide.geo_v_raepa_ouvraep
  OWNER TO sig_create;

COMMENT ON VIEW m_reseau_humide.geo_v_raepa_ouvraep
  IS 'Ouvrage d''adduction d''eau';


-- #################################################################### VUE OUVRAGE ASS ###############################################


-- View: m_reseau_humide.geo_v_raepa_ouvrass

-- DROP VIEW m_reseau_humide.geo_v_raepa_ouvrass;

CREATE OR REPLACE VIEW m_reseau_humide.geo_v_raepa_ouvrass AS 
 SELECT
  g.idnoeud,
  a.idouvrage,
--  x
--  y
  g.mouvrage,
  g.gexploit,
  p.fnouvass,
  g.anfinpose,
-- idcanamont,
-- idcanaval,  
  g.idcanppale, 
  a.z,
  g.andebpose,      
  g.qualglocxy,
  g.qualglocz, 
  g.datemaj,
  g.sourcemaj,
  g.qualannee,
  g.dategeoloc,
  g.sourgeoloc,
  g.sourattrib,
  g.geom

FROM m_reseau_humide.geo_raepa_noeud g
RIGHT JOIN m_reseau_humide.an_raepa_ouvr a ON g.idnoeud = a.idnoeud
RIGHT JOIN m_reseau_humide.an_raepa_ouvrass p ON p.idouvrage = a.idouvrage
ORDER BY g.idnoeud;

ALTER TABLE m_reseau_humide.geo_v_raepa_ouvrass
  OWNER TO sig_create;

COMMENT ON VIEW m_reseau_humide.geo_v_raepa_ouvrass
  IS 'Ouvrage d''assainissement collectif';


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                     TRIGGER                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################



-- #################################################################### FONCTION TRIGGER - GEO_V_RAEPA_CANALAE ###################################################

-- Function: m_reseau_humide.ft_geo_v_raepa_canalae()

-- DROP FUNCTION m_reseau_humide.ft_geo_v_raepa_canalae();

CREATE OR REPLACE FUNCTION m_reseau_humide.ft_geo_v_raepa_canalae()
  RETURNS trigger AS
$BODY$

DECLARE v_idcana_raepa character varying(254);
DECLARE v_idnoeud_raepa character varying(254);

BEGIN

-- INSERT
IF (TG_OP = 'INSERT') THEN

v_idcana_raepa := concat('cana',nextval('m_reseau_humide.geo_raepa_canal_id_seq'::regclass));

INSERT INTO m_reseau_humide.an_raepa_id (idraepa,idexterne)
SELECT v_idcana_raepa,
NULL;

INSERT INTO m_reseau_humide.geo_raepa_canal (idcana,mouvrage,gexploit,enservice,branchemnt,materiau,diametre,anfinpose,modecircu,idnini,idnterm,idcanppale,andebpose,longcana,nbranche,qualglocxy,qualglocz,datemaj,sourcemaj,qualannee,dategeoloc,sourgeoloc,sourattrib,geom)
SELECT v_idcana_raepa,
CASE WHEN NEW.mouvrage = '' THEN NULL ELSE NEW.mouvrage END, -- voir si on gère pas aussi la casse
CASE WHEN NEW.gexploit = '' THEN NULL ELSE NEW.gexploit END, -- voir si on gère pas aussi la casse
CASE WHEN NEW.enservice = '' THEN NULL ELSE NEW.enservice END, -- voir domaine de valeur type faux booleen à créer
CASE WHEN NEW.branchemnt = '' THEN NULL ELSE NEW.branchemnt END, -- voir domaine de valeur type faux booleen à créer
CASE WHEN NEW.materiau IS NULL THEN '00' ELSE NEW.materiau END,
CASE WHEN NEW.diametre IS NULL THEN 0 ELSE NEW.diametre END,
CASE WHEN NEW.anfinpose IS NULL THEN '0000' ELSE NEW.anfinpose END,
CASE WHEN NEW.modecircu IS NULL THEN '00' ELSE NEW.modecircu END,
(SELECT idnoeud FROM m_reseau_humide.geo_raepa_noeud WHERE ST_Contains(st_startpoint(NEW.geom),geom) IS TRUE), -- par jointure graphique on va chercher le numéro du noeud pour le NEW.idnini
(SELECT idnoeud FROM m_reseau_humide.geo_raepa_noeud WHERE ST_Contains(st_endpoint(NEW.geom),geom) IS TRUE), -- par jointure graphique on va chercher le numéro du noeud pour le NEW.idnterm
CASE WHEN NEW.branchemnt = 'N' THEN NULL ELSE NEW.idcanppale END, -- lorsque la cana est déclarée de type non branchement, alors idcanppale est NULL, dans le cas inverse
NEW.andebpose,
st_length(NEW.geom),
NEW.nbranche, -- voir si capacité à calculer en automatique par références d'id liés
CASE WHEN NEW.qualglocxy IS NULL THEN '03' ELSE NEW.qualglocxy END,
CASE WHEN NEW.qualglocz IS NULL THEN '03' ELSE NEW.qualglocz END,
NEW.datemaj,
NEW.sourcemaj,
CASE WHEN NEW.qualannee IS NULL THEN '00' ELSE NEW.qualannee END,
NEW.dategeoloc,
CASE WHEN NEW.sourgeoloc = '' THEN NULL ELSE NEW.sourgeoloc END,
CASE WHEN NEW.sourattrib = '' THEN NULL ELSE NEW.sourattrib END,
NEW.geom;

INSERT INTO m_reseau_humide.an_raepa_canalae (idcana,contcanaep,fonccanaep,profgen)
SELECT v_idcana_raepa,
CASE WHEN NEW.contcanaep IS NULL THEN '00' ELSE NEW.contcanaep END,
CASE WHEN NEW.fonccanaep IS NULL THEN '00' ELSE NEW.fonccanaep END,
NEW.profgen;

RETURN NEW;


-- UPDATE
ELSIF (TG_OP = 'UPDATE') THEN

-- pas d'update sur la table des an_raepa_id (sauf si on gère à ce niveau la référence du tiers producteur "idexterne")

UPDATE
m_reseau_humide.geo_raepa_canal
SET
idcana=OLD.idcana,
mouvrage=CASE WHEN NEW.mouvrage = '' THEN NULL ELSE NEW.mouvrage END, -- voir si on gère pas aussi la casse
gexploit=CASE WHEN NEW.gexploit = '' THEN NULL ELSE NEW.gexploit END, -- voir si on gère pas aussi la casse
enservice=CASE WHEN NEW.enservice = '' THEN NULL ELSE NEW.enservice END, -- voir domaine de valeur type faux booleen à créer
branchemnt=CASE WHEN NEW.branchemnt = '' THEN NULL ELSE NEW.branchemnt END, -- voir domaine de valeur type faux booleen à créer
materiau=CASE WHEN NEW.materiau IS NULL THEN '00' ELSE NEW.materiau END,
diametre=CASE WHEN NEW.diametre IS NULL THEN 0 ELSE NEW.diametre END,
anfinpose=CASE WHEN NEW.anfinpose IS NULL THEN '0000' ELSE NEW.anfinpose END,
modecircu=CASE WHEN NEW.modecircu IS NULL THEN '00' ELSE NEW.modecircu END,
idnini=(SELECT idnoeud FROM m_reseau_humide.geo_raepa_noeud WHERE ST_Contains(st_startpoint(NEW.geom),geom) IS TRUE), -- par jointure graphique on va chercher le numéro du noeud pour le NEW.idnini
idnterm=(SELECT idnoeud FROM m_reseau_humide.geo_raepa_noeud WHERE ST_Contains(st_endpoint(NEW.geom),geom) IS TRUE), -- par jointure graphique on va chercher le numéro du noeud pour le NEW.idnterm
idcanppale=CASE WHEN NEW.branchemnt = 'N' THEN NULL ELSE NEW.idcanppale END, -- lorsque la cana est déclarée de type non branchement, alors idcanppale est NULL, dans le cas inverse
andebpose=NEW.andebpose,
longcana=st_length(NEW.geom),
nbranche=NEW.nbranche, -- voir si capacité à calculer en automatique par références d'id liés
qualglocxy=CASE WHEN NEW.qualglocxy IS NULL THEN '03' ELSE NEW.qualglocxy END,
qualglocz=CASE WHEN NEW.qualglocz IS NULL THEN '03' ELSE NEW.qualglocz END,
datemaj=NEW.datemaj,
sourcemaj=NEW.sourcemaj,
qualannee=CASE WHEN NEW.qualannee IS NULL THEN '00' ELSE NEW.qualannee END,
dategeoloc=NEW.dategeoloc,
sourgeoloc=CASE WHEN NEW.sourgeoloc = '' THEN NULL ELSE NEW.sourgeoloc END,
sourattrib=CASE WHEN NEW.sourattrib = '' THEN NULL ELSE NEW.sourattrib END,
geom=NEW.geom;

UPDATE
m_reseau_humide.an_raepa_canalae
SET
idcana=OLD.idcana,
contcanaep=CASE WHEN NEW.contcanaep IS NULL THEN '00' ELSE NEW.contcanaep END,
fonccanaep=CASE WHEN NEW.fonccanaep IS NULL THEN '00' ELSE NEW.fonccanaep END,
profgen=NEW.profgen;

RETURN NEW;

END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION m_reseau_humide.ft_geo_v_raepa_canalae()
  OWNER TO postgres;
COMMENT ON FUNCTION m_reseau_humide.ft_geo_v_raepa_canalae() IS 'Fonction trigger pour mise à jour de la vue de gestion des canalisations d''adduction d''eau';



-- Trigger: t_t1_geo_v_raepa_canalae on m_reseau_humide.geo_v_raepa_canalae

-- DROP TRIGGER t_t1_geo_v_pei_ctr ON m_reseau_humide.geo_v_raepa_canalae;

CREATE TRIGGER t_t1_geo_v_raepa_canalae
  INSTEAD OF INSERT OR UPDATE --OR DELETE
  ON m_reseau_humide.geo_v_raepa_canalae
  FOR EACH ROW
  EXECUTE PROCEDURE m_reseau_humide.ft_geo_v_raepa_canalae();

 

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                  BAC A SABLE                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

/*

-- données fictives pour test

-- ### NOEUD ###

INSERT INTO m_reseau_humide.geo_raepa_noeud(
            idnoeud, mouvrage, gexploit, anfinpose, idcanppale, andebpose, qualglocxy, qualglocz, datemaj, sourcemaj, qualannee, dategeoloc, sourgeoloc, sourattrib, geom)
    VALUES
(concat('noeud',nextval('m_reseau_humide.geo_raepa_noeud_id_seq'::regclass)), NULL, NULL, NULL, NULL, NULL, '03', '03', NULL, NULL, '00', NULL, NULL, NULL, ST_GeomFromText('POINT(681028 6918030)', 2154)),
(concat('noeud',nextval('m_reseau_humide.geo_raepa_noeud_id_seq'::regclass)), NULL, NULL, NULL, NULL, NULL, '03', '03', NULL, NULL, '00', NULL, NULL, NULL, ST_GeomFromText('POINT(681047 6918043)', 2154));

-- ### CANALISATION AE ###

INSERT INTO m_reseau_humide.geo_v_raepa_canalae(
            idcana, mouvrage, gexploit, enservice, branchemnt, materiau, diametre, anfinpose, modecircu, contcanaep, fonccanaep, idnini, idnterm, idcanppale, profgen, andebpose, longcana, nbranche, qualglocxy, qualglocz, datemaj, sourcemaj, qualannee, dategeoloc, sourgeoloc, sourattrib, geom)
    VALUES
(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ST_GeomFromText('LINESTRING(681028 6918030, 681047 6918043)', 2154));

*/
