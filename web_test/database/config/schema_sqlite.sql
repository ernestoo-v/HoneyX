-- Categorías de platos
CREATE TABLE IF NOT EXISTS categorias (
  id       INTEGER PRIMARY KEY AUTOINCREMENT,
  nombre   TEXT UNIQUE NOT NULL
);

-- Platos
CREATE TABLE IF NOT EXISTS menu_items (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  nombre       TEXT  NOT NULL,
  descripcion  TEXT,
  precio       REAL  NOT NULL,
  imagen_url   TEXT,
  categoria_id INTEGER NOT NULL,
  FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

-- Especial del día
CREATE TABLE IF NOT EXISTS especiales (
  fecha        DATE PRIMARY KEY,
  menu_item_id INTEGER NOT NULL,
  FOREIGN KEY (menu_item_id) REFERENCES menu_items(id)
);

-- Reservas
CREATE TABLE IF NOT EXISTS reservas (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  nombre      TEXT NOT NULL,
  email       TEXT NOT NULL,
  telefono    TEXT NOT NULL,
  fecha       DATE NOT NULL,
  hora        TIME NOT NULL,
  comensales  INTEGER NOT NULL,
  mensaje     TEXT,
  estado      TEXT NOT NULL DEFAULT 'pendiente'  -- nueva columna
               CHECK (estado IN ('pendiente','confirmada','cancelada')),
  creado      TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Valoraciones
CREATE TABLE IF NOT EXISTS valoraciones (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  menu_item_id INTEGER NOT NULL,
  puntuacion   INTEGER NOT NULL CHECK (puntuacion BETWEEN 1 AND 5),
  comentario   TEXT,
  creado       TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (menu_item_id) REFERENCES menu_items(id)
);

-- Empleados
CREATE TABLE IF NOT EXISTS empleados (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  nombre      TEXT NOT NULL,
  puesto      TEXT NOT NULL,
  contratado  DATE NOT NULL
);

-- Índice para reservas por fecha-hora
CREATE INDEX IF NOT EXISTS idx_reserva_fecha_hora
          ON reservas(fecha, hora);
