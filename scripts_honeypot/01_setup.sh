#!/usr/bin/env bash
# 01_setup.sh — Crear estructura de carpetas y permisos

set -e
BASE_DIR="honeypot"

echo "==> Creando directorios en $BASE_DIR..."
mkdir -p \ 
  "$BASE_DIR/ftp" \ 
  "$BASE_DIR/web" \ 
  "$BASE_DIR/volumenes/apache_logs" \ 
  "$BASE_DIR/volumenes/mysql_log" \ 
  "$BASE_DIR/volumenes/ftp_logs" \ 
  "$BASE_DIR/volumenes/fakessh_logs" \ 
  "$BASE_DIR/volumenes/mysql_data" \ 
  "$BASE_DIR/volumenes/config" \ 
  "$BASE_DIR/config"

echo "Estructura inicial preparada."
