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
  
  mi_mysql:
    image: mysql:5.7
    container_name: mi_mysql
    restart: unless-stopped
    environment:
      - MYSQL_DATABASE=bbdd
      - MYSQL_ROOT_PASSWORD=vagrant
      - MYSQL_USER=usuario
      - MYSQL_PASSWORD=passwd
    volumes:
      - ./volumenes/mysql_data:/var/lib/mysql
      - ./volumenes/mysql_log:/var/log/mysql
      - ./config/my.cnf:/etc/my.cnf
    ports:
      - "3306:3306"
    networks:
      dmz:
        ipv4_address: 172.18.0.18
  
  mi_apache:
    image: php:7-apache
    container_name: mi_apache
    restart: unless-stopped
    depends_on:
      - mi_mysql
    environment:
      - DB_HOST=mi_mysql
      - DB_NAME=bbdd
      - DB_USER=usuario
      - DB_PASS=passwd
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
# Crear directorio web si no existe
mkdir -p $dir/web

# index.php: incluye config.php y muestra phpinfo
cat > $dir/web/index.php << 'EOF'
<?php
// Carga la configuración de conexión a MySQL
require_once __DIR__ . '/config.php';

// Muestra información de PHP
phpinfo();
?>
EOF

# config.php: parámetros de conexión a MySQL desde variables de entorno
cat > $dir/web/config.php << 'EOF'
<?php
// Obtiene credenciales de MySQL de variables de entorno
\$host = getenv('DB_HOST') ?: 'mi_mysql';
\$db   = getenv('DB_NAME') ?: 'bbdd';
\$user = getenv('DB_USER') ?: 'usuario';
\$pass = getenv('DB_PASS') ?: 'passwd';

// DSN para PDO
\$dsn = "mysql:host={\$host};dbname={\$db};charset=utf8mb4";

try {
    \$pdo = new PDO(\$dsn, \$user, \$pass, [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
    echo \"Conectado a MySQL: {\$db} en {\$host}\" . PHP_EOL;
} catch (PDOException \$e) {
    echo \"Error de conexión a MySQL: \" . \$e->getMessage() . PHP_EOL;
    exit(1);
}
?>
EOF

echo "Archivos web/index.php y web/config.php generados."

# Configuración de MySQL (my.cnf)
echo "Generando my.cnf para MySQL..."
cat > $dir/config/my.cnf << 'EOF'
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/5.7/en/server-configuration-defaults.html

[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M
skip-host-cache
skip-name-resolve
datadir=/var/lib/mysql
socket=/var/run/mysqld/mysqld.sock
secure-file-priv=/var/lib/mysql-files
user=mysql

# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

log-error=/var/log/mysql/error.log
general_log = 1
general_log_file = /var/log/mysql/general.log
pid-file=/var/run/mysqld/mysqld.pid
[client]
socket=/var/run/mysqld/mysqld.sock

!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mysql.conf.d/
EOF

echo "my.cnf generado para MySQL."


# Configuración de Loki
echo "Generando configuración para Loki..."
cat > $dir/config/loki-config.yaml << 'EOF'
auth_enabled: false

server:
  http_listen_port: 3100
  grpc_listen_port: 9096

query_scheduler:
  max_outstanding_requests_per_tenant: 4096
frontend:
  max_outstanding_per_tenant: 4096

common:
  instance_addr: 127.0.0.1
  path_prefix: /tmp/loki
  storage:
    filesystem:
      chunks_directory: /tmp/loki/chunks
      rules_directory: /tmp/loki/rules
  replication_factor: 1
  ring:
    kvstore:
      store: inmemory

query_range:
  results_cache:
    cache:
      embedded_cache:
        enabled: true
        max_size_mb: 100

schema_config:
  configs:
    - from: 2020-10-24
      store: boltdb-shipper
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h

ruler:
  alertmanager_url: http://localhost:9093

analytics:
  reporting_enabled: false
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
  - job_name: apache
    static_configs:
      - targets:
          - localhost
        labels:
          job: apache
          __path__: /var/log/apache2/*.log

  - job_name: mysql
    static_configs:
      - targets:
          - localhost
        labels:
          job: mysql
          __path__: /var/log/mysql/*.log

  - job_name: ftp
    static_configs:
      - targets:
          - localhost
        labels:
          job: ftp
          __path__: /var/log/vsftpd.log
EOF

# Configuración de Prometheus
echo "Generando configuración para Prometheus..."
cat > $dir/config/prometheus.yml << 'EOF'
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['mi_prometheus:9090']
  - job_name: 'mysql'
    static_configs:
      - targets: ['mi_mysql:9104']
  - job_name: 'apache'
    static_configs:
      - targets: ['mi_apache:9117']
  - job_name: 'ftp'
    static_configs:
      - targets: ['mi_ftp:9123']
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['mi_node_exporter:9100']
  - job_name: 'grafana'
    static_configs:
      - targets: ['mi_grafana:3000']
  - job_name: 'loki'
    static_configs:
      - targets: ['mi_loki:3100']
  - job_name: 'promtail'
    static_configs:
      - targets: ['mi_promtail:9080']
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

