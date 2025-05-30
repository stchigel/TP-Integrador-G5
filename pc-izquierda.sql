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




