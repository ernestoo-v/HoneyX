<?php
session_start();
require_once 'db.php';

// Verificar si el usuario ha iniciado sesión y tiene el rol adecuado
if (!isset($_SESSION['username']) || !in_array($_SESSION['rol'], ['admin', 'jefe', 'ventas'])) {
    header('Location: login.php');
    exit();
}

$db = getDB();
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel de Administración</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Estilos personalizados -->
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<?php include 'navbar.php'; ?>

<div class="container mt-5">
    <h2 class="mb-4">Panel de Administración</h2>

    <!-- Tabla de Empleados -->
    <div class="mb-5">
        <h4>Empleados</h4>
        <div class="table-responsive">
            <table class="table table-striped table-bordered">
                <thead class="table-dark">
                    <tr>
                        <th>Nombre</th>
                        <th>Apellido</th>
                        <th>Dirección</th>
                        <th>Teléfono</th>
                        <th>Correo Electrónico</th>
                        <th>Rol</th>
                        <th>Número de Cuenta Bancaria</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                    $stmt = $db->query("SELECT * FROM empleados");
                    while ($empleado = $stmt->fetch(PDO::FETCH_ASSOC)) {
                        echo "<tr>
                                <td>{$empleado['nombre']}</td>
                                <td>{$empleado['apellido']}</td>
                                <td>{$empleado['direccion']}</td>
                                <td>{$empleado['telefono']}</td>
                                <td>{$empleado['email']}</td>
                                <td>{$empleado['puesto']}</td>
                                <td>{$empleado['cuenta_bancaria']}</td>
                              </tr>";
                    }
                    ?>
                </tbody>
            </table>
        </div>
    </div>
    <!-- Tabla de Usuarios -->
<div class="mb-5">
    <h4>Usuarios</h4>
    <div class="table-responsive">
        <table class="table table-striped table-bordered">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Nombre de Usuario</th>
                    <th>Email</th>
                    <th>Contraseña</th>
                    <th>Rol</th>
                </tr>
            </thead>
            <tbody>
                <?php
                $stmt = $db->query("SELECT * FROM usuarios");
                while ($usuario = $stmt->fetch(PDO::FETCH_ASSOC)) {
                    echo "<tr>
                            <td>{$usuario['id']}</td>
                            <td>{$usuario['username']}</td>
                            <td>{$usuario['email']}</td>
                            <td>{$usuario['password']}</td>
                            <td>{$usuario['rol']}</td>
                          </tr>";
                }
                ?>
            </tbody>
        </table>
    </div>
</div>
    <!-- Tabla de Ventas -->
    <div class="mb-5">
        <h4>Ventas</h4>
        <div class="table-responsive">
            <table class="table table-striped table-bordered">
                <thead class="table-dark">
                    <tr>
                        <th>ID Venta</th>
                        <th>ID Usuario</th>
                        <th>ID Plato</th>
                        <th>Fecha</th>
                        <th>Cantidad</th>
                        <th>Total (€)</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                    $stmt = $db->query("SELECT * FROM ventas");
                    while ($venta = $stmt->fetch(PDO::FETCH_ASSOC)) {
                        echo "<tr>
                                <td>{$venta['id']}</td>
                                <td>{$venta['usuario_id']}</td>
                                <td>{$venta['plato_id']}</td>
                                <td>{$venta['fecha']}</td>
                                <td>{$venta['cantidad']}</td>
                                <td>{$venta['total']}</td>
                              </tr>";
                    }
                    ?>
                </tbody>
            </table>
        </div>
    </div>




</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
