#!/usr/bin/env bash
# 01_setup.sh — Crear estructura de carpetas y permisos

set -e
BASE_DIR="honeypot"

echo "Creando directorios necesarios…"
mkdir -p $BASE_DIR/{grafana/{data,provisioning/{datasources,dashboards}},config}

# ► NUEVO: carpeta persistente para Loki
mkdir -p $BASE_DIR/loki/{chunks,rules,wal,compactor}

# Permisos
echo "Asignando permisos…"
# grafana corre como UID 472
sudo chown -R 472:472 $BASE_DIR/grafana/data
# loki corre como UID 10001
sudo chown -R 10001:10001 $BASE_DIR/loki

echo "Estructura inicial preparada."
