 /*RAEPA V1.2*/
/*log de la base RAEPA */
/*init_bd_resh_40_log.sql */
/*PostGIS*/

/* GeoCompiegnois - http://geo.compiegnois.fr/ */
/* Auteur : Florent Vanhoutte */



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        DROP                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- trigger
DROP TRIGGER IF EXISTS t_t2_log_audit_raepa ON m_raepa.geo_v_raepa_canalaep_l;
-- fonction trigger
DROP FUNCTION IF EXISTS m_raepa.ft_m_log_audit_raepa();
-- classe
DROP TABLE IF EXISTS m_raepa.log_audit_raepa;
-- sequence
DROP SEQUENCE IF EXISTS m_raepa.raepa_idaudit_seq;


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                     SEQUENCE                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- Sequence: m_raepa.raepa_idaudit_seq

-- DROP SEQUENCE m_raepa.raepa_idaudit_seq;

CREATE SEQUENCE m_raepa.raepa_idaudit_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                       CLASSE                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- ################################################################ CLASSE LOG RAEPA ##############################################


-- Table: m_raepa.log_audit_raepa

-- DROP TABLE m_raepa.log_audit_raepa;

CREATE TABLE m_raepa.log_audit_raepa
(
  idaudit integer NOT NULL,
  tablename character varying(80) NOT NULL,
  idraepa character varying(254) NOT NULL,
  type_ope text NOT NULL,
  ope_sai character varying(254),
  dataold character varying(254),
  datanew character varying(254),
  date_maj timestamp without time zone,
  CONSTRAINT log_audit_raepa_pkey PRIMARY KEY (idaudit)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.log_audit_raepa
  IS 'Table d''audit des opérations sur la base de données RAEPA';
COMMENT ON COLUMN m_raepa.log_audit_raepa.idaudit IS 'Identifiant unique de d''opération';
COMMENT ON COLUMN m_raepa.log_audit_raepa.tablename IS 'Nom de la table concernée par l''opération sur l''entité';
COMMENT ON COLUMN m_raepa.log_audit_raepa.idraepa IS 'Identifiant de l''entité concernée par l''opération';
COMMENT ON COLUMN m_raepa.log_audit_raepa.type_ope IS 'Type l''opération sur l''entité';
COMMENT ON COLUMN m_raepa.log_audit_raepa.ope_sai IS 'Utilisateur ayant effectuée l''opération sur l''entité';
COMMENT ON COLUMN m_raepa.log_audit_raepa.dataold IS 'Valeur ancienne avant l''opération sur l''entité';
COMMENT ON COLUMN m_raepa.log_audit_raepa.datanew IS 'Valeur nouvelle après l''opération sur l''entité';
COMMENT ON COLUMN m_raepa.log_audit_raepa.date_maj IS 'Horodatage de l''opération sur la base RAEPA';



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      TRIGGER                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################



-- #################################################################### FONCTION TRIGGER - LOG_RAEPA ###################################################

-- Function: m_raepa.ft_m_log_audit_raepa()

-- DROP FUNCTION m_raepa.ft_m_log_audit_raepa();

CREATE OR REPLACE FUNCTION m_raepa.ft_m_log_audit_raepa()
  RETURNS trigger AS
$BODY$

DECLARE v_idaudit integer;
DECLARE v_idraepa character varying(254);
DECLARE v_dataold character varying(254);
DECLARE v_datanew character varying(254);


BEGIN

-- INSERT
IF (TG_OP = 'INSERT') THEN

v_idaudit := nextval('m_raepa.raepa_idaudit_seq'::regclass);
v_idraepa := currval('m_raepa.raepa_idraepa_seq'::regclass);
v_datanew := ROW(NEW.*);
INSERT INTO m_raepa.log_audit_raepa (idaudit, tablename, idraepa, type_ope, ope_sai, dataold, datanew, date_maj)
SELECT
v_idaudit,
TG_TABLE_NAME,
v_idraepa,
'INSERT',
CASE WHEN NEW.sourmaj IS NULL THEN 'Non renseigné' ELSE NEW.sourmaj END, -- voir si équivalence avec sourmaj
NULL,
v_datanew,
now();
RETURN NEW;


-- UPDATE
ELSIF (TG_OP = 'UPDATE') THEN

v_idaudit := nextval('m_raepa.raepa_idaudit_seq'::regclass);
v_dataold := ROW(OLD.*);
v_datanew := ROW(NEW.*);

INSERT INTO m_raepa.log_audit_raepa (idaudit, tablename, idraepa, type_ope, ope_sai, dataold, datanew, date_maj)
SELECT
v_idaudit,
TG_TABLE_NAME,
NEW.idcana, -- problèmes compte tenu des différents "nom" des attributs idcana,idouvr,idappar ... on devrait unifier les noms dans le resh_20 et revoir les vues opendata pour retrouver le bon nom d'attribut pour les échanges. Sinon contrainte de faire autant de fonction que de type de classe (cana, repar, appar, ouvr)
'UPDATE',
CASE WHEN NEW.sourmaj IS NULL THEN 'Non renseigné' ELSE NEW.sourmaj END, -- voir si équivalence avec sourmaj
v_dataold,
v_datanew,
now();
RETURN NEW;

/*
-- DELETE
ELSIF (TG_OP = 'DELETE') THEN

v_idaudit := nextval('m_raepa.raepa_idaudit_seq'::regclass);
INSERT INTO m_raepa.log_audit_raepa (idaudit, tablename, idraepa, type_ope, ope_sai, dataold, datanew, date_maj)
SELECT
v_idaudit,
TG_TABLE_NAME,
NEW.idcana, -- problèmes compte tenu des différents "nom" des attributs idcana,idouvr,idappar ... on devrait unifier les noms dans le resh_20 et revoir les vues opendata pour retrouver le bon nom d'attribut pour les échanges. Sinon contrainte de faire autant de fonction que de type de classe (cana, repar, appar, ouvr)
'DELETE',
NEW.sourmaj, -- voir si équivalence avec sourmaj
v_dataold,
v_datanew,
now();
RETURN NEW;
*/
END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

COMMENT ON FUNCTION m_raepa.ft_m_log_audit_raepa() IS 'audit';



-- Trigger: t_t2_log_audit_raepa on m_raepa.geo_v_raepa_canalaep_l

-- DROP TRIGGER t_t2_log_audit_raepa ON m_raepa.geo_v_raepa_canalaep_l;

CREATE TRIGGER t_t2_log_audit_raepa
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON m_raepa.geo_v_raepa_canalaep_l
  FOR EACH ROW
  EXECUTE PROCEDURE m_raepa.ft_m_log_audit_raepa();
