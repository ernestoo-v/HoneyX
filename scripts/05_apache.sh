#!/usr/bin/env bash
# Script maestro para generar automáticamente todas las páginas web desde la carpeta "web"
set -euo pipefail

SCRIPTS_DIR="web"
APACHE_SETUP_SCRIPT="$SCRIPTS_DIR/create_apache.sh"

echo "==> Iniciando generación de entorno web..."

# Ejecutar primero el script de creación de Apache y estructura web
if [[ -f "$APACHE_SETUP_SCRIPT" ]]; then
  echo "Ejecutando $(basename "$APACHE_SETUP_SCRIPT")..."
  bash "$APACHE_SETUP_SCRIPT"
else
  echo "Error: No se encontró $APACHE_SETUP_SCRIPT"
  exit 1
fi

# Ejecutar el resto de scripts de creación de páginas, excluyendo el de Apache
for script in "$SCRIPTS_DIR"/create_*.sh; do
  if [[ "$script" != "$APACHE_SETUP_SCRIPT" ]]; then
    echo "Ejecutando $(basename "$script")..."
    bash "$script"
  fi
done

echo "==> Todas las páginas web se han generado correctamente."
