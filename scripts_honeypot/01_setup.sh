#!/usr/bin/env bash
# 01_setup.sh — Crear estructura de carpetas y permisos

set -e
BASE_DIR="honeypot"

echo "==> Creando directorios en $BASE_DIR..."
mkdir -p $BASE_DIR/{cowrie,mi_ftp,web,volumenes/apache_logs,volumenes/mysql_log,volumenes/ftp_logs,volumenes/cowrie_logs,config}

echo "Estructura inicial preparada."
