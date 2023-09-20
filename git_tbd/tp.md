## Forker et cloner le projet du TP

  

[Projet à forker et cloner](https://github.com/Zerofiltre-Courses/zerofiltre-blog-backend-inow)

  

En Forkant, décochez "cloner la branche main uniquement" car on va travailler sur une branche différente.

  

* [Ajoutez votre clé publique à github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

  


* Clonez

Clonez le projet :

  

```shell

git  clone  git@github.com:YOUR_GITHUB_USERNAME/zerofiltre-blog-backend-inow.git

```

  

## Mise en place du scénario + explications

  

Mettez-vous sur la branche `email-on_article_in_review_inow_jour1` :

  

```shell

git  checkout  email-on_article_in_review_inow_jour1

```

  

Créez une nouvelle branche et déplacez-vous dessus :

  

```shell

git  checkout  -b  email-on_article_in_review_inow-conflict-a

```

  

Exécutez `mvn test` => échec

  

Corrigez en ajoutant ces deux lignes :

  

```java

UserActionEvent  userActionEvent = new  UserActionEvent(appUrl, Locale.forLanguageTag(author.getLanguage()), author, "", existingArticle, Action.ARTICLE_SUBMITTED);

notificationProvider.notify(userActionEvent);

```

  

Exécutez à nouveau `mvn test` => OK

  

Poussez sur le repo distant et faites la pull request vers `email-on_article_in_review_inow_jour1` qui est acceptée

  

Revenez à la branche `email-on_article_in_review_inow_jour1`

  

Créez une nouvelle branche et déplacez-vous dessus :

  

```shell

git  checkout  -b  email-on_article_in_review_inow-conflict-b

```

  

Corrigez en ajoutant ces deux lignes :

  

```java

UserActionEvent  userActionEvent = new  UserActionEvent(appUrl, Locale.forLanguageTag("FR-fr"), author, "any", existingArticle, Action.ARTICLE_SUBMITTED);

notificationProvider.notify(userActionEvent);

```

  

Puisqu'il y a des modifications sur la branche principale :

  

```shell

git  checkout  email-on_article_in_review_inow_jour_1

git  pull

git  checkout  -

```

  

Sur `email-on_article_in_review_inow-conflict-b`, faites un rebase de `email-on_article_in_review_inow_jour1`

  

Résolvez le conflit en fusionnant les modifications à la main ou sur Theia IDE

  

```shell

git  add  .

git  rebase  --continue

git  status

git  push  -f

```

  

Car la branche locale `email-on_article_in_review_inow-conflict-b` a divergé de la branche distante `origin/email-on_article_in_review_inow-conflict-b`

  

La branche locale est la plus à jour, donc on force l'écrasement de la branche distante.

  

## Faire une release :

  

```shell

git  checkout  -b  release-1.0.0

git  push  -u  origin  release-1.0.0

```

  

Mise en prod manuelle

  

Création de tag :

  

```shell

git  tag  -a  v1.7.0  -m  "Fix Send email on article review"

git  push  -u  origin  --tags

```

  

Supprimez la branche de release

  

## Quelques astuces

 * i/ Revenir à l’état de la branche distante

  

```shell

git  reset  --hard  origin/branch_name

```

  

 * ii/  Corriger une catastrophe

  

```shell

git  reflog

```

  

Copiez le hash

  

```shell

git  reset  --hard  hash

```

  
