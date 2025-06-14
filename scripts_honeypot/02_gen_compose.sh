#!/usr/bin/env bash
# 02_gen_compose.sh — Genera docker-compose.yml

set -e
BASE_DIR="honeypot"
OUT="$BASE_DIR/docker-compose.yml"

echo "==> Generando $OUT..."
cat > $OUT << 'EOF'
services:

## ──────────────────────────────  Apache ───────────────────────────────────── ##
  apache:
    build: ./apache
    image: apache_custom
    container_name: apache
    depends_on: [mysql]
    volumes:
      - ./web/:/var/www/html:ro
      - ./volumenes/apache_logs:/var/log/apache2           
    ports: ["80:80"]
    networks: { dmz: { ipv4_address: 172.18.0.12 } }

## ──────────────────────────────  MySQL Database ───────────────────────────── ##
  mysql:
    image: mysql:5.7
    container_name: mysql
    restart: unless-stopped
    environment:
      MYSQL_DATABASE: bbdd
      MYSQL_ROOT_PASSWORD: vagrant
      MYSQL_USER: usuario
      MYSQL_PASSWORD: passwd
    volumes:
      - ./volumenes/mysql_data:/var/lib/mysql
      - ./volumenes/mysql_log:/var/log/mysql
      - ./config/my.cnf:/etc/my.cnf
      - ./sql-init:/docker-entrypoint-initdb.d
    ports: ["3306:3306"]
    networks: { dmz: { ipv4_address: 172.18.0.18 } }

## ──────────────────────────────  FTP (ProFTPD) ────────────────────────────── ##
  ftp:
    build: ./proftpd
    container_name: ftp
    volumes:
      - ./proftpd/proftpd.conf:/etc/proftpd/proftpd.conf:ro
      - ./volumenes/ftp_logs:/var/log/proftpd
    ports: ["21:21", "21100-21110:21100-21110"]
    networks: { dmz: { ipv4_address: 172.18.0.11 } }

## ──────────────────────────────  Fake SSH ─────────────────────────────────── ##
  fake_ssh:
    image: alpine
    container_name: fake_ssh
    command: 'sh -c "while true; do echo $$(date) - SSH attempt from fake IP >> /var/log/fakessh.log; sleep 10; done"'
    volumes:
      - ./volumenes/fakessh_logs:/var/log
    networks: { dmz: { ipv4_address: 172.18.0.20 } }
    
###############################  Monitoring & Logging ##############################

## ──────────────────────────────  Prometheus ───────────────────────────────── ##
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: unless-stopped
    ports:
      - "9090:9090"
    volumes:
      - ./config/prometheus.yml:/etc/prometheus/prometheus.yml:ro
    networks: { dmz: { ipv4_address: 172.18.0.30 } }

## ──────────────────────────────  Node Exporter ───────────────────────────── ##
  node_exporter:
    image: prom/node-exporter:latest
    container_name: node_exporter
    restart: unless-stopped
    ports:
      - "9100:9100"
    networks: { dmz: { ipv4_address: 172.18.0.32 } }

## ─────────────────────────────  Promtail ─────────────────────────────────── ##
  promtail:
    image: grafana/promtail:2.9.6
    container_name: promtail
    restart: unless-stopped
    command: -config.file=/etc/promtail/config.yml
    volumes:
      # logs texto plano
      - ./volumenes/apache_logs:/var/log/apache2:ro
      - ./volumenes/mysql_log:/var/log/mysql:ro
      - ./volumenes/ftp_logs:/var/log/proftpd:ro
      - ./volumenes/fakessh_logs:/var/log/fakessh:ro
      # config & posiciones
      - ./config/promtail-config.yaml:/etc/promtail/config.yml:ro
      - promtail-data:/var/lib/promtail
    networks: { dmz: { ipv4_address: 172.18.0.15 } }

#################################################################################
#                                   VOLUMES                                     #
#################################################################################

volumes:
  promtail-data:

#################################################################################
#                                   NETWORKS                                    #
#################################################################################

networks:
  dmz:
    driver: bridge
    ipam:
      config:
        - subnet: 172.18.0.0/16
          gateway: 172.18.0.1

EOF

echo "docker-compose.yml generado."