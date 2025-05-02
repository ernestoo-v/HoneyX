#!/usr/bin/env bash
# Genera la configuración de datasource para Grafana

set -e

dir="honeypot/grafana/provisioning/datasources"

cat > $dir/datasource.yml << 'EOF'
apiVersion: 1
datasources:
  - name: Loki
    type: loki
    access: proxy
    url: http://mi_loki:3100
    jsonData:
      maxLines: 1000
EOF

echo "datasource.yml generado en $dir"
