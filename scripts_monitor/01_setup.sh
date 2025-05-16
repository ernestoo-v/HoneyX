#!/usr/bin/env bash
# 01_setup.sh — Crear estructura de carpetas y permisos

set -e
BASE_DIR="honeypot"

# Crear estructura de carpetas
mkdir -p $BASE_DIR/{grafana/data,grafana/provisioning/datasources,config}
echo "Creando directorios necesarios..."

# Asignar permisos adecuados para Grafana
sudo chown -R 472:472 $BASE_DIR/grafana/data
echo "Asignando permisos a grafana/data..."

echo "Estructura inicial preparada."
