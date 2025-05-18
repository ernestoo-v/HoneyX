#!/usr/bin/env bash
# 07_promtail.sh — Promtail

set -e
CONF="honeypot/config"

echo "==> Promtail config..."
cat > $CONF/promtail-config.yaml << 'EOF'
server:
  http_listen_port: 9080
  grpc_listen_port: 0          # seguimos sin gRPC

positions:
  #La metemos en /var/lib para que sobreviva a reinicios y a /tmp cleanups
  filename: /var/lib/promtail/positions.yaml

clients:
  - url: http://10.0.9.15:3100/loki/api/v1/push

scrape_configs:
#─────────────────────────── APACHE ───────────────────────────
  - job_name: apache-access
    static_configs:
      - targets: [localhost]
        labels:
          job: apache
          type: access        # distinguir access de error facilita las queries
          env: honeypot
          __path__: /var/log/apache2/access.log
    pipeline_stages:
      - regex:
          expression: '^(?P<remote_ip>\S+) \S+ \S+ \[(?P<timestamp>[^\]]+)] "(?P<method>\S+) (?P<path>\S+) (?P<protocol>[^\"]+)" (?P<status>\d{3}) (?P<size>\d+).*'
      - labels:
          remote_ip:
          method:
          status:
      - timestamp:
          source: timestamp
          format: '02/Jan/2006:15:04:05 -0700'

  - job_name: apache-error
    static_configs:
      - targets: [localhost]
        labels:
          job: apache
          type: error
          env: honeypot
          __path__: /var/log/apache2/error.log
    pipeline_stages:
      - regex:
          expression: '^\[(?P<timestamp>[^\]]+)] \[(?P<level>[^\]]+)] \[pid (?P<pid>\d+)\]'
      - labels:
          level:
          pid:
      - timestamp:
          source: timestamp
          # Ej.: Mon Jan 02 15:04:05.123456 2006
          format: 'Mon Jan 02 15:04:05.000000 2006'

  - job_name: modsecurity
    static_configs:
      - targets: [localhost]
        labels:
          job: apache
          type: modsec
          env: honeypot
          __path__: /var/log/apache2/modsec_audit.json
    pipeline_stages:
      - json:
      - labels:
          transaction.id:
          message:
          severity:

#─────────────────────────── MYSQL ─────────────────────────────
  - job_name: mysql-slow
    static_configs:
      - targets: [localhost]
        labels:
          job: mysql
          type: slow
          env: honeypot
          __path__: /var/log/mysql/slow.log
    pipeline_stages:
      - multiline:
          firstline: '^# Time:'       # junta cada query lenta en un solo entry
      - regex:
          expression: '^# Time: (?P<timestamp>\d{6}\s+\d{1,2}:\d{2}:\d{2}).*\n# User@Host:.*\n# Query_time: (?P<query_time>[0-9\.]+)'
      - labels:
          query_time:
      - timestamp:
          source: timestamp
          format: '060102 15:04:05'

  - job_name: mysql-audit
    static_configs:
      - targets: [localhost]
        labels:
          job: mysql
          type: audit
          env: honeypot
          __path__: /var/log/mysql/audit.log
    pipeline_stages:
      - json:
      - labels:
          command_class:
          user:
          host:

  - job_name: mysql-error
    static_configs:
      - targets: [localhost]
        labels:
          job: mysql
          type: error
          env: honeypot
          __path__: /var/log/mysql/error.log

#─────────────────────────── FTP (ProFTPD) ─────────────────────
  - job_name: ftp
    static_configs:
      - targets: [localhost]
        labels:
          job: ftp
          env: honeypot
          __path__: /var/log/proftpd/*.log
    # Puedes añadir aquí un regex para separar usuarios/IP si lo necesitas

#─────────────────────────── COWRIE ────────────────────────────
  - job_name: cowrie
    static_configs:
      - targets: [localhost]
        labels:
          job: cowrie
          env: honeypot
          host: vps1
          __path__: /cowrie/log/*.json
    pipeline_stages:
      - json:
      - labels:
          src_ip:
          username:
          success:

#─────────────────────────── FAIL2BAN ──────────────────────────
  - job_name: fail2ban
    static_configs:
      - targets: [localhost]
        labels:
          job: security
          type: fail2ban
          env: honeypot
          __path__: /var/log/fail2ban.log
    pipeline_stages:
      - regex:
          expression: '^(?P<timestamp>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}).*?\[(?P<jail>[^\]]+)\] Ban (?P<ip>\S+)'
      - labels:
          jail:
          ip:
      - timestamp:
          source: timestamp
          format: '2006-01-02 15:04:05'

EOF


echo "Loki y Promtail configurados."
