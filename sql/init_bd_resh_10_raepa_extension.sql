/*RAEPA V1.2*/
/*Implémentation locale du RAEPA et extension de la structure des données (table, séquence, trigger,...) sur la base du pivot du standard RAEPA */
/*init_bd_resh_20_raepa_extension.sql */
/*PostGIS*/

/* GeoCompiegnois - https://geo.compiegnois.fr/ */
/* Auteur : Florent Vanhoutte */

/*
Principe : ne pas altérer le standard, mais ajouter des classes, attributs modifiés ou étendus en conséquence pour éviter une perte d'information entre le SI des exploitants et celui de la collectivité.
Cela permet de garantir à la fois une livraison RAEPA et des livrables complémentaires pour les échanges locaux.
*/
/* Extension :
Préfixe attributs étendu par "l_"
Classe origine raepa nommé "raepa"
Classe étendue nommé "raepal"
Liste origine raepa nommé "raepa"
Liste étendu du raepa ou ajouté nommé "raepal"
*/
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      SUPPRESSION                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################
-- vue /* obligaotire pour pouvoir déplacer des attributs dans d'autres classes. Seront reconstituées dans le fichier des vues de gestion */

DROP MATERIALIZED VIEW IF EXISTS raepa.raepa_canalaep_l;
DROP MATERIALIZED VIEW IF EXISTS raepa.raepa_canalass_l;
DROP MATERIALIZED VIEW IF EXISTS raepa.raepa_apparaep_p;
DROP MATERIALIZED VIEW IF EXISTS raepa.raepa_apparass_p;
DROP MATERIALIZED VIEW IF EXISTS raepa.raepa_ouvraep_p;
DROP MATERIALIZED VIEW IF EXISTS raepa.raepa_ouvrass_p;
DROP MATERIALIZED VIEW IF EXISTS raepa.raepa_reparaep_p;
DROP MATERIALIZED VIEW IF EXISTS raepa.raepa_reparass_p;

-- fkey
ALTER TABLE IF EXISTS raepa.noeud DROP CONSTRAINT val_raepa_idcanamont_fkey;
ALTER TABLE IF EXISTS raepa.noeud DROP CONSTRAINT val_raepa_idcanaval_fkey;


-- pkey

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      RENOMMER                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- fkey

ALTER TABLE raepa.metadonnees_raepa RENAME CONSTRAINT val_raepa_qualite_anpose_fkey TO lt_raepa_qualannee_fkey;
ALTER TABLE raepa.metadonnees_raepa RENAME CONSTRAINT val_raepa_qualite_geoloc_xy_fkey TO lt_raepa_qualglocxy_fkey;
ALTER TABLE raepa.metadonnees_raepa RENAME CONSTRAINT val_raepa_qualite_geoloc_z_fkey TO lt_raepa_qualglocz_fkey;
ALTER TABLE raepa.canalisation RENAME CONSTRAINT val_raepa_materiau_fkey TO lt_raepal_materiau_fkey;
ALTER TABLE raepa.canalisation RENAME CONSTRAINT val_raepa_mode_circulation_fkey TO lt_raepa_modecirc_fkey;
ALTER TABLE raepa.canalisation_ae RENAME CONSTRAINT val_raepa_cat_canal_ae_fkey TO lt_raepal_contcanaep_fkey;
ALTER TABLE raepa.canalisation_ae RENAME CONSTRAINT val_raepa_fonc_canal_ae_fkey TO lt_raepa_fonccanaep_fkey;
ALTER TABLE raepa.canalisation_ass RENAME CONSTRAINT val_raepa_typ_reseau_ass_fkey TO lt_raepa_typreseau_fkey;
ALTER TABLE raepa.canalisation_ass RENAME CONSTRAINT val_raepa_cat_canal_ass_fkey TO lt_raepa_contcanass_fkey;
ALTER TABLE raepa.canalisation_ass RENAME CONSTRAINT val_raepa_fonc_canal_ass_fkey TO lt_raepa_fonccanass_fkey;
ALTER TABLE raepa.appareillage_ae RENAME CONSTRAINT val_raepa_fonc_app_ae_fkey TO lt_raepal_fnappaep_fkey;
ALTER TABLE raepa.appareillage_ass RENAME CONSTRAINT val_raepa_typ_reseau_ass_fkey TO lt_raepa_typreseau_fkey;
ALTER TABLE raepa.appareillage_ass RENAME CONSTRAINT val_raepa_fonc_app_ass_fkey TO lt_raepa_fnappass_fkey;
ALTER TABLE raepa.ouvrage_ae RENAME CONSTRAINT val_raepa_fonc_ouv_ae_fkey TO lt_raepa_fnouvaep_fkey;
ALTER TABLE raepa.ouvrage_ass RENAME CONSTRAINT val_raepa_typ_reseau_ass_fkey TO lt_raepa_typreseau_fkey;
ALTER TABLE raepa.ouvrage_ass RENAME CONSTRAINT val_raepa_fonc_ouv_ass_fkey TO lt_raepa_fnouvass_fkey;
ALTER TABLE raepa.reparation RENAME CONSTRAINT val_raepa_support_incident_fkey TO lt_raepa_support_incident_fkey;
ALTER TABLE raepa.reparation RENAME CONSTRAINT val_raepa_defaillance_fkey TO lt_raepa_defaillance_fkey;


-- classe

ALTER TABLE IF EXISTS raepa.metadonnees_raepa RENAME TO an_raepal_objet_reseau;
ALTER TABLE IF EXISTS raepa.canalisation RENAME TO an_raepa_canal;
ALTER TABLE IF EXISTS raepa.canalisation_ae RENAME TO an_raepa_canalae;
ALTER TABLE IF EXISTS raepa.canalisation_ass RENAME TO an_raepa_canalass;
ALTER TABLE IF EXISTS raepa.noeud RENAME TO geo_raepa_noeud;
ALTER TABLE IF EXISTS raepa.appareillage RENAME TO an_raepa_app;
ALTER TABLE IF EXISTS raepa.appareillage_ae RENAME TO an_raepa_appae;
ALTER TABLE IF EXISTS raepa.appareillage_ass RENAME TO an_raepa_appass;
ALTER TABLE IF EXISTS raepa.ouvrage RENAME TO an_raepa_ouv;
ALTER TABLE IF EXISTS raepa.ouvrage_ae RENAME TO an_raepa_ouvae;
ALTER TABLE IF EXISTS raepa.ouvrage_ass RENAME TO an_raepa_ouvass;
ALTER TABLE IF EXISTS raepa.reparation RENAME TO geo_raepa_repar;

-- domaine de valeur

ALTER TABLE IF EXISTS raepa.val_raepa_materiau RENAME TO lt_raepal_materiau;
ALTER TABLE IF EXISTS raepa.val_raepa_mode_circulation RENAME TO lt_raepa_modecirc;
ALTER TABLE IF EXISTS raepa.val_raepa_qualite_anpose RENAME TO lt_raepa_qualannee;
ALTER TABLE IF EXISTS raepa.val_raepa_qualite_geoloc RENAME TO lt_raepa_qualgloc;
ALTER TABLE IF EXISTS raepa.val_raepa_support_incident RENAME TO lt_raepa_support_incident;
ALTER TABLE IF EXISTS raepa.val_raepa_defaillance RENAME TO lt_raepa_defaillance;
ALTER TABLE IF EXISTS raepa.val_raepa_cat_canal_ae RENAME TO lt_raepal_contcanaep;
ALTER TABLE IF EXISTS raepa.val_raepa_fonc_canal_ae RENAME TO lt_raepa_fonccanaep;
ALTER TABLE IF EXISTS raepa.val_raepa_fonc_app_ae RENAME TO lt_raepal_fnappaep;
ALTER TABLE IF EXISTS raepa.val_raepa_fonc_ouv_ae RENAME TO lt_raepa_fnouvaep;
ALTER TABLE IF EXISTS raepa.val_raepa_typ_reseau_ass RENAME TO lt_raepa_typreseau;
ALTER TABLE IF EXISTS raepa.val_raepa_cat_canal_ass RENAME TO lt_raepa_contcanass;
ALTER TABLE IF EXISTS raepa.val_raepa_fonc_canal_ass RENAME TO lt_raepa_fonccanass;
ALTER TABLE IF EXISTS raepa.val_raepa_fonc_app_ass RENAME TO lt_raepa_fnappass;
ALTER TABLE IF EXISTS raepa.val_raepa_fonc_ouv_ass RENAME TO lt_raepa_fnouvass;

-- sequence

ALTER SEQUENCE IF EXISTS raepa.raepa_idraepa RENAME TO raepa_id_obj_reseau_seq;
ALTER SEQUENCE IF EXISTS raepa.raepa_idrepar RENAME TO raepa_id_repar_seq;

-- attributs
	-- nom
ALTER TABLE IF EXISTS raepa.an_raepa_canalae  RENAME profgen TO distgen;
ALTER TABLE IF EXISTS raepa.an_raepa_app  RENAME z TO zradapp;
ALTER TABLE IF EXISTS raepa.an_raepa_ouv  RENAME z TO zradouv;

ALTER TABLE IF EXISTS raepa.an_raepa_canal  RENAME idcana TO idprod;
COMMENT ON COLUMN raepa.an_raepa_canal.idprod IS 'Identifiant du producteur';
ALTER TABLE IF EXISTS raepa.an_raepa_canal DROP CONSTRAINT canalisation_pkey; -- suppression pkey qui n'est plus sur cet attribut

ALTER TABLE IF EXISTS raepa.an_raepa_canalae  RENAME idcana TO idprod;
COMMENT ON COLUMN raepa.an_raepa_canalae.idprod IS 'Identifiant du producteur';
ALTER TABLE IF EXISTS raepa.an_raepa_canalae DROP CONSTRAINT canalisation_ae_pkey;  -- suppression pkey qui n'est plus sur cet attribut


ALTER TABLE IF EXISTS raepa.an_raepa_canalass  RENAME idcana TO idprod;
COMMENT ON COLUMN raepa.an_raepa_canalass.idprod IS 'Identifiant du producteur';
ALTER TABLE IF EXISTS raepa.an_raepa_canalass DROP CONSTRAINT canalisation_ass_pkey; -- suppression pkey qui n'est plus sur cet attribut


ALTER TABLE IF EXISTS raepa.an_raepa_app  RENAME idappareil TO idprod;
COMMENT ON COLUMN raepa.an_raepa_app.idprod IS 'Identifiant du producteur';
ALTER TABLE IF EXISTS raepa.an_raepa_app DROP CONSTRAINT appareillage_pkey; -- suppression pkey qui n'est plus sur cet attribut


ALTER TABLE IF EXISTS raepa.an_raepa_appae  RENAME idappareil TO idprod;
COMMENT ON COLUMN raepa.an_raepa_appae.idprod IS 'Identifiant du producteur';
ALTER TABLE IF EXISTS raepa.an_raepa_appae DROP CONSTRAINT appareillage_ae_pkey; -- suppression pkey qui n'est plus sur cet attribut


ALTER TABLE IF EXISTS raepa.an_raepa_appass  RENAME idappareil TO idprod;
COMMENT ON COLUMN raepa.an_raepa_appass.idprod IS 'Identifiant du producteur';
ALTER TABLE IF EXISTS raepa.an_raepa_appass DROP CONSTRAINT appareillage_ass_pkey; -- suppression pkey qui n'est plus sur cet attribut


ALTER TABLE IF EXISTS raepa.an_raepa_ouv  RENAME idouvrage TO idprod;
COMMENT ON COLUMN raepa.an_raepa_ouv.idprod IS 'Identifiant du producteur';
ALTER TABLE IF EXISTS raepa.an_raepa_ouv DROP CONSTRAINT ouvrage_pkey; -- suppression pkey qui n'est plus sur cet attribut


ALTER TABLE IF EXISTS raepa.an_raepa_ouvae  RENAME idouvrage TO idprod;
COMMENT ON COLUMN raepa.an_raepa_ouvae.idprod IS 'Identifiant du producteur';
ALTER TABLE IF EXISTS raepa.an_raepa_ouvae DROP CONSTRAINT ouvrage_ae_pkey; -- suppression pkey qui n'est plus sur cet attribut


ALTER TABLE IF EXISTS raepa.an_raepa_ouvass  RENAME idouvrage TO idprod;
COMMENT ON COLUMN raepa.an_raepa_ouvass.idprod IS 'Identifiant du producteur';
ALTER TABLE IF EXISTS raepa.an_raepa_ouvass DROP CONSTRAINT ouvrage_ass_pkey; -- suppression pkey qui n'est plus sur cet attribut


ALTER TABLE IF EXISTS raepa.an_raepal_objet_reseau  RENAME idraepa TO idprod;
COMMENT ON COLUMN raepa.an_raepal_objet_reseau.idprod IS 'Identifiant du producteur';
ALTER TABLE IF EXISTS raepa.an_raepal_objet_reseau DROP CONSTRAINT metadonnees_raepa_pkey; -- suppression pkey qui n'est plus sur cet attribut





-- Schema
ALTER SCHEMA raepa RENAME TO m_raepa;

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                    SUPPRESSION SET DEFAULT NEXTVAL                                           ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

ALTER TABLE m_raepa.an_raepa_canal ALTER COLUMN idprod DROP DEFAULT;
ALTER TABLE m_raepa.geo_raepa_noeud ALTER COLUMN idnoeud DROP DEFAULT;
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                             CREATION TABLE CORRESPONDANCES IDNOEUD AVEC IDPROD                                               ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################
/* Cela permet de conserver la correspondance entre les idprod de chaque noeud (qui se superposent sur le raepa), 
avec l'idnoeud généré par le service, de manière à joindre notre identifiant interne aux idnini et idnterm des canalisations. */

