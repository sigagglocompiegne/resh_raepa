/**************/
/* POSTGRESQL */
/***********************************/
/* CREATIONS DES VUES APPLICATIVES */
/***********************************/
-- init_bd_resh_21_xapps.sql --
-- Auteur : Léandre Béron
-- https://geo.compiegnois.fr/portail/

/***************************************************************************************************************/
/******                                            AEP                                                  ******/
/**************************************************************************************************************/
/******************************************/
/*    VUE CANALISATION AEP    */
/******************************************/
CREATE MATERIALIZED VIEW x_apps.x_apps_geo_vmr_canalae AS  --Rafraichît lors de chaque intégration de données via FME
	SELECT
	o.idobjet,
	o.mouvrage,
	o.gexploit,
	o.l_reseau,
	o.l_datext,
	o.l_domaine,
	dom.valeur AS "l_domaine_v",
	o.l_libvoie,
	o.l_insee,
	o.l_typeobjet,
	o.andebpose,
	o.anfinpose,
	o.materiau ,
	ma.valeur AS "materiau_v",
	o.enservice,
	o.datemaj,
	o.sourmaj,
	o.qualannee,
	qua.valeur AS "qualannee_v",
	o.dategeoloc,
	o.sourgeoloc,
	o.sourattrib,
	CASE WHEN o.enservice = 'O' THEN 'Oui' -- traduction explicite des valeurs
			ELSE 'Non' END AS "enservice_v",
	t.sensecoul,
	CASE WHEN t.sensecoul = 'i' THEN 'Inverse' -- traduction explicite des valeurs
		WHEN t.sensecoul = 'd' THEN 'Direct'
		ELSE 'Indéterminé' END AS "sensecoul_v",
	CASE WHEN c.diametre =-1 THEN 'Non renseigné' -- traduction explicite des valeurs
	ELSE c.diametre::character varying END AS "diametre",
	c.modecirc,
	modc.valeur AS "modecirc_v",
    c.branchemnt,
	CASE WHEN c.branchemnt = 'O' THEN 'Canalisation de branchement individuel' -- traduction explicite des valeurs
			ELSE 'Canalisation de transport ou de distribution' END AS "branchemnt_v",
	c.nbranche,
	c.distgen,
	ce.fonccanaep,
	f.valeur AS "fonccanaep_v",
	ce.contcanaep,
	g.valeur AS "contcanaep_v",
	o.qualglocxy,
	xy.valeur AS "qualglocxy_v",
	o.qualglocz,
	z.valeur AS "qualglocz_v",
	t.longmes,
	t.l_longcalc,
	t.idnini,
	t.idnterm,
	t.geom

	FROM m_raepa.an_raepa_canalae ce 
	LEFT JOIN m_raepa.an_raepa_canal c ON c.idobjet = ce.idobjet
	LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = c.idobjet
	LEFT JOIN m_raepa.geo_raepal_tronc t ON t.idtronc = c.idtronc
	LEFT JOIN m_raepa.lt_raepa_fonccanaep f ON f.code = ce.fonccanaep
	LEFT JOIN m_raepa.lt_raepal_contcanaep g ON g.code_arc = ce.contcanaep
	LEFT JOIN m_raepa.lt_raepa_qualgloc xy ON xy.code = o.qualglocxy
	LEFT JOIN m_raepa.lt_raepa_qualgloc z ON z.code = o.qualglocz
	LEFT JOIN m_raepa.lt_raepal_materiau ma ON ma.code_arc = o.materiau
	LEFT JOIN m_raepa.lt_raepal_domaine dom ON dom.code = o.l_domaine
	LEFT JOIN m_raepa.lt_raepa_qualannee qua ON qua.code = o.qualannee
	LEFT JOIN m_raepa.lt_raepa_modecirc modc ON modc.code = c.modecirc

	ORDER BY o.idobjet;

COMMENT ON MATERIALIZED VIEW x_apps.x_apps_geo_vmr_canalae
  IS 'Vue matérialisée permettant l''affichage des informations patrimoniales raepa des canalisations d''adduction d''eau. Rafraichît lors de chaque intégration de données via FME';

