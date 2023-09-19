## Objectif
Le but de ce TP est d'exporter les metriques d'une application web Flask sous le format Prometheus 


## Étapes

### Étape 1 : Création du projet Flask 
Tout d'abord, nous allons créer un projet Flask simple pour l'utiliser dans ce TP. Voici les étapes à suivre pour créer un projet Flask :

1. Créer un nouveau répertoire pour le projet :

```bash
mkdir flask-metrics
cd flask-metrics
```

2. Créer un environnement virtuel pour le projet :

```bash
python3 -m venv .venv
```

3. Activer l'environnement virtuel :

```bash
source .venv/bin/activate
```

4. Installer Flask et Flask-Prometheus:

```bash
pip install Flask Flask-Prometheus
```

5. Créer un fichier app.py avec le contenu suivant :


```python
from flask import Flask, Response, request
from prometheus_client import Counter, Histogram, generate_latest


app = Flask(__name__)


# Nous definissons les metriques que nous souhaitons exporter
REQUEST_COUNT = Counter('http_request_count', 'Total HTTP Request Count', ['method', 'endpoint', 'ip']) # Un Compteur pour le nombre de requetes
REQUEST_LATENCY = Histogram('http_request_latency_seconds', 'HTTP Request Latency', ['method', 'endpoint']) # Un Histogramme pour la latence des requetes
ARTICLE_COUNT = Counter('article_count', 'Total posted article Count', ['id']) # Un Compteur pour le nombre d'articles postés


@app.before_request
def before_monitoring():
    REQUEST_COUNT.labels(method=request.method, endpoint=request.endpoint, ip=request.remote_addr).inc() # On incremente le compteur de requetes à chaque requete

@app.route('/')
def hello():
    with REQUEST_LATENCY.labels(method=request.method, endpoint=request.endpoint).time(): # On mesure la latence de la requete
        return 'Hello, World!'


@app.route('/articles', methods=["POST"])
def add_article():
    with REQUEST_LATENCY.labels(method=request.method, endpoint=request.endpoint).time():
        return 'Hello, World!'


# Nous definissons une route pour exporter les metriques
@app.route('/metrics')
def metrics():
    resp = Response(generate_latest())
    resp.headers['Content-type'] = 'text/plain; version=0.0.4; charset=utf-8'
    return resp
```

## Étape 2 : Configuration de Prometheus

Nous allons maintenant configurer Prometheus pour qu'il puisse exporter les metriques de notre application Flask. Pour cela, nous allons créer un fichier de configuration **prometheus.yml** avec le contenu suivant :

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
    - targets: ['localhost:9090']
  - job_name: 'app-metrics'
      static_configs:
      - targets: ['localhost:5000/metrics']
```

## Étape 3 : Lancement de l'application Flask et de Prometheus

Nous allons maintenant lancer nos applications avec docker-compose.

1. Créer un fichier **docker-compose.yml** avec le contenu suivant :

```yaml
version: '3.7'
services:
  prometheus:
    image: prom/prometheus
    container_name: prometheus
    ports:
      - 9090:9090
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
  app:
    image: app-metrics
    container_name: app-metrics
    ports:
      - 5000:5000
```
2. Construire l'image de l'application Flask avec la commande suivante :

```bash
sudo docker build -t app-metrics .
```

3. Lancer les applications avec la commande suivante :

```bash
docker-compose up
```

Si tout se passe bien, vous devriez voir les logs.

## Étape 4 : Vérification des metriques

Nous allons maintenant vérifier que les metriques sont bien exportées par notre application Flask.

1. Ouvrir un navigateur et accéder à l'URL suivante : http://localhost:5000/metrics
2. Ouvrir un autre onglet et accéder à l'URL suivante : http://localhost:9090/graph
3. Dans la console de requêtes, taper la requête suivante :

```bash
http_request_count
```

4. Cliquer sur le bouton **Execute** pour exécuter la requête.
5. Vérifier que la requête retourne bien les metriques de l'application Flask.

Bravo ! Vous avez réussi à exporter les metriques de votre application Flask sous le format Prometheus.
