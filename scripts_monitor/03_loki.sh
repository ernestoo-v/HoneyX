#!/usr/bin/env bash
# 03_loki.sh — Loki

set -e
CONF="honeypot/config"

echo "==> Loki config..."
cat > $CONF/loki-config.yaml << 'EOF'
auth_enabled: false          # ⇦ seguirá sin login, pero podrás activarlo más adelante

server:
  http_listen_port: 3100
  grpc_listen_port: 9096
  log_level: info            # Añadido: verbosidad básica para debug

#────────────── INGESTER ──────────────
ingester:
  wal:                       # ⇦ habilita Write-Ahead-Log → nunca pierdes buffers
    enabled: true
    dir: /var/loki/wal
  lifecycler:
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1
  chunk_idle_period: 5m      # descarga chunks inactivos antes
  max_chunk_age: 1h

#────────────── GLOBAL ────────────────
common:
  instance_addr: 0.0.0.0     # dentro del contenedor es la forma correcta
  path_prefix: /var/loki      # ya no /tmp → volumen persistente
  storage:
    filesystem:
      chunks_directory: /var/loki/chunks
      rules_directory:  /var/loki/rules
  ring:
    kvstore:
      store: inmemory

#────────────── ESQUEMA / ÍNDICES ─────
schema_config:
  configs:
    - from: 2020-10-24
      store: boltdb-shipper
      object_store: filesystem
      schema: v12            # v12 trae etiquetas ilimitadas y mejor compactor
      index:
        prefix: index_
        period: 24h

#────────────── COMPACTOR + RETENCIÓN ─
compactor:
  working_directory: /var/loki/compactor
  shared_store: filesystem
  retention_enabled: true

limits_config:
  # borra todo a los 30 d excepto honeypot (ver abajo)
  retention_period: 30d
  retention_stream:
    # guarda tu laboratorio 6 meses
    - selector: '{env="honeypot"}'
      priority: 1
      period: 180d

#────────────── QUERY FRONTEND ────────
query_scheduler:
  max_outstanding_requests_per_tenant: 4096
frontend:
  max_outstanding_per_tenant: 4096

#────────────── RULER / ALERTAS ───────
ruler:
  alertmanager_url: http://alertmanager:9093   # container-name, no localhost
  storage:
    type: local
    local:
      directory: /var/loki/rules

analytics:
  reporting_enabled: false

EOF

echo "Loki configurado."
