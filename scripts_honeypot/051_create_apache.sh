#!/usr/bin/env bash
set -euo pipefail

AP_DIR="honeypot/apache"
WEB_DIR="honeypot/web"

echo "==> Dockerfile de Apache+PHP..."
mkdir -p "$AP_DIR"
cat > "$AP_DIR/Dockerfile" << 'EOF'
FROM php:7-apache

# Instala PDO y PDO_MySQL
RUN apt-get update \
 && docker-php-ext-install pdo pdo_mysql \
 && rm -rf /var/lib/apt/lists/*
EOF