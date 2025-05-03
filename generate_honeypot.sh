#!/usr/bin/env bash
# Script para generar la estructura y ficheros de un honeypot de media interacción
# con Cowrie (SSH), Vsftpd (FTP), un servicio web Apache+PHP y herramientas de observabilidad.

set -e

# Base directory
dir="honeypot"

# Crear estructura de carpetas
mkdir -p $dir/{cowrie,mi_ftp,web,volumenes/apache_logs,volumenes/mysql_log,volumenes/ftp_logs,grafana/data,grafana/provisioning/datasources,config}
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

  mi_ftp:
    image: fauria/vsftpd
    container_name: mi_ftp
    environment:
      - FTP_USER=ftpuser
      - FTP_PASS=ftppass
      - PASV_ADDRESS=0.0.0.0
      - PASV_MIN_PORT=21
      - PASV_MAX_PORT=21
      - FILE_OPEN_MODE=0666
      - LOCAL_UMASK=022
      - LOG_STDOUT=YES
    volumes:
      - ./mi_ftp/vsftpd.conf:/etc/vsftpd.conf
      - ./volumenes/ftp_logs:/var/log/vsftpd
    ports:
      - "21:21"
    networks:
      dmz:
        ipv4_address: 172.18.0.11
  
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
    build:
      context: ./apache
      dockerfile: Dockerfile
    image: mi_apache_custom
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
      - ./volumenes/ftp_logs:/var/log/vsftpd
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

# mi_ftp
echo "Generando configuración para mi_ftp..."

mkdir -p $dir/mi_ftp

cat > $dir/mi_ftp/vsftpd.conf << 'EOF'
listen=YES
anonymous_enable=YES
local_enable=YES
write_enable=NO
dirmessage_enable=YES
xferlog_enable=YES
xferlog_file=/var/log/vsftpd.log
log_ftp_protocol=YES
connect_from_port_20=YES
xferlog_std_format=YES
ftpd_banner=Welcome to FTP.
listen_port=21
pasv_enable=YES
pasv_min_port=21
pasv_max_port=21
pasv_address=0.0.0.0
EOF

# Servicio web Apache+PHP
echo "Generando servicio web Apache+PHP..."
# Generar Dockerfile para Apache+PHP en directorio apache/
echo "Creando directorio apache/ y Dockerfile de build..."
mkdir -p $dir/apache
cat > $dir/apache/Dockerfile << 'EOF'
FROM php:7-apache

# Instala las extensiones PDO y PDO_MySQL
RUN apt-get update \
 && docker-php-ext-install pdo pdo_mysql \
 && rm -rf /var/lib/apt/lists/*
EOF
echo "Dockerfile generado en $dir/apache/Dockerfile"

# Crear directorio web si no existe
mkdir -p $dir/web
mkdir -p $dir/web/assets/css
mkdir -p $dir/web/assets/js
# Web estática y PHP
echo "Generando archivos web..."
# index.php
cat > $dir/web/index.php << 'EOF'
<?php
include 'config.php';
?><!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><title>Restaurante Ejemplo - Inicio</title><link rel="stylesheet" href="assets/css/style.css"></head><body><header><h1>Bienvenidos</h1><nav><a href="index.php">Inicio</a><a href="menu.php">Menú</a><a href="contact.php">Contacto</a></nav></header><main><h2>Sobre Nosotros</h2><?php $stmt = $pdo->query("SELECT 'Historia del restaurante...' AS historia"); echo '<blockquote>' . $stmt->fetch()['historia'] . '</blockquote>'; ?></main><footer>&copy;<?=date('Y')?></footer><script src="assets/js/script.js"></script></body></html>
EOF

# config.php
cat > $dir/web/config.php << 'EOF'
<?php
$host = getenv('DB_HOST') ?: 'mi_mysql';
$db   = getenv('DB_NAME') ?: 'bbdd';
$user = getenv('DB_USER') ?: 'usuario';
$pass = getenv('DB_PASS') ?: 'passwd';
$dsn = "mysql:host={$host};dbname={$db};charset=utf8mb4";
try { $pdo = new PDO($dsn, $user, $pass, [PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION, PDO::ATTR_DEFAULT_FETCH_MODE=>PDO::FETCH_ASSOC]); } catch (PDOException $e) { echo "Error BD: " . $e->getMessage(); exit(1);} 
EOF

# menu.php
cat > $dir/web/menu.php << 'EOF'
<?php include 'config.php'; ?><!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><title>Menú</title><link rel="stylesheet" href="assets/css/style.css"></head><body><header><h1>Menú</h1><nav><a href="index.php">Inicio</a><a href="menu.php">Menú</a><a href="contact.php">Contacto</a></nav></header><main><h2>Platos</h2><ul><?php $platos=[['nombre'=>'Ensalada','precio'=>'8€'],['nombre'=>'Paella','precio'=>'12€'],['nombre'=>'Tarta','precio'=>'5€']]; foreach($platos as $p) echo "<li>{$p['nombre']} - <strong>{$p['precio']}</strong></li>"; ?></ul></main><footer>&copy;<?=date('Y')?></footer><script src="assets/js/script.js"></script></body></html>
EOF

# contact.php
cat > $dir/web/contact.php << 'EOF'
<?php include 'config.php'; ?><!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><title>Contacto</title><link rel="stylesheet" href="assets/css/style.css"></head><body><header><h1>Contacto</h1><nav><a href="index.php">Inicio</a><a href="menu.php">Menú</a><a href="contact.php">Contacto</a></nav></header><main><h2>Mensaje</h2><form id="contactForm"><label>Nombre:<input required name="name"></label><label>Email:<input type="email" required name="email"></label><label>Mensaje:<textarea required name="message"></textarea></label><button>Enviar</button></form><div id="formResult"></div></main><footer>&copy;<?=date('Y')?></footer><script src="assets/js/script.js"></script></body></html>
EOF

# Assets CSS y JS
cat > $dir/web/assets/css/style.css << 'EOF'
body{font-family:Arial,sans-serif;margin:0;padding:0;background:#fafafa;color:#333}header{background:#c0392b;color:#fff;padding:1rem;text-align:center}nav a{color:#fff;margin:0 1rem;text-decoration:none}main{padding:2rem}h2{color:#c0392b}footer{background:#2c3e50;color:#fff;text-align:center;padding:1rem;position:fixed;bottom:0;width:100%}form label{display:block;margin:0.5rem 0}form input,form textarea{width:100%;padding:0.5rem;border:1px solid #ccc;border-radius:4px}button{background:#c0392b;color:#fff;padding:0.5rem 1rem;border:none;border-radius:4px;cursor:pointer}button:hover{background:#e74c3c}
EOF

cat > $dir/web/assets/js/script.js << 'EOF'
document.addEventListener('DOMContentLoaded',function(){const form=document.getElementById('contactForm');if(form){form.addEventListener('submit',function(e){e.preventDefault();const data=new FormData(form);document.getElementById('formResult').innerText=`Gracias, ${data.get('name')}! Tu mensaje ha sido enviado.`;form.reset();}});
EOF

echo "Web de restaurante integrada correctamente."

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
          __path__: /var/log/vsftpd/*.log
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

