#!/usr/bin/env bash
# scripts/05_apache.sh — Orquesta la generación de la web
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1) Nombre del script que configura Apache
APACHE_SETUP="$BASE_DIR/051_create_apache.sh"

# 2) Verifica si existe el script
if [[ -f "$APACHE_SETUP" ]]; then
  echo "----> Ejecutando $(basename "$APACHE_SETUP")"
  bash "$APACHE_SETUP"
else
  echo "¡¡ Error: no existe $APACHE_SETUP !!"
  exit 1
fi

# 3) Copiar el contenido del directorio web al destino en honeypot
sudo cp -r web/* honeypot/web

echo "==> ¡Todas las páginas web se han generado correctamente!"
