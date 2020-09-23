/*
Réseau d'eau pluviale
Creation du des templates pour gabarit RAEPA strict
init_bd_resh_40_raepa_templates.sql
PostGIS
GeoCompiegnois - http://geo.compiegnois.fr/
Auteur : Léandre Béron
*/
/****************************************************************************/
/*                            FICHIERS RAEPA                                */
/****************************************************************************/
-- canalaep_l
CREATE OR REPLACE VIEW m_raepa.template_RAEPA_CANALAEP_L AS
 SELECT 
  e.idobjet::character varying (254) as "IDCANA",
  o.mouvrage as "MOUVRAGE",
  o.gexploit as "GEXPLOIT", 
  o.enservice as "ENSERVICE",
  c.branchemnt as "BRANCHEMNT",
  m.code_raepa as "MATERIAU",
  c.diametre as "DIAMETRE",  
  o.anfinpose as "ANFINPOSE",
  c.modecirc as "MODECIRC",
  z.code_raepa as "CONTCANAEP",
  e.fonccanaep as "FONCCANAEP",     
  t.idnini::character varying (254) as "IDNINI",
  t.idnterm::character varying (254) as "IDNTERM",
  character varying (254) 'null' as "IDCANPPALE",
  c.distgen as "PROFGEN",
  o.andebpose as "ANDEBPOSE",
  t.longmes as "LONGCANA",
  c.nbranche as "NBRANCHE",
  o.qualglocxy as "QUALGLOCXY",
  o.qualglocz as "QUALGLOCZ", 
  o.datemaj::date as "DATEMAJ",
  o.sourmaj as "SOURMAJ",
  o.qualannee as "QUALANNEE",
  o.dategeoloc::date as "DATEGEOLOC",
  o.sourgeoloc as "SOURGEOLOC",
  o.sourattrib as "SOURATTRIB",
  t.geom
  
FROM m_raepa.an_raepa_canalae e
LEFT JOIN m_raepa.an_raepa_canal c  ON e.idobjet = c.idobjet
LEFT JOIN m_raepa.an_raepal_objet_reseau o  ON e.idobjet = o.idobjet
LEFT JOIN m_raepa.geo_raepal_tronc t ON t.idtronc = c.idtronc
LEFT JOIN m_raepa.lt_raepal_materiau m ON m.code_arc = o.materiau
LEFT JOIN m_raepa.lt_raepal_contcanaep z ON z.code_arc = e.contcanaep
WHERE e.idobjet = 0 -- pour ne rien récupérer
ORDER BY e.idobjet;
--DELETE FROM m_raepa.template_RAEPA_CANALAEP_L;

-- canalass_l
CREATE OR REPLACE VIEW m_raepa.template_RAEPA_CANALASS_L AS 
 SELECT 
  a.idobjet::character varying (254) as "IDCANA",
  o.mouvrage as "MOUVRAGE",
  o.gexploit as "GEXPLOIT", 
  o.enservice as "ENSERVICE",
  c.branchemnt as "BRANCHEMNT",
  a.typreseau as "TYPRESEAU",  
  m.code_raepa as "MATERIAU",
  c.diametre as "DIAMETRE",  
  o.anfinpose as "ANFINPOSE",
  c.modecirc as "MODECIRC",
  a.contcanass as "CONTCANASS",
  a.fonccanass as "FONCCANASS",     
  t.idnini::character varying (254) as "IDNINI",
  t.idnterm::character varying (254) as "IDNTERM",
  character varying (254) 'null' as "IDCANPPALE",
  c.zamont as "ZAMONT",
  c.zaval as "ZAVAL",
  z.code_raepa as "SENSECOUL",
  o.andebpose as "ANDEBPOSE",
  t.longmes as "LONGCANA",
  c.nbranche as "NBRANCHE",
  o.qualglocxy as "QUALGLOCXY",
  o.qualglocz as "QUALGLOCZ", 
  o.datemaj::date as "DATEMAJ",
  o.sourmaj as "SOURMAJ",
  o.qualannee as "QUALANNEE",
  o.dategeoloc::date as "DATEGEOLOC",
  o.sourgeoloc as "SOURGEOLOC",
  o.sourattrib as "SOURATTRIB",
  t.geom
  
FROM m_raepa.an_raepa_canalass a
LEFT JOIN m_raepa.an_raepa_canal c ON c.idobjet = a.idobjet
LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = a.idobjet
LEFT JOIN m_raepa.geo_raepal_tronc t ON t.idtronc = c.idtronc
LEFT JOIN m_raepa.lt_raepal_materiau m ON m.code_arc = o.materiau
LEFT JOIN m_raepa.lt_raepal_sensecoul z ON z.code = t.sensecoul
WHERE a.idobjet = 0 --pour ne rien récupérer
ORDER BY a.idobjet;



