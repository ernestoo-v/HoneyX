<?php
/* web_test/reservas.php */
require_once __DIR__.'/config.php';
$title='Reservar mesa';
$ok=false;$err=[];
if($_SERVER['REQUEST_METHOD']==='POST'){
  [$n,$e,$t,$f,$h,$c,$m]=[
     trim($_POST['nombre']??''),
     trim($_POST['email']??''),
     trim($_POST['telefono']??''),
     $_POST['fecha']??'',
     $_POST['hora']??'',
     (int)($_POST['comensales']??0),
     trim($_POST['mensaje']??'')];

  if($n==='')$err[]='Nombre requerido';
  if(!filter_var($e,FILTER_VALIDATE_EMAIL))$err[]='E-mail inválido';
  if($c<1)$err[]='Comensales ≥1';
  if(!$err){
    $sql="INSERT INTO reservas(nombre,email,telefono,fecha,hora,comensales,mensaje)
          VALUES(:n,:e,:t,:f,:h,:c,:m)";
    $st=$pdo->prepare($sql);          /* prepared PDO + placeholders :contentReference[oaicite:4]{index=4} */
    $st->execute([':n'=>$n,':e'=>$e,':t'=>$t,':f'=>$f,':h'=>$h,':c'=>$c,':m'=>$m]);
    $ok=true;
  }
}
require_once __DIR__.'/partials/header.php';
?>

<header class="bg-secondary text-white py-4">
  <div class="container"><h1 class="mb-0"><i class="fa-solid fa-calendar-plus me-2"></i>Reservar mesa</h1></div>
</header>

<section class="py-5">
 <div class="container" style="max-width:600px">
   <?php if($ok): ?>
     <div class="alert alert-success">¡Reserva registrada! Te confirmaremos por correo.</div>
   <?php elseif($err): ?>
     <div class="alert alert-danger"><ul class="mb-0">
       <?php foreach($err as $e)echo"<li>".htmlspecialchars($e)."</li>"; ?>
     </ul></div>
   <?php endif; ?>

   <form method="post" novalidate>
     <div class="mb-3">
       <label class="form-label">Nombre</label>
       <input name="nombre" class="form-control" required>
     </div>
     <div class="mb-3">
       <label class="form-label">E-mail</label>
       <input type="email" name="email" class="form-control" required>
     </div>
     <div class="mb-3">
       <label class="form-label">Teléfono</label>
       <input name="telefono" class="form-control" required>
     </div>
     <div class="row">
       <div class="col-6 mb-3">
         <label class="form-label">Fecha</label>
         <input type="date" name="fecha" class="form-control" required>
       </div>
       <div class="col-6 mb-3">
         <label class="form-label">Hora</label>
         <input type="time" name="hora" class="form-control" required>
       </div>
     </div>
     <div class="mb-3">
       <label class="form-label">Comensales</label>
       <input type="number" name="comensales" min="1" max="20" class="form-control" required>
     </div>
     <div class="mb-3">
       <label class="form-label">Mensaje (opcional)</label>
       <textarea name="mensaje" rows="3" class="form-control"></textarea>
     </div>
     <button class="btn btn-primary"><i class="fa-solid fa-paper-plane me-2"></i>Enviar</button>
   </form>
 </div>
</section>

<?php require_once __DIR__.'/partials/footer.php'; ?>
