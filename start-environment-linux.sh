#!/bin/bash

# Script de démarrage pour l'environnement Cassandra + Prometheus + Grafana sur Ubuntu

echo "Création des répertoires nécessaires..."

# Créer les répertoires pour les volumes
mkdir -p ./docker/prometheus/config
mkdir -p ./docker/prometheus/data
mkdir -p ./docker/grafana/data
mkdir -p ./docker/grafana/config
mkdir -p ./docker/jmx-exporter/config

# Créer les répertoires Cassandra si nécessaire
mkdir -p ./docker/cassandra11
mkdir -p ./docker/cassandra12
mkdir -p ./docker/cassandra13
mkdir -p ./docker/cassandra21
mkdir -p ./docker/cassandra22
mkdir -p ./docker/cassandra23

echo "Configuration des permissions..."
# Définir les permissions appropriées pour l'utilisateur actuel
sudo chown -R $USER:$USER ./docker/
chmod -R 755 ./docker/

# Copier les fichiers de configuration
echo "Copie des fichiers de configuration..."
cp prometheus.yml ./docker/prometheus/config/
cp cassandra-jmx.yml ./docker/jmx-exporter/config/cassandra.yml

echo "Vérification de Docker et Docker Compose..."
if ! command -v docker &> /dev/null; then
    echo "Docker n'est pas installé. Installation..."
    sudo apt update
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
    echo "Redémarrez votre session ou utilisez 'newgrp docker' pour utiliser Docker sans sudo"
fi

#if ! command -v docker-compose &> /dev/null; then
#    echo "Docker Compose n'est pas installé. Installation..."
#    sudo apt install -y docker-compose
# fi

echo "Démarrage des conteneurs..."
docker compose -f docker-compose-linux.yml up -d

echo ""
echo "=========================================="
echo "Environnement démarré avec succès!"
echo "=========================================="
echo ""
echo "Accès aux services:"
echo "- Cassandra Datacenter Nord:"
echo "  * cassandra11: localhost:9142"
echo "  * cassandra12: localhost:9242" 
echo "  * cassandra13: localhost:9342"
echo ""
echo "- Cassandra Datacenter Terres-de-la-Couronne:"
echo "  * cassandra21: localhost:9442"
echo "  * cassandra22: localhost:9542"
echo "  * cassandra23: localhost:9642"
echo ""
echo "- Monitoring:"
echo "  * Prometheus: http://localhost:9090"
echo "  * Grafana: http://localhost:3000 (admin/admin123)"
echo "  * JMX Exporter: http://localhost:8080/metrics"
echo ""
echo "Commandes utiles:"
echo "- Vérifier le statut: docker-compose -f docker-compose-linux.yml ps"
echo "- Voir les logs: docker compose -f docker-compose-linux.yml logs [service]"
echo "- Arrêter: docker compose -f docker-compose-linux.yml down"
