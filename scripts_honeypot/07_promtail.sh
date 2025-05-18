#!/usr/bin/env bash
# 07_promtail.sh — Promtail

set -e
CONF="honeypot/config"

echo "==> Promtail config..."
cat > $CONF/promtail-config.yaml << 'EOF'
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://10.0.9.15:3100/loki/api/v1/push

scrape_configs:
  - job_name: apache
    static_configs:
      - targets:
          - localhost
        labels:
          job: apache
          __path__: /var/log/apache2/*.log

  - job_name: mysql
    static_configs:
      - targets:
          - localhost
        labels:
          job: mysql
          __path__: /var/log/mysql/*.log

  - job_name: ftp
    static_configs:
      - targets:
          - localhost
        labels:
          job: ftp
          __path__: /var/log/proftpd/*.log

  - job_name: cowrie
    static_configs:
      - targets:
          - localhost
        labels:
          job: cowrie
          host: vps1
          __path__: /cowrie/log/*.json
EOF


echo "Loki y Promtail configurados."
