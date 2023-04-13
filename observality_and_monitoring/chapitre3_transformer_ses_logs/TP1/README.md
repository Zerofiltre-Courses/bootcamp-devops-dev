# Ezploiter vos logs avec Promtail et Loki 

## Objectifs

- Collecter les logs de votre application avec Promtail
- Extraire les données de vos logs avec Promtail en utilisant des pipelines de traitement
- Créer des tableaux de bord pour visualiser les données de vos logs avec Grafana

Nous créerons un tableau de bord grfana pour visualiser le nombre de requêtes par seconde, la repartition des utilisateurs par pays, les pages les plus visitées et systèmes d'exploitation les plus utilisés.

## Prérequis

- La box vagrant fournie avec le TP
- Le depot git du TP


## Préparation

Pour ce TP, nous allons reprendre l'application web que nous avons développé dans le TP précédent. Nous allons donc utiliser la box vagrant fournie avec le TP.

1. Se connecter à la box vagrant

```bash
vagrant ssh
```

2. Cloner le depot git du TP

```bash
git clone https://github.com/Zerofiltre-Courses/bootcamp-devops-dev
```

3. Se placer dans le répertoire du TP

```bash
cd bootcamp-devops-dev/observability_and_monitoring/chapitre3_transformer_ses_logs/TP1
```

Vous decouvrirez dans ce répertoire les fichiers et répertoires suivants:

- *app-logging* : Le répertoire contenant l'application web
- *grafana* : Le répertoire contenant les fichiers de configuration de Grafana
- *loki* : Le répertoire contenant les fichiers de configuration de Loki
- *promtail* : Le répertoire contenant les fichiers de configuration de Promtail
- *docker-compose.yaml* : Le fichier de configuration de docker-compose


Dans le fichier *promtail/promtail-config.yaml*, nous avons défini un pipeline de traitement qui extrait les données suivantes de nos logs:

- Le nom de l'application (name)
- Le niveau de log (level)
- Le message de log (message)
- Le timestamp (timestamp)
- L'adresse IP de l'utilisateur pour obtenir les données de géolocalisation avec geoip
- Le pays de l'utilisateur (geoip_country_name)
- Le système d'exploitation de l'utilisateur (user_agent)
- La page visitée par l'utilisateur (path)
- Le navigateur utilisé par l'utilisateur (user_agent)

4. Pipeline de traitement

```yaml
    pipeline_stages:
    - json:
        expressions:
          log:
    
    - json:
        expressions:
          message: message
          level: level
          name: name
          timespan: timespan
          path: path
          method: method
          ip: ip
          user_agent: user_agent
        source: log

    - geoip:
        source: "ip"
        db_type: "city"
        db: "/etc/promtail/geolite2-city.mmdb"

    - labels:
        message: message
        level: level
        name: name
        timespan: timespan
        path: path
        ip: ip
        user_agent: user_agent
        geoip_country_name:
```

Il est défini dans le fichier plus précisément dans la section pipeline_stages. Ce pipeline de traitement est composé de trois étapes:

- La première étape est de parser le message de log en JSON. Le message de log est stocké dans la variable log. Nous utilisons l'expression json pour parser le message de log en JSON. Nous utilisons l'expression source pour spécifier la variable dans laquelle le message de log est stocké.

- La deuxième étape est de parser le message de log en JSON. Nous utilisons l'expression json pour parser le message de log en JSON. Nous utilisons l'expression source pour spécifier la variable dans laquelle le message de log est stocké. Nous utilisons l'expression expressions pour spécifier les variables dans lesquelles nous voulons stocker les données extraites du message de log.

- La troisième étape est d'extraire les données de géolocalisation à partir de l'adresse IP de l'utilisateur. Nous utilisons l'expression geoip pour extraire les données de géolocalisation. Nous utilisons l'expression source pour spécifier la variable dans laquelle l'adresse IP de l'utilisateur est stockée. Nous utilisons l'expression db_type pour spécifier le type de base de données de géolocalisation que nous utilisons. Nous utilisons l'expression db pour spécifier le chemin vers la base de données de géolocalisation.

