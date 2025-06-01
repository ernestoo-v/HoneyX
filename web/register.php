<?php
session_start();
require_once 'db.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $db = getDB();
    $username = $_POST['username'];
    $email = $_POST['email'];
    $password = $_POST['password'];

    // Inserción vulnerable a inyección SQL (intencionado para el honeypot)
    $query = "INSERT INTO usuarios (username, email, password, rol) VALUES ('$username', '$email', '$password', 'cliente')";

    try {
        $db->exec($query);
        $_SESSION['username'] = $username;
        $_SESSION['rol'] = 'cliente';
        header('Location: panel.php');
        exit();
    } catch (Exception $e) {
        $error = "Error al registrar: " . $e->getMessage();
    }
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registro de Usuario</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/login.css">
</head>
<body>
    <div class="container">
        <h2>Registrarse</h2>
        <?php if (isset($error)): ?>
            <p class="error"><?= $error ?></p>
        <?php endif; ?>
        <form method="POST">
            <label for="username">Nombre de Usuario</label>
            <input type="text" id="username" name="username" required>

            <label for="email">Correo Electrónico</label>
            <input type="email" id="email" name="email" required>

            <label for="password">Contraseña</label>
            <input type="password" id="password" name="password" required>

            <button type="submit">Registrarse</button>
        </form>
             <!-- Botón para ir a iniciar sesion -->
    <div class="mt-3 text-center">
        <p>¿Ya tienes cuenta?</p>
        <a href="login.php" class="btn btn-outline-primary">Iniciar sesión</a>
    </div>
    </div>
</body>
</html>
