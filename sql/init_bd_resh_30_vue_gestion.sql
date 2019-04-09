 /*RAEPA V1.2*/
/*Vue de gestion pour les extensions locales du RAEPA (vue, trigger,...)*/
/*init_bd_resh_30_vue_gestion.sql */
/*PostGIS*/

/* GeoCompiegnois - http://geo.compiegnois.fr/ */
/* Auteur : Florent Vanhoutte */




-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        VUES                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- #################################################################### VUE CANALISATION AEP ###############################################
        
-- View: m_raepa.geo_v_raepa_canalaep_l

-- DROP VIEW m_raepa.geo_v_raepa_canalaep_l;

CREATE OR REPLACE VIEW m_raepa.geo_v_raepa_canalaep_l AS 
 SELECT 
  g.idcana,
  g.mouvrage,
  g.gexploit, 
  g.enservice,
  g.branchemnt,
  g.materiau,
  g.materiau2,
  g.diametre,
  g.forme,  
  g.anfinpose,
  g.modecircu,
  a.contcanaep,
  a.fonccanaep,     
  g.idnini,
  g.idnterm,
  g.idcanppale,
  g.zgensup,
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
  
FROM m_raepa.geo_raepa_canal g
INNER JOIN m_raepa.an_raepa_canalaep a ON g.idcana = a.idcana
INNER JOIN m_raepa.an_raepa_metadonnees m ON g.idcana = m.idraepa
ORDER BY g.idcana;

COMMENT ON VIEW m_raepa.geo_v_raepa_canalaep_l
  IS 'Canalisation d''adduction d''eau';



-- #################################################################### VUE CANALISATION ASS ###############################################

-- View: m_raepa.geo_v_raepa_canalass_l

-- DROP VIEW m_raepa.geo_v_raepa_canalass_l;

CREATE OR REPLACE VIEW m_raepa.geo_v_raepa_canalass_l AS 
 SELECT 
  g.idcana,
  g.mouvrage,
  g.gexploit, 
  g.enservice,
  g.branchemnt,
  a.typreseau,  
  g.materiau,
  g.materiau2,
  g.diametre,
  g.forme,    
  g.anfinpose,
  g.modecircu,
  a.contcanass,
  a.fonccanass,     
  g.idnini,
  g.idnterm,
  g.idcanppale,
  a.zamont,
  a.zaval,
  g.zgensup,
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
  
FROM m_raepa.geo_raepa_canal g
INNER JOIN m_raepa.an_raepa_canalass a ON g.idcana = a.idcana
INNER JOIN m_raepa.an_raepa_metadonnees m ON g.idcana = m.idraepa
ORDER BY g.idcana;

COMMENT ON VIEW m_raepa.geo_v_raepa_canalass_l
  IS 'Canalisation d''assainissement collectif';
  
  
  
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      TRIGGER                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- #################################################################### FONCTION TRIGGER - GEO_V_CANALAEP_L ###################################################

-- Function: m_raepa.ft_m_geo_v_raepa_canalaep_l()

-- DROP FUNCTION m_raepa.ft_m_geo_v_raepa_canalaep_l();

CREATE OR REPLACE FUNCTION m_raepa.ft_m_geo_v_raepa_canalaep_l()
  RETURNS trigger AS
$BODY$

--déclaration variable pour stocker la séquence des id raepa
DECLARE v_id_cana character varying(254);

BEGIN

-- INSERT
IF (TG_OP = 'INSERT') THEN

v_id_cana := nextval('m_raepa.raepa_idraepa_seq'::regclass);

-- geo_raepa_canal
INSERT INTO m_raepa.geo_raepa_canal (id_cana, mouvrage, gexploit, enservice, branchemnt, materiau, materiau2, diametre, forme, anfinpose, modecircu, idnini, idnterm, idcanppale, zgensup, profgen, andebpose, longcana, nbranche, geom)
SELECT v_id_cana,
NEW.mouvrage,
NEW.gexploit, 
NEW.enservice,
NEW.branchemnt,
LEFT(NEW.materiau2,2),
CASE WHEN NEW.materiau2 IS NULL THEN '00-00' ELSE NEW.materiau2 END,
NEW.diametre,
CASE WHEN NEW.forme IS NULL THEN '00' ELSE NEW.forme END,
NEW.anfinpose,
CASE WHEN NEW.modecircu IS NULL THEN '00' ELSE NEW.modecircu END, 
NEW.idnini,
NEW.idnterm,
NEW.idcanppale,
NEW.zgensup,
NEW.andebpose,
NEW.longcana,
NEW.nbranche,
NEW.geom;

