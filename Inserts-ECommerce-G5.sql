-- Categorías
INSERT INTO Categoria VALUES (1, 'Tecnología'), (2, 'Electrodomésticos'), (3, 'Juguetes');

-- Métodos de pago
INSERT INTO MetodoPago VALUES 
(1, 'Tarjeta de crédito'),
(2, 'Tarjeta de débito'),
(3, 'Pago Fácil'),
(4, 'Rapipago');

-- Métodos de envío
INSERT INTO Envio VALUES 
(1, 'OCA', 1200),
(2, 'Correo Argentino', 900);

-- Usuarios (con diferentes niveles)
INSERT INTO Usuario VALUES
(10000001, 'Ana', 'Pérez', 'Calle Falsa 123', '1990-04-15', NULL, 0, 0, 0),
(10000002, 'Luis', 'Gómez', 'Av. Siempreviva 742', '1985-06-10', 'Normal', 5000, 3, 75),
(10000003, 'María', 'López', 'Av. Corrientes 800', '1992-01-22', 'Platinum', 120000, 7, 90),
(10000004, 'Carlos', 'Fernández', 'Belgrano 200', '1980-11-05', 'Gold', 1050000, 12, 95),
(10000005, 'Julián', 'Mendoza', 'Sarmiento 350', '2000-07-08', NULL, 0, 0, 0); -- Comprador

-- Productos
INSERT INTO Producto VALUES
(1, 'Smartphone X', 'Teléfono gama alta', 150000, 1),
(2, 'Licuadora Turbo', 'Licuadora de 1000W', 30000, 2),
(3, 'Muñeco Articulado', 'Muñeco de colección', 15000, 3);

-- Publicaciones (algunas con subasta, otras con venta directa)
INSERT INTO Publicacion VALUES
(1, 'Último modelo', 150000, 'Platino', 'Finalizada', 10000002, 1, 1, "2025-04-23"),
(2, 'Potente y silenciosa', 30000, 'Oro', 'Activa', 10000003, 2, 2, "2024-12-20"),
(3, 'Muñeco raro', 15000, 'Plata', 'Activa', 10000004, 3, 3, "2025-06-03");

-- Venta directa (solo una concretada)
INSERT INTO VentaDirecta VALUES
(1, 150000, 90, 85, 1, 10000005, 1, 1);

-- Respuestas
INSERT INTO Respuestas VALUES
(1, 'Sí, es nuevo en caja.', '2025-06-01'),
(2, 'Tiene 6 velocidades.', '2025-06-02');

-- Preguntas
INSERT INTO Preguntas VALUES
(1, '¿Está nuevo?', 10000005, 2, 1, '2025-05-31'),
(2, '¿Cuántas velocidades tiene?', 10000005, 2, 2, '2025-06-01');

-- Subasta (asociada a publicación 3)
INSERT INTO Subasta VALUES
(1, 15000, 3, '2025-06-10 23:59:59');

-- Ofertas
INSERT INTO Oferta VALUES
(1, 15500, '2025-06-06 14:00:00', 10000005, 1),
(2, 16000, '2025-06-06 15:00:00', 10000003, 1);
