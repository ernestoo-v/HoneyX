#!/usr/bin/env bash
set -e

dir=$1

echo "Generando configuración para Cowrie..."
cat > $dir/cowrie/Dockerfile << 'EOF'
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
