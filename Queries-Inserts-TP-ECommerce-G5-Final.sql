/*Stored Procedures*/

/*1*/ 
delimiter //
create procedure buscarPublicacion(in nomProd text)
begin
	declare idPub int;
    declare precioProd float;
    declare nomCat text;
    declare hayFilas boolean default 1;
	declare publicacionesCursor cursor for select Publicacion.id, Publicacion.precio, Categoria.nombre
    from Publicacion join Categoria on Publicacion.Categoria_id =
    Categoria.id join Producto on Producto_id = Producto.id where Producto.Nombre=nomProd;
    declare continue handler for not found set hayFilas=0;
    open publicacionesCursor;
    bucle:loop
		fetch publicacionesCursor into idPub, precioProd, nomCat;
		if hayFilas = 0 then
			leave bucle;
		end if;
        select idPub, nomProd, precioProd, nomCat;
	end loop;
    close publicacionesCursor;
end //
delimiter ;
drop procedure buscarPublicacion;
call buscarPublicacion("Licuadora Turbo");

/*2*/
delimiter //
create procedure crearPublicacion(in id int, in Descripcion text, in precio float, in nivel text, in estado text, 
in UsuarioVendedor_dni int, in Producto_id int, in Categoria_id int, in esSubasta tinyint, in fechaMax date)
begin
	if esSubasta then
		INSERT INTO Publicacion VALUES (id, Descripcion, precio, nivel, estado, UsuarioVendedor_dni, Producto_id, Categoria_id, current_date());
        insert into Subasta values (id+1000, precio, id, fechaMax);
	else
		INSERT INTO Publicacion VALUES (id, Descripcion, precio, nivel, estado, UsuarioVendedor_dni, Producto_id, Categoria_id, current_date());
	end if;
end //
delimiter ;
call crearPublicacion(75, "Aspiradora para el guarbarros del auto",100.0, "Plata","Activo",10000003, 3, 1, 0,'2025-05-25');

/*3*/ 
delimiter //
	create procedure Ver_preguntas(in idPub int)
		begin
        select * from Preguntas where publicacion_id = idPub;
		end//
delimiter ;
drop procedure Ver_preguntas;
call Ver_preguntas(2);

/*4*/
delimiter //
create procedure actualizarReputacionUsuarios()
begin
	declare reputacionVendedor int;
    declare reputacionComprador int;
    declare dniComprador int;
    declare dniVendedor int;
	declare hayFilas boolean default 1;
    declare publicacionesCursor cursor for select calificacionVen, UsuarioComprador_dni, calificacionCom, Publicacion.UsuarioVendedor_dni
	from VentaDirecta join Publicacion on Publicacion_id = Publicacion.id;
    declare continue handler for not found set hayFilas=0;
    open publicacionesCursor;
    bucle:loop
		fetch publicacionesCursor into reputacionComprador, dniComprador, reputacionVendedor, dniVendedor;
        if hayFilas = 0 then
			leave bucle;
		end if;
        update Usuario set reputacion = (reputacion+reputacionVendedor) where Usuario.dni = dniVendedor;
        update Usuario set reputacion = (reputacion+reputacionComprador) where Usuario.dni = dniComprador;
	end loop;
    close publicacionesCursor;
end //
delimiter ;
call actualizarReputacionUsuarios();
/*Stored Functions*/
/*1*/
delimiter //
create function comprarProducto (idUsuaCom int, idPub int, idPago int, empEnvio int) returns text deterministic
begin
	declare mensaje text default'';
    declare estadoPub varchar(45);
    declare idEnvio int;
    select estado into estadoPub from Publicacion where Publicacion.id = idPub;
    if estadoPub!="Activa" then
		set mensaje="La publicacion no esta activa";
	else if estadoPub = "Activa" then
		if idPub in (select Publicacion_id from Subasta) then
			set mensaje="Es una subasta";
        else if idPub in (select Publicacion_id from VentaDirecta) then
			set mensaje="Ya existe, actualizando";
			update VentaDirecta set MetodoPago_id = idPago, Envio_id = empEnvio, usuarioComprador_dni = idUsuaCom;
        else
			set mensaje="Creada satisfactoriamente";
			select Envio.id into idEnvio from Envio where Empresa=empEnvio;
            insert into VentaDirecta(UsuarioComprador_dni, Publicacion_id, MetodoPago_id, Envio_id) 
            values(idUsuaCom , idPub , idPago, empEnvio);
            update Publicacion set estado="Finalizado" where id=idPub;
        end if;
        end if;
    end if;
    end if;
