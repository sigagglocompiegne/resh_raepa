/**************/
/* POSTGRESQL */
/***********************************/
/* CREATIONS DES VUES DE RECONSTITUTION DU STANDARD RAEPA */
/***********************************/

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                           RECONSTITUTION DES VUES                                                            ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- #################################################################### VUE CANALISATION AEP ###############################################
       
-- View: x_opendata.x_opendata_geo_vmr_raepa_canalaep_l

-- DROP MATERIALIZED VIEW x_opendata.x_opendata_geo_vmr_raepa_canalaep_l;
CREATE MATERIALIZED VIEW x_opendata.x_opendata_geo_vmr_raepa_canalaep_l AS  --Rafraichît lors de chaque intégration de données via FME
 SELECT 
  e.idobjet as "IDCANA",
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
  t.idnini as "IDNINI",
  t.idnterm as "IDNTERM",
  character varying (254) 'null' as "IDCANPPALE",
  c.distgen as "PROFGEN",
  o.andebpose as "ANDEBPOSE",
  t.longmes as "LONGCANA",
  c.nbranche as "NBRANCHE",
  o.qualglocxy as "QUALGLOCXY",
  o.qualglocz as "QUALGLOCZ", 
  o.datemaj as "DATEMAJ",
  o.sourmaj as "SOURMAJ",
  o.qualannee as "QUALANNEE",
  o.dategeoloc as "DATEGEOLOC",
  o.sourgeoloc as "SOURGEOLOC",
  o.sourattrib as "SOURATTRIB",
  t.geom
  
FROM m_raepa.an_raepa_canalae e
LEFT JOIN m_raepa.an_raepa_canal c  ON e.idobjet = c.idobjet
LEFT JOIN m_raepa.an_raepal_objet_reseau o  ON e.idobjet = o.idobjet
LEFT JOIN m_raepa.geo_raepal_tronc t ON t.idtronc = c.idtronc
LEFT JOIN m_raepa.lt_raepal_materiau m ON m.code_arc = o.materiau
LEFT JOIN m_raepa.lt_raepal_contcanaep z ON z.code_arc = e.contcanaep
ORDER BY e.idobjet;

COMMENT ON MATERIALIZED VIEW x_opendata.x_opendata_geo_vmr_raepa_canalaep_l
  IS 'Vue matérialisée contenant les informations des canalisations d''adduction d''eau selon le standard RAEPA. Rafraichît lors de chaque intégration de données via FME';




-- #################################################################### VUE CANALISATION ASS ###############################################

-- View: x_opendata.x_opendata_geo_vmr_raepa_canalass_l

-- DROP MATERIALIZED VIEW x_opendata.x_opendata_geo_vmr_raepa_canalass_l;

CREATE MATERIALIZED VIEW x_opendata.x_opendata_geo_vmr_raepa_canalass_l AS 
 SELECT 
  a.idobjet as "IDCANA",
  o.mouvrage as "MOUVRAGE",
  o.gexploit as "GEXPLOIT", 
  o.enservice as "ENSERVICE",
  c.branchemnt as "BRANCHMNT",
  a.typreseau as "TYPRESEAU",  
  m.code_raepa as "MATERIAU",
  c.diametre as "DIAMETRE",  
  o.anfinpose as "ANFINPOSE",
  c.modecirc as "MODECIRC",
  a.contcanass as "CONTCANASS",
  a.fonccanass as "FONCCANASS",     
  t.idnini as "IDNINI",
  t.idnterm as "IDNTERM",
  character varying (254) 'null' as "IDCANPPALE",
  c.zamont as "ZAMONT",
  c.zaval as "ZAVAL",
  z.code_raepa as "SENSECOUL",
  o.andebpose as "ANDEBPOSE",
  t.longmes as "LONGCANA",
  c.nbranche as "NRBANCHE",
  o.qualglocxy as "QUALGLOCXY",
  o.qualglocz as "QUALGLOCZ", 
  o.datemaj as "DATEMAJ",
  o.sourmaj as "SOURMAJ",
  o.qualannee as "QUALANNEE",
  o.dategeoloc as "DATEGEOLOC",
  o.sourgeoloc as "SOURGEOLOC",
  o.sourattrib as "SOURATTRIB",
  t.geom
  
FROM m_raepa.an_raepa_canalass a
LEFT JOIN m_raepa.an_raepa_canal c ON c.idobjet = a.idobjet
LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = a.idobjet
LEFT JOIN m_raepa.geo_raepal_tronc t ON t.idtronc = c.idtronc
LEFT JOIN m_raepa.lt_raepal_materiau m ON m.code_arc = o.materiau
LEFT JOIN m_raepa.lt_raepal_sensecoul z ON z.code = t.sensecoul
ORDER BY a.idobjet;

COMMENT ON MATERIALIZED VIEW x_opendata.x_opendata_geo_vmr_raepa_canalass_l
  IS 'Vue matérialisée contenant les informations des canalisations d''assainissement collectif selon le standard RAEPA. Rafraichît lors de chaque intégration de données via FME';


-- #################################################################### VUE APPAREILLAGE AEP ###############################################


-- View: x_opendata.x_opendata_raepa_geo_vmr_apparaep_p

-- DROP MATERIALIZED VIEW x_opendata.x_opendata_geo_vmr_raepa_apparaep_p;

