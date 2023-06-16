/*RAEPA V1.2*/
/*Creation du squelette des vues templates RAEPA étendu */
/*init_bd_resh_42_raepal_template.sql */
/*PostGIS*/

/* GeoCompiegnois - https://geo.compiegnois.fr/ */
/* Auteur : Florent Vanhoutte, reprit par Léandre Béron et Kévin Messager*/

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                         ASS                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- ################################################################# ouvrage ass ###############################################


-- AVALOIR ASS

DROP VIEW m_raepa.template_raepal_ass_ouv_avaloir;
CREATE OR REPLACE VIEW m_raepa.template_raepal_ass_ouv_avaloir AS 
 SELECT
-- m_raepa.an_raepa_ouvass
  --oa.idobjet,
  oa.idprod,
  oa.typreseau,
  oa.fnouvass, 
-- m_raepa.an_raepal_avaloir_ass
  --e.idobjet,
  --e.idprod,
  e.l_typaval,
  e.l_nivvoiri,
  e.l_decant,
  e.l_dimgrill,
  e.l_modpass,
-- m_raepa.an_raepa_ouv
  --o.idobjet,
  --o.idprod,
  o.zradouv,
  o.l_nom,
  o.l_typimpl,
  o.l_ztn,
  o.l_profond,
  o.l_acces,
  o.l_nbapp,
  --o.idnoeud,
-- m_raepa.geo_raepa_noeud
  --g.idnoeud,
  --g.x,
  --g.y,
  g.geom,
  g.l_xreel,
  g.l_yreel,    
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepal_avaloir_ass e
LEFT JOIN m_raepa.an_raepa_ouvass oa ON oa.idobjet = e.idobjet
LEFT JOIN m_raepa.an_raepa_ouv o ON o.idobjet = e.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud g ON g.idnoeud = o.idnoeud
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = e.idobjet
WHERE e.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY e.idobjet;


-- REGARD ASS
DROP VIEW m_raepa.template_raepal_ass_ouv_regard;
CREATE OR REPLACE VIEW m_raepa.template_raepal_ass_ouv_regard AS 
 SELECT
-- m_raepa.an_raepa_ouvass
  --oa.idobjet,
  oa.idprod,
  oa.typreseau,
  oa.fnouvass, 
-- m_raepa.an_raepal_regard_ass
  --e.idobjet,
  --e.idprod,
  e.l_typreg,
  e.l_visit,
  e.l_formreg,
  e.l_decant,
  e.l_tampon,
  e.l_grille,
  e.l_dimgrill,
-- m_raepa.an_raepa_ouv
  --o.idobjet,
  --o.idprod,
  o.zradouv,
  o.l_nom,
  o.l_typimpl,
  o.l_ztn,
  o.l_profond,
  o.l_acces,
  o.l_nbapp,
  --o.idnoeud,
-- m_raepa.geo_raepa_noeud
  --g.idnoeud,
  --g.x,
  --g.y,
  g.geom,
  g.l_xreel,
  g.l_yreel,    
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepal_regard_ass e
LEFT JOIN m_raepa.an_raepa_ouvass oa ON oa.idobjet = e.idobjet
LEFT JOIN m_raepa.an_raepa_ouv o ON o.idobjet = e.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud g ON g.idnoeud = o.idnoeud
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = e.idobjet
-- filtre d'exclusion des regards de type boite de branchement typreg = '03'
WHERE e.l_typreg <> '03' AND e.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY e.idobjet;



-- BOITE DE BRANCHEMENT (TYPE DE REGARD) ASS
DROP VIEW m_raepa.template_raepal_ass_ouv_regard_bt_brchmt;
CREATE OR REPLACE VIEW m_raepa.template_raepal_ass_ouv_regard_bt_brchmt AS 
 SELECT
-- m_raepa.an_raepa_ouvass
  --oa.idobjet,
  oa.idprod,
  oa.typreseau,
  oa.fnouvass, 
-- m_raepa.an_raepal_regard_ass
  --e.idobjet,
  --e.idprod,
  e.l_typreg,
  e.l_visit,
  e.l_formreg,
  e.l_decant,
  e.l_tampon,
  e.l_grille,
  e.l_dimgrill,
-- m_raepa.an_raepal_reg_bt_brchmt_ass
  --ee.idobjet,
  --ee.idprod,
  ee.l_typusage,  
-- m_raepa.an_raepa_ouv
  --o.idobjet,
  --o.idprod,
  o.zradouv,
  o.l_nom,
  o.l_typimpl,
  o.l_ztn,
  o.l_profond,
  o.l_acces,
  o.l_nbapp,
  --o.idnoeud,
