# Cassandra Prometheus Grafana
Expérimentations

# Pour lancer / arrêter / démonter : 

docker compose -f docker-compose-linux -d

docker compose -f docker-compose-linux stop

docker compose -f docker-compose-linux start

docker compose -f docker-compose-linux down -v

# URL : 

## Ecosystème et Accès aux services:

### - Cassandra Datacenter Nord:
* cassandra11: localhost:9142
* cassandra12: localhost:9242 
* cassandra13: localhost:9342

### - Cassandra Datacenter Terres-de-la-Couronne:
* cassandra21: localhost:9442
* cassandra22: localhost:9542
* cassandra23: localhost:9642

### - Monitoring:
* Port JMX cassandra : 7199
* Prometheus: http://localhost:9090
* Grafana: http://localhost:3000 (admin/admin123)
* JMX Exporter: http://localhost:8080/metrics

### Template Grafana : 
* https://grafana.com/grafana/dashboards/10849-cassandra-dashboard/

## Image Conteneur Cassandra officielle :
* https://hub.docker.com/_/cassandra
