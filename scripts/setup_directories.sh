#!/usr/bin/env bash
# Crea la estructura de carpetas base y ajusta permisos de Grafana

set -e

dir="honeypot"

# Crear directorios base
mkdir -p $dir/{cowrie,dionaea,web,volumenes/apache_logs,volumenes/mysql_log,volumenes/ftp_logs,grafana/data,grafana/provisioning/datasources,config}
echo "Directorios creados en ./$dir"

# Asignar permisos para Grafana (UID 472 dentro del contenedor)
sudo chown -R 472:472 $dir/grafana/data
echo "Permisos asignados a grafana/data"
