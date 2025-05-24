#!/usr/bin/env bash
# 04_grafana.sh — Aprovisionar Grafana (datasource + dashboards)

set -e

BASE_DIR="honeypot"

# ----- rutas host -----
DS_DIR="$BASE_DIR/grafana/provisioning/datasources"      # YAML datasource
PR_DIR="$BASE_DIR/grafana/provisioning/dashboards"       # YAML provider
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

echo "Creando dashboard Honeypot Overview…"
cat > "$DB_DIR/honeypot_overview.json" <<'EOF'
{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": {
          "type": "grafana",
          "uid": "-- Grafana --"
        },
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "type": "dashboard"
      }
    ]
  },
  "editable": true,
  "fiscalYearStartMonth": 0,
  "graphTooltip": 0,
  "id": 21,
  "links": [],
  "panels": [
    {
      "datasource": "$DS_LOKI",
      "fieldConfig": {
        "defaults": {},
        "overrides": []
      },
      "gridPos": {
        "h": 10,
        "w": 24,
        "x": 0,
        "y": 0
      },
      "id": 1,
      "options": {
        "dedupStrategy": "none",
        "enableInfiniteScrolling": false,
        "enableLogDetails": true,
        "prettifyLogMessage": false,
        "showCommonLabels": false,
        "showLabels": false,
        "showTime": true,
        "sortOrder": "Descending",
        "wrapLogMessage": true
      },
      "pluginVersion": "11.6.1",
      "targets": [
        {
          "expr": "{job=\"apache\",env=\"$env\",type=\"$type\"}",
          "refId": "A"
        }
      ],
      "title": "Apache Logs ($type)",
      "type": "logs"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "$DS_LOKI"
      },
      "fieldConfig": {
        "defaults": {
          "custom": {
            "align": "auto",
            "cellOptions": {
              "type": "auto"
            },
            "inspect": false
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "Petición"
            },
            "properties": [
              {
                "id": "custom.width",
                "value": 378
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 10,
        "w": 24,
        "x": 0,
        "y": 10
      },
      "id": 5,
      "options": {
        "cellHeight": "sm",
        "footer": {
          "countRows": false,
          "fields": "",
          "reducer": [
            "sum"
          ],
          "show": false
        },
        "showHeader": true,
        "sortBy": []
      },
      "pluginVersion": "11.6.1",
      "targets": [
        {
          "direction": "backward",
          "editorMode": "code",
          "exemplar": false,
          "expr": "{job=\"apache\", env=\"$env\", type=\"access\"} |~ \" [45][0-9][0-9] \" | regexp `(?P<ip>\\d+\\.\\d+\\.\\d+\\.\\d+) - - \\[[^\\]]+\\] \\\"(?P<request>[A-Z]+ [^\\\"]+ HTTP/[0-9.]+)\\\" (?P<code>[45][0-9]{2})`",
          "format": "logs",
          "instant": false,
          "queryType": "range",
          "refId": "A"
        }
      ],
      "title": "Errores HTTP Detallados",
      "transformations": [
        {
          "id": "extractFields",
          "options": {
            "delimiter": ",",
            "pattern": "",
            "source": "labels"
          }
        },
        {
          "id": "organize",
          "options": {
            "excludeByName": {
              "Line": true,
              "code": true,
              "env": true,
              "filename": true,
              "id": true,
              "ip": true,
              "job": true,
              "labels": true,
              "line": true,
              "tsNs": true,
              "type": true
            },
            "includeByName": {},
            "indexByName": {
              "Line": 6,
              "Time": 0,
              "code": 4,
              "env": 9,
              "filename": 10,
              "id": 8,
              "ip": 2,
              "job": 11,
              "labels": 5,
              "method": 12,
              "remote_ip": 1,
              "request": 3,
              "status": 13,
              "tsNs": 7,
              "type": 14
            },
            "renameByName": {
              "code": "Código",
              "ip": "IP",
              "request": "Petición",
              "ts": "Time"
            }
          }
        }
      ],
      "type": "table"
    },
    {
      "datasource": "$DS_LOKI",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 20
      },
      "id": 2,
      "interval": "1s",
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "table",
          "placement": "bottom",
          "showLegend": true,
          "sortBy": "Name",
          "sortDesc": false
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.1",
      "targets": [
        {
          "expr": "rate({job=\"apache\",env=\"$env\",type=\"access\"}[1m])",
          "refId": "A"
        }
      ],
      "title": "Requests per second",
      "type": "timeseries"
    },
    {
      "datasource": "$DS_LOKI",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "bars",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 20
      },
      "id": 3,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "table",
          "placement": "bottom",
          "showLegend": true
        },
        "stacking": {
          "mode": "normal"
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.6.1",
      "targets": [
        {
          "expr": "sum by (status)(rate({job=\"apache\",env=\"$env\",type=\"access\"}[1m]))",
          "refId": "A"
        }
      ],
      "title": "HTTP Status Codes (rate)",
      "type": "timeseries"
    },
    {
      "datasource": "$DS_LOKI",
      "fieldConfig": {
        "defaults": {
          "custom": {
            "align": "auto",
            "cellOptions": {
              "type": "auto"
            },
            "inspect": false
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green"
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 28
      },
      "id": 4,
      "options": {
        "cellHeight": "sm",
        "columns": [
          {
            "field": "remote_ip",
            "text": "IP"
          },
          {
            "field": "__value__",
            "text": "Connections"
          }
        ],
        "footer": {
          "countRows": false,
          "fields": "",
          "reducer": [
            "sum"
          ],
          "show": false
        },
        "showHeader": true,
        "sortBy": []
      },
      "pluginVersion": "11.6.1",
      "targets": [
        {
          "expr": "topk(10, sum by (remote_ip) (count_over_time({job=\"apache\", env=\"$env\", type=\"access\"}[5m])))",
          "instant": true,
          "refId": "A"
        }
      ],
      "title": "Top 10 IPs by Connections",
      "transformations": [
        {
          "id": "labelsToFields",
          "options": {
            "mode": "values"
          }
        }
      ],
      "type": "table"
    }
  ],
  "preload": false,
  "refresh": "5s",
  "schemaVersion": 41,
  "tags": [
    "honeypot",
    "apache",
    "logs"
  ],
  "templating": {
    "list": [
      {
        "current": {
          "text": "Loki",
          "value": "loki_uid"
        },
        "label": "Loki datasource",
        "name": "DS_LOKI",
        "options": [],
        "query": "loki",
        "refresh": 1,
        "type": "datasource"
      },
      {
        "current": {
          "text": "access",
          "value": "access"
        },
        "datasource": "$DS_LOKI",
        "label": "Log type",
        "name": "type",
        "options": [],
        "query": "label_values({job=\"apache\",env=\"honeypot\"}, type)",
        "refresh": 2,
        "type": "query"
      },
      {
        "current": {
          "text": "honeypot",
          "value": "honeypot"
        },
        "hide": 2,
        "label": "Environment",
        "name": "env",
        "query": "honeypot",
        "skipUrlSync": true,
        "type": "constant"
      }
    ]
  },
  "time": {
    "from": "now-24h",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "browser",
  "title": "Apache Logs Dashboard",
  "uid": "apache-logs",
  "version": 5
}
EOF

echo "Datasource y dashboard listos."
