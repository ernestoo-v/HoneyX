#!/usr/bin/env bash
set -e

dir=$1

echo "Generando servicio web Apache+PHP..."
echo "<?php phpinfo(); ?>" > $dir/web/index.php
