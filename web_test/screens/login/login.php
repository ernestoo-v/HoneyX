<?php
session_start();
if (isset($_SESSION['user'])) { header('Location: dashboard.php'); exit; }
include_once 'inc/header.php';
?>
<h2>Acceso al sistema</h2>

<?php if (isset($_GET['err'])): ?>
  <p class="alert">Usuario o contraseña incorrectos</p>
<?php endif; ?>

<form action="auth.php" method="post" class="login-box" autocomplete="off">
  <label>Usuario
    <input type="text" name="username" required>
  </label>
  <label>Contraseña
    <input type="password" name="password" required>
  </label>
  <button type="submit">Entrar</button>
</form>

<?php include_once 'inc/footer.php'; ?>
