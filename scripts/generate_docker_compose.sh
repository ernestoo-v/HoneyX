#!/usr/bin/env bash
# Genera el docker-compose.yml completo

set -e

dir="honeypot"
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
      - ./cowrie/cowrie.cfg:/cowrie/etc/cowrie.cfg

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

echo "docker-compose.yml generado en ./$dir"
