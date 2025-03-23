## Objectif
Le but de ce TP est de créer des alertes dans alertmanager pour vous notifer par mail, lorsque le taux d'utilisation de vos ressources,
cpu et mémoire dépassent un certain seuil. Nous en profiterons pour tester la notion d'inhibition.

## Prérequis

- Vous êtes connectés à la box vagrant fournie avec ce TP et vous avez cloné ce projet 
- Deux comptes gmail


## Guide

### 1. Configuration des alertes
Déplacez-vous dans le projet du chapitre4 :

```shell
cd observability_and_monitoring/chapitre4_configurer_les_alertes/TP1
```
Pour créer des alertes dans Alertmanager, vous devez d'abord configurer vos règles de surveillance dans Prometheus. Cela peut être fait en utilisant le langage de requête Prometheus (PromQL), qui vous permet de spécifier les critères de déclenchement des alertes.

- Créez un fichier `alert.rules` qui sera monté dans le dossier `/etc/prometheus/rules/` de votre serveur prometheus

- Ajouter la règle suivante dans ce fichier :

```
groups:
  - name: bootcamp_alert
    rules:
      - alert: HighMemoryUsage
        expr: mem_available_percent > 70
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High memory usage"
          description: "Memory usage on {{ $labels.instance }} has been above 70% for more than 5 minutes."

      - alert: HighMemoryUsage
        expr: mem_available_percent > 50
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High memory usage"
          description: "Memory usage on {{ $labels.instance }} has been above 50% for more than 5 minutes."

      - alert: HighCPUUsage
        expr: 100 - cpu_usage_idle{cpu!="cpu-total"} > 90
        for: 5m
        labels:
          severity: page
        annotations:
          summary: "High memory usage"
          description: "CPU usage for {{ $labels.cpu }}  on {{ $labels.instance }} has been above 90% for more than 5 minutes."

```

- Redémarrer le service prometheus avec

```bash
docker compose restart
```


### 2. Configuration d'alertmanager'

Toute la config sera faite dans un fichier `alertmanager.yml` que l'on va monter en tant que volume dans le container alertmanager.

Créez le fichier `alertmanager.yml`

Les spécifications à configurer sont les suivantes:

- L'envoi d'alertes sera faite par mail via un serveur de messagerie gmail
- Les configurations du serveur de mail doivent être globales à l'ensemble.
- Les alertes en warning seront envoyées uniquement aux récepteurs nommés ops
- Les alertes en critical seront envoyées aux récepteurs nommés opsandmanager
- L'équipe ops est joignable à l'adresse mail: première adresse gmail
- L'équipe opsandmanager est joignable aux adresses mail: première et seconde adresse gmail
- Les mails seront envoyés de votre adresse gmail
- Les alertes seront toujours groupées par le champ 'alertname'
- Si deux alertes ayant le même 'alertname' sont déclenchées, celle ayant une sévérité warning sera ignorée au profit de celle ayant la sévérité 'critical'


Alertmanager utilise des récepteurs pour spécifier comment gérer les alertes. Les récepteurs sont des destinations pour les alertes, comme un service de notification ou un système de gestion des tickets.
