/*Stored Procedures*/
/*1*/
delimiter //
create procedure buscarPublicacion(in nomProd text)
begin
	declare idPub int;
    declare nomProd text;
    declare precioProd float;
    declare nomCat text;
    declare hayFilas boolean default 1;
	declare publicacionesCursor cursor for select Publicacion.id, Publicacion.precio, Categoria.nombre
    from Publicacion join Categoria on Publicacion.Categoria_id =
    Categoria.id where Producto.nombre=nomProd;
    declare continue handler for not found set hayFilas=0;
    open publicacionesCursor;
    bucle:loop
		fetch publicacionesCursor into idPub, precioProd, nomCat;
		select nombre into nomProd from Producto where nombre=nomProd;
		if hayFilas = 0 then
			leave bucle;
		end if;
        select idPub, nomProd, precioProd, nomCat;
	end loop;
    close publicacionesCursor;
end //
delimiter ;

/*2*/
delimiter //
create procedure crearPublicacion(in id int, in Descripcion text, in precio float, in nivel text, in estado text, 
in UsuarioVendedor_dni int, in Producto_id int, in Categoria_id int)
begin
	INSERT INTO Publicacion VALUES (id, Descripcion, precio, nivel, estado, UsuarioVendedor_dni, Producto_id, Categoria_id);
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