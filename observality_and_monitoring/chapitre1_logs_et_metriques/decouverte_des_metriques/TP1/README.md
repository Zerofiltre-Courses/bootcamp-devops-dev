# TP : Collecte et visualisation de métriques avec Telegraf et Prometheus

## Objectifs:

L'objectif de ce TP est de découvrir comment installer et configurer Telegraf et Prometheus à l'aide de Docker Compose, et comment utiliser PromQL pour interroger les métriques collectées par Telegraf. 

À la fin de ce TP, vous serez en mesure de :
- Installer et configurer Telegraf pour collecter des métriques système
- Configurer telegraf pour exposer un endpoint Prometheus
- Installer et configurer Prometheus pour récupérer les métriques de Telegraf
- Interroger les métriques avec PromQL et visualiser les résultats dans l'interface graphique de Prometheus

Ce TP vous permettra d'acquérir des connaissances pratiques sur la collecte et la visualisation de métriques avec Telegraf et Prometheus, qui sont des outils populaires pour la surveillance et l'analyse de performances dans les systèmes informatiques.

## Prérequis

- La box vagent (Si vous ne l'avez pas encore telechargez le guide ici)


## Étape 1 : Configuration de Telegraf

Nous allons commencer par définir le service Telegraf et son fichier de configuration **telegraf.conf**. Créez un nouveau répertoire et créez un fichier **docker-compose.yml** avec le contenu suivant :

```yaml
version: '3.9'
services:
  telegraf:
    image: telegraf
    container_name: telegraf
    volumes:
      - ./telegraf.conf:/etc/telegraf/telegraf.conf
    ports:
      - "9273:9273"
```

Ce fichier de configuration définit un service Telegraf qui utilise l'image Docker telegraf. Il monte le fichier telegraf.conf dans le conteneur pour la configuration et expose le port 9273 pour les métriques.

Créons également un fichier telegraf.conf avec le contenu suivant :

```conf

#Nous definissions un endpoint pour exposer les metriques collectees par telegraf au format prometheus sur le port 9273
[[outputs.prometheus_client]] 
  listen = ":9273"

# Les configurations suivantes permettent d'activer les plugins telgraf pour collecter les metriques système 

# CPU
[[inputs.cpu]]
  percpu = true
  totalcpu = true
  fielddrop = ["time_*"]

# disque
[[inputs.disk]]
  ignore_fs = ["tmpfs", "devtmpfs", "devfs"]

# memoire
[[inputs.mem]]

# le reseau
[[inputs.net]]

# les métriques de charge système pour le serveur sur lequel Telegraf est installé
[[inputs.system]]
```

## Étape 2: Execution de telegraf et exploration des metriques

Maintenant que la configuration est en place, nous pouvons lancer Telegraf en utilisant Docker Compose. Assurez-vous que vous êtes dans le répertoire contenant les fichiers docker-compose.yml, telegraf.conf puis exécutez la commande suivante :

```bash
docker compose up
```

Si tout ce passe bien, vous pouvez alors voir les metriques de la box vagrant en consultant l'addresse: http://localhost:9273/metrics.

Effrayant n'es ce pas ? Il s'agit des metriques de votre box exportees au format prometheus:

En utilisant le recherche, votre trouver par exemple disk_total, mem_available_percent ou totalcpu qui sont respectivement les metriques de l'espace disque total, la memoire disponible en pourcentage et le nombre de coeurs de votre processeur.

(fAire une capture d'ecran)

## Étape 3: Configuration de Prometheus

Nous allons maintenant configurer Prometheus pour récupérer les métriques de Telegraf. Dans notre fichier  **docker-compose.yml** ajoutons le contenu suivant :

```yaml
 prometheus:
    image: prom/prometheus
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
```

Nous venons d'ajouter un service Prometheus qui utilise l'image Docker prom/prometheus. Il monte le fichier prometheus.yml dans le conteneur pour la configuration et expose le port 9090 pour l'interface utilisateur de Prometheus.


Créons maintenant un fichier prometheus.yml pour configurer prometheus avec le contenu suivant :

```yaml
global:
  scrape_interval: 10s

scrape_configs:
  - job_name: 'telegraf'
    scrape_interval: 5s
    static_configs:
      - targets: ['telegraf:9273']
```

Ce fichier de configuration définit un job de collecte nommé telegraf qui récupère les métriques de Telegraf toutes les 5 secondes. Le job de collecte est configuré pour récupérer les métriques de l'endpoint Prometheus de Telegraf sur le port 9273.

Par cette configuration, ajoutons Telegraf en tant que cible (target) de Prometheus, nous avons donc informé Prometheus qu'il doit régulièrement interroger Telegraf pour récupérer ses métriques. Ainsi, Prometheus sera en mesure de collecter les données de Telegraf de manière continue.


## Étape 4: Execution de Prometheus et exploration des metriques

Maintenant que la configuration est en place, nous pouvons lancer Prometheus en utilisant Docker Compose. Assurez-vous que vous êtes dans le répertoire contenant les fichiers docker-compose.yml, prometheus.yml puis exécutez la commande suivante :

```bash
docker compose up
```

Si tout ce passe bien, vous pouvez acceder a l'interface graphique de prometheus via l'addresse http://localhost:9090.