return mensaje;
end//
delimiter ;
drop function comprarProducto;
select comprarProducto(10000003, 4, 3, 2);
/*2*/
delimiter //
create function cerrarPublicacion (idUsuaVend int, idPub int) returns text deterministic
begin
	declare mensaje text default'';
    if idPub in(select Publicacion_id from VentaDirecta where calificacionCom is not null and calificacionVen is not null) then
		update Publicacion set estado = "Finalizado" where id=idPub;
        set mensaje="La publicacion se finalizo exitosamente";
	else
		set mensaje="La publicacion no se pudo finalizar";
	end if;
return mensaje;
end//
delimiter ;
select cerrarPublicacion(10000002, 2);

/*3*/ /*funca*/
delimiter //
create function eliminarProducto(idProd int) returns text deterministic
begin
	declare mensaje text default'';
	if idProd not in (select Producto_id from Publicacion) then
		delete from Producto where Producto.id = idProd;
        set mensaje="Producto eliminado exitosamente";
	else
		set mensaje="No se pudo eliminar el producto ya que este se encuentra en una publicacion";
    end if;
return mensaje;
end //
delimiter ;
select eliminarProducto(3);
/*4*/ /*funca*/
delimiter //
create function pausarPublicacion(idPub int, idUsu int) returns text deterministic
begin
	declare mensaje text default '';
    if idPub in (select Publicacion.id from Publicacion where UsuarioVendedor_dni=idUsu) then
		update Publicacion set estado = "Pausada";
        set mensaje="Publicacion pausada exitosamente";
	else
		set mensaje="La publicacion no se pudo pausar";
	end if;
return mensaje;
end //
delimiter ;
select pausarPublicacion(1, 10000002);
/*5*/
delimiter //
create function pujarProducto (idPuja int, idPublicacion int, idCliente int, cantAPujar float) returns text deterministic
begin
	declare respuesta varchar(45) default "Error de función";
	declare sub_id int default null;
    declare precio_act int default 0;
	declare estado_prod varchar(45) default "Nohay";

	select Subasta.id into sub_id from Publicacion left join Subasta on Publicacion.id=Publicacion_id where Publicacion.id=idPublicacion;
	select estado into estado_prod from Publicacion where id=idPublicacion;
    select precio into precio_act from Subasta where Publicacion_id=idPublicacion;
	if sub_id is null then
		set respuesta="La publicación no es una subasta";
	else if estado_prod!="Activa" then
		set respuesta="La subasta no está activa";
	else if cantAPujar<=precio_act then
		set respuesta="No es mayor que el precio actual";
	else
		set respuesta="pujado satisfactoriamente";
        insert into Oferta values (idPuja, cantAPujar, now(), idCliente, sub_id);
	end if;
    end if;
    end if;
	return respuesta;
end//
delimiter ;
drop function pujarProducto;
select pujarProducto(8, 4, 10000001, 18000);
/*6*/ /*funca*/
delimiter //
create function eliminarCategoria (idCategoria int) returns text deterministic
begin
	declare respuesta varchar(45) default "Error de función";
	declare cant_prods int default 0;

	select count(*) into cant_prods from Producto where Categoria_id=idCategoria;

	if (select id from Categoria where id=idCategoria) is null then
		set respuesta="La categoría no existe";
	else if cant_prods>0 then
		set respuesta="La categoría está en uso";
	else
		set respuesta="La categoría ha sido eliminada";
        delete from Categoria where id=idCategoria;
	end if;
    end if;
	return respuesta;
