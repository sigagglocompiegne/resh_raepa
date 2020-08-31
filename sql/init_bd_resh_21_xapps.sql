/**************/
/* POSTGRESQL */
/***********************************/
/* CREATIONS DES VUES APPLICATIVES */
/***********************************/

-- init_bd_resh_20_vues_applicatives.sql --
-- Auteur : Léandre Béron
-- https://geo.compiegnois.fr/portail/

/***************************************************************************************************************/
/******                                             AEP                                                  ******/
/**************************************************************************************************************/





/***************************************************************************************************************/
/******                                             ASS                                                  ******/
/**************************************************************************************************************/
/******************************************/
/*    VUE CANALISATION ASS    */
/******************************************/
SELECT
*
FROM m_raepa.an_raepa_canalass ca 
LEFT JOIN m_raepa.an_raepa_canal c ON c.idobjet = ca.idobjet
LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = c.idobjet
LEFT JOIN m_raepa.geo_raepal_tronc t ON t.idtronc = c.idtronc
ORDER BY o.idobjet;

/******************************************/
/*    VUE CANALISATION BRANCHEMENT ASS    */
/******************************************/
SELECT
br.idobjet, br.l_typracc, br.l_conform
FROM m_raepa.an_raepal_brcht_ass br
LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = br.idobjet
ORDER BY o.idobjet;

/******************************************/
/*    VUE CANALISATION OUV    */
/******************************************/
/*SELECT
*
FROM m_raepa.an_raepal_brcht_ass br
LEFT JOIN m_raepa.an_raepa_canalass ca ON ca.idobjet = br.idobjet
LEFT JOIN m_raepa.an_raepa_canal c ON c.idobjet = ca.idobjet
LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = c.idobjet
LEFT JOIN m_raepa.geo_raepal_tronc t ON t.idtronc = c.idtronc
ORDER BY o.idobjet;*/