GRANT ALL ON TABLE x_apps.x_apps_geo_vmr_canalae TO sig_create;

/******************************************/
/*    VUE OUVRAGE AEP                     */
/******************************************/
CREATE MATERIALIZED VIEW x_apps.x_apps_an_vmr_ouvae AS  --Rafraichît lors de chaque intégration de données via FME
	SELECT
	
	o.idobjet,
	o.mouvrage,
	o.gexploit,
	o.l_reseau,
	o.l_typeobjet,
	o.l_datext,
	o.l_domaine,
	dom.valeur AS "l_domaine_v",
	o.l_libvoie,
	o.l_insee,
	o.andebpose,
	o.anfinpose,
	ouv.idnoeud,
	n.x,
	n.y,
	ouv.zradouv,
	oe.fnouvaep,
	fnouvaep.valeur AS "fnouvaep_v",
	o.datemaj,
	o.sourmaj,
	o.qualannee,
	qua.valeur AS "qualannee_v",
	o.dategeoloc,
	o.sourgeoloc,
	o.sourattrib,
	o.qualglocxy,
	xy.valeur AS "qualglocxy_v",
	o.qualglocz,
	z.valeur AS "qualglocz_v",
	n.geom
	
	
	FROM m_raepa.an_raepa_ouvae oe 
	LEFT JOIN m_raepa.an_raepa_ouv ouv ON ouv.idobjet = oe.idobjet
	LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = ouv.idobjet
	LEFT JOIN m_raepa.geo_raepa_noeud n ON n.idnoeud = ouv.idnoeud
	LEFT JOIN m_raepa.lt_raepal_fnouvaep fnouvaep ON fnouvaep.code_arc = oe.fnouvaep
	LEFT JOIN m_raepa.lt_raepa_qualgloc xy ON xy.code = o.qualglocxy
	LEFT JOIN m_raepa.lt_raepa_qualgloc z ON z.code = o.qualglocz
	LEFT JOIN m_raepa.lt_raepal_domaine dom ON dom.code = o.l_domaine
	LEFT JOIN m_raepa.lt_raepa_qualannee qua ON qua.code = o.qualannee
	
	ORDER BY o.idobjet;

	
	
COMMENT ON MATERIALIZED VIEW x_apps.x_apps_an_vmr_ouvae
  IS 'Vue matérialisée permettant l''affichage des informations patrimoniales raepa des ouvrages d''adduction d''eau. Rafraichît lors de chaque intégration de données via FME';

GRANT ALL ON TABLE x_apps.x_apps_an_vmr_ouvae TO sig_create;


/******************************************/
/*    VUE APPAREILLAGE AEP                 */
/******************************************/
CREATE MATERIALIZED VIEW x_apps.x_apps_an_vmr_appae AS  --Rafraichît lors de chaque intégration de données via FME
	SELECT

	o.idobjet,
	o.mouvrage,
	o.gexploit,
	o.l_reseau,
	o.l_typeobjet,
	o.l_datext,
	o.l_domaine,
	dom.valeur AS "l_domaine_v",
	o.l_libvoie,
	o.l_insee,
	o.andebpose,
	o.anfinpose,
	app.idnoeud,
	n.x,
	n.y,
	app.zradapp,
	app.diametre,
	ae.fnappaep,
	fnappaep.valeur AS "fnappaep_v",
	o.datemaj,
	o.sourmaj,
	o.qualannee,
	qua.valeur AS "qualannee_v",
	o.dategeoloc,
	o.sourgeoloc,
	o.sourattrib,
	o.qualglocxy,
	xy.valeur AS "qualglocxy_v",
	o.qualglocz,
	z.valeur AS "qualglocz_v",
	app.idouvrage,
	n.geom
	
	
	FROM m_raepa.an_raepa_appae ae 
	LEFT JOIN m_raepa.an_raepa_app app ON app.idobjet = ae.idobjet
	LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = app.idobjet
	LEFT JOIN m_raepa.geo_raepa_noeud n ON n.idnoeud = app.idnoeud
	LEFT JOIN m_raepa.lt_raepal_fnappaep fnappaep ON fnappaep.code_arc = ae.fnappaep
	LEFT JOIN m_raepa.lt_raepa_qualgloc xy ON xy.code = o.qualglocxy
	LEFT JOIN m_raepa.lt_raepa_qualgloc z ON z.code = o.qualglocz
	LEFT JOIN m_raepa.lt_raepal_domaine dom ON dom.code = o.l_domaine
	LEFT JOIN m_raepa.lt_raepa_qualannee qua ON qua.code = o.qualannee
	
	ORDER BY app.idouvrage asc;

	
