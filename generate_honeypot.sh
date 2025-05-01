#!/usr/bin/env bash
# Script para generar la estructura y ficheros de un honeypot de media interacción
# con Cowrie (SSH), Dionaea (FTP), un servicio web Apache+PHP y herramientas de observabilidad.

set -e

# Base directory
dir="honeypot"

# Crear estructura de carpetas
mkdir -p $dir/{cowrie,dionaea,web,volumenes/apache_logs,volumenes/mysql_log,volumenes/ftp_logs,grafana/data,grafana/provisioning/datasources,config}
echo "Creando directorios necesarios..."

# Asignar permisos adecuados para Grafana
sudo chown -R 472:472 $dir/grafana/data
echo "Asignando permisos a grafana/data..."

# Generar docker-compose.yml
echo "Generando docker-compose.yml..."
cat > $dir/docker-compose.yml << 'EOF'
version: "3.8"

services:
  cowrie:
    build: ./cowrie
    container_name: honeypot_cowrie
    restart: unless-stopped
    networks:
      dmz:
        ipv4_address: 172.18.0.10
    volumes:
      - type: bind
        source: ./cowrie/cowrie.cfg
        target: /cowrie/etc/cowrie.cfg

  dionaea:
    build: ./dionaea
    container_name: honeypot_dionaea
    restart: unless-stopped
    networks:
      dmz:
        ipv4_address: 172.18.0.11
    tmpfs:
      - /dionaea/data:rw,size=100m

  mi_apache:
    image: php:7-apache
    container_name: mi_apache
    restart: unless-stopped
    volumes:
      - ./web/:/var/www/html:ro
      - ./volumenes/apache_logs:/var/log/apache2
    ports:
      - "80:80"
    networks:
      dmz:
        ipv4_address: 172.18.0.12

  grafana:
    image: grafana/grafana-oss:latest
    container_name: honeypot_grafana
    restart: unless-stopped
    ports:
      - "3000:3000"
    networks:
      dmz:
        ipv4_address: 172.18.0.13
    volumes:
      - ./grafana/data:/var/lib/grafana
      - ./grafana/provisioning:/etc/grafana/provisioning

  mi_loki:
    image: grafana/loki:2.9.0
    container_name: mi_loki
    command: -config.file=/etc/loki/local-config.yaml
    volumes:
      - ./config/loki-config.yaml:/etc/loki/local-config.yaml
    ports:
      - "3100:3100"
    networks:
      dmz:
        ipv4_address: 172.18.0.14

  mi_promtail:
    image: grafana/promtail:2.9.0
    container_name: mi_promtail
    volumes:
      - ./volumenes/apache_logs:/var/log/apache2
      - ./volumenes/mysql_log:/var/log/mysql
      - ./volumenes/ftp_logs:/var/log/
      - ./config/promtail-config.yaml:/etc/promtail/config.yml
    command: -config.file=/etc/promtail/config.yml
    networks:
      dmz:
        ipv4_address: 172.18.0.15

  mi_prometheus:
    image: prom/prometheus:latest
    container_name: mi_prometheus
    volumes:
      - ./config/prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"
    networks:
      dmz:
        ipv4_address: 172.18.0.16

  mi_node_exporter:
    image: prom/node-exporter:latest
    container_name: mi_node_exporter
    ports:
      - "9100:9100"
    networks:
      dmz:
        ipv4_address: 172.18.0.17

networks:
  dmz:
    driver: bridge
    ipam:
      config:
        - subnet: 172.18.0.0/16
          gateway: 172.18.0.1
EOF

# Cowrie
echo "Generando configuración para Cowrie..."
cat > $dir/cowrie/Dockerfile << 'EOF'
FROM cowrie/cowrie:latest
COPY cowrie.cfg /cowrie/etc/cowrie.cfg
EOF

cat > $dir/cowrie/cowrie.cfg << 'EOF'
[honeypot]
hostname = honeypot-ssh
listen_addr = 0.0.0.0
listen_port = 22
log_path = /cowrie/log
download_path = /cowrie/dl

auth_class = AuthRandom
auth_class_parameters = 2,5,10

[output_jsonlog]
enabled = true
EOF

# Dionaea
echo "Generando configuración para Dionaea..."
cat > $dir/dionaea/Dockerfile << 'EOF'
FROM dinotools/dionaea:latest
COPY dionaea.conf /etc/dionaea/dionaea.conf
EOF

cat > $dir/dionaea/dionaea.conf << 'EOF'
[dionaea]
sensor_name = honeypot-ftp
modules = ftp
log_format = json

[ftp]
enabled = true
listen_address = 0.0.0.0
listen_port = 21
EOF

# Servicio web Apache+PHP
echo "Generando servicio web Apache+PHP..."
echo "<?php phpinfo(); ?>" > $dir/web/index.php

# Configuración de Loki
echo "Generando configuración para Loki..."
cat > $dir/config/loki-config.yaml << 'EOF'
auth_enabled: false
server:
  http_listen_port: 3100
  grpc_listen_port: 9095
ingester:
  lifecycler:
    ring:
      kvstore:
        store: inmemory
  final_sleep: 0s
  chunk_idle_period: 5m
  max_chunk_age: 1h
  chunk_target_size: 1048576
  chunk_retain_period: 30s
  wal:
    enabled: true
    dir: /tmp/wal
schema_config:
  configs:
    - from: 2022-01-01
      store: boltdb-shipper
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h
storage_config:
  boltdb_shipper:
    active_index_directory: /tmp/index
    cache_location: /tmp/index_cache
    shared_store: filesystem
  filesystem:
    directory: /tmp/chunks
limits_config:
  enforce_metric_name: false
  reject_old_samples: true
  reject_old_samples_max_age: 168h
chunk_store_config:
  max_look_back_period: 0s
table_manager:
  retention_deletes_enabled: false
  retention_period: 0s
EOF

# Configuración de Promtail
echo "Generando configuración para Promtail..."
cat > $dir/config/promtail-config.yaml << 'EOF'
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://mi_loki:3100/loki/api/v1/push

scrape_configs:
  - job_name: apache_logs
    static_configs:
      - targets:
          - localhost
        labels:
          job: apache
          __path__: /var/log/apache2/*.log

  - job_name: mysql_logs
    static_configs:
      - targets:
          - localhost
        labels:
          job: mysql
          __path__: /var/log/mysql/*.log

  - job_name: ftp_logs
    static_configs:
      - targets:
          - localhost
        labels:
          job: ftp
          __path__: /var/log/*.log
EOF

# Configuración de Prometheus
echo "Generando configuración para Prometheus..."
cat > $dir/config/prometheus.yml << 'EOF'
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['mi_node_exporter:9100']
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
EOF

# Configuración de provisioning para Grafana
echo "Generando configuración de provisioning para Grafana..."
cat > $dir/grafana/provisioning/datasources/datasource.yml << 'EOF'
apiVersion: 1
datasources:
  - name: Loki
    type: loki
    access: proxy
    url: http://mi_loki:3100
    jsonData:
      maxLines: 1000
EOF



echo "Estructura y ficheros generados en ./$dir"
