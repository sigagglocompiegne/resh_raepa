![GeoCompiegnois](img/new_logo_geocompiegnois.png )

CREATION : 04-08-20.
DATE MISE A JOUR : 06-08-20.
AUTEUR : Léandre BÉRON.
STATUT : En Cours.

# Principes

Dans le cadre du projet sur les réseaux d'Eau et d'Assainissement ainsi que du standard national RAEPA, la collectivité souhaite prendre connaissance du patrimoine de ces réseaux à l'échelle du territoire auprès de ces concessionnaires auxquels elle délègue la compétence. 
En appui du standard national existant et des standards régionaux, l'objectif est de mettre en place une base de données étendue du standard national RAEPA, dans une logique de rendre la modélisation accessible pour tous types de réseaux.

Cette base de données a été conçue, au travers des échanges réguliers avec nos services métiers, ainsi que nos concessionnaires sur notre territoire.

# Étapes de modélisation

La première étape de ce projet est de s'orienter sur la modélisation des informations patrimoniales de ces réseaux, avant de se pencher sur les aspects des interventions, contextuels, d'habillages ou encore de gestion.

## Architecture de base
Après analyses et mise en place d'un diagnostic entre les différents standards (national et locaux) ainsi que des expériences du service sur d'autres projets de réseaux, l'architecture des classes a été définie dans un premier temps afin de stocker les informations patrimoniales des réseaux.

![Picto](img/logicogramme_infra_base.png)

### Cardinalités

|TABLE DEPART|DEPART|TABLE DESTINATION|ARRIVE|
|:---|:-|:---|:-|
|an_raepal_objet_reseau|(0,1)|an_raepa_canal|(1,1)|
|an_raepal_objet_reseau|(0,1)|an_raepa_app|(1,1)|
|an_raepal_objet_reseau|(0,1)|an_raepa_ouv|(1,1)|
|geo_raepal_troncon|(0,1)|an_raepa_canal|(1,1)|
|geo_raepa_noeud|(0,1)|an_raepa_app|(1,1)|
|geo_raepa_noeud|(0,1)|an_raepa_ouv|(1,1)|
|an_raepa_app|(0,1)|an_raepa_ouv|(0,1)|
|geo_raepa_noeud|(0,1)|an_raepa_app|(1,1)|
|an_raepa_canal|(0,1)|an_raepa_canalass|(1,1)|
|an_raepa_canal|(0,1)|an_raepa_canalae|(1,1)|
|an_raepa_app|(0,1)|an_raepa_appass|(1,1)|
|an_raepa_app|(0,1)|an_raepa_appae|(1,1)|
|an_raepa_ouv|(0,1)|an_raepa_ouvass|(1,1)|
|an_raepa_ouv|(0,1)|an_raepa_ouvae|(1,1)|

Remarque : Concernant la table geo_raepal_troncon, la cardinalité de départ est de 0,1. En effet, En prenant en compte la disponibilité de cette modélisation pour tous réseaux, on peut imaginer greffer ultérieurement les écoulements de surfaces, ou encore les réseaux éléctriques. Le tronçon sera donc rattaché à l'un des réseau et non uniquement pour une canalisation.


# Dépendances

La base de données RAEPA s'appuie sur des référentiels préexistants constituant autant de dépendances que nécessaires pour l'implémentation de certaines informations dans la BdD.

|SCHEMA|TABLE/VUE|DESCRIPTION|USAGE|
|:---|:---|:---|:---|
|A COMPLETER||| Détermine le code INSEE des objets du réseau par jointure spatiale |
|A COMPLETER|||Détermine le domaine Privée ou Public de l'objet du réseau par rapport au référentiel cadastral |
|A COMPLETER|||Détermine l'adresse de localisation de l'objet à partir de jointure spatiale du référentiel des voies et adresses |

# Séquences

De façon général, nous avons entendu la création d'une séquence pour les objets du réseau, quelqu'il soit, ainsi que la génération d'une séquence pour chaque compléments d'informations. Il a été convenu que les géométries sont des informations complémentaires au patrimoine du réseau. Par conséquent, nous générerons 3 séquences : 

* raepa_id_obj_reseau_seq : Séquence permettant de générer un numéro unique pour un objet de réseau.
* raepa_id_noeud_seq : Séquence permettant de générer un numéro unique par noeud de réseau.
* raepap_id_tronc_seq : Séquence permettant de générer un numéro unique par tronçon de réseau.

En conséquence, ces choix permettent de pouvoir identifier un objet de réseau, quelque soit ce réseau, de manière unique. Nous aurions très bien pu générer une séquence par réseau ou encore par type d'objet, ou encore de manière combinée, mais cela aura pour conséquence des doublons d'identifiants dans la superclasse d'objets de réseau, évoquée ci-après.

