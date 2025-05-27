<?php
/* web_test/valoraciones.php */
require_once __DIR__.'/config.php';
$title='Valoraciones';
require_once __DIR__.'/partials/header.php';

/* consulta: review + nombre del plato */
$sql="SELECT v.id,mi.nombre plato,v.puntuacion,v.comentario,v.creado
        FROM valoraciones v
        JOIN menu_items mi ON mi.id=v.menu_item_id
    ORDER BY v.creado DESC";
$res=$pdo->query($sql)->fetchAll();
?>
<header class="bg-secondary text-white py-4">
  <div class="container"><h1 class="mb-0"><i class="fa-solid fa-star me-2"></i>Valoraciones</h1></div>
</header>

<section class="py-3 bg-light">
  <div class="container">
    <input id="filtro" class="form-control" placeholder="Buscar plato…">
  </div>
</section>

<section class="py-5">
 <div class="container">
  <?php foreach($res as $r): ?>
   <div class="border-bottom pb-3 mb-3 review">
     <h5 class="mb-1 nombre"><?=htmlspecialchars($r['plato'])?></h5>
     <!-- estrellas -->
     <?php for($i=1;$i<=5;$i++): ?>
       <i class="fa-solid fa-star <?= $i<=$r['puntuacion']?'text-warning':'text-muted' ?>"></i>
     <?php endfor; ?>
     <small class="text-muted ms-2"><?=substr($r['creado'],0,10)?></small>
     <p class="mt-2"><?=htmlspecialchars($r['comentario'])?></p>
   </div>
  <?php endforeach; ?>
 </div>
</section>

<?php require_once __DIR__.'/partials/footer.php'; ?>
<script>
document.getElementById('filtro').addEventListener('input',e=>{
  const t=e.target.value.toLowerCase();
  document.querySelectorAll('.review').forEach(d=>{
    d.style.display=d.querySelector('.nombre').textContent.toLowerCase().includes(t)?'':'none';
  });
});
</script>
