<?php 
session_start();
include 'db.php'; $db = getDB(); ?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reserva tu mesa</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">

</head>
<body>
<?php include 'navbar.php'; ?>
<div class="container mt-5" style="max-width:500px">
    <h2 class="mb-4">Reserva tu mesa</h2>
    <?php
    $mensaje = "";
    if($_SERVER['REQUEST_METHOD'] == 'POST'){
        $nombre = $_POST['nombre'];
        $telefono = $_POST['telefono'];
        $fecha = $_POST['fecha'];
        $personas = $_POST['personas'];
        // CONSULTA VULNERABLE
        $sql = "INSERT INTO reservas (nombre, telefono, fecha, personas) VALUES ('$nombre', '$telefono', '$fecha', $personas)";
        $db->exec($sql);
        $mensaje = "<div class='alert alert-success'>Reserva registrada correctamente.</div>";
    }
    echo $mensaje;
    ?>
    <form method="POST">
        <div class="mb-3">
            <label>Nombre</label>
            <input type="text" name="nombre" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Teléfono</label>
            <input type="text" name="telefono" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Fecha</label>
            <input type="datetime-local" name="fecha" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Número de personas</label>
            <input type="number" name="personas" class="form-control" required>
        </div>
        <button type="submit" class="btn btn-primary w-100">Reservar</button>
    </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
