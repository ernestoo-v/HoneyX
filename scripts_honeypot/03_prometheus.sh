#!/usr/bin/env bash
# 03_prometheus.sh — Genera el archivo de configuración para Prometheus

set -e
DIR="honeypot/config"
mkdir -p "$DIR"

echo "==> Generando prometheus.yml para Prometheus..."
cat > "$DIR/prometheus.yml" << 'EOF'
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['172.18.0.32:9100']
EOF

echo "Archivo prometheus.yml generado en $DIR."