end//
delimiter ;
select eliminarCategoria(4);
/*7*/ /*funca*/
delimiter //
create function puntuarComprador (idCompra int, idVendedor int, calificacion int) returns text deterministic
begin
	declare respuesta varchar(45) default "Error de función";
	declare cant_prods int default 0;
    declare vendedor_id int default 0;

	select UsuarioVendedor_dni into vendedor_id from VentaDirecta join Publicacion on 
    Publicacion_id=Publicacion.id where VentaDirecta.id=idCompra;

	if (select id from VentaDirecta where id=idCompra) is null then
		set respuesta="La compra no existe";
	else if vendedor_id!=idVendedor then
		set respuesta="El usuario no es el vendedor";
	else
		set respuesta="Calificado";
        update VentaDirecta set calificacionCom=calificacion where id=idCompra;
	end if;
    end if;
	return respuesta;
end//
delimiter ;
select puntuarComprador(3, 10000003, 100);
/*8*/ /*funca*/
delimiter //
create function responderPregunta (idPregunta int, idRespuesta int, idVendedor int, respuesta text) returns text deterministic
begin
	declare resp varchar(45) default "Error de función";
    declare vendedor_id int default 0;

	select UsuarioVendedor_dni into vendedor_id from Preguntas join Publicacion on 
    Publicacion_id=Publicacion.id where Preguntas.id=idPregunta;

	if vendedor_id!=idVendedor then
		set resp="El usuario no es el vendedor";
	else
		set resp="Respondido";
        insert into Respuestas values (idRespuesta, respuesta, current_date());
        update Preguntas set Respuestas_id=idRespuesta where id=idPregunta;
	end if;
	return resp;
end//
delimiter ;
drop function responderPregunta;
select responderPregunta(3, 1004, 10000003, "Gracias por su consulta.");
delete from Respuestas where id=1004;
/*vistas*/

/*1*/
Create view preguntasSC as select Preguntas.id as idPreg, Publicacion.Descripcion, Publicacion.id, Publicacion.Producto_id, UsuarioVendedor_dni from Preguntas join Publicacion on Preguntas.Publicacion_id = Publicacion.id where Publicacion.estado = "Activo" and Respuestas_id = null;
select * from preguntasSC;

/*2*/ /*arreglar*/
Create view Top10 as Select Categoria.id from Categoria join Publicacion on Categoria_id = Categoria.id where week(current_date()) = week(fechaPublicacion) group by Categoria.id order by count(Categoria.id) desc limit 10;
select * from Top10;

/*3*/
Create view Top3 as Select Publicacion.id, Publicacion.nivel, Count(Preguntas.id) from Publicacion join Preguntas on Publicacion.id = Preguntas.publicacion_id where fechaPublicacion = current_date and Publicacion.estado = "Activo"  group by Publicacion.id order by count(Preguntas.id) desc limit 3;
select *from Top3;

/*4*/
create view mayorrep as select Usuario.Nombre, Categoria_id from Publicacion join Usuario on UsuarioVendedor_dni = Usuario.dni group by Publicacion.Categoria_id order by reputacion desc limit 1; 
select * from mayorrep;
drop view mayorrep;

/*Triggers*/

/*1*/
delimiter //
create trigger BorrarPreguntas Before Delete on Publicacion for each row
begin 
	delete from Preguntas where Publicacion_id = old.id;
end //
delimiter ;
delete from Publicacion where Publicacion.id = 4;

/*2*/
delimiter //
create trigger calificar After Update on VentaDirecta for each row 
begin
	declare usu_ven int;
	select UsuarioVendedor_dni into usu_ven from Publicacion where Publicacion.id=new.Publicacion_id;
    if new.calificacionCom is not null then 
		update Usuario
        set reputacion = reputacion + new.calificacionCom
        where dni = new.UsuarioComprador_dni;
    end if ;
    if new.calificacionVen is not null then
		
        update Usuario
        set reputacion = reputacion + new.calificacionVen
        where dni = usu_ven;
    end if ;
