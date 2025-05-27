<?php
$title = 'Carta completa';
require_once __DIR__.'/config.php';
require_once __DIR__.'/partials/header.php';

/* ── Menú con imagen de reserva si falta la real ──
   Usamos COALESCE para que ‘imagen’ nunca sea NULL  */
$stmt = $pdo->query(
 "SELECT c.nombre AS categoria,
         i.nombre,
         i.descripcion,
         i.precio,
         COALESCE(
           NULLIF(i.imagen_url, ''),
           'https://picsum.photos/seed/' || i.id || '/200/120'
         ) AS imagen
    FROM categorias c
    JOIN menu_items i ON i.categoria_id = c.id
ORDER BY c.id, i.id"
);
$menu=[];
foreach ($stmt as $row) $menu[$row['categoria']][]=$row;
?>
<header class="bg-secondary text-white py-4">
  <div class="container"><h1 class="mb-0"><i class="fa-solid fa-book-open me-2"></i>Carta completa</h1></div>
</header>

<section class="py-3 bg-light">
  <div class="container">
    <input id="buscador" type="search" class="form-control" placeholder="Buscar plato…">
  </div>
</section>

<section class="py-5">
  <div class="container">
    <?php foreach ($menu as $cat=>$platos): ?>
      <h2 class="border-bottom pb-2 mb-4"><?= htmlspecialchars($cat) ?></h2>
      <div class="row g-4">
        <?php foreach ($platos as $p): ?>
          <div class="col-md-6">
            <div class="d-flex align-items-start gap-3 plato">
              <img src="<?= htmlspecialchars($p['imagen']) ?>"
                   width="200" height="120" class="rounded img-fluid"
                   loading="lazy"
                   onerror="this.src='https://picsum.photos/seed/fallback/200/120'"><!-- fallback cliente :contentReference[oaicite:5]{index=5} -->
              <div>
                <h5 class="mb-1 nombre"><?= htmlspecialchars($p['nombre']) ?></h5>
                <p class="mb-1 small descripcion"><?= htmlspecialchars($p['descripcion']) ?></p>
                <span class="fw-semibold precio">€<?= number_format($p['precio'],2,',','.') ?></span>
              </div>
            </div>
          </div>
        <?php endforeach; ?>
      </div>
    <?php endforeach; ?>
  </div>
</section>

<?php require_once __DIR__.'/partials/footer.php'; ?>

<script>
document.getElementById('buscador').addEventListener('input',e=>{
  const term=e.target.value.toLowerCase();
  document.querySelectorAll('.plato').forEach(div=>{
    div.style.display=div.textContent.toLowerCase().includes(term)?'':'none';
  });
});
</script>
