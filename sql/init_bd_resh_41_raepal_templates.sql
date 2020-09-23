/*
Réseau d'eau pluviale
Creation du des templates pour gabarit RAEPA étendu
init_bd_resh_41_raepal_templates.sql
PostGIS
GeoCompiegnois - http://geo.compiegnois.fr/
Auteur : Léandre Béron
*/
/****************************************************************************/
/*                        FICHIERS RAEPA ETENDU                             */
/****************************************************************************/
/***************************/
/*           AEP           */
/***************************/
-- RAEPAL_CANALAEP
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_CANALAEP AS
 SELECT 
  e.idprod,
  o.l_idsandre,
  o.l_positver,
  o.materiau,
  e.contcanaep,
  o.l_entrpose,
  o.l_marque,
  o.l_modele,
  o.l_etat,
  o.l_criticit,
  t.sensecoul,
  c.l_formcana,
  c.l_dim,
  c.l_protext,
  c.l_protint,
  c.l_ztn,
  c.l_zgen,
  c.zamont,
  c.zaval,
  c.l_penter,
  e.l_pression,
  e.l_protcath,
  e.l_indperte,
  c.l_autpass,
  o.l_observ
FROM m_raepa.an_raepa_canalae e
LEFT JOIN m_raepa.an_raepa_canal c  ON e.idobjet = c.idobjet
LEFT JOIN m_raepa.an_raepal_objet_reseau o  ON e.idobjet = o.idobjet
LEFT JOIN m_raepa.geo_raepal_tronc t ON t.idtronc = c.idtronc
WHERE e.idobjet = 0 -- pour ne rien récupérer
ORDER BY e.idobjet;



-- RAEPAL_OUVRAEP
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_OUVRAEP AS 
 SELECT
  oe.idprod,
  o.l_idsandre,
  ouv.l_nom,
  ouv.l_typimpl,
  oe.fnouvaep,
  o.l_positver,
  o.enservice,
  n.l_xreel,
  n.l_yreel,
  o.l_entrpose,
  o.l_marque,
  o.l_modele,
  o.l_etat,
  o.l_criticit,
  ouv.l_ztn,
  ouv.l_acces,
  o.l_observ
FROM m_raepa.an_raepa_ouvae oe
LEFT JOIN m_raepa.an_raepa_ouv ouv ON ouv.idobjet = oe.idobjet
LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = ouv.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud n ON n.idnoeud = ouv.idnoeud
WHERE oe.idobjet = 0 --pour ne rien récupérer
ORDER BY oe.idobjet;

-- RAEPAL_STATPOMP_AEP
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_STATPOMP_AEP AS 
 SELECT
  oe.idprod,
  oe.l_typpomp,
  oe.l_debit,
  oe.l_hmano
FROM m_raepa.an_raepal_stat_pomp_ae oe

WHERE oe.idobjet = 0 --pour ne rien récupérer
ORDER BY oe.idobjet;

-- RAEPAL_STATTRAIT_AEP
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_STATTRAIT_AEP AS 
 SELECT
  oe.idprod,
  oe.l_typtrait,
  oe.l_idars,
  oe.l_capacite
FROM m_raepa.an_raepal_stat_trait_ae oe

WHERE oe.idobjet = 0 --pour ne rien récupérer
ORDER BY oe.idobjet;

-- RAEPAL_RESERV_AEP
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_RESERV_AEP AS 
 SELECT
  oe.idprod,
  oe.l_typres,
  oe.l_volume,
  oe.l_ztp,
  oe.l_nbcuve
FROM m_raepa.an_raepal_reservoir_ae oe

WHERE oe.idobjet = 0 --pour ne rien récupérer
ORDER BY oe.idobjet;

-- RAEPAL_CAPTAG_AEP
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_CAPTAG_AEP AS 
 SELECT
  oe.idprod,
  oe.l_typcapt,
  oe.l_idbss,
  oe.l_debh,
  oe.l_debj,
  oe.l_deba
FROM m_raepa.an_raepal_captage_ae oe

WHERE oe.idobjet = 0 --pour ne rien récupérer
ORDER BY oe.idobjet;


-- RAEPAL_CHAMBR_AEP
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_CHAMBR_AEP AS 
 SELECT
  oe.idprod,
  oe.l_dim,
  o.materiau
FROM m_raepa.an_raepal_chambr_ae oe
LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = oe.idobjet

