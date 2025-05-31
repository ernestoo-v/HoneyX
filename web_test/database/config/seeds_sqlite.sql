/*  web_test/seeds_big.sql
    Poblado masivo para el honeypot – SQLite3                      */

BEGIN TRANSACTION;

/*-----------------------------------------------------------------
  1. CATEGORÍAS
-----------------------------------------------------------------*/
INSERT OR IGNORE INTO categorias (id,nombre) VALUES
  (1,'Entrantes'),
  (2,'Platos principales'),
  (3,'Postres'),
  (4,'Bebidas'),
  (5,'Pizzas'),
  (6,'Ensaladas');

/*-----------------------------------------------------------------
  2. PLATOS (60 registros)
-----------------------------------------------------------------*/
INSERT INTO menu_items (nombre,descripcion,precio,imagen_url,categoria_id) VALUES
-- Entrantes (10)
('Gazpacho andaluz','Sopa fría de tomate, pepino y pimiento',4.20,'img/gazpacho.jpg',1),
('Croquetas jamón','Bechamel casera con jamón ibérico',5.80,'img/croquetas.jpg',1),
('Patatas bravas','Con salsa picante y alioli',4.50,'img/bravas.jpg',1),
('Calamares a la andaluza','Rebozados y fritos, con limón',7.90,'img/calamares.jpg',1),
('Huevos rotos','Con jamón y patatas',6.40,'img/huevos_rotos.jpg',1),
('Tabla de quesos','Selección artesanal nacional',9.50,'img/tabla_quesos.jpg',1),
('Ensaladilla rusa','Receta tradicional',4.90,'img/ensaladilla.jpg',1),
('Mejillones al vapor','Con limón y laurel',6.20,'img/mejillones.jpg',1),
('Berenjena frita','Con miel de caña',5.30,'img/berenjena.jpg',1),
('Tosta de sardina ahumada','Sobre pan de centeno',5.10,'img/tosta_sardina.jpg',1),

-- Platos principales (12)
('Paella mixta','Arroz con marisco y pollo',14.50,'img/paella.jpg',2),
('Bacalao al pil-pil','Con ajo y guindilla',13.90,'img/bacalao.jpg',2),
('Entrecot de ternera','250 g, parrilla carbón',17.80,'img/entrecot.jpg',2),
('Pollo al curry','Con arroz basmati',11.60,'img/pollo_curry.jpg',2),
('Hamburguesa gourmet','Pan brioche, cheddar y bacon',10.90,'img/burger.jpg',2),
('Costillas BBQ','Ahumadas 6 h, salsa casera',15.40,'img/costillas.jpg',2),
('Merluza a la vasca','Con almejas y espárragos',13.20,'img/merluza.jpg',2),
('Fajitas de ternera','Con guacamole y pico de gallo',12.10,'img/fajitas.jpg',2),
('Ramen de cerdo','Caldo tonkotsu 12 h',12.80,'img/ramen.jpg',2),
('Curry de garbanzos','Opción vegana',9.90,'img/curry_vegano.jpg',2),
('Solomillo al foie','Reducción PX',18.90,'img/solomillo.jpg',2),
('Pulpo a la gallega','Sobre cachelos',15.60,'img/pulpo.jpg',2),

-- Postres (8 más los 2 que ya tenías = 10)
('Brownie nueces','Con helado de vainilla',5.20,'img/brownie.jpg',3),
('Crème brûlée','Caramelizada al momento',4.80,'img/creme_brulee.jpg',3),
('Coulant de chocolate','Centro líquido',5.50,'img/coulant.jpg',3),
('Panna cotta','Con coulis de mango',4.60,'img/pannacotta.jpg',3),
('Helado artesanal','Dos bolas a elegir',4.00,'img/helado.jpg',3),
('Flan casero','Con nata montada',3.90,'img/flan.jpg',3),
('Apple pie','Tarta caliente, canela',4.70,'img/apple_pie.jpg',3),
('Natillas','Con galleta María',3.60,'img/natillas.jpg',3),

