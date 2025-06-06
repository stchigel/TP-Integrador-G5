/*Stored Procedures*/

/*1*/ /*anda*/
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

/*2*/ /*arreglar*/
delimiter //
create procedure crearPublicacion(in id int, in Descripcion text, in precio float, in nivel text, in estado text, 
in UsuarioVendedor_dni int, in Producto_id int, in Categoria_id int, in esSubasta tinyint, in fechaMax date)
begin
	if esSubasta then
		INSERT INTO Publicacion VALUES (id, Descripcion, precio, nivel, estado, UsuarioVendedor_dni, Producto_id, Categoria_id);
        insert into Subasta values (0, id, fechaMax, null);
	else
		INSERT INTO Publicacion VALUES (id, Descripcion, precio, nivel, estado, UsuarioVendedor_dni, Producto_id, Categoria_id);
	end if;
end //
delimiter ;
call crearPublicacion(73, "Aspiradora para el guarbarros del auto",100.0, "Plata","Activo",48520220, 3, 1, 0,'2025-05-25');

/*3*/ /*anda*/
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

/*Stored Functions*/
/*1*/
delimiter //
create function comprarProdcuto (idUsuaCom int, idPub int, idPago varchar(45), empEnvio varchar(45)) returns text deterministic
begin
	declare mensaje text default'';
    declare estadoPub varchar(45);
    declare idEnvio int;
    select estado into estadoPub from Publicacion where Publicacion.id = idPub;
    if estado="No activa" then
		set mensaje="La publicacion no esta activa";
	else if estado = "Activo" then
		if idPub in (select Publicacion_id from Subasta) then
			set mensaje="Es una subasta";
        else if idPub in (select Publicacion_id from VentaDirecta) then
			update VentaDirecta set MetodoPago_id = idPago, Envio_id = 1, usuarioComprador_dni = idUsuaCom;
        else
			select Envio.id into idEnvio from Envio where Empresa=empEnvio;
            insert into VentaDirecta(UsuarioComprador_dni, Publicacion_id, MetodoPago_id, Envio_id) 
            values(idUsuaCom , idPub , idPago, empEnvio);
        end if;
        end if;
    end if;
    end if;
return mensaje;
end//
delimiter ;
select comprarProductos(12, 3, 3, "OCA");
/*2*/
delimiter //
create function cerrarPublicacion (idUsuaVend int) returns text deterministic
begin
	declare mensaje text default'';
    declare idPub int;
    select Publicacion.id into idPub from Publicacion where UsuarioVendedor_dni=idUsuaVend limit 1; 
    if idPub in (select Publicacion_id from VentaDirecta where calificacionCom is not null and calificacionVen is not null) then
		update Publicacion set estado = "Finalizado";
        set mensaje="La publicacion se finalizo exitosamente";
	else
		set mensaje="La publicacion no se pudo finalizar";
	end if;
return mensaje;
end//
delimiter ;
select cerrarPublicacion(12);
/*3*/
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
select eliminarProducto(22);
/*4*/
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
select pausarPublicacion(12, 2);
/*5*/
delimiter //
create function pujarProducto (idPublicacion int, idCliente int, cantAPujar float) returns text deterministic
begin
	declare respuesta varchar(45) default "Error de función";
	declare sub_id int default null;
    declare precio_act int default 0;
	declare estado_prod varchar(45) default "Nohay";

	select Subasta.id into sub_id from Publicacion left join Subasta on Publicacion.id=Publicacion_id;
	select estado into estado_prod from Publicacion;
    select precio into precio_act from Subasta;
	if sub_id is null then
		set respuesta="La publicación no es una subasta";
	else if estado_prod!="Activa" then
		set respuesta="La subasta no está activa";
	else if cantAPujar<=precio_act then
		set respuesta="No es mayor que el precio actual";
	else
		set respuesta="pujado satisfactoriamente";
        insert into Oferta values (cantAPujar, now(), idCliente, idPublicacion);
	end if;
    end if;
    end if;
	return respuesta;