WHERE oe.idobjet = 0 --pour ne rien récupérer
ORDER BY oe.idobjet;

-- RAEPAL_CHAMBR_COMPT_AEP
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_CHAMBR_COMPT_AEP AS 
 SELECT
  oe.idprod,
  ch.l_dim,
  o.materiau
FROM m_raepa.an_raepal_chambr_compt_ae oe
LEFT JOIN m_raepa.an_raepal_chambr_ae ch ON oe.idobjet = ch.idobjet
LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = oe.idobjet

WHERE oe.idobjet = 0 --pour ne rien récupérer
ORDER BY oe.idobjet;

-- RAEPAL_CITERN_AEP
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_CITERN_AEP AS 
 SELECT
  oe.idprod,
  oe.l_typusage
FROM m_raepa.an_raepal_citerneau_ae oe

WHERE oe.idobjet = 0 --pour ne rien récupérer
ORDER BY oe.idobjet;


-- RAEPAL_APPARAEP
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_APPARAEP AS 
 SELECT
  e.idprod,
  o.l_idsandre,
  a.l_typimpl,
  e.fnappaep,
  o.l_positver,
  o.enservice,
  n.l_xreel,
  n.l_yreel,
  o.l_entrpose,
  o.l_marque,
  o.l_modele,
  o.l_etat,
  o.l_criticit,
  a.l_acces,
  o.l_observ,
  e.l_debit

FROM m_raepa.an_raepa_appae e  
LEFT JOIN m_raepa.an_raepa_app a ON a.idobjet = e.idobjet
LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = e.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud n ON n.idnoeud = a.idnoeud
WHERE e.idobjet = 0 --pour ne rien récupérer
ORDER BY e.idobjet;

-- RAEPAL_DEB_AEP
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_DEB_AEP AS 
 SELECT
  oe.idprod,
  oe.l_positdeb
FROM m_raepa.an_raepal_deb_ae oe

WHERE oe.idobjet = 0 --pour ne rien récupérer
ORDER BY oe.idobjet;


-- RAEPAL_VIDANG_AEP
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_VIDANG_AEP AS 
 SELECT
  oe.idprod,
  oe.l_positvid,
  oe.l_typexut
FROM m_raepa.an_raepal_vidange_ae oe

WHERE oe.idobjet = 0 --pour ne rien récupérer
ORDER BY oe.idobjet;

-- RAEPAL_VANNE_AEP
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_VANNE_AEP AS 
 SELECT
  oe.idprod,
  oe.l_positvan,
  o.materiau,
  oe.l_etatvan,
  oe.l_prtcharge
FROM m_raepa.an_raepal_vanne_ae oe
LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = oe.idobjet

WHERE oe.idobjet = 0 --pour ne rien récupérer
ORDER BY oe.idobjet;

-- RAEPAL_REG_PRESS_AEP
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_REG_PRESS_AEP AS 
 SELECT
  oe.idprod,
  oe.l_typregul,
  oe.l_consamt,
  oe.l_consavl
FROM m_raepa.an_raepal_reg_press_ae oe

WHERE oe.idobjet = 0 --pour ne rien récupérer
ORDER BY oe.idobjet;


-- RAEPAL_COMPT_AEP
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_COMPT_AEP AS 
 SELECT
  oe.idprod,
  oe.l_typcompt,
  oe.l_foncompt,
  oe.l_anetal
FROM m_raepa.an_raepal_compt_ae oe

WHERE oe.idobjet = 0 --pour ne rien récupérer
ORDER BY oe.idobjet;


/***************************/
/*           ASS           */
/***************************/
-- RAEPAL_CANALASS
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_CANALASS AS 
 SELECT 
  a.idprod,
  o.l_idsandre,
  o.l_positver,
  o.materiau,
  o.l_entrpose,
  o.l_marque,
  o.l_modele,
  o.l_etat,
  o.l_criticit,
  c.l_formcana,
  c.l_dim,
  c.l_protext,
  c.l_protint,
  c.l_ztn,
  c.l_zgen,
  c.l_penter,
  c.l_autpass,
  o.l_observ  
FROM m_raepa.an_raepa_canalass a
LEFT JOIN m_raepa.an_raepa_canal c ON c.idobjet = a.idobjet
LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = a.idobjet
WHERE a.idobjet = 0 --pour ne rien récupérer
ORDER BY a.idobjet;