COMMENT ON MATERIALIZED VIEW x_apps.x_apps_an_vmr_appae
  IS 'Vue matérialisée permettant l''affichage des informations patrimoniales raepa des appareillages d''adduction d''eau. Rafraichît lors de chaque intégration de données via FME';

GRANT ALL ON TABLE x_apps.x_apps_an_vmr_appae TO sig_create;




/***************************************************************************************************************/
/******                                             ASS                                                  ******/
/**************************************************************************************************************/
/******************************************/
/*    VUE CANALISATION ASS    */
/******************************************/

CREATE MATERIALIZED VIEW x_apps.x_apps_geo_vmr_canalass AS  --Rafraichît lors de chaque intégration de données via FME
	SELECT
	o.idobjet,
	o.mouvrage,
	o.gexploit,
	o.l_reseau,
	o.l_datext,
	o.l_domaine,
	dom.valeur AS "l_domaine_v",
	o.l_libvoie,
	o.l_insee,
	o.l_typeobjet,
	o.andebpose,
	o.anfinpose,
	o.materiau,
	ma.valeur AS "materiau_v",
	o.enservice,
	o.datemaj,
	o.sourmaj,
	o.qualannee,
	qua.valeur AS "qualannee_v",
	o.dategeoloc,
	o.sourgeoloc,
	o.sourattrib,
	CASE WHEN o.enservice = 'O' THEN 'Oui' -- traduction explicite des valeurs
			ELSE 'Non' END AS "enservice_v",
	CASE WHEN c.diametre =-1 THEN 'Non renseigné' -- traduction explicite des valeurs
	ELSE c.diametre::character varying END AS "diametre",
	c.modecirc,
	modc.valeur AS "modecirc_v",
    c.branchemnt,
	CASE WHEN c.branchemnt = 'O' THEN 'Canalisation de branchement individuel' -- traduction explicite des valeurs
			ELSE 'Canalisation de transport ou collecte' END AS "branchemnt_v",
	t.sensecoul,
	CASE WHEN t.sensecoul = 'i' THEN 'Inverse' -- traduction explicite des valeurs
		WHEN t.sensecoul = 'd' THEN 'Direct'
		ELSE 'Indéterminé' END AS "sensecoul_v",
	c.nbranche,
	c.zamont,
	c.zaval,
	ca.typreseau,
	tr.valeur AS "typreseau_v",
	ca.fonccanass,
	f.valeur AS "fonccanass_v",
	ca.contcanass,
	g.valeur AS "contcanass_v",
	o.qualglocxy,
	xy.valeur AS "qualglocxy_v",
	o.qualglocz,
	z.valeur AS "qualglocz_v",
	t.longmes,
	t.l_longcalc,
	t.idnini,
	t.idnterm,
	t.geom

	FROM m_raepa.an_raepa_canalass ca 
	LEFT JOIN m_raepa.an_raepa_canal c ON c.idobjet = ca.idobjet
	LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = c.idobjet
	LEFT JOIN m_raepa.geo_raepal_tronc t ON t.idtronc = c.idtronc
	LEFT JOIN m_raepa.lt_raepa_typreseau tr ON tr.code = ca.typreseau
	LEFT JOIN m_raepa.lt_raepa_fonccanass f ON f.code = ca.fonccanass
	LEFT JOIN m_raepa.lt_raepa_contcanass g ON g.code = ca.contcanass
	LEFT JOIN m_raepa.lt_raepa_qualgloc xy ON xy.code = o.qualglocxy
	LEFT JOIN m_raepa.lt_raepa_qualgloc z ON z.code = o.qualglocz
	LEFT JOIN m_raepa.lt_raepal_materiau ma ON ma.code_arc = o.materiau
	LEFT JOIN m_raepa.lt_raepal_domaine dom ON dom.code = o.l_domaine
	LEFT JOIN m_raepa.lt_raepa_qualannee qua ON qua.code = o.qualannee
	LEFT JOIN m_raepa.lt_raepa_modecirc modc ON modc.code = c.modecirc
	
	ORDER BY o.idobjet;

