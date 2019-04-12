 /*RAEPA V1.2*/
/*log de la base RAEPA */
/*init_bd_resh_40_log.sql */
/*PostGIS*/

/* GeoCompiegnois - http://geo.compiegnois.fr/ */
/* Auteur : Florent Vanhoutte */




-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                     SEQUENCE                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- Sequence: m_raepa.raepa_idlog_seq

-- DROP SEQUENCE m_raepa.raepa_idlog_seq;

CREATE SEQUENCE m_raepa.raepa_idlog_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                    CLASSE LOG                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- ################################################################ CLASSE LOG RAEPA ##############################################




-- Table: m_raepa.log_audit_raepa

-- DROP TABLE m_raepa.log_audit_raepa;

CREATE TABLE m_raepa.log_audit_raepa
(
  idlog character varying(254) NOT NULL,
  idraepa character varying(254) NOT NULL,
  type_ope text NOT NULL,
  ope_sai character varying(254),
  date_maj timestamp without time zone,
  CONSTRAINT log_audit_raepa_pkey PRIMARY KEY (idlog)  
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_raepa.log_audit_raepa
  IS 'Table d''audit des opérations sur la base de données RAEPA';
COMMENT ON COLUMN m_raepa.log_audit_raepa.idlog IS 'Identifiant unique de l''opération de la base RAEPA';
COMMENT ON COLUMN m_raepa.log_audit_raepa.idraepa IS 'Identifiant de l''entité concernée par l''opération sur la base RAEPA';
COMMENT ON COLUMN m_raepa.log_audit_raepa.type_ope IS 'Type d''opération intervenue sur la base RAEPA';
COMMENT ON COLUMN m_raepa.log_audit_raepa.ope_sai IS 'Utilisateur ayant effectuée l''opération sur la base RAEPA';
COMMENT ON COLUMN m_raepa.log_audit_raepa.date_maj IS 'Horodatage de l''opération sur la base RAEPA';