CREATE TABLE m_raepa.an_raepal_correspondance
(
  idprod character varying (254), -- identifiant producteur du noeud
  idnoeud bigint NOT NULL, -- identifiant interne du noeud
  CONSTRAINT m_reseau_idprod_pkey PRIMARY KEY (idprod)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.an_raepal_correspondance
  IS 'Table de correspondance entre les identifiants des noeuds producteurs et ceux interne.';
COMMENT ON COLUMN m_raepa.an_raepal_correspondance.idprod IS 'Identifiant du producteur du noeud';
COMMENT ON COLUMN m_raepa.an_raepal_correspondance.idnoeud IS 'Identifiant interne du noeud';



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                EXTENSION DES LISTES RAEPA                                               ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

--#################   MATERIAU   ###################
ALTER TABLE IF EXISTS m_raepa.an_raepa_canal DROP CONSTRAINT IF EXISTS lt_raepal_materiau_fkey;

DROP TABLE IF EXISTS m_raepa.lt_raepal_materiau;

-- Table: m_raepa.lt_raepal_materiau

-- DROP TABLE m_raepa.lt_raepal_materiau;


CREATE TABLE m_raepa.lt_raepal_materiau
(
  code_arc character varying(5) NOT NULL, -- code interne de l'arc pour améliorer finesse informations par rapport au RAEPA
  code_raepa character varying (2) NOT NULL, -- code raepa du matériau
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition du matériau
  CONSTRAINT m_reseau_materiau_pkey PRIMARY KEY (code_arc)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_materiau
  IS 'Matériau constitutif des tuyaux composant une canalisation';
COMMENT ON COLUMN m_raepa.lt_raepal_materiau.code_arc IS 'Code interne de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation';
COMMENT ON COLUMN m_raepa.lt_raepal_materiau.code_raepa IS 'Code raepa de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation';
COMMENT ON COLUMN m_raepa.lt_raepal_materiau.valeur IS 'Valeur de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation';
COMMENT ON COLUMN m_raepa.lt_raepal_materiau.definition IS 'Définition de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation';

INSERT INTO m_raepa.lt_raepal_materiau(code_arc,
            code_raepa, valeur, definition)
    VALUES
('00-00','00','Indéterminé','Canalisation composée de tuyaux dont le matériau est inconnu'),
('01-00','01','Acier','Canalisation composée de tuyaux d''acier'),
('02-00','02','Amiante-ciment','Canalisation composée de tuyaux d''amiante-ciment'),
('03-00','99','Béton','Canalisation composée de tuyaux de béton'),
('03-01','03','Béton âme tôle','Canalisation composée de tuyaux de béton âme tôle'),
('03-02','04','Béton armé','Canalisation composée de tuyaux de béton armé'),
('03-03','05','Béton fibré','Canalisation composée de tuyaux de béton fibré'),
('03-04','06','Béton non armé','Canalisation composée de tuyaux de béton non armé'),
('03-99','99','Béton autre','Canalisation composée de tuyaux de béton ne figurant pas dans la liste'),
('04-00','07','Cuivre','Canalisation composée de tuyaux de cuivre'),
('05-00','99','Fibre','Canalisation composée de tuyaux de fibre'),
('05-01','08','Fibre ciment','Canalisation composée de tuyaux de fibre ciment'),
('05-02','09','Fibre de verre','Canalisation composée de tuyaux de fibre de verre'),
('05-03','10','Fibrociment','Canalisation composée de tuyaux de fibrociment'),
('05-99','99','Fibre autre','Canalisation composée de tuyaux de fibre ne figurant pas dans la liste'),
('06-00','99','Fonte','Canalisation composée de tuyaux de fonte'),
('06-01','11','Fonte ductile','Canalisation composée de tuyaux de fonte ductile'),
('06-02','12','Fonte grise','Canalisation composée de tuyaux de fonte grise'),
('06-99','99','Fonte autre','Canalisation composée de tuyaux de fonte ne figurant pas dans la liste'),
('07-00','13','Grès','Canalisation composée de tuyaux de grès'),
('08-00','14','Maçonnerie','Canalisation maçonnée'),
('09-00','15','Meulière','Canalisation construite en pierre meulière'),
('10-00','99','PE','Canalisation composée de tuyaux de polyéthylène'),
('10-10','16','PEBD','Canalisation composée de tuyaux de polyéthylène basse densité'),
('10-20','99','PEHD','Canalisation composée de tuyaux de polyéthylène haute densité'),
('10-21','17','PEHD annelé','Canalisation composée de tuyaux de polyéthylène haute densité annelés'),
('10-22','18','PEHD lisse','Canalisation composée de tuyaux de polyéthylène haute densité lisses'),
('10-99','99','PE autre','Canalisation composée de tuyaux de polyéthylène ne figurant pas dans la liste'),
('11-00','19','Plomb','Canalisation composée de tuyaux de plomb'),
('12-00','99','PP','Canalisation composée de tuyaux de polypropylène'),
('12-01','20','PP annelé','Canalisation composée de tuyaux de polypropylène annelés'),
('12-02','21','PP lisse','Canalisation composée de tuyaux de polypropylène lisses'),
('12-99','99','PP autre','Canalisation composée de tuyaux de polypropylène ne figurant pas dans la liste'),
('13-00','99','PRV','Canalisation composée de polyester renforcé de fibre de verre'),
('13-01','22','PRV A','Canalisation composée de polyester renforcé de fibre de verre (série A)'),
('13-02','23','PRV B','Canalisation composée de polyester renforcé de fibre de verre (série B)'),
('13-99','18','PRV autre','Canalisation composée de polyester renforcé de fibre de verre ne figurant pas dans la liste'),
('14-00','99','PVC','Canalisation composée de tuyaux de polychlorure de vinyle'),
('14-10','24','PVC ancien','Canalisation composée de tuyaux de polychlorure de vinyle posés avant 1980'),
('14-20','25','PVC BO','Canalisation composée de tuyaux de polychlorure de vinyle bi-orienté'),
('14-30','99','PVC U','Canalisation composée de tuyaux de polychlorure de vinyle rigide'),
('14-31','26','PVC U annelé','Canalisation composée de tuyaux de polychlorure de vinyle rigide annelés'),
('14-32','27','PVC U lisse','Canalisation composée de tuyaux de polychlorure de vinyle rigide lisses'),
('14-99','99','PVC autre','Canalisation composée de tuyaux de polychlorure de vinyle ne figurant pas dans la liste'),
('15-00','99','Tôle','Canalisation construite en tôle'),
('15-01','28','Tôle galvanisée','Canalisation construite en tôle galvanisée'),
('15-99','99','Tôle autre','Canalisation construite en tôle ne figurant pas dans la liste'),
('99-00','99','Autre','Canalisation composée de tuyaux dont le matériau ne figure pas dans la liste ci-dessus');

ALTER TABLE m_raepa.an_raepa_canal
	ADD CONSTRAINT lt_raepa_materiau_fkey FOREIGN KEY (materiau)
	 REFERENCES m_raepa.lt_raepal_materiau (code_arc) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;         

--#################   SENSECOUL  ###################
-- Table: m_raepa.lt_raepal_sensecoul

-- DROP TABLE m_raepa.lt_raepal_sensecoul;


CREATE TABLE m_raepa.lt_raepal_sensecoul
(
  code character varying(1) NOT NULL, -- code de la liste
  code_raepa character varying (1), -- code raepa
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition du matériau
  CONSTRAINT m_reseau_sensecoul_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_sensecoul
  IS 'Sens d''écoulement de la canalisation';
COMMENT ON COLUMN m_raepa.lt_raepal_sensecoul.code IS 'Code ARC de la liste énumérée relative au sens d''écoulement de la canalisation.';
COMMENT ON COLUMN m_raepa.lt_raepal_sensecoul.code_raepa IS 'Code RAEPA de la liste énumérée relative au sens d''écoulement de la canalisation.';
COMMENT ON COLUMN m_raepa.lt_raepal_sensecoul.valeur IS 'Valeur de la liste énumérée relative au sens d''écoulement de la canalisation.';
COMMENT ON COLUMN m_raepa.lt_raepal_materiau.definition IS 'Définition de la liste énumérée relative au sens d''écoulement de la canalisation.';

INSERT INTO m_raepa.lt_raepal_sensecoul(code,code_raepa,
            valeur, definition)
    VALUES
('0',null,'Indéterminée','Sens d''écoulement inconnu'),
('d','1','Direct','L''écoulement s''effectue du noeud initial vers le noeud terminal'),
('i','0','Inverse','L''écoulement s''effectue du noeud terminal vers le noeud initial');

ALTER TABLE m_raepa.an_raepa_canalass
	ADD CONSTRAINT lt_raepal_sensecoul_fkey FOREIGN KEY (sensecoul)
	 REFERENCES m_raepa.lt_raepal_sensecoul (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;   


--#################   fnouvaep   ###################
ALTER TABLE IF EXISTS m_raepa.an_raepa_ouvae DROP CONSTRAINT IF EXISTS lt_raepa_fnouvaep_fkey;
DROP TABLE IF EXISTS m_raepa.lt_raepa_fnouvaep;

-- Table: m_raepa.lt_raepal_fnouvaep

-- DROP TABLE m_raepa.lt_raepal_fnouvaep;


CREATE TABLE m_raepa.lt_raepal_fnouvaep
(
  code_arc character varying(5) NOT NULL, -- code interne de l'arc pour améliorer finesse informations par rapport au RAEPA
  code_raepa character varying (2) NOT NULL, -- code raepa
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_fnouvaep_pkey PRIMARY KEY (code_arc)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_fnouvaep
  IS 'Liste décrivant le type d''ouvrage d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_fnouvaep.code_arc IS 'Code interne de la liste énumérée relative au type d''ouvrage d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_fnouvaep.code_raepa IS 'Code raepa de la liste énumérée relative au type d''ouvrage d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_fnouvaep.valeur IS 'Valeur de la liste énumérée relative au type d''ouvrage d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_fnouvaep.definition IS 'Définition de la liste énumérée relative au type d''ouvrage d''Adduction d''eau potable';

INSERT INTO m_raepa.lt_raepal_fnouvaep(code_arc,
            code_raepa, valeur, definition)
    VALUES
('00-00','00','Indéterminé','Type d''ouvrage inconnu'),
('01-00','01','Station de pompage','Station de pompage d''eau potable'),
('02-00','02','Station de traitement','Station de traitement d''eau potable'),
('03-00','03','Réservoir','Réservoir d''eau potable'),
('04-00','99','Chambre','Chambre'),
('04-01','04','Chambre de comptage','Chambre de comptage'), -- conservé car présent dans le raepa, mais devrait être dans une classe spécialisée
('05-00','05','Captage','Captage'),
('06-00','99','Citerneau','Petit regard où sont positionné le ou les compteurs individuels'),
('99-99','99','Autre','Ouvrage dont le type ne figure pas dans la liste ci-dessus');

ALTER TABLE m_raepa.an_raepa_ouvae
	ADD CONSTRAINT lt_raepal_fnouvaep_fkey FOREIGN KEY (fnouvaep)
	 REFERENCES m_raepa.lt_raepal_fnouvaep (code_arc) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;   



--#################   fnouvass   ###################
ALTER TABLE IF EXISTS m_raepa.an_raepa_ouvass DROP CONSTRAINT IF EXISTS lt_raepa_fnouvass_fkey;
DROP TABLE IF EXISTS m_raepa.lt_raepa_fnouvass;

-- Table: m_raepa.lt_raepal_fnouvass

-- DROP TABLE m_raepa.lt_raepal_fnouvass;


CREATE TABLE m_raepa.lt_raepal_fnouvass
(
  code_arc character varying(5) NOT NULL, -- code interne de l'arc pour améliorer finesse informations par rapport au RAEPA
  code_raepa character varying (2) NOT NULL, -- code raepa
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_fnouvass_pkey PRIMARY KEY (code_arc)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_fnouvass
  IS 'Liste décrivant le type d''ouvrage d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_fnouvass.code_arc IS 'Code interne de la liste énumérée relative au type d''ouvrage d''Assanissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_fnouvass.code_raepa IS 'Code raepa de la liste énumérée relative au type d''ouvrage d''Assanissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_fnouvass.valeur IS 'Valeur de la liste énumérée relative au type d''ouvrage d''Assanissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_fnouvass.definition IS 'Définition de la liste énumérée relative au type d''ouvrage d''Assanissement collectif';

INSERT INTO m_raepa.lt_raepal_fnouvass(code_arc,
            code_raepa, valeur, definition)
    VALUES
('00-00','00','Indéterminé','Type d''ouvrage inconnu'),
('01-00','01','Station de pompage','Station de pompage d''eaux usées et/ou pluviales'),
('02-00','02','Station d''épuration','Station de traitement d''eaux usées'),
('03-00','03','Bassin de stockage','Ouvrage de stockage d''eaux usées et/ou pluviales'),
('04-00','04','Déversoir d''orage','Ouvrage de décharge du trop-plein d''effluents d''une canalisation d''assainissement collectif vers un milieu naturel récepteur'),
('05-00','05','Rejet','Rejet (exutoire) dans le milieu naturel d''eaux usées ou pluviales'),
('05-01','99','Rejet eaux pluviales','Rejet (exutoire) dans le milieu d''eaux pluviales'),
('05-02','99','Rejet eaux usées','Rejet (exutoire) dans le milieu naturel d''eaux usées'),
('05-99','99','Rejet Autre','Autre type de rejet'),
('06-00','06','Regard','Ouvrage de regard'),
('07-00','07','Avaloir','Avaloir'),
('08-00','99','Station sous-vide','Station sous-vide'),
('09-00','99','Chambre à sable','Chambre à sable'),
('99-99','99','Autre','Ouvrage dont le type ne figure pas dans la liste ci-dessus');

ALTER TABLE m_raepa.an_raepa_ouvass
	ADD CONSTRAINT lt_raepal_fnouvass_fkey FOREIGN KEY (fnouvass)
	 REFERENCES m_raepa.lt_raepal_fnouvass (code_arc) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;   

--#################   fnappass   ###################
ALTER TABLE IF EXISTS m_raepa.an_raepa_appass DROP CONSTRAINT IF EXISTS lt_raepa_fnappass_fkey;
DROP TABLE IF EXISTS m_raepa.lt_raepa_fnappass;

-- Table: m_raepa.lt_raepal_fnappass

-- DROP TABLE m_raepa.lt_raepal_fnappass;


CREATE TABLE m_raepa.lt_raepal_fnappass
(
  code_arc character varying(5) NOT NULL, -- code interne de l'arc pour améliorer finesse informations par rapport au RAEPA
  code_raepa character varying (2) NOT NULL, -- code raepa
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_fnappass_pkey PRIMARY KEY (code_arc)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_fnappass
  IS 'Liste décrivant le type d''appareillage d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_fnappass.code_arc IS 'Code interne de la liste énumérée relative au type d''appareillage d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_fnappass.code_raepa IS 'Code raepa de la liste énumérée relative au type d''appareillage d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_fnappass.valeur IS 'Valeur de la liste énumérée relative au type d''appareillage d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_fnappass.definition IS 'Définition de la liste énumérée relative au type d''appareillage d''Assainissement collectif';

INSERT INTO m_raepa.lt_raepal_fnappass(code_arc,
            code_raepa, valeur, definition)
    VALUES
('00-00','00','Indéterminé','Type d''appareillage inconnu'),
('01-00','01','Point de branchement','Piquage de branchement individuel'),
('02-00','02','Ventouse','Ventouse d''assainissement'),
('03-00','03','Vanne','Vanne d''assainissement'),
('04-00','99','Point métrologique','Point métrologique'),
('04-01','04','Débitmètre','Appareil de mesure des débits transités'),
('04-03','99','Pluviometre','Appareil de mesure des quantités de précipitation'),
('04-99','99','Autre point métrologique','Point métrologique autre que la liste énumérée'),
('05-00','99','Batardeau','Batardeau'),
('06-00','99','Chasse','Chasse'),
('99-99','99','','Appareillage dont le type ne figure pas dans la liste ci-dessus');

ALTER TABLE m_raepa.an_raepa_appass
	ADD CONSTRAINT lt_raepal_fnappass_fkey FOREIGN KEY (fnappass)
	 REFERENCES m_raepa.lt_raepal_fnappass (code_arc) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
	  

--#################   fnappaaep   ###################
ALTER TABLE IF EXISTS m_raepa.an_raepa_appae DROP CONSTRAINT IF EXISTS lt_raepal_fnappaep_fkey;
DROP TABLE IF EXISTS m_raepa.lt_raepal_fnappaep;

-- Table: m_raepa.lt_raepal_fnappaep

-- DROP TABLE m_raepa.lt_raepal_fnappaep;


CREATE TABLE m_raepa.lt_raepal_fnappaep
(
  code_arc character varying(5) NOT NULL, -- code interne de l'arc pour améliorer finesse informations par rapport au RAEPA
  code_raepa character varying (2) NOT NULL, -- code raepa
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_fnappaep_pkey PRIMARY KEY (code_arc)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_fnappaep
  IS 'Liste décrivant le type d''appareillage d''Adduction d''eau';
COMMENT ON COLUMN m_raepa.lt_raepal_fnappaep.code_arc IS 'Code interne de la liste énumérée relative au type d''appareillage d''Adduction d''eau';
COMMENT ON COLUMN m_raepa.lt_raepal_fnappaep.code_raepa IS 'Code raepa de la liste énumérée relative au type d''appareillage d''Adduction d''eau';
COMMENT ON COLUMN m_raepa.lt_raepal_fnappaep.valeur IS 'Valeur de la liste énumérée relative au type d''appareillage d''Adduction d''eau';
COMMENT ON COLUMN m_raepa.lt_raepal_fnappaep.definition IS 'Définition de la liste énumérée relative au type d''appareillage d''Adduction d''eau';

INSERT INTO m_raepa.lt_raepal_fnappaep(code_arc,
            code_raepa, valeur, definition)
    VALUES
('00-00','00','Indéterminé','Type d''appareillage inconnu'),
('01-00','01','Point de branchement','Piquage de branchement individuel'),
('02-00','02','Ventouse','Ventouse d''adduction d''eau'),
('03-00','03','Vanne','Vanne d''adduction d''eau'),
('04-00','04','Vidange','Vidange d''adduction d''eau'),
('05-00','05','Régulateur de pression','Régulateur de pression d''adduction d''eau'),
('06-00','06','Hydrant','Hydrant'),
('07-00','99','Point métrologique','Point métrologique'),
('07-01','07','Compteur','Appareil de mesure des volumes transités'),
('07-02','08','Débitmètre','Appareil de mesure des débits transités'),
('07-03','99','Capteur de pression','Appareil de mesure de pression'),
('07-99','99','Autre point métrologique','Point métrologique autre que la liste énumérée'),
('99-99','99','Autre','Appareillage dont le type ne figure pas dans la liste ci-dessus');

ALTER TABLE m_raepa.an_raepa_appae
	ADD CONSTRAINT lt_raepal_fnappaep_fkey FOREIGN KEY (fnappaep)
	 REFERENCES m_raepa.lt_raepal_fnappaep (code_arc) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
	  

--#################   contcanaep   ###################
ALTER TABLE IF EXISTS m_raepa.an_raepa_canalae DROP CONSTRAINT IF EXISTS lt_raepal_contcanaep_fkey;
DROP TABLE IF EXISTS m_raepa.lt_raepal_contcanaep;

-- Table: m_raepa.lt_raepal_contcanaep

-- DROP TABLE m_raepa.lt_raepal_contcanaep;


CREATE TABLE m_raepa.lt_raepal_contcanaep
(
  code_arc character varying(5) NOT NULL, -- code interne de l'arc pour améliorer finesse informations par rapport au RAEPA
  code_raepa character varying (2) NOT NULL, -- code raepa
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_contcanaep_pkey PRIMARY KEY (code_arc)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_contcanaep
  IS '';
COMMENT ON COLUMN m_raepa.lt_raepal_contcanaep.code_arc IS 'Code interne de la liste énumérée relative au type d''ouvrage d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_contcanaep.code_raepa IS 'Code raepa de la liste énumérée relative au type d''ouvrage d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_contcanaep.valeur IS 'Valeur de la liste énumérée relative au type d''ouvrage d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_contcanaep.definition IS 'Définition de la liste énumérée relative au type d''ouvrage d''Adduction d''eau potable';

INSERT INTO m_raepa.lt_raepal_contcanaep(code_arc,
            code_raepa, valeur, definition)
    VALUES
('00-00','00','Indéterminé','Nature des eaux véhiculées par la canalisation inconnue'),
('01-00','01','Eau brute','Canalisation véhiculant de l''eau brute'),
('02-00','02','Eau potable','Canalisation véhiculant de l''eau potable'),
('03-00','99','Eau de lavage','Canalisation véhiculant des eaux de lavage'),
('04-00','99','Eau traitée','Canalisation véhiculant des eaux traitées'),
('99-99','99','Autre','Canalisation véhiculant tantôt de l''eau brute, tantôt de l''eau potable');

ALTER TABLE m_raepa.an_raepa_canalae
	ADD CONSTRAINT lt_raepal_contcanaep_fkey FOREIGN KEY (contcanaep)
	 REFERENCES m_raepa.lt_raepal_contcanaep (code_arc) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;   

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                AJOUT DES LISTES LOCALES                                                      ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- ###################################################### 
-- ###NIVEAU 0 : Superclasse an_raepal_objet_reseau   ###
-- #######################################################

--#################   positver   ###################

-- Table: m_raepa.lt_raepal_positver

-- DROP TABLE m_raepa.lt_raepal_positver;


CREATE TABLE m_raepa.lt_raepal_positver
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_positver_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_positver
  IS 'Liste décrivant la position verticale de l''objet du réseau';
COMMENT ON COLUMN m_raepa.lt_raepal_positver.code IS 'Code interne de la liste énumérée relative à la position verticale de l''objet du réseau';
COMMENT ON COLUMN m_raepa.lt_raepal_positver.valeur IS 'Valeur de la liste énumérée relative à la position verticale de l''objet du réseau';
COMMENT ON COLUMN m_raepa.lt_raepal_positver.definition IS 'Définition de la liste énumérée relative à la position verticale de l''objet du réseau';

INSERT INTO m_raepa.lt_raepal_positver(code,
            valeur, definition)
    VALUES
('00','Indéterminé','Position verticale non connu'),
('01','Surface','Objet de réseau positionné à la surface'),
('02','Suspendue','Objet de réseau suspendu (aérien)'),
('03','Enterrée','Objet de réseau entérré');




--#################   domaine   ###################

-- Table: m_raepa.lt_raepal_domaine

-- DROP TABLE m_raepa.lt_raepal_domaine;


CREATE TABLE m_raepa.lt_raepal_domaine
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_domaine_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_domaine
  IS 'Liste décrivant le domaine d''appartenance de l''objet du réseau';
COMMENT ON COLUMN m_raepa.lt_raepal_domaine.code IS 'Code interne de la liste énumérée relative au domaine d''appartenance de l''objet du réseau';
COMMENT ON COLUMN m_raepa.lt_raepal_domaine.valeur IS 'Valeur de la liste énumérée relative au domaine d''appartenance de l''objet du réseau';
COMMENT ON COLUMN m_raepa.lt_raepal_domaine.definition IS 'Définition de la liste énumérée relative au domaine d''appartenance de l''objet du réseau';

INSERT INTO m_raepa.lt_raepal_domaine(code,
            valeur, definition)
    VALUES
('00','Indéterminé','Domaine inconnu'),
('01','Public','Objet appartenant au domaine public'),
('02','Privé','Objet appartenant au domaine privé'),
('ZZ','Non concerné','Non concerné');


--#################   etat   ###################

-- Table: m_raepa.lt_raepal_etat

-- DROP TABLE m_raepa.lt_raepal_etat;


CREATE TABLE m_raepa.lt_raepal_etat
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_etat_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_etat
  IS 'Liste décrivant l''état de l''objet du réseau';
COMMENT ON COLUMN m_raepa.lt_raepal_etat.code IS 'Code interne de la liste énumérée relative à l''état de l''objet du réseau';
COMMENT ON COLUMN m_raepa.lt_raepal_etat.valeur IS 'Valeur de la liste énumérée relative à l''état de l''objet du réseau';
COMMENT ON COLUMN m_raepa.lt_raepal_etat.definition IS 'Définition de la liste énumérée relative à l''état de l''objet du réseau';

INSERT INTO m_raepa.lt_raepal_etat(code,
            valeur, definition)
    VALUES
('00','Indéterminé','Etat inconnu'),
('01','Bon','Objet en bon état'),
('02','Défectueux','Objet défectueux'),
('03','Travaux à envisager','Objet dont des travaux sont à envisager'),
('04','Travaux programmés','Objet dont des travaux sont programmés'),
('99','Autre','Objet dont l''état ne figure pas dans la liste ci-dessus');


--#################   boolean   ###################

-- Table: m_raepa.lt_raepal_boolean

-- DROP TABLE m_raepa.lt_raepal_boolean;


CREATE TABLE m_raepa.lt_raepal_boolean
(
  code character varying(1) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_boolean_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_boolean
  IS 'Liste de faux booléen';
COMMENT ON COLUMN m_raepa.lt_raepal_boolean.code IS 'Code interne de la liste énumérée relative au faux booléen';
COMMENT ON COLUMN m_raepa.lt_raepal_boolean.valeur IS 'Valeur de la liste énumérée relative au faux booléen';
COMMENT ON COLUMN m_raepa.lt_raepal_boolean.definition IS 'Définition de la liste énumérée relative au faux booléen';

INSERT INTO m_raepa.lt_raepal_boolean(code,
            valeur, definition)
    VALUES
('0','Indéterminé','Etat inconnu'),
('t','Oui','True'),
('f','Non','False');



-- ###################################################### 
-- ###NIVEAU 1 : Classes géométriques                  ###
-- #######################################################


-- ###################################################### 
-- ###NIVEAU 2 : classes d'objets                      ###
-- #######################################################

--#################   formcana   ###################

-- Table: m_raepa.lt_raepal_formcana

-- DROP TABLE m_raepa.lt_raepal_formcana;


CREATE TABLE m_raepa.lt_raepal_formcana
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_formcana_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_formcana
  IS 'Liste décrivant la forme de la canalisation';
COMMENT ON COLUMN m_raepa.lt_raepal_formcana.code IS 'Code interne de la liste énumérée relative à la forme de la canalisation';
COMMENT ON COLUMN m_raepa.lt_raepal_formcana.valeur IS 'Valeur de la liste énumérée relative à la forme de la canalisation';
COMMENT ON COLUMN m_raepa.lt_raepal_formcana.definition IS 'Définition de la liste énumérée relative à la forme de la canalisation';

INSERT INTO m_raepa.lt_raepal_formcana(code,
            valeur, definition)
    VALUES
('00','Indéterminé','Forme inconnu'),
('01','Circulaire','Canalisation de forme circulaire'),
('02','Ovoïde','Canalisation de forme  ovoïde'),
('03','Dalot','Canalisation de forme dalot'),
('99','Autre','Forme de canalisation ne figurant pas dans la liste ci-dessus');



--#################   typprot   ###################

-- Table: m_raepa.lt_raepal_typprot

-- DROP TABLE m_raepa.lt_raepal_typprot;


CREATE TABLE m_raepa.lt_raepal_typprot
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_typprot_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_typprot
  IS 'Liste décrivant le type de protection de la canalisation';
COMMENT ON COLUMN m_raepa.lt_raepal_typprot.code IS 'Code interne de la liste énumérée relative au type de protection de la canalisation';
COMMENT ON COLUMN m_raepa.lt_raepal_typprot.valeur IS 'Valeur de la liste énumérée relative au type de protection de la canalisation';
COMMENT ON COLUMN m_raepa.lt_raepal_typprot.definition IS 'Définition de la liste énumérée relative au type de protection de la canalisation';

INSERT INTO m_raepa.lt_raepal_typprot(code,
            valeur, definition)
    VALUES
('00','Indéterminé','Forme inconnu'),
('01','Aucune','Aucune protection'),
('02','Ciment','Protection ciment'),
('03','Époxy','Protection époxy'),
('04','Bitumeux','Protection bitumeux'),
('05','Polyéthylène','Protection en polyéthylène'),
('06','Polypropylène','Protection en polypropylène'),
('07','Zinc','Protection en zinc'),
('08','Alliage Zinc aluminium','Protection en alliage de zinc aluminium'),
('09','Alliage Zinc cuivré','Protection en alliage de zinc cuivré'),
('99','Autre','Type de protection ne figurant pas dans la liste ci-dessus');



--#################   typimpl   ###################

-- Table: m_raepa.lt_raepal_typimpl

-- DROP TABLE m_raepa.lt_raepal_typimpl;


CREATE TABLE m_raepa.lt_raepal_typimpl
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_typimpl_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_typimpl
  IS 'Liste décrivant le type d''implantation de l''ouvrage';
COMMENT ON COLUMN m_raepa.lt_raepal_typimpl.code IS 'Code interne de la liste énumérée relative au type d''implantation de l''ouvrage';
COMMENT ON COLUMN m_raepa.lt_raepal_typimpl.valeur IS 'Valeur de la liste énumérée relative au type d''implantation de l''ouvrage';
COMMENT ON COLUMN m_raepa.lt_raepal_typimpl.definition IS 'Définition de la liste énumérée relative au type d''implantation de l''ouvrage';

INSERT INTO m_raepa.lt_raepal_typimpl(code,
            valeur, definition)
    VALUES
('00','Indéterminé','Type d''implantation inconnu'),
('01','Sous chaussée','Ouvrage implanté sous chaussée'),
('02','Sous trottoir','Ouvrage implanté sous trottoir'),
('03','Bas côté','Ouvrage implanté sur bas côté'),
('04','En privé','Ouvrage implanté en privé'),
('99','Autre','Ouvrage dont le type d''implantation ne figure pas dans la liste ci-dessus');

-- ###################################################### 
-- ###NIVEAU 3 : classes métiers                       ###
-- #######################################################


-- ###################################################### 
-- ###NIVEAU 4 : classes spécialisées                 ###
-- #######################################################

--#################   typusage_ass   ###################

-- Table: m_raepa.lt_raepal_typusage_ass

-- DROP TABLE m_raepa.lt_raepal_typusage_ass;


CREATE TABLE m_raepa.lt_raepal_typusage_ass
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_typusage_ass_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_typusage_ass
  IS 'Liste décrivant le type d''usager raccordé au regard de boîte de branchement d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_typusage_ass.code IS 'Code interne de la liste énumérée relative au type d''usager raccordé au regard de boîte de branchement d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_typusage_ass.valeur IS 'Valeur de la liste énumérée relative au type d''usager raccordé au regard de boîte de branchement d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_typusage_ass.definition IS 'Définition de la liste énumérée relative au type d''usager raccordé au regard de boîte de branchement d''Assainissement collectif';

INSERT INTO m_raepa.lt_raepal_typusage_ass(code,
            valeur, definition)
    VALUES
('00','Indéterminé','Type d''usager inconnu'),
('01','Domestique','Type d''usager domestique'),
('02','Assimilé domestique','Type d''usager assimilié domestique (boulangerie, boucherie, etc.)'),
('03','Industriel','Type d''usager industriel'),
('04','Industriel/Assimilé Domestique','Type d''usager à la fois industriel et assimilé domestique'),
('99','Autre','Type d''usager ne figurant pas dans la liste ci-dessus');


--#################   typusage_ae   ###################

-- Table: m_raepa.lt_raepal_typusage_ae

-- DROP TABLE m_raepa.lt_raepal_typusage_ae;


CREATE TABLE m_raepa.lt_raepal_typusage_ae
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_typusage_ae_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_typusage_ae
  IS 'Liste décrivant le type d''usager raccordé au citerneau d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typusage_ae.code IS 'Code interne de la liste énumérée relative au type d''usager raccordé au citerneau d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typusage_ae.valeur IS 'Valeur de la liste énumérée relative au type d''usager raccordé au citerneau d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typusage_ae.definition IS 'Définition de la liste énumérée relative au type d''usager raccordé au citerneau d''Adduction d''eau potable';

INSERT INTO m_raepa.lt_raepal_typusage_ae(code,
            valeur, definition)
    VALUES
('00','Indéterminé','Type d''usager inconnu'),
('01','Domestique','Type d''usager domestique'),
('03','Industriel','Type d''usager industriel'),
('04','Agricole','Type d''usager agricole'),
('99','Autre','Type d''usager ne figurant pas dans la liste ci-dessus');



--#################   typracc   ###################

-- Table: m_raepa.lt_raepal_typracc

-- DROP TABLE m_raepa.lt_raepal_typracc;


CREATE TABLE m_raepa.lt_raepal_typracc
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_typracc_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_typracc
  IS 'Liste décrivant le type de raccord d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_typracc.code IS 'Code interne de la liste énumérée relative au type de raccord d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_typracc.valeur IS 'Valeur de la liste énumérée relative au type de raccord d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_typracc.definition IS 'Définition de la liste énumérée relative au type de raccord d''Assainissement collectif';

INSERT INTO m_raepa.lt_raepal_typracc(code,
            valeur, definition)
    VALUES
('00','Indéterminé','Type de raccordement inconnu'),
('01','Direct','Boîte de raccordement à passage direct'),
('02','Siphoïde','Boîte de raccordement à passage siphoïde'),
('03','Multidirectionnel','Boîte de raccordement multidirectionnel'),
('99','Autre','Type de raccordement ne figurant pas dans la liste ci-dessus');


--#################   typexut   ###################

-- Table: m_raepa.lt_raepal_typexut

-- DROP TABLE m_raepa.lt_raepal_typexut;


CREATE TABLE m_raepa.lt_raepal_typexut
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_typexut_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_typexut
  IS 'Liste décrivant le type d''éxutoire de l''appareillage de vidange d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typexut.code IS 'Code interne de la liste énumérée relative au type d''éxutoire de l''appareillage de vidange d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typexut.valeur IS 'Valeur de la liste énumérée relative au type d''éxutoire de l''appareillage de vidange d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typexut.definition IS 'Définition de la liste énumérée relative au type d''éxutoire de l''appareillage de vidange d''Adduction d''eau potable';

INSERT INTO m_raepa.lt_raepal_typexut(code,
            valeur, definition)
    VALUES
('00','Indéterminé','Type d''éxutoire'),
('01','Milieu naturel','Exutoire milieu naturel'),
('02','Pluvial','Exutoire pluvial'),
('99','Autre','Type d''éxutoire ne figurant pas dans la liste ci-dessus');


--#################   positvid   ###################

-- Table: m_raepa.lt_raepal_position

-- DROP TABLE m_raepa.lt_raepal_position;


CREATE TABLE m_raepa.lt_raepal_position
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_positvid_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_position
  IS 'Liste décrivant la position de l''appareillage d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_position.code IS 'Code interne de la liste énumérée relative à la position de l''appareillage d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_position.valeur IS 'Valeur de la liste énumérée relative à la position de l''appareillage d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_position.definition IS 'Définition de la liste énumérée relative à la position de l''appareillage d''Adduction d''eau potable';

INSERT INTO m_raepa.lt_raepal_position(code,
            valeur, definition)
    VALUES
('00','Indéterminé','Position inconnue'),
('01','En regard','Appareillage situé en regard'),
('02','Sous bouche à clé','Appareillage situé sous bouche à clé'),
('99','Autre','Autre position de l''appareillage ne figurant pas dans la liste ci-dessus');



--#################   typvanne   ###################

-- Table: m_raepa.lt_raepal_typvanne

-- DROP TABLE m_raepa.lt_raepal_typvanne;


CREATE TABLE m_raepa.lt_raepal_typvanne
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_typvanne_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_typvanne
  IS 'Liste décrivant le type de vanne d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typvanne.code IS 'Code interne de la liste énumérée relative au type de vanne d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typvanne.valeur IS 'Valeur de la liste énumérée relative au type de vanne d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typvanne.definition IS 'Définition de la liste énumérée relative au type de vanne d''Adduction d''eau potable';

INSERT INTO m_raepa.lt_raepal_typvanne(code,
            valeur, definition)
    VALUES
('00','Indéterminé','Type de vanne inconnu'),
('01','Opercule','Vanne opercule'),
('02','Papillon','Vanne papillon'),
('03','Monovar','Vanne monovar'),
('04','Guillotine','Vanne guillotine'),
('05','Pointeau','Vanne pointeau'),
('99','Autre','Type de vanne figurant pas dans la liste ci-dessus');


--#################   etatvan   ###################

-- Table: m_raepa.lt_raepal_etatvan

-- DROP TABLE m_raepa.lt_raepal_etatvan;


CREATE TABLE m_raepa.lt_raepal_etatvan
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_etatvan_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_etatvan
  IS 'Liste décrivant la position de la vanne d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_etatvan.code IS 'Code interne de la liste énumérée relative à la position de la vanne d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_etatvan.valeur IS 'Valeur de la liste énumérée relative à la position de la vanne d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_etatvan.definition IS 'Définition de la liste énumérée relative à la position de la vanne d''Adduction d''eau potable';

INSERT INTO m_raepa.lt_raepal_etatvan(code,
            valeur, definition)
    VALUES
('00','Indéterminée','Position indéterminée'),
('01','Ouverte','Vanne ouverte'),
('02','Fermée','Vanne fermée'),
('99','Autre','Type de position de la vanne ne figurant pas dans la liste ci-dessus');


--#################   typregul   ###################

-- Table: m_raepa.lt_raepal_typregul

-- DROP TABLE m_raepa.lt_raepal_typregul;


CREATE TABLE m_raepa.lt_raepal_typregul
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_typregul_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_typregul
  IS 'Liste décrivant le type de régulateur de pression';
COMMENT ON COLUMN m_raepa.lt_raepal_typregul.code IS 'Code interne de la liste énumérée relative au type de régulateur de pression';
COMMENT ON COLUMN m_raepa.lt_raepal_typregul.valeur IS 'Valeur de la liste énumérée relative au type de régulateur de pression';
COMMENT ON COLUMN m_raepa.lt_raepal_typregul.definition IS 'Définition de la liste énumérée relative au type de régulateur de pression';

INSERT INTO m_raepa.lt_raepal_typregul(code,
            valeur, definition)
    VALUES
('00','Indéterminée','Type de régulateur de pression inconnu'),
('01','Stabilisateur Amont','Régulateur de type Stabilisateur Amont'),
('02','Stabilisateur Aval','Régulateur de type Stabilisateur Aval'),
('03','Stabilisateur Amont - Aval','Régulateur de type Stabilisateur Amont - Aval'),
('04','Limitateur débit','Régulateur de type Limitateur débit'),
('05','Robinet altimétrique','Régulateur de type Robinet altimétrique '),
('06','Vanne de survitesse','Régulateur de type Vanne de survitesse '),
('07','Clapet','Régulateur de type Clapet'),
('08','Disconnecteur','Régulateur de type Disconnecteur'),
('09','Soupape de décharge','Régulateur de type Soupape de décharge'),
('10','Réducteur de pression','Régulateur de type Réducteur de pression'),
('99','Autre','Type de régulateur ne figurant pas dans la liste ci-dessus');



--#################   foncompt   ###################

-- Table: m_raepa.lt_raepal_foncompt

-- DROP TABLE m_raepa.lt_raepal_foncompt;


CREATE TABLE m_raepa.lt_raepal_foncompt
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_foncompt_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_foncompt
  IS 'Liste décrivant la fonction du compteur d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_foncompt.code IS 'Code interne de la liste énumérée relative à la fonction du compteur d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_foncompt.valeur IS 'Valeur de la liste énumérée relative à la fonction du compteur d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_foncompt.definition IS 'Définition de la liste énumérée relative à la fonction du compteur d''Adduction d''eau potable';

INSERT INTO m_raepa.lt_raepal_foncompt(code,
            valeur, definition)
    VALUES
('00','Indéterminée','Type de régulateur de pression inconnu'),
('01','Achat','Compteur d''achat'),
('02','Vente','Compteur de vente'),
('03','Sectorisation','Compteur de sectorisation'),
('04','Achat/Vente','Compteur d''achat et de vente'),
('99','Autre','Fonction du compteur ne figurant pas dans la liste ci-dessus');



--#################   typcompt   ###################

-- Table: m_raepa.lt_raepal_typcompt

-- DROP TABLE m_raepa.lt_raepal_typcompt;


CREATE TABLE m_raepa.lt_raepal_typcompt
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_typcompt_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_typcompt
  IS 'Liste décrivant le type de compteur d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typcompt.code IS 'Code interne de la liste énumérée relative au type de compteur d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typcompt.valeur IS 'Valeur de la liste énumérée relative au type de compteur d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typcompt.definition IS 'Définition de la liste énumérée relative au type de compteur d''Adduction d''eau potable';

INSERT INTO m_raepa.lt_raepal_typcompt(code,
            valeur, definition)
    VALUES
('00','Indéterminée','Type de régulateur de pression inconnu'),
('01','Compteur volume','Compteur de type compteur volume'),
('02','Electromagnétique','Compteur électromagnétique'),
('03','Ultrasons','Compteur à ultrasons'),
('99','Autre','Type de compteur ne figurant pas dans la liste ci-dessus');


--#################   typpompa   ###################

-- Table: m_raepa.lt_raepal_typpompa

-- DROP TABLE m_raepa.lt_raepal_typpompa;


CREATE TABLE m_raepa.lt_raepal_typpompa
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_typpompa_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_typpompa
  IS 'Liste décrivant le type de station de pompage d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_typpompa.code IS 'Code interne de la liste énumérée relative au type de station de station de pompage d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_typpompa.valeur IS 'Valeur de la liste énumérée relative au type de station de pompage d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_typpompa.definition IS 'Définition de la liste énumérée relative au type de station de pompage d''Assainissement collectif';

INSERT INTO m_raepa.lt_raepal_typpompa(code,
            valeur, definition)
    VALUES
('00','Indéterminée','Type de station de pompage inconnu'),
('01','Poste de refoulement','Station de pompage de type Poste de refoulement'),
('02','Poste de relèvement','Station de pompage de type Poste de Relèvement'),
('03','Poste aspiration','Station de pompage de type Poste Aspiration'),
('04','Centrale sous vide','Station de pompage de type Centrale sous vide'),
('99','Autre','Type de de station de pompage ne figurant pas dans la liste ci-dessus');


--#################   charge   ###################

-- Table: m_raepa.lt_raepal_charge

-- DROP TABLE m_raepa.lt_raepal_charge;


CREATE TABLE m_raepa.lt_raepal_charge
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_charge_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_charge
  IS 'Liste décrivant la capacité de charge de la STEP d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_charge.code IS 'Code interne de la liste énumérée relative à la capacité de charge de la STEP d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_charge.valeur IS 'Valeur de la liste énumérée relative à la capacité de charge de la STEP d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_charge.definition IS 'Définition de la liste énumérée relative à la capacité de charge de la STEP d''Assainissement collectif';

INSERT INTO m_raepa.lt_raepal_charge(code,
            valeur, definition)
    VALUES
('00','Indéterminée','Charge inconnu'),
('01','Faible charge','STEP à faible charge'),
('02','Moyenne charge','STEP à moyenne charge'),
('03','Forte charge','STEP à forte charge'),
('99','Autre','Charge de la STEP autre que les valeurs présentées dans la liste ci-dessus');


--#################   typstep   ###################

-- Table: m_raepa.lt_raepal_typstep

-- DROP TABLE m_raepa.lt_raepal_typstep;


CREATE TABLE m_raepa.lt_raepal_typstep
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_typstep_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_typstep
  IS 'Liste décrivant la nature du traitement de la STEP d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_typstep.code IS 'Code interne de la liste énumérée relative à la nature du traitement de la STEP d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_typstep.valeur IS 'Valeur de la liste énumérée relative à la nature du traitement de la STEP d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_typstep.definition IS 'Définition de la liste énumérée relative à la nature du traitement de la STEP d''Assainissement collectif';

INSERT INTO m_raepa.lt_raepal_typstep(code,
            valeur, definition)
    VALUES
('00','Indéterminée','Type de traitement inconnu'),
('01','Lits bactériens','Traitement sur lits bactériens'),
('02','Filtres biologiques','Traitement sur Filtres biologiques'),
('03','Disques biologiques','Traitement sur Disques biologiques'),
('04','Filtres à sable','Traitement sur Filtres à sable'),
('05','Filtres plantés','Traitement sur Filtres plantés'),
('06','Lagunage naturel','Traitement sur Lagunage naturel'),
('07','Boues activées','Traitement sur Boues activées'),
('08','SBR','Traitement biologique séquentiel'),
('99','Autre','Nature du traitement ne figurant pas dans la liste ci-dessus');



--#################   typbass   ###################

-- Table: m_raepa.lt_raepal_typbass

-- DROP TABLE m_raepa.lt_raepal_typbass;


CREATE TABLE m_raepa.lt_raepal_typbass
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_typbass_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_typbass
  IS 'Liste décrivant le type de Bassin de Stockage d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_typbass.code IS 'Code interne de la liste énumérée relative au type de Bassin de Sockage d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_typbass.valeur IS 'Valeur de la liste énumérée relative au type de Bassin de Sockage d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_typbass.definition IS 'Définition de la liste énumérée relative au type de Bassin de Sockage d''Assainissement collectif';

INSERT INTO m_raepa.lt_raepal_typbass(code,
            valeur, definition)
    VALUES
('00','Indéterminée','Type de bassin de stockage inconnu'),
('01','Bassin tampon','Bassin tampon'),
('02','Bassin d''orage','Bassin d''orage'),
('03','Bassin de rétention','Bassin de rétention'),
('04','Déssableur','Déssableur'),
('99','Autre','Type de bassin de stockage ne figurant pas dans la liste ci-dessus');



--#################   formreg   ###################

-- Table: m_raepa.lt_raepal_formreg

-- DROP TABLE m_raepa.lt_raepal_formreg;


CREATE TABLE m_raepa.lt_raepal_formreg
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_formreg_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_formreg
  IS 'Liste décrivant la forme du regard d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_formreg.code IS 'Code interne de la liste énumérée relative à la forme du regard d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_formreg.valeur IS 'Valeur de la liste énumérée relative à la forme du regard d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_formreg.definition IS 'Définition de la liste énumérée relative à la forme du regard d''Assainissement collectif';

INSERT INTO m_raepa.lt_raepal_formreg(code,
            valeur, definition)
    VALUES
('00','Indéterminée','Forme du regard inconnu'),
('01','Carré','Regard de forme carré'),
('02','Rond','Regard de forme ronde'),
('99','Autre','Autre forme de regard ne figurant pas dans la liste ci-dessus');

--#################   typreg   ###################

-- Table: m_raepa.lt_raepal_typreg

-- DROP TABLE m_raepa.lt_raepal_typreg;


CREATE TABLE m_raepa.lt_raepal_typreg
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_typreg_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_typreg
  IS 'Liste décrivant le type de regard d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_typreg.code IS 'Code interne de la liste énumérée relative au type de regard d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_typreg.valeur IS 'Valeur de la liste énumérée relative au type de regard d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_typreg.definition IS 'Définition de la liste énumérée relative au type de regard d''Assainissement collectif';

INSERT INTO m_raepa.lt_raepal_typreg(code,
            valeur, definition)
    VALUES
('00','Indéterminée','Type de regard inconnu'),
('01','Visite','Regard de visite'),
('02','Bâche','Regard bâche'),
('03','Boîte de branchement','Regard de boîte de branchement'),
('99','Autre','Type de regard ne figurant pas dans la liste ci-dessus');

--#################   typaval   ###################

-- Table: m_raepa.lt_raepal_typaval

-- DROP TABLE m_raepa.lt_raepal_typaval;


CREATE TABLE m_raepa.lt_raepal_typaval
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_typaval_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_typaval
  IS 'Liste décrivant le type d''Avaloir d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_typaval.code IS 'Code interne de la liste énumérée relative au type d''avaloir d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_typaval.valeur IS 'Valeur de la liste énumérée relative au type d''avaloir d''Assainissement collectif';
COMMENT ON COLUMN m_raepa.lt_raepal_typaval.definition IS 'Définition de la liste énumérée relative au type d''avaloir d''Assainissement collectif';

INSERT INTO m_raepa.lt_raepal_typaval(code,
            valeur, definition)
    VALUES
('00','Indéterminée','Type de regard inconnu'),
('01','Avaloir simple','Avaloir simple'),
('02','Avaloir à grille','Avaloir à grille'),
('03','Grille avaloir','Grille avaloir'),
('04','Avaloir tampon','Avaloir tampon'),
('99','Autre','Type d''avaloir ne figurant pas dans la liste ci-dessus');



--#################   typpompe   ###################

-- Table: m_raepa.lt_raepal_typpompe

-- DROP TABLE m_raepa.lt_raepal_typpompe;


CREATE TABLE m_raepa.lt_raepal_typpompe
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_typpompe_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_typpompe
  IS 'Liste décrivant le type de station de pompage d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typpompe.code IS 'Code interne de la liste énumérée relative au type de station de pompage d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typpompe.valeur IS 'Valeur de la liste énumérée relative au type de station de pompage d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typpompe.definition IS 'Définition de la liste énumérée relative au type de station de pompage d''Adduction d''eau potable';

INSERT INTO m_raepa.lt_raepal_typpompe(code,
            valeur, definition)
    VALUES
('00','Indéterminée','Type de pompe inconnu'),
('01','Supression','Station de pompage de type surpression'),
('02','Reprise','Station de pompage de type reprise'),
('03','Accélérateur','Station de pompage de type accélérateur'),
('99','Autre','Type de station de pompage ne figurant pas dans la liste ci-dessus');


--#################   typtrait   ###################

-- Table: m_raepa.lt_raepal_typtrait

-- DROP TABLE m_raepa.lt_raepal_typtrait;


CREATE TABLE m_raepa.lt_raepal_typtrait
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_typtrait_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_typtrait
  IS 'Liste décrivant le type de traitement de la station d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typtrait.code IS 'Code interne de la liste énumérée relative au type de traitement de la station d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typtrait.valeur IS 'Valeur de la liste énumérée relative au type de traitement de la station d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typtrait.definition IS 'Définition de la liste énumérée relative au type de traitement de la station d''Adduction d''eau potable';

INSERT INTO m_raepa.lt_raepal_typtrait(code,
            valeur, definition)
    VALUES
('00','Indéterminée','Type de traitement inconnu'),
('01','Javel liquide','Traitement à la javel liquide'),
('02','Chlore gazeux','Traitement au chlore gazeux'),
('03','Charbon actif','Traitement au charbon actif'),
('04','Fer','Traitement au fer'),
('99','Autre','Traitement ne figurant pas dans la liste ci-dessus');



--#################   typres   ###################

-- Table: m_raepa.lt_raepal_typres

-- DROP TABLE m_raepa.lt_raepal_typres;


CREATE TABLE m_raepa.lt_raepal_typres
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_typres_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_typres
  IS 'Liste décrivant le type de réservoir d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typres.code IS 'Code interne de la liste énumérée relative au type de réservoir d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typres.valeur IS 'Valeur de la liste énumérée relative au type de réservoir d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typres.definition IS 'Définition de la liste énumérée relative au type de réservoir d''Adduction d''eau potable';

INSERT INTO m_raepa.lt_raepal_typres(code,
            valeur, definition)
    VALUES
('00','Indéterminée','Type de réservoir inconnu'),
('01','Semi entérré','Réservoir semi entérré'),
('02','Bâche','Réservoir sur bâche'),
('03','Sur tour','Réservoir sur tour'),
('99','Autre','Type de réservoir ne figurant pas dans la liste ci-dessus');

--#################   typcapt   ###################

-- Table: m_raepa.lt_raepal_typcapt

-- DROP TABLE m_raepa.lt_raepal_typcapt;


CREATE TABLE m_raepa.lt_raepal_typcapt
(
  code character varying(2) NOT NULL, -- code de la liste
  valeur character varying(80) NOT NULL, -- valeur de la liste
  definition character varying(255), --définition
  CONSTRAINT m_reseau_typcapt_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.lt_raepal_typcapt
  IS 'Liste décrivant le type de captage d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typcapt.code IS 'Code interne de la liste énumérée relative au type de captage d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typcapt.valeur IS 'Valeur de la liste énumérée relative au type de captage d''Adduction d''eau potable';
COMMENT ON COLUMN m_raepa.lt_raepal_typcapt.definition IS 'Définition de la liste énumérée relative au type de captage d''Adduction d''eau potable';

INSERT INTO m_raepa.lt_raepal_typcapt(code,
            valeur, definition)
    VALUES
('00','Indéterminée','Type de réservoir inconnu'),
('01','Source','Captage source'),
('02','Puit, Forage','Captage de puit, forage'),
('99','Autre','Type de captage ne figurant pas dans la liste ci-dessus');


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                           EXTENSIONS SEQUENCES                                                               ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################
-- Sequence: m_raepa.raepa_id_noeud_seq

-- DROP SEQUENCE m_raepa.raepa_id_noeud_seq;

CREATE SEQUENCE m_raepa.raepa_id_noeud_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

-- Sequence: m_raepa.raepa_id_tronc_seq

-- DROP SEQUENCE m_raepa.raepa_id_tronc_seq;

CREATE SEQUENCE m_raepa.raepa_id_tronc_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                    EXTENSION CLASSES ET ATTRIBUTS                                            ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- ##########################################################################################################
-- ############ Suppression attributs raepa qui sont déplacés dans d'autres classes ou supprimés ############
-- ##########################################################################################################

ALTER TABLE m_raepa.an_raepa_canal DROP COLUMN materiau; -- déplacé vers an_raepal_objet_reseau
ALTER TABLE m_raepa.an_raepa_canal DROP COLUMN enservice; -- déplacé vers an_raepal_objet_reseau
ALTER TABLE m_raepa.an_raepa_canal DROP COLUMN andebpose; -- déplacé vers an_raepal_objet_reseau
ALTER TABLE m_raepa.an_raepa_canal DROP COLUMN anfinpose; -- déplacé vers an_raepal_objet_reseau
ALTER TABLE m_raepa.an_raepa_canal DROP COLUMN mouvrage; -- déplacé vers an_raepal_objet_reseau
ALTER TABLE m_raepa.an_raepa_canal DROP COLUMN gexploit; -- déplacé vers an_raepal_objet_reseau
ALTER TABLE m_raepa.an_raepa_canal DROP COLUMN longcana; -- déplacé vers geo_raepal_tronc
ALTER TABLE m_raepa.an_raepa_canal DROP COLUMN geom; -- déplacé vers geo_raepal_tronc
ALTER TABLE m_raepa.an_raepa_canal DROP COLUMN idcanppale; -- Attribut qui n'est pas conservé car aucune information n'y sera jamais renseignée. Pas cohérent d'avoir ce genre d'information (on parle d'un réseau principal, avec plusieurs objets de canalisation, donc pas pertinent, qui va avoir la joie de figurer en tant que canalisation principal ?)
ALTER TABLE m_raepa.an_raepa_canal DROP COLUMN idnini; -- déplacé vers geo_raepal_tronc
ALTER TABLE m_raepa.an_raepa_canal DROP COLUMN idnterm; -- déplacé vers geo_raepal_tronc

ALTER TABLE m_raepa.geo_raepa_noeud DROP COLUMN idcanppale; -- Information non adaptée. Dans cas piquage sur une modélisation topologique, qui va être le principal ? Arc de gauche ou droite ?
ALTER TABLE m_raepa.geo_raepa_noeud DROP COLUMN idcanamont; -- Information non adaptée.
ALTER TABLE m_raepa.geo_raepa_noeud DROP COLUMN idcanaval; -- Information non adaptée.
ALTER TABLE m_raepa.geo_raepa_noeud DROP COLUMN mouvrage; -- déplacé vers an_raepal_objet_reseau
ALTER TABLE m_raepa.geo_raepa_noeud DROP COLUMN gexploit; -- déplacé vers an_raepal_objet_reseau
ALTER TABLE m_raepa.geo_raepa_noeud DROP COLUMN andebpose; -- déplacé vers an_raepal_objet_reseau
ALTER TABLE m_raepa.geo_raepa_noeud DROP COLUMN anfinpose; -- déplacé vers an_raepal_objet_reseau

ALTER TABLE m_raepa.an_raepa_canalass DROP COLUMN sensecoul; -- déplacé vers an_raepa_canal
ALTER TABLE m_raepa.an_raepa_canalass DROP COLUMN zamont; -- déplacé vers an_raepa_canal
ALTER TABLE m_raepa.an_raepa_canalass DROP COLUMN zaval; -- déplacé vers an_raepa_canal

ALTER TABLE m_raepa.an_raepa_canalae DROP COLUMN distgen; -- déplacé vers an_raepa_canal


-- ####################################################################################
-- ############ Ajout des informations étendues sur les classes existantes ############
-- ####################################################################################

-- ### an_raepal_objet_reseau ###

ALTER TABLE m_raepa.an_raepal_objet_reseau
	ADD COLUMN idobjet bigint PRIMARY KEY, -- Identifiant unique de l'objet du réseau. (pkey)
	ADD COLUMN enservice character varying (1), -- Objet en service ou non. Issu du RAEPA déplacé pour tout objets de réseau
	ADD COLUMN materiau character varying (5) NOT NULL DEFAULT '00', -- Matériau de l'objet de réseau. Issu du RAEPA déplacé pour tout objets de réseau
	ADD COLUMN mouvrage character varying (100), -- Maître d'ouvrage du réseau. Issu du RAEPA déplacé pour tout objets de réseau
	ADD COLUMN gexploit character varying (100), -- Gestionnaire exploitant du réseau. Issu du RAEPA déplacé pour tout objets de réseau
	ADD COLUMN andebpose character varying (4), -- Année marquant le début de pose de l'objet de réseau. Issu du RAEPA déplacé pour tout objets de réseau
	ADD COLUMN anfinpose character varying (4), -- Année marquant la fin de pose de l'objet de réseau. Issu du RAEPA déplacé pour tout objets de réseau
	ADD COLUMN l_insee character varying (5), -- Code insee de localisation de l'objet
	ADD COLUMN l_positver character varying (2) NOT NULL DEFAULT '00', -- Position verticale de l'objet (lt)
	ADD COLUMN l_entrpose character varying (100), -- Entreprise ayant réalisée la pose
	ADD COLUMN l_marque character varying (100), -- Marque commerciale de l'objet
	ADD COLUMN l_modele character varying (100), -- Modèle commercial de l'objet
	ADD COLUMN l_etat character varying (2) NOT NULL DEFAULT '00', -- Etat de l'objet (lt)
	ADD COLUMN l_criticit character varying (1), -- Objet en criticite ou non
	ADD COLUMN l_domaine character varying (2) NOT NULL DEFAULT '00', -- Domaine auquel appartient l'objet du réseau. Généré lors de l'intégration FME (lt)
	--ADD COLUMN l_idu character varying (12), -- Numéro de parcelle cadastrale.
	ADD COLUMN l_libvoie character varying (254), -- Adressage du nom de la rue où est positionné l'objet. Généré lors de l'intégration FME
	ADD COLUMN l_reseau character varying (7) NOT NULL, -- Définit le type de réseau de l'objet selon la convention DT-DICT. Généré lors de l'intégration FME
	ADD COLUMN l_typeobjet character varying (20) NOT NULL, -- Type d'objet de réseau. Généré lors de l'intégration FME
	ADD COLUMN l_idsandre character varying (254), -- Code SANDRE
	ADD COLUMN l_observ character varying (500), -- Compléments d'informations, observations.
	ADD COLUMN l_datext timestamp without time zone; -- Date extraction de la donnée chez le producteur.
	
ALTER TABLE m_raepa.an_raepal_objet_reseau
    ALTER COLUMN idprod SET NOT NULL;
	
COMMENT ON COLUMN m_raepa.an_raepal_objet_reseau.idobjet IS 'Identifiant unique de l''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_objet_reseau.enservice IS 'Objet en service ou non (abandonné).';
COMMENT ON COLUMN m_raepa.an_raepal_objet_reseau.materiau IS 'Matériau constitutif de l''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_objet_reseau.mouvrage IS 'Maître d''ouvrage du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_objet_reseau.gexploit IS 'Gestionnaire exploitant du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_objet_reseau.andebpose IS 'Année marquant le début de pose de l''objet de réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_objet_reseau.anfinpose IS 'Année marquant la fin de pose de l''objet de réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_objet_reseau.l_insee IS 'Code INSEE de la commune de localisation de l''objet du réseau';
COMMENT ON COLUMN m_raepa.an_raepal_objet_reseau.l_positver IS 'Position verticale de l''objet de réseau';
COMMENT ON COLUMN m_raepa.an_raepal_objet_reseau.l_entrpose IS 'Entreprise ayant réalisée la pose de l''objet de réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_objet_reseau.l_marque IS 'Marque commerciale de l''objet';
COMMENT ON COLUMN m_raepa.an_raepal_objet_reseau.l_modele IS 'Modèle de l''objet';
COMMENT ON COLUMN m_raepa.an_raepal_objet_reseau.l_etat IS 'Etat de l''objet.';
COMMENT ON COLUMN m_raepa.an_raepal_objet_reseau.l_criticit IS 'Objet en criticité ou non.';
COMMENT ON COLUMN m_raepa.an_raepal_objet_reseau.l_domaine IS 'Domaine auquel appartient l''objet du réseau.';
--COMMENT ON COLUMN m_raepa.an_raepal_objet_reseau.l_idu IS 'Identifiant unique de la parcelle';
COMMENT ON COLUMN m_raepa.an_raepal_objet_reseau.l_libvoie IS 'Adressage du nom de la rue où est positionné l''objet.';
COMMENT ON COLUMN m_raepa.an_raepal_objet_reseau.l_reseau IS 'Définit le type de réseau de l''objet selon la convention DT-DICT.';
COMMENT ON COLUMN m_raepa.an_raepal_objet_reseau.l_typeobjet IS 'Définit le type d''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_objet_reseau.l_idsandre IS 'Code SANDRE.';
COMMENT ON COLUMN m_raepa.an_raepal_objet_reseau.l_observ IS 'Compléments d''informations, observations.';
COMMENT ON COLUMN m_raepa.an_raepal_objet_reseau.l_datext IS 'Date extraction de la donnée chez le producteur.';

	
ALTER TABLE m_raepa.an_raepal_objet_reseau ALTER COLUMN idobjet SET DEFAULT nextval('m_raepa.raepa_id_obj_reseau_seq'::regclass);
ALTER TABLE m_raepa.an_raepal_objet_reseau ALTER COLUMN datemaj TYPE timestamp without time zone;	
ALTER TABLE m_raepa.an_raepal_objet_reseau ALTER COLUMN dategeoloc TYPE timestamp without time zone;		

	
-- ### an_raepa_noeud ###
	
ALTER TABLE m_raepa.geo_raepa_noeud
	ADD COLUMN l_xreel Decimal (10,3), --  	Coordonnée X réelle Lambert 93 (en mètres)
	ADD COLUMN l_yreel Decimal (10,3); -- Coordonnée Y réelle Lambert 93 (en mètres)
		
COMMENT ON COLUMN m_raepa.geo_raepa_noeud.l_xreel IS 'Coordonnée X réelle Lambert 93 (en mètres)';
COMMENT ON COLUMN m_raepa.geo_raepa_noeud.l_yreel IS 'Coordonnée Y réelle Lambert 93 (en mètres)';

ALTER TABLE m_raepa.geo_raepa_noeud ALTER COLUMN idnoeud TYPE bigint USING idnoeud::bigint;	
ALTER TABLE m_raepa.geo_raepa_noeud ALTER COLUMN idnoeud SET DEFAULT nextval('m_raepa.raepa_id_noeud_seq'::regclass);

	
-- ### an_raepa_canal ###
	
ALTER TABLE m_raepa.an_raepa_canal
	ADD COLUMN idobjet bigint PRIMARY KEY, -- Identifiant unique de l'objet du réseau. (pkey)
	ADD COLUMN l_formcana character varying (2), -- Forme (Section) de la canalisation. (lt)
	ADD COLUMN l_dim character varying (20), -- Dimensions de la canalisation lorsque forme non circulaire, en mètres (longueur x largeur).
	ADD COLUMN l_protext character varying (2) NOT NULL DEFAULT '00', -- Protection extérieur potentiellement associé à la canalisation (lt)
	ADD COLUMN l_protint character varying (2) NOT NULL DEFAULT '00', -- Type de protection interne de la canalisation. (lt)
	ADD COLUMN l_ztn decimal (6,3), -- Côte du terrain naturel en mètre (Référentiel NGF IGN69).
	ADD COLUMN l_zgen decimal (6,3), -- Côte de la génératrice supérieure en mètre (ou inférieure dans le cas de canalisations aériennes) (Référentiel NGF IGN69).
	ADD COLUMN zamont decimal (6,3), -- Altitude fil eau à l'extrémité amont (en mètres, Référentiel NGFIGN69). Issu du RAEPA déplacé
	ADD COLUMN zaval decimal (6,3),--Altitude fil eau à l'extrémité aval (en mètres, Référentiel NGF-IGN69). Issu du RAEPA déplacé
	ADD COLUMN l_pente decimal (3,1),--Pente, exprimée en %.
	ADD COLUMN l_penter decimal (3,1),-- Contre pente, exprimée en %.
	ADD COLUMN distgen decimal (6,3),-- Distance moyenne de la génératrice de la canalisation, en mètre.
	ADD COLUMN l_autpass character varying (1) NOT NULL DEFAULT '0',-- Définit s'il y a une autorisation de passage de la canalisation (lt)
	ADD COLUMN idtronc bigint;-- Identifiant unique du tronçon d'un réseau.
ALTER TABLE m_raepa.an_raepa_canal
    ALTER COLUMN idprod SET NOT NULL;
	
COMMENT ON COLUMN m_raepa.an_raepa_canal.idobjet IS 'Identifiant unique de l''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepa_canal.l_formcana IS 'Forme (Section) de la canalisation.';
COMMENT ON COLUMN m_raepa.an_raepa_canal.l_dim IS 'Dimensions de la canalisation lorsque forme non circulaire, en mètres (longueur x largeur).';
COMMENT ON COLUMN m_raepa.an_raepa_canal.l_protext IS 'Protection extérieur potentiellement associé à la canalisation';
COMMENT ON COLUMN m_raepa.an_raepa_canal.l_protint IS 'Type de protection interne de la canalisation.';
COMMENT ON COLUMN m_raepa.an_raepa_canal.l_ztn IS 'Côte du terrain naturel en mètre (Référentiel NGF IGN69).';
COMMENT ON COLUMN m_raepa.an_raepa_canal.l_zgen IS 'Côte de la génératrice supérieure en mètre (ou inférieure dans le cas de canalisations aériennes) (Référentiel NGF IGN69).';
COMMENT ON COLUMN m_raepa.an_raepa_canal.zamont IS 'Altitude fil eau à l''extrémité amont (en mètres, Référentiel NGFIGN69).';
COMMENT ON COLUMN m_raepa.an_raepa_canal.zaval IS 'Altitude fil eau à l''extrémité aval (en mètres, Référentiel NGF-IGN69).';
COMMENT ON COLUMN m_raepa.an_raepa_canal.l_pente IS 'Pente, exprimée en %.';
COMMENT ON COLUMN m_raepa.an_raepa_canal.l_penter IS 'Contre pente, exprimée en %.';
COMMENT ON COLUMN m_raepa.an_raepa_canal.distgen IS 'Distance moyenne de la génératrice de la canalisation';
COMMENT ON COLUMN m_raepa.an_raepa_canal.l_autpass IS 'Définit s''il y a une autorisation de passage de la canalisation';
COMMENT ON COLUMN m_raepa.an_raepa_canal.idtronc IS 'Identifiant unique du tronçon d''un réseau.';

	
-- ### an_raepa_ouv ###
ALTER TABLE m_raepa.an_raepa_ouv
	ADD COLUMN idobjet bigint PRIMARY KEY, -- Identifiant unique de l'objet du réseau. (pkey)
	ADD COLUMN l_nom character varying (254), -- Nom de l'ouvrage.
	ADD COLUMN l_typimpl character varying (2) NOT NULL DEFAULT '00', -- Type d'implantation de l'ouvrage.
	ADD COLUMN l_ztn decimal (6,3), -- Côte du terrain naturel en mètre (Référentiel NGF IGN69).
	ADD COLUMN l_profond decimal (6,3), -- Profondeur de l'ouvrage
	ADD COLUMN l_acces character varying (1) NOT NULL DEFAULT '0', -- Ouvrage accessible (Oui/Non) (lt)
	ADD COLUMN l_nbapp integer, -- Nombre d'appareils positionnés sur l'ouvrage. Généré automatiquement lors de l'intégration des données.
	ADD COLUMN idnoeud bigint; -- Identifiant unique du noeud de réseau.
ALTER TABLE m_raepa.an_raepa_ouv
    ALTER COLUMN idprod SET NOT NULL;
	
COMMENT ON COLUMN m_raepa.an_raepa_ouv.idobjet IS 'Identifiant unique de l''objet du réseau. (pkey)';
COMMENT ON COLUMN m_raepa.an_raepa_ouv.l_nom IS 'Nom de l''ouvrage.';
COMMENT ON COLUMN m_raepa.an_raepa_ouv.l_typimpl IS 'Type d''implantation de l''ouvrage.';
COMMENT ON COLUMN m_raepa.an_raepa_ouv.l_ztn IS 'Côte du terrain naturel en mètre (Référentiel NGF IGN69).';
COMMENT ON COLUMN m_raepa.an_raepa_ouv.l_profond IS 'Profondeur de l''ouvrage';
COMMENT ON COLUMN m_raepa.an_raepa_ouv.l_acces IS 'Ouvrage accessible (Oui/Non)';
COMMENT ON COLUMN m_raepa.an_raepa_ouv.l_nbapp IS 'Nombre d''appareils positionnés sur l''ouvrage. Généré automatiquement lors de l''intégration des données';
COMMENT ON COLUMN m_raepa.an_raepa_ouv.idnoeud IS 'Identifiant unique du noeud de réseau.';

	
-- ### an_raepa_app ###
ALTER TABLE m_raepa.an_raepa_app
	ADD COLUMN idobjet bigint PRIMARY KEY, -- Identifiant unique de l'objet du réseau. (pkey)
	ADD COLUMN l_typimpl character varying (2) NOT NULL DEFAULT '0', -- Type implantation de l'appareillage (lt)
	ADD COLUMN l_acces character varying (1) NOT NULL DEFAULT '0', -- Ouvrage accessible (Oui/Non) (lt)
	ADD COLUMN idnoeud bigint; -- Identifiant unique du noeud de réseau.
	
ALTER TABLE m_raepa.an_raepa_app  ALTER COLUMN idprod SET NOT NULL;

ALTER TABLE m_raepa.an_raepa_app ALTER COLUMN idouvrage TYPE bigint USING idnoeud::bigint;	
    
COMMENT ON COLUMN m_raepa.an_raepa_app.idobjet IS 'Identifiant unique de l''objet du réseau. (pkey)';
COMMENT ON COLUMN m_raepa.an_raepa_app.l_typimpl IS 'Type implantation de l''appareillage';
COMMENT ON COLUMN m_raepa.an_raepa_app.l_acces IS 'Ouvrage accessible (Oui/Non)';
COMMENT ON COLUMN m_raepa.an_raepa_app.idnoeud IS 'Identifiant unique du noeud de réseau.';	
	
-- ### an_raepa_canalass ###
ALTER TABLE m_raepa.an_raepa_canalass
	ADD COLUMN idobjet bigint PRIMARY KEY; -- Identifiant unique de l'objet du réseau. (pkey)	
ALTER TABLE m_raepa.an_raepa_canalass
    ALTER COLUMN idprod SET NOT NULL;
    
COMMENT ON COLUMN m_raepa.an_raepa_canalass.idobjet IS 'Identifiant unique de l''objet du réseau. (pkey)';

-- ### an_raepa_canalae ###
ALTER TABLE m_raepa.an_raepa_canalae
	ADD COLUMN idobjet bigint PRIMARY KEY, -- Identifiant unique de l'objet du réseau. (pkey)	
	ADD COLUMN l_pression decimal (6,3), -- Pression moyenne dans la canalisation, en bars.
	ADD COLUMN l_protcath character varying (1) NOT NULL DEFAULT '0', -- Existence d'une protection cathodique. (lt)
	ADD COLUMN l_indperte decimal (6,2); -- Indice linéaire de perte, en m3/km/j
ALTER TABLE m_raepa.an_raepa_canalae
    ALTER COLUMN idprod SET NOT NULL;

ALTER TABLE m_raepa.an_raepa_canalae ALTER COLUMN contcanaep TYPE character varying (5);	

	
COMMENT ON COLUMN m_raepa.an_raepa_canalae.idobjet IS 'Identifiant unique de l''objet du réseau. (pkey)';
COMMENT ON COLUMN m_raepa.an_raepa_canalae.l_pression IS 'Pression moyenne dans la canalisation, en bars.';
COMMENT ON COLUMN m_raepa.an_raepa_canalae.l_protcath IS 'Existence d''une protection cathodique.';
COMMENT ON COLUMN m_raepa.an_raepa_canalae.l_indperte IS 'Indice linéaire de perte, en m3/km/j';

-- ### an_raepa_ouvass ###
ALTER TABLE m_raepa.an_raepa_ouvass
	ADD COLUMN idobjet bigint PRIMARY KEY; -- Identifiant unique de l'objet du réseau. (pkey)
ALTER TABLE m_raepa.an_raepa_ouvass
    ALTER COLUMN idprod SET NOT NULL;
    
COMMENT ON COLUMN m_raepa.an_raepa_ouvass.idobjet IS 'Identifiant unique de l''objet du réseau. (pkey)';
ALTER TABLE m_raepa.an_raepa_ouvass ALTER COLUMN fnouvass TYPE character varying (5);	

-- ### an_raepa_ouvae ###
ALTER TABLE m_raepa.an_raepa_ouvae
	ADD COLUMN idobjet bigint PRIMARY KEY; -- Identifiant unique de l'objet du réseau. (pkey)
ALTER TABLE m_raepa.an_raepa_ouvae
    ALTER COLUMN idprod SET NOT NULL;
    
COMMENT ON COLUMN m_raepa.an_raepa_ouvae.idobjet IS 'Identifiant unique de l''objet du réseau. (pkey)';
ALTER TABLE m_raepa.an_raepa_ouvae ALTER COLUMN fnouvaep TYPE character varying (5);	

-- ### an_raepa_appass ###
ALTER TABLE m_raepa.an_raepa_appass
	ADD COLUMN idobjet bigint PRIMARY KEY; -- Identifiant unique de l'objet du réseau. (pkey)
ALTER TABLE m_raepa.an_raepa_appass
    ALTER COLUMN idprod SET NOT NULL;
    
COMMENT ON COLUMN m_raepa.an_raepa_appass.idobjet IS 'Identifiant unique de l''objet du réseau. (pkey)';

ALTER TABLE m_raepa.an_raepa_appass ALTER COLUMN fnappass TYPE character varying (5);	

-- ### an_raepa_appae ###
ALTER TABLE m_raepa.an_raepa_appae
	ADD COLUMN idobjet bigint PRIMARY KEY, -- Identifiant unique de l'objet du réseau. (pkey)
	ADD COLUMN l_debit decimal (5,2); -- Débit nominal de l'appareillage d'eau potable en m3/h.
ALTER TABLE m_raepa.an_raepa_appae
    ALTER COLUMN idprod SET NOT NULL;
    
COMMENT ON COLUMN m_raepa.an_raepa_appae.idobjet IS 'Identifiant unique de l''objet du réseau. (pkey)';
COMMENT ON COLUMN m_raepa.an_raepa_appae.l_debit IS 'Débit nominal de l''appareillage d''eau potable en m3/h.';
ALTER TABLE m_raepa.an_raepa_appae ALTER COLUMN fnappaep TYPE character varying (5);

-- ##########################################################################################	
-- ############ Création des nouvelles classes d'extension et de leurs attributs ############
-- ##########################################################################################

-- ### geo_raepal_tronc ###
CREATE TABLE m_raepa.geo_raepal_tronc
(
  idtronc bigint, -- Identifiant unique du tronçon du réseau
  sensecoul character varying (1) NOT NULL DEFAULT '0', -- Sens de l'écoulement dans la canalisation
  longmes integer, -- longueur mesurée du troncon, en m
  l_longcalc integer NOT NULL, -- longueur calculée du troncon, en m
  idnini bigint,-- NOT NULL, -- Identifiant du noeud initial du tronçon (fkey) 
  idnterm bigint,-- NOT NULL, -- Identifiant du noeud terminal du tronçon (fkey)
  geom geometry(LineString,2154) NOT NULL, -- geom Attribut portant la géométrie de l'objet linéaire, RGF93

  CONSTRAINT m_reseau_idtronc_pkey PRIMARY KEY (idtronc)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.geo_raepal_tronc
  IS 'Tronçon de réseau';
COMMENT ON COLUMN m_raepa.geo_raepal_tronc.idtronc IS 'Identifiant unique du tronçon du réseau';
COMMENT ON COLUMN m_raepa.geo_raepal_tronc.sensecoul IS 'Sens de l''écoulement dans la canalisation';
COMMENT ON COLUMN m_raepa.geo_raepal_tronc.l_longcalc IS 'longueur calculée du troncon, en mètre.';
COMMENT ON COLUMN m_raepa.geo_raepal_tronc.longmes IS 'longueur mesurée du troncon, en mètre.';
COMMENT ON COLUMN m_raepa.geo_raepal_tronc.idnini IS 'Identifiant du noeud initial du tronçon (fkey)';
COMMENT ON COLUMN m_raepa.geo_raepal_tronc.idnterm IS 'Identifiant du noeud terminal du tronçon (fkey)';
COMMENT ON COLUMN m_raepa.geo_raepal_tronc.geom IS 'Attribut portant la géométrie de l''objet linéaire, RGF93';

ALTER TABLE m_raepa.geo_raepal_tronc ALTER COLUMN idtronc SET DEFAULT nextval('m_raepa.raepa_id_tronc_seq'::regclass);


-- ### an_raepal_brcht_ass ###
CREATE TABLE m_raepa.an_raepal_brcht_ass
(
  idobjet bigint, -- Identifiant unique de l'objet du réseau.
  idprod character varying (254) NOT NULL, -- Identifiant du producteur de l'objet
  l_typracc character varying (2) NOT NULL DEFAULT '00', -- Type de raccord de branchement (lt)
  l_conform character varying (1) NOT NULL DEFAULT '0', -- Définit si le branchement d'Assainissement collectif est conforme. (lt)
  CONSTRAINT m_reseau_brcht_ass_pkey PRIMARY KEY (idobjet)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.an_raepal_brcht_ass
  IS 'Classe alphanumérique portant les informations génériques d''une canalisation de branchement de réseau d''Assainissement collectif.';
COMMENT ON COLUMN m_raepa.an_raepal_brcht_ass.idobjet IS 'Identifiant unique de l''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_brcht_ass.idprod IS 'Identifiant du producteur de l''objet';
COMMENT ON COLUMN m_raepa.an_raepal_brcht_ass.l_typracc IS 'Type de raccord de branchement';
COMMENT ON COLUMN m_raepa.an_raepal_brcht_ass.l_conform IS 'Définit si le branchement d''Assainissement collectif est conforme.';

-- ### an_raepal_deb_ae ###

CREATE TABLE m_raepa.an_raepal_deb_ae
(
  idobjet bigint, -- Identifiant unique de l'objet du réseau.
  idprod character varying (254) NOT NULL, -- Identifiant du producteur de l'objet
  l_positdeb character varying (2) NOT NULL DEFAULT '00', -- Position du débitmètre.
  CONSTRAINT m_reseau_deb_ae_pkey PRIMARY KEY (idobjet)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.an_raepal_deb_ae
  IS 'Classe alphanumérique portant les informations génériques d''un appareillage d''Adduction d''eau potable de type débitmètre.';
COMMENT ON COLUMN m_raepa.an_raepal_deb_ae.idobjet IS 'Identifiant unique de l''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_deb_ae.idprod IS 'Identifiant du producteur de l''objet';
COMMENT ON COLUMN m_raepa.an_raepal_deb_ae.l_positdeb IS 'Position du débitmètre.';

-- ### an_raepal_vidange_ae ###

CREATE TABLE m_raepa.an_raepal_vidange_ae
(
  idobjet bigint, -- Identifiant unique de l'objet du réseau.
  idprod character varying (254) NOT NULL, -- Identifiant du producteur de l'objet
  l_positvid character varying (2) NOT NULL DEFAULT '00', -- Position de l'appareillage de vidange.
  l_typexut character varying (2) NOT NULL DEFAULT '00', -- Type d'éxutoire.
  CONSTRAINT m_reseau_vidange_ae_pkey PRIMARY KEY (idobjet)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.an_raepal_vidange_ae
  IS 'Classe alphanumérique portant les informations génériques d''un appareillage d''Adduction d''eau potable de type vidange.';
COMMENT ON COLUMN m_raepa.an_raepal_vidange_ae.idobjet IS 'Identifiant unique de l''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_vidange_ae.idprod IS 'Identifiant du producteur de l''objet';
COMMENT ON COLUMN m_raepa.an_raepal_vidange_ae.l_positvid IS 'Position de l''appareillage de vidange.';
COMMENT ON COLUMN m_raepa.an_raepal_vidange_ae.l_typexut IS 'Type d''éxutoire.';

-- ### an_raepal_vanne_ae ###
CREATE TABLE m_raepa.an_raepal_vanne_ae
(
  idobjet bigint, -- Identifiant unique de l'objet du réseau.
  idprod character varying (254) NOT NULL, -- Identifiant du producteur de l'objet
  l_typvanne character varying (2) NOT NULL DEFAULT '00', -- Type de Vanne.
  l_positvan character varying (2) NOT NULL DEFAULT '00', -- Position de la vanne.
  l_etatvan character varying (2) NOT NULL DEFAULT '00', -- Etat de la vanne (Ouverte ou Fermée)
  l_prtcharge decimal (5,2), -- Perte de charge, en mètre.
  CONSTRAINT m_reseau_vanne_ae_pkey PRIMARY KEY (idobjet)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.an_raepal_vanne_ae
  IS 'Classe alphanumérique portant les informations génériques d''un appareillage d''Adduction d''eau potable de type vanne.';
COMMENT ON COLUMN m_raepa.an_raepal_vanne_ae.idobjet IS 'Identifiant unique de l''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_vanne_ae.idprod IS 'Identifiant du producteur de l''objet';
COMMENT ON COLUMN m_raepa.an_raepal_vanne_ae.l_typvanne IS 'Type de Vanne.';
COMMENT ON COLUMN m_raepa.an_raepal_vanne_ae.l_positvan IS 'Position de la Vanne.';
COMMENT ON COLUMN m_raepa.an_raepal_vanne_ae.l_etatvan IS 'Etat de la vanne (Ouverte ou Fermée)';
COMMENT ON COLUMN m_raepa.an_raepal_vanne_ae.l_prtcharge IS 'Perte de charge, en mètre.';

-- ### an_raepal_reg_press_ae ###
CREATE TABLE m_raepa.an_raepal_reg_press_ae
(
  idobjet bigint, -- Identifiant unique de l'objet du réseau.
  idprod character varying (254) NOT NULL, -- Identifiant du producteur de l'objet
  l_typregul character varying (2) NOT NULL DEFAULT '00', -- Type de régulateur de pression.
  l_consamt decimal (5,2), -- Consigne Amont en bars.
  l_consavl decimal (5,2), -- Consigne Aval en bars.
  CONSTRAINT m_reseau_reg_press_ae_pkey PRIMARY KEY (idobjet)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.an_raepal_reg_press_ae
  IS 'Classe alphanumérique portant les informations génériques d''un appareillage d''Adduction d''eau potable de type régulateur de pression.';
COMMENT ON COLUMN m_raepa.an_raepal_reg_press_ae.idobjet IS 'Identifiant unique de l''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_reg_press_ae.idprod IS 'Identifiant du producteur de l''objet';
COMMENT ON COLUMN m_raepa.an_raepal_reg_press_ae.l_typregul IS 'Type de régulateur de pression.';
COMMENT ON COLUMN m_raepa.an_raepal_reg_press_ae.l_consamt IS 'Consigne Amont en bars.';
COMMENT ON COLUMN m_raepa.an_raepal_reg_press_ae.l_consavl IS 'Consigne Aval en bars.';


-- ### an_raepal_compt_ae ###
CREATE TABLE m_raepa.an_raepal_compt_ae
(
  idobjet bigint, -- Identifiant unique de l'objet du réseau.
  idprod character varying (254) NOT NULL, -- Identifiant du producteur de l'objet
  l_typcompt character varying (2) NOT NULL DEFAULT '00', --Type de compteur.
  l_foncompt character varying (2) NOT NULL DEFAULT '00', -- Fonction du compteur
  l_diametre integer, -- Diamètre nominal du compteur, en millimètres
  l_anetal character varying (4), -- Année étalonnage compteur 
  CONSTRAINT m_reseau_compt_ae_pkey PRIMARY KEY (idobjet)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.an_raepal_compt_ae
  IS 'Classe alphanumérique portant les informations génériques d''un appareillage d''Adduction d''eau potable de compteur.';
COMMENT ON COLUMN m_raepa.an_raepal_compt_ae.idobjet IS 'Identifiant unique de l''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_compt_ae.idprod IS 'Identifiant du producteur de l''objet';
COMMENT ON COLUMN m_raepa.an_raepal_compt_ae.l_typcompt IS 'Type de compteur.';
COMMENT ON COLUMN m_raepa.an_raepal_compt_ae.l_foncompt IS 'Fonction du compteur';
COMMENT ON COLUMN m_raepa.an_raepal_compt_ae.l_diametre IS 'Diamètre nominal du compteur, en millimètres';
COMMENT ON COLUMN m_raepa.an_raepal_compt_ae.l_anetal IS 'Année étalonnage compteur ';

-- ### an_raepal_stat_pomp_ass ###
CREATE TABLE m_raepa.an_raepal_stat_pomp_ass
(
  idobjet bigint, -- Identifiant unique de l'objet du réseau.
  idprod character varying (254) NOT NULL, -- Identifiant du producteur de l'objet
  l_typpompa character varying (2) NOT NULL DEFAULT '00', -- Type de station de pompage.
  l_traith2s character varying (1) NOT NULL DEFAULT '0', -- Traitement de l'Hydrogène sulfuré (Oui/Non).
  l_troplein character varying (1)NOT NULL DEFAULT '0', -- Présence trop plein (Oui/Non).
  CONSTRAINT m_reseau_stat_pomp_ass_pkey PRIMARY KEY (idobjet)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.an_raepal_stat_pomp_ass
  IS 'Classe alphanumérique portant les informations génériques d''une station de pompage d''Assainissement collectif.';
COMMENT ON COLUMN m_raepa.an_raepal_stat_pomp_ass.idobjet IS 'Identifiant unique de l''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_stat_pomp_ass.idprod IS 'Identifiant du producteur de l''objet';
COMMENT ON COLUMN m_raepa.an_raepal_stat_pomp_ass.l_typpompa IS 'Type de station de pompage.';
COMMENT ON COLUMN m_raepa.an_raepal_stat_pomp_ass.l_traith2s IS 'Traitement de l''Hydrogène sulfuré (Oui/Non).';
COMMENT ON COLUMN m_raepa.an_raepal_stat_pomp_ass.l_troplein IS ' Présence trop plein (Oui/Non).';


-- ### an_raepal_step_ass
CREATE TABLE m_raepa.an_raepal_step_ass
(
  idobjet bigint, -- Identifiant unique de l'objet du réseau.
  idprod character varying (254) NOT NULL, -- Identifiant du producteur de l'objet
  l_typstep character varying (2) NOT NULL DEFAULT '00', -- Type de traitement de la STEP.
  l_charge character varying (2) NOT NULL DEFAULT '00', -- Capacité de charge de la STEP.
  l_capnomi Integer, -- Capacité nominale de la STEP en équivalent habitant.
  CONSTRAINT m_reseau_step_ass_pkey PRIMARY KEY (idobjet)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.an_raepal_step_ass
  IS 'Classe alphanumérique portant les informations génériques d''une STEP d''Assainissement collectif.';
COMMENT ON COLUMN m_raepa.an_raepal_step_ass.idobjet IS 'Identifiant unique de l''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_step_ass.idprod IS 'Identifiant du producteur de l''objet';
COMMENT ON COLUMN m_raepa.an_raepal_step_ass.l_typstep IS 'Type de traitement de la STEP.';
COMMENT ON COLUMN m_raepa.an_raepal_step_ass.l_charge IS 'Capacité de charge de la STEP.';
COMMENT ON COLUMN m_raepa.an_raepal_step_ass.l_capnomi IS 'Capacité nominale de la STEP en équivalent habitant.';


-- ### an_raepal_bass_stock_ass
CREATE TABLE m_raepa.an_raepal_bass_stock_ass
(
  idobjet bigint, -- Identifiant unique de l'objet du réseau.
  idprod character varying (254) NOT NULL, -- Identifiant du producteur de l'objet
  l_typbass character varying (2) NOT NULL DEFAULT '00', -- Type de bassin de stockage d'Assainissement collectif.
  l_telegest character varying (1) NOT NULL DEFAULT '0', -- Télégestion (Oui/Non).
  l_zsurv decimal (6,3), -- Côte de la surverse, en mètres (Référentiel NGF - IGN69).
  CONSTRAINT m_reseau_bass_stock_ass_pkey PRIMARY KEY (idobjet)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.an_raepal_bass_stock_ass
  IS 'Classe alphanumérique portant les informations génériques d''un Bassin de Stockage d''Assainissement collectif.';
COMMENT ON COLUMN m_raepa.an_raepal_bass_stock_ass.idobjet IS 'Identifiant unique de l''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_bass_stock_ass.idprod IS 'Identifiant du producteur de l''objet';
COMMENT ON COLUMN m_raepa.an_raepal_bass_stock_ass.l_typbass IS ' Type de bassin de stockage d''Assainissement collectif.';
COMMENT ON COLUMN m_raepa.an_raepal_bass_stock_ass.l_telegest IS 'Télégestion (Oui/Non).';
COMMENT ON COLUMN m_raepa.an_raepal_bass_stock_ass.l_zsurv IS 'Côte de la surverse, en mètres (Référentiel NGF - IGN69).';



-- ### an_raepal_regard_ass
CREATE TABLE m_raepa.an_raepal_regard_ass
(
  idobjet bigint, -- Identifiant unique de l'objet du réseau.
  idprod character varying (254) NOT NULL, -- Identifiant du producteur de l'objet
  l_typreg character varying (2) NOT NULL DEFAULT '00', -- Type de regard d'Assainissement collectif.
  l_visit character varying (1) NOT NULL DEFAULT '0', --   Regard visitable, ou non (borgne)
  l_formreg character varying (2) NOT NULL DEFAULT '00', -- Forme du regard d'Assainissement collectif.
  l_decant character varying (1) NOT NULL DEFAULT '0', -- Regard d'Assainissement collectif à décantation ou non.  
  l_tampon character varying (1) NOT NULL DEFAULT '0', --  Regard d'Assainissement collectif avec tampon ou non. 
  l_grille character varying (1) NOT NULL DEFAULT '0', --  Regard d'Assainissement collectif avec grille ou non. 
  l_dimgrill character varying (20), -- Dimension de la grille, en m.  
	
  CONSTRAINT m_reseau_regard_ass_pkey PRIMARY KEY (idobjet)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.an_raepal_regard_ass
  IS 'Classe alphanumérique portant les informations génériques d''un Regard d''Assainissement collectif.';
COMMENT ON COLUMN m_raepa.an_raepal_regard_ass.idobjet IS 'Identifiant unique de l''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_regard_ass.idprod IS 'Identifiant du producteur de l''objet';
COMMENT ON COLUMN m_raepa.an_raepal_regard_ass.l_typreg IS 'Type de regard d''Assainissement collectif.';
COMMENT ON COLUMN m_raepa.an_raepal_regard_ass.l_visit IS 'Regard visitable, ou non (borgne)';
COMMENT ON COLUMN m_raepa.an_raepal_regard_ass.l_formreg IS 'Forme du regard d''Assainissement collectif.';
COMMENT ON COLUMN m_raepa.an_raepal_regard_ass.l_decant IS 'Regard d''Assainissement collectif à décantation ou non';
COMMENT ON COLUMN m_raepa.an_raepal_regard_ass.l_tampon IS 'Regard d''Assainissement collectif avec tampon ou non.';
COMMENT ON COLUMN m_raepa.an_raepal_regard_ass.l_grille IS 'Regard d''Assainissement collectif avec grille ou non.';
COMMENT ON COLUMN m_raepa.an_raepal_regard_ass.l_dimgrill IS 'Dimension de la grille, en mètre. (longueur x largeur).';


-- ### an_raepal_reg_bt_brchmt_ass
CREATE TABLE m_raepa.an_raepal_reg_bt_brchmt_ass
(
  idobjet bigint, -- Identifiant unique de l'objet du réseau.
  idprod character varying (254) NOT NULL, -- Identifiant du producteur de l'objet
  l_typusage character varying (2) NOT NULL DEFAULT '00', -- Type d'usager
	
  CONSTRAINT m_reseau_reg_bt_brchmt_ass_pkey PRIMARY KEY (idobjet)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.an_raepal_reg_bt_brchmt_ass
  IS 'Classe alphanumérique portant les informations génériques d''un regard de boîte de branchement d''Assainissement collectif.';
COMMENT ON COLUMN m_raepa.an_raepal_reg_bt_brchmt_ass.idobjet IS 'Identifiant unique de l''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_reg_bt_brchmt_ass.idprod IS 'Identifiant du producteur de l''objet';
COMMENT ON COLUMN m_raepa.an_raepal_reg_bt_brchmt_ass.l_typusage IS ' Type d''usager';



-- ### an_raepal_avaloir_ass
CREATE TABLE m_raepa.an_raepal_avaloir_ass
(
  idobjet bigint, -- Identifiant unique de l'objet du réseau.
  idprod character varying (254) NOT NULL, -- Identifiant du producteur de l'objet
  l_typaval character varying (2) NOT NULL DEFAULT '00', -- Type d'avaloir.
  l_nivvoiri character varying (1) NOT NULL DEFAULT '0', -- Mise à côte voirie (Oui/Non)
  l_decant character varying (1) NOT NULL DEFAULT '0', -- Décantation (Oui/Non) 
  l_dimgrill character varying (20), -- Dimension de la grille, en m.
  l_modpass character varying (2) NOT NULL DEFAULT '00', -- Mode de passage.
	
	
  CONSTRAINT m_reseau_avaloir_ass_pkey PRIMARY KEY (idobjet)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.an_raepal_avaloir_ass
  IS 'Classe alphanumérique portant les informations génériques d''un regard d''un Avaloir d''Assainissement collectif.';
COMMENT ON COLUMN m_raepa.an_raepal_avaloir_ass.idobjet IS 'Identifiant unique de l''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_avaloir_ass.idprod IS 'Identifiant du producteur de l''objet';
COMMENT ON COLUMN m_raepa.an_raepal_avaloir_ass.l_typaval IS 'Type d''avaloir.';
COMMENT ON COLUMN m_raepa.an_raepal_avaloir_ass.l_nivvoiri IS 'Mise à côte voirie (Oui/Non)';
COMMENT ON COLUMN m_raepa.an_raepal_avaloir_ass.l_decant IS 'Décantation (Oui/Non) ';
COMMENT ON COLUMN m_raepa.an_raepal_avaloir_ass.l_dimgrill IS 'Dimension de la grille, en mètre. (longueur x largeur)';
COMMENT ON COLUMN m_raepa.an_raepal_avaloir_ass.l_modpass IS 'Mode de passage.';

-- ### an_raepal_stat_pomp_ae
CREATE TABLE m_raepa.an_raepal_stat_pomp_ae
(
  idobjet bigint, -- Identifiant unique de l'objet du réseau.
  idprod character varying (254) NOT NULL, -- Identifiant du producteur de l'objet
  l_typpomp character varying (2) NOT NULL DEFAULT '00', -- Type de station de pompage d'Adduction d'eau potable.
  l_debit integer, -- Débit nominal de la station de pompage en m3/h.
  l_hmano decimal(5,2), -- Hauteur manométrique totale en mètre. Correspond à la différence de presssion du liquide franchissant la pompe
	
  CONSTRAINT m_reseau_stat_pomp_ae_pkey PRIMARY KEY (idobjet)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.an_raepal_stat_pomp_ae
  IS 'Classe alphanumérique portant les informations génériques d''une station de pompage d''Adduction d''eau potable.';
COMMENT ON COLUMN m_raepa.an_raepal_stat_pomp_ae.idobjet IS 'Identifiant unique de l''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_stat_pomp_ae.idprod IS 'Identifiant du producteur de l''objet';
COMMENT ON COLUMN m_raepa.an_raepal_stat_pomp_ae.l_typpomp IS 'Type de station de pompage d''Adduction d''eau potable.';
COMMENT ON COLUMN m_raepa.an_raepal_stat_pomp_ae.l_debit IS 'Débit nominal de la station de pompage en m3/h.';
COMMENT ON COLUMN m_raepa.an_raepal_stat_pomp_ae.l_hmano IS 'Hauteur manométrique totale en mètre. Correspond à la différence de presssion du liquide franchissant la pompe';



-- ### an_raepal_stat_trait_ae
CREATE TABLE m_raepa.an_raepal_stat_trait_ae
(
  idobjet bigint, -- Identifiant unique de l'objet du réseau.
  idprod character varying (254) NOT NULL, -- Identifiant du producteur de l'objet
  l_idars character varying (100), -- Identifiant de l'Agence Régionale de Santé
  l_typtrait character varying (2) NOT NULL DEFAULT '00', -- Type de traitement de la station d'Adduction d'eau potable.
  l_capacite integer, -- Capacité de traitement en m3/h.
	
  CONSTRAINT m_reseau_stat_trait_ae_pkey PRIMARY KEY (idobjet)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.an_raepal_stat_trait_ae
  IS 'Classe alphanumérique portant les informations génériques d''une station de traitement d''Adduction d''eau potable.';
COMMENT ON COLUMN m_raepa.an_raepal_stat_trait_ae.idobjet IS 'Identifiant unique de l''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_stat_trait_ae.idprod IS 'Identifiant du producteur de l''objet';
COMMENT ON COLUMN m_raepa.an_raepal_stat_trait_ae.l_idars IS 'Identifiant de l''Agence Régionale de Santé';
COMMENT ON COLUMN m_raepa.an_raepal_stat_trait_ae.l_typtrait IS 'Type de traitement de la station d''Adduction d''eau potable.';
COMMENT ON COLUMN m_raepa.an_raepal_stat_trait_ae.l_capacite IS 'Capacité de traitement en m3/h.';


-- ### an_raepal_reservoir_ae
CREATE TABLE m_raepa.an_raepal_reservoir_ae
(
  idobjet bigint, -- Identifiant unique de l'objet du réseau.
  idprod character varying (254) NOT NULL, -- Identifiant du producteur de l'objet
  l_typres character varying (2) NOT NULL DEFAULT '00', -- Type de réservoir d'Adduction d'eau potable.
  l_volume integer, -- Volume du réservoir en m3.
  l_ztp decimal (6,3), -- Côte NGF du trop plein, en mètres.
  l_nbcuve integer, -- Nombre de cuves
	
  CONSTRAINT m_reseau_reservoir_ae_pkey PRIMARY KEY (idobjet)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.an_raepal_reservoir_ae
  IS 'Classe alphanumérique portant les informations génériques d''un Réservoir d''Adduction d''eau potable.';
COMMENT ON COLUMN m_raepa.an_raepal_reservoir_ae.idobjet IS 'Identifiant unique de l''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_reservoir_ae.idprod IS 'Identifiant du producteur de l''objet';
COMMENT ON COLUMN m_raepa.an_raepal_reservoir_ae.l_typres IS 'Type de réservoir d''Adduction d''eau potable.';
COMMENT ON COLUMN m_raepa.an_raepal_reservoir_ae.l_volume IS 'Volume du réservoir en m3.';
COMMENT ON COLUMN m_raepa.an_raepal_reservoir_ae.l_ztp IS 'Côte NGF du trop plein, en mètres.';
COMMENT ON COLUMN m_raepa.an_raepal_reservoir_ae.l_nbcuve IS 'Nombre de cuves';

-- ### an_raepal_captage_ae
CREATE TABLE m_raepa.an_raepal_captage_ae
(
  idobjet bigint, -- Identifiant unique de l'objet du réseau.
  idprod character varying (254) NOT NULL, -- Identifiant du producteur de l'objet
  l_typcapt character varying (2) NOT NULL DEFAULT '00', -- Type de captage d'Adduction d'eau potable.
  l_idbss character varying (254), -- Identifiant du point d'eau (Code BSS)
  l_debh integer, -- Débit nominal en m3/h.
  l_debj integer, -- Débit nominal en m3/jour.
  l_deba integer, -- Débit nominal en m3/an.
	
  CONSTRAINT m_reseau_captage_ae_pkey PRIMARY KEY (idobjet)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.an_raepal_captage_ae
  IS 'Classe alphanumérique portant les informations génériques d''un Captage d''Adduction d''eau potable.';
COMMENT ON COLUMN m_raepa.an_raepal_captage_ae.idobjet IS 'Identifiant unique de l''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_captage_ae.idprod IS 'Identifiant du producteur de l''objet';
COMMENT ON COLUMN m_raepa.an_raepal_captage_ae.l_typcapt IS 'Type de captage d''Adduction d''eau potable.';
COMMENT ON COLUMN m_raepa.an_raepal_captage_ae.l_idbss IS 'Identifiant du point d''eau (Code BSS)';
COMMENT ON COLUMN m_raepa.an_raepal_captage_ae.l_debh IS 'Débit nominal en m3/h.';
COMMENT ON COLUMN m_raepa.an_raepal_captage_ae.l_debj IS 'Débit nominal en m3/jour.';
COMMENT ON COLUMN m_raepa.an_raepal_captage_ae.l_deba IS 'Débit nominal en m3/an.';

-- ### an_raepal_chambr_ae
CREATE TABLE m_raepa.an_raepal_chambr_ae
(
  idobjet bigint, -- Identifiant unique de l'objet du réseau.
  idprod character varying (254) NOT NULL, -- Identifiant du producteur de l'objet
  l_dim character varying (20), -- Dimension de la chambre (longueur x largeur), en mètre.
	
  CONSTRAINT m_reseau_chambr_ae_pkey PRIMARY KEY (idobjet)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.an_raepal_chambr_ae
  IS 'Classe alphanumérique portant les informations génériques d''une Chambre d''Adduction d''eau potable.';
COMMENT ON COLUMN m_raepa.an_raepal_chambr_ae.idobjet IS 'Identifiant unique de l''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_chambr_ae.idprod IS 'Identifiant du producteur de l''objet';
COMMENT ON COLUMN m_raepa.an_raepal_chambr_ae.l_dim IS 'Dimension de la chambre (longueur x largeur), en mètre.';


-- ### an_raepal_chambr_compt_ae
CREATE TABLE m_raepa.an_raepal_chambr_compt_ae
(
  idobjet bigint, -- Identifiant unique de l'objet du réseau.
  idprod character varying (254) NOT NULL, -- Identifiant du producteur de l'objet
  l_nbcompt integer, -- Nombre de compteur(s) présent(s); Généré automatiquement à l'intégration.
	
  CONSTRAINT m_reseau_chambr_compt_ae_pkey PRIMARY KEY (idobjet)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.an_raepal_chambr_compt_ae
  IS 'Classe alphanumérique portant les informations génériques d''une chambre de comptage.';
COMMENT ON COLUMN m_raepa.an_raepal_chambr_compt_ae.idobjet IS 'Identifiant unique de l''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_chambr_compt_ae.idprod IS 'Identifiant du producteur de l''objet';
COMMENT ON COLUMN m_raepa.an_raepal_chambr_compt_ae.l_nbcompt IS 'Nombre de compteur(s) présent(s); Généré automatiquement à l''intégration.';


-- ### an_raepal_citerneau_ae
CREATE TABLE m_raepa.an_raepal_citerneau_ae
(
  idobjet bigint, -- Identifiant unique de l'objet du réseau.
  idprod character varying (254) NOT NULL, -- Identifiant du producteur de l'objet
  l_nbcompt integer, -- Nombre de compteur(s) présent(s); Généré automatiquement à l'intégration.
  l_typusage character varying (2) NOT NULL DEFAULT '00', -- Type d'usager
	
  CONSTRAINT m_reseau_citerneau_ae_pkey PRIMARY KEY (idobjet)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.an_raepal_citerneau_ae
  IS 'Classe alphanumérique portant les informations génériques d''une chambre de comptage.';
COMMENT ON COLUMN m_raepa.an_raepal_citerneau_ae.idobjet IS 'Identifiant unique de l''objet du réseau.';
COMMENT ON COLUMN m_raepa.an_raepal_citerneau_ae.idprod IS 'Identifiant du producteur de l''objet';
COMMENT ON COLUMN m_raepa.an_raepal_citerneau_ae.l_nbcompt IS 'Nombre de compteur(s) présent(s); Généré automatiquement à l''intégration.';
COMMENT ON COLUMN m_raepa.an_raepal_citerneau_ae.l_typusage IS 'Type d''usager';

/* CLASSE GEO_RAEPAL_COMPARATEUR */
/* Classe permettant de comparer entre chaque version les objets ajoutés et supprimés (indirectement les autres sont MAJ) */

-- Table: m_raepa.geo_raepal_comparateur

-- DROP TABLE m_raepa.geo_raepal_comparateur;
CREATE TABLE m_raepa.geo_raepal_comparateur
(
  idobjet bigint, -- Identifiant unique de l'objet du réseau
  idprod character varying (254) NOT NULL, -- Identifiant du prestataire de l'objet
  typcomp character varying (20) NOT NULL, -- Type de comparaison
  l_reseau character varying (7) NOT NULL, -- Réseau concerné
  l_typeobjet character varying (20) NOT NULL, --Type d'objet du réseau
  concess character varying (20) NOT NULL, -- Définit le concessionnaire de l'objet
  date_ext date NOT NULL, -- date d'extraction du lot de données chez le producteur'
  geom geometry (GEOMETRY, 2154) NOT NULL,
  CONSTRAINT m_raepal_indicateur_id_objet_pkey PRIMARY KEY (idobjet)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.geo_raepal_comparateur
  IS 'Classe d''indicateur stockant les ajouts et suppressions d''objets entre deux versions';
COMMENT ON COLUMN m_raepa.geo_raepal_comparateur.idobjet IS 'Identifiant unique de l''objet du réseau';
COMMENT ON COLUMN m_raepa.geo_raepal_comparateur.idprod IS 'Identifiant du prestataire de l''objet';
COMMENT ON COLUMN m_raepa.geo_raepal_comparateur.l_reseau IS 'Réseau de l''objet';
COMMENT ON COLUMN m_raepa.geo_raepal_comparateur.typcomp IS 'Type de comparaison (Ajout/Suppression)';

COMMENT ON COLUMN m_raepa.geo_raepal_comparateur.l_typeobjet IS 'Type de l''objet';
COMMENT ON COLUMN m_raepa.geo_raepal_comparateur.date_ext IS 'Date d''extraction du lot de données chez le producteur';
COMMENT ON COLUMN m_raepa.geo_raepal_comparateur.concess IS ' Définit le concessionnaire de l''objet';
COMMENT ON COLUMN m_raepa.geo_raepal_comparateur.geom IS 'Attribut contenant la géométrie';



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                           EXTENSIONS FKEY (clé étrangère)                                                               ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- ############ AN_RAEPAL_OBJET_RESEAU ############

ALTER TABLE m_raepa.an_raepal_objet_reseau

  ADD CONSTRAINT lt_raepal_positver_fkey FOREIGN KEY (l_positver)
      REFERENCES m_raepa.lt_raepal_positver (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepal_materiau_fkey FOREIGN KEY (materiau)
      REFERENCES m_raepa.lt_raepal_materiau (code_arc) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepal_etat_fkey FOREIGN KEY (l_etat)
      REFERENCES m_raepa.lt_raepal_etat (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepal_domaine_fkey FOREIGN KEY (l_domaine)
      REFERENCES m_raepa.lt_raepal_domaine (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepal_criticit_fkey FOREIGN KEY (l_criticit)
      REFERENCES m_raepa.lt_raepal_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION; 
	  
	  
-- ############ GEO_RAEPAL_TRONC ############
ALTER TABLE m_raepa.geo_raepal_tronc
    ADD CONSTRAINT lt_raepa_idnini_fkey FOREIGN KEY (idnini)
      REFERENCES m_raepa.geo_raepa_noeud (idnoeud) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
	ADD CONSTRAINT lt_raepa_idnterm_fkey FOREIGN KEY (idnterm)
      REFERENCES m_raepa.geo_raepa_noeud (idnoeud) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepal_sensecoul_fkey FOREIGN KEY (sensecoul)
      REFERENCES m_raepa.lt_raepal_sensecoul (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- ############ AN_RAEPA_CANAL ############
ALTER TABLE m_raepa.an_raepa_canal

  ADD CONSTRAINT lt_raepal_formcana_fkey FOREIGN KEY (l_formcana)
      REFERENCES m_raepa.lt_raepal_formcana (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepal_protint_fkey FOREIGN KEY (l_protint)
      REFERENCES m_raepa.lt_raepal_typprot (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepal_idtronc_fkey FOREIGN KEY (idtronc)
      REFERENCES m_raepa.geo_raepal_tronc (idtronc) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepal_autpass_fkey FOREIGN KEY (l_autpass)
      REFERENCES m_raepa.lt_raepal_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepal_protext_fkey FOREIGN KEY (l_protext)
      REFERENCES m_raepa.lt_raepal_typprot (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;



-- ############ AN_RAEPA_OUV ############
ALTER TABLE m_raepa.an_raepa_ouv

  ADD CONSTRAINT lt_raepal_typimpl_fkey FOREIGN KEY (l_typimpl)
      REFERENCES m_raepa.lt_raepal_typimpl (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepa_idnoeud_fkey FOREIGN KEY (idnoeud)
      REFERENCES m_raepa.geo_raepa_noeud (idnoeud) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepal_acces_fkey FOREIGN KEY (l_acces)
      REFERENCES m_raepa.lt_raepal_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
	  
-- ############ AN_RAEPA_APP ############
ALTER TABLE m_raepa.an_raepa_app
  ADD CONSTRAINT lt_raepa_idouvrage_fkey FOREIGN KEY (idouvrage)
      REFERENCES m_raepa.an_raepa_ouv (idobjet) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepa_idnoeud_fkey FOREIGN KEY (idnoeud)
      REFERENCES m_raepa.geo_raepa_noeud (idnoeud) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepal_acces_fkey FOREIGN KEY (l_acces)
      REFERENCES m_raepa.lt_raepal_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;  
	  
-- ############ AN_RAEPA_CANALASS ############
ALTER TABLE m_raepa.an_raepa_canalae

  ADD CONSTRAINT lt_raepal_protcath_fkey FOREIGN KEY (l_protcath)
      REFERENCES m_raepa.lt_raepal_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;  
	 
-- ############ AN_RAEPAL_BRCHT_ASS ############
ALTER TABLE m_raepa.an_raepal_brcht_ass

  ADD CONSTRAINT lt_raepal_typracc_fkey FOREIGN KEY (l_typracc)
      REFERENCES m_raepa.lt_raepal_typracc (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepal_conform_fkey FOREIGN KEY (l_conform)
      REFERENCES m_raepa.lt_raepal_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;	  
	 
-- ############ AN_RAEPAL_VIDANGE_AE ############
ALTER TABLE m_raepa.an_raepal_vidange_ae

  ADD CONSTRAINT lt_raepal_positvid_fkey FOREIGN KEY (l_positvid)
      REFERENCES m_raepa.lt_raepal_position (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepal_typexut_fkey FOREIGN KEY (l_typexut)
      REFERENCES m_raepa.lt_raepal_typexut (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;	  	 

-- ############ AN_RAEPAL_VANNE_AE ############
ALTER TABLE m_raepa.an_raepal_vanne_ae

  ADD CONSTRAINT lt_raepal_typvanne_fkey FOREIGN KEY (l_typvanne)
      REFERENCES m_raepa.lt_raepal_typvanne (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepal_positvan_fkey FOREIGN KEY (l_positvan)
      REFERENCES m_raepa.lt_raepal_position (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepal_etatvan_fkey FOREIGN KEY (l_etatvan)
      REFERENCES m_raepa.lt_raepal_etatvan (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;	  	 
	  
-- ############ AN_RAEPAL_REG_PRESS_AE ############

ALTER TABLE m_raepa.an_raepal_reg_press_ae
 ADD CONSTRAINT lt_raepal_typregul_fkey FOREIGN KEY (l_typregul)
      REFERENCES m_raepa.lt_raepal_typregul (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;	  	 

-- ############ AN_RAEPAL_DEB_AE ############

ALTER TABLE m_raepa.an_raepal_deb_ae

  ADD CONSTRAINT lt_raepal_positdeb_fkey FOREIGN KEY (l_positdeb)
      REFERENCES m_raepa.lt_raepal_position (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
	  
	  
-- ############ AN_RAEPAL_COMPT_AE ############
ALTER TABLE m_raepa.an_raepal_compt_ae

  ADD CONSTRAINT lt_raepal_typcompt_fkey FOREIGN KEY (l_typcompt)
      REFERENCES m_raepa.lt_raepal_typcompt (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepal_foncompt_fkey FOREIGN KEY (l_foncompt)
      REFERENCES m_raepa.lt_raepal_foncompt (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;	  	 
	  	  
-- ############ AN_RAEPAL_STAT_POMP_ASS ############
ALTER TABLE m_raepa.an_raepal_stat_pomp_ass

  ADD CONSTRAINT lt_raepal_typpompa_fkey FOREIGN KEY (l_typpompa)
      REFERENCES m_raepa.lt_raepal_typpompa (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,  
  ADD CONSTRAINT lt_raepal_traith2s_fkey FOREIGN KEY (l_traith2s)
      REFERENCES m_raepa.lt_raepal_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
   ADD CONSTRAINT lt_raepal_troplein_fkey FOREIGN KEY (l_troplein)
      REFERENCES m_raepa.lt_raepal_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;	
	  
-- ############ AN_RAEPAL_STEP_ASS ############
ALTER TABLE m_raepa.an_raepal_step_ass

  ADD CONSTRAINT lt_raepal_typstep_fkey FOREIGN KEY (l_typstep)
      REFERENCES m_raepa.lt_raepal_typstep (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,  
  ADD CONSTRAINT lt_raepal_charge_fkey FOREIGN KEY (l_charge)
      REFERENCES m_raepa.lt_raepal_charge (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
	  
-- ############ AN_RAEPAL_BASS_STOCK_ASS ############
ALTER TABLE m_raepa.an_raepal_bass_stock_ass

  ADD CONSTRAINT lt_raepal_typbass_fkey FOREIGN KEY (l_typbass)
      REFERENCES m_raepa.lt_raepal_typbass (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,  
  ADD CONSTRAINT lt_raepal_telegest_fkey FOREIGN KEY (l_telegest)
      REFERENCES m_raepa.lt_raepal_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;	  
	  
-- ############ AN_RAEPAL_REGARD_ASS ############
ALTER TABLE m_raepa.an_raepal_regard_ass

  ADD CONSTRAINT lt_raepal_typreg_fkey FOREIGN KEY (l_typreg)
      REFERENCES m_raepa.lt_raepal_typreg (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepal_formreg_fkey FOREIGN KEY (l_formreg)
      REFERENCES m_raepa.lt_raepal_formreg (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
 ADD CONSTRAINT lt_raepal_decant_fkey FOREIGN KEY (l_decant)
      REFERENCES m_raepa.lt_raepal_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
 ADD CONSTRAINT lt_raepal_tampon_fkey FOREIGN KEY (l_tampon)
      REFERENCES m_raepa.lt_raepal_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
 ADD CONSTRAINT lt_raepal_grille_fkey FOREIGN KEY (l_grille)
      REFERENCES m_raepa.lt_raepal_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepal_visit_fkey FOREIGN KEY (l_visit)
      REFERENCES m_raepa.lt_raepal_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
	  
	  
-- ############ AN_RAEPAL_reg_bt_brchmt_ass ############
ALTER TABLE m_raepa.an_raepal_reg_bt_brchmt_ass

  ADD CONSTRAINT lt_raepal_typusage_fkey FOREIGN KEY (l_typusage)
      REFERENCES m_raepa.lt_raepal_typusage_ass (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
	  
-- ############ AN_RAEPAL_AVALOIR_ASS ############
ALTER TABLE m_raepa.an_raepal_avaloir_ass
 ADD CONSTRAINT lt_raepal_nivvoiri_fkey FOREIGN KEY (l_nivvoiri)
      REFERENCES m_raepa.lt_raepal_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
 ADD CONSTRAINT lt_raepal_decant_fkey FOREIGN KEY (l_decant)
      REFERENCES m_raepa.lt_raepal_boolean (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
 ADD CONSTRAINT lt_raepal_modpass_fkey FOREIGN KEY (l_modpass)
      REFERENCES m_raepa.lt_raepal_typracc (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_raepal_typaval_fkey FOREIGN KEY (l_typaval)
      REFERENCES m_raepa.lt_raepal_typaval (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
	 
-- ############ AN_RAEPAL_STAT_POMP_AE ############
ALTER TABLE m_raepa.an_raepal_stat_pomp_ae
  ADD CONSTRAINT lt_raepal_typpomp_fkey FOREIGN KEY (l_typpomp)
      REFERENCES m_raepa.lt_raepal_typpompe (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
	 
-- ############ AN_RAEPAL_STAT_TRAIT_AE ############
ALTER TABLE m_raepa.an_raepal_stat_trait_ae
  ADD CONSTRAINT lt_raepal_typtrait_fkey FOREIGN KEY (l_typtrait)
      REFERENCES m_raepa.lt_raepal_typtrait (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;	 

-- ############ AN_RAEPAL_RESERVOIR_AE ############
ALTER TABLE m_raepa.an_raepal_reservoir_ae
  ADD CONSTRAINT lt_raepal_typres_fkey FOREIGN KEY (l_typres)
      REFERENCES m_raepa.lt_raepal_typres (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;	 

-- ############ AN_RAEPAL_CAPTAGE_AE ############
ALTER TABLE m_raepa.an_raepal_captage_ae
  ADD CONSTRAINT lt_raepal_typcapt_fkey FOREIGN KEY (l_typcapt)
      REFERENCES m_raepa.lt_raepal_typcapt (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;	 
	  
-- ############ AN_RAEPAL_CITERNEAU_AE ############
ALTER TABLE m_raepa.an_raepal_citerneau_ae
  ADD CONSTRAINT lt_raepal_typusage_fkey FOREIGN KEY (l_typusage)
      REFERENCES m_raepa.lt_raepal_typusage_ae (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;	 	 


