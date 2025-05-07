#!/usr/bin/env bash
# 06_mysql.sh — Configuración de MySQL

set -e
CONF_DIR="honeypot/config"
VOLUME="honeypot/volumenes/mysql_data"

echo "==> Generando my.cnf..."
cat > $CONF_DIR/my.cnf << 'EOF'
[... contenido de tu my.cnf ...]
EOF

echo "MySQL configurado (volumen en $VOLUME)."
