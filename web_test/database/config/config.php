<?php
// Ruta al fichero.  Puedes moverlo fuera de web_test si prefieres.
define('DB_FILE', __DIR__ . '/restaurante.db');

$pdo = new PDO('sqlite:' . DB_FILE, null, null, [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
]);

// Imprescindible en SQLite para que funcionen las FK
$pdo->exec('PRAGMA foreign_keys = ON;');
?>
