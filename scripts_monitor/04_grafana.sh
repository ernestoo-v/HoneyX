#!/usr/bin/env bash
# 04_grafana.sh — Grafana

set -e
CONF="honeypot/config"
GF_PROV="honeypot/grafana/provisioning/datasources"

echo "Generando configuración de provisioning para Grafana..."
cat > $CONF/prometheus.yml << 'EOF'
apiVersion: 1
datasources:
  - name: Loki
    type: loki
    access: proxy
    url: http://mi_loki:3100
    jsonData:
      maxLines: 1000
EOF

echo "Grafana configurado."