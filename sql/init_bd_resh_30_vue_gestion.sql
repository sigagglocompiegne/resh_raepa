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


-- !!!! penser à récup code insee et nom com dans les vues et incidences dans les triggers, sauf si possibilité de récup d'une extension pour la gestions des contrats_resh
-- !!! voir si code insee et nom com à gérer dans la base (stockage dans un attribut) ou pas simplement dans les "vues d'exploitation / applicatives"

-- #################################################################### VUE CANALISATION AEP ###############################################
        
-- View: m_raepa.geo_v_raepa_canalaep_l

-- DROP VIEW m_raepa.geo_v_raepa_canalaep_l;

CREATE OR REPLACE VIEW m_raepa.geo_v_raepa_canalaep_l AS 
 SELECT 
  g.idcana,
  m.idexploit,
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
  m.idexploit,  
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


-- !!!! pour les canalisations, prévoir de vérifier des contraintes topologiques (noeud, cana sécante ...) et métiers (incompatibilité de valeur d'attribut)

-- #################################################################### FONCTION TRIGGER - GEO_V_CANALAEP_L ###################################################

-- Function: m_raepa.ft_m_geo_v_raepa_canalaep_l()

-- DROP FUNCTION m_raepa.ft_m_geo_v_raepa_canalaep_l();

CREATE OR REPLACE FUNCTION m_raepa.ft_m_geo_v_raepa_canalaep_l()
  RETURNS trigger AS
$BODY$

--déclaration variable pour stocker la séquence des id raepa
DECLARE v_idcana character varying(254);

BEGIN

-- INSERT
IF (TG_OP = 'INSERT') THEN

v_idcana := nextval('m_raepa.raepa_idraepa_seq'::regclass);

-- an_raepa_metadonnees
INSERT INTO m_raepa.an_raepa_metadonnees (idraepa, qualglocxy, qualglocz, datemaj, sourmaj, dategeoloc, sourgeoloc, sourattrib, qualannee, idexploit)
SELECT v_idcana,
CASE WHEN NEW.qualglocxy IS NULL THEN '03' ELSE NEW.qualglocxy END,
CASE WHEN NEW.qualglocz IS NULL THEN '03' ELSE NEW.qualglocz END,
-- now(), -- datesai
now(), -- datemaj si date de sai existe alors datemaj peut être NULL (voir init_resh_20) et ici la valeur doit donc être NULL
CASE WHEN NEW.sourmaj IS NULL THEN 'Non renseigné' ELSE NEW.sourmaj END,
NEW.dategeoloc,
NEW.sourgeoloc,
NEW.sourattrib,
CASE WHEN (NEW.andebpose = NEW.anfinpose) THEN NEW.qualannee ELSE NULL END,
NEW.idexploit;

-- geo_raepa_canal
INSERT INTO m_raepa.geo_raepa_canal (idcana, mouvrage, gexploit, enservice, branchemnt, materiau, materiau2, diametre, forme, anfinpose, modecircu, idnini, idnterm, idcanppale, zgensup, andebpose, longcana, nbranche, geom)
SELECT v_idcana,
NEW.mouvrage,
NEW.gexploit, 
NEW.enservice,
NEW.branchemnt,
(SELECT code_open FROM m_raepa.lt_raepa_materiau2 m WHERE NEW.materiau2 = m.code),
CASE WHEN NEW.materiau2 IS NULL THEN '00-00' ELSE NEW.materiau2 END,
NEW.diametre,
CASE WHEN NEW.forme IS NULL THEN '00' ELSE NEW.forme END,
CASE WHEN (TO_DATE(NEW.anfinpose,'YYYY') > now()) THEN NULL ELSE NEW.anfinpose END,
CASE WHEN NEW.modecircu IS NULL THEN '00' ELSE NEW.modecircu END, 
NEW.idnini,
NEW.idnterm,
NEW.idcanppale,
NEW.zgensup,
CASE WHEN ((TO_DATE(NEW.andebpose,'YYYY') > now()) OR (TO_DATE(NEW.andebpose,'YYYY') > TO_DATE(NEW.anfinpose,'YYYY'))) THEN NULL ELSE NEW.andebpose END,
ST_Length(NEW.geom),
NEW.nbranche,
NEW.geom;

-- an_raepa_canalaep
INSERT INTO m_raepa.an_raepa_canalaep (idcana, contcanaep, fonccanaep, profgen)
SELECT v_idcana,
CASE WHEN NEW.contcanaep IS NULL THEN '00' ELSE NEW.contcanaep END,
CASE WHEN NEW.fonccanaep IS NULL THEN '00' ELSE NEW.fonccanaep END,
NEW.profgen;


RETURN NEW;


-- UPDATE
ELSIF (TG_OP = 'UPDATE') THEN

-- an_raepa_metadonnees
UPDATE
m_raepa.an_raepa_metadonnees
SET
idraepa=OLD.idcana,
qualglocxy=CASE WHEN NEW.qualglocxy IS NULL THEN '03' ELSE NEW.qualglocxy END,
qualglocz=CASE WHEN NEW.qualglocz IS NULL THEN '03' ELSE NEW.qualglocz END,
-- datesau=OLD.datesai, -- datesai
datemaj=now(),
sourmaj=CASE WHEN NEW.sourmaj IS NULL THEN 'Non renseigné' ELSE NEW.sourmaj END,
dategeoloc=NEW.dategeoloc,
sourgeoloc=NEW.sourgeoloc,
sourattrib=NEW.sourattrib,
qualannee=CASE WHEN (NEW.andebpose = NEW.anfinpose) THEN NEW.qualannee ELSE NULL END,
idexploit=NEW.idexploit
WHERE m_raepa.an_raepa_metadonnees.idraepa = OLD.idcana;

-- geo_raepa_canal
UPDATE
m_raepa.geo_raepa_canal
SET
idcana=OLD.idcana,
mouvrage=NEW.mouvrage,
gexploit=NEW.gexploit, 
enservice=NEW.enservice,
branchemnt=NEW.branchemnt,
materiau=(SELECT code_open FROM m_raepa.lt_raepa_materiau2 m WHERE NEW.materiau2 = m.code),
materiau2=CASE WHEN NEW.materiau2 IS NULL THEN '00-00' ELSE NEW.materiau2 END,
diametre=NEW.diametre,
forme=CASE WHEN NEW.forme IS NULL THEN '00' ELSE NEW.forme END,
anfinpose=CASE WHEN (TO_DATE(NEW.anfinpose,'YYYY') > now()) THEN NULL ELSE NEW.anfinpose END,
modecircu=CASE WHEN NEW.modecircu IS NULL THEN '00' ELSE NEW.modecircu END, 
idnini=NEW.idnini,
idnterm=NEW.idnterm,
idcanppale=NEW.idcanppale,
zgensup=NEW.zgensup,
andebpose=CASE WHEN ((TO_DATE(NEW.andebpose,'YYYY') > now()) OR (TO_DATE(NEW.andebpose,'YYYY') > TO_DATE(NEW.anfinpose,'YYYY'))) THEN NULL ELSE NEW.andebpose END,
longcana=ST_Length(NEW.geom),
nbranche=NEW.nbranche,
geom=NEW.geom
WHERE m_raepa.geo_raepa_canal.idcana = OLD.idcana;

-- an_raepa_canalaep
UPDATE
m_raepa.an_raepa_canalaep
SET
idcana=OLD.idcana,
contcanaep=CASE WHEN NEW.contcanaep IS NULL THEN '00' ELSE NEW.contcanaep END,
fonccanaep=CASE WHEN NEW.fonccanaep IS NULL THEN '00' ELSE NEW.fonccanaep END,
profgen=NEW.profgen
WHERE m_raepa.an_raepa_canalaep.idcana = OLD.idcana;


RETURN NEW;

/*

-- manque un attribut etat pour gérer la "suppression"

-- DELETE
ELSIF (TG_OP = 'DELETE') THEN
UPDATE
m_raepa.geo_pei
SET
etat_pei='03'

WHERE m_raepa.geo_pei.idcana = OLD.idcana;


RETURN NEW;

*/

END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

COMMENT ON FUNCTION m_raepa.ft_m_geo_v_raepa_canalaep_l() IS 'Fonction trigger pour mise à jour des entités depuis la vue de gestion des canalisations d''eau potable';


-- Trigger: t_t1_geo_v_raepa_canalaep_l on m_raepa.geo_v_raepa_canalaep_l

-- DROP TRIGGER t_t1_geo_v_raepa_canalaep_l ON m_raepa.geo_v_raepa_canalaep_l;

CREATE TRIGGER t_t1_geo_v_raepa_canalaep_l
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON m_raepa.geo_v_raepa_canalaep_l
  FOR EACH ROW
  EXECUTE PROCEDURE m_raepa.ft_m_geo_v_raepa_canalaep_l();  