-- m_raepa.geo_raepa_noeud
  --g.idnoeud,
  --g.x,
  --g.y,
  g.geom,
  g.l_xreel,
  g.l_yreel,    
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepal_reg_bt_brchmt_ass ee
LEFT JOIN m_raepa.an_raepal_regard_ass e ON e.idobjet = ee.idobjet
LEFT JOIN m_raepa.an_raepa_ouvass oa ON oa.idobjet = ee.idobjet
LEFT JOIN m_raepa.an_raepa_ouv o ON o.idobjet = ee.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud g ON g.idnoeud = o.idnoeud
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = ee.idobjet
WHERE ee.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY ee.idobjet;


-- STEP ASS
DROP VIEW m_raepa.template_raepal_ass_ouv_step;
CREATE OR REPLACE VIEW m_raepa.template_raepal_ass_ouv_step AS 
 SELECT
-- m_raepa.an_raepa_ouvass
  --oa.idobjet,
  oa.idprod,
  oa.typreseau,
  oa.fnouvass, 
-- m_raepa.an_raepal_step_ass
  --e.idobjet,
  --e.idprod,
  e.l_typstep,
  e.l_charge,
  e.l_capnomi,
-- m_raepa.an_raepa_ouv
  --o.idobjet,
  --o.idprod,
  o.zradouv,
  o.l_nom,
  o.l_typimpl,
  o.l_ztn,
  o.l_profond,
  o.l_acces,
  o.l_nbapp,
  --o.idnoeud,
-- m_raepa.geo_raepa_noeud
  --g.idnoeud,
  --g.x,
  --g.y,
  g.geom,
  g.l_xreel,
  g.l_yreel,    
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepal_step_ass e
LEFT JOIN m_raepa.an_raepa_ouvass oa ON oa.idobjet = e.idobjet
LEFT JOIN m_raepa.an_raepa_ouv o ON o.idobjet = e.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud g ON g.idnoeud = o.idnoeud
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = e.idobjet
WHERE e.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY e.idobjet;


-- BASSIN STOCKAGE ASS
DROP VIEW m_raepa.template_raepal_ass_ouv_bass_stock;
CREATE OR REPLACE VIEW m_raepa.template_raepal_ass_ouv_bass_stock AS 
 SELECT
-- m_raepa.an_raepa_ouvass
  --oa.idobjet,
  oa.idprod,
  oa.typreseau,
  oa.fnouvass, 
-- m_raepa.an_raepal_bass_stock_ass
  --e.idobjet,
  --e.idprod,
  e.l_typbass,
  e.l_telegest,
  e.l_zsurv,
-- m_raepa.an_raepa_ouv
  --o.idobjet,
  --o.idprod,
  o.zradouv,
  o.l_nom,
  o.l_typimpl,
  o.l_ztn,
  o.l_profond,
  o.l_acces,
  o.l_nbapp,
  --o.idnoeud,
-- m_raepa.geo_raepa_noeud
  --g.idnoeud,
  --g.x,
  --g.y,
  g.geom,
  g.l_xreel,
  g.l_yreel,    
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepal_bass_stock_ass e
LEFT JOIN m_raepa.an_raepa_ouvass oa ON oa.idobjet = e.idobjet
LEFT JOIN m_raepa.an_raepa_ouv o ON o.idobjet = e.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud g ON g.idnoeud = o.idnoeud
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = e.idobjet
WHERE e.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY e.idobjet;


-- STATION POMPAGE ASS
DROP VIEW m_raepa.template_raepal_ass_ouv_stat_pomp;
CREATE OR REPLACE VIEW m_raepa.template_raepal_ass_ouv_stat_pomp AS 
 SELECT
-- m_raepa.an_raepa_ouvass
  --oa.idobjet,
  oa.idprod,
  oa.typreseau,
  oa.fnouvass, 
-- m_raepa.an_raepal_stat_pomp_ass
  --e.idobjet,
  --e.idprod,
  e.l_typpompa,
  e.l_traith2s,
  e.l_troplein,
-- m_raepa.an_raepa_ouv
  --o.idobjet,
  --o.idprod,
  o.zradouv,
  o.l_nom,
  o.l_typimpl,
  o.l_ztn,
  o.l_profond,
  o.l_acces,
  o.l_nbapp,
  --o.idnoeud,
