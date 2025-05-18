#!/usr/bin/env bash
# 04_grafana.sh — Aprovisionar Grafana (datasource + dashboards)

set -e
GF_PROV_DS="honeypot/grafana/provisioning/datasources"
GF_PROV_DB="honeypot/grafana/provisioning/dashboards"
GF_DASH="honeypot/grafana/dashboards"

echo "Generando datasource Loki…"
cat > $GF_PROV_DS/loki.yml <<'EOF'
apiVersion: 1
datasources:
  - name: Loki
    uid: loki          # uid interno para referenciarlo desde paneles
    type: loki
    access: proxy
    url: http://mi_loki:3100
    jsonData:
      maxLines: 1000
EOF

echo "Generando proveedor de dashboards…"
cat > $GF_PROV_DB/honeypot_dashboards.yml <<'EOF'
apiVersion: 1
providers:
  - name: Honeypot default
    orgId: 1
    folder: Honeypot          # carpeta visible en la UI de Grafana
    type: file
    disableDeletion: false
    updateIntervalSeconds: 30
    allowUiUpdates: true
    options:
      path: /var/lib/grafana/dashboards   # ↔  monta tu $BASE_DIR/grafana/dashboards aquí
EOF

echo "Generando dashboard Honeypot por defecto…"
cat > $GF_DASH/honeypot_overview.json <<'EOF'
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

echo "Grafana configurado con datasource, provisioning y dashboard por defecto."
