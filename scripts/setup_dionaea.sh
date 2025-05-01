#!/usr/bin/env bash
set -e

dir=$1

echo "Generando configuración para Dionaea..."
cat > $dir/dionaea/Dockerfile << 'EOF'
FROM dinotools/dionaea:latest
COPY dionaea.conf /etc/dionaea/dionaea.conf
EOF

cat > $dir/dionaea/dionaea.conf << 'EOF'
[dionaea]
sensor_name = honeypot-ftp
modules = ftp
log_format = json

[ftp]
enabled = true
listen_address = 0.0.0.0
listen_port = 21
EOF