-- m_raepa.geo_raepa_noeud
  --g.idnoeud,
  --g.x,
  --g.y,
  g.geom,
  g.l_xreel,
  g.l_yreel,    
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepal_stat_pomp_ass e
LEFT JOIN m_raepa.an_raepa_ouvass oa ON oa.idobjet = e.idobjet
LEFT JOIN m_raepa.an_raepa_ouv o ON o.idobjet = e.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud g ON g.idnoeud = o.idnoeud
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = e.idobjet
WHERE e.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY e.idobjet;



-- OUVRAGE (AUTRE) ASS
DROP VIEW m_raepa.template_raepal_ass_ouv;
CREATE OR REPLACE VIEW m_raepa.template_raepal_ass_ouv AS 
 SELECT
-- m_raepa.an_raepa_ouvass
  --oa.idobjet,
  oa.idprod,
  oa.typreseau,
  oa.fnouvass,
-- m_raepa.an_raepa_ouv
  --o.idobjet,
  --o.idprod,
  o.zradouv,
  o.l_nom,
  o.l_typimpl,
  o.l_ztn,
  o.l_profond,
  o.l_acces,
  o.l_nbapp,
  --o.idnoeud,
-- m_raepa.geo_raepa_noeud
  --g.idnoeud,
  --g.x,
  --g.y,
  g.geom,
  g.l_xreel,
  g.l_yreel,    
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepa_ouvass oa
LEFT JOIN m_raepa.an_raepa_ouv o ON o.idobjet = oa.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud g ON g.idnoeud = o.idnoeud
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = oa.idobjet
-- filtre d'exclusion les sous classes d'ouvrageass spécialisées
WHERE oa.fnouvass NOT IN ('07-00','06-00','02-00','01-00','03-00') AND oa.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY oa.idobjet;



-- ################################################################# appareillage ass ###############################################


-- APPAREILLAGE ASS
DROP VIEW m_raepa.template_raepal_ass_app;
CREATE OR REPLACE VIEW m_raepa.template_raepal_ass_app AS 
 SELECT
-- m_raepa.an_raepa_appass
  --aa.idobjet,
  aa.idprod,
  aa.typreseau,
  aa.fnappass, 
-- m_raepa.an_raepa_app
  --a.idobjet,
  --a.idprod,
  a.idouvrage,
  a.diametre,
  a.zradapp,
  a.l_acces,
  --a.idnoeud,
-- m_raepa.geo_raepa_noeud
  --g.idnoeud,
  --g.x,
  --g.y,
  g.geom,
  g.l_xreel,
  g.l_yreel,    
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepa_appass aa
LEFT JOIN m_raepa.an_raepa_app a ON a.idobjet = aa.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud g ON g.idnoeud = a.idnoeud
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = aa.idobjet
WHERE aa.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY aa.idobjet;


-- ################################################################# canalisation ass ###############################################


-- CANALISATION ASS
DROP VIEW m_raepa.template_raepal_ass_can;
CREATE OR REPLACE VIEW m_raepa.template_raepal_ass_can AS 
 SELECT
-- m_raepa.an_raepa_canalass
  --ca.idobjet,
  ca.idprod,
  ca.typreseau,
  ca.contcanass,
  ca.fonccanass, 
-- m_raepa.an_raepa_canal
  --c.idobjet,
  --c.idprod,
  c.branchemnt,
  c.diametre,
  c.modecirc,
  c.nbranche,
  c.l_formcana,
  c.l_dim,
  c.l_protext,
  c.l_protint,
  c.l_ztn,
  c.l_zgen,
  c.zamont,
  c.zaval,
  c.l_pente,
  c.l_penter,
  c.distgen,
  c.l_autpass,
  --c.idtronc,
-- m_raepa.geo_raepal_tronc;
  --g.idtronc,
  g.sensecoul,
  g.longmes,
  --g.l_longcalc,
  g.idnini,
  g.idnterm,
  g.geom,
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepa_canalass ca
LEFT JOIN m_raepa.an_raepa_canal c ON c.idobjet = ca.idobjet
LEFT JOIN m_raepa.geo_raepal_tronc g ON g.idtronc = c.idtronc
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = ca.idobjet
-- filtre d'exclusion des canalisations de branchement (branchemnt = '0')
WHERE c.branchemnt = 'N' AND ca.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY ca.idobjet;


-- BRANCHEMENT CANALISATION ASS
DROP VIEW m_raepa.template_raepal_ass_can_brcht;
CREATE OR REPLACE VIEW m_raepa.template_raepal_ass_can_brcht AS 
 SELECT
