#!/usr/bin/env bash
# scripts/05_apache.sh — Orquesta la generación de la web
set -euo pipefail

# 1) Calculo de la ruta absoluta al propio directorio de este script:
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 2) Primero: creamos Dockerfile y estructura Apache/PHP
if [[ -f "$APACHE_SETUP" ]]; then
  echo "----> Ejecutando $(basename "$APACHE_SETUP")"
  bash "$APACHE_SETUP"
else
  echo "¡¡ Error: no existe $APACHE_SETUP !!"
  exit 1
fi

# 3) Copiamos el directorio de nuestra web al directorio de honeypot
sudo cp -r web/* honeypot/web

echo "==> ¡Todas las páginas web se han generado correctamente!"