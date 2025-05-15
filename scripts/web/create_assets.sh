# scripts/05_apache/create_assets.sh
#!/usr/bin/env bash
set -euo pipefail
WEB_DIR="honeypot/web"
echo "==> Generando assets CSS y JS..."
# CSS
cat > "$WEB_DIR/assets/css/style.css" << 'EOF'
body {font-family:Arial,sans-serif;margin:0;padding:0;background:#fafafa;color:#333}
header {background:#c0392b;color:#fff;padding:1rem;text-align:center}
nav a {color:#fff;margin:0 1rem;text-decoration:none}
main {padding:2rem}
h2 {color:#c0392b}
footer {background:#2c3e50;color:#fff;text-align:center;padding:1rem;position:fixed;bottom:0;width:100%}
form label {display:block;margin:0.5rem 0}
form input,form textarea {width:100%;padding:0.5rem;border:1px solid #ccc;border-radius:4px}
button {background:#c0392b;color:#fff;padding:0.5rem 1rem;border:none;border-radius:4px;cursor:pointer}
button:hover {background:#e74c3c}
EOF
# JS
cat > "$WEB_DIR/assets/js/script.js" << 'EOF'
document.addEventListener('DOMContentLoaded', function() {
  const form = document.getElementById('contactForm');
  if (form) {
    form.addEventListener('submit', function(e) {
      e.preventDefault();
      const data = new FormData(form);
      document.getElementById('formResult').innerText =
        `Gracias, ${data.get('name')}! Tu mensaje ha sido enviado.`;
      form.reset();
    });
  }
});
EOF