COMMENT ON MATERIALIZED VIEW x_apps.x_apps_geo_vmr_canalass
  IS 'Vue matérialisée permettant l''affichage des informations patrimoniales raepa des canalisations d''assainissement collectif. Rafraichît lors de chaque intégration de données via FME';

GRANT ALL ON TABLE x_apps.x_apps_geo_vmr_canalass TO sig_create;

/******************************************/
/*    VUE OUVRAGE ASS                     */
/******************************************/
CREATE MATERIALIZED VIEW x_apps.x_apps_an_vmr_ouvass AS  --Rafraichît lors de chaque intégration de données via FME
	SELECT
	
	o.idobjet,
	o.mouvrage,
	o.gexploit,
	o.l_reseau,
	o.l_typeobjet,
	o.l_datext,
	o.l_domaine,
	dom.valeur AS "l_domaine_v",
	o.l_libvoie,
	o.l_insee,
	o.andebpose,
	o.anfinpose,
	ouv.idnoeud,
	n.x,
	n.y,
	ouv.zradouv,
	oa.fnouvass,
	fnouvass.valeur AS "fnouvass_v",
	oa.typreseau,
	typreseau.valeur AS "typreseau_v",
	o.datemaj,
	o.sourmaj,
	o.qualannee,
	qua.valeur AS "qualannee_v",
	o.dategeoloc,
	o.sourgeoloc,
	o.sourattrib,
	o.qualglocxy,
	xy.valeur AS "qualglocxy_v",
	o.qualglocz,
	z.valeur AS "qualglocz_v",
	n.geom
	
	
	FROM m_raepa.an_raepa_ouvass oa 
	LEFT JOIN m_raepa.an_raepa_ouv ouv ON ouv.idobjet = oa.idobjet
	LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = ouv.idobjet
	LEFT JOIN m_raepa.geo_raepa_noeud n ON n.idnoeud = ouv.idnoeud
	LEFT JOIN m_raepa.lt_raepal_fnouvass fnouvass ON fnouvass.code_arc = oa.fnouvass
	LEFT JOIN m_raepa.lt_raepa_typreseau typreseau ON typreseau.code = oa.typreseau
	LEFT JOIN m_raepa.lt_raepa_qualgloc xy ON xy.code = o.qualglocxy
	LEFT JOIN m_raepa.lt_raepa_qualgloc z ON z.code = o.qualglocz
	LEFT JOIN m_raepa.lt_raepal_domaine dom ON dom.code = o.l_domaine
	LEFT JOIN m_raepa.lt_raepa_qualannee qua ON qua.code = o.qualannee
	
	ORDER BY o.idobjet;
	
COMMENT ON MATERIALIZED VIEW x_apps.x_apps_an_vmr_ouvass
  IS 'Vue matérialisée permettant l''affichage des informations patrimoniales raepa des ouvrages d''assainissement collectif. Rafraichît lors de chaque intégration de données via FME';

GRANT ALL ON TABLE x_apps.x_apps_an_vmr_ouvass TO sig_create;