end //
delimiter ;
drop trigger calificar;
/*3*/
delimiter //
	create trigger CambiarCategoria after insert on VentaDirecta for each row 
		begin	
				declare DueñoPublicacion int default 0;
                declare cant_ventas int default 0;
                declare cant_facturacion int default 0;
                select UsuarioVendedor_dni into DueñoPublicacion from Publicacion where new.Publicacion_id = id;
                select count(VentaDirecta.id) into cant_ventas from VentaDirecta join Publicacion on Publicacion.id = publicacion_id where UsuarioVendedor_dni = DueñoPublicacion;
				select sum(Publicacion.Precio) into cant_facturacion from VentaDirecta join Publicacion on Publicacion.id = publicacion_id where UsuarioVendedor_dni = DueñoPublicacion;
                if cant_ventas <= 5 then
					upDate Usuario set nivel = "Normal" where dni = DueñoPublicacion;

				else if cant_ventas > 5 and cant_ventas < 10 then 
					upDate Usuario set nivel = "Platinum" where dni = DueñoPublicacion;
                    
				else if cant_facturacion > 100000 and cant_facturacion < 1000000 then 
					upDate Usuario set nivel = "Platinum" where dni = DueñoPublicacion;
                    
				else if cant_ventas > 11 then 
					upDate Usuario set nivel = "Gold" where dni = DueñoPublicacion;
                    
				else if cant_facturacion > 1000000 then
					upDate Usuario set nivel = "Gold" where dni = DueñoPublicacion;
				end if;
                end if;
                end if;
                end if;
                end if;
		end //
delimiter ;
drop trigger CambiarCategoria;
INSERT INTO VentaDirecta VALUES
(3, 30000, 0, 0, 4, 10000003, 1, 2);

/*Eventos*/
/*1*/
delimiter //
create procedure borrarPublis()
begin
	delete from Publicacion where estado = "Pausado" and fechaPublicacion <= now() - interval 90 DAY;
end//
create event eliminarPublisEvent on schedule EVERY 1 week starts now() do
begin
	call borrarPublis();
end//
delimiter ;
 
/*2*/
delimiter //
create procedure observarPublis()
begin
	update Publicacion set estado = "Observado"
    where Publicacion.id in (select Publicacion_id from VentaDirecta where MetodoPago_id is null) 
    and estado="Activo";
end//
create event observarPublisEvent on schedule EVERY 1 day starts now() do
begin
	call observarPublis();
end//
delimiter ;

/*Indices*/

/*1*/
CREATE INDEX nombre_publi ON Publicacion (Producto_id); 
explain analyze select * from Publicacion where Producto_id=1;
drop INDEX nombre_publi on Publicacion;
drop INDEX fk_Publicacion_Categoria1_idx on Publicacion;
CREATE INDEX publi_nombre ON Producto (Nombre);
explain analyze select * from Producto where Nombre="Smartphone X";
/*2*/
CREATE UNIQUE INDEX Usuario_mail ON Usuario (Direccion); 
explain analyze select * from Usuario where Direccion="Calle Falsa 123";
/*3*/
CREATE INDEX estado_publi ON Publicacion (estado); 

/*Transacciones*/

/*1*/
delimiter //
create procedure crearPublicacion(in id int, in Descripcion text, in precio float, in nivel text, in estado text, 
in UsuarioVendedor_dni int, in Producto_id int, in Categoria_id int, in esSubasta tinyint, in fechaMax date)
begin
	start transaction;
	if esSubasta then
		INSERT INTO Publicacion VALUES (id, Descripcion, precio, nivel, estado, UsuarioVendedor_dni, Producto_id, Categoria_id);
        insert into Subasta values (0, id, fechaMax, null);
	else
		INSERT INTO Publicacion VALUES (id, Descripcion, precio, nivel, estado, UsuarioVendedor_dni, Producto_id, Categoria_id);
	end if;
    
    if exists (select * from Publicacion where Publicacion.id = id) then
		commit;
	else
		rollback;
	end if;
end //
delimiter ;
call crearPublicacion(6, "chachel", 300.0, "Platino", "Finalizada", 10000001, 2, 3, 0, null);

