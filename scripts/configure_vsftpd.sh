#!/usr/bin/env bash
# Genera Dockerfile y configuración de Vsftpd

set -e

dir="honeypot/mi_ftp"

echo "Generando configuración para mi_ftp..."
cat > $dir/mi_ftp/Dockerfile << 'EOF'
FROM fauria/vsftpd:latest
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
EOF

cat > $dir/mi_ftp/vsftpd.conf << 'EOF'
[mi_ftp]
listen=YES
anonymous_enable=YES
local_enable=YES
write_enable=NO
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
ftpd_banner=Welcome to FTP.
listen_port=21
pasv_enable=YES
pasv_min_port=21100
pasv_max_port=21110
pasv_address=0.0.0.0
EOF

echo "Vsftpd configurado en $dir"
