#!/usr/bin/env bash
set -e

BASE_DIR="honeypot"

echo "Creando directorios necesarios…"

# ── GRAFANA ────────────────────────────────────────────────
mkdir -p \
  "$BASE_DIR/grafana/data" \
  "$BASE_DIR/grafana/provisioning/datasources" \
  "$BASE_DIR/grafana/provisioning/dashboards" \
  "$BASE_DIR/grafana/dashboards"

# ── LOKI ───────────────────────────────────────────────────
mkdir -p \
  "$BASE_DIR/loki/chunks" \
  "$BASE_DIR/loki/rules" \
  "$BASE_DIR/loki/wal" \
  "$BASE_DIR/loki/compactor"

# ── CONFIG (ficheros generados por scripts) ───────────────
mkdir -p "$BASE_DIR/config"

echo "Asignando permisos…"
sudo chown -R 472:472 "$BASE_DIR/grafana"          # Grafana (UID 472)
sudo chown -R 10001:10001 "$BASE_DIR/loki"         # Loki (UID 10001)

echo "Estructura inicial preparada."