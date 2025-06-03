#!/usr/bin/env bash
# 01_setup.sh — Crear estructura de carpetas y permisos

set -e
BASE_DIR="honeypot"

echo "==> Creando directorios en $BASE_DIR..."
mkdir -p $BASE_DIR/{ftp,web,volumenes/apache_logs,volumenes/mysql_log,volumenes/ftp_logs,volumenes/config}

echo "Estructura inicial preparada."
