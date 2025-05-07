#!/usr/bin/env bash
# 05_apache.sh — Dockerfile Apache+PHP y archivos web

set -e
AP_DIR="honeypot/apache"
WEB_DIR="honeypot/web"

echo "==> Dockerfile de Apache+PHP..."
mkdir -p $AP_DIR
cat > $AP_DIR/Dockerfile << 'EOF'
FROM php:7-apache

# Instala PDO y PDO_MySQL
RUN apt-get update \
 && docker-php-ext-install pdo pdo_mysql \
 && rm -rf /var/lib/apt/lists/*
EOF

echo "==> Creando web estática y PHP..."
mkdir -p $WEB_DIR/{assets/css,assets/js}

# index.php
cat > $WEB_DIR/index.php << 'EOF'
<?php
include 'config.php';
?><!DOCTYPE html><html lang="es">…EOF

# config.php
cat > $dir/web/config.php << 'EOF'
<?php
$host = getenv('DB_HOST') ?: 'mi_mysql';
$db   = getenv('DB_NAME') ?: 'bbdd';
$user = getenv('DB_USER') ?: 'usuario';
$pass = getenv('DB_PASS') ?: 'passwd';
$dsn = "mysql:host={$host};dbname={$db};charset=utf8mb4";
try { $pdo = new PDO($dsn, $user, $pass, [PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION, PDO::ATTR_DEFAULT_FETCH_MODE=>PDO::FETCH_ASSOC]); } catch (PDOException $e) { echo "Error BD: " . $e->getMessage(); exit(1);} 
EOF

# menu.php
cat > $WEB_DIR/menu.php << 'EOF'
<?php include 'config.php'; ?><!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><title>Menú</title><link rel="stylesheet" href="assets/css/style.css"></head><body><header><h1>Menú</h1><nav><a href="index.php">Inicio</a><a href="menu.php">Menú</a><a href="contact.php">Contacto</a></nav></header><main><h2>Platos</h2><ul><?php $platos=[['nombre'=>'Ensalada','precio'=>'8€'],['nombre'=>'Paella','precio'=>'12€'],['nombre'=>'Tarta','precio'=>'5€']]; foreach($platos as $p) echo "<li>{$p['nombre']} - <strong>{$p['precio']}</strong></li>"; ?></ul></main><footer>&copy;<?=date('Y')?></footer><script src="assets/js/script.js"></script></body></html>
EOF

# contact.php
cat > $WEB_DIR/contact.php << 'EOF'
<?php include 'config.php'; ?><!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><title>Contacto</title><link rel="stylesheet" href="assets/css/style.css"></head><body><header><h1>Contacto</h1><nav><a href="index.php">Inicio</a><a href="menu.php">Menú</a><a href="contact.php">Contacto</a></nav></header><main><h2>Mensaje</h2><form id="contactForm"><label>Nombre:<input required name="name"></label><label>Email:<input type="email" required name="email"></label><label>Mensaje:<textarea required name="message"></textarea></label><button>Enviar</button></form><div id="formResult"></div></main><footer>&copy;<?=date('Y')?></footer><script src="assets/js/script.js"></script></body></html>
EOF

# Assets CSS y JS
cat > $WEB_DIR/ssets/css/style.css << 'EOF'
body{font-family:Arial,sans-serif;margin:0;padding:0;background:#fafafa;color:#333}header{background:#c0392b;color:#fff;padding:1rem;text-align:center}nav a{color:#fff;margin:0 1rem;text-decoration:none}main{padding:2rem}h2{color:#c0392b}footer{background:#2c3e50;color:#fff;text-align:center;padding:1rem;position:fixed;bottom:0;width:100%}form label{display:block;margin:0.5rem 0}form input,form textarea{width:100%;padding:0.5rem;border:1px solid #ccc;border-radius:4px}button{background:#c0392b;color:#fff;padding:0.5rem 1rem;border:none;border-radius:4px;cursor:pointer}button:hover{background:#e74c3c}
EOF

cat > $WEB_DIR/assets/js/script.js << 'EOF'
document.addEventListener('DOMContentLoaded',function(){const form=document.getElementById('contactForm');if(form){form.addEventListener('submit',function(e){e.preventDefault();const data=new FormData(form);document.getElementById('formResult').innerText=`Gracias, ${data.get('name')}! Tu mensaje ha sido enviado.`;form.reset();}});
EOF

echo "Web de restaurante integrada correctamente."

