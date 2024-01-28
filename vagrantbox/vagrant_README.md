## VAGRANT BOX

Cette box est une machine virtuelle vagrant qui contient les pre-requis pour le bootcamp. Elle contient notamment:

- docker
- docker-compose
- git


### Prérequis

- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://developer.hashicorp.com/vagrant/downloads?product_intent=vagrant)

### Installation de la box

Pour installer la box, il faut:

- Cloner le repo git: `git clone <url_du_repo>.git`
- Se placer dans le dossier vagrantbox
- Lancer la commande `vagrant up`

### Connexion à la box

- Se placer dans le dossier vagrantbox
- Lancer la commande `vagrant ssh`

### Ouvrir plusieurs ports en ssh

Au besoin, dupliquer la ligne du fichier `provision.sh` :  
 `config.vm.network "forwarded_port", guest: <port_local>, host: <port_distant>` autant de fois que vous aurez un port à rediriger vers la machine locale en ssh. 

Ex: 

```
config.vm.network "forwarded_port", guest: 80, host: 8080
config.vm.network "forwarded_port", guest: 9000, host: 9000 
config.vm.network "forwarded_port", guest: 8888, host: 8888 
```

### Augmenter le gabarit de la VM 

Commencez avec les ressources fournies: 2Go RAM, 2vcpus 

Au besoin  et en fonction de la capacité de votre machine physique, modifiez ces valeurs dans le fichier `Vagrantfile` puis:

`vagrant reload`

### Installer de nouveaux outils dans la VM 

Il suffit d'ajouter les intructions d'installation dans le fichier `provision.sh` puis :

`vagrant provision`

### [Plus de commandes vagrant ici.](https://gist.github.com/wpscholar/a49594e2e2b918f4d0c4)