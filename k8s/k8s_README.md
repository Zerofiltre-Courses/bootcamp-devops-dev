# BootCamp Devops k8s course

## Connexion au bac à sable 

### Prérequis : 

#### Si vous souhaitez installer les outils sur votre PC en local

* Retrouvez les identifiants : username / password envoyés par mail après votre inscription au parcours (pas reçus ? contactez info@zerofiltre.tech)
  
* Téléchargez le fichier [oidc-kube-config.yml](oidc-kube-config.yml)

* [Installez Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/ "‌")
* [Installez le plugin manager Krew pour kubectl](https://krew.sigs.k8s.io/docs/user-guide/setup/install/ "‌")
* Installez le plugin [oidc-login](https://github.com/int128/kubelogin/blob/master/docs/setup.md) via krew : `kubectl krew install oidc-login`

#### Si vous souhaitez utiliser la machine vagrant

* Retrouvez les identifiants : username / password envoyés par mail après votre inscription au parcours (pas reçus ? contactez info@zerofiltre.tech)

* [Vagrant box configurée](../vagrantbox/README.md)

* [Installez le plugin manager Krew pour kubectl](https://krew.sigs.k8s.io/docs/user-guide/setup/install/ "‌")
* Installez le plugin [oidc-login](https://github.com/int128/kubelogin/blob/master/docs/setup.md) via krew : `kubectl krew install oidc-login`



### A/ Persistez localement les identifiants de connexion *(pas besoin de faire cette étape si vous utilisez la machine vagrant)*

Copiez le fichier  [oidc-kube-config.yml](oidc-kube-config.yml) à un emplacement et définissez le chemin ABSOLU vers ce fichier sous la variable d'environnement: KUBECONFIG 

‌

```
nano ~/.bashrc
```

Insérez-y les lignes suivante :

```
alias k=kubectl
alias zerouser='export KUBECONFIG=/mon/chemin/absolu/oidc-kube-config.yml'
```

Enregistrez puis :

```
source ~/.bashrc
```


Utilsez la commande `zerouser` pour vous connecter au cluster zerofiltre avant de rentrer les commandes kubectl.

Si vous avez plusieurs clusters (boulot, zerofiltre, perso), définissez un alias pour chacun afin de changer facilement de contexte.

Utilisez l'alias `k` en lieu et place de `kubectl`

‌



### B/ Vérifiez l'accès

Tapez une commande `kubectl` , Ex: `kubectl get pods -n 
<username>`  

et ouvrez `localhost:8000` dans un navigateur de votre machine pour authentification:   

Entrez le username / password envoyés par mail après votre inscription au parcours

Si vous voyez le message `No resources found in <username> namespace.`, alors vous êtes correctement authentifiés.

Si vous avez un **permission denied**, vérifiez auprès de l'administrateur que vous avez bien le droit de faire ce que vous souhaitez faire :

Copiez le message d’erreur : `User xxxxxxx#yyyyyy can not access ...`  et envoyez à l'admin du cluster ou à info@zerofiltre.tech

**⚠️ Ps: En cas de 53x Bad Gateway : 2 solutions :**  

Videz les cookies de votre navigateur provenant de keycloak.zerofiltre.tech et essayez de nouveau.

Copiez le lien dans un navigateur privé et essayez de nouveau.  

🥳 Bravo, vous êtes connectés à votre bac à sable personnel kubernetes
