# scripts/05_apache/create_menu.sh
#!/usr/bin/env bash
set -euo pipefail
WEB_DIR="honeypot/web"
echo "==> Generando menu.php..."
cat > "$WEB_DIR/menu.php" << 'EOF'
<?php
require_once __DIR__ . '/config.php';
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Menú</title>
  <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
  <header>
    <h1>Menú</h1>
    <nav>
      <a href="index.php">Inicio</a>
      <a href="menu.php">Menú</a>
      <a href="contact.php">Contacto</a>
    </nav>
  </header>
  <main>
    <h2>Platos</h2>
    <ul>
      <?php
        $platos = [
          ['nombre' => 'Ensalada', 'precio' => '8€'],
          ['nombre' => 'Paella',  'precio' => '12€'],
          ['nombre' => 'Tarta',   'precio' => '5€']
        ];
        foreach ($platos as $p) {
          echo "<li>" . htmlspecialchars($p['nombre']) . " - <strong>" . htmlspecialchars($p['precio']) . "</strong></li>";
        }
      ?>
    </ul>
  </main>
  <footer>&copy;<?= date('Y') ?></footer>
  <script src="assets/js/script.js"></script>
</body>
</html>
EOF