CREATE MATERIALIZED VIEW x_opendata.x_opendata_geo_vmr_raepa_apparaep_p AS 
 SELECT
  e.idobjet as "IDAPPAREIL",
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
  a.idouvrage as "IDOUVRAGE",  -- prb si on gère séquence unique de noeud sans gérer sequence ouvrage et appareil
  a.zradapp as "Z",
  o.andebpose as "ANDEBPOSE",      
  o.qualglocxy as "QUALGLOCXY",
  o.qualglocz as "QUALGLOCZ", 
  o.datemaj as "DATEMAJ",
  o.sourmaj as "SOURMAJ",
  o.qualannee as "QUALANNEE",
  o.dategeoloc as "DATEGEOLOC",
  o.sourgeoloc as "SOURGEOLOC",
  o.sourattrib as "SOURATTRIB",
  n.geom

FROM m_raepa.an_raepa_appae e  
LEFT JOIN m_raepa.an_raepa_app a ON a.idobjet = e.idobjet
LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = e.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud n ON n.idnoeud = a.idnoeud
LEFT JOIN m_raepa.lt_raepal_fnappaep z ON z.code_arc = e.fnappaep
ORDER BY e.idobjet;

COMMENT ON MATERIALIZED VIEW x_opendata.x_opendata_geo_vmr_raepa_apparaep_p
  IS 'Vue matérialisée contenant les informations des appareillages d''adduction d''eau selon le standard RAEPA. Rafraichît lors de chaque intégration de données via FME';


-- #################################################################### VUE APPAREILLAGE ASS ###############################################


-- View: x_opendata.x_opendata_geo_vmr_raepa_apparass_p

-- DROP VIEW x_opendata.x_opendata_geo_vmr_raepa_apparass_p;

CREATE MATERIALIZED VIEW x_opendata.x_opendata_geo_vmr_raepa_apparass_p AS 
 SELECT
  z.idobjet as "IDAPPAREIL",
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
  a.idouvrage as "IDOUVRAGE",
  a.zradapp as "Z",
  o.andebpose as "ANDEBPOSE",      
  o.qualglocxy as "QUALGLOCXY",
  o.qualglocz as "QUALGLOCZ", 
  o.datemaj as "DATEMAJ",
  o.sourmaj as "SOURMAJ",
  o.qualannee as "QUALANNEE",
  o.dategeoloc as "DATEGEOLOC",
  o.sourgeoloc as "SOURGEOLOC",
  o.sourattrib as "SOURATTRIB",
  n.geom

FROM m_raepa.an_raepa_appass z
LEFT JOIN m_raepa.an_raepa_app a ON a.idobjet = z.idobjet
LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = a.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud n ON a.idnoeud = n.idnoeud
LEFT JOIN m_raepa.lt_raepal_fnappass fn ON fn.code_arc = z.fnappass
ORDER BY z.idobjet;

COMMENT ON MATERIALIZED VIEW x_opendata.x_opendata_geo_vmr_raepa_apparass_p
  IS 'Vue matérialisée contenant les informations des appareillages d''assanissement collectif selon le standard RAEPA. Rafraichît lors de chaque intégration de données via FME';



-- #################################################################### VUE OUVRAGE AEP ###############################################

-- View: x_opendata.x_opendata_geo_vmr_raepa_ouvraep_p

-- DROP MATERIALIZED VIEW x_opendata.x_opendata_geo_vmr_raepa_ouvraep_p;

CREATE MATERIALIZED VIEW x_opendata.x_opendata_geo_vmr_raepa_ouvraep_p AS 
 SELECT
  oe.idobjet as "IDOUVRAGE",
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
  o.datemaj as "DATEMAJ",
  o.sourmaj as "SOURMAJ",
  o.qualannee as "QUALANNEE",
  o.dategeoloc as "DATEGEOLOC",
  o.sourgeoloc as "SOURGEOLOC",
  o.sourattrib as "SOURATTRIB",
  n.geom

FROM m_raepa.an_raepa_ouvae oe
LEFT JOIN m_raepa.an_raepa_ouv ouv ON ouv.idobjet = oe.idobjet
LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = ouv.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud n ON n.idnoeud = ouv.idnoeud
LEFT JOIN m_raepa.lt_raepal_fnouvaep z ON z.code_arc = oe.fnouvaep
ORDER BY oe.idobjet;

COMMENT ON MATERIALIZED VIEW x_opendata.x_opendata_geo_vmr_raepa_ouvraep_p
  IS 'Vue matérialisée contenant les informations des ouvrages d''adduction d''eau selon le standard RAEPA. Rafraichît lors de chaque intégration de données via FME';


-- #################################################################### VUE OUVRAGE ASS ###############################################

-- View: x_opendata.x_opendata_geo_vmr_raepa_ouvrass_p

-- DROP MATERIALIZED VIEW x_opendata.x_opendata_geo_vmr_raepa_ouvrass_p;

CREATE MATERIALIZED VIEW x_opendata.x_opendata_geo_vmr_raepa_ouvrass_p AS 
 SELECT
  oa.idobjet as "IDOUVRAGE",
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
  o.datemaj as "DATEMAJ",
  o.sourmaj as "SOURMAJ",
  o.qualannee as "QUALANNEE",
  o.dategeoloc as "DATEGEOLOC",
  o.sourgeoloc as "SOURGEOLOC",
  o.sourattrib as "SOURATTRIB",
  n.geom

FROM m_raepa.an_raepa_ouvass oa
LEFT JOIN m_raepa.an_raepa_ouv ouv ON ouv.idobjet = oa.idobjet
LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = oa.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud n ON n.idnoeud = ouv.idnoeud
LEFT JOIN m_raepa.lt_raepal_fnouvass z ON z.code_arc = oa.fnouvass
ORDER BY oa.idobjet;

COMMENT ON MATERIALIZED VIEW x_opendata.x_opendata_geo_vmr_raepa_ouvrass_p
  IS 'Vue matérialisée contenant les informations des ouvrages d''assainissement collectif selon le standard RAEPA. Rafraichît lors de chaque intégration de données via FME';

/*
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
  */