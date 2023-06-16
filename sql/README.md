![picto](/doc/img/geocompiegnois_2020_reduit_v2.png)

# Scripts SQL pour l'implémentation du standard RAEPA et de ses extensions locales dans un SGBD spatial Postgres/Postgis

## Description :

* [Script d'initialisation de la base de données RAEPA](init_bd_resh_00_raepa.sql)
* [Script d'extension locale de la base de données RAEPA](init_bd_resh_10_raepa_extension.sql)
* [Script des vues applicatives pour l'application de consultation](init_bd_resh_21_xapps.sql)
* [Script des vues de reconstitution du standard RAEPA](init_bd_resh_22_xopendata.sql)
* [Script de destruction de la base RAEPA étendue](init_bd_resh_30_drop_base_etendue.sql)
* [Script de préparation de gabarits RAEPA](init_bd_resh_40_raepa_templates.sql) (modèle permettant de générer le gabarit présent dans le répertoire `gabarit/RAEPA`)
* [Script de préparation de gabarits RAEPA étendu](init_bd_resh_42_raepal_templates.sql)
