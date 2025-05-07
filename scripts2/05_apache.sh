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

# menu.php, contact.php, config.php, style.css, script.js (igual que tu original)

echo "Apache+PHP y web listos."
