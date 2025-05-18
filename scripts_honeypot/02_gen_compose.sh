#!/usr/bin/env bash
# 02_gen_compose.sh — Genera docker-compose.yml

set -e
BASE_DIR="honeypot"
OUT="$BASE_DIR/docker-compose.yml"

echo "==> Generando $OUT..."
cat > $OUT << 'EOF'
version: "3.8"

services:
  mi_ftp:
    build: ./proftpd
    container_name: mi_ftp
    environment:
      - PASV_ADDRESS=0.0.0.0
      - PASV_MIN_PORT=21100
      - PASV_MAX_PORT=21110
    volumes:
      - ./proftpd/proftpd.conf:/etc/proftpd/proftpd.conf
      - ./volumenes/ftp_logs:/var/log/proftpd
    ports:
      - "21:21"
      - "21100-21110:21100-21110"
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
      - ./sql-init:/docker-entrypoint-initdb.d
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

  mi_promtail:
    image: grafana/promtail:2.9.0
    container_name: mi_promtail
    restart: unless-stopped
    command: -config.file=/etc/promtail/config.yml
    volumes:
      - ./volumenes/apache_logs:/var/log/apache2:ro
      - ./volumenes/mysql_log:/var/log/mysql:ro
      - ./volumenes/ftp_logs:/var/log/proftpd:ro
      - ./volumenes/cowrie_logs:/cowrie/log:ro
      - ./config/promtail-config.yaml:/etc/promtail/config.yml:ro
      - promtail-data:/var/lib/promtail
    networks:
      dmz:
        ipv4_address: 172.18.0.15

networks:
  dmz:
    driver: bridge
    ipam:
      config:
        - subnet: 172.18.0.0/16
          gateway: 172.18.0.1
EOF

echo "docker-compose.yml generado."
