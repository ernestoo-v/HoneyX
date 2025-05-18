#!/usr/bin/env bash
# 04_grafana.sh — Aprovisionar Grafana (datasource + dashboards)

set -e

BASE_DIR="honeypot"
GF_PROV_DIR="$BASE_DIR/grafana/provisioning"          # raíz de provisioning en el host
GF_DS="$GF_PROV_DIR/datasources"
GF_DB="$GF_PROV_DIR/dashboards"                      # ← aquí irá el YAML *y* el JSON

echo "Generando datasource Loki…"
cat > "$GF_DS/loki.yml" <<'EOF'
apiVersion: 1
datasources:
  - name: Loki
    uid: loki
    type: loki
    access: proxy
    url: http://mi_loki:3100
    jsonData:
      maxLines: 1000
EOF

echo "Generando provider de dashboards…"
# IMPORTANTE: la ruta ES LA DEL CONTENEDOR, no la del host
cat > "$GF_DB/honeypot_provider.yml" <<'EOF'
apiVersion: 1
providers:
  - name: Honeypot default
    orgId: 1
    folder: Honeypot
    type: file
    disableDeletion: false
    updateIntervalSeconds: 30
    allowUiUpdates: true
    options:
      path: /etc/grafana/provisioning/dashboards
EOF

echo "Creando dashboard Honeypot Overview…"
cat > "$GF_DB/honeypot_overview.json" <<'EOF'
{
  "uid": "honeypot-overview",
  "title": "Honeypot Overview",
  "tags": ["honeypot"],
  "schemaVersion": 39,
  "version": 1,
  "refresh": "10s",
  "time": { "from": "now-6h", "to": "now" },
  "panels": [
    {
      "uid": "req_rate",
      "type": "timeseries",
      "title": "HTTP Request Rate",
      "datasource": { "type": "loki", "uid": "loki" },
      "targets": [
        {
          "expr": "sum by(job) (rate({app=\"apache\"} |~ \"GET|POST|HEAD\" [1m]))",
          "legendFormat": "{{job}}",
          "refId": "A"
        }
      ]
    },
    {
      "uid": "top_ips",
      "type": "table",
      "title": "Top Source IPs (last 1h)",
      "datasource": { "type": "loki", "uid": "loki" },
      "targets": [
        {
          "expr": "topk(10, count_over_time(({app=\"apache\"} | json | unwrap src_ip)[1h])) by (src_ip)",
          "refId": "A"
        }
      ],
      "transformations": [
        { "id": "seriesToColumns", "options": {} }
      ]
    },
    {
      "uid": "mysql_attempts",
      "type": "timeseries",
      "title": "MySQL Login Attempts",
      "datasource": { "type": "loki", "uid": "loki" },
      "targets": [
        {
          "expr": "sum by(user) (rate({app=\"mysql\"} |= \"Access denied\" [1m]))",
          "legendFormat": "{{user}}",
          "refId": "A"
        }
      ]
    }
  ],
  "templating": { "list": [] }
}
EOF

echo "Datasource y dashboard listos."
