import requests
import random
import time

# URL de l'endpoint /articles
url = 'http://localhost:5000/articles'

# Boucle pour simuler l'activité pendant 5000 minutes
for i in range(5000):
    # Temps d'attente aléatoire entre 1 et 10 secondes
    time.sleep(random.randint(1, 10))

    # Choix aléatoire entre GET et POST
    method = random.choice(['GET', 'POST'])

    # Envoi de la requête à l'endpoint /articles
    response = requests.request(method, url)

    # Affichage de la réponse de l'application
    print(f'Requête {method} - Réponse {response.status_code}')