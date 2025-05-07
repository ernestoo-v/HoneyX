# scripts/05_apache/create_config.sh
#!/usr/bin/env bash
set -euo pipefail
WEB_DIR="honeypot/web"
echo "==> Generando config.php..."
cat > "$WEB_DIR/config.php" << 'EOF'
<?php
$host = getenv('DB_HOST') ?: 'mi_mysql';
$db   = getenv('DB_NAME') ?: 'bbdd';
$user = getenv('DB_USER') ?: 'usuario';
$pass = getenv('DB_PASS') ?: 'passwd';
$dsn = "mysql:host={$host};dbname={$db};charset=utf8mb4";
try {
    $pdo = new PDO(
        $dsn,
        $user,
        $pass,
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC]
    );
} catch (PDOException $e) {
    echo "Error BD: " . htmlspecialchars($e->getMessage());
    exit(1);
}
EOF