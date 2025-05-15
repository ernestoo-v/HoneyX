<?php
require_once __DIR__ . '/config.php';

// Obtenemos todos los platos
$stmt = $pdo->query("SELECT nombre, ingredientes FROM platos");
$platos = $stmt->fetchAll();
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Menú</title>
  <link rel="stylesheet" href="assets/css/menu_style.css">
  <link rel="stylesheet" href="assets/css/style.css">

</head>
<body>
  <header class="site-header">
    <h1 class="site-title">Nuestro Menú</h1>
    <nav class="nav-bar">
      <a href="index.php">Inicio</a>
      <a href="menu.php" class="active">Menú</a>
      <a href="reservations.php">Reservas</a>
      <a href="contact.php">Contacto</a>
    </nav>
  </header>

  <main class="menu-container">
    <?php if (empty($platos)): ?>
      <p>No hay platos disponibles.</p>
    <?php else: ?>
      <div class="grid">
        <?php foreach ($platos as $p): 
          // Convertir cadena de ingredientes en array
          $ings = array_map('trim', explode(',', $p['ingredientes']));
        ?>
          <a href="platodetail.php?id=<?= $p['id'] ?>" class="card">
            <img src="assets/img/placeholder.jpg" alt="<?= htmlspecialchars($p['nombre']) ?>">
            <div class="card-content">
              <h2 class="card-title"><?= htmlspecialchars($p['nombre']) ?></h2>
              <ul class="card-ingredients">
                <?php foreach ($ings as $ing): ?>
                  <li><?= htmlspecialchars($ing) ?></li>
                <?php endforeach; ?>
              </ul>
            </div>
            <div class="card-action">Ver más</div>
          </a>
        <?php endforeach; ?>
      </div>
    <?php endif; ?>
  </main>

  <footer class="site-footer">&copy;<?= date('Y') ?> Restaurante Ejemplo</footer>
  <script src="assets/js/script.js"></script>
</body>
</html>