end//
delimiter ;
/*6*/
delimiter //
create function eliminarCategoria (idCategoria int) returns text deterministic
begin
	declare respuesta varchar(45) default "Error de función";
	declare cant_prods int default 0;

	select count(*) into cantprods from Producto where Categoria_id=idCategoria;

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
/*7*/
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
/*8*/
delimiter //
create function puntuarComprador (idPregunta int, idVendedor int, respuesta text) returns text deterministic
begin
	declare respuesta varchar(45) default "Error de función";
    declare vendedor_id int default 0;

	select UsuarioVendedor_dni into vendedor_id from Preguntas join Publicacion on 
    Publicacion_id=Publicacion.id where Preguntas.id=idPregunta;

	if vendedor_id!=idVendedor then
		set respuesta="El usuario no es el vendedor";
	else
		set respuesta="Respondido";
        insert into Respuestas values (respuesta, current_date());
        update Preguntas set Respuestas_id=LAST_INSERT_ID() where id=idPregunta;
	end if;
	return respuesta;
end//
delimiter ;

/*vistas*/

/*1*/
Create view preguntasSC as select Preguntas.id, Publicacion.Descripcion, Publicacion.id, Publicacion.Producto_id, UsuarioVendedor_id from Preguntas join Publicacion on Preguntas.Publicacion_id = Publicacion.id where Publicacion.estado = "Activo" and Respuesta.id = null;

/*2*/
Create view Top10 as Select Categoria.id from Categoria  Where week(current_date()) = week(FechaPu) group by Categoria.id order by count(Categoria.id) desc limit 10;

/*3*/
Create view Top3 as Select Publicacion.id, Publicacion.nivel, Count(Preguntas.id) from Publicacion join Preguntas on Publicacion.id = Preguntas.Publicaciones where FechaPu = current_date and Publicacion.estado = "Activo"  group by Publicacion.id order by count(Preguntas.id) desc limit 3;

/*4*/
create view mayorrep as select UsuarioVendedor_dni, Categoria_id from Publicacion join Usuario on UsuarioVendedor_dni = Usuario.dni group by Publicacion.Categoria_id order by reputacion desc limit 1; 

/*Triggers*/

/*1*/
delimiter //
create trigger BorrarPreguntas Before Delete on Publicacion for each row
begin 
	delete from Preguntas where Publicacion_id = old.id;
end //
delimiter ;

/*2*/
delimiter //
create trigger calificar After UpDate on VentaRealizada for each row 
begin
    if new.calificacionComprador is not null then upDate Usuario
        set calificacion = new.calificacionComprador
        where id = new.UsuarioComprador_id;
    end if ;
    if new.calificacionVendedor is not null then
        upDate Usuario
        set calificacion = new.calificacionVendedor
        where id = new.UsuarioVendedor_id;
    end if ;
end //
delimiter ;
/*3*/
delimiter //
	create trigger CambiarCategoria after insert on VentaDirecta for each row 
		begin	
				declare DueñoPublicacion int default 0;
                declare cant_ventas int default 0;
                declare cant_facturacion int default 0;
                select UsuarioVendedor_dni into DueñoPublicacion from publicacion where new.idPublicacion = id_publicacion;
                select count(VentaDirecta.id) into cant_ventas from VentaDirecta join publicacion on Publicacion.id = publicacion_id where UsuarioVendedor_dni = DueñoPublicacion;
				select sum(Publicacion.Precio) into cant_facturacion from VentaDirecta join publicacion on Publicacion.id = publicacion_id where UsuarioVendedor_dni = DueñoPublicacion;
                if cant_ventas <= 5 then
					upDate nivel set nivel = "Normal" where Usuario_dni = DueñoPublicacion;

				else if cant_ventas > 5 and cant_ventas < 10 then 
					upDate nivel set nivel = "Platinum" where Usuario_dni = DueñoPublicacion;
                    
				else if cant_facturacion > 100000 and cant_facturacion < 1000000 then 
					upDate nivel set nivel = "Platinum" where Usuario_dni = DueñoPublicacion;
                    
				else if cant_ventas > 11 then 
					upDate nivel set nivel = "Gold" where Usuario_dni = DueñoPublicacion;
                    
				else if cant_facturacion > 1000000 then
					upDate nivel set nivel = "Gold" where Usuario_dni = DueñoPublicacion;
				end if;

		end //
delimiter ;

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
CREATE INDEX publi_nombre ON Producto (Nombre);
/*2*/
CREATE UNIQUE INDEX Usuario_mail ON Usuario (Direccion); 
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