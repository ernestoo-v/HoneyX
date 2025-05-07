#!/usr/bin/env bash
# 08_prometheus_grafana.sh — Prometheus y Grafana

set -e
CONF="honeypot/config"
GF_PROV="honeypot/grafana/provisioning/datasources"

echo "==> Generando prometheus.yml..."
cat > $CONF/prometheus.yml << 'EOF'
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

echo "==> Grafana provisioning..."
mkdir -p $GF_PROV
cat > $GF_PROV/datasource.yml << 'EOF'
apiVersion: 1
datasources:
  - name: Loki
    type: loki
    access: proxy
    url: http://mi_loki:3100
    jsonData:
      maxLines: 1000
EOF

echo "Prometheus y Grafana listos."