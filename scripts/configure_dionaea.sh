#!/usr/bin/env bash
# Genera Dockerfile y configuración de Dionaea

set -e

dir="honeypot/dionaea"

cat > $dir/Dockerfile << 'EOF'
FROM dinotools/dionaea:latest
COPY dionaea.conf /etc/dionaea/dionaea.conf
EOF

cat > $dir/dionaea.conf << 'EOF'
[dionaea]
sensor_name = honeypot-ftp
modules = ftp
log_format = json

[ftp]
enabled = true
listen_address = 0.0.0.0
listen_port = 21
EOF

echo "Dionaea configurado en $dir"
