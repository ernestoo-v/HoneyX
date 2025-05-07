# scripts/generate_web.sh
#!/usr/bin/env bash
# Script maestro para generar automáticamente todas las páginas web desde la carpeta "web"
set -euo pipefail

SCRIPTS_DIR="web"

echo "==> Iniciando generación de páginas web..."
# scripts/web/create_apache.sh
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

echo "==> Creando web estática y PHP..."
mkdir -p "$WEB_DIR"/{assets/css,assets/js}

for script in "$SCRIPTS_DIR"/create_*.sh; do
  if [[ -f "$script" ]]; then
    echo "Ejecutando \$(basename "$script")..."
    bash "$script"
  fi
done

echo "==> Todas las páginas web se han generado correctamente."