-- Bebidas (10)
('Café espresso','100 % Arábica',1.50,'img/espresso.jpg',4),
('Capuchino','Con espuma cremosa',2.20,'img/capuchino.jpg',4),
('Té verde','Orgánico',1.80,'img/te_verde.jpg',4),
('Refresco cola','33 cl',2.00,'img/cola.jpg',4),
('Zumo naranja','Natural exprimido',2.90,'img/zumo.jpg',4),
('Cerveza rubia','33 cl',2.50,'img/cerveza.jpg',4),
('Cerveza tostada','33 cl',2.70,'img/cerveza_tostada.jpg',4),
('Agua mineral','50 cl',1.20,'img/agua.jpg',4),
('Vino tinto Rioja','Copa',3.50,'img/vino_tinto.jpg',4),
('Vino blanco Rueda','Copa',3.30,'img/vino_blanco.jpg',4),

-- Pizzas (5)
('Pizza Margherita','Tomate, mozzarella y albahaca',8.90,'img/pizza_margherita.jpg',5),
('Pizza Pepperoni','Extra pepperoni y queso',9.80,'img/pizza_pepperoni.jpg',5),
('Pizza Cuatro Quesos','Mozzarella, gorgonzola, parmesano y emmental',10.20,'img/pizza_4quesos.jpg',5),
('Pizza Vegetal','Verduras a la parrilla',9.50,'img/pizza_vegetal.jpg',5),
('Calzone','Rellena de jamón y champiñones',10.00,'img/calzone.jpg',5),

-- Ensaladas (5)
('Ensalada griega','Feta, aceitunas y pepino',7.20,'img/ensalada_griega.jpg',6),
('Ensalada quinoa','Quinoa, aguacate y tomate cherry',7.80,'img/ensalada_quinoa.jpg',6),
('Ensalada caprese','Mozzarella, tomate y pesto',7.50,'img/ensalada_caprese.jpg',6),
('Ensalada de mango','Mango, rúcula y nueces',7.60,'img/ensalada_mango.jpg',6),
('Ensalada César vegana','Heura y aliño vegano',8.10,'img/ensalada_cesar_veg.jpg',6);

/*-----------------------------------------------------------------
  3. ESPECIALES DEL DÍA (7 días a partir de hoy)
-----------------------------------------------------------------*/
INSERT OR REPLACE INTO especiales (fecha, menu_item_id)
VALUES
  (DATE('now','localtime', '+0 day'),
   (SELECT id FROM menu_items WHERE nombre='Paella mixta' LIMIT 1)),
  (DATE('now','localtime', '+1 day'),
   (SELECT id FROM menu_items WHERE nombre='Entrecot de ternera' LIMIT 1)),
  (DATE('now','localtime', '+2 day'),
   (SELECT id FROM menu_items WHERE nombre='Pizza Cuatro Quesos' LIMIT 1)),
  (DATE('now','localtime', '+3 day'),
   (SELECT id FROM menu_items WHERE nombre='Ramen de cerdo' LIMIT 1)),
  (DATE('now','localtime', '+4 day'),
   (SELECT id FROM menu_items WHERE nombre='Pulpo a la gallega' LIMIT 1)),
  (DATE('now','localtime', '+5 day'),
   (SELECT id FROM menu_items WHERE nombre='Curry de garbanzos' LIMIT 1)),
  (DATE('now','localtime', '+6 day'),
   (SELECT id FROM menu_items WHERE nombre='Brownie nueces' LIMIT 1));

/*-----------------------------------------------------------------
  4. EMPLEADOS (12)
-----------------------------------------------------------------*/
INSERT INTO empleados (nombre,puesto,contratado) VALUES
('Laura Gómez','Gerente','2021-03-15'),
('Iván Martín','Chef Ejecutivo','2020-06-01'),
('Sara López','Jefa de sala','2022-01-10'),
('Miguel Torres','Cocinero','2023-02-20'),
('Ana Ruiz','Cocinera','2024-04-05'),
('Pedro Díaz','Camarero','2023-09-12'),
('Lucía Castillo','Camarera','2023-11-30'),
('Óscar Vidal','Camarero','2024-02-18'),
('Marta Navarro','Repostera','2022-07-22'),
('Erik Sánchez','Barman','2021-12-03'),
('Diana Morales','Administración','2020-10-14'),
('Elena Roca','Marketing','2024-01-09');

