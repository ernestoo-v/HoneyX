# scripts/generate_web.sh
#!/usr/bin/env bash
# Script maestro para generar automáticamente todas las páginas web desde la carpeta "web"
set -euo pipefail

SCRIPTS_DIR="web"

echo "==> Iniciando generación de páginas web..."
for script in "$SCRIPTS_DIR"/create_*.sh; do
  if [[ -f "$script" ]]; then
    echo "Ejecutando \$(basename "$script")..."
    bash "$script"
  fi
done

echo "==> Todas las páginas web se han generado correctamente."