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
    * ext_canalae
  * Ouvrage
    * ext_station_pomp_aep
    * ext_sration_trait_aep
    * ext_reservoir_aep
    * ext_captage_aep
    * ext_chambre_aep
    * ext_citerneau_aep
  * Appareillage
    * ext_compteur_aep
    * ext_regul_press_aep
    * ext_vanne_aep
    * ext_vidange_aep

* Assainissement
  * Canalisation
    * ext_canal_ass 
  * Ouvrage
    * ext_station_pomp_ass
    * ext_step_ass
    * ext_bassin_stock_ass
    * ext_regard_ass
    * ext_avaloir_ass
  * Appareillage
    * ext_app_ass
