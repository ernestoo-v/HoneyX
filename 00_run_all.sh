#!/usr/bin/env bash
# run_all.sh — Ejecuta en orden todos los scripts de configuración,
# usando sudo sólo para el setup.

set -euo pipefail

SCRIPTS_DIR="scripts"
# El primer script requiere sudo, el resto no
SCRIPTS=(
  "01_setup.sh"
  "02_gen_compose.sh"
  "03_cowrie.sh"
  "04_ftp.sh"
  "05_apache.sh"
  "06_mysql.sh"
  "07_loki_promtail.sh"
  "08_prometheus_grafana.sh"
)

echo "==> Iniciando ejecución de todos los scripts..."

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
  if [[ "$script" == "01_setup.sh" ]]; then
    sudo bash "$SCRIPT_PATH"
  else
    bash "$SCRIPT_PATH"
  fi
  echo "----> $script completado."
done

echo "==> Todos los scripts se han ejecutado correctamente."
