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
  "graphTooltip": 1,
  "id": 10,
  "links": [],
  "panels": [
    {
      "datasource": {
        "type": "loki",
        "uid": "loki_uid"
      },
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
        "y": 0
      },
      "id": 1,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
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
          "datasource": {
            "type": "loki",
            "uid": "loki_uid"
          },
          "expr": "count_over_time({job=\"mysql\"}[$__interval])",
          "legendFormat": "MySQL Logs",
          "queryType": "range",
          "refId": "A"
        }
      ],
      "title": "Gráfico de Líneas - Tasa de Logs MySQL",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "loki_uid"
      },
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
            "fillOpacity": 80,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineWidth": 1,
            "scaleDistribution": {
              "type": "linear"
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
        "y": 0
      },
      "id": 2,
      "options": {
        "barRadius": 0,
        "barWidth": 0.97,
        "fullHighlight": false,
        "groupWidth": 0.7,
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "orientation": "auto",
        "showValue": "auto",
        "stacking": "none",
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        },
        "xTickLabelRotation": 0,
        "xTickLabelSpacing": 0
      },
      "pluginVersion": "11.6.1",
      "targets": [
        {
          "datasource": {
            "type": "loki",
            "uid": "loki_uid"
          },
          "expr": "sum by (job) (count_over_time({job=~\".+\"}[1h]))",
          "queryType": "instant",
          "refId": "B"
        }
      ],
      "title": "Gráfico de Barras - Logs por Job (última hora)",
      "type": "barchart"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "loki_uid"
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
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 8
      },
      "id": 3,
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
        "showHeader": true
      },
      "pluginVersion": "11.6.1",
      "targets": [
        {
          "datasource": {
            "type": "loki",
            "uid": "loki_uid"
          },
          "expr": "sum by (job) (count_over_time({job=~\".+\"}[1h]))",
          "queryType": "instant",
          "refId": "C"
        }
      ],
      "title": "Tabla - Logs por Job (última hora)",
      "type": "table"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "loki_uid"
      },
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
        "x": 12,
        "y": 8
      },
      "id": 4,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
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
          "datasource": {
            "type": "loki",
            "uid": "loki_uid"
          },
          "expr": "sum(rate({job=\"mysql\"} |= \"error\" [$__interval])) by (instance)",
          "legendFormat": "Errores MySQL - {{instance}}",
          "queryType": "range",
          "refId": "D"
        }
      ],
      "title": "Gráfico de Líneas - Tasa de Errores en Logs de MySQL",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "loki_uid"
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
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 16
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
        "showHeader": true
      },
      "pluginVersion": "11.6.1",
      "targets": [
        {
          "datasource": {
            "type": "loki",
            "uid": "loki_uid"
          },
          "expr": "topk(5, sum by (user) (count_over_time({job=\"ftp\"} |= \"login failed\" [1h])))",
          "queryType": "instant",
          "refId": "E"
        }
      ],
      "title": "Tabla - Top 5 Usuarios con Más Intentos Fallidos de Login en FTP",
      "type": "table"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "loki_uid"
      },
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
            "fillOpacity": 80,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineWidth": 1,
            "scaleDistribution": {
              "type": "linear"
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
        "y": 16
      },
      "id": 6,
      "options": {
        "barRadius": 0,
        "barWidth": 0.97,
        "fullHighlight": false,
        "groupWidth": 0.7,
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "orientation": "auto",
        "showValue": "auto",
        "stacking": "none",
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        },
        "xTickLabelRotation": 0,
        "xTickLabelSpacing": 0
      },
      "pluginVersion": "11.6.1",
      "targets": [
        {
          "datasource": {
            "type": "loki",
            "uid": "loki_uid"
          },
          "direction": "backward",
          "editorMode": "code",
          "expr": "sum(rate({job=\"apache\"} |= \"404\" [$__interval]) + rate({job=\"apache\"} |= \"403\" [$__interval])) by (client_ip)",
          "queryType": "range",
          "refId": "F"
        }
      ],
      "title": "Gráfico de Barras - Patrones de Acceso Sospechosos en Apache",
      "type": "barchart"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "loki_uid"
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
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 24
      },
      "id": 7,
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
        "showHeader": true
      },
      "pluginVersion": "11.6.1",
      "targets": [
        {
          "datasource": {
            "type": "loki",
            "uid": "loki_uid"
          },
          "expr": "topk(10, sum by (query) (count_over_time({job=\"mysql\"} |= \"SELECT\" [1h])))",
          "queryType": "instant",
          "refId": "G"
        }
      ],
      "title": "Tabla - Consultas SQL Más Frecuentes en MySQL",
      "type": "table"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "loki_uid"
      },
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
        "x": 12,
        "y": 24
      },
      "id": 8,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
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
          "datasource": {
            "type": "loki",
            "uid": "loki_uid"
          },
          "expr": "avg_over_time({job=\"mysql\"} |~ \"query time: [0-9.]+\" | unwrap duration [$__interval])",
          "legendFormat": "Latencia Promedio",
          "queryType": "range",
          "refId": "H"
        }
      ],
      "title": "Gráfico de Líneas - Latencia Promedio de Consultas en MySQL",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "loki_uid"
      },
      "fieldConfig": {
        "defaults": {
          "custom": {
            "align": "left",
            "cellOptions": {
              "type": "auto"
            },
            "filterable": true,
            "inspect": false
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": []
          }
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "Line"
            },
            "properties": [
              {
                "id": "custom.width",
                "value": 600
              },
              {
                "id": "displayName",
                "value": "Query and Client IP"
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Timestamp"
            },
            "properties": [
              {
                "id": "custom.width",
                "value": 319
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 10,
        "w": 24,
        "x": 0,
        "y": 32
      },
      "id": 9,
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
        "sortBy": [
          {
            "desc": true,
            "displayName": "tsNs"
          }
        ]
      },
      "pluginVersion": "11.6.1",
      "targets": [
        {
          "direction": "backward",
          "editorMode": "code",
          "expr": "{job=\"mysql\"} |~ \"SELECT|INSERT|UPDATE|DELETE\" | regexp `(?P<query>(SELECT|INSERT|UPDATE|DELETE)\\s+[^;]+)` | regexp `client_ip:\\s*(?P<client_ip>\\S+)` | line_format \"{{.query}} from {{.client_ip}}\"",
          "queryType": "range",
          "refId": "A"
        }
      ],
      "title": "SQL Queries Executed with Client IPs",
      "transformations": [
        {
          "id": "organize",
          "options": {
            "excludeByName": {
              "Value": true
            },
            "includeByName": {},
            "indexByName": {
              "Line": 1,
              "Time": 0
            },
            "renameByName": {
              "Line": "Query and Client IP",
              "Time": "Timestamp",
              "id": ""
            }
          }
        }
      ],
      "type": "table"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "loki_uid"
      },
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
        "y": 42
      },
      "id": 10,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
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
          "datasource": {
            "type": "loki",
            "uid": "loki_uid"
          },
          "expr": "count_over_time({job=\"mysql\"} |= \"' OR '1'='1\" [$__interval])",
          "legendFormat": "Injection ' OR '1'='1",
          "queryType": "range",
          "refId": "A"
        },
        {
          "datasource": {
            "type": "loki",
            "uid": "loki_uid"
          },
          "expr": "count_over_time({job=\"mysql\"} |= \"UNION SELECT\" [$__interval])",
          "legendFormat": "Injection UNION SELECT",
          "queryType": "range",
          "refId": "B"
        },
        {
          "datasource": {
            "type": "loki",
            "uid": "loki_uid"
          },
          "expr": "count_over_time({job=\"mysql\"} |= \"--\" [$__interval])",
          "legendFormat": "Injection Comentario --",
          "queryType": "range",
          "refId": "C"
        }
      ],
      "title": "Detección de Intentos de Inyección SQL",
      "type": "timeseries"
    }
  ],
  "preload": false,
  "refresh": "5s",
  "schemaVersion": 41,
  "tags": [],
  "templating": {
    "list": []
  },
  "time": {
    "from": "now-6h",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "browser",
  "title": "Dashboard Personalizado Avanzado",
  "uid": "celzi2os67fggc",
  "version": 8
}
EOF

echo "Datasource y dashboard listos."
