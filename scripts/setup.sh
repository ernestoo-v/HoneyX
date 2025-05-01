#!/usr/bin/env bash
set -e

# Base directory
dir="honeypot"

# Crear estructura de carpetas
mkdir -p $dir/{cowrie,dionaea,web,volumenes/apache_logs,volumenes/mysql_log,volumenes/ftp_logs,grafana/data,grafana/provisioning,config}
echo "Creando directorios necesarios..."

# Asignar permisos adecuados para Grafana
sudo chown -R 472:472 $dir/grafana/data
echo "Asignando permisos a grafana/data..."

# Llamar a los scripts de configuración
bash setup_cowrie.sh $dir
bash setup_dionaea.sh $dir
bash setup_web.sh $dir
bash setup_observability.sh $dir
bash setup_docker_compose.sh $dir

echo "Estructura y ficheros generados en ./$dir"
