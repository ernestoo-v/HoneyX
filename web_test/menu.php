<?php
require_once __DIR__ . '/config.php';
$stmt = $pdo->query("SELECT id, nombre, ingredientes FROM platos");
$platos = $stmt->fetchAll();
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Menú</title>
  <link rel="stylesheet" href="assets/css/global.css">
  <link rel="stylesheet" href="assets/css/menu_style.css">
</head>
<body>
  <header>
    <h1>Menú</h1>
    <nav>
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
  <footer>&copy;<?= date('Y') ?></footer>
</body>
</html>
