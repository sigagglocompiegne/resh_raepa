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
RIGHT JOIN m_raepa.an_raepa_canalaep a ON g.idcana = a.idcana
RIGHT JOIN m_raepa.an_raepa_metadonnees m ON g.idcana = m.idraepa
ORDER BY g.idcana;

COMMENT ON VIEW m_raepa.geo_v_raepa_canalaep_l
  IS 'Canalisation d''adduction d''eau';