/*-----------------------------------------------------------------
  5. RESERVAS (30 aleatorias)
-----------------------------------------------------------------*/
INSERT INTO reservas (nombre,email,telefono,fecha,hora,comensales,mensaje,estado) VALUES
('Carlos Pérez','carlos@example.com','600111222','2025-05-27','20:30',4,'Mesa terraza','confirmada'),
('Beatriz Alonso','bea@example.com','600333444','2025-05-27','21:00',2,'Aniversario','confirmada'),
('Luis García','luis@example.com','600555666','2025-05-28','14:00',3,'','pendiente'),
('Nuria Ramos','nuria@example.com','600777888','2025-05-28','15:00',6,'Cumpleaños','confirmada'),
('Alberto Vidal','alberto@example.com','600999111','2025-05-29','13:30',1,'Vegano','pendiente'),
('Patricia León','patri@example.com','600112233','2025-05-29','20:00',5,'Trona bebé','confirmada'),
('Sergio Mora','sergio@example.com','600221133','2025-05-30','21:15',2,'Ventana','pendiente'),
('Celia Núñez','celia@example.com','600334455','2025-05-30','22:00',4,'','pendiente'),
('Rafael Ibáñez','rafi@example.com','600445566','2025-05-31','14:30',3,'Sin gluten','confirmada'),
('Julia Ortiz','julia@example.com','600556677','2025-05-31','15:00',7,'Recolecta tarta','confirmada'),
('Pablo Vega','pvega@example.com','600667788','2025-06-01','20:45',2,'','pendiente'),
('Isabel Cano','isa@example.com','600778899','2025-06-01','21:30',2,'','confirmada'),
('Andrés Bravo','andres@example.com','600889900','2025-06-02','14:10',5,'Empresa','confirmada'),
('Eva Marín','eva@example.com','600990011','2025-06-02','15:20',2,'Vegana','pendiente'),
('Gonzalo Lara','gon@example.com','600101112','2025-06-03','20:00',6,'Cumple 18','confirmada'),
('Teresa Pons','teresa@example.com','600131415','2025-06-03','20:30',3,'','pendiente'),
('Diego Ferrer','diego@example.com','600141516','2025-06-03','21:00',2,'','pendiente'),
('Yolanda Fdez','yoli@example.com','600151617','2025-06-04','13:45',4,'','confirmada'),
('Jorge Crespo','jorge@example.com','600161718','2025-06-04','14:30',2,'','confirmada'),
('Rosa Benítez','rosa@example.com','600171819','2025-06-05','20:10',8,'Despedida','confirmada'),
('Mario Ríos','mario@example.com','600181920','2025-06-05','21:40',2,'','pendiente'),
('Lorena Sáez','lorena@example.com','600192021','2025-06-05','22:10',2,'','pendiente'),
('Alejandro Gil','alex@example.com','600202122','2025-06-06','14:25',5,'','pendiente'),
('Helena Solé','helena@example.com','600212223','2025-06-06','15:00',3,'','confirmada'),
('Víctor Pozo','victor@example.com','600222324','2025-06-06','21:00',2,'','pendiente'),
('Natalia Fdez','nat@example.com','600232425','2025-06-07','20:30',4,'Sin lactosa','confirmada'),
('José Prada','jprada@example.com','600242526','2025-06-07','21:15',2,'Balcony','pendiente'),
('Irene Vidal','irene@example.com','600252627','2025-06-07','22:00',2,'','pendiente'),
('Tomás Riera','tomas@example.com','600262728','2025-06-08','14:00',6,'Graduación','confirmada'),
('Raquel Campo','raquel@example.com','600272829','2025-06-08','15:30',2,'','pendiente');

/* ================================================================
   VALORACIONES – 90 filas (3 por plato, 30 platos) – SQLite
   ================================================================ */