-- m_raepa.an_raepa_canalass
  --ca.idobjet,
  ca.idprod,
  ca.typreseau,
  ca.contcanass,
  ca.fonccanass,
-- m_raepa.an_raepal_brcht_ass
  --e.idobjet,
  --e.idprod,
  e.l_typracc,
  e.l_conform,   
-- m_raepa.an_raepa_canal
  --c.idobjet,
  --c.idprod,
  c.branchemnt,
  c.diametre,
  c.modecirc,
  c.nbranche,
  c.l_formcana,
  c.l_dim,
  c.l_protext,
  c.l_protint,
  c.l_ztn,
  c.l_zgen,
  c.zamont,
  c.zaval,
  c.l_pente,
  c.l_penter,
  c.distgen,
  c.l_autpass,
  --c.idtronc,
-- m_raepa.geo_raepal_tronc;
  --g.idtronc,
  g.sensecoul,
  g.longmes,
  --g.l_longcalc,
  g.idnini,
  g.idnterm,
  g.geom,
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepal_brcht_ass e
LEFT JOIN m_raepa.an_raepa_canalass ca ON ca.idobjet = e.idobjet
LEFT JOIN m_raepa.an_raepa_canal c ON c.idobjet = e.idobjet
LEFT JOIN m_raepa.geo_raepal_tronc g ON g.idtronc = c.idtronc
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = e.idobjet
-- filtre d'exclusion des canalisations principales
WHERE c.branchemnt = 'O' AND e.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY e.idobjet;


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                         AEP                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- ################################################################# canalisation aep ################################################################

-- CANALISATION AEP 
DROP VIEW m_raepa.template_raepal_aep_can;
CREATE OR REPLACE VIEW m_raepa.template_raepal_aep_can AS
  SELECT
-- m_raepa.an_an_canalae
 -- ce.idobjet,
  ce.idprod,
  ce.contcanaep,
  ce.fonccanaep,
  ce.l_pression,
  ce.l_protcath,
  ce.l_indperte,
-- m_raepa.an_raepa_canal
  --c.idobjet,
  --c.idprod,
  c.branchemnt,
  c.diametre,
  c.modecirc,
  c.nbranche,
  c.l_formcana,
  c.l_dim,
  c.l_protext,
  c.l_protint,
  c.l_ztn,
  c.l_zgen,
  c.zamont,
  c.zaval,
  c.l_pente,
  c.l_penter,
  c.distgen,
  c.l_autpass,
  --c.idtronc,
-- m_raepa.geo_raepal_tronc;
  --g.idtronc,
  g.sensecoul,
  g.longmes,
  --g.l_longcalc,
  g.idnini,
  g.idnterm,
  g.geom,
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepa_canalae ce
LEFT JOIN m_raepa.an_raepa_canal c ON c.idobjet = ce.idobjet
LEFT JOIN m_raepa.geo_raepal_tronc g ON g.idtronc = c.idtronc
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = ce.idobjet
-- filtre d'exclusion des canalisations de branchement (branchemnt = '0')
WHERE c.branchemnt = 'N' AND ce.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY ce.idobjet;


-- ################################################################# ouvrage aep ###############################################

-- OUVRAGES AEP 
DROP VIEW m_raepa.template_raepal_aep_ouv;
CREATE OR REPLACE VIEW m_raepa.template_raepal_aep_ouv AS 
 SELECT
-- m_raepa.an_raepa_ouvae
  --oe.idobjet,
  oe.idprod,
  oe.fnouvaep,
-- m_raepa.an_raepa_ouv
  --o.idobjet,
  --o.idprod,
  o.zradouv,
  o.l_nom,
  o.l_typimpl,
  o.l_ztn,
  o.l_profond,
  o.l_acces,
  o.l_nbapp,
  --o.idnoeud,
-- m_raepa.geo_raepa_noeud
  --g.idnoeud,
  --g.x,
  --g.y,
  g.geom,
  g.l_xreel,
  g.l_yreel,    
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepa_ouvae oe
LEFT JOIN m_raepa.an_raepa_ouv o ON o.idobjet = oe.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud g ON g.idnoeud = o.idnoeud
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = oe.idobjet
-- filtre d'exclusion les sous classes d'ouvrageass spécialisées
WHERE oe.fnouvaep NOT IN ('07-00','06-00','02-00','01-00','03-00') AND oe.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY oe.idobjet;


-- STATION POMPAGE AEP
DROP VIEW m_raepa.template_raepal_aep_ouv_stat_pomp;
CREATE OR REPLACE VIEW m_raepa.template_raepal_aep_ouv_stat_pomp AS 
 SELECT
