-- MySQL dump 10.13  Distrib 8.0.42, for Linux (x86_64)
--
-- Host: localhost    Database: EcommerceG5
-- ------------------------------------------------------
-- Server version	8.0.42-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Categoria`
--

DROP TABLE IF EXISTS `Categoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Categoria` (
  `id` int NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Categoria`
--

LOCK TABLES `Categoria` WRITE;
/*!40000 ALTER TABLE `Categoria` DISABLE KEYS */;
INSERT INTO `Categoria` VALUES (1,'Tecnología'),(2,'Electrodomésticos'),(3,'Juguetes'),(4,'ParaProbar');
/*!40000 ALTER TABLE `Categoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Envio`
--

DROP TABLE IF EXISTS `Envio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Envio` (
  `id` int NOT NULL,
  `Empresa` varchar(45) DEFAULT NULL,
  `precio` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Envio`
--

LOCK TABLES `Envio` WRITE;
/*!40000 ALTER TABLE `Envio` DISABLE KEYS */;
INSERT INTO `Envio` VALUES (1,'OCA',1200),(2,'Correo Argentino',900);
/*!40000 ALTER TABLE `Envio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MetodoPago`
--

DROP TABLE IF EXISTS `MetodoPago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MetodoPago` (
  `id` int NOT NULL,
  `tipo` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MetodoPago`
--

LOCK TABLES `MetodoPago` WRITE;
/*!40000 ALTER TABLE `MetodoPago` DISABLE KEYS */;
INSERT INTO `MetodoPago` VALUES (1,'Tarjeta de crédito'),(2,'Tarjeta de débito'),(3,'Pago Fácil'),(4,'Rapipago');
/*!40000 ALTER TABLE `MetodoPago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Oferta`
--

DROP TABLE IF EXISTS `Oferta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Oferta` (
  `id` int NOT NULL,
  `dinero_ofertado` float DEFAULT NULL,
  `hora` datetime DEFAULT NULL,
  `Usuario_dni` int NOT NULL,
  `Subasta_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_Oferta_Usuario1_idx` (`Usuario_dni`),
  KEY `fk_Oferta_Subasta1_idx` (`Subasta_id`),
  CONSTRAINT `fk_Oferta_Subasta1` FOREIGN KEY (`Subasta_id`) REFERENCES `Subasta` (`id`),
  CONSTRAINT `fk_Oferta_Usuario1` FOREIGN KEY (`Usuario_dni`) REFERENCES `Usuario` (`dni`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Oferta`
--

LOCK TABLES `Oferta` WRITE;
/*!40000 ALTER TABLE `Oferta` DISABLE KEYS */;
INSERT INTO `Oferta` VALUES (1,15500,'2025-06-06 14:00:00',10000005,1),(2,16000,'2025-06-06 15:00:00',10000003,1),(8,18000,'2025-06-13 11:10:46',10000001,2);
/*!40000 ALTER TABLE `Oferta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Preguntas`
--

DROP TABLE IF EXISTS `Preguntas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Preguntas` (
  `id` int NOT NULL,
  `ContenidoP` varchar(2500) DEFAULT NULL,
  `UsuarioPreguntador_dni` int NOT NULL,
  `Publicacion_id` int NOT NULL,
  `Respuestas_id` int NOT NULL,
  `FechaP` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_Preguntas_Usuario1_idx` (`UsuarioPreguntador_dni`),
  KEY `fk_Preguntas_Publicacion1_idx` (`Publicacion_id`),
  KEY `fk_Preguntas_Respuestas1_idx` (`Respuestas_id`),
  CONSTRAINT `fk_Preguntas_Publicacion1` FOREIGN KEY (`Publicacion_id`) REFERENCES `Publicacion` (`id`),
  CONSTRAINT `fk_Preguntas_Respuestas1` FOREIGN KEY (`Respuestas_id`) REFERENCES `Respuestas` (`id`),
  CONSTRAINT `fk_Preguntas_Usuario1` FOREIGN KEY (`UsuarioPreguntador_dni`) REFERENCES `Usuario` (`dni`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Preguntas`
--

LOCK TABLES `Preguntas` WRITE;
/*!40000 ALTER TABLE `Preguntas` DISABLE KEYS */;
INSERT INTO `Preguntas` VALUES (1,'¿Está nuevo?',10000005,2,1,'2025-05-31'),(2,'¿Cuántas velocidades tiene?',10000005,2,2,'2025-06-01'),(3,'¿Está nuevo?',10000003,2,1003,'2025-05-31');
/*!40000 ALTER TABLE `Preguntas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Producto`
--

DROP TABLE IF EXISTS `Producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Producto` (
  `id` int NOT NULL,
  `Nombre` varchar(450) DEFAULT NULL,
  `Descripcion` varchar(450) DEFAULT NULL,
  `Precio` float DEFAULT NULL,
  `Categoria_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_Producto_Categoria_idx` (`Categoria_id`),
  KEY `publi_nombre` (`Nombre`),
  CONSTRAINT `fk_Producto_Categoria` FOREIGN KEY (`Categoria_id`) REFERENCES `Categoria` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Producto`
--

LOCK TABLES `Producto` WRITE;
/*!40000 ALTER TABLE `Producto` DISABLE KEYS */;
INSERT INTO `Producto` VALUES (1,'Smartphone X','Teléfono gama alta',150000,1),(2,'Licuadora Turbo','Licuadora de 1000W',30000,2),(3,'Muñeco Articulado','Muñeco de colección',15000,3);
/*!40000 ALTER TABLE `Producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Publicacion`
--

DROP TABLE IF EXISTS `Publicacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Publicacion` (
  `id` int NOT NULL,
  `Descripcion` varchar(450) DEFAULT NULL,
  `precio` float DEFAULT NULL,
  `nivel` varchar(45) DEFAULT NULL,
  `estado` varchar(45) DEFAULT NULL,
  `UsuarioVendedor_dni` int NOT NULL,
  `Producto_id` int NOT NULL,
  `Categoria_id` int NOT NULL,
  `fechaPublicacion` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_Publicacion_Usuario1_idx` (`UsuarioVendedor_dni`),
  KEY `fk_Publicacion_Categoria1_idx` (`Categoria_id`),
  KEY `estado_publi` (`estado`),
  KEY `nombre_publi` (`Producto_id`),
  CONSTRAINT `fk_Publicacion_Categoria1` FOREIGN KEY (`Categoria_id`) REFERENCES `Categoria` (`id`),
  CONSTRAINT `fk_Publicacion_Producto1` FOREIGN KEY (`Producto_id`) REFERENCES `Producto` (`id`),
  CONSTRAINT `fk_Publicacion_Usuario1` FOREIGN KEY (`UsuarioVendedor_dni`) REFERENCES `Usuario` (`dni`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Publicacion`
--

LOCK TABLES `Publicacion` WRITE;
/*!40000 ALTER TABLE `Publicacion` DISABLE KEYS */;
INSERT INTO `Publicacion` VALUES (1,'Último modelo',150000,'Platino','Finalizado',10000002,1,1,'2025-04-23 00:00:00'),(2,'Potente y silenciosa',30000,'Oro','Activa',10000003,2,2,'2024-12-20 00:00:00'),(3,'Muñeco raro',15000,'Plata','Activa',10000004,3,3,'2025-06-03 00:00:00'),(4,'Publi Prueba',30000,'Oro','Activa',10000003,2,2,'2024-12-20 00:00:00'),(6,'chachel',300,'Platino','Activa',10000001,2,3,'2025-06-13 00:00:00'),(73,'Aspiradora para el guarbarros del auto',100,'Plata','Activa',10000003,3,1,'2025-06-13 00:00:00'),(75,'Aspiradora para el guarbarros del auto',100,'Plata','Activa',10000003,3,1,'2025-06-13 00:00:00');
/*!40000 ALTER TABLE `Publicacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Respuestas`
--

DROP TABLE IF EXISTS `Respuestas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Respuestas` (
  `id` int NOT NULL,
  `ContenidoR` varchar(2500) DEFAULT NULL,
  `FechaR` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Respuestas`
--

LOCK TABLES `Respuestas` WRITE;
/*!40000 ALTER TABLE `Respuestas` DISABLE KEYS */;
INSERT INTO `Respuestas` VALUES (1,'Sí, es nuevo en caja.','2025-06-01'),(2,'Tiene 6 velocidades.','2025-06-02'),(1003,'Gracias por su consulta pero me la paso por los huevos','2025-06-13');
/*!40000 ALTER TABLE `Respuestas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Subasta`
--

DROP TABLE IF EXISTS `Subasta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Subasta` (
  `id` int NOT NULL,
  `precio` float DEFAULT NULL,
  `Publicacion_id` int NOT NULL,
  `fecha_maxima_subasta` datetime DEFAULT NULL,
  PRIMARY KEY (`id`,`Publicacion_id`),
  KEY `fk_Subasta_Publicacion1_idx` (`Publicacion_id`),
  CONSTRAINT `fk_Subasta_Publicacion1` FOREIGN KEY (`Publicacion_id`) REFERENCES `Publicacion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Subasta`
--

LOCK TABLES `Subasta` WRITE;
/*!40000 ALTER TABLE `Subasta` DISABLE KEYS */;
INSERT INTO `Subasta` VALUES (1,15000,3,'2025-06-10 23:59:59'),(2,16000,4,'2025-06-10 23:59:59');
/*!40000 ALTER TABLE `Subasta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `Top10`
--

DROP TABLE IF EXISTS `Top10`;
/*!50001 DROP VIEW IF EXISTS `Top10`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Top10` AS SELECT 
 1 AS `id`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `Top3`
--

DROP TABLE IF EXISTS `Top3`;
/*!50001 DROP VIEW IF EXISTS `Top3`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Top3` AS SELECT 
 1 AS `id`,
 1 AS `nivel`,
 1 AS `Count(Preguntas.id)`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `Usuario`
--

DROP TABLE IF EXISTS `Usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Usuario` (
  `dni` int NOT NULL,
  `Nombre` varchar(45) DEFAULT NULL,
  `Apellido` varchar(45) DEFAULT NULL,
  `Direccion` varchar(45) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `nivel` varchar(45) DEFAULT NULL,
  `Dinero_Recaudado` float DEFAULT NULL,
  `cantVentas` int DEFAULT NULL,
  `reputacion` float DEFAULT NULL,
  PRIMARY KEY (`dni`),
  UNIQUE KEY `Usuario_mail` (`Direccion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Usuario`
--

LOCK TABLES `Usuario` WRITE;
/*!40000 ALTER TABLE `Usuario` DISABLE KEYS */;
INSERT INTO `Usuario` VALUES (10000001,'Ana','Pérez','Calle Falsa 123','1990-04-15',NULL,0,0,0),(10000002,'Luis','Gómez','Av. Siempreviva 742','1985-06-10','Normal',5000,3,340),(10000003,'María','López','Av. Corrientes 800','1992-01-22','Normal',120000,7,265),(10000004,'Carlos','Fernández','Belgrano 200','1980-11-05','Gold',1050000,12,95),(10000005,'Julián','Mendoza','Sarmiento 350','2000-07-08',NULL,0,0,85);
/*!40000 ALTER TABLE `Usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `VentaDirecta`
--

DROP TABLE IF EXISTS `VentaDirecta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `VentaDirecta` (
  `id` int NOT NULL,
  `precio` float DEFAULT NULL,
  `calificacionCom` int DEFAULT NULL,
  `calificacionVen` int DEFAULT NULL,
  `Publicacion_id` int NOT NULL,
  `UsuarioComprador_dni` int NOT NULL,
  `MetodoPago_id` int NOT NULL,
  `Envio_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_VentaDirecta_Publicacion1_idx` (`Publicacion_id`),
  KEY `fk_VentaDirecta_Usuario1_idx` (`UsuarioComprador_dni`),
  KEY `fk_VentaDirecta_MetodoPago1_idx` (`MetodoPago_id`),
  KEY `fk_VentaDirecta_Envio1_idx` (`Envio_id`),
  CONSTRAINT `fk_VentaDirecta_Envio1` FOREIGN KEY (`Envio_id`) REFERENCES `Envio` (`id`),
  CONSTRAINT `fk_VentaDirecta_MetodoPago1` FOREIGN KEY (`MetodoPago_id`) REFERENCES `MetodoPago` (`id`),
  CONSTRAINT `fk_VentaDirecta_Publicacion1` FOREIGN KEY (`Publicacion_id`) REFERENCES `Publicacion` (`id`),
  CONSTRAINT `fk_VentaDirecta_Usuario1` FOREIGN KEY (`UsuarioComprador_dni`) REFERENCES `Usuario` (`dni`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `VentaDirecta`
--

LOCK TABLES `VentaDirecta` WRITE;
/*!40000 ALTER TABLE `VentaDirecta` DISABLE KEYS */;
INSERT INTO `VentaDirecta` VALUES (1,150000,90,85,1,10000003,3,2),(2,150000,0,0,1,10000003,3,2),(3,30000,0,0,4,10000003,1,2);
/*!40000 ALTER TABLE `VentaDirecta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `mayorrep`
--

DROP TABLE IF EXISTS `mayorrep`;
/*!50001 DROP VIEW IF EXISTS `mayorrep`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `mayorrep` AS SELECT 
 1 AS `Nombre`,
 1 AS `Categoria_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `preguntasSC`
--

DROP TABLE IF EXISTS `preguntasSC`;
/*!50001 DROP VIEW IF EXISTS `preguntasSC`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `preguntasSC` AS SELECT 
 1 AS `idPreg`,
 1 AS `Descripcion`,
 1 AS `id`,
 1 AS `Producto_id`,
 1 AS `UsuarioVendedor_dni`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `Top10`
--

/*!50001 DROP VIEW IF EXISTS `Top10`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Top10` AS select `Categoria`.`id` AS `id` from (`Categoria` join `Publicacion` on((`Publicacion`.`Categoria_id` = `Categoria`.`id`))) where (week(curdate(),0) = week(`Publicacion`.`fechaPublicacion`,0)) group by `Categoria`.`id` order by count(`Categoria`.`id`) desc limit 10 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Top3`
--

/*!50001 DROP VIEW IF EXISTS `Top3`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Top3` AS select `Publicacion`.`id` AS `id`,`Publicacion`.`nivel` AS `nivel`,count(`Preguntas`.`id`) AS `Count(Preguntas.id)` from (`Publicacion` join `Preguntas` on((`Publicacion`.`id` = `Preguntas`.`Publicacion_id`))) where ((`Publicacion`.`fechaPublicacion` = curdate()) and (`Publicacion`.`estado` = 'Activo')) group by `Publicacion`.`id` order by count(`Preguntas`.`id`) desc limit 3 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `mayorrep`
--

/*!50001 DROP VIEW IF EXISTS `mayorrep`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `mayorrep` AS select `Usuario`.`Nombre` AS `Nombre`,`Publicacion`.`Categoria_id` AS `Categoria_id` from (`Publicacion` join `Usuario` on((`Publicacion`.`UsuarioVendedor_dni` = `Usuario`.`dni`))) group by `Publicacion`.`Categoria_id` order by `Usuario`.`reputacion` desc limit 1 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `preguntasSC`
--

/*!50001 DROP VIEW IF EXISTS `preguntasSC`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `preguntasSC` AS select `Preguntas`.`id` AS `idPreg`,`Publicacion`.`Descripcion` AS `Descripcion`,`Publicacion`.`id` AS `id`,`Publicacion`.`Producto_id` AS `Producto_id`,`Publicacion`.`UsuarioVendedor_dni` AS `UsuarioVendedor_dni` from (`Preguntas` join `Publicacion` on((`Preguntas`.`Publicacion_id` = `Publicacion`.`id`))) where ((`Publicacion`.`estado` = 'Activo') and (`Preguntas`.`Respuestas_id` = NULL)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-13 12:10:00
