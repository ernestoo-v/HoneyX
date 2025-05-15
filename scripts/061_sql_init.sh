#!/usr/bin/env bash
set -euo pipefail

# Directorio base de tu proyecto Docker
BASE_DIR="honeypot"

# 1. Crear carpeta sql-init si no existe
SQL_INIT_DIR="$BASE_DIR/sql-init"
echo "==> Creando directorio $SQL_INIT_DIR..."
mkdir -p "$SQL_INIT_DIR"                   # no da error si ya existe :contentReference[oaicite:5]{index=5}

# 2. Generar create_tables.sql con la definición de la tabla reservas
INIT_SQL="$SQL_INIT_DIR/create_tables.sql"
echo "==> Generando $INIT_SQL..."
cat > "$INIT_SQL" << 'EOF'
-- Script de inicialización de tablas para honeypot
CREATE TABLE IF NOT EXISTS reservas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  fecha DATE,
  hora TIME,
  personas INT
);
EOF
echo "==> Fichero $INIT_SQL generado."