-- m_raepa.an_raepa_ouvae
  --oe.idobjet,
  oe.idprod,
  oe.fnouvaep,
-- m_raepa.an_raepal_stat_pomp_ae
  --e.idobjet,
  --e.idprod,
  e.l_typpomp,
  e.l_debit,
  e.l_hmano,
-- m_raepa.an_raepa_ouv
  --o.idobjet,
  --o.idprod,
  o.zradouv,
  o.l_nom,
  o.l_typimpl,
  o.l_ztn,
  o.l_profond,
  o.l_acces,
  o.l_nbapp,
  --o.idnoeud,
-- m_raepa.geo_raepa_noeud
  --g.idnoeud,
  --g.x,
  --g.y,
  g.geom,
  g.l_xreel,
  g.l_yreel,    
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepal_stat_pomp_ae e
LEFT JOIN m_raepa.an_raepa_ouvae oe ON oe.idobjet = e.idobjet
LEFT JOIN m_raepa.an_raepa_ouv o ON o.idobjet = e.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud g ON g.idnoeud = o.idnoeud
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = e.idobjet
WHERE e.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY e.idobjet;


-- STATION DE TRAITEMENT AEP

DROP VIEW m_raepa.template_raepal_aep_ouv_stat_trait;
CREATE OR REPLACE VIEW m_raepa.template_raepal_aep_ouv_stat_trait AS 
 SELECT
-- m_raepa.an_raepa_ouvae
  --oe.idobjet,
  oe.idprod,
  oe.fnouvaep,
-- m_raepa.an_raepal_stat_trait_ae
  --o.idobjet,
  --o.idprod,
  e.l_idars,
  e.l_typtrait,
  e.l_capacite,
-- m_raepa.an_raepa_ouv
  --o.idobjet,
  --o.idprod,
  o.zradouv,
  o.l_nom,
  o.l_typimpl,
  o.l_ztn,
  o.l_profond,
  o.l_acces,
  o.l_nbapp,
  --o.idnoeud,
-- m_raepa.geo_raepa_noeud
  --g.idnoeud,
  --g.x,
  --g.y,
  g.geom,
  g.l_xreel,
  g.l_yreel,    
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepal_stat_trait_ae e
LEFT JOIN m_raepa.an_raepa_ouvae oe ON oe.idobjet = e.idobjet
LEFT JOIN m_raepa.an_raepa_ouv o ON o.idobjet = e.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud g ON g.idnoeud = o.idnoeud
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = e.idobjet
WHERE e.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY e.idobjet;


-- RESERVOIR AEP

DROP VIEW m_raepa.template_raepal_aep_ouv_reservoir;
CREATE OR REPLACE VIEW m_raepa.template_raepal_aep_ouv_reservoir AS 
 SELECT
-- m_raepa.an_raepa_ouvae
  --oe.idobjet,
  oe.idprod,
  oe.fnouvaep,
-- m_raepa.an_raepal_reservoir_ae
  e.l_typres,
  e.l_volume,
  e.l_ztp,
  e.l_nbcuve,
-- m_raepa.an_raepa_ouv
  --o.idobjet,
  --o.idprod,
  o.zradouv,
  o.l_nom,
  o.l_typimpl,
  o.l_ztn,
  o.l_profond,
  o.l_acces,
  o.l_nbapp,
  --o.idnoeud,
-- m_raepa.geo_raepa_noeud
  --g.idnoeud,
  --g.x,
  --g.y,
  g.geom,
  g.l_xreel,
  g.l_yreel,    
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepal_reservoir_ae e
LEFT JOIN m_raepa.an_raepa_ouvae oe ON oe.idobjet = e.idobjet
LEFT JOIN m_raepa.an_raepa_ouv o ON o.idobjet = e.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud g ON g.idnoeud = o.idnoeud
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = e.idobjet
WHERE e.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY e.idobjet;

-- CAPTAGE AEP
DROP VIEW m_raepa.template_raepal_aep_ouv_captage;
CREATE OR REPLACE VIEW m_raepa.template_raepal_aep_ouv_captage AS 
 SELECT
-- m_raepa.an_raepa_ouvae
  --oe.idobjet,
  oe.idprod,
  oe.fnouvaep,
-- m_raepa.an_raepal_captage_ae
  e.l_typcapt,
  e.l_idbss,
  e.l_debh,
  e.l_debj,
  e.l_deba,