INSERT INTO valoraciones (menu_item_id, puntuacion, comentario)

-- 1  Paella mixta
SELECT id,5,'Auténtica, sabor brutal' FROM menu_items WHERE nombre='Paella mixta' UNION ALL
SELECT id,4,'Muy buena, algo salada'  FROM menu_items WHERE nombre='Paella mixta' UNION ALL
SELECT id,5,'Repetiría sin dudar'     FROM menu_items WHERE nombre='Paella mixta' UNION ALL

-- 2  Entrecot de ternera
SELECT id,5,'Punto perfecto'          FROM menu_items WHERE nombre='Entrecot de ternera' UNION ALL
SELECT id,4,'Jugoso y sabroso'        FROM menu_items WHERE nombre='Entrecot de ternera' UNION ALL
SELECT id,4,'Un pelín caro'           FROM menu_items WHERE nombre='Entrecot de ternera' UNION ALL

-- 3  Brownie nueces
SELECT id,5,'Chocolate top'           FROM menu_items WHERE nombre='Brownie nueces' UNION ALL
SELECT id,5,'Postre imprescindible'   FROM menu_items WHERE nombre='Brownie nueces' UNION ALL
SELECT id,4,'Un poco dulce de más'    FROM menu_items WHERE nombre='Brownie nueces' UNION ALL

-- 4  Gazpacho andaluz
SELECT id,5,'Refrescante y ligero'    FROM menu_items WHERE nombre='Gazpacho andaluz' UNION ALL
SELECT id,4,'Buenísimo, faltó hielo'  FROM menu_items WHERE nombre='Gazpacho andaluz' UNION ALL
SELECT id,4,'Ideal para el calor'     FROM menu_items WHERE nombre='Gazpacho andaluz' UNION ALL

-- 5  Croquetas jamón
SELECT id,4,'Bechamel cremosa'        FROM menu_items WHERE nombre='Croquetas jamón' UNION ALL
SELECT id,4,'Ricas pero pocas'        FROM menu_items WHERE nombre='Croquetas jamón' UNION ALL
SELECT id,3,'Mejor muy calientes'     FROM menu_items WHERE nombre='Croquetas jamón' UNION ALL

-- 6  Lasaña boloñesa
SELECT id,5,'Como la de la nona'      FROM menu_items WHERE nombre='Lasaña boloñesa' UNION ALL
SELECT id,4,'Salsa deliciosa'         FROM menu_items WHERE nombre='Lasaña boloñesa' UNION ALL
SELECT id,4,'Ración generosa'         FROM menu_items WHERE nombre='Lasaña boloñesa' UNION ALL

-- 7  Risotto de setas
SELECT id,5,'Al dente perfecto'       FROM menu_items WHERE nombre='Risotto de setas' UNION ALL
SELECT id,4,'Muy aromático'           FROM menu_items WHERE nombre='Risotto de setas' UNION ALL
SELECT id,4,'Un poco líquido'         FROM menu_items WHERE nombre='Risotto de setas' UNION ALL

-- 8  Pizza Pepperoni
SELECT id,5,'Picante en su punto'     FROM menu_items WHERE nombre='Pizza Pepperoni' UNION ALL
SELECT id,4,'Masa crujiente'          FROM menu_items WHERE nombre='Pizza Pepperoni' UNION ALL
SELECT id,4,'Repetiría seguro'        FROM menu_items WHERE nombre='Pizza Pepperoni' UNION ALL

-- 9  Cerveza rubia
SELECT id,4,'Muy fría, genial'        FROM menu_items WHERE nombre='Cerveza rubia' UNION ALL
SELECT id,4,'Buena espuma'            FROM menu_items WHERE nombre='Cerveza rubia' UNION ALL
SELECT id,5,'Ideal con las tapas'     FROM menu_items WHERE nombre='Cerveza rubia' UNION ALL

--10  Tiramisú
SELECT id,5,'Exquisito, suave'        FROM menu_items WHERE nombre='Tiramisú' UNION ALL
SELECT id,5,'Equilibrio perfecto'     FROM menu_items WHERE nombre='Tiramisú' UNION ALL
SELECT id,4,'Me faltó más café'       FROM menu_items WHERE nombre='Tiramisú' UNION ALL

