#!/usr/bin/env bash
# 01_setup.sh — Crear estructura de carpetas y permisos

set -e
BASE_DIR="honeypot"

echo "==> Creando directorios en $BASE_DIR..."
mkdir -p $BASE_DIR/{cowrie,proftpd,apache,web,volumenes/{apache_logs,mysql_data,mysql_log,ftp_logs},grafana/{data,provisioning/datasources},config}

echo "==> Ajustando permisos de grafana/data..."
sudo chown -R 472:472 $BASE_DIR/grafana/data

echo "Estructura inicial preparada."