/******************************************/
/*    VUE APPAREILLAGE ASS                 */
/******************************************/
CREATE MATERIALIZED VIEW x_apps.x_apps_an_vmr_appass AS  --Rafraichît lors de chaque intégration de données via FME
	SELECT

	o.idobjet,
	o.mouvrage,
	o.gexploit,
	o.l_reseau,
	o.l_typeobjet,
	o.l_datext,
	o.l_domaine,
	dom.valeur AS "l_domaine_v",
	o.l_libvoie,
	o.l_insee,
	o.andebpose,
	o.anfinpose,
	app.idnoeud,
	n.x,
	n.y,
	app.zradapp,
	app.diametre,
	aa.fnappass,
	fnappass.valeur AS "fnappass_v",
	aa.typreseau,
	typreseau.valeur AS "typreseau_v",
	o.datemaj,
	o.sourmaj,
	o.qualannee,
	qua.valeur AS "qualannee_v",
	o.dategeoloc,
	o.sourgeoloc,
	o.sourattrib,
	o.qualglocxy,
	xy.valeur AS "qualglocxy_v",
	o.qualglocz,
	z.valeur AS "qualglocz_v",
	app.idouvrage,
	n.geom
	
	
	FROM m_raepa.an_raepa_appass aa 
	LEFT JOIN m_raepa.an_raepa_app app ON app.idobjet = aa.idobjet
	LEFT JOIN m_raepa.an_raepal_objet_reseau o ON o.idobjet = app.idobjet
	LEFT JOIN m_raepa.geo_raepa_noeud n ON n.idnoeud = app.idnoeud
	LEFT JOIN m_raepa.lt_raepal_fnappass fnappass ON fnappass.code_arc = aa.fnappass
	LEFT JOIN m_raepa.lt_raepa_typreseau typreseau ON typreseau.code = aa.typreseau
	LEFT JOIN m_raepa.lt_raepa_qualgloc xy ON xy.code = o.qualglocxy
	LEFT JOIN m_raepa.lt_raepa_qualgloc z ON z.code = o.qualglocz
	LEFT JOIN m_raepa.lt_raepal_domaine dom ON dom.code = o.l_domaine
	LEFT JOIN m_raepa.lt_raepa_qualannee qua ON qua.code = o.qualannee
	
	ORDER BY o.idobjet;

	
COMMENT ON MATERIALIZED VIEW x_apps.x_apps_an_vmr_appass
  IS 'Vue matérialisée permettant l''affichage des informations patrimoniales raepa des appareillages d''assainissement collectif. Rafraichît lors de chaque intégration de données via FME';

GRANT ALL ON TABLE x_apps.x_apps_an_vmr_appass TO sig_create;
















/***************************************************************************************************************/
/******                                            NOEUDS                                                  ******/
/**************************************************************************************************************/
/*****************************************************/
/*    VUE QUI CALCUL LES NB OUV ET APP PAR NOEUD (ASS)    */
/****************************************************/
--DROP MATERIALIZED VIEW x_apps.x_apps_geo_vmr_noeud_ass;
CREATE MATERIALIZED VIEW x_apps.x_apps_geo_vmr_noeud_ass AS  --Rafraichît lors de chaque intégration de données via FME

