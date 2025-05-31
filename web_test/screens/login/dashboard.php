<?php
session_start();
if (!isset($_SESSION['user'])) { header('Location: login.php'); exit; }
include_once 'inc/header.php';
?>
<h2>Hola, <?php echo htmlspecialchars($_SESSION['user']); ?> 👋</h2>
<p>Has accedido a la zona restringida del honeypot.</p>
<?php include_once 'inc/footer.php'; ?>
