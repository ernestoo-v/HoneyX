#!/usr/bin/env bash
# Crea un index.php de ejemplo para Apache+PHP

set -e

# Servicio web Apache+PHP
echo "Generando servicio web Apache+PHP..."
# Crear directorio web si no existe
mkdir -p $dir/web

# index.php: incluye config.php y muestra phpinfo
cat > $dir/web/index.php << 'EOF'
<?php
// Carga la configuración de conexión a MySQL
require_once __DIR__ . '/config.php';

// Muestra información de PHP
phpinfo();
?>
EOF

# config.php: parámetros de conexión a MySQL desde variables de entorno
cat > $dir/web/config.php << 'EOF'
<?php
// Obtiene credenciales de MySQL de variables de entorno
\$host = getenv('DB_HOST') ?: 'mi_mysql';
\$db   = getenv('DB_NAME') ?: 'bbdd';
\$user = getenv('DB_USER') ?: 'usuario';
\$pass = getenv('DB_PASS') ?: 'passwd';

// DSN para PDO
\$dsn = "mysql:host={\$host};dbname={\$db};charset=utf8mb4";

try {
    \$pdo = new PDO(\$dsn, \$user, \$pass, [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
    echo \"Conectado a MySQL: {\$db} en {\$host}\" . PHP_EOL;
} catch (PDOException \$e) {
    echo \"Error de conexión a MySQL: \" . \$e->getMessage() . PHP_EOL;
    exit(1);
}
?>
EOF

echo "Archivos web/index.php y web/config.php generados."


# Configuración de MySQL (my.cnf)
echo "Generando my.cnf para MySQL..."
cat > $dir/config/my.cnf << 'EOF'
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/5.7/en/server-configuration-defaults.html

[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M
skip-host-cache
skip-name-resolve
datadir=/var/lib/mysql
socket=/var/run/mysqld/mysqld.sock
secure-file-priv=/var/lib/mysql-files
user=mysql

# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

log-error=/var/log/mysql/error.log
general_log = 1
general_log_file = /var/log/mysql/general.log
pid-file=/var/run/mysqld/mysqld.pid
[client]
socket=/var/run/mysqld/mysqld.sock

!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mysql.conf.d/
EOF

echo "my.cnf generado para MySQL."
