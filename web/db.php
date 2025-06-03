<?php
// db.php — conexión con MySQL
function getDB() {
    $host = 'mysql';       // nombre del contenedor en la red Docker
    $dbname = 'bbdd';         // como definiste en MYSQL_DATABASE
    $user = 'usuario';        // como definiste en MYSQL_USER
    $pass = 'passwd';         // como definiste en MYSQL_PASSWORD
    $charset = 'utf8mb4';

    $dsn = "mysql:host=$host;dbname=$dbname;charset=$charset";
    $options = [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
    ];

    return new PDO($dsn, $user, $pass, $options);
}
?>