--11  Curry de garbanzos
SELECT id,5,'Vegano top'              FROM menu_items WHERE nombre='Curry de garbanzos' UNION ALL
SELECT id,4,'Toque especiado suave'   FROM menu_items WHERE nombre='Curry de garbanzos' UNION ALL
SELECT id,4,'Ración abundante'        FROM menu_items WHERE nombre='Curry de garbanzos' UNION ALL

--12  Pulpo a la gallega
SELECT id,5,'Tiernísimo'              FROM menu_items WHERE nombre='Pulpo a la gallega' UNION ALL
SELECT id,5,'Pimentón de calidad'     FROM menu_items WHERE nombre='Pulpo a la gallega' UNION ALL
SELECT id,4,'Cachelos ok'             FROM menu_items WHERE nombre='Pulpo a la gallega' UNION ALL

--13  Merluza a la vasca
SELECT id,4,'Buen punto de cocción'   FROM menu_items WHERE nombre='Merluza a la vasca' UNION ALL
SELECT id,4,'Salsa rica'              FROM menu_items WHERE nombre='Merluza a la vasca' UNION ALL
SELECT id,3,'Un pelín seca'           FROM menu_items WHERE nombre='Merluza a la vasca' UNION ALL

--14  Fajitas de ternera
SELECT id,4,'Carne sabrosa'           FROM menu_items WHERE nombre='Fajitas de ternera' UNION ALL
SELECT id,4,'Guacamole top'           FROM menu_items WHERE nombre='Fajitas de ternera' UNION ALL
SELECT id,3,'Algo picantes'           FROM menu_items WHERE nombre='Fajitas de ternera' UNION ALL

--15  Pizza Vegetal
SELECT id,3,'Le falta queso'          FROM menu_items WHERE nombre='Pizza Vegetal' UNION ALL
SELECT id,4,'Verduras frescas'        FROM menu_items WHERE nombre='Pizza Vegetal' UNION ALL
SELECT id,4,'Masa ligera'             FROM menu_items WHERE nombre='Pizza Vegetal' UNION ALL

--16  Ensalada quinoa
SELECT id,5,'Sana y rica'             FROM menu_items WHERE nombre='Ensalada quinoa' UNION ALL
SELECT id,4,'Me encantó el aguacate'  FROM menu_items WHERE nombre='Ensalada quinoa' UNION ALL
SELECT id,4,'Gran opción vegana'      FROM menu_items WHERE nombre='Ensalada quinoa' UNION ALL

--17  Helado artesanal
SELECT id,5,'Chocolate espectacular'  FROM menu_items WHERE nombre='Helado artesanal' UNION ALL
SELECT id,4,'Textura cremosa'         FROM menu_items WHERE nombre='Helado artesanal' UNION ALL
SELECT id,5,'Ración generosa'         FROM menu_items WHERE nombre='Helado artesanal' UNION ALL

--18  Costillas BBQ
SELECT id,4,'Muy jugosas'             FROM menu_items WHERE nombre='Costillas BBQ' UNION ALL
SELECT id,5,'Salsa brutal'            FROM menu_items WHERE nombre='Costillas BBQ' UNION ALL
SELECT id,4,'Carne se despega'        FROM menu_items WHERE nombre='Costillas BBQ' UNION ALL

--19  Hamburguesa gourmet
SELECT id,4,'Pan brioche top'         FROM menu_items WHERE nombre='Hamburguesa gourmet' UNION ALL
SELECT id,4,'Buena carne'             FROM menu_items WHERE nombre='Hamburguesa gourmet' UNION ALL
SELECT id,3,'Patatas flojas'          FROM menu_items WHERE nombre='Hamburguesa gourmet' UNION ALL

--20  Apple pie
SELECT id,5,'Cálida y canela'         FROM menu_items WHERE nombre='Apple pie' UNION ALL
SELECT id,4,'Muy americana'           FROM menu_items WHERE nombre='Apple pie' UNION ALL
SELECT id,4,'Helado aparte OK'        FROM menu_items WHERE nombre='Apple pie' UNION ALL

