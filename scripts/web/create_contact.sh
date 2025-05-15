# scripts/05_apache/create_contact.sh
#!/usr/bin/env bash
set -euo pipefail
WEB_DIR="honeypot/web"
echo "==> Generando contact.php..."
cat > "$WEB_DIR/contact.php" << 'EOF'
<?php
require_once __DIR__ . '/config.php';
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Contacto</title>
  <link rel="stylesheet" href="assets/css/global.css">
  <link rel="stylesheet" href="assets/css/contact_style.css">
</head>
<body>
  <header>
    <h1>Contacto</h1>
    <nav>
      <a href="index.php">Inicio</a>
      <a href="menu.php">Menú</a>
      <a href="reservations.php">Reservas</a>
      <a href="contact.php" class="active">Contacto</a>
    </nav>
  </header>
  <main>
    <h2>Mensaje</h2>
    <form class="contact-form">
      <label>Nombre:<input required name="name"></label>
      <label>Email:<input type="email" required name="email"></label>
      <label>Mensaje:<textarea required name="message" rows="5"></textarea></label>
      <button type="submit">Enviar mensaje</button>
    </form>
    <div id="formResult"></div>
  </main>
  <footer>&copy;<?= date('Y') ?></footer>
  <script src="assets/js/script.js"></script>
</body>
</html>

EOF