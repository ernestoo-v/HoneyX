<?php
require_once __DIR__ . '/config.php';

if (file_exists(DB_FILE)) {
    echo "La base de datos ya existe.\n";
    exit;
}

$sql = file_get_contents(__DIR__ . '/schema_sqlite.sql');
$pdo->exec($sql);
echo "Base de datos creada y tablas listas.\n";
?>
