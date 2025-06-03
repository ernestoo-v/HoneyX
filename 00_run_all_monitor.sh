#!/usr/bin/env bash
# run_all.sh — Ejecuta en orden todos los scripts de configuración,
# usando sudo sólo para el setup.

set -euo pipefail

SCRIPTS_DIR="scripts_monitor"
SCRIPTS=(
  "01_setup.sh"
  "02_gen_compose.sh"
  "03_loki.sh"
  "04_grafana.sh"
)

echo "==> Iniciando ejecución de todos los scripts..."
read -p "Introduce la IP del servidor honeypot: " HONEYPOT_ID
if [[ ! "$HONEYPOT_ID" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "IP no válida"
  exit 1
fi
export HONEYPOT_ID

for script in "${SCRIPTS[@]}"; do
  SCRIPT_PATH="$SCRIPTS_DIR/$script"
  if [[ ! -f "$SCRIPT_PATH" ]]; then
    echo "¡¡ Atención: $script no existe en $SCRIPTS_DIR !!"
    exit 1
  fi
  if [[ ! -x "$SCRIPT_PATH" ]]; then
    chmod +x "$SCRIPT_PATH"
  fi

  echo "----> Ejecutando $script..."
  bash "$SCRIPT_PATH"
  echo "----> $script completado."
done

echo "==> Todos los scripts se han ejecutado correctamente."
