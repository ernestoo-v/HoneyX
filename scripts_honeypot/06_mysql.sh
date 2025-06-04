#!/usr/bin/env bash
# 06_mysql.sh — Configuración de MySQL

set -e
CONF_DIR="honeypot/config"
VOLUME="honeypot/volumenes/mysql_data"

echo "==> Generando my.cnf..."
cat > $CONF_DIR/my.cnf << 'EOF'
[mysqld]
skip-host-cache
skip-name-resolve
datadir=/var/lib/mysql
socket=/var/run/mysqld/mysqld.sock
secure-file-priv=/var/lib/mysql-files
user=mysql

# Codificación UTF-8 por defecto
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

# Seguridad
symbolic-links=0

# Logs
log-error=/var/log/mysql/error.log
general_log = 1
general_log_file = /var/log/mysql/general.log
pid-file=/var/run/mysqld/mysqld.pid

[client]
socket=/var/run/mysqld/mysqld.sock
default-character-set = utf8mb4

!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mysql.conf.d/

EOF

echo "MySQL configurado (volumen en $VOLUME)."