-- RAEPAL_BRANCHEMNT_ASS
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_BRANCHEMNT_ASS AS 
 SELECT
  oe.idprod,
  oe.l_typracc,
  oe.l_conform
FROM m_raepa.an_raepal_brcht_ass oe

WHERE oe.idobjet = 0 --pour ne rien récupérer
ORDER BY oe.idobjet;


-- RAEPAL_OUVRASS
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_OUVRASS AS 
 SELECT
  oa.idprod,
  o.l_idsandre,
  ouv.l_nom,
  ouv.l_typimpl,
  oa.fnouvass,
  o.l_positver,
  o.enservice,
  n.l_xreel,
  n.l_yreel,
  o.l_entrpose,
  o.l_marque,
  o.l_modele,
  o.l_etat,
  o.l_criticit,
  ouv.l_ztn,
  ouv.l_acces,
  o.l_observ

FROM m_raepa.an_raepa_ouvass oa
LEFT JOIN m_raepa.an_raepa_ouv ouv ON ouv.idobjet = oa.idobjet
LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = oa.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud n ON n.idnoeud = ouv.idnoeud
LEFT JOIN m_raepa.lt_raepal_fnouvass z ON z.code_arc = oa.fnouvass
WHERE oa.idobjet = 0 -- pour ne rien récupérer
ORDER BY oa.idobjet;

-- RAEPAL_STATPOMP_ASS
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_STATPOMP_ASS AS 
 SELECT
  oe.idprod,
  oe.l_typpompa,
  oe.l_traith2s,
  oe.l_troplein
FROM m_raepa.an_raepal_stat_pomp_ass oe

WHERE oe.idobjet = 0 --pour ne rien récupérer
ORDER BY oe.idobjet;

-- RAEPAL_STEP_ASS
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_STEP_ASS AS 
 SELECT
  oe.idprod,
  oe.l_typstep,
  oe.l_charge,
  oe.l_capnomi
FROM m_raepa.an_raepal_step_ass oe

WHERE oe.idobjet = 0 --pour ne rien récupérer
ORDER BY oe.idobjet;

-- RAEPAL_BASS_ASS
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_BASS_ASS AS 
 SELECT
  oe.idprod,
  oe.l_typbass,
  oe.l_telegest,
  oe.l_zsurv
FROM m_raepa.an_raepal_bass_stock_ass oe

WHERE oe.idobjet = 0 --pour ne rien récupérer
ORDER BY oe.idobjet;

-- RAEPAL_REG_ASS
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_REG_ASS AS 
 SELECT
  oe.idprod,
  oe.l_typreg,
  o.materiau,
  oe.l_visit,
  oe.l_formreg,
  oe.l_decant,
  oe.l_tampon,
  oe.l_grille,
  oe.l_dimgrill,
  z.l_typusage
FROM m_raepa.an_raepal_reg_bt_brchmt_ass z
LEFT JOIN m_raepa.an_raepal_regard_ass oe ON oe.idobjet = z.idobjet
LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = oe.idobjet

WHERE oe.idobjet = 0 --pour ne rien récupérer
ORDER BY oe.idobjet;


-- RAEPAL_AVALOIR_ASS
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_AVALOIR_ASS AS 
 SELECT
  oe.idprod,
  oe.l_typaval,
  oe.l_nivvoiri,
  oe.l_decant,
  oe.l_dimgrill,
  oe.l_modpass
FROM m_raepa.an_raepal_avaloir_ass oe

WHERE oe.idobjet = 0 --pour ne rien récupérer
ORDER BY oe.idobjet;

-- RAEPAL_APPARASS
CREATE OR REPLACE VIEW m_raepa.template_RAEPAL_APPARASS AS 
 SELECT
  z.idprod,
  o.l_idsandre,
  a.l_typimpl,
  z.fnappass,
  o.l_positver,
  o.enservice,
  n.l_xreel,
  n.l_yreel,
  o.l_entrpose,
  o.l_marque,
  o.l_modele,
  o.l_etat,
  o.l_criticit,
  a.l_acces,
  o.l_observ
FROM m_raepa.an_raepa_appass z
LEFT JOIN m_raepa.an_raepa_app a ON a.idobjet = z.idobjet
LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = a.idobjet
LEFT JOIN m_raepa.geo_raepa_noeud n ON a.idnoeud = n.idnoeud
LEFT JOIN m_raepa.lt_raepal_fnappass fn ON fn.code_arc = z.fnappass
WHERE z.idobjet = 0 --pour ne rien récupérer
ORDER BY z.idobjet;


