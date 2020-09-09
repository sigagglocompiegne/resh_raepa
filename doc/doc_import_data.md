![picto](/doc/img/new_logo_geocompiegnois.png)

# Livrables

Les livrables transmis auprès ou par la collectivé comprennent :

## Les données standardisées RAEPA

Les données au standard RAEPA (v1.2) et au format ESRI Shape (SHP) :
* Adduction d'eau
  * raepa_canalaep_l
  * raepa_apparaep_p
  * raepa_ouvraep_p
  * raepa_reparaep_p
* Assainissement
  * raepa_canalass_l
  * raepa_apparass_p
  * raepa_ouvrass_p
  * raepa_reparass_p

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
