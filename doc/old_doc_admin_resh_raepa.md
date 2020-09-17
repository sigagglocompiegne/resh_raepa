![picto](/doc/img/geocompiegnois_2020_reduit_v2.png)

# Documentation d'administration de la base de données des réseaux humides

## Principes
  
### Généralités

Description détaillée du géostandard est disponible sur http://www.geoinformations.developpement-durable.gouv.fr/geostandard-reseaux-d-adduction-d-eau-potable-et-d-a3478.html
 
### Résumé fonctionnel
 
## Dépendances


## Classes d'objets


## Liste de valeurs


`lt_raepa_materiau` : Liste permettant de décrire le matériau constitutif des tuyaux composant une canalisation 

|Nom attribut | Définition | Type | 
|:---|:---|:---|
|code|Code de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation|character varying(2)|
|valeur|Valeur de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation|character varying(80)|
|definition|Définition de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation|character varying(255)|

Valeurs possibles :

|Code | Valeur | Définition |
|:---|:---|:---|  
|00|Indéterminé|Canalisation composée de tuyaux dont le matériau est inconnu|
|01|Acier|Canalisation composée de tuyaux d'acier|
|02|Amiante-ciment|Canalisation composée de tuyaux d'amiante-ciment|
|03|Béton âme tôle|Canalisation composée de tuyaux de béton âme tôle|
|04|Béton armé|Canalisation composée de tuyaux de béton armé|
|05|Béton fibré|Canalisation composée de tuyaux de béton fibré|
|06|Béton non armé|Canalisation composée de tuyaux d'amiante-ciment|
|07|Cuivre|Canalisation composée de tuyaux de cuivre|
|08|Fibre ciment|Canalisation composée de tuyaux de fibre ciment|
|09|Fibre de verre|Canalisation composée de tuyaux de fibre de verre|
|10|Fibrociment|Canalisation composée de tuyaux de fibrociment|
|11|Fonte ductile|Canalisation composée de tuyaux de fonte ductile|
|12|Fonte grise|Canalisation composée de tuyaux de fonte grise|
|13|Grès|Canalisation composée de tuyaux de grès|
|14|Maçonné|Canalisation maçonnée|
|15|Meulière|Canalisation construite en pierre meulière|
|16|PEBD|Canalisation composée de tuyaux de polyéthylène basse densité|
|17|PEHD annelé|Canalisation composée de tuyaux de polyéthylène haute densité annelés|
|18|PEHD lisse|Canalisation composée de tuyaux de polyéthylène haute densité lisses|
|19|Plomb|Canalisation composée de tuyaux de plomb|
|20|PP annelé|Canalisation composée de tuyaux de polypropylène annelés|
|21|PP lisse|Canalisation composée de tuyaux de polypropylène lisses|
|22|PRV A|Canalisation composée de polyester renforcé de fibre de verre (série A)|
|23|PRV B|Canalisation composée de polyester renforcé de fibre de verre (série B)|
|24|PVC ancien|Canalisation composée de tuyaux de polychlorure de vinyle posés avant 1980|
|25|PVC BO|Canalisation composée de tuyaux de polychlorure de vinyle bi-orienté|
|26|PVC U annelé|Canalisation composée de tuyaux de polychlorure de vinyle rigide annelés|
|27|PVC U lisse|Canalisation composée de tuyaux de polychlorure de vinyle rigide lisses|
|28|Tôle galvanisée|Canalisation construite en tôle galvanisée|
|99|Autre|Canalisation composée de tuyaux dont le matériau ne figure pas dans la liste ci-dessus|

---

`lt_raepa_mode_circulation` : Liste permettant de décrire le mode de circulation de l'eau dans une canalisation 

|Nom attribut | Définition | Type  |
|:---|:---|:---|
|code|Code de la liste énumérée relative au mode de circualtion de l'eau dans une canalisation|character varying(2)|
|valeur|Valeur de la liste énumérée relative au mode de circualtion de l'eau dans une canalisation|character varying(80)|
|definition|Définition de la liste énumérée relative au mode de circualtion de l'eau dans une canalisation|character varying(255)|

Valeurs possibles :

|Code | Valeur | Définition |
|:---|:---|:---|  
|00|Indéterminé|Mode de circulation inconnu|
|01|Gravitaire|L'eau s'écoule par l'effet de la pesanteur dans la canalisation en pente|
|02|Forcé|L'eau circule sous pression dans la canalisation grâce à un système de pompage|
|03|Sous-vide|L'eau circule par l'effet de la mise sous vide de la canalisation par une centrale d'aspiration|
|99|Autre|L'eau circule tantôt dans un des modes ci-dessus tantôt dans un autre|

---

