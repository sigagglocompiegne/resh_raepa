![GeoCompiegnois](img/new_logo_geocompiegnois.png )

CREATION : 04-08-20.
DATE MISE A JOUR : 04-08-20.
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

![picto](/doc/img/logicogramme_infra_base.png)

# Dépendances

La base de données RAEPA s'appuie sur des référentiels préexistants constituant autant de dépendances que nécessaires pour l'implémentation de certaines informations dans la BdD.

|SCHEMA|TABLE|DESCRIPTION|USAGE|
|:---|:---|:---|:---|
|||| Détermine le code INSEE des objets du réseau par jointure spatiale |
||||Détermine le domaine Privée ou Public de l'objet du réseau par rapport au référentiel cadastral |
||||Détermine l'adresse de localisation de l'objet à partir de jointure spatiale du référentiel des voies et adresses |

# Séquences

De façon général, nous avons entendu la création d'une séquence pour les objets du réseau, quelqu'il soit, ainsi que la génération d'une séquence pour chaque compléments d'informations. Il a été convenu que les géométries sont des informations complémentaires au patrimoine du réseau. Par conséquent, nous générerons 3 séquences : 

* raepa_id_objet_reseau_seq : Séquence permettant de générer un numéro unique pour un objet de réseau.
* raepa_id_noeud_seq : Séquence permettant de générer un numéro unique par noeud de réseau.
* raepap_id_tronc_seq : Séquence permettant de générer un numéro unique par tronçon de réseau.

En conséquence, ces choix permettent de pouvoir identifier un objet de réseau, quelque soit ce réseau, de manière unique. Nous aurions très bien pu générer une séquence par réseau ou encore par type d'objet, ou encore de manière combinée, mais cela aura pour conséquence des doublons d'identifiants dans la superclasse d'objets de réseau, évoquée ci-après.

# Collecte du patrimoine

Afin de pouvoir identifier les informations qui sont issues du standard national ou des extensions locales, nous utiliserons la codification suivante :

* Nomenclature des classes : raepa_[nom_classe] pour les informations issues du RAEPA et raepal_[nom_classe] pour les informations issues d'extension locale
* Nomenclature des attributs : Ajout du préfixe "l_" devant chaque attribut issu de l'extension locale.

## Définition des classes
### Niveau 0 - Superclasse Objet de Réseau
`an_raepal_objet_reseau` : Superclasse regroupant les informations communes à tous types d'objet du réseau

|Nom attribut|Définition|Type|Contrainte|Valeurs|
|:---|:---|:---|:---|:---|
|idobjet|Identifiant unique de l'objet du réseau|bigint|Primary Key||
|idprest|Identifiant du prestataire de l'objet|Caractères (254)|Obligatoire||
|l_reseau|Définit le type de réseau de l'objet selon la convention DT-DICT|Caractères (4)|Obligatoire|ASS/AEP|
|l_typobjet|Définit le type d'objet du réseau|Caractères (20)|Obligatoire|Canalisation/Ouvrage/Appareillage|
|mouvrage|
|gexploit|
|l_typimplt|
|enservice|
|l_insee|
|l_domaine|
|l_entrpose|
|l_propdata|
|qualglocxy|
|qualglocz|
|dategeoloc|
|sourgeoloc|
|autattrib|
|datemaj|
|sourmaj|
|qualanne|

## Définition des listes de domaines
