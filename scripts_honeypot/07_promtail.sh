#!/usr/bin/env bash
# 07_promtail.sh — Promtail

set -e
CONF="honeypot/config"

echo "==> Promtail config..."
cat > $CONF/promtail-config.yaml << EOF
server:
  http_listen_port: 9080
positions:
  filename: /var/lib/promtail/positions.yaml

clients:
  - url: http://$LOKI_IP:3100/loki/api/v1/push

scrape_configs:
#─────────── Apache access / error ───────────
  - job_name: apache-access
    static_configs:
      - labels: { job: apache, type: access, __path__: /var/log/apache2/access.log }
    pipeline_stages:
      - regex:
          expression: '^(?P<remote_ip>\S+) .* "(?P<method>\S+) (?P<path>\S+)'
      - labels: { remote_ip, method }

  - job_name: apache-error
    static_configs:
      - labels: { job: apache, type: error, __path__: /var/log/apache2/error.log }
    pipeline_stages:
      - regex:
          expression: 'IP=(?P<remote_ip>\d+\.\d+\.\d+\.\d+).*usuario=\'(?P<user>[^\']+)\' contraseña=\'(?P<pass>[^\']+)\' - Query=(?P<query>.+)'
      - labels: { remote_ip, user }

#─────────── ModSecurity audit (JSON) ───────────
  - job_name: modsec
    static_configs:
      - labels: { job: apache, type: modsec, __path__: /var/log/modsecurity/*audit*.json }
    pipeline_stages:
      - json:
          expressions:
            txid: transaction.id
            severity: severity
            client_ip: transaction.client_ip
            uri: transaction.request.uri
      - labels: { txid, severity, client_ip }

#─────────── MySQL slow / error / general ───────────
  - job_name: mysql-error
    static_configs:
      - labels: { job: mysql, type: error, __path__: /var/log/mysql/error.log }

  - job_name: mysql-general
    static_configs:
      - labels: { job: mysql, type: general, __path__: /var/log/mysql/general.log }
    pipeline_stages:
      - regex:
          expression: '(?P<remote_ip>(?:[0-9]{1,3}\.){3}[0-9]{1,3})'
      - labels: { remote_ip }

#─────────── ProFTPD ───────────
  - job_name: ftp
    static_configs:
      - labels: { job: ftp, __path__: /var/log/proftpd/*.log }

#─────────── Fakessh ───────────
  - job_name: fakessh
    static_configs:
      - labels: { job: fakessh, __path__: /var/log/fakessh/fakessh.log }

EOF

echo "Promtail configurado."
