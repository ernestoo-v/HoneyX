<?php
require_once 'inc/db.php';   // $conn = mysqli_connect(...)
session_start();

if (!isset($_POST['username'], $_POST['password'])) {
    header('Location: login.php'); exit;
}

$user = $_POST['username'];
$pass = $_POST['password'];

/*  Consulta INSEGURA  — bypass con:
    usuario: admin' OR '1'='1
    password: lo_que_sea
*/
$sql = "SELECT id, username
        FROM users
        WHERE username = '$user' AND password = '$pass'";

$result = mysqli_query($conn, $sql); // ⚠️ Vulnerable a SQLi (php.net) 

if ($result && mysqli_num_rows($result) === 1) {
    $_SESSION['user'] = mysqli_fetch_assoc($result)['username'];
    header('Location: dashboard.php');
} else {
    header('Location: login.php?err=1');
}