# Collecte du patrimoine

Afin de pouvoir identifier les informations qui sont issues du standard national ou des extensions locales, nous utiliserons la codification suivante :

* Nomenclature des classes : raepa_[nom_classe] pour les informations issues du RAEPA et raepal_[nom_classe] pour les informations issues d'extension locale
* Nomenclature des attributs : Ajout du préfixe "l_" devant chaque attribut issu de l'extension locale.

## Définition des classes

Certains attributs présents dans la modélisation du standard national ont été déplacé dans une autre classe. Leur définition est donc adapté au circonstance (exemple attribut `enservice`)

### Niveau 0 - Superclasse Objet de Réseau
`an_raepal_objet_reseau` : Superclasse regroupant les informations communes à tous types d'objet du réseau

|Nom attribut|Définition|Type|Contrainte|Valeurs|
|:---|:---|:---|:---|:---|
|idobjet|Identifiant unique de l'objet du réseau.|bigint|Primary Key|nextval('m_raepa.raepa_id_obj_reseau_seq'::regclass)|
|idprest|Identifiant du prestataire de l'objet|character varying  (254).|Obligatoire||
|l_reseau|Définit le type de réseau de l'objet selon la convention DT-DICT.|character varying  (4)|Obligatoire|ASS/AEP|
|l_typobjet|Définit le type d'objet du réseau.|character varying  (20)|Obligatoire|Canalisation/Ouvrage/Appareillage|
|l_sandre|Code SANDRE.|character varying (254)|||
|l_insee|Code INSEE de la commune de localisation de l'objet du réseau.|character varying  (5)|Obligatoire||
|l_nom_rue|Adressage du nom de la rue où est positionné l'objet.|character varying  (254)|Olibgatoire|Jointure spatiale avec le référentiel Voies et Adresses| 
|l_domaine|Domaine auquel appartient l'objet du réseau.|character varying  (2)||lt_raepal_domaine|
|mouvrage|Maître d'ouvrage du réseau.|character varying  (100)|Obligatoire||
|gexploit|Gestionnaire exploitant du réseau.|character varying  (100)|Obligatoire||
|andebpose|Année marquant le début de pose de l'objet de réseau.|character varying  (4)|||
|anfinpose|Année marquant la fin de pose de l'objet de réseau.|character varying  (4)|||
|l_marque|Marque commerciale de l'objet|character varying (100)|||
|materiau|Matériau du tronçon.|character varying  (2)|Obligatoire|lt_raepal_materiau
|enservice|Objet en service ou non (abandonné).|character varying  (1)||O,N|
|l_criticit|Objet en criticité ou non.|character varying  (1)||O,N|
|l_etat|Etat de l'objet.|character varying  (2)||lt_raepal_etat|
|l_entrpose|Entreprise ayant réalisée la pose de l'objet de réseau.|character varying  (100)|||
|(l_propdata)|Propriétaire de la donnée de l'objet du réseau.|character varying  (100)|||
|qualglocxy|Qualité de la géolocalisation planimétrique (XY).|character varying  (2)|Obligatoire|lt_raepa_qualite_geoloc|
|qualglocz|Qualité de la géolocalisation altimétrique (Z).|character varying  (2)|Obligatoire|lt_raepa_qualite_geoloc|
|datemaj|Date de la dernière mise à jour des informations.|Timestamp without time zone|Obligatoire||
|sourmaj|Source de la mise à jour.|character varying  (100)|Obligatoire||
|qualannee|Fiabilité, lorsque ANDEBPOSE = ANFINPOSE, de l'année de pose.|character varying  (2)|||
|dategeoloc|Date de la géolocalisation.|Timestamp without time zone|||
|sourgeoloc|Auteur de la géolocalisation.|character varying  (100)|||
|autattrib|Auteur de la saisie des données attributaires (lorsque différent de l'auteur de la géolocalisation).|character varying  (100)|||
|(l_comment)|Commentaire sur l'objet du réseau.|character varying  (254)|||

### Niveau 1 - Classes géométriques
`geo_raepal_tronc` : Classe géométrique portant les informations communes d'un tronçon de réseau

|Nom attribut|Définition|Type|Contrainte|Valeurs|
|:---|:---|:---|:---|:---|
|idtronc|Identifiant unique du tronçon de réseau.|Bigint|Primary Key|nextval('m_raepa.raepa_id_tronc_seq'::regclass)|
|sensecoul|Sens de l'écoulement dans la canalisation d'assainissement collectif 0 (noeud terminal → noeud initial) • 1 (noeud initial → noeud terminal)|character varying  (1)||0,1|
|long_mes|Longueur mesurée du tronçon, en mètre.|Integer|||
|l_long_cal|Longueur calculée du tronçon, en mètre.|Integer|||
|idnini|Identifiant du noeud initial du tronçon.|Bigint|Foreign Key, Obligatoire||
|idnterm|Identifiant du noeud terminal du tronçon.|Bigint|Foreign Key, Obligatoire||
|idtrppal|Identifiant du tronçon principal.|Bigint|Foreign Key||
|geom|Attribut portant la géométrie du tronçon, RGF93.|Linestring,2154|Obligatoire||

Remarque : L'attribut "longcana" du standard RAEPA a été renommé par "long_mes" pour cohérence avec l'ajout de l'attribut de la longueur calculée nommé "l_long_cal"
De plus, en cohérence avec le choix du type Entier du modèle RAEPA, la longueur calculée sera du même type, soit Entier.

`geo_raepa_noeud` : Classe géométrique portant les informations communes d'un noeud de réseau

|Nom attribut|Définition|Type|Contrainte|Valeurs|
|:---|:---|:---|:---|:---|
|idnoeud|Identifiant unique d'un nœud de réseau.|Bigint|Primary Key|nextval('m_raepa.raepa_id_noeud_seq'::regclass)|
|x|Coordonnée X Lambert 93 (en mètres)|Decimal (10,3)|Obligatoire||
|y|Coordonnée X Lambert 93 (en mètres)|Decimal (10,3)|Obligatoire||
|idtramont|Identifiant du tronçon amont du noeud|Bigint||null
|idtraval|Identifiant du tronçon aval du noeud|Bigint||null
|itrppal|Identifiant du tronçon principal du noeud|Bigint||null
|geom|Attribut portant la géométrie du noeud, RGF93.|Point,2154|Obligatoire||

### Niveau 2 - Classes d'objets
`an_raepa_canal` : Classe alphanumérique portant les informations génériques d'une canalisation.

|Nom attribut|Définition|Type|Contrainte|Valeurs|
|:---|:---|:---|:---|:---|
|idobjet|Identifiant unique de l'objet du réseau.|bigint|Primary Key|nextval('m_raepa.raepa_id_obj_reseau_seq'::regclass)|
|idprest|Identifiant du prestataire de l'objet|character varying  (254).|Obligatoire||
|l_forme|Forme (Section) de la canalisation d'Assainissement collectif.|character varying (2)||lt_raepal_forme_canal_ass|
|l_dimension|Dimensions de la canalisation lorsque forme non circulaire, en mètres.|character varying (20)|||
|branchmnt|Tronçon de branchement individuel : O Tronçon de transport ou de distribution : N.|character varying  (1)|Obligatoire|O,N|
|l_aerien|Définit si la canalisation est aerienne ou enterré|character varying  (2)||lt_raepal_booleen|
|diametre|Diamètre nominal de la canalisation (en millimètres)|Interger|Obligatoire||
|l_protext|Protection extérieur potentiellement associé à la canalisation|character varying  (2)||lt_raepal_protection_ext|
|modecirc|Mode de circulation de l'eau à l'intérieur de la canalisation|character varying  (2)|Obligatoire|lt_raepa_mode_circultation|
|l_cote_tn|Côte du terrain naturel en mètre (Référentiel NGF IGN69).|Decimal (5,2)|||
|l_cote_gs|Côte de la génératrice supérieure en mètre (Référentiel NGF IGN69).|Decimal (5,2)|||
|profgen|Profondeur moyenne de la génératrice supérieure de la canalisation|Decimal (3,2)|||
|nbranche|Nombre de branchements individuels sur la canalisation.|Integer|||
|l_aut_pass|Définit s'il existe un droit de servitude ou non|character varying (2)||lt_raepal_booleen|
|idtronc|Identifiant unique du tronçon d'un réseau.|Bigint|Foreign Key, Obligatoire||

Remarque : L'attribut "sensecoul" issu du RAEPA a été déplacé aux canalisations. Il sera demandé en extension locale pour le réseau d'Adduction d'Eau Potable.

`an_raepa_ouv` : Classe alphanumérique portant les informations génériques d'un ouvrage de réseau.

|Nom attribut|Définition|Type|Contrainte|Valeurs|
|:---|:---|:---|:---|:---|
|idobjet|Identifiant unique de l'objet du réseau.|bigint|Primary Key|nextval('m_raepa.raepa_id_obj_reseau_seq'::regclass)|
|idprest|Identifiant du prestataire de l'objet|character varying  (254).|Obligatoire||
|l_nom|Nom de l'ouvrage.|character varying (254)|||
|z|Altitude (en mètres, référentiel NGF-IGN69).|Decimal (6,3)|||
|l_cote_tn|Côte du terrain naturel en mètre (Référentiel NGF IGN69).|Decimal (5,2)|||
|l_cote_rad|Côte du radier en mètre (Référentiel NGF IGN69).|Decimal (5,2)|||
|l_profond|Prondeur de l'ouvrage|Decimal (5,2)||Différence entre cote_tn - cote_rad
|idnoeud|Identifiant unique du noeud de réseau.|Bigint|Foreign Key, Obligatoire||


`an_raepa_app` : Classe alphanumérique portant les informations génériques d'un appareillage de réseau.

|Nom attribut|Définition|Type|Contrainte|Valeurs|
|:---|:---|:---|:---|:---|
|idobjet|Identifiant unique de l'objet du réseau.|bigint|Primary Key|nextval('m_raepa.raepa_id_obj_reseau_seq'::regclass)|
|idprest|Identifiant du prestataire de l'objet|character varying  (254).|Obligatoire||
|diametre|Diamètre nominal de l'appareillage (en millimètres).|Integer|Obligatoire||
|z|Altitude (en mètres, référentiel NGF-IGN69).|Decimal (6,3)|||
|idouvrage|Identifiant de l'ouvrage dans lequel se situe l'appareil.|Bigint|Foreign Key||
|idnoeud|Identifiant unique du noeud de réseau.|Bigint|Foreign Key, Obligatoire||


### Niveau 3 - Classes d'objets métiers
`an_raepa_canalass` : Classe alphanumérique portant les informations génériques d'une canalisation d'Assainissement collectif.

|Nom attribut|Définition|Type|Contrainte|Valeurs|
|:---|:---|:---|:---|:---|
|idobjet|Identifiant unique de l'objet du réseau.|bigint|Primary Key|nextval('m_raepa.raepa_id_obj_reseau_seq'::regclass)|
|idprest|Identifiant du prestataire de l'objet|character varying  (254)|Obligatoire||
|typreseau|Type du réseau d'assainissement collectif.|character varying (2)|Obligatoire|lt_raepa_typ_reseau|
|contcanass|Catégorie de la canalisation d'assainissement collectif.|character varying (2)|Obligatoire|lt_raepa_cat_canal_ass|
|fonccannass|Fonction de la canalisation d'assainissement collectif.|character varying (2)|Obligatoire|lt_raepa_fonc_canal_ass|
|zamont|Altitude à l'extrémité amont (en mètres, Référentiel NGFIGN69).|Decimal (6,3)|||
|zaval|Altitude à l'extrémité aval (en mètres, Référentiel NGF-IGN69).|Decimal (6,3)|||
|l_file_amt|Fil eau à l'extrémité amont (en mètres, Référentiel NGFIGN69).|Decimal (6,3)|||
|l_file_avl|Fil eau à l'extrémité aval (en mètres, Référentiel NGFIGN69).|Decimal (6,3)|||
|l_pente|Pente, exprimée en %.|Decimal (3,1)|||
|l_penter|Contre pente, exprimée en %.|Decimal (3,1)|||

`an_raepa_canalae` : Classe alphanumérique portant les informations génériques d'une canalisation d'Adduction d'eau potable.

|Nom attribut|Définition|Type|Contrainte|Valeurs|
|:---|:---|:---|:---|:---|
|idobjet|Identifiant unique de l'objet du réseau.|bigint|Primary Key|nextval('m_raepa.raepa_id_obj_reseau_seq'::regclass)|
|idprest|Identifiant du prestataire de l'objet|character varying  (254).|Obligatoire||
|contcanaep|Catégorie de la canalisation d'adduction d'eau potable|character varying (2)|Obligatoire|lt_raepa_cat_canal_ae|
|foncanaep|Fonction de la canalisation d'adduction d'eau potable|character varying (2)|Obligatoire|lt_raepa_fonc_canal_ae|
|l_fileau|Altitude fil d'eau ou charge en mètres.|Decimal (6,3)|||
|l_pression|Pression moyenne dans la canalisation, en bars.|Decimal (6,3)|||
|l_protcath|Existence d'une protection cathodique.|character varying (2)||lt_raepal_booleen|
|l_protint|Type de protection interne de la canalisation d'assainissement collectif.|character varying (2)||lt_raepal_protection_int|
|l_indperte|Indice linéaire de perte|?|||


`an_raepa_appass` : Classe alphanumérique portant les informations génériques d'un appareillage d'Assainissement collectif.

|Nom attribut|Définition|Type|Contrainte|Valeurs|
|:---|:---|:---|:---|:---|
|idobjet|Identifiant unique de l'objet du réseau.|bigint|Primary Key|nextval('m_raepa.raepa_id_obj_reseau_seq'::regclass)|
|idprest|Identifiant du prestataire de l'objet|character varying  (254).|Obligatoire||
|typreseau|Type du réseau d'assainissement collectif.|character varying (2)|Obligatoire|lt_raepa_typ_reseau|
|fnpappass|Types d'un appareillage d'assainissement collectif.|Obligatoire|lt_raepal_fonc_app_ass|
|l_acces|Définit si l'appareillage d'assainissement collectif est accessible ou non.|character varying (2)||lt_raepal_booleen|
|l_autpass|Définit si il y a servitude ou non.|character varying (2)||lt_raepal_booleen|


`an_raepa_appae` : Classe alphanumérique portant les informations génériques d'une appareillage d'Adduction d'eau potable.

|Nom attribut|Définition|Type|Contrainte|Valeurs|
|:---|:---|:---|:---|:---|
|idobjet|Identifiant unique de l'objet du réseau.|bigint|Primary Key|nextval('m_raepa.raepa_id_obj_reseau_seq'::regclass)|
|idprest|Identifiant du prestataire de l'objet|character varying  (254).|Obligatoire||
|fnappaep|Fonction de l'appareillage d'adduction d'eau potable.|character varying (2)|Obligatoire|lt_raepa_fonc_app_ae|
|l_debit|Débit nominal de l'appareillage d'eau potable en m3/h.|Decimal (5,2)|||

`an_raepa_ouvass` : Classe alphanumérique portant les informations génériques d'un ouvrage d'Assainissement collectif.

|Nom attribut|Définition|Type|Contrainte|Valeurs|
|:---|:---|:---|:---|:---|
|idobjet|Identifiant unique de l'objet du réseau.|bigint|Primary Key|nextval('m_raepa.raepa_id_obj_reseau_seq'::regclass)|
|idprest|Identifiant du prestataire de l'objet|character varying  (254).|Obligatoire||
|typreseau|Type du réseau d'assainissement collectif.|character varying (2)|Obligatoire|lt_raepa_typ_reseau|
|fnouvass|Type d'un ouvrage d'assainissement collectif|character varying (2)|Obligatoire|lt_raepal_fonc_ouv_ass|


`an_raepa_ouvae` : Classe alphanumérique portant les informations génériques d'un ouvrage d'Adduction d'eau potable.

|Nom attribut|Définition|Type|Contrainte|Valeurs|
|:---|:---|:---|:---|:---|
|idobjet|Identifiant unique de l'objet du réseau.|bigint|Primary Key|nextval('m_raepa.raepa_id_obj_reseau_seq'::regclass)|
|idprest|Identifiant du prestataire de l'objet|character varying  (254).|Obligatoire||
|fnouvaep|Fonction de l'ouvrage d'adduction d'eau potable.|character varying (2)|Obligatoire|lt_raepal_fonc_ouv_ae|

### Niveau 4 - Classes spécialisées d'objets de réseau

#### Canalisation
Aucune classe spécialisée concernant les canalisations.

#### Ouvrages

#### Appareillages
`an_raepal_pt_brcht_ass` : Classe alphanumérique portant les informations génériques d'un point de branchement de réseau d'Assainissement collectif.

|Nom attribut|Définition|Type|Contrainte|Valeurs|
|:---|:---|:---|:---|:---|
|idobjet|Identifiant unique de l'objet du réseau.|bigint|Primary Key|nextval('m_raepa.raepa_id_obj_reseau_seq'::regclass)|
|idprest|Identifiant du prestataire de l'objet|character varying  (254).|Obligatoire||
|l_typ_racc|Type de raccord de branchement|character varying (2)||lt_raepal_typ_raccord_ass|
|l_boitbrt|Présence d'une boîte de branchement|character varynig (2)||lt_raepal_booleen|
|l_usager|Type d'usager relié au point de branchement d'Assainissement collectif|character varying (2)|lt_raepal_typ_usager|
|l_conform|Définit si le branchement d'Assainissement collectif est conforme.|character varying (2)||lt_raepal_booleen|

`an_raepal_pt_brcht_ae` : Classe alphanumérique portant les informations génériques d'un point de branchement de réseau d'Adduction d'eau potable.

|Nom attribut|Définition|Type|Contrainte|Valeurs|
|:---|:---|:---|:---|:---|
|idobjet|Identifiant unique de l'objet du réseau.|bigint|Primary Key|nextval('m_raepa.raepa_id_obj_reseau_seq'::regclass)|
|idprest|Identifiant du prestataire de l'objet|character varying  (254).|Obligatoire||
|l_usager|Type d'usager relié au point de branchement d'Assainissement collectif|character varying (2)|lt_raepal_typ_usager|
|l_nb_compt|Nombre de compteur sur le point de branchement d'Adduction d'eau potable.|Integer|||

`an_raepal_vidange_ae` : Classe alphanumérique portant les informations génériques d'un appareillage d'Adduction d'eau potablede type vidange.

|Nom attribut|Définition|Type|Contrainte|Valeurs|
|:---|:---|:---|:---|:---|
|idobjet|Identifiant unique de l'objet du réseau.|bigint|Primary Key|nextval('m_raepa.raepa_id_obj_reseau_seq'::regclass)|
|idprest|Identifiant du prestataire de l'objet|character varying  (254).|Obligatoire||
|l_position|Position de l'appareillage de vidange.|character varying (2)||lt_raepal_position|
|l_exutoire|Type d'éxutoire.|character varying (2)||lt_raepal_typ_exutoire|

## Définition des listes de domaines
### Niveau 0
`lt_raepal_domaine` : Liste décrivant le domaine d'appartenance du réseau.
|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|10|Privé|
|20|Public|
|99|Autre|

`lt_raepa_qualite_geoloc` : Liste décrivant la qualité de géolocalisation.
|Code|Valeur|Définition|
|:---|:---|:---|
|01|Classe A|Classe de précision inférieure 40 cm|
|02|Classe B|Classe de précision supérieure à 40 cm et inférieure à 1,50 m|
|03|Classe C|Classe de précision supérieure à 1,50 m|

`lt_raepa_qualite_annee` : Liste décrivant la fiabilité de lorsque ANDEBPOSE = ANFINPOSE.
|Code|Valeur|Définition|
|:---|:---|:---|
|00|Indéterminée|Information ou qualité de l'information inconnue|
|01|Certaines|Année constatée durant les travaux de pose|
|02|Récolement|Année reprise sur plans de récolement|
|03|Projet|Année reprise sur plans de projet|
|04|Mémoire|Année issue de souvenir(s) individuel(s)|
|05|Déduite|Année déduite du matériau ou de l'état de l'équipement|

`lt_raepal_etat` : Liste décrivant l'état d'un objet.
|Code|Valeur|
|:---|:---|
|00|Indéterminée|
|01|Très mauvais état|
|02|Mauvais état|
|03|Bon état|
|04|Très bon état|
|05|Etat neuf|
|99|Autre|


`lt_raepal_materiau` : Liste décrivant le type de matériau (utilisée également dans d'autres niveaux).
|Code ARC|Code RAEPA|Valeur|
|:---|:---|:---|
|00-00|00|Non renseigné|
|01-00|01|Acier|
|02-00|02|Amiante ciment|
|03-00|99|Béton|
|03-01|03|Béton âme tôle|
|03-02|04|Béton armé|
|03-03|05|Béton fibré|
|03-04|06|Béton non armé|
|03-99|99|Béton autre|
|04-00|07|Cuivre|
|05-00|99|Fibre|
|05-01|08|Fibre ciment|
|05-02|09|Fibre de verre|
|05-03|10|Fibrociment|
|05-99|99|Fibre autre|
|06-00|99|Fonte|
|06-01|11|Fonte ductile|
|06-02|12|Fonte grise|
|06-99|99|Fonte autre|
|07-00|13|Grès|
|08-00|14|Maçonnerie|
|09-00|15|Meulière|
|10-00|99|PE|
|10-10|16|PEBD|
|10-20|99|PEHD|
|10-21|17|PEHD annelé|
|10-22|18|PEHD lisse|
|10-99|99|PE autre|
|11-00|19|Plomb|
|12-00|99|PP|
|12-01|20|PP annelé|
|12-02|21|PP lisse|
|12-99|99|PP autre|
|13-00|99|PRV|
|13-01|22|PRV A|
|13-02|23|PRV B|
|13-99|99|PRV autre|
|14-00|99|PVC|
|14-10|24|PVC ancien|
|14-20|25|PVC BO|
|14-30|99|PVC U|
|14-31|26|PVC U annelé|
|14-32|27|PVC U lisse|
|14-99|99|PVC autre|
|15-00|99|Tôle|
|15-01|28|Tôle galvanisée|
|15-99|99|Tôle autre|
|99-00|99|Autre|


### Niveau 1

Aucune liste de valeurs pour ce niveau.

### Niveau 2

`lt_raepal_forme_canal` : Liste décrivant la forme de la canalisation.
|Code|Valeur|
|:---|:---|
|00|Indéterminée|
|01|Circulaire|
|02|Ovoïde|
|03|Dallot|
|99|Autre|

`lt_raepal_protection_ext` : Liste décrivant le type de protection extérieur de la canalisation.
|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|01|Aucune|
|02|Polyéthylène|
|03|Polypropylène|
|04|Zinc|
|05|Bitumeux|
|99|Autre|

`lt_raepal_booleen` : Liste de faux booléen (utilisée également dans d'autres niveaux).
|Code|Valeur|
|:---|:---|
|00|Non renseignée|
|01|Oui|
|02|Non|

`lt_raepa_mode_circulation` : Liste décrivant les différents modes de circulation.
|Code|Valeur|Définition|
|:---|:---|:---|
|00|Indéterminé|Mode de circulation inconnu|
|01|Gravitaire|L'eau s'écoule par l'effet de la pesanteur dans la canalisation en pente|
|02|Forcé|L'eau circule sous pression dans la canalisation grâce à un système de pompage|
|03|Sous-vide|L'eau circule par l'effet de la mise sous vide de la canalisation par une centrale d'aspiration|
|99|Autre|L'eau circule tantôt dans un des modes ci-dessus tantôt dans un autre|

### Niveau 3

`lt_raepa_typ_reseau` : Liste décrivant le type de réseau d'assainissement collectif.
|Code|Valeur|Définition|
|:---|:---|:---|
|01|Pluvial|Réseau de collecte de seules eaux pluviales|
|02|Eaux usées|Réseau de collecte de seules eaux usées|
|03|Unitaire|Réseau de collecte des eaux usées et des eaux pluviales|


`lt_raepa_cat_canal_ass` : Liste décrivant la nature des eaux véhiculées par une canalisation d'assainissement collectif.
|Code|Valeur|Définition|
|:---|:---|:---|
|00|Indéterminée|Nature des eaux véhiculées par la canalisation inconnue
|01|Pluvial|Canalisation véhiculant des eaux pluviales|
|02|Eaux usées|Canalisation véhiculant des eaux usées|
|03|Unitaire|Canalisation véhiculant des eaux usées et pluviales en fonctionnement normal|
|99|Autre|Canalisation véhiculant tantôt des eaux pluviales, tantôt des eaux usées|


`lt_raepa_fonc_canal_ass` : Liste décrivant la fonction dans le réseau d'une canalisation d'assainissement collectif.
|Code|Valeur|Définition|
|:---|:---|:---|
|00|Indéterminée|Fonction de la canalisation dans le réseau inconnue
|01|Transport|Canalisation de transport
|02|Collecte|Canalisation de collecte
|99|Autre|Canalisation dont la fonction dans le réseau ne figure pas dans la liste ci-dessus|

`lt_raepa_cat_canal_ae` : Liste décrivant la nature des eaux véhiculées par une canalisation d'adduction d'eau.
|Code|Valeur|Définition|
|:---|:---|:---|
|00|Indéterminée|Nature des eaux véhiculées par la canalisation inconnue
|01|Eau brute|Canalisation véhiculant de l'eau brute|
|02|Eau potable|Canalisation véhiculant de l'eau potable|
|99|Autre|Canalisation véhiculant tantôt de l'eau brute, tantôt de l'eau potable|

`lt_raepa_fonc_canal_ae` : Liste décrivant la fonction dans le réseau d'une canalisation d'adduction d'eau.
|Code|Valeur|Définition|
|:---|:---|:---|
|00|Indéterminée|Fonction de la canalisation dans le réseau inconnue|
|01|Transport|Canalisation de transport|
|02|Distribution|Canalisation de distribution|
|99|Autre|Canalisation dont la fonction dans le réseau ne figure pas dans la liste ci-dessus|


`lt_raepal_protection_int` : Liste décrivant le type de protection interne d'une canalisation d'eau potable.
|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|01|Aucune|
|02|Ciment|
|03|Époxy|
|04|Bitumeux|
|99|Autre|

`lt_raepal_fonc_app_ass` : Liste décrivant le type d'un appareillage d'assainissement collectif.
|Code ARC|Code RAEPA|Valeur|Définition|
|:---|:---|:---|:---|
|00|00|Indéterminé|Type d'appareillage inconnu|
|01|01|Point de branchement|Piquage de branchement individuel|
|02|02|Ventouse|Ventouse d'assainissement|
|03|03|Vanne|Vanne d'assainissement|
|04|04|Débitmètre|Appareil de mesure des débits transités|
|05|99|Point métrologique|Point métrologique|
|06|99|Batardeau|Batardeau|
|07|99|Chasse|Chasse|
|08|99|Exutoire eaux pluviales|Exutoire eaux pluviales|
|99|Autre|Appareillage dont le type ne figure pas dans la liste ci-dessus|

`lt_raepa_fonc_app_ae` : Liste décrivant le type d'un appareillage d'adduction d'eau|
|Code|Valeur|Définition|
|:---|:---|:---|
|00|Indéterminé|Type d'appareillage inconnu|
|01|Point de branchement|Piquage de branchement individuel|
|02|Ventouse|Ventouse d'adduction d'eau|
|03|Vanne|Vanne d'adduction d'eau|
|04|Vidange|Vidange d'adduction d'eau|
|05|Régulateur de pression|Régulateur de pression|
|06|Hydrant|Poteau de défense contre l'incendie|
|07|Compteur|Appareil de mesure des volumes transités|
|08|Débitmètre|Appareil de mesure des débits transités|
|99|Autre|Appareillage dont le type ne figure pas dans la liste ci-dessus|

`lt_raepal_fonc_ouv_ass` : Liste décrivant le type d'ouvrage d'assainissement collectif|
|Code ARC|Code RAEPA|Valeur|Définition|
|:---|:---|:---|:---|
|00|00|Indéterminé|Type d'ouvrage inconnu|
|01|01|Station de pompage|Station de pompage d'eaux usées et/ou pluviales|
|02|02|Station d'épuration|Station de traitement d'eaux usées|
|03|03|Bassin de stockage|Ouvrage de stockage d'eaux usées et/ou pluviales|
|04|04|Déversoir d'orage|Ouvrage de décharge du trop-plein d'effluents d'une canalisation d'assainissement collectif vers un milieu naturel récepteur|
|05|05|Rejet|Rejet (exutoire) dans le milieu naturel d'eaux usées ou pluviales|
|06|06|Regard|Regard|
|07|07|Avaloir|Avaloir|
|08|99|Station sous-vide|
|09|99|Chambre à sable|
|99|99|Autre|Ouvrage dont le type ne figure pas dans la liste ci-dessus|


`lt_raepal_fonc_ouv_ae` : Liste décrivant le type d'ouvrage d'Adduction d'eau potable|
|Code ARC|Code RAEPA|Valeur|Définition|
|:---|:---|:---|:---|
|00-00|00|Indéterminé|Type d'ouvrage inconnu|
|01-00|01|Station de pompage|Station de pompage d'eau potable|
|02-00|02|Station de traitement|Station de traitement d'eau potable|
|03-00|03|Réservoir|Réservoir d'eau potable|
|04-00|04|Déversoir d'orage|
|05-00|05|Rejet|Rejet (exutoire) dans le milieu naturel d'eaux usées ou pluviales|
|06-01|06|Chambre de comptage|Chambre de comptage|
|07-00|07|Captage|Captage|
|99-99|99|Autre|Ouvrage dont le type ne figure pas dans la liste ci-dessus|

### Niveau 4

`lt_raepal_typ_usager` : Liste décrivant le type d'usager raccordé à l'appareillage de point de branchement d'Assainissement collectif.
|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|01|Domestique|
|02|Industriel|
|03|Collectif|
|04|Agricole|
|99|Autre|

`lt_raepal_typ_raccord_ass` : Liste décrivant le type de raccord du point de branchement d'Assainissement collectif.
|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|01|Boîte de raccordement à passage direct|
|02|Boîte de raccordement à passage siphoïde|
|03|Boîte de raccordement multidirectionnel|
|99|Autre|


`lt_raepal_typ_exutoire` : Liste décrivant le type d'éxutoire de l'appareillage de vidange d'Adduction d'eau potable.
|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|01|Milieu naturel|
|02|Pluvial|
|99|Autre|

`lt_raepal_position` : Liste décrivant la position de l'appareillage de vidange d'Adduction d'eau potable.
|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|01|En regard|
|02|Sous bouche à clé|
|99|Autre|

# Collecte d'informations non patrimoniales

Au fil des discussions avec les services métiers concernés, des souhaits de conservation d'informations plutôt engagée sur les aspects de gestions, interventions ou de contextes ont été évoqué.

Non rattaché au patrimoine, ils sont office d'une prochaine étape de modélisation, mais sont recensés ci-dessous, afin de ne pas les oublier :

|Réseau|Type objet|Nom attribut|Définition|Commentaire|
|:---|:---|:---|:---|:---|
|AEP et ASS|Canalisation|l_agressiv|Aggressivité du sol à proximité de la canalisation|Comparaison avec une couche géologique ? Qui détient l'information ?|
|AEP et ASS|Canalisation|l_env_elec|Présence d'un réseau éléctrique à proximité|Possibilité de croiser avec le réseau électrique quand nous le détiendrons, ou obligation de connaître la maîtrise de cette information chez nos concessionnaires|
|AEP et ASS|Canalisation|l_nappe|Présence d'une nappe aux abords de la canalisation|Couche spatiale de l'emprise des nappes. Qui a cette donnée ?|
|AEP et ASS|Canalisation|l_recolemt|Lien vers le plan de récolement||
|AEP et ASS|Canalisation|l_nivtrafi|Niveau de trafic à proximité de la canalisation.| Qui détient l'information ? Information contextuelle.
|AEP et ASS|TOUT||| Information accès sur un état après travaux d'un objet de réseau. lt_raepal_type_origine.



`lt_raepal_type_origine` : Définit l'origine de cet objet sur le réseau.
|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|01|Création|
|02|Réhabilitation|
|03|Renouvellement|
|04|Renforcement|
|99|Autre|
