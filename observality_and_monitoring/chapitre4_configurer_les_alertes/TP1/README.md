## Objectif
Le but de ce TP est de créer une alerte dans alertmanager pour vous notifer lorsque le taux d'utilisation de la mémoire de votre serveur dépasse 90%.

## Prérequis

- La box vagrant fournie avec ce TP
- Un serveur SMTP


## Guide

### 1. Configuration des alertes

Pour créer des alertes dans Alertmanager, vous devez d'abord configurer vos règles de surveillance dans Prometheus. Cela peut être fait en utilisant le langage de requête Prometheus (PromQL), qui vous permet de spécifier les critères de déclenchement des alertes.

- Créer un fichier `alert.rules` dans le dossier `/etc/prometheus/rules/` de votre serveur prometheus

- Ajouter la règle suivante dans ce fichier :

```
groups:
  - name: bootcamp_alert
    rules:
      - alert: HighMemoryUsage
        expr: node_memory_MemTotal_bytes - node_memory_MemFree_bytes - node_memory_Buffers_bytes - node_memory_Cached_bytes > 0.9 * node_memory_MemTotal_bytes
        for: 5m
        labels:
          severity: page
        annotations:
          summary: "High memory usage"
          description: "Memory usage on {{ $labels.instance }} has been above 90% for more than 5 minutes."

```

- Redémarrer le service prometheus avec

```bash
docker compose restart
```


### 2. Configuration des récepteurs


Alertmanager utilise des récepteurs pour spécifier comment gérer les alertes. Les récepteurs sont des destinations pour les alertes, comme un service de notification ou un système de gestion des tickets.

Nous allons configurer un récepteur pour envoyer des alertes par e-mail :

```
receivers:
- name: email
  email_configs:
  - to: 'admin@example.com'
    from: 'alertmanager@example.com'
    smarthost: 'smtp.gmail.com:587'
    auth_username: 'alertmanager@example.com'
    auth_password: 'secret'
```

Cette configuration spécifie que les alertes doivent être envoyées à l'adresse e-mail spécifiée, en utilisant un serveur SMTP pour l'envoi.



### 3. Configuration des routes

Les routes permettent de définir comment les alertes sont distribuées aux récepteurs. Les routes sont des expressions booléennes qui sont évaluées pour chaque alerte. Si l'expression est vraie, l'alerte est envoyée au récepteur correspondant.

Nous allons configurer une route pour envoyer toutes les alertes à notre récepteur e-mail :

```yaml
route:
  group_by: ['alertname']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 1h
  receiver: email
```

Cette configuration spécifie que toutes les alertes doivent être envoyées au récepteur e-mail.

## Conclusion

La création d'alertes dans Alertmanager nécessite une configuration appropriée des règles de surveillance dans Prometheus, ainsi que des récepteurs et des routes dans Alertmanager. Avec une configuration appropriée, vous pouvez gérer efficacement les alertes et prendre des mesures proactives pour résoudre les problèmes avant qu'ils ne deviennent critiques.