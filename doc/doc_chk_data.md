![picto](/doc/img/geocompiegnois_2020_reduit_v2.png)

# Mise en place d'un contrôle qualité des fichiers au standard RAEPA

Dans une optique de rendre péréenne la qualité des informations que nous recevrons de nos prestataires extérieurs, la mise en place d'un traitement via un ETL pour la conformité de la donnée semble idéale.

Selon la norme ISO 19157 ainsi que les différents protocoles de contrôle de la qualité des données disponibles, nous appliquerons la directive suivante :

|FICHIER DE TRAITEMENT|CONTROLE|TYPE DE CONTROLE|COMMENTAIRES|
|:---|:---|:---|:---|
|rapea_controle|GENERAL|général|Script permettant de lancer tous les traitements en une seule manipulation|
|raepa_controle_proprietes_fichiers|PROPRIETE|Formats des fichiers|Contrôle le format de fichier du jeu de données (shapefile)|
|raepa_controle_proprietes_fichiers|PROPRIETE|Noms Fichiers|Contrôle le nom des fichiers receptionnés|
|raepa_controle_proprietes_fichiers|PROPRIETE|Quantité de Fichiers|Contrôle la réception du bon nombre de fichiers d'échanges attendus|
|raepa_controle_proprietes_fichiers|PROPRIETE|Nom Attribut|Vérifie la toponymie des attributs|
|raepa_controle_proprietes_fichiers|PROPRIETE|Type Informatique|Vérifie le type de chacun des attributs, et de leur taille|
|raepa_controle_proprietes_fichiers|PROPRIETE|Quantité d'Attributs|Vérifie la quantité d'attributs reçus pour chaque fichier|
|raepa_controle_geometrie|GEOMETRIE|Type|Vérifie les types de géométrie attendus|
|raepa_controle_geometrie|GEOMETRIE|Projection|Vérifie la projection en Lambert 93|
|raepa_controle_geometrie|GEOMETRIE|Position|Vérifie la cohérence de la position des objets par rapport à notre territoire|
|raepa_controle_geometrie|GEOMETRIE|Topologie|Vérifie la cohérence des clés étrangères avec les différents objets liés|
|raepa_controle_attributaire|ATTRIBUTS|Unicité|Vérifie l'unicité des attributs de clés primaires|
|raepa_controle_attributaire|ATTRIBUTS|Obligation|Vérifie l'obligation de saisie des attributs concernés|
|raepa_controle_attributaire|ATTRIBUTS|Contenu|Vérifie le contenu des attributs cocnernés (liste de domaines, plage de valeurs, etc.)|
|raepa_controle_attributaire|ATTRIBUTS|Temporel|Vérifie les attributs portant des informations temporelles (date, années, etc.)|
|raepa_controle_attributaire|ATTRIBUTS|Cohérence|Vérifie la cohérence des attributs (informations attributaires des géométrie avec la géométrie, etc.)|
|raepa_controle_attributaire|ATTRIBUTS|Relations|Vérifie les liens entre des attributs liés (qualannee saisi si andebpose = anfinpose, etc.)|

## Cadre du contrôle topologique

Dans cette partie, nous checkerons la géométrie des objets et nous veillerons à vérifier les aspects suivants :

* corrélation entre la géométrie et les coordonnées attributaires (app,ouv)
* noeud (ouv/app) non connecté à au moins une canalisation
* de base, le sens d'écoulement dans une canalisation correspond au noeud amont pour le point de départ et au noeud aval pour le point d'arrivée, éventuellement au cas inverse (uniquement pour assainissement) si le sens d'écoulement de la canalisation le précise (attribut sensecoul=0)

## Questionnement sans réponse actuellement

Certains contrôle ne sont pas encore tranché.
Nous noterons :
* IDNTERM et IDNINI : Attributs toujours obligatoires dans le RAEPA, mais certaines canalisations n'ont pas de noeuds à l'une des deux extrémités.
  * Pour les branchements, avons-nous toujours un appareillage ou ouvrage avant le domaine privé ? Sur l'extrémité donnant jonction avec la canalisation principale, il y aura dans tous les cas un appareillage de type "Point de branchement" disponible dans le RAEPA.
   * Pour les canalisations de transport, on remarque que certaines n'ont pas deux noeuds aux extrémités. Pourtant les valeurs IDNINI et IDNTERM sont remplies. Ces objets semblent en limite de contrat, ont-ils donc été coupés à l'export, ce qui expliquerait l'absence de noeud sur une des extrémités ?



Nous ne rentrerons pas dans un contrôle de topologie très fin, qui serait plutôt engagé au sein d'un service SIG métiers. 
Dans notre cas, il s'agit uniquement d'acquérir une vision globale du réseau sur le territoire.

