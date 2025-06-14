#!/usr/bin/env bash
# 04_grafana.sh — Aprovisionar Grafana (datasource + dashboards)

set -e

BASE_DIR="honeypot"

# ----- rutas host -----
DS_DIR="$BASE_DIR/grafana/provisioning/datasources"      # YAML datasource
PR_DIR="$BASE_DIR/grafana/provisioning/dashboards"       # YAML provider
LDB_DIR="scripts_monitor/dashboards"                     # JSON local dashboards
DB_DIR="$BASE_DIR/grafana/dashboards"                    # JSON dashboards


echo "Generando datasource Loki…"
cat > "$DS_DIR/loki.yml" <<'EOF'
apiVersion: 1
datasources:
  - name: Loki
    uid: loki_uid
    type: loki
    access: proxy
    url: http://loki:3100
    isDefault: true
    editable: false
    jsonData:
      maxLines: 1000
EOF

echo "Generando datasource Prometheus…"
cat > "$DS_DIR/prometheus.yml" << EOF
apiVersion: 1
datasources:
  - name: Prometheus
    uid: prometheus_uid
    type: prometheus
    access: proxy
    url: http://$HONEYPOT_ID:9090/
    isDefault: false
    editable: false
EOF

echo "Generando provider de dashboards…"
# IMPORTANTE: la ruta ES LA DEL CONTENEDOR, no la del host
cat > "$PR_DIR/honeypot_provider.yml" <<'EOF'
apiVersion: 1
providers:
  - name: Honeypot default
    orgId: 1
    folder: Honeypot
    type: file
    allowUiUpdates: true
    updateIntervalSeconds: 30
    options:
      path: /var/lib/grafana-dashboards        # ← ruta del contenedor
      foldersFromFilesStructure: true
EOF

sudo cp $LDB_DIR/apache_grafana.json $DB_DIR/
sudo cp $LDB_DIR/mysql_dashboard.json $DB_DIR/
sudo cp $LDB_DIR/prometheus_dashboard.json $DB_DIR/
sudo cp $LDB_DIR/proftpd_dashboard.json $DB_DIR/

echo "Datasource y dashboard listos."
