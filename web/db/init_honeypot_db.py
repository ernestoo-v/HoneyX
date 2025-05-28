#!/usr/bin/env python3
# init_honeypot_db.py
import sqlite3
from datetime import datetime

DB_FILE = "honeypot_restaurante.db"
conn = sqlite3.connect(DB_FILE)
c = conn.cursor()

# ────────────────────── Empleados ──────────────────────
c.execute("""
CREATE TABLE empleados (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre          TEXT,
    apellido        TEXT,
    puesto          TEXT,
    direccion       TEXT,
    telefono        TEXT,
    email           TEXT,
    cuenta_bancaria TEXT,
    fecha_nacimiento TEXT
)
""")

empleados = [
    ("Antonio", "Martínez", "admin",   "C/ Mayor 12, Madrid",   "612345678", "antonio.admin@restaurante.com",  "ES2321000418450200051332", "1980-01-15"),
    ("Lucía",   "Gómez",     "jefe",    "Av. América 7, Valencia","611222333", "lucia.jefe@restaurante.com",     "ES9100491500052712345678", "1975-04-20"),
    ("Javier",  "Ruiz",      "cocinero","C/ Sol 45, Sevilla",    "656789123", "javier.cocina@restaurante.com",  "ES1122334455667788990011", "1985-12-08"),
    ("Sara",    "López",     "ventas",  "Pº Castellana 89, Madrid","687654321","sara.ventas@restaurante.com",    "ES9876543210123456789000", "1990-09-30"),
    ("Marta",   "Fernández", "camarero","C/ Luna 5, Barcelona",  "677889900", "marta.fernandez@restaurante.com", "ES1234567890123456789012", "1993-07-25"),
    ("Carlos",  "Sánchez",   "camarero","C/ Fresa 2, Málaga",    "698745632", "carlos.sanchez@restaurante.com", "ES9999000011112222333344", "1991-03-14"),
    ("Elena",   "Torres",    "camarera","C/ Goya 11, Madrid",    "655443322", "elena.torres@restaurante.com",   "ES5566778899001122334455", "1995-02-28"),
    ("Pablo",   "Romero",    "camarero","C/ Valle 23, Bilbao",   "688112233", "pablo.romero@restaurante.com",   "ES7788990011223344556677", "1989-11-10"),
    ("Sandra",  "Moreno",    "camarera","Av. Libertad 8, Granada","699887766", "sandra.moreno@restaurante.com",  "ES3344556677889900112233", "1997-06-19"),
    ("Diego",   "Navarro",   "camarero","C/ Prado 14, Zaragoza", "677788899", "diego.navarro@restaurante.com",  "ES6677889900112233445566", "1994-10-05"),
    ("Alba",    "Jiménez",   "camarera","C/ Río 9, Oviedo",      "690112244", "alba.jimenez@restaurante.com",   "ES4455667788990011223344", "1996-05-13"),
    ("Raúl",    "Herrera",   "camarero","C/ Solana 6, Murcia",   "691234567", "raul.herrera@restaurante.com",   "ES2233445566778899001122", "1992-08-22"),
    ("Eva",     "Serrano",   "camarera","C/ Cielo 10, Alicante", "692345678", "eva.serrano@restaurante.com",    "ES1100223344556677889900", "1998-12-01"),
    ("Rubén",   "Vega",      "camarero","Av. Europa 16, Valladolid","693456789","ruben.vega@restaurante.com",   "ES3344556677889900112233", "1993-04-30"),
]
c.executemany("""
INSERT INTO empleados (nombre, apellido, puesto, direccion, telefono, email,
                       cuenta_bancaria, fecha_nacimiento)
VALUES (?, ?, ?, ?, ?, ?, ?, ?)
""", empleados)

# ────────────────────── Usuarios ──────────────────────
c.execute("""
CREATE TABLE usuarios (
    id       INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT,
    email    TEXT,
    password TEXT,      -- ¡texto plano intencionado para el honeypot!
    rol      TEXT       -- admin | jefe | ventas | cliente
)
""")

usuarios = [
    ("admin",   "admin@restaurante.com",   "admin123",   "admin"),
    ("jefe",    "jefe@restaurante.com",    "jefe123",    "jefe"),
    ("ventas",  "ventas@restaurante.com",  "ventas123",  "ventas"),
] + [
    (f"user{i}", f"user{i}@email.com", f"user{i}pass", "cliente")
    for i in range(1, 11)
]
c.executemany("INSERT INTO usuarios (username, email, password, rol) VALUES (?, ?, ?, ?)", usuarios)

