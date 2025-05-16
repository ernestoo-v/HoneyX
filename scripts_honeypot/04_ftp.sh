#!/usr/bin/env bash
# 04_ftp.sh — Dockerfile y cfg para ProFTPD

set -e
DIR="honeypot/proftpd"
mkdir -p $DIR

echo "==> Generando Dockerfile de ProFTPD..."
cat > $DIR/Dockerfile << 'EOF'
FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y proftpd-basic && rm -rf /var/lib/apt/lists/*
COPY proftpd.conf /etc/proftpd/proftpd.conf
RUN mkdir -p /var/log/proftpd && \
    useradd -m -d /home/ftpuser -s /bin/bash ftpuser && \
    echo "ftpuser:ftppass" | chpasswd && \
    chown -R ftpuser:ftpuser /home/ftpuser /var/log/proftpd
EXPOSE 21 21100-21110
CMD ["proftpd", "--nodaemon"]
EOF

echo "==> Generando proftpd.conf..."
cat > $DIR/proftpd.conf << 'EOF'
ServerName "ProFTPD Honeypot"
ServerType standalone
DefaultServer on

Port 21

PassivePorts 21100 21110

SystemLog /var/log/proftpd/proftpd.log
ExtendedLog /var/log/proftpd/access.log AUTH,READ,WRITE
TransferLog /var/log/proftpd/transfer.log
LogFormat commandLog "%h %l %u %t \"%r\" %s"
ExtendedLog /var/log/proftpd/commands.log ALL commandLog

DefaultRoot ~

TimesGMT off
SetEnv TZ :/etc/localtime

ServerIdent on "FTP Honeypot Listo"
EOF

echo "FTP configurado."
