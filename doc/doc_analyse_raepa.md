# Analyse du géostandard et problématiques d'implémentation locale

## Analyse geostandard RAEPA 1.1

### partie B - Modèle conceptuel de données

- ensemble des id est de type char(254)

#### classe canalisation

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

- IDSUPREPAR : voir comment gérer la vérification de l'id (fkey) en fonction de l'attribut qui dit le type de support. en fonction, il faudra vérifier soit l'idcana, soit l'idappareil, soit l'idouvrage.


## Problématiques d'implémentation

- id de type char(254) alors que nous utilisons classiquement des entiers
- des sous classes spécialisées à prévoir pour porter des attributs spécifiques (ex : différents type d'avaloir)
- besoin de classe d'habillage (ex : emprise de bassin)
- besoin attribut "insee" pour filtrer et gestion des droits ==> implication sur la modélisation globale. Attention au cas de réseau sur voie entre 2 communes (ex : verberie/St Vaast), comment traiter le sujet ?
- urbanisation geom entre pcrs et base métier raepa ??? ==> complexe à ce stade (absence de base topo locale)