-- apparaep_p
CREATE OR REPLACE VIEW m_raepa.template_RAEPA_APPARAEP_P AS 
 SELECT
  e.idobjet::character varying (254) as "IDAPPAREIL",
  n.x as "X",
  n.y as "Y",
  o.mouvrage as "MOUVRAGE",
  o.gexploit as "GEXPLOIT",
  z.code_raepa as "FNAPPAEP",
  o.anfinpose as "ANFINPOSE",
  a.diametre as "DIAMETRE", -- A PRIORI soit : attribut manquant dans la modélisation à ce niveau car présent dans les gabarits des livrables d'appareillage ae et ass et absent pour les ouvrages / soit : attribut implémenté et qui ne devrait pas l'être / MCD
  character varying (254) 'null' as "IDCANAMONT",
  character varying (254) 'null' as "IDCANAVAL",  
  character varying (254) 'null' as "IDCANPPALE",
  a.idouvrage::character varying (254) as "IDOUVRAGE",  -- prb si on gère séquence unique de noeud sans gérer sequence ouvrage et appareil
  a.zradapp as "Z",
  o.andebpose as "ANDEBPOSE",      
  o.qualglocxy as "QUALGLOCXY",
  o.qualglocz as "QUALGLOCZ", 
  o.datemaj::date as "DATEMAJ",
  o.sourmaj as "SOURMAJ",
  o.qualannee as "QUALANNEE",
  o.dategeoloc::date as "DATEGEOLOC",
  o.sourgeoloc as "SOURGEOLOC",
  o.sourattrib as "SOURATTRIB",
  n.geom

FROM m_raepa.an_raepa_appae e  
LEFT JOIN m_raepa.an_raepa_app a ON a.idobjet = e.idobjet
LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = e.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud n ON n.idnoeud = a.idnoeud
LEFT JOIN m_raepa.lt_raepal_fnappaep z ON z.code_arc = e.fnappaep
WHERE e.idobjet = 0 --pour ne rien récupérer
ORDER BY e.idobjet;



-- apparass_p
CREATE OR REPLACE VIEW m_raepa.template_RAEPA_APPARASS_P AS 
 SELECT
  z.idobjet::character varying (254) as "IDAPPAREIL",
  n.x as "X",
  n.y as "Y",
  o.mouvrage as "MOUVRAGE",
  o.gexploit as "GEXPLOIT",
  z.typreseau as "TYPRESEAU",
  fn.code_raepa as "FNAPPASS",
  o.anfinpose as "ANFINPOSE",
  a.diametre as "DIAMETRE", 
  character varying (254) 'null' as "IDCANAMONT",
  character varying (254) 'null' as "IDCANAVAL",  
  character varying (254) 'null' as "IDCANPPALE",
  a.idouvrage::character varying (254) as "IDOUVRAGE",
  a.zradapp as "Z",
  o.andebpose as "ANDEBPOSE",      
  o.qualglocxy as "QUALGLOCXY",
  o.qualglocz as "QUALGLOCZ", 
  o.datemaj::date as "DATEMAJ",
  o.sourmaj as "SOURMAJ",
  o.qualannee as "QUALANNEE",
  o.dategeoloc::date as "DATEGEOLOC",
  o.sourgeoloc as "SOURGEOLOC",
  o.sourattrib as "SOURATTRIB",
  n.geom

FROM m_raepa.an_raepa_appass z
LEFT JOIN m_raepa.an_raepa_app a ON a.idobjet = z.idobjet
LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = a.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud n ON a.idnoeud = n.idnoeud
LEFT JOIN m_raepa.lt_raepal_fnappass fn ON fn.code_arc = z.fnappass
WHERE z.idobjet = 0 --pour ne rien récupérer
ORDER BY z.idobjet;

-- ouvraep_p
CREATE OR REPLACE VIEW m_raepa.template_RAEPA_OUVRAEP_P AS 
 SELECT
  oe.idobjet::character varying (254) as "IDOUVRAGE",
  n.x as "X",
  n.y as "Y",
  o.mouvrage as "MOUVRAGE",
  o.gexploit as "GEXPLOIT",
  z.code_raepa as "FNOUVAEP",
  o.anfinpose as "ANFINPOSE",
  character varying (254) 'null' as "IDCANAMONT", 
  character varying (254) 'null' as "IDCANAVAL",  
  character varying (254) 'null' as "IDCANPPALE",
  ouv.zradouv as "Z",
  o.andebpose as "ANDEBPOSE",      
  o.qualglocxy as "QUALGLOCXY",
  o.qualglocz as "QUALGLOCZ", 
  o.datemaj::date as "DATEMAJ",
  o.sourmaj as "SOURMAJ",
  o.qualannee as "QUALANNEE",
  o.dategeoloc::date as "DATEGEOLOC",
  o.sourgeoloc as "SOURGEOLOC",
  o.sourattrib as "SOURATTRIB",
  n.geom

FROM m_raepa.an_raepa_ouvae oe
LEFT JOIN m_raepa.an_raepa_ouv ouv ON ouv.idobjet = oe.idobjet
LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = ouv.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud n ON n.idnoeud = ouv.idnoeud
LEFT JOIN m_raepa.lt_raepal_fnouvaep z ON z.code_arc = oe.fnouvaep
WHERE oe.idobjet = 0 --pour ne rien récupérer
ORDER BY oe.idobjet;