-- an_raepa_canalaep
INSERT INTO m_raepa.an_raepa_canalaep (id_cana, contcanaep, fonccanaep, profgen)
SELECT v_id_cana,
CASE WHEN NEW.contcanaep IS NULL THEN '00' ELSE NEW.contcanaep END,
CASE WHEN NEW.fonccanaep IS NULL THEN '00' ELSE NEW.fonccanaep END,
NEW.profgen;

-- an_raepa_metadonnees
INSERT INTO m_raepa.an_raepa_canalaep (id_cana, contcanaep, fonccanaep, profgen)
SELECT v_id_cana,
CASE WHEN NEW.qualglocxy IS NULL THEN '03' ELSE NEW.qualglocxy END,
CASE WHEN NEW.qualglocz IS NULL THEN '03' ELSE NEW.qualglocxz END,
-- now(), -- datesai
NULL, -- datemaj
NEW.sourmaj,
NEW.dategeoloc,
NEW.sourgeoloc,
NEW.sourattrib,
CASE WHEN NEW.qualannee IS NULL THEN '03' ELSE NEW.qualglocxz END;


RETURN NEW;


-- UPDATE
ELSIF (TG_OP = 'UPDATE') THEN

-- geo_raepa_canal
UPDATE
m_raepa.geo_raepa_canal
SET
id_cana=OLD.id_cana,
mouvrage=NEW.mouvrage,
gexploit=NEW.gexploit, 
enservice=NEW.enservice,
branchemnt=NEW.branchemnt,
materiau=LEFT(NEW.materiau2,2),
materiau2=CASE WHEN NEW.materiau2 IS NULL THEN '00-00' ELSE NEW.materiau2 END,
diametre=NEW.diametre,
forme=CASE WHEN NEW.forme IS NULL THEN '00' ELSE NEW.forme END,
anfinpose=NEW.anfinpose,
modecircu=CASE WHEN NEW.modecircu IS NULL THEN '00' ELSE NEW.modecircu END, 
idnini=NEW.idnini,
idnterm=NEW.idnterm,
idcanppale=NEW.idcanppale,
zgensup=NEW.zgensup,
andebpose=NEW.andebpose,
longcana=NEW.longcana,
nbranche=NEW.nbranche,
geom=NEW.geom
WHERE m_raepa.geo_canal.id_cana = OLD.id_cana;

-- an_raepa_canalaep
UPDATE
m_raepa.an_raepa_canalaep
SET
id_cana=OLD.id_cana,
contcanaep=CASE WHEN NEW.contcanaep IS NULL THEN '00' ELSE NEW.contcanaep END,
fonccanaep=CASE WHEN NEW.fonccanaep IS NULL THEN '00' ELSE NEW.fonccanaep END,
profgen=NEW.profgen
WHERE m_raepa.an_raepa_canalaep.id_cana = OLD.id_cana;

-- an_raepa_metadonnees
UPDATE
m_raepa.an_raepa_metadonnees
SET
id_cana=OLD.id_cana,
qualglocxy=CASE WHEN NEW.qualglocxy IS NULL THEN '03' ELSE NEW.qualglocxy END,
qualglocz=CASE WHEN NEW.qualglocz IS NULL THEN '03' ELSE NEW.qualglocxz END,
-- datesau=OLD.datesai, -- datesai
datemaj=now(),
sourmaj=NEW.sourmaj,
dategeoloc=NEW.dategeoloc,
sourgeoloc=NEW.sourgeoloc,
sourattrib=NEW.sourattrib,
qualannee=CASE WHEN NEW.qualannee IS NULL THEN '03' ELSE NEW.qualglocxz END
WHERE m_raepa.an_raepa_metadonnees.id_cana = OLD.id_cana;

RETURN NEW;

/*

-- DELETE
ELSIF (TG_OP = 'DELETE') THEN
UPDATE
m_raepa.geo_pei
SET
etat_pei='03'

WHERE m_raepa.geo_pei.id_cana = OLD.id_cana;


RETURN NEW;

*/

END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

COMMENT ON FUNCTION m_raepa.ft_m_geo_v_raepa_canalaep_l() IS 'Fonction trigger pour mise à jour de la vue de gestion des canalisations d''eau potable';


-- Trigger: t_t1_geo_v_raepa_canalaep_l on m_raepa.geo_v_raepa_canalaep_l

-- DROP TRIGGER t_t1_geo_v_raepa_canalaep_l ON m_raepa.geo_v_raepa_canalaep_l;

CREATE TRIGGER t_t1_geo_v_raepa_canalaep_l
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON m_raepa.geo_v_raepa_canalaep_l
  FOR EACH ROW
  EXECUTE PROCEDURE m_raepa.ft_m_geo_v_raepa_canalaep_l();  