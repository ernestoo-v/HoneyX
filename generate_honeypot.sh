#!/usr/bin/env bash
# Script para generar la estructura y ficheros de un honeypot de media interacción
# con Cowrie (SSH), Dionaea (FTP), Apache+PHP y Grafana.

set -e

# Base directory
dir="honeypot"

# Crear estructura de carpetas
mkdir -p $dir/{cowrie,dionaea,web,volumenes/apache_logs,grafana/data,grafana/provisioning}
echo "Creando directorios: $dir/{cowrie,dionaea,web,volumenes/apache_logs,grafana/data,grafana/provisioning}"

# Asignar permisos adecuados a la carpeta de datos de Grafana
sudo chown -R 472:472 $dir/grafana/data
echo "Asignados permisos 472:472 a $dir/grafana/data"

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

networks:
  dmz:
    driver: bridge
    ipam:
      config:
        - subnet: 172.18.0.0/16
          gateway: 172.18.0.1
EOF

# Cowrie
echo "Generando Cowrie..."
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
echo "Generando Dionaea..."
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

echo "Estructura y ficheros generados en ./$dir"

