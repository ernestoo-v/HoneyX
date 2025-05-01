#!/usr/bin/env bash
# Script para generar la estructura y ficheros de un honeypot de media interacción
# con Cowrie (SSH), Dionaea (FTP) y Glastopf (HTTP).

set -e

# Base directory
dir="honeypot"

# Crear estructura de carpetas
mkdir -p $dir/{cowrie,dionaea,glastopf}

echo "Creando directorios..."

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

  glastopf:
    image: harrybb/glastopf:latest
    container_name: honeypot_glastopf
    restart: unless-stopped
    ports:
      - "80:80"
    volumes:
      # Monta tu cfg en la ruta donde Glastopf la busca por defecto :contentReference[oaicite:0]{index=0}
      - ./glastopf/glastopf.cfg:/etc/glastopf/glastopf.cfg:ro
      # Directorio de datos y logs, persistente en host
      - ./glastopf/data:/data/glastopf
    networks:
      dmz:
        ipv4_address: 172.18.0.12

networks:
  dmz:
    driver: bridge
    ipam:
      config:
        - subnet: 172.18.0.0/16
          gateway: 172.18.0.1
EOF

echo "Generando Cowrie..."
# Dockerfile para Cowrie
cat > $dir/cowrie/Dockerfile << 'EOF'
FROM cowrie/cowrie:latest
COPY cowrie.cfg /cowrie/etc/cowrie.cfg
EOF

# Config mínima de Cowrie
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

echo "Generando Dionaea..."
# Dockerfile para Dionaea
cat > $dir/dionaea/Dockerfile << 'EOF'
FROM dinotools/dionaea:latest
COPY dionaea.conf /etc/dionaea/dionaea.conf
EOF

# Config mínima de Dionaea
cat > $dir/dionaea/dionaea.conf << 'EOF'
[dionaea]
sensor_name = honeypot-ftp
# Habilitar módulo FTP
modules = ftp
# Formato de log JSON
log_format = json

[ftp]
enabled = true
listen_address = 0.0.0.0
listen_port = 21
EOF

echo "Generando Glastopf..."
# Dockerfile para Glastopf
cat > $dir/glastopf/Dockerfile << 'EOF'
FROM mushorg/glastopf:latest
COPY glastopf.cfg /glastopf/data/glastopf.cfg
EOF

# Config mínima de Glastopf
cat > $dir/glastopf/glastopf.cfg << 'EOF'
[server]
host = 0.0.0.0
port = 80

[logging]
enable_http_logs = true
log_dir = /glastopf/data/logs

[plugins]
# Habilitar detección de XSS, SQLi, LFI
xss = true
sqli = true
lfi = true
EOF

# Hacer script ejecutable
chmod +x $0

echo "Estructura y ficheros generados en ./$dir"
