<?php
session_start();
require_once 'db.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $db = getDB();
    $username = $_POST['username'];
    $password = $_POST['password'];

    $ip = $_SERVER['REMOTE_ADDR'];

    $query = "SELECT * FROM usuarios WHERE username = '$username' AND password = '$password'";

    error_log("[HONEYX] IP=$ip - Intento de login con usuario='$username' y contraseña='$password' - Query=$query");

    $result = $db->query($query);
    $user = $result->fetch(PDO::FETCH_ASSOC);

    if ($user) {
        $_SESSION['username'] = $user['username'];
        $_SESSION['rol'] = $user['rol'];
        header('Location: panel.php');
        exit();
    } else {
        $error = "Usuario o contraseña incorrectos.";
    }
}
?>


<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Iniciar Sesión</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/login.css">

</head>
<body>


<div class="container">
    <h2>Iniciar Sesión</h2>
    <?php if (isset($error)): ?>
        <p class="error"><?= $error ?></p>
    <?php endif; ?>
    <form method="POST">
        <label for="username">Usuario</label>
        <input type="text" id="username" name="username" required>

        <label for="password">Contraseña</label>
        <input type="password" id="password" name="password" required>

        <button type="submit">Entrar</button>
    </form>

    <!-- Botón para ir a registrarse -->
    <div class="mt-3 text-center">
        <p>¿No tienes cuenta?</p>
        <a href="register.php" class="btn btn-outline-primary">Registrarse</a>
    </div>
</div>

</body>
</html>
