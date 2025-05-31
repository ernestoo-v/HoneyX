<?php
require_once __DIR__.'../database/config/config.php';

/* ── datos dinámicos ─────────────────────────────────────────── */
$special = $pdo->query(
  "SELECT i.nombre,i.descripcion,i.precio,i.imagen_url
     FROM especiales e
     JOIN menu_items i ON i.id=e.menu_item_id
    WHERE e.fecha = DATE('now','localtime') LIMIT 1"
)->fetch();

$destacados = $pdo->query(
  "SELECT nombre,descripcion,precio,imagen_url
     FROM menu_items
 ORDER BY precio ASC
    LIMIT 3"
)->fetchAll();

/* ── cabecera/nav comunes ────────────────────────────────────── */
$title = 'Restaurante Ficticio';
require_once __DIR__.'/partials/header.php';
?>

<!-- HERO ------------------------------------------------------- -->
<header class="bg-dark text-white py-5"
        style="background:url('img/hero.jpg') center/cover no-repeat;">
  <div class="container text-center">
    <h1 class="display-4 fw-bold">Sabores auténticos · Experiencia inolvidable</h1>
    <p class="lead">Ven a disfrutar de nuestra cocina mediterránea y ambiente acogedor.</p>
    <a href="reservas.php" class="btn btn-primary btn-lg mt-3">
      <i class="fa-solid fa-calendar-check me-2"></i>Reservar ya
    </a>
  </div>
</header>

<!-- ESPECIAL DEL DÍA ------------------------------------------ -->
<?php if ($special): ?>
<section id="especial" class="py-5">
  <div class="container">
    <h2 class="text-center mb-4">
      <i class="fa-solid fa-star me-2 text-warning"></i>Especial del día
    </h2>

    <div class="row justify-content-center">
      <div class="col-md-8 col-lg-6">
        <div class="card shadow">
          <?php if ($special['imagen_url']): ?>
            <img src="<?= htmlspecialchars($special['imagen_url']) ?>" class="card-img-top" alt="">
          <?php endif; ?>
          <div class="card-body text-center">
            <h3 class="card-title"><?= htmlspecialchars($special['nombre']) ?></h3>
            <p class="card-text"><?= htmlspecialchars($special['descripcion']) ?></p>
            <span class="badge bg-success fs-5">
              €<?= number_format($special['precio'],2,',','.') ?>
            </span>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>
<?php endif; ?>

<!-- DESTACADOS ------------------------------------------------- -->
<section id="destacados" class="py-5 bg-light">
  <div class="container">
    <h2 class="text-center mb-4">Descubre el menú</h2>
    <div class="row g-4">
      <?php foreach ($destacados as $d): ?>
      <div class="col-md-4">
        <div class="card h-100">
          <?php if ($d['imagen_url']): ?>
            <img src="<?= htmlspecialchars($d['imagen_url']) ?>" class="card-img-top" alt="">
          <?php endif; ?>
          <div class="card-body d-flex flex-column">
            <h5 class="card-title"><?= htmlspecialchars($d['nombre']) ?></h5>
            <p class="card-text small flex-grow-1"><?= htmlspecialchars($d['descripcion']) ?></p>
            <span class="fw-bold">€<?= number_format($d['precio'],2,',','.') ?></span>
          </div>
        </div>
      </div>
      <?php endforeach; ?>
    </div>

    <div class="text-center mt-4">
      <a href="menu.php" class="btn btn-outline-primary">Ver carta completa</a>
    </div>
  </div>
</section>

<!-- Llamada a la acción reservas ------------------------------- -->
<section class="py-5">
  <div class="container text-center">
    <h2 class="mb-3">¿Listo para tu próxima comida inolvidable?</h2>
    <a href="reservas.php" class="btn btn-primary btn-lg">
      <i class="fa-solid fa-calendar-plus me-2"></i>Reservar mesa
    </a>
  </div>
</section>

<?php require_once __DIR__.'/partials/footer.php'; ?>
