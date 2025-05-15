# scripts/05_apache/create_reservas.sh
#!/usr/bin/env bash
set -euo pipefail

WEB_DIR="honeypot/web"
echo "==> Generando reservas.php..."
cat > "$WEB_DIR/reservas.php" << 'EOF'
<?php
require_once __DIR__ . '/config.php';
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Reservas</title>
  <link rel="stylesheet" href="assets/css/global.css">
  <link rel="stylesheet" href="assets/css/reservations_style.css">
</head>
<body>
  <header>
    <h1>Reservas</h1>
    <nav>
      <a href="index.php">Inicio</a>
      <a href="menu.php">Menú</a>
      <a href="reservations.php" class="active">Reservas</a>
      <a href="contact.php">Contacto</a>
    </nav>
  </header>
  <main>
    <h2>Haz tu reserva</h2>
    <?php
      if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $nombre   = $_POST['nombre'];
        $fecha    = $_POST['fecha'];
        $hora     = $_POST['hora'];
        $personas = $_POST['personas'];
        $sql = "INSERT INTO reservas (nombre, fecha, hora, personas) VALUES (
          '$nombre', '$fecha', '$hora', '$personas'
        )";
        try {
          $pdo->exec($sql);
          echo '<p class="reservation-message">Reserva hecha para <strong>' 
             . htmlspecialchars($nombre) . '</strong> el <strong>' 
             . htmlspecialchars($fecha) . '</strong> a las <strong>' 
             . htmlspecialchars($hora) . '</strong> para <strong>' 
             . htmlspecialchars($personas) . '</strong> personas.</p>';
        } catch (PDOException $e) {
          echo '<p class="reservation-message">Error: ' . htmlspecialchars($e->getMessage()) . '</p>';
        }
      }
    ?>
    <form class="reservations-form" action="reservations.php" method="POST">
      <label for="nombre">Nombre:<input type="text" id="nombre" name="nombre" required></label>
      <label for="fecha">Fecha (YYYY-MM-DD):<input type="text" id="fecha" name="fecha" required></label>
      <label for="hora">Hora (HH:MM):<input type="text" id="hora" name="hora" required></label>
      <label for="personas">Número de personas:<input type="number" id="personas" name="personas" required></label>
      <button type="submit">Enviar reserva</button>
    </form>
  </main>
  <footer>&copy;<?= date('Y') ?></footer>
</body>
</html>

EOF

echo "reservas.php generado."
