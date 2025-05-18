#!/usr/bin/env bash
# 02_gen_compose.sh — Genera docker-compose.yml

set -e
BASE_DIR="honeypot"
OUT="$BASE_DIR/docker-compose.yml"

echo "==> Generando $OUT..."
cat > $OUT << 'EOF'
services:
  loki:
    image: grafana/loki:2.9.6
    container_name: loki
    command: -config.file=/etc/loki/local-config.yaml
    volumes:
      - ./loki:/var/loki
      - ./config/loki-config.yaml:/etc/loki/local-config.yaml:ro
    ports: ["3100:3100"]
    networks: { dmz: { ipv4_address: 172.18.0.14 } }

  grafana:
    image: grafana/grafana:11.6.1
    container_name: grafana
    depends_on: [loki]
    restart: unless-stopped
    environment:
      GF_SECURITY_ADMIN_PASSWORD: admin
    ports: ["3000:3000"]
    volumes:
      - ./grafana/data:/var/lib/grafana
      - ./grafana/provisioning:/etc/grafana/provisioning:ro
      - ./grafana/dashboards:/var/lib/grafana-dashboards   # carpeta para JSON model
    networks: { dmz: { ipv4_address: 172.18.0.13 } }

networks:
  dmz:
    driver: bridge
    ipam:
      config:
        - subnet: 172.18.0.0/16
          gateway: 172.18.0.1

EOF

echo "docker-compose.yml generado."
