# Analyse du géostandard et problématiques d'implémentation locale

## Typologie

`lt_toto` : Liste des valeurs de l'attribut type d'ouvrage (

|Code RAEPA|Valeur RAEPA|Code ARC|Valeur ARC|
|:---|:---|:---|:---|
|00|Non renseigné|00|Non renseigné|
||||
||||
||||



## Analyse geostandard RAEPA 1.1

### partie B - Modèle conceptuel de données

- ensemble des id est de type char(254)
- a priori, la précision x,y,z est au millimètre

#### classe canalisation

- contraintes : canalisation sont des noeuds aux 2 extrémités sauf pour une canalisation de branchement individuel ...
Ceci semble diverger avec les règles, même adaptées pour les branchements, qui sont posées en B.1.3. Le reste du document donne plutôt l'impression qu'au noeud non coupant sur une canalisation, on place à minima un noeud appareillage de type piquage non sécant.
- maitreOuvrage : prévoir des domaines de valeurs
- exploitant : prévoir des domaines de valeurs
- longueur : réelle ou calculée ??

#### ss classe canalisation ae

- filGen : pourquoi cet attribut est considéré comme spécifique d'un réseau ae ?

#### super classe noeud

- choix de modélisation sur le fait qu'un noeud est obligatoirement un appareillage et/ou un ouvrage. Cette classe ne peut pas gérer des noeuds de raccord "fictifs" pour faire des jonctions hors présence d'ouvrage ou d'appareillage (ex noeud fictif de raccord entre 2 communes pour besoin de la base de données)

#### classe appareillage

- altiNoeud : de quelle référence parle t-on ?

### partie C - Structure des données

- de manière générale, le choix de l'ordre des attributs des classes implémentées mérite d'être explicité ...

#### table canalisation

- IDCANPPALE : ne semble présenter un interet que dans le cas d'un branchement avec un piquage sur une cana maitresse (cad, par la présence d'un noeud de piquage "non coupant" 
- LONGCANA : pourquoi simplifier en déclarant de l'entier (mètre) ? cela correspond il a un calcul ou une longueur réelle ?
- CONTCANAEP/CONTCANASS : pourquoi "CONT" alors que cela fait référence à un domaine de valeur parlant de "catégorie" donc plutôt "CAT" ?

#### table apparaep

- DIAMETRE : d'où vient cet attribut par rapport au MCD ? à priori, devrait être placer au niveau de classe appareillage car l'attribut est présent dans les tables d'appareillage ae et ass et absent pour les tables d'ouvrages
- IDCANAVAL et IDCANAMONT : voir dans quelle mesure ces info peuvent être héritées des propriétés relationnelles plutot que saisie manuellement ... a priori cela devrait dépendre du sens d'écoulement de la cana.

#### table reparation


## Problématiques d'implémentation

### modélisation

- id de type char(254) alors que nous utilisons classiquement des entiers
- des sous classes spécialisées à prévoir pour porter des attributs spécifiques (ex : différents type d'avaloir)
- besoin de classe d'habillage (ex : emprise de bassin)
- besoin attribut "insee" pour filtrer et gestion des droits ==> implication sur la modélisation globale. Attention au cas de réseau sur voie entre 2 communes (ex : verberie/St Vaast), comment traiter le sujet ?
- urbanisation geom entre pcrs et base métier raepa ??? ==> complexe à ce stade (absence de base topo locale)
- IDSUPREPAR : voir comment gérer la vérification de l'id (fkey) en fonction de l'attribut qui dit le type de support. en fonction, il faudra vérifier soit l'idcana, soit l'idappareil, soit l'idouvrage ??? en passant l'id en type texte comme attendu, on doit pouvoir préfixer l'id par le type de classe puis un numero de sequence. de cette façon, pas de doublon de numero d'ordre pour l'id possible entre plusieurs classes. A cela s'ajoute l'obligation d'avoir une table de passage contenant l'ensemble des id des différentes classes du réseaux (cana, noeud, appar, ouvr) pour pouvoir placer la fkey sur celle-ci. Si cela n'est pas fait, le controle ne se fera pas par le biais d'une fkey mais par un trigger en cas de mise à jour. Ceci est autant que possible à proscrire. Cette table des id pourrait peut être également servir de table de correspondance et accueillir l'id externe du producteur de la donnée.
- prévoir de gérer l'archivage ou à défaut, l'état "actif", "abandonner" ou "supprimé" du réseau. Ne pas oublier que pour les DT-DICT, un réseau "abandonné" reste cartographier car physiquement présent mais plus en fonctionnement. En revanche, un réseau supprimé physiquement n'est plus à faire figurer pour le dt-dict.

### test reprise de données

- le domaine de valeur "materiau" est trop fin et n'a pas été conçu pour gérer des logiques d'emboitement (ex : 10 pour du PVC dont 11 pour du PVC ancien, 12 pour du PVC BO etc ...). Il en resulte une incapacité de migration d'information entre les sources et le domaine cible en raepa. Ceci induit une perte importante d'information ou un ajout inconsidéré d'attributs optionnels locaux. Voir dans quelle mesure une adaptation n'est pas possible (domaine local reconstruit avec table de passage pour export RAEPA ...)
- absence attribut date_pose alors que cette information est parfois connue. Si pas d'ajout d'un champ optionnel, perte d'info
- absent attribut hauteur, largeur qui permettrait de gérer les formes de "cana" type dalot rectangulaire en plus de l'attribut diametre
- prévoir peut être un attribut complémentaire "section" permetant de préciser le type de section de la canalisation avec un domaine de valeur associé (ex : circulaire, ovoide, dalot rectangulaire ...). voir si c'est une propriété de cana, ou propriété de sstype AEP/ASS 

### extension du modèle d'échange

- id_delegat varchar(254) : id des objets propre au delegataire, à ajouter afin de maintenir un appariement avec la base de la collectivité
