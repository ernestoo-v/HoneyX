<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="index.php">La Paradita</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="menu.php">Menú Semanal</a></li>
                <li class="nav-item"><a class="nav-link" href="platos.php">Platos</a></li>
                <li class="nav-item"><a class="nav-link" href="reserva.php">Reservas</a></li>
                <?php if (isset($_SESSION['rol']) && in_array($_SESSION['rol'], ['admin', 'jefe', 'ventas'])): ?>
            <li class="nav-item"><a class="nav-link" href="panel.php">Panel de Administración</a></li>
        <?php endif; ?>
        <?php if (isset($_SESSION['username'])): ?>
            <li class="nav-item"><a class="nav-link" href="logout.php">Cerrar Sesión</a></li>
        <?php else: ?>
            <li class="nav-item"><a class="nav-link" href="login.php">Iniciar Sesión</a></li>
        <?php endif; ?>
            </ul>
        </div>
    </div>
</nav>
