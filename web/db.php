<?php
// db.php
function getDB() {
    $db = new PDO('sqlite:db/honeypot_restaurante.db');
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    return $db;
}
?>
