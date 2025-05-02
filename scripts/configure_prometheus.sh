#!/usr/bin/env bash
# Genera prometheus.yml

set -e

dir="honeypot/config"

cat > $dir/prometheus.yml << 'EOF'
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

echo "prometheus.yml generado en $dir"
