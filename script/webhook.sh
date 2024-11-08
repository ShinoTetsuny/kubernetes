#!/bin/bash

# Récupérer l'URL publique de Ngrok
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')

# Modifie l'URL pour le point de terminaison du webhook
WEBHOOK_URL="${NGROK_URL}/"

# Configuration du webhook GitHub
REPO="ShinoTetsuny/kubernetes"  # Remplacez par votre nom d'utilisateur et dépôt
TOKEN=$GITHUB_TOKEN_PUBLIC        # Remplacez par votre token GitHub

# Supprimer le webhook existant (optionnel)
curl -X DELETE -H "Authorization: token $TOKEN" \
  "https://api.github.com/repos/$REPO/hooks"

# Créer le webhook GitHub
curl -X POST -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/$REPO/hooks \
  -d "{
    \"config\": {
      \"url\": \"$WEBHOOK_URL\",
      \"content_type\": \"json\"
    },
    \"events\": [
      \"push\"
    ],
    \"active\": true
  }"

echo "Webhook configuré avec succès à l'adresse : $WEBHOOK_URL"