# Configuration Cassandra + Prometheus + Grafana pour Ubuntu Linux

## Vue d'ensemble

Cette configuration étend votre cluster Cassandra existant avec un stack de monitoring complet incluant Prometheus et Grafana, optimisée pour Ubuntu Linux.

## Modifications pour Linux

- **Chemins de volumes**: Utilisation de chemins relatifs (`./docker/`) au lieu de chemins Windows
- **Permissions**: Configuration user `1000:1000` pour Prometheus et Grafana
- **Scripts**: Scripts bash optimisés pour Ubuntu avec gestion automatique des permissions

## Services ajoutés

### Prometheus (192.168.100.150)
- **Port**: 9090
- **Volumes**: `./docker/prometheus/config` et `./docker/prometheus/data`
- **User**: 1000:1000 (évite les problèmes de permissions)

### Grafana (192.168.100.151) 
- **Port**: 3000
- **Volumes**: `./docker/grafana/data` et `./docker/grafana/config`
- **Credentials**: admin/admin123
- **User**: 1000:1000

### JMX Exporter (192.168.100.152)
- **Port**: 8080
- **Volume**: `./docker/jmx-exporter/config`

## Déploiement rapide sur Ubuntu

### Option 1: Script automatique (recommandé)

```bash
# Rendre le script exécutable et l'exécuter
chmod +x start-environment-linux.sh
./start-environment-linux.sh
```

Le script automatique:
- Vérifie et installe Docker/Docker Compose si nécessaire
- Crée tous les répertoires requis
- Configure les permissions appropriées
- Copie les fichiers de configuration
- Démarre l'environnement complet

### Option 2: Déploiement manuel

```bash
# 1. Créer les répertoires
mkdir -p ./docker/{prometheus/{config,data},grafana/{data,config},jmx-exporter/config}
mkdir -p ./docker/cassandra{11,12,13,21,22,23}

# 2. Configurer les permissions
sudo chown -R $USER:$USER ./docker/
chmod -R 755 ./docker/

# 3. Copier les configurations
cp prometheus.yml ./docker/prometheus/config/
cp cassandra-jmx.yml ./docker/jmx-exporter/config/cassandra.yml

# 4. Démarrer l'environnement
docker-compose -f docker-compose-linux.yml up -d
```

## Structure des répertoires

```
./
├── docker-compose-linux.yml
├── prometheus.yml
├── cassandra-jmx.yml
├── start-environment-linux.sh
├── cleanup-environment.sh
└── docker/
    ├── cassandra11/          # Données Cassandra nœud 1
    ├── cassandra12/          # Données Cassandra nœud 2
    ├── cassandra13/          # Données Cassandra nœud 3
    ├── cassandra21/          # Données Cassandra nœud 4
    ├── cassandra22/          # Données Cassandra nœud 5
    ├── cassandra23/          # Données Cassandra nœud 6
    ├── prometheus/
    │   ├── config/           # Configuration Prometheus
    │   └── data/             # Données Prometheus
    ├── grafana/
    │   ├── config/           # Configuration Grafana
    │   └── data/             # Données Grafana
    └── jmx-exporter/
        └── config/           # Configuration JMX Exporter
```

## Accès aux services

- **Cluster Cassandra**:
  - Nord: ports 9142, 9242, 9342
  - Terres-de-la-Couronne: ports 9442, 9542, 9642
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3000 (admin/admin123)
- **Métriques JMX**: http://localhost:8080/metrics

## Commandes utiles

### Gestion des conteneurs
```bash
# Vérifier le statut
docker-compose -f docker-compose-linux.yml ps

# Voir les logs
docker-compose -f docker-compose-linux.yml logs prometheus
docker-compose -f docker-compose-linux.yml logs grafana

# Redémarrer un service
docker-compose -f docker-compose-linux.yml restart prometheus

# Arrêter l'environnement
docker-compose -f docker-compose-linux.yml down
```

### Vérification Cassandra
```bash
# Se connecter à un nœud Cassandra
docker exec -it cassandra11 cqlsh

# Vérifier le statut du cluster
docker exec -it cassandra11 nodetool status
```

### Debugging
```bash
# Vérifier les métriques JMX
curl http://localhost:8080/metrics | grep cassandra

# Vérifier les targets Prometheus
curl http://localhost:9090/api/v1/targets
```

## Permissions et sécurité

Le configuration utilise l'UID/GID 1000:1000 pour Prometheus et Grafana, ce qui correspond généralement au premier utilisateur créé sur Ubuntu. Si vous utilisez un UID différent, modifiez les valeurs `user:` dans le docker-compose.

## Nettoyage

Utilisez le script de nettoyage pour arrêter et supprimer l'environnement:

```bash
chmod +x cleanup-environment.sh
./cleanup-environment.sh
```

## Surveillance avancée

Une fois Grafana configuré:
1. Ajoutez Prometheus comme source de données: `http://prometheus:9090`
2. Importez des dashboards Cassandra depuis grafana.com
3. Créez des alertes sur les métriques critiques

## Prérequis Ubuntu

- Ubuntu 18.04+ (testé sur 20.04/22.04)
- Docker 20.10+
- Docker Compose 1.25+
- Au moins 8GB RAM recommandés pour le cluster complet