- La quatrième étape est d'ajouter des étiquettes aux données extraites. Nous utilisons l'expression labels pour ajouter des étiquettes aux données extraites. Nous utilisons l'expression message pour spécifier la variable dans laquelle le message de log est stocké. Nous utilisons l'expression level pour spécifier la variable dans laquelle le niveau de log est stocké. Nous utilisons l'expression name pour spécifier la variable dans laquelle le nom de l'application est stocké. Nous utilisons l'expression timespan pour spécifier la variable dans laquelle le temps d'exécution de la requête est stocké. Nous utilisons l'expression path pour spécifier la variable dans laquelle la page visitée par l'utilisateur est stockée. Nous utilisons l'expression ip pour spécifier la variable dans laquelle l'adresse IP de l'utilisateur est stockée. Nous utilisons l'expression user_agent pour spécifier la variable dans laquelle le navigateur utilisé par l'utilisateur est stocké. Nous utilisons l'expression geoip_country_name pour spécifier la variable dans laquelle le pays de l'utilisateur est stocké.


4. Lancer l'application

Dqns le répertoire du TP, se trouve un ficher docker-compose.yaml. Ce fichier permet de lancer l'application web et toute la stack loki/grafana/promtail

```bash
docker-compose up -d
```

Ce fichier contient quatre services:

  - Le premier service est nommé app et correspond à une application dont les logs doivent être collectés. Il est construit à partir du Dockerfile situé dans le répertoire ./app-logging. L'image construite est nommée app-logging et le nom de conteneur est app-logging. Il est exposé sur le port 5000.

  - Le deuxième service est nommé grafana et contient l'image Docker de Grafana, un outil de visualisation de données. Il est nommé grafana et exposé sur le port 3000. Il utilise un volume nommé grafana-storage pour stocker les données.

  - Le troisième service est nommé loki et contient l'image Docker de Loki, un système de gestion de journaux. Il est nommé loki, exposé sur le port 3100 et utilise un volume pour stocker la configuration de Loki.

  - Le quatrième service est nommé promtail et contient l'image Docker de Promtail, un agent de collecte de journaux pour Loki. Il est nommé promtail et utilise plusieurs volumes pour stocker la configuration de Promtail, les fichiers de journal Docker et les fichiers de base de données de géolocalisation(qui nous servira plustard). Le fichier de configuration de Promtail est situé dans le répertoire ./promtail et est en lecture seule.

Et un volume nommé grafana-storage est défini pour stocker les données de Grafana.

- Vérifier que l'application est bien lancée

```bash
docker-compose ps
```

- Vérifier que une notre application est bien accessible

```bash
curl http://localhost:5000
```

```bash
curl http://localhost:3000
```


- Vérifier que les logs sont bien envoyés à Loki

```bash
curl http://localhost:3100/loki/api/v1/query_range?query={name="app"}
```

A ce stade, vous devriez voir les logs de votre application dans le navigateur.

## Création du dashboard


### Création de la source de données

- Dans Grafana, cliquez sur le bouton Configuration (l'engrenage) dans le coin supérieur gauche de l'écran.
- Cliquez sur Sources.
- Cliquez sur Ajouter une source.
- Sélectionnez Loki dans la liste déroulante.
- Entrez http://loki:3100 dans le champ URL.
- Cliquez sur le bouton Sauvegarder et tester.

Vous devriez voir une notification indiquant que la source de données a été ajoutée avec succès et un message indiquant que la connexion a réussi et que les étiquettes ont été récupérées.

### Création du dashboard

- Cliquez sur dashboard dans le menu de gauche.
- Cliquez sur le bouton nouveau un tableau de bord.

Puis aller dans paramètres du tableau de bord modifier le nom du tableau de bord en app-logginge et enregistrez le tableau de bord.

- Cliquez sur le bouton Ajouter un panneau.

- Dans la section requête, sélectionnez la source de données Loki que vous avez créée précédemment.

- Dans la section requête, entrez {name="app"} dans le champ Requête.
