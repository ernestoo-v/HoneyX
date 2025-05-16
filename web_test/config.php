<?php
// Ruta absoluta al fichero .db
$sqlitePath = __DIR__ . '/reservas.db';

if (file_exists($sqlitePath)) {
    // Conexión SQLite
    $pdo = new PDO("sqlite:" . $sqlitePath);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} else {
    // (Opcional) Aquí podrías lanzar un error si no existe la DB
    die("No existe la base de datos SQLite en $sqlitePath");
}
