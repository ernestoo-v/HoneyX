<?php 
session_start();
include 'db.php'; $db = getDB(); ?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Menú Semanal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">

</head>
<body>
<?php include 'navbar.php'; ?>
<div class="container mt-5">
    <h2 class="mb-4">Menú Semanal</h2>
    <div class="row">
        <?php
        $dias = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes"];
        $platos = $db->query("SELECT * FROM platos ORDER BY RAND() LIMIT 5")->fetchAll();
        for($i=0; $i<5; $i++) {
            $plato = $platos[$i];
            echo '<div class="col-md-4 mb-4">
                    <div class="card shadow h-100">
                        <img src="'.$plato['imagen_url'].'" class="card-img-top" alt="'.$plato['nombre'].'">
                        <div class="card-body">
                            <h5 class="card-title">'.$dias[$i].': '.$plato['nombre'].'</h5>
                            <p class="card-text">'.$plato['descripcion'].'</p>
                            <span class="badge bg-success">€'.number_format($plato['precio'], 2).'</span>
                        </div>
                    </div>
                </div>';
        }
        ?>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
