<?php
require_once __DIR__ . '/config.php';
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Restaurante Ejemplo - Inicio</title>
  <link rel="stylesheet" href="assets/css/global.css">
  <link rel="stylesheet" href="assets/css/index_style.css">
</head>
<body>
  <header>
    <h1>Bienvenidos</h1>
    <nav>
      <a href="index.php" class="active">Inicio</a>
      <a href="menu.php">Menú</a>
      <a href="reservations.php">Reservas</a>
      <a href="contact.php">Contacto</a>
    </nav>
  </header>
  <main>
    <h2>Sobre Nosotros</h2>
    <?php
      $stmt = $pdo->query("SELECT 'Historia del restaurante...' AS historia");
      echo '<blockquote>' . htmlspecialchars($stmt->fetch()['historia']) . '</blockquote>';
    ?>
  </main>
  <footer>&copy;<?= date('Y') ?></footer>
</body>
</html>
