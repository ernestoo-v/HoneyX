#!/usr/bin/env bash
# scripts/05_apache.sh — Orquesta la generación de la web
set -euo pipefail

# 1) Calculo de la ruta absoluta al propio directorio de este script:
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 2) Carpeta donde están los create_*.sh
SCRIPTS_DIR="$BASE_DIR/web"
# 3) Identificar explícitamente el setup de Apache
APACHE_SETUP="$SCRIPTS_DIR/create_apache.sh"

echo "==> Iniciando generación de páginas web desde $SCRIPTS_DIR …"

# 4) Primero: creamos Dockerfile y estructura Apache/PHP
if [[ -f "$APACHE_SETUP" ]]; then
  echo "----> Ejecutando $(basename "$APACHE_SETUP")"
  bash "$APACHE_SETUP"
else
  echo "¡¡ Error: no existe $APACHE_SETUP !!"
  exit 1
fi

# 5) Luego, todos los demás create_*.sh (salta el de Apache)
for script in "$SCRIPTS_DIR"/create_*.sh; do
  [[ "$script" == "$APACHE_SETUP" ]] && continue
  if [[ -x "$script" ]]; then
    echo "----> Ejecutando $(basename "$script")"
    bash "$script"
  else
    echo "----> Haciendo ejecutable y lanzando $(basename "$script")"
    chmod +x "$script"
    bash "$script"
  fi
done

echo "==> ¡Todas las páginas web se han generado correctamente!"