# ────────────────────── Platos ──────────────────────
c.execute("""
CREATE TABLE platos (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre      TEXT,
    descripcion TEXT,
    precio      REAL,
    imagen_url  TEXT
)
""")
platos = [
    ("Paella Valenciana",     "Arroz con pollo, conejo y verduras",        13.50, "/img/paella.jpg"),
    ("Tortilla de Patatas",   "Clásica tortilla de patatas española",       7.00, "/img/tortilla.jpg"),
    ("Gazpacho Andaluz",      "Sopa fría de tomate y verduras",             6.00, "/img/gazpacho.jpg"),
    ("Croquetas de Jamón",    "Croquetas cremosas de jamón",                5.50, "/img/croquetas.jpg"),
    ("Pulpo a la Gallega",    "Pulpo con pimentón y aceite de oliva",      16.00, "/img/pulpo.jpg"),
    ("Ensaladilla Rusa",      "Ensalada fría de patata y mayonesa",         5.00, "/img/ensaladilla.jpg"),
    ("Salmorejo",             "Crema fría de tomate y pan",                 6.50, "/img/salmorejo.jpg"),
    ("Huevos Rotos",          "Huevos fritos con patatas y jamón",          8.50, "/img/huevos.jpg"),
    ("Calamares a la Romana", "Calamares rebozados y fritos",               9.00, "/img/calamares.jpg"),
    ("Patatas Bravas",        "Patatas con salsa picante",                  4.50, "/img/bravas.jpg"),
    ("Albóndigas en Salsa",   "Albóndigas de carne con salsa",              8.00, "/img/albondigas.jpg"),
    ("Pollo al Ajillo",       "Pollo frito con ajo",                       10.00, "/img/pollo.jpg"),
    ("Gambas al Ajillo",      "Gambas salteadas con ajo",                  12.00, "/img/gambas.jpg"),
    ("Pisto Manchego",        "Salteado de verduras con tomate",            7.50, "/img/pisto.jpg"),
    ("Empanada Gallega",      "Masa rellena de atún y verduras",            6.50, "/img/empanada.jpg"),
    ("Fabada Asturiana",      "Guiso de fabes con embutido",               14.00, "/img/fabada.jpg"),
    ("Cocido Madrileño",      "Guiso de garbanzos y carne",                15.00, "/img/cocido.jpg"),
    ("Rabo de Toro",          "Estofado de rabo de toro",                  18.00, "/img/rabo.jpg"),
    ("Merluza a la Vasca",    "Merluza con salsa verde",                   13.00, "/img/merluza.jpg"),
    ("Churros con Chocolate", "Masa frita con chocolate caliente",          4.00, "/img/churros.jpg"),
]
c.executemany("INSERT INTO platos (nombre, descripcion, precio, imagen_url) VALUES (?, ?, ?, ?)", platos)

# ────────────────────── Ventas ──────────────────────
c.execute("""
CREATE TABLE ventas (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario_id  INTEGER,
    plato_id    INTEGER,
    fecha       TEXT,
    cantidad    INTEGER,
    total       REAL,
    metodo_pago TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (plato_id)   REFERENCES platos(id)
)
""")
ventas = [
    (1,  1,  "2024-05-01 13:00", 2, 27.00, "tarjeta"),
    (2,  3,  "2024-05-02 14:30", 1,  6.00, "efectivo"),
    (3,  5,  "2024-05-03 20:15", 3, 48.00, "tarjeta"),
    (4,  2,  "2024-05-04 21:00", 1,  7.00, "tarjeta"),
    (5, 10,  "2024-05-05 12:45", 2,  9.00, "tarjeta"),
    (6, 12,  "2024-05-06 13:30", 1, 10.00, "efectivo"),
    (7,  8,  "2024-05-07 15:00", 2, 17.00, "tarjeta"),
    (8,  6,  "2024-05-08 14:20", 1,  5.00, "tarjeta"),
    (9, 14,  "2024-05-09 19:00", 1,  7.50, "tarjeta"),
    (10, 19, "2024-05-10 21:30", 4, 52.00, "efectivo"),
]
c.executemany("""
INSERT INTO ventas (usuario_id, plato_id, fecha, cantidad, total, metodo_pago)
VALUES (?, ?, ?, ?, ?, ?)
""", ventas)

# ────────────────────── Valoraciones ──────────────────────
c.execute("""
CREATE TABLE valoraciones (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario_id  INTEGER,
    plato_id    INTEGER,
    puntuacion  INTEGER,
    comentario  TEXT,
    fecha       TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (plato_id)   REFERENCES platos(id)
)
""")
valoraciones = [
    (1,  1, 5, "La paella estaba espectacular, repetiré seguro",   "2024-05-01"),
    (2,  3, 4, "Gazpacho fresco y delicioso",                      "2024-05-02"),
    (3,  5, 5, "El pulpo estaba en su punto",                      "2024-05-03"),
    (4, 10, 3, "Patatas bravas ricas pero poco picantes",          "2024-05-04"),
    (5,  7, 4, "El salmorejo muy sabroso",                         "2024-05-05"),
    (6, 14, 5, "Pisto muy recomendable",                           "2024-05-06"),
    (7, 19, 2, "La merluza estaba un poco seca",                   "2024-05-07"),
    (8, 18, 5, "Rabo de toro exquisito",                           "2024-05-08"),
    (9, 20, 5, "Churros perfectos para terminar la comida",        "2024-05-09"),
    (10, 8, 3, "Huevos rotos bien, pero faltaba jamón",            "2024-05-10"),
]
c.executemany("""
INSERT INTO valoraciones (usuario_id, plato_id, puntuacion, comentario, fecha)
VALUES (?, ?, ?, ?, ?)
""", valoraciones)

# ────────────────────── Reservas ──────────────────────
c.execute("""
CREATE TABLE reservas (
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre    TEXT,
    telefono  TEXT,
    fecha     TEXT,   -- 'YYYY-MM-DD'
    hora      TEXT,   -- 'HH:MM'
    personas  INTEGER,
    mensaje   TEXT
)
""")

reservas = [
    ("María López",  "600111222", "2024-06-01", "14:00", 4, "Mesa cerca de la ventana"),
    ("Carlos García","600333444", "2024-06-02", "21:00", 2, "Celebramos aniversario"),
]
c.executemany("""
INSERT INTO reservas (nombre, telefono, fecha, hora, personas, mensaje)
VALUES (?, ?, ?, ?, ?, ?)
""", reservas)

# ────────────────────── Finalizar ──────────────────────
conn.commit()
conn.close()

print(f"{datetime.now():%H:%M:%S} - Base de datos creada y poblada correctamente.")