-- m_raepa.an_raepa_ouv
  --o.idobjet,
  --o.idprod,
  o.zradouv,
  o.l_nom,
  o.l_typimpl,
  o.l_ztn,
  o.l_profond,
  o.l_acces,
  o.l_nbapp,
  --o.idnoeud,
-- m_raepa.geo_raepa_noeud
  --g.idnoeud,
  --g.x,
  --g.y,
  g.geom,
  g.l_xreel,
  g.l_yreel,    
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepal_captage_ae e
LEFT JOIN m_raepa.an_raepa_ouvae oe ON oe.idobjet = e.idobjet
LEFT JOIN m_raepa.an_raepa_ouv o ON o.idobjet = e.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud g ON g.idnoeud = o.idnoeud
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = e.idobjet
WHERE e.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY e.idobjet;

-- CITERNEAU AEP
DROP VIEW m_raepa.template_raepal_aep_ouv_citerneau;
CREATE OR REPLACE VIEW m_raepa.template_raepal_aep_ouv_citerneau AS 
 SELECT
-- m_raepa.an_raepa_ouvae
  --oe.idobjet,
  oe.idprod,
  oe.fnouvaep,
-- m_raepa.an_raepal_citerneau_ae
  --o.idobjet,
  --o.idprod,
  e.l_nbcompt,
  e.l_typusage,
-- m_raepa.an_raepa_ouv
  --o.idobjet,
  --o.idprod,
  o.zradouv,
  o.l_nom,
  o.l_typimpl,
  o.l_ztn,
  o.l_profond,
  o.l_acces,
  o.l_nbapp,
  --o.idnoeud,
-- m_raepa.geo_raepa_noeud
  --g.idnoeud,
  --g.x,
  --g.y,
  g.geom,
  g.l_xreel,
  g.l_yreel,    
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepal_citerneau_ae e
LEFT JOIN m_raepa.an_raepa_ouvae oe ON oe.idobjet = e.idobjet
LEFT JOIN m_raepa.an_raepa_ouv o ON o.idobjet = e.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud g ON g.idnoeud = o.idnoeud
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = e.idobjet
WHERE e.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY e.idobjet;

-- CHAMBRE AEP
DROP VIEW m_raepa.template_raepal_aep_ouv_chambr;
CREATE OR REPLACE VIEW m_raepa.template_raepal_aep_ouv_chambr AS 
 SELECT
-- m_raepa.an_raepa_ouvae
 -- oe.idobjet,
  oe.idprod,
  oe.fnouvaep,
-- m_raepa.an_raepal_chambr_ae
  --o.idobjet,
  --o.idprod,
  e.l_dim,
-- m_raepa.an_raepa_ouv
  --o.idobjet,
  --o.idprod,
  o.zradouv,
  o.l_nom,
  o.l_typimpl,
  o.l_ztn,
  o.l_profond,
  o.l_acces,
  o.l_nbapp,
  --o.idnoeud,
-- m_raepa.geo_raepa_noeud
  --g.idnoeud,
  --g.x,
  --g.y,
  g.geom,
  g.l_xreel,
  g.l_yreel,    
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepal_chambr_ae e
LEFT JOIN m_raepa.an_raepa_ouvae oe ON oe.idobjet = e.idobjet
LEFT JOIN m_raepa.an_raepa_ouv o ON o.idobjet = e.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud g ON g.idnoeud = o.idnoeud
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = e.idobjet
WHERE e.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY e.idobjet;

-- CHAMBRE DE COMPTAGE
DROP VIEW m_raepa.template_raepal_aep_ouv_chambr_compt;
CREATE OR REPLACE VIEW m_raepa.template_raepal_aep_ouv_chambr_compt AS 
 SELECT
-- m_raepa.an_raepa_ouvae
  --oe.idobjet,
  oe.idprod,
  oe.fnouvaep,
-- m_raepa.an_raepal_chambr_ae
  --e.idobjet,
  --e.idprod,
  e.l_dim,
-- m_raepa.an_raepal_chambr_compt_ae
  -- ee.idobjet,
  -- ee.idprod,
  ee.l_nbcompt,
-- m_raepa.an_raepa_ouv
  --o.idobjet,
  --o.idprod,
  o.zradouv,
  o.l_nom,
  o.l_typimpl,
  o.l_ztn,
  o.l_profond,
  o.l_acces,
  o.l_nbapp,
  --o.idnoeud,