WITH req_t AS ( -- super sous requête pour préparer la requête finale
WITH -- -- sous requêtes
req_nb_ouvass AS  -- récupération des nombres d'ouvrages ass par noeud
(SELECT n.idnoeud, count (*) AS nb_ouvass 
 from m_raepa.an_raepa_ouv o,m_raepa.an_raepa_ouvass oa, m_raepa.geo_raepa_noeud n 
 WHERE o.idnoeud = n.idnoeud AND oa.idobjet = o.idobjet 
 GROUP BY n.idnoeud),
 
req_nb_appass AS -- récupération des nombres d'appareillages ass par noeud
(SELECT n.idnoeud, count (*) AS nb_appass 
 from m_raepa.an_raepa_app a, m_raepa.an_raepa_appass aa, m_raepa.geo_raepa_noeud n 
 WHERE a.idnoeud = n.idnoeud AND aa.idobjet = a.idobjet 
 GROUP BY n.idnoeud 
 ORDER BY nb_appass DESC),
 
req_lt_appass AS -- récupération de tous les types d'appareillages d'ass dans un champ concaténé
(SELECT aa.idobjet, n.idnoeud, fnappass.valeur || '_' || row_number() over() AS fnappass_v, 
 -- row_number permet de garder les deux symboles si deux app sont de même type, sinon, un seul est conservé dans l'application
 fnappass.symbole AS symbole_infobulle
 FROM m_raepa.an_raepa_appass aa 
 LEFT JOIN m_raepa.an_raepa_app a ON aa.idobjet = a.idobjet 
 LEFT JOIN m_raepa.geo_raepa_noeud n ON n.idnoeud = a.idnoeud
 LEFT JOIN m_raepa.lt_raepal_fnappass fnappass ON fnappass.code_arc = aa.fnappass 
 ORDER BY idnoeud)
 
-- sous requête principale
SELECT DISTINCT-- on regroupe les infos avec en plus l'idnoeud et la geom
n.idnoeud, 
n.geom, 
CASE WHEN nb_ouvass is null THEN '0'::integer ELSE nb_ouvass::integer END AS "nb_ouvass", -- remplace les null par 0
CASE WHEN nb_appass is null THEN '0'::integer ELSE nb_appass::integer END AS "nb_appass",  -- remplace les null par 0

-- on applique les règles de symbologie définie en interne
	-- on préfixe par le type objet lorsque type intéterminé ou autre, pour différencier les symbo dans appli entre les ouv et les app
CASE WHEN nb_ouvass = 1 THEN 
		(CASE WHEN fnouvass.valeur = 'Autre' OR fnouvass.valeur = 'Indéterminé' THEN  'ouvrage ' ||fnouvass.valeur
			ELSE fnouvass.valeur END) -- si un ouvrage est présent, on récupère fnouvass pour symboliser l'ouvrage selon son type
	WHEN (nb_ouvass is null AND nb_appass = 1) THEN 
		(CASE WHEN fnappass.valeur = 'Autre' OR fnappass.valeur = 'Indéterminé' THEN 'appareillage ' ||fnappass.valeur -- si pas d'ouvrages mais 1 appareillage, on prend le symbole de l'appareillage
			ELSE fnappass.valeur END) -- sinon on a de multiples appareillages
	ELSE 'multiples appareillages'
	END AS "symbole",

CASE WHEN nb_ouvass = 1 AND nb_appass is null THEN null -- on prépare valeur dans étiquettes dans le cas de plusieurs objets sur un même noeud
	WHEN nb_ouvass = 1 AND nb_appass > 0 THEN nb_appass
	WHEN nb_ouvass is null AND nb_appass = 1 THEN null
	WHEN nb_ouvass is null AND nb_appass > 1 THEN nb_appass
	ELSE '99' END AS "etiquette",
	
	req.fnappass_v, -- récupération type appareillages
	req.symbole_infobulle -- récupération symbole des infobulles


FROM m_raepa.geo_raepa_noeud n
LEFT JOIN req_nb_ouvass oa ON oa.idnoeud = n.idnoeud
LEFT JOIN req_nb_appass aa ON aa.idnoeud = n.idnoeud
LEFT JOIN m_raepa.an_raepa_ouv o ON o.idnoeud = n.idnoeud
LEFT JOIN m_raepa.an_raepa_ouvass ouva ON ouva.idobjet = o.idobjet
LEFT JOIN m_raepa.lt_raepal_fnouvass fnouvass ON fnouvass.code_arc = ouva.fnouvass
LEFT JOIN m_raepa.an_raepa_app a ON a.idnoeud = n.idnoeud
LEFT JOIN m_raepa.an_raepa_appass appa ON appa.idobjet = a.idobjet
LEFT JOIN m_raepa.lt_raepal_fnappass fnappass ON fnappass.code_arc = appa.fnappass
LEFT JOIN req_lt_appass req ON req.idnoeud = n.idnoeud
WHERE (nb_ouvass > 0 OR nb_appass > 0)
ORDER BY etiquette ASC
)
-- requête principale
SELECT
t.idnoeud,
t.nb_ouvass,
t.nb_appass,
t.symbole,
t.etiquette,
-- on met dans un attribut tous les symboles des appareillages présents, pour ensuite les afficher dans l'infobulle
CASE 
	WHEN nb_appass > 1 
	THEN '<div align="left"><u>Liste des appareillages</u><br>' || string_agg('<img src="http://geo.compiegnois.fr/documents/metiers/resh/raepa/symboles/symboles_ass_svg/export_png/' || symbole_infobulle || '" alt="" width="50"> ' ||
	rtrim(fnappass_v,'_0123456789') , '<br>') || '</div>' -- permet de supprimer les row number générés dans la sous requête précédente
 	ELSE ''
