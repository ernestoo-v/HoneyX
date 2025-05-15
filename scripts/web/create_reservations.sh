# scripts/05_apache/create_reservas.sh
#!/usr/bin/env bash
set -euo pipefail

WEB_DIR="honeypot/web"
echo "==> Generando reservas.php..."
cat > "$WEB_DIR/reservas.php" << 'EOF'
<?php
require_once __DIR__ . '/config.php';  // Aquí se define $conn = new mysqli(...)
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Reservas</title>
  <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
  <header>
    <h1>Reservas</h1>
    <nav>
      <a href="index.php">Inicio</a>
      <a href="menu.php">Menú</a>
      <a href="reservas.php">Reservas</a>
      <a href="contact.php">Contacto</a>
    </nav>
  </header>
  <main>
    <h2>Haz tu reserva</h2>
    <?php
      if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        // Vulnerabilidad: uso directo de $_POST sin sanitización ni prepared statements
        $nombre  = $_POST['nombre'];
        $fecha   = $_POST['fecha'];
        $hora    = $_POST['hora'];
        $personas= $_POST['personas'];

        $sql = "INSERT INTO reservas (nombre, fecha, hora, personas) VALUES (
          '$nombre',
          '$fecha',
          '$hora',
          '$personas'
        )";

        if ($conn->query($sql) === TRUE) {
          echo "<p>Reserva hecha para <strong>$nombre</strong> el <strong>$fecha</strong> a las <strong>$hora</strong> para <strong>$personas</strong> personas.</p>";
        } else {
          echo "<p>Error: " . $conn->error . "</p>";
        }
      }
    ?>
    <form action="reservas.php" method="POST">
      <label for="nombre">Nombre:</label><br>
      <input type="text" id="nombre" name="nombre" required><br><br>

      <label for="fecha">Fecha (YYYY-MM-DD):</label><br>
      <input type="text" id="fecha" name="fecha" required><br><br>

      <label for="hora">Hora (HH:MM):</label><br>
      <input type="text" id="hora" name="hora" required><br><br>

      <label for="personas">Número de personas:</label><br>
      <input type="number" id="personas" name="personas" required><br><br>

      <button type="submit">Reservar</button>
    </form>
  </main>
  <footer>&copy;<?= date('Y') ?></footer>
  <script src="assets/js/script.js"></script>
</body>
</html>
EOF

echo "reservas.php generado."
