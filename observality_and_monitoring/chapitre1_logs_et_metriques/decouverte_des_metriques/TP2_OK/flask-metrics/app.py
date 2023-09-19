from flask import Flask, Response, request
from prometheus_client import Counter, Histogram, generate_latest


app = Flask(__name__)


# Nous definissons les metriques que nous souhaitons exporter
REQUEST_COUNT = Counter('http_request_count', 'Total HTTP Request Count', ['method', 'endpoint', 'ip']) # Un Compteur pour le nombre de requetes
REQUEST_LATENCY = Histogram('http_request_latency_seconds', 'HTTP Request Latency', ['method', 'endpoint']) # Un Histogramme pour la latence des requetes
ARTICLE_COUNT = Counter('article_count', 'Total posted article Count', ['id']) # Un Compteur pour le nombre d'articles postés

# Initialize the iteration count
iteration_count = 0

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
	    global iteration_count  # Access the global iteration_count
	    iteration_count += 1

	    # Use 'even' for even iterations, 'odd' for odd iterations,
            # and 'mult7' for iterations that are multiples of 7
	    if iteration_count % 7 == 0:
        	article_id = 'mult7'
	    elif iteration_count % 2 == 0:
        	article_id = 'even'
	    else:
        	article_id = 'odd'    

	    # Increment the article_count counter
	    ARTICLE_COUNT.labels(id=article_id).inc()
    
	    return f'Hello, World! Article ID: {article_id}'    


# Nous definissons une route pour exporter les metriques
@app.route('/metrics')
def metrics():
    resp = Response(generate_latest())
    resp.headers['Content-type'] = 'text/plain; version=0.0.4; charset=utf-8'
    return resp