END
	AS info_bulle,
t.geom
FROM
req_t t
GROUP BY t.idnoeud, t.nb_ouvass, t.nb_appass,t.symbole,t.etiquette,t.geom
ORDER BY nb_appass DESC;



COMMENT ON MATERIALIZED VIEW x_apps.x_apps_geo_vmr_noeud_ass
  IS 'Vue matérialisée permettant de récupérer le noeud ainsi que le nombre d''ouvrages et/ou appareillages associés d''assainissement. Rafraichît lors de chaque intégration de données via FME';

GRANT ALL ON TABLE x_apps.x_apps_geo_vmr_noeud_ass TO sig_create;
	
	
/*****************************************************/
/*    VUE QUI CALCUL LES NB OUV ET APP PAR NOEUD (AEP)    */
/****************************************************/

CREATE MATERIALIZED VIEW x_apps.x_apps_geo_vmr_noeud_ae AS  --Rafraichît lors de chaque intégration de données via FME
WITH req_t AS( -- super sous requête pour préparer la requête finale
WITH -- -- sous requêtes
	
req_nb_ouvae AS -- récupération des nombres d'ouvrages ass par noeud
	(SELECT n.idnoeud, count (*) AS nb_ouvae 
	 FROM m_raepa.an_raepa_ouv o,m_raepa.an_raepa_ouvae oe, m_raepa.geo_raepa_noeud n 
	 WHERE o.idnoeud = n.idnoeud AND oe.idobjet = o.idobjet 
	 GROUP BY n.idnoeud),
	
req_nb_appae AS -- récupération des nombres d'appareillages ass par noeud
	(SELECT n.idnoeud, count (*) AS nb_appae 
	 from m_raepa.an_raepa_app a, m_raepa.an_raepa_appae ae, m_raepa.geo_raepa_noeud n 
	 WHERE a.idnoeud = n.idnoeud AND ae.idobjet = a.idobjet 
	 GROUP BY n.idnoeud 
	 order by n.idnoeud),

req_lt_appae AS -- récupération de tous les types d'appareillages d'ass dans un champ concaténé
(SELECT ae.idobjet, n.idnoeud, fnappaep.valeur || '_' || row_number() over() AS fnappaep_v, fnappaep.symbole AS symbole_infobulle
-- row_number permet de garder les deux symboles si deux app sont de même type, sinon, un seul est conservé dans l'application
 FROM m_raepa.an_raepa_appae ae 
 LEFT JOIN m_raepa.an_raepa_app a ON ae.idobjet = a.idobjet 
 LEFT JOIN m_raepa.geo_raepa_noeud n ON n.idnoeud = a.idnoeud
 LEFT JOIN m_raepa.lt_raepal_fnappaep fnappaep ON fnappaep.code_arc = ae.fnappaep
 ORDER BY idnoeud)	
	
-- sous requête principale	
SELECT DISTINCT-- -- on regroupe les infos avec en plus l'idnoeud et la geom
n.idnoeud, 
n.geom, 
CASE WHEN nb_ouvae is null THEN '0'::integer ELSE nb_ouvae::integer END AS "nb_ouvae",
CASE WHEN nb_appae is null THEN '0'::integer ELSE nb_appae::integer END AS "nb_appae",

-- on applique les règles de symbologie définie en interne
	-- on préfixe par le type objet lorsque type intéterminé ou autre, pour différencier les symbo dans appli entre les ouv et les app
CASE WHEN nb_ouvae = 1 THEN 
	(CASE WHEN fnouvaep.valeur = 'Autre' OR fnouvaep.valeur = 'Indéterminé' THEN  'ouvrage ' || fnouvaep.valeur
	 	  ELSE fnouvaep.valeur END)  -- si un ouvrage est présent, on récupère fnouvass pour symboliser l'ouvrage selon son type
	WHEN (nb_ouvae is null AND nb_appae = 1) THEN 
		(CASE WHEN fnappaep.valeur = 'Autre' OR fnappaep.valeur = 'Indéterminé' THEN 'appareillage ' ||fnappaep.valeur  
		 ELSE fnappaep.valeur END) -- si pas d'ouvrages mais 1 appareillage, on prend le symbole de l'appareillage
	ELSE 'multiples appareillages' 
	END AS "symbole",


CASE WHEN nb_ouvae = 1 AND nb_appae is null THEN null -- on prépare valeur dans étiquettes dans le cas de plusieurs objets sur un même noeud
	WHEN nb_ouvae = 1 AND nb_appae > 0 THEN nb_appae
	WHEN nb_ouvae is null AND nb_appae = 1 THEN null
	WHEN nb_ouvae is null AND nb_appae > 1 THEN nb_appae
	ELSE '99' END AS "etiquette",
	
	req.fnappaep_v,-- récupération type appareillages
	req.symbole_infobulle -- récupération symbole des infobulles
	
FROM m_raepa.geo_raepa_noeud n
LEFT JOIN req_nb_ouvae oe ON oe.idnoeud = n.idnoeud
LEFT JOIN req_nb_appae ae ON ae.idnoeud = n.idnoeud
LEFT JOIN m_raepa.an_raepa_ouv o ON o.idnoeud = n.idnoeud
LEFT JOIN m_raepa.an_raepa_ouvae ouve ON ouve.idobjet = o.idobjet
LEFT JOIN m_raepa.lt_raepal_fnouvaep fnouvaep ON fnouvaep.code_arc = ouve.fnouvaep
LEFT JOIN m_raepa.an_raepa_app a ON a.idnoeud = n.idnoeud
LEFT JOIN m_raepa.an_raepa_appae appe ON appe.idobjet = a.idobjet
LEFT JOIN m_raepa.lt_raepal_fnappaep fnappaep ON fnappaep.code_arc = appe.fnappaep
LEFT JOIN req_lt_appae req ON req.idnoeud = n.idnoeud
WHERE (nb_ouvae > 0 OR nb_appae > 0)
ORDER BY etiquette)

