#!/usr/bin/env bash
# 02_gen_compose.sh — Genera docker-compose.yml

set -e
BASE_DIR="honeypot"
OUT="$BASE_DIR/docker-compose.yml"

echo "==> Generando $OUT..."
cat > $OUT << 'EOF'
services:
#─────────────────── FTP ────────────────────
  mi_ftp:
    build: ./proftpd
    container_name: mi_ftp
    volumes:
      - ./proftpd/proftpd.conf:/etc/proftpd/proftpd.conf:ro
      - ./volumenes/ftp_logs:/var/log/proftpd
    ports: ["21:21", "21100-21110:21100-21110"]
    networks: { dmz: { ipv4_address: 172.18.0.11 } }

#─────────────────── MySQL ──────────────────
  mi_mysql:
    image: mysql:5.7
    container_name: mi_mysql
    restart: unless-stopped
    environment:
      MYSQL_DATABASE: bbdd
      MYSQL_ROOT_PASSWORD: vagrant
      MYSQL_USER: usuario
      MYSQL_PASSWORD: passwd
    volumes:
      - ./volumenes/mysql_data:/var/lib/mysql
      - ./volumenes/mysql_log:/var/log/mysql
      - ./config/my.cnf:/etc/my.cnf:ro
    ports: ["3306:3306"]
    networks: { dmz: { ipv4_address: 172.18.0.18 } }

#─────────────────── Apache + ModSecurity ───
  mi_apache:
    build: ./apache
    image: mi_apache_custom
    container_name: mi_apache
    depends_on: [mi_mysql]
    volumes:
      - ./web/:/var/www/html:ro
      - ./volumenes/apache_logs:/var/log/apache2            # access & error
      - ./volumenes/modsec_logs:/var/log/modsecurity        # audit JSON
    ports: ["80:80"]
    networks: { dmz: { ipv4_address: 172.18.0.12 } }

#─────────────────── Promtail ───────────────
  mi_promtail:
    image: grafana/promtail:2.9.6
    container_name: mi_promtail
    restart: unless-stopped
    command: -config.file=/etc/promtail/config.yml
    volumes:
      # logs texto plano
      - ./volumenes/apache_logs:/var/log/apache2:ro
      - ./volumenes/mysql_log:/var/log/mysql:ro
      - ./volumenes/ftp_logs:/var/log/proftpd:ro
      # log JSON de ModSecurity (ruta distinta para evitar solaparse)
      - ./volumenes/modsec_logs:/var/log/modsecurity:ro
      # config & posiciones
      - ./config/promtail-config.yaml:/etc/promtail/config.yml:ro
      - promtail-data:/var/lib/promtail
    networks: { dmz: { ipv4_address: 172.18.0.15 } }

volumes:
  promtail-data:

networks:
  dmz:
    driver: bridge
    ipam:
      config:
        - subnet: 172.18.0.0/16
          gateway: 172.18.0.1
EOF

echo "docker-compose.yml generado."
