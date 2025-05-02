#!/usr/bin/env bash
# Crea un index.php de ejemplo para Apache+PHP

set -e

dir="honeypot/web"
mkdir -p "$dir"

cat > $dir/index.php << 'EOF'
<?php
phpinfo();
EOF

echo "Apache+PHP configurado con index.php en $dir"
