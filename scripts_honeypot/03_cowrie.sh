#!/usr/bin/env bash
# 03_cowrie.sh — Dockerfile y cfg para Cowrie

set -e
DIR="honeypot/cowrie"

echo "==> Generando Dockerfile de Cowrie..."
cat > $DIR/Dockerfile << 'EOF'
FROM cowrie/cowrie:latest
COPY cowrie.cfg /cowrie/etc/cowrie.cfg
EOF

cat > $dir/cowrie/cowrie.cfg << 'EOF'
[honeypot]
hostname = honeypot-ssh
listen_addr = 0.0.0.0
listen_port = 22
log_path = /cowrie/log
download_path = /cowrie/dl

auth_class = AuthRandom
auth_class_parameters = 2,5,10

[output_jsonlog]
enabled = true
EOF

echo "Cowrie configurado."
