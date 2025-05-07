#!/usr/bin/env bash
# 07_loki_promtail.sh — Loki y Promtail

set -e
CONF="honeypot/config"

echo "==> Loki config..."
cat > $CONF/loki-config.yaml << 'EOF'
[... loki-config.yaml ...]
EOF

echo "==> Promtail config..."
cat > $CONF/promtail-config.yaml << 'EOF'
[... promtail-config.yaml ...]
EOF

echo "Loki y Promtail configurados."
