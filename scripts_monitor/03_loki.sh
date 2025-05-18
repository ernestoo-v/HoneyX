#!/usr/bin/env bash
# 03_loki.sh — Loki

set -e
CONF="honeypot/config"

echo "==> Loki config..."
cat > $CONF/loki-config.yaml << 'EOF'
# ─────────── AUTENTICACIÓN ───────────
auth_enabled: false                 # Loki sin login (cámbialo cuando lo expongas)

# ─────────── SERVIDOR ────────────────
server:
  http_listen_port: 3100
  grpc_listen_port: 9096
  log_level: info                    # Verbosidad básica para debug

# ─────────── INGESTER ────────────────
ingester:
  wal:                               # Write-Ahead-Log → evita pérdida de buffers
    enabled: true
    dir: /var/loki/wal
  lifecycler:
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1
  chunk_idle_period: 5m              # Descarga chunks inactivos con rapidez
  max_chunk_age: 1h

# ─────────── PARÁMETROS COMUNES ──────
common:
  instance_addr: 0.0.0.0             # Válido dentro del contenedor
  path_prefix: /var/loki             # Volumen persistente
  storage:
    filesystem:
      chunks_directory: /var/loki/chunks
      rules_directory:  /var/loki/rules
  ring:
    kvstore:
      store: inmemory

# ─────────── ESQUEMA / ÍNDICES ───────
schema_config:
  configs:
    - from: 2020-10-24
      store: boltdb-shipper
      object_store: filesystem
      schema: v12                    # v12 → etiquetas ilimitadas y compactor mejorado
      index:
        prefix: index_
        period: 24h

# ─────────── COMPACTOR + RETENCIÓN ───
compactor:
  working_directory: /var/loki/compactor
  shared_store: filesystem
  retention_enabled: true

limits_config:
  retention_period: 30d              # Retención global
  retention_stream:                  # Retención específica por selector
    - selector: '{env="honeypot"}'
      priority: 1                    # Se aplica primero
      period: 180d                   # 6 meses para flujos de tu laboratorio

# ─────────── QUERY FRONTEND ──────────
query_scheduler:
  max_outstanding_requests_per_tenant: 4096

frontend:
  max_outstanding_per_tenant: 4096

query_range:
  results_cache:
    cache:
      embedded_cache:
        enabled: true
        max_size_mb: 100

# ─────────── RULER / ALERTAS ─────────
ruler:
  # Descomenta la línea siguiente si incorporas Alertmanager en el stack:
  # alertmanager_url: http://alertmanager:9093
  storage:
    type: local
    local:
      directory: /var/loki/rules

# ─────────── TELEMETRÍA ──────────────
analytics:
  reporting_enabled: false           # Sin estadísticas a Grafana Labs

EOF

echo "Loki configurado."