-- m_raepa.geo_raepa_noeud
  --g.idnoeud,
  --g.x,
  --g.y,
  g.geom,
  g.l_xreel,
  g.l_yreel,    
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepal_chambr_compt_ae ee
LEFT JOIN m_raepa.an_raepal_chambr_ae e ON e.idobjet = ee.idobjet
LEFT JOIN m_raepa.an_raepa_ouvae oe ON oe.idobjet = ee.idobjet
LEFT JOIN m_raepa.an_raepa_ouv o ON o.idobjet = ee.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud g ON g.idnoeud = o.idnoeud
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = ee.idobjet
WHERE ee.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY ee.idobjet;



-- ################################################################# appareils aep ################################################################

-- APPAREILLAGE AEP
DROP VIEW m_raepa.template_raepal_aep_app;
CREATE OR REPLACE VIEW m_raepa.template_raepal_aep_app AS 
 SELECT
-- m_raepa.an_raepa_appae
  --aa.idobjet,
  aa.idprod,
  aa.fnappaep,
  aa.l_debit, 
-- m_raepa.an_raepa_app
  --a.idobjet,
  --a.idprod,
  a.idouvrage,
  a.diametre,
  a.zradapp,
  a.l_acces,
  -- a.idnoeud
-- m_raepa.geo_raepa_noeud
  --g.idnoeud,
  --g.x,
  --g.y,
  g.geom,
  g.l_xreel,
  g.l_yreel,    
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepa_appae aa
LEFT JOIN m_raepa.an_raepa_app a ON a.idobjet = aa.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud g ON g.idnoeud = a.idnoeud
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = aa.idobjet
WHERE aa.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY aa.idobjet;

-- VIDANGE AEP 
DROP VIEW m_raepa.template_raepal_aep_app_vidange;
CREATE OR REPLACE VIEW m_raepa.template_raepal_aep_app_vidange AS 
 SELECT
-- m_raepa.an_raepa_appae
  --ae.idobjet,
  ae.idprod,
  ae.fnappaep,
  ae.l_debit, 
-- m_raepa.an_raepal_vidange_ae
  -- aa.idobjet,
  -- aa.idprod,
  aa.l_positvid,
  aa.l_typexut,
-- m_raepa.an_raepa_app
  --a.idobjet,
  --a.idprod,
  a.idouvrage,
  a.diametre,
  a.zradapp,
  a.l_acces,
  -- a.idnoeud
-- m_raepa.geo_raepa_noeud
  --g.idnoeud,
  --g.x,
  --g.y,
  g.geom,
  g.l_xreel,
  g.l_yreel,    
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepal_vidange_ae aa
LEFT JOIN m_raepa.an_raepa_appae ae ON ae.idobjet = aa.idobjet
LEFT JOIN m_raepa.an_raepa_app a ON a.idobjet = aa.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud g ON g.idnoeud = a.idnoeud
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = aa.idobjet
WHERE aa.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY aa.idobjet;


-- VANNE AEP
DROP VIEW m_raepa.template_raepal_aep_app_vanne;
CREATE OR REPLACE VIEW m_raepa.template_raepal_aep_app_vanne AS 
 SELECT
-- m_raepa.an_raepa_appae
  --ae.idobjet,
  ae.idprod,
  ae.fnappaep,
  ae.l_debit, 
-- m_raepa.an_raepal_vanne_ae
  -- aa.idobjet,
  -- aa.idprod,
  aa.l_typvanne,
  aa.l_etatvan,
  aa.l_prtcharge,
  aa.l_positvan,
-- m_raepa.an_raepa_app
  --a.idobjet,
  --a.idprod,
  a.idouvrage,
  a.diametre,
  a.zradapp,
  a.l_acces,
  -- a.idnoeud
-- m_raepa.geo_raepa_noeud
  --g.idnoeud,
  --g.x,
  --g.y,
  g.geom,
  g.l_xreel,
  g.l_yreel,    
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepal_vanne_ae aa
LEFT JOIN m_raepa.an_raepa_appae ae ON ae.idobjet = aa.idobjet
LEFT JOIN m_raepa.an_raepa_app a ON a.idobjet = aa.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud g ON g.idnoeud = a.idnoeud
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = aa.idobjet
WHERE aa.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY aa.idobjet;

-- REGULATEUR DE PRESSION AEP
DROP VIEW m_raepa.template_raepal_aep_app_reg_press;
CREATE OR REPLACE VIEW m_raepa.template_raepal_aep_app_reg_press AS 
 SELECT
-- m_raepa.an_raepa_appae
  --ae.idobjet,
  ae.idprod,
  ae.fnappaep,
  ae.l_debit, 
-- m_raepa.an_raepal_reg_press_ae
  -- aa.idobjet,
  -- aa.idprod,
  aa.l_typregul,
  aa.l_consamt,
  aa.l_consavl,
