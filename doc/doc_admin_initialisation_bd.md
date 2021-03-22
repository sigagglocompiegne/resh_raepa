![picto](https://github.com/sigagglocompiegne/orga_gest_igeo/blob/master/doc/img/geocompiegnois_2020_reduit_v2.png)

# Initialisation de la base de données et première intégration

Pour réinitialiser la base, lancez les scripts suivants dans l'ordre respectif :
* init_bd_resh_30_drop_base_etendue.sql
* init_bd_resh_00_raepa.sql
* init_bd_resh_10_raepa_extension.sql
* init_bd_resh_21_xapps.sql
* init_bd_resh_22_xopendata.sql


Pour contrôler les données, lancez le script suivant :
* RAEPA_controle.fmw

Pour intégrer les données (seulement si le lot est conforme), lancez le script suivant :
* RAEPA_integration.fmw
