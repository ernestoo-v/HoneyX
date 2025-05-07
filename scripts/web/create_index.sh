# scripts/05_apache/create_index.sh
#!/usr/bin/env bash
set -euo pipefail
WEB_DIR="honeypot/web"
echo "==> Generando index.php..."
cat > "$WEB_DIR/index.php" << 'EOF'
<?php
require_once __DIR__ . '/config.php';
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Restaurante Ejemplo - Inicio</title>
  <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
  <header>
    <h1>Bienvenidos</h1>
    <nav>
      <a href="index.php">Inicio</a>
      <a href="menu.php">Menú</a>
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
  <script src="assets/js/script.js"></script>
</body>
</html>
EOF