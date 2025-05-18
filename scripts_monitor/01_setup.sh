#!/usr/bin/env bash
set -e
BASE_DIR="honeypot"

echo "Creando directorios necesarios…"
# provisioning → solo YAML (datasources + providers)
mkdir -p $BASE_DIR/grafana/provisioning/{datasources,dashboards}

# NUEVO: carpeta para los dashboards JSON editables
mkdir -p $BASE_DIR/grafana/dashboards     # ← aquí irán los .json

# Loki persistente
mkdir -p $BASE_DIR/loki/{chunks,rules,wal,compactor}

echo "Asignando permisos…"
sudo chown -R 472:472 $BASE_DIR/grafana/{data,dashboards}      # Grafana UID 472
sudo chown -R 10001:10001 $BASE_DIR/loki                       # Loki UID 10001
echo "Estructura inicial preparada."
