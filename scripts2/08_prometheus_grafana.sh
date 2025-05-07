#!/usr/bin/env bash
# 08_prometheus_grafana.sh — Prometheus y Grafana

set -e
CONF="honeypot/config"
GF_PROV="honeypot/grafana/provisioning/datasources"

echo "==> Generando prometheus.yml..."
cat > $CONF/prometheus.yml << 'EOF'
[... prometheus.yml ...]
EOF

echo "==> Grafana provisioning..."
mkdir -p $GF_PROV
cat > $GF_PROV/datasource.yml << 'EOF'
[... datasource.yml ...]
EOF

echo "Prometheus y Grafana listos."