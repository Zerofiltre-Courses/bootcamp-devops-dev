# Sample Trunk Based Development project scenario

## Description du scénario
Deux nouvelles features - featA et featB - sont respectivement à faire développer sur le projet par deux développeurs Pat et Hamadi.

- Jour 0: Nouvelle feature A: pat va créer une branche featA à partir de main sur laquelle il va travailler jusqu’au jour 3 en modifiant fichier A, fichier B et fichier C
- Jour 1: Nouvelle feature B: hamadi va créer une branche featB à partir de main sur laquelle il va travailler jusqu’au jour 2 où il va modifier des fichiers B,C et D

- Jour 2 : hamadi termine son dev et met sa branche à jour en l’alignant à main, puis faire une pull request vers la branche main qui sera acceptée et par conséquent fusionnée.

- Jour 3 : pat termine son dev et met sa branche à jour en l'alignant sur main, cependant, cependant main contient déjà les dev de hamadi sur les fichier B et C qui ont été aussi modifiés par pat.
Il faut alors résoudre le conflit, puis faire un pull request et fusionner à main également.

- Jour 4 : Une fois les featA et featB créées, il faut faire une release pour la mise en PROD. Un tag sera créé à l'issu de la mise en prod afin de figer et tracer la version en PROD


## Forker et cloner ce projet 

[Projet à forker et cloner](https://github.com/Zerofiltre-Courses/sample_tbd_scenario)  

* [Ajoutez votre clé publique à github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) afin de pouvoir pousser du code sur github.
 


* Clonez

Clonez le projet :
  

```shell

git  clone  git@github.com:YOUR_GITHUB_USERNAME/sample_tbd_scenario.git

```

### Jour 0 : Pat débute son dev

* Création de la branche featA
```shell
git co -b featA
```

* Modification des fichiers a, b et c

```shell
echo "pat modification" >> a.txt
echo "pat modification" >> b.txt
echo "pat modification" >> c.txt
git add .
git commit -n -m "pat modifications"
```

### Jour 1 : Hamadi débute son dev

* Création de la branche featB
```shell
git co -b featB
```

* Modification des fichiers b, c et d

```shell
echo "hamadi modification" >> b.txt
echo "hamadi modification" >> c.txt
echo "hamadi modification" >> d.txt
git add .
git commit -n -m "hamadi modifications"
```

### Jour 2 : Hamadi termine son dev 

```shell
# mise à jour de la branche main 
git co main
git pull

git co featB
# aucun nouvelle modif venant de main donc rebase sans conflits
git rebase main

git push -u origin featB
```

* Hamadi crée une pull request vers main et la fusion est faite


### Jour 3 : Pat termine son dev 

```shell
# mise à jour de la branche main 
git co main
git pull

git co featA
# les modifications de featB et featB vont entrer en conflit sur les fichiers b.txt et c.txt
git rebase main

```
Régler les conflits puis :

```shell
git push -u origin featA
```

* Hamadi crée une pull request vers main et la fusion est faite

Jour 4 : La release

```shell

# Mise à jour de la branche main
git co main
git pull main

git co -b release-0.0.1
git push -u origin release-0.0.1
```

* Après la mise en prod, vous pouvez créer un tag à partir de la branche de release

```shell
git co release-0.0.1
git tag -a v0.0.1 -m "frist release"
git push origin --tags
```



  

