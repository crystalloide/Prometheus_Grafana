#!/bin/bash

# Script de nettoyage pour l'environnement Cassandra + Prometheus + Grafana

echo "Arrêt de tous les conteneurs..."
docker-compose -f docker-compose-linux.yml down

echo "Suppression des volumes (ATTENTION: ceci supprimera toutes les données)..."
read -p "Voulez-vous supprimer tous les volumes de données? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo rm -rf ./docker/
    echo "Volumes supprimés."
else
    echo "Volumes conservés."
fi

echo "Nettoyage des images Docker non utilisées..."
docker system prune -f

echo "Nettoyage terminé!"
