#!/usr/bin/env bash
set -euo pipefail

# Directorio base de tu proyecto Docker
BASE_DIR="honeypot"

# 1. Crear carpeta sql-init si no existe
SQL_INIT_DIR="$BASE_DIR/sql-init"
echo "==> Creando directorio $SQL_INIT_DIR..."
mkdir -p "$SQL_INIT_DIR"                   # no da error si ya existe :contentReference[oaicite:5]{index=5}

# 2. Generar create_tables.sql con la definición de la tabla reservas
INIT_SQL="$SQL_INIT_DIR/create_tables.sql"
echo "==> Generando $INIT_SQL..."
cat > "$INIT_SQL" << 'EOF'
-- init.sql: Creación de tablas y datos para honeypot

CREATE TABLE IF NOT EXISTS reservas (
  id       INT         AUTO_INCREMENT PRIMARY KEY,
  nombre   VARCHAR(100) NOT NULL,
  fecha    DATE        NOT NULL,
  hora     TIME        NOT NULL,
  personas INT         NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS platos (
  id           INT           AUTO_INCREMENT PRIMARY KEY,
  nombre       VARCHAR(255)  NOT NULL,
  ingredientes TEXT          NOT NULL
) ENGINE=InnoDB;

INSERT INTO platos (nombre, ingredientes) VALUES
  ('Pizza Napoletana',     'Harina, agua, levadura, sal, tomate, mozzarella, albahaca'),
  ('Rendang',              'Carne de res, leche de coco, chalotas, ajo, jengibre, galanga, chiles, cilantro, cúrcuma'),
  ('Dan Dan Noodles',      'Fideos, cerdo picado, aceite de chile, cacahuetes, cebolla verde, ajo, pasta de sésamo'),
  ('Boiled Maine Lobster', 'Langosta, agua, sal, mantequilla, limón'),
  ('Cacio e Pepe',         'Pasta, queso pecorino romano, pimienta negra'),
  ('Pozole',               'Maíz pozolero, carne de cerdo, chiles, lechuga, rábano, orégano, limón'),
  ('Milanesa Napolitana',  'Filete empanado, jamón, queso, salsa de tomate'),
  ('Tom Kha Gai',          'Pechuga de pollo, leche de coco, galanga, hojas de lima kafir, chile, citronela'),
  ('Pho',                  'Fideos de arroz, caldo de carne, carne de res, jengibre, anís estrellado, cilantro'),
  ('Bibimbap',             'Arroz, vegetales variados, carne de res, huevo, pasta de chile'),
  ('Tacos al Pastor',      'Tortillas, carne de cerdo marinada, piña, cebolla, cilantro'),
  ('Sushi Roll',           'Arroz para sushi, alga nori, pescado crudo, vinagre de arroz'),
  ('Paella Valenciana',    'Arroz, pollo, conejo, judías verdes, garrofón, azafrán'),
  ('Coq au Vin',           'Pollo, vino tinto, champiñones, tocino, cebolla, ajo'),
  ('Gyoza',                'Masa para empanadilla, cerdo picado, col, ajo, jengibre, salsa de soja'),
  ('Shakshuka',            'Tomate, pimiento, cebolla, huevo, comino, pimentón'),
  ('Borscht',              'Remolacha, repollo, zanahoria, patata, carne de res, crema agria'),
  ('Feijoada',             'Frijoles negros, carne de cerdo, arroz, naranja, col'),
  ('Pad Thai',             'Fideos de arroz, tofu, huevo, brotes de soja, cacahuetes, tamarindo'),
  ('Moussaka',             'Berenjena, carne de cordero, tomate, bechamel, queso');


EOF
echo "==> Fichero $INIT_SQL generado."
