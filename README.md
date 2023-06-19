![picto](https://github.com/sigagglocompiegne/orga_gest_igeo/blob/master/doc/img/geocompiegnois_2020_reduit_v2.png)

# Dernière mise à jour : 2020-09-18
## changelog 
   * 2023-06-19 : Ajout gabarit de saisie de données RAEPA étendu (extension locale)
   * 2020-09-25 : Suppression du gabarit d'extension : problème lors de saisie CSV, recherche d'alternatives
   * 2020-09-23 : MAJ des scripts SQL (corrections mineures)
   * 2020-09-22 : Modification de structure du répertoire de gabarit RAEPA + ajout du gabarit RAEPA Étendu. 
   * 2020-09-21 : Suppression de `l_diametre` dans la classe an_raepal_compt_ae car déjà présent dans la classe supérieure an_raepa_app (doublon)
   * 2020-09-18  : Ajout du gabarit RAEPA strict + modification du script templates et du script de destruction de la base
   * 2020-09-17 : MAJ SQL opendata + Ajout script SQL templates + Ajout répertoire de Gabarit

# Base de données des réseaux humides

## Généralités

### Objectifs

* pour les exploitants, généraliser les processus d'échanges des données vers les collectivités à partir du standard national RAEPA
* pour les collectivités,
  * disposer d'une vision cohérente et unifier du patrimoine réseau à l'échelle du territoire
  * mettre en place des processus d'import de données

### Principes

Les échanges entre les exploitants et la collectivité sont constitués :
* des données selon les livrables normalisés définis par le standard RAEPA
* des données complémentaires selon des livrables définis localement comme des extensions au pivot RAEPA. Ces données doivent garantir l'échange d'**informations riches** détenues par les exploitants et que le standard national ne saurait retranscrire.