/*2*/
delimiter //
create procedure actualizarReputacionUsuarios()
begin
	declare reputacionVendedor int;
    declare reputacionComprador int;
    declare dniComprador int;
    declare dniVendedor int;
	declare hayFilas boolean default 1;
    declare publicacionesCursor cursor for select calificacionVen, UsuarioComprador_dni, calificacionCom, Publicacion.UsuarioVendedor_dni
	from VentaDirecta join Publicacion on Publicacion_id = Publicacion.id;
    declare continue handler for not found set hayFilas=0;
    open publicacionesCursor;
    bucle:loop
		start transaction;
		fetch publicacionesCursor into reputacionComprador, dniComprador, reputacionVendedor, dniVendedor;
        if hayFilas = 0 then
			leave bucle;
		end if;
        update Usuario set reputacion = (reputacion+reputacionVendedor) where Usuario.dni = dniVendedor;
        update Usuario set reputacion = (reputacion+reputacionComprador) where Usuario.dni = dniComprador;
        if (select reputacion from Usuario where Usuario.dni = dniVendedor) = (reputacion+reputacionVendedor)
        and (select reputacion from Usuario where Usuario.dni = dniComprador) = (reputacion+reputacionComprador) then
			commit;
		else
			rollback;
		end if;
	end loop;
    close publicacionesCursor;
end //
delimiter ;
call actualizarReputacionUsuarios();

/*Inserts*/
-- Categorías
INSERT INTO Categoria VALUES (1, 'Tecnología'), (2, 'Electrodomésticos'), (3, 'Juguetes'); 
INSERT INTO Categoria VALUES (4, 'ParaProbar');

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

INSERT INTO Producto VALUES
(4, 'Anashei', 'Muñeco de colección', 15000, 3);

-- Publicaciones (algunas con subasta, otras con venta directa)
INSERT INTO Publicacion VALUES
(1, 'Último modelo', 150000, 'Platino', 'Finalizada', 10000002, 1, 1, "2025-04-23"),
(2, 'Potente y silenciosa', 30000, 'Oro', 'Activa', 10000003, 2, 2, "2024-12-20"),
(3, 'Muñeco raro', 15000, 'Plata', 'Activa', 10000004, 3, 3, "2025-06-03");
INSERT INTO Publicacion VALUES
(4, 'Publi Prueba', 30000, 'Oro', 'Activa', 10000003, 2, 2, "2024-12-20");

-- Venta directa (solo una concretada)
INSERT INTO VentaDirecta VALUES
(1, 150000, 90, 85, 1, 10000005, 1, 1);
INSERT INTO VentaDirecta VALUES
(2, 150000, 0, 0, 1, 10000005, 2, 1);
INSERT INTO VentaDirecta VALUES
(3, 30000, 0, 0, 4, 10000003, 1, 2);
delete from VentaDirecta where id=3;

-- Respuestas
INSERT INTO Respuestas VALUES
(1, 'Sí, es nuevo en caja.', '2025-06-01'),
(2, 'Tiene 6 velocidades.', '2025-06-02');

-- Preguntas
INSERT INTO Preguntas VALUES
(1, '¿Está nuevo?', 10000005, 2, 1, '2025-05-31'),
(2, '¿Cuántas velocidades tiene?', 10000005, 2, 2, '2025-06-01');
INSERT INTO Preguntas VALUES
(3, '¿Está nuevo?', 10000003, 2, 1, '2025-05-31');
INSERT INTO Preguntas VALUES
(4, '¿Está a prueba?', 10000003, 4, 2, '2025-05-31');

-- Subasta (asociada a publicación 3)
INSERT INTO Subasta VALUES
(1, 15000, 3, '2025-06-10 23:59:59');
INSERT INTO Subasta VALUES
(2, 16000, 4, '2025-06-10 23:59:59');

-- Ofertas
INSERT INTO Oferta VALUES
(1, 15500, '2025-06-06 14:00:00', 10000005, 1),
(2, 16000, '2025-06-06 15:00:00', 10000003, 1);
