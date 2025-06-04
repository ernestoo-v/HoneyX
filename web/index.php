<?php 
session_start();
include 'db.php'; ?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>La Paradita</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Estilos personalizados -->
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <?php include 'navbar.php'; ?>

    <!-- Imagen de fondo con texto alineado a la derecha -->
<div class="bg-image text-white d-flex align-items-center" style="background-image: url('img/restaurant.png'); height: 100vh; background-size: cover; background-position: center;">
    <div class="container d-flex justify-content-end">
        <div class="text-end">
            <h1 class="display-4 fw-bold">Bienvenido a La Paradita</h1>
            <p class="lead">Disfruta de la mejor cocina española en un ambiente moderno y elegante.</p>
            <a href="reserva.php" class="btn btn-warning btn-lg m-2 text-dark fw-bold">Reservar Mesa</a>
            <a href="menu.php" class="btn btn-outline-light btn-lg m-2">Ver Menú</a>
        </div>
    </div>
</div>

    <!-- Sección de destacados -->
    <div class="container my-5">
        <h2 class="text-center mb-4">Platos Destacados</h2>
        <div class="row">
            <?php
            $db = getDB();
            $stmt = $db->query("SELECT * FROM platos ORDER BY RAND() LIMIT 3")->fetchAll();
            foreach($stmt as $plato) {
                echo '
                <div class="col-md-4 mb-4">
                    <div class="card h-100 shadow">
                        <img src="'.$plato['imagen_url'].'" class="card-img-top" alt="'.$plato['nombre'].'">
                        <div class="card-body">
                            <h5 class="card-title">'.$plato['nombre'].'</h5>
                            <p class="card-text">'.$plato['descripcion'].'</p>
                            <span class="badge bg-success">€'.number_format($plato['precio'], 2).'</span>
                        </div>
                    </div>
                </div>
                ';
            }
            ?>
        </div>
    </div>

    <!-- Sección de testimonios -->
    <div class="bg-light py-5">
        <div class="container">
            <h2 class="text-center mb-4">Opiniones de Nuestros Clientes</h2>
            <div class="row">
                <div class="col-md-4">
                    <blockquote class="blockquote">
                        <p>"La mejor paella que he probado en Madrid. ¡Volveré pronto!"</p>
                        <footer class="blockquote-footer">María López</footer>
                    </blockquote>
                </div>
                <div class="col-md-4">
                    <blockquote class="blockquote">
                        <p>"Ambiente acogedor y servicio excepcional. Recomendado al 100%."</p>
                        <footer class="blockquote-footer">Carlos García</footer>
                    </blockquote>
                </div>
                <div class="col-md-4">
                    <blockquote class="blockquote">
                        <p>"Una experiencia culinaria inolvidable. Cada plato es una obra de arte."</p>
                        <footer class="blockquote-footer">Lucía Fernández</footer>
                    </blockquote>
                </div>
            </div>
        </div>
    </div>

    <!-- Información de contacto -->
    <div class="bg-dark text-white py-4">
        <div class="container text-center">
            <!-- cGFzc3dvcmQ6IFlXUnRhVzR4TWpNPQ== -->
            <p><strong>Dirección:</strong> Avenida de los Cármenes, 23 - Madrid</p>
            <p><strong>Teléfono:</strong> +34 912 345 678</p>
            <p><strong>Horario:</strong> Lunes a Domingo: 12:00 - 23:00</p>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
