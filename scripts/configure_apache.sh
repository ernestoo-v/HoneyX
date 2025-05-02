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
