![picto](/doc/img/Logo_web-GeoCompiegnois.png)

# Documentation de contrôle des données de production

|Nom attribut | Définition | Type | 
|:---|:---|:---|
|code|Code de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation|character varying(2)|
|valeur|Valeur de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation|character varying(80)|
|definition|Définition de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation|character varying(255)|

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