-- requête principale
SELECT
t.idnoeud,
t.nb_ouvae,
t.nb_appae,
t.symbole,
t.etiquette,
-- on met dans un attribut tous les symboles des appareillages présents, pour ensuite les afficher dans l'infobulle
CASE 
	WHEN nb_appae > 1 
	THEN '<div align="left"><u>Liste des appareillages</u><br>' || string_agg('<img src="http://geo.compiegnois.fr/documents/metiers/resh/raepa/symboles/symboles_aep_svg/export_png/' || symbole_infobulle || '" alt="" width="50"> ' ||
	rtrim(fnappaep_v,'_0123456789') , '<br>') || '</div>' -- permet de supprimer les row number générés dans la sous requête précédente
 	ELSE ''
END
	AS info_bulle,
t.geom
FROM
req_t t
GROUP BY t.idnoeud, t.nb_ouvae, t.nb_appae,t.symbole,t.etiquette,t.geom
ORDER BY symbole DESC;

COMMENT ON MATERIALIZED VIEW x_apps.x_apps_geo_vmr_noeud_ae
  IS 'Vue matérialisée permettant de récupérer le noeud ainsi que le nombre d''ouvrages et/ou appareillages associés d''eau potable. Rafraichît lors de chaque intégration de données via FME';

GRANT ALL ON TABLE x_apps.x_apps_geo_vmr_noeud_ae TO sig_create;	
	