#!/usr/bin/env bash
# 01_setup.sh — Crear estructura de carpetas y permisos

set -e
BASE_DIR="honeypot"

echo "Creando directorios necesarios…"
mkdir -p $BASE_DIR/{grafana/{data,provisioning/{datasources,dashboards}},config}

# Permisos para el usuario UID 472 (grafana dentro del contenedor)
echo "Asignando permisos a grafana/data y grafana/dashboards…"
sudo chown -R 472:472 $BASE_DIR/grafana/{data,dashboards}

echo "Estructura inicial preparada."
