![GeoCompiegnois](img/new_logo_geocompiegnois.png )

CREATION : 04-08-20.
DATE MISE A JOUR : 05-08-20.
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

# Dépendances

La base de données RAEPA s'appuie sur des référentiels préexistants constituant autant de dépendances que nécessaires pour l'implémentation de certaines informations dans la BdD.

|SCHEMA|TABLE|DESCRIPTION|USAGE|
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
|l_insee|Code INSEE de la commune de localisation de l'objet du réseau.|character varying  (5)|Obligatoire||
|l_nom_rue|Adressage du nom de la rue où est positionné l'objet.|character varying  (254)|Olibgatoire|Jointure spatiale avec le référentiel Voies et Adresses| 
|l_domaine|Domaine auquel appartient l'objet du réseau.|character varying  (2)||lt_raepal_domaine|
|mouvrage|Maître d'ouvrage du réseau.|character varying  (100)|Obligatoire||
|gexploit|Gestionnaire exploitant du réseau.|character varying  (100)|Obligatoire||
|l_typimplt|Type d'implantation de l'objet du réseau.|character varying  (2)||lt_raepal_type_implantation|
|andebpose|Année marquant le début de pose de l'objet de réseau.|character varying  (4)|||
|anfinpose|Année marquant la fin de pose de l'objet de réseau.|character varying  (4)|||
|enservice|Objet en service ou non (abandonné).|character varying  (1)||O,N|
|l_entrpose|Entreprise ayant réalisée la pose de l'objet de réseau.|character varying  (100)|||
|l_propdata|Propriétaire de la donnée de l'objet du réseau.|character varying  (100)|||
|qualglocxy|Qualité de la géolocalisation planimétrique (XY).|character varying  (2)|Obligatoire|lt_raepa_qualite_geoloc|
|qualglocz|Qualité de la géolocalisation altimétrique (Z).|character varying  (2)|Obligatoire|lt_raepa_qualite_geoloc|
|datemaj|Date de la dernière mise à jour des informations.|Timestamp without time zone|Obligatoire||
|sourmaj|Source de la mise à jour.|character varying  (100)|Obligatoire||
|qualanne|Fiabilité, lorsque ANDEBPOSE = ANFINPOSE, de l'année de pose.|character varying  (2)|||
|dategeoloc|Date de la géolocalisation.|Timestamp without time zone|||
|sourgeoloc|Auteur de la géolocalisation.|character varying  (100)|||
|autattrib|Auteur de la saisie des données attributaires (lorsque différent de l'auteur de la géolocalisation).|character varying  (100)|||
|l_comment|Commentaire sur l'objet du réseau.|character varying  (254)|||

### Niveau 1 - Classes géométriques
`geo_raepal_tronc` : Classe géométrique portant les informations communes d'un tronçon de réseau

|Nom attribut|Définition|Type|Contrainte|Valeurs|
|:---|:---|:---|:---|:---|
|idtronc|Identifiant unique du tronçon de réseau.|Bigint|Primary Key|nextval('m_raepa.raepa_id_tronc_seq'::regclass)|
|materiau|Matériau du tronçon.|character varying  (2)|Obligatoire|lt_raepal_materiau
|long_mes|Longueur mesurée du tronçon, en mètre.|Integer|||
|l_long_cal|Longueur calculée du tronçon, en mètre.|Integer|||
|branchmnt|Tronçon de branchement individuel : O Tronçon de transport ou de distribution : N.|character varying  (1)|Obligatoire|O,N|
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

### Niveau 2 - Classes d'objet
`an_raepa_canal` : Classe alphanumérique portant les informations génériques d'une canalisation.

|Nom attribut|Définition|Type|Contrainte|Valeurs|
|:---|:---|:---|:---|:---|
|idobjet|Identifiant unique de l'objet du réseau.|bigint|Primary Key|nextval('m_raepa.raepa_id_obj_reseau_seq'::regclass)|
|idprest|Identifiant du prestataire de l'objet|character varying  (254).|Obligatoire||
|sensecoul|Sens de l'écoulement dans la canalisation d'assainissement collectif 0 (noeud terminal → noeud initial) • 1 (noeud initial → noeud terminal)|character varying  (1)||0,1|
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
|l_etat|Etat de l'ouvrage.|character varying (2)||lt_raepal_etat_ouvrage|
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

## Définition des listes de domaines


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

