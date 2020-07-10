![picto](/doc/img/Logo_web-GeoCompiegnois.png)

# Documentation des contrôles des données de production

chk list d'interdit
* superposition d'ouvrage entre eux
* superposition d'appareillage entre eux
* erreur de topologie intraclasse pour les canalisation (papillon etc ...)
* corrélation entre la géométrie et les coordonnées attributaires (app,ouv,cana)
* noeud (ouv/app) non connecté à au moins une canalisation
* canalisation non connectée à des noeuds
  * 2 noeuds dans le cas d'une canalisation principale
  * au moins 1 noeud dans le cas d'un branchement et dans le cas où le point de jonction n'est pas sécant
* canalisation sécante
  * à l'exception du cas d'une canalisation ASS de type refoulement avec une canalisation d'un autre type ou d'un branchement
  * à l'exception d'une canalisation qui n'est plus en service (enservice=N)
* de base, le sens d'écoulement dans une canalisation correspond au noeud amont pour le point de départ et au noeud aval pour le point d'arrivée, éventuellement au cas inverse si le sens d'écoulement de la canalisation le précise (attribut sensecoul=0)
* canalisation de branchement sur un ouvrage autre qu'un regard (avaloir ?, NR et autre)
* canalisation de refoulement dont le point terminal est une station de pompage

# Mise en place d'un contrôle qualité des fichiers au standard RAEPA

Dans une optique de rendre péréenne la qualité des informations que nous recevrons de nos prestataires extérieurs, la mise en place d'un traitement via un ETL pour la conformité de la donnée semble idéale.

Selon la norme ISO 19157 ainsi que les différents protocoles de contrôle de la qualité des données disponibles, nous appliquerons la directive suivante :

|FICHIER DE TRAITEMENT|CONTROLE|TYPE DE CONTROLE|COMMENTAIRES|
|:---|:---|:---|:---|
|rapea_controle|GENERAL|général|Script permettant de lancer tous les traitements en une seule manipulation|
|raepa_controle_proprietes_fichiers|PROPRIETE||
|raepa_controle_proprietes_fichiers|PROPRIETE||
|raepa_controle_proprietes_fichiers|PROPRIETE||

