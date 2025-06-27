/*3*/
delimiter //
	create procedure Ver_preguntas(in publi varchar(45))
		begin
        select * from preguntas where publicacion_id = publi;
		end//
delimiter ;

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