-- ouvrass_p
CREATE OR REPLACE VIEW m_raepa.template_RAEPA_OUVRASS_P AS 
 SELECT
  oa.idobjet::character varying (254) as "IDOUVRAGE",
  n.x as "X",
  n.y as "Y",
  o.mouvrage as "MOUVRAGE",
  o.gexploit as "GEXPLOIT",
  oa.typreseau as "TYPRESEAU",
  z.code_raepa as "FNOUVASS",
  o.anfinpose as "ANFINPOSE",
  character varying (254) 'null' as "IDCANAMONT",
  character varying (254) 'null' as "IDCANAVAL",
  character varying (254) 'null' as "IDCANPPALE",
  ouv.zradouv as "Z",
  o.andebpose as "ANDEBPOSE",      
  o.qualglocxy as "QUALGLOCXY",
  o.qualglocz as "QUALGLOCZ", 
  o.datemaj::date as "DATEMAJ",
  o.sourmaj as "SOURMAJ",
  o.qualannee as "QUALANNEE",
  o.dategeoloc::date as "DATEGEOLOC",
  o.sourgeoloc as "SOURGEOLOC",
  o.sourattrib as "SOURATTRIB",
  n.geom

FROM m_raepa.an_raepa_ouvass oa
LEFT JOIN m_raepa.an_raepa_ouv ouv ON ouv.idobjet = oa.idobjet
LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = oa.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud n ON n.idnoeud = ouv.idnoeud
LEFT JOIN m_raepa.lt_raepal_fnouvass z ON z.code_arc = oa.fnouvass
WHERE oa.idobjet = 0 -- pour ne rien récupérer
ORDER BY oa.idobjet;
--DELETE FROM m_raepa.template_RAEPA_OUVRASS_P;


/****************************************************************************/
/*                               LISTES RAEPA                               */
/****************************************************************************/
--DROP VIEW m_raepa.template_lt_raepa_materiau;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepa_materiau AS 
SELECT 
code_raepa as code, valeur
FROM m_raepa.lt_raepal_materiau WHERE code_raepa != '99'
union all
select
'99' as code_raepa, 'Autre' as valeur;

--DROP VIEW m_raepa.template_lt_raepa_sensecoul;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepa_sensecoul AS 
SELECT 
code_raepa as code, code_raepa as valeur
FROM m_raepa.lt_raepal_sensecoul;

--DROP VIEW m_raepa.template_lt_raepa_boolean;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepa_boolean AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepa_boolean;

--DROP VIEW m_raepa.template_lt_raepa_modecirc;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepa_modecirc AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepa_modecirc;


--DROP VIEW m_raepa.template_lt_raepal_contcanaep;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_contcanaep AS 
SELECT 
code_raepa as code, valeur
FROM m_raepa.lt_raepal_contcanaep WHERE code_raepa != '99'
union all
select
'99' as code_raepa, 'Autre' as valeur;

--DROP VIEW m_raepa.template_lt_raepa_fonccanaep;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepa_fonccanaep AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepa_fonccanaep;

--DROP VIEW m_raepa.template_lt_raepal_fnappaep;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_fnappaep AS 
SELECT 
code_raepa as code, valeur
FROM m_raepa.lt_raepal_fnappaep WHERE code_raepa != '99'
union all
select
'99' as code_raepa, 'Autre' as valeur;

--DROP VIEW m_raepa.template_lt_raepal_fnouvaep;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_fnouvaep AS 
SELECT 
code_raepa as code, valeur
FROM m_raepa.lt_raepal_fnouvaep WHERE code_raepa != '99'
union all
select
'99' as code_raepa, 'Autre' as valeur;

--DROP VIEW m_raepa.template_lt_raepa_fonccanass;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepa_fonccanass AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepa_fonccanass;

--DROP VIEW m_raepa.template_lt_raepa_fonccanass;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepa_contcanass AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepa_contcanass;

--DROP VIEW m_raepa.template_lt_raepa_typreseau;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepa_typreseau AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepa_typreseau;


--DROP VIEW m_raepa.template_lt_raepal_fnappass;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_fnappass AS 
SELECT 
code_raepa as code, valeur
FROM m_raepa.lt_raepal_fnappass WHERE code_raepa != '99'
union all
select
'99' as code_raepa, 'Autre' as valeur;

--DROP VIEW m_raepa.template_lt_raepal_fnouvass;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_fnouvass AS 
SELECT 
code_raepa as code, valeur
FROM m_raepa.lt_raepal_fnouvass WHERE code_raepa != '99'
union all
select
'99' as code_raepa, 'Autre' as valeur;

--DROP VIEW m_raepa.template_lt_raepa_qualgloc;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepa_qualgloc AS 
SELECT
code, valeur
FROM m_raepa.lt_raepa_qualgloc;

--DROP VIEW m_raepa.template_lt_raepa_qualannee;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepa_qualanee AS 
SELECT
code, valeur
FROM m_raepa.lt_raepa_qualannee;

-- support incident
-- defaillance





















