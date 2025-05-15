# scripts/05_apache/create_assets.sh
#!/usr/bin/env bash
set -euo pipefail
WEB_DIR="honeypot/web"
echo "==> Generando assets CSS y JS..."
# CSS

# global.css
cat > "$WEB_DIR/assets/css/global.css" << 'EOF'


/* Variables de color y espaciado */
:root {
  --primary: #2c3e50;
  --accent: #e74c3c;
  --form-accent: #868686;
  --bg: #f7f9fa;
  --card-bg: #fff;
  --text-dark: #333;
  --text-light: #666;
  --radius: 12px;
  --shadow: rgba(0,0,0,0.08);
  --gap: 1rem;
}

/* ==== Global Header and Footer Styling ==== */
body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    background-color: #fafafa;
    color: #333;
  }
  
  header, footer {
    background-color: #2c3e50;
    color: #fff;
    padding: 1rem;
    text-align: center;
  }
  
  header {
    position: sticky;
    top: 0;
  }
  
  footer {
    position: fixed;
    bottom: 0;
    width: 100%;
  }
  
  nav a {
    color: #fff;
    margin: 0 1rem;
    text-decoration: none;
    padding: 0.5rem;
    transition: background-color 0.3s;
  }
  
  nav a:hover, nav a.active {
    background-color: #34495e;
    border-radius: 5px;
  }
  
  main {
    padding: 2rem;
    margin-bottom: 4rem; /* Para evitar solapamiento con el footer */
  }
  
EOF

# contact_style.css
cat > "$WEB_DIR/assets/css/contact_style.css" << 'EOF'
/* ==== Formulario de Reservas Mejorado ==== */
.contact-form {
  max-width: 480px;
  margin: 2rem auto;
  display: grid;
  gap: 1.5rem; /* Espaciado claro entre campos */
}

.contact-form label {
  display: flex;
  flex-direction: column;
  font-weight: 600;
  color: var(--primary);
}

.contact-form input {
  padding: 0.75rem 1rem;
  border: 2px solid #ccc;
  border-radius: 8px;
  font-size: 1rem;
  transition: border-color 0.3s ease, box-shadow 0.3s ease; /* Animación suave */
}

.contact-form input:focus {
  border-color: var(--form-accent);
  box-shadow: 0 0 0 3px #ccc; /* Enfoque con sombra sutil */
  outline: none;
}


.contact-form textarea {
  padding: 0.75rem 1rem;
  border: 2px solid #ccc;
  border-radius: 8px;
  font-size: 1rem;
  transition: border-color 0.3s ease, box-shadow 0.3s ease; /* Animación suave */
}


.contact-form textarea:focus {
  border-color: var(--form-accent);
  box-shadow: 0 0 0 3px #ccc; /* Enfoque con sombra sutil */
  outline: none;
}


/* Botón de envío en reservas */
.contact-form button {
  padding: 0.75rem 1.5rem;
  background: var(--accent);
  color: #fff;
  font-weight: 600;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: background 0.3s, transform 0.2s;
}

.contact-form button:hover {
  background: var(--primary);
  transform: translateY(-2px);
}
EOF


# index_style.css
cat > "$WEB_DIR/assets/css/style.css" << 'EOF'
/* index_style.css: estilos para la página de inicio */
.home-intro {
    max-width: 800px;
    margin: 2rem auto;
    font-size: 1.1rem;
    color: #444;
    text-align: center;
  }
  
  .home-intro blockquote {
    margin: 1.5rem auto;
    padding: 1rem 1.5rem;
    font-style: italic;
    border-left: 4px solid var(--accent);
    background: #fff;
    border-radius: var(--radius);
  }
  
EOF


# menu_style.css
cat > "$WEB_DIR/assets/css/menu_style.css" << 'EOF'
/* Contenedor grid de 3 columnas */
.menu-container .grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: var(--gap);
  padding: var(--gap);
  max-width: 1200px;
  margin: 0 auto;
}

/* Tarjeta clicable */
.card {
  background: var(--card-bg);
  border-radius: var(--radius);
  box-shadow: 0 4px 12px var(--shadow);
  overflow: hidden;
  text-decoration: none;
  color: inherit;
  display: flex;
  flex-direction: column;
  transition: transform 0.2s, box-shadow 0.2s;
}
.card:hover {
  transform: translateY(-6px);
  box-shadow: 0 8px 20px var(--shadow);
}

/* Imagen por defecto */
.card img {
  width: 100%;
  height: 180px;
  object-fit: cover;
  background: #ddd url('assets/img/placeholder.jpg') center/cover no-repeat;
}

/* Contenido de la tarjeta */
.card-content {
  padding: var(--gap);
  flex: 1;
  display: flex;
  flex-direction: column;
}
.card-title {
  font-size: 1.3rem;
  margin-bottom: 0.5rem;
  color: var(--primary);
}
.card-ingredients {
  flex: 1;
  margin-bottom: 1rem;
  color: var(--text-light);
  list-style: none;
  padding-left: 0;
}
.card-ingredients li {
  margin-bottom: 0.25rem;
  position: relative;
  padding-left: 1.2rem;
}
.card-ingredients li::before {
  content: '•';
  position: absolute;
  left: 0;
  color: var(--accent);
}

/* Botón o acción al final */
.card-action {
  text-align: center;
  padding: 0.75rem;
  background: var(--primary);
  color: #fff;
  font-weight: bold;
  border-top: 1px solid rgba(255,255,255,0.1);
  transition: background 0.2s;
}
.card-action:hover {
  background: var(--accent);
}

EOF


# reservations_style.css
cat > "$WEB_DIR/assets/css/reservations_style.css" << 'EOF'
/* ==== Formulario de Reservas Mejorado ==== */
.reservations-form {
    max-width: 480px;
    margin: 2rem auto;
    display: grid;
    gap: 1.5rem; /* Espaciado claro entre campos */
  }
  
  .reservations-form label {
    display: flex;
    flex-direction: column;
    font-weight: 600;
    color: var(--primary);
  }
  
  .reservations-form input {
    padding: 0.75rem 1rem;
    border: 2px solid #ccc;
    border-radius: 8px;
    font-size: 1rem;
    transition: border-color 0.3s ease, box-shadow 0.3s ease; /* Animación suave */
  }
  
  .reservations-form input:focus {
    border-color: var(--form-accent);
    box-shadow: 0 0 0 3px #ccc;/* Enfoque con sombra sutil */
    outline: none;
  }
  

/* Botón de envío en reservas */
.reservations-form button {
    padding: 0.75rem 1.5rem;
    background: var(--accent);
    color: #fff;
    font-weight: 600;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    transition: background 0.3s, transform 0.2s;
  }
  
  .reservations-form button:hover {
    background: var(--primary);
    transform: translateY(-2px);
  }
    
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