/****************************************************************************/
/*                              LISTES RAEPAL                               */
/****************************************************************************/
--DROP VIEW m_raepa.template_lt_raepal_materiau;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_materiau AS 
SELECT 
code_arc as code, valeur
FROM m_raepa.lt_raepal_materiau;

--DROP VIEW m_raepa.template_lt_raepal_positver;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_positver AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_positver;

--DROP VIEW m_raepa.template_lt_raepal_etat;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_etat AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_etat;

--DROP VIEW m_raepa.template_lt_raepal_boolean
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_boolean AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_boolean;

--DROP VIEW m_raepa.template_lt_raepal_formcana;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_formcana AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_formcana;

--DROP VIEW m_raepa.template_lt_raepal_typprot;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_typprot AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_typprot;

--DROP VIEW m_raepa.template_lt_raepal_typimpl;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_typimpl AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_typimpl;

--DROP VIEW m_raepa.template_lt_raepal_sensecoul;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_sensecoul AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_sensecoul;

--DROP VIEW m_raepa.template_lt_raepal_contcanaep;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_contcanaep AS 
SELECT 
code_arc as code, valeur
FROM m_raepa.lt_raepal_contcanaep;

--DROP VIEW m_raepa.template_lt_raepal_fnouvaep;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_fnouvaep AS 
SELECT 
code_arc as code, valeur
FROM m_raepa.lt_raepal_fnouvaep;

--DROP VIEW m_raepa.template_lt_raepal_typpompe;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_typpompe AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_typpompe;

--DROP VIEW m_raepa.template_lt_raepal_typtrait;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_typtrait AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_typtrait;

--DROP VIEW m_raepa.template_lt_raepal_typres;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_typres AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_typres;

--DROP VIEW m_raepa.template_lt_raepal_typcapt;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_typcapt AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_typcapt;

--DROP VIEW m_raepa.template_lt_raepal_typusage_ae;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_typusage_ae AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_typusage_ae;

--DROP VIEW m_raepa.template_lt_raepal_fnappaep;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_fnappaep AS 
SELECT 
code_arc as code, valeur
FROM m_raepa.lt_raepal_fnappaep;


--DROP VIEW m_raepa.template_lt_raepal_position;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_position AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_position;

--DROP VIEW m_raepa.template_lt_raepal_typexut;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_typexut AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_typexut;

--DROP VIEW m_raepa.template_lt_raepal_typvanne;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_typvanne AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_typvanne;

--DROP VIEW m_raepa.template_lt_raepal_etatvan;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_etatvan AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_etatvan;

--DROP VIEW m_raepa.template_lt_raepal_typregul;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_typregul AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_typregul;

--DROP VIEW m_raepa.template_lt_raepal_typcompt;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_typcompt AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_typcompt;

--DROP VIEW m_raepa.template_lt_raepal_foncompt;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_foncompt AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_foncompt;

--DROP VIEW m_raepa.template_lt_raepal_typracc;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_typracc AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_typracc;

--DROP VIEW m_raepa.template_lt_raepal_fnouvass;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_fnouvass AS 
SELECT 
code_arc as code, valeur
FROM m_raepa.lt_raepal_fnouvass;

--DROP VIEW m_raepa.template_lt_raepal_typpompa;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_typpompa AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_typpompa;

--DROP VIEW m_raepa.template_lt_raepal_charge;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_charge AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_charge;

--DROP VIEW m_raepa.template_lt_raepal_typbass;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_typbass AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_typbass;

--DROP VIEW m_raepa.template_lt_raepal_typreg;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_typreg AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_typreg;

--DROP VIEW m_raepa.template_lt_raepal_formreg;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_formreg AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_formreg;

--DROP VIEW m_raepa.template_lt_raepal_typusage_ass;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_typusage_ass AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_typusage_ass;

--DROP VIEW m_raepa.template_lt_raepal_typaval;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_typaval AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_typaval;

--DROP VIEW m_raepa.template_lt_raepal_typstep;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_typstep AS 
SELECT 
code, valeur
FROM m_raepa.lt_raepal_typstep;

--DROP VIEW m_raepa.template_lt_raepal_fnappass;
CREATE OR REPLACE VIEW m_raepa.template_lt_raepal_fnappass AS 
SELECT 
code_arc as code, valeur
FROM m_raepa.lt_raepal_fnappass;