-- m_raepa.an_raepa_app
  --a.idobjet,
  --a.idprod,
  a.idouvrage,
  a.diametre,
  a.zradapp,
  a.l_acces,
  -- a.idnoeud
-- m_raepa.geo_raepa_noeud
  --g.idnoeud,
  --g.x,
  --g.y,
  g.geom,
  g.l_xreel,
  g.l_yreel,    
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepal_reg_press_ae aa
LEFT JOIN m_raepa.an_raepa_appae ae ON ae.idobjet = aa.idobjet
LEFT JOIN m_raepa.an_raepa_app a ON a.idobjet = aa.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud g ON g.idnoeud = a.idnoeud
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = aa.idobjet
WHERE aa.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY aa.idobjet;

-- COMPTEUR AEP
DROP VIEW m_raepa.template_raepal_aep_app_compt;
CREATE OR REPLACE VIEW m_raepa.template_raepal_aep_app_compt AS 
 SELECT
-- m_raepa.an_raepa_appae
  --ae.idobjet,
  ae.idprod,
  ae.fnappaep,
  ae.l_debit, 
-- m_raepa.an_raepal_compt_ae
  -- aa.idobjet,
  -- aa.idprod,
  aa.l_typcompt,
  aa.l_foncompt,
  aa.l_anetal,
-- m_raepa.an_raepa_app
  --a.idobjet,
  --a.idprod,
  a.idouvrage,
  a.diametre,
  a.zradapp,
  a.l_acces,
  -- a.idnoeud
-- m_raepa.geo_raepa_noeud
  --g.idnoeud,
  --g.x,
  --g.y,
  g.geom,
  g.l_xreel,
  g.l_yreel,    
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepal_compt_ae aa
LEFT JOIN m_raepa.an_raepa_appae ae ON ae.idobjet = aa.idobjet
LEFT JOIN m_raepa.an_raepa_app a ON a.idobjet = aa.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud g ON g.idnoeud = a.idnoeud
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = aa.idobjet
WHERE aa.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY aa.idobjet;


-- DEBIMETRE AEP
DROP VIEW m_raepa.template_raepal_aep_app_deb;
CREATE OR REPLACE VIEW m_raepa.template_raepal_aep_app_deb AS 
 SELECT
-- m_raepa.an_raepa_appae
  --ae.idobjet,
  ae.idprod,
  ae.fnappaep,
  ae.l_debit, 
-- m_raepa.an_raepal_deb_ae
  -- aa.idobjet,
  -- aa.idprod,
  aa.l_positdeb,
-- m_raepa.an_raepa_app
  --a.idobjet,
  --a.idprod,
  a.idouvrage,
  a.diametre,
  a.zradapp,
  a.l_acces,
  -- a.idnoeud
-- m_raepa.geo_raepa_noeud
  --g.idnoeud,
  --g.x,
  --g.y,
  g.geom,
  g.l_xreel,
  g.l_yreel,    
-- m_raepa.an_raepal_objet_reseau
  --o.idobjet, 
  --o.idprod,
  r.qualglocxy,
  r.qualglocz,
  --r.datemaj, le jour où on reçoit les données du producteur
  --r.sourmaj, le jour où on reçoit les données du producteur
  --r.dategeoloc, le jour où on reçoit les données du producteur
  --r.sourgeoloc, le jour où on reçoit les données du producteur
  --r.sourattrib, le jour où on reçoit les données du producteur
  r.qualannee,
  r.enservice,
  r.materiau,
  --r.mouvrage,
  --r.gexploit,
  r.andebpose,
  r.anfinpose,
  --r.l_insee,
  r.l_positver,
  r.l_entrpose,
  r.l_marque,
  r.l_modele,
  r.l_etat,
  r.l_criticit,
  r.l_domaine,
  --r.l_libvoie,
  --r.l_reseau,
  --r.l_typeobjet,
  r.l_idsandre,
  r.l_observ
  --r.l_datext,
FROM m_raepa.an_raepal_deb_ae aa
LEFT JOIN m_raepa.an_raepa_appae ae ON ae.idobjet = aa.idobjet
LEFT JOIN m_raepa.an_raepa_app a ON a.idobjet = aa.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud g ON g.idnoeud = a.idnoeud
LEFT JOIN m_raepa.an_raepal_objet_reseau r ON r.idobjet = aa.idobjet
WHERE aa.idobjet = 0 --filtre id = 0 pour ne rien récupérer
ORDER BY aa.idobjet;