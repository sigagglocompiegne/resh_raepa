![picto](/doc/img/geocompiegnois_2020_reduit_v2.png)

# Livrables

Les livrables transmis auprès ou par la collectivé comprennent :

## Gabarit RAEPA et Gabarit RAEPA étendu

Deux gabarits sont mis en place, sous QGIS.

### Pré-requis pour l'utilisation du Gabarit sous QGis

Afin de pouvoir utiliser les fonds de plan intégrés dans le gabarit QGis, vous devez préalablement installer le plugin Geo2France et paramétrer l'accès aux flux WMS du Pays Compiégnois.

- installer le plugin Geo2France via le gestionnaire d'extension de QGIS
  - Déclarer et activer le dépôt suivant : https://www.geo2france.fr/public/qgis3/plugins/plugins.xml
  - Rechercher et charger l'extension intitulée "Geo2France"


## Les données standardisées RAEPA

Les données au standard RAEPA (v1.2) et au format ESRI Shape (SHP) :
* Adduction d'eau
  * RAEPA_CANALAEP_L
  * RAEPA_APPARAEP_P
  * RAEPA_OUVRAEP_P
  * RAEPA_REPARAEP_P
* Assainissement
  * RAEPA_CANALASS_L
  * RAEPA_APPARASS_P
  * RAEPA_OUVRASS_P
  * RAEPA_REPARASS_P

## Les données riches issues des extensions locales du RAEPA

Des données complémentaires enrichies, au format (? tabulaire à définir txt, dbf, cvs, json ?), afin de maintenir l'exhaustivité et la précision de l'état de connaissance patrimoniale entre intervenants (exploitant, collectivité ...).

* Adduction d'eau
  * Canalisation
    * RAEPAL_CANALAEP
    
  * Ouvrage
    * RAEPAL_OUVRAEP
    * RAEPAL_STATPOMP_AEP
    * RAEPAL_STATTRAIT_AEP
    * RAEPAL_RESERV_AEP
    * RAEPAL_CAPTAG_AEP
    * RAEPAL_CHAMBR_AEP
    * RAEPAL_CHAMBR_COMPT_AEP
    * RAEPAL_CITERN_AEP
    
  * Appareillage
    * RAEPAL_APPARAEP
    * RAEPAL_VIDANG_AEP
    * RAEPAL_VENTOUSE_AEP
    * RAEPAL_VANNE_AEP
    * RAEPAL_REG_PRESS_AEP
    * RAEPAL_COMPT_AEP

* Assainissement
  * Canalisation
    * RAEPAL_CANALASS
    * RAEPAL_BRANCHEMNT_ASS
    
  * Ouvrage
    * RAEPAL_OUVRASS
    * RAEPAL_STATPOMP_ASS
    * RAEPAL_STEP_ASS
    * RAEPAL_BASS_ASS
    * RAEPAL_REG_ASS
    * RAEPAL_AVALOIR_ASS
    
  * Appareillage
    * RAEPAL_APPARASS