--21  Capuchino
SELECT id,5,'Espuma perfecta'         FROM menu_items WHERE nombre='Capuchino' UNION ALL
SELECT id,4,'Bien de temperatura'     FROM menu_items WHERE nombre='Capuchino' UNION ALL
SELECT id,4,'Aroma intenso'           FROM menu_items WHERE nombre='Capuchino' UNION ALL

--22  Zumo naranja
SELECT id,5,'Natural recién hecho'    FROM menu_items WHERE nombre='Zumo naranja' UNION ALL
SELECT id,4,'Sin pulpa'               FROM menu_items WHERE nombre='Zumo naranja' UNION ALL
SELECT id,4,'Un poco caro'            FROM menu_items WHERE nombre='Zumo naranja' UNION ALL

--23  Café espresso
SELECT id,4,'Buen tueste'             FROM menu_items WHERE nombre='Café espresso' UNION ALL
SELECT id,4,'Correcto tamaño'         FROM menu_items WHERE nombre='Café espresso' UNION ALL
SELECT id,5,'Me despertó al instante' FROM menu_items WHERE nombre='Café espresso' UNION ALL

--24  Bacalao al pil-pil
SELECT id,4,'Aceite en su punto'      FROM menu_items WHERE nombre='Bacalao al pil-pil' UNION ALL
SELECT id,4,'Ligero y sabroso'        FROM menu_items WHERE nombre='Bacalao al pil-pil' UNION ALL
SELECT id,3,'Porción algo pequeña'    FROM menu_items WHERE nombre='Bacalao al pil-pil' UNION ALL

--25  Panna cotta
SELECT id,5,'Suave y ligera'          FROM menu_items WHERE nombre='Panna cotta' UNION ALL
SELECT id,5,'Coulis delicioso'        FROM menu_items WHERE nombre='Panna cotta' UNION ALL
SELECT id,4,'Un poco de más azúcar'   FROM menu_items WHERE nombre='Panna cotta' UNION ALL

--26  Flan casero
SELECT id,4,'Sabor tradicional'       FROM menu_items WHERE nombre='Flan casero' UNION ALL
SELECT id,4,'Nata estupenda'          FROM menu_items WHERE nombre='Flan casero' UNION ALL
SELECT id,3,'Algo compacto'           FROM menu_items WHERE nombre='Flan casero' UNION ALL

--27  Natillas
SELECT id,4,'Con canela genial'       FROM menu_items WHERE nombre='Natillas' UNION ALL
SELECT id,4,'Muy cremosas'            FROM menu_items WHERE nombre='Natillas' UNION ALL
SELECT id,3,'Galleta blandita'        FROM menu_items WHERE nombre='Natillas' UNION ALL

--28  Ensalada griega
SELECT id,5,'Queso feta top'          FROM menu_items WHERE nombre='Ensalada griega' UNION ALL
SELECT id,4,'Fresca y ligera'         FROM menu_items WHERE nombre='Ensalada griega' UNION ALL
SELECT id,4,'Aceitunas deliciosas'    FROM menu_items WHERE nombre='Ensalada griega' UNION ALL

--29  Pizza Margherita
SELECT id,4,'Clásica y rica'          FROM menu_items WHERE nombre='Pizza Margherita' UNION ALL
SELECT id,4,'Masa napolitana'         FROM menu_items WHERE nombre='Pizza Margherita' UNION ALL
SELECT id,3,'Poca albahaca'           FROM menu_items WHERE nombre='Pizza Margherita' UNION ALL

--30  Solomillo al foie
SELECT id,5,'Carne sublime'           FROM menu_items WHERE nombre='Solomillo al foie' UNION ALL
SELECT id,5,'Foie espectacular'       FROM menu_items WHERE nombre='Solomillo al foie' UNION ALL
SELECT id,4,'Vale cada euro'          FROM menu_items WHERE nombre='Solomillo al foie';

COMMIT;
