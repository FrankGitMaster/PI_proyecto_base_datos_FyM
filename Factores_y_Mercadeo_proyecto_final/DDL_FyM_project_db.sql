/*CREAR LA BASE DE DATOS*/
create database FyM_project_db;
/*HACER USO DE LA BASE DE DATOS*/
use FyM_project_db;

/*CREAR LA TABLA CARGO*/
create table Cargo(
	id_cargo int primary key identity(1,1),
	cargo varchar(50) not null
);

/*CREAR LA TABLA EMPLEADO*/
create table Empleado(
	num_doc int primary key,
	nom_1 varchar(20) not null,
	nom_2 varchar(20),
	ape_1 varchar(20) not null,
	ape_2 varchar(20),
	cargo int not null,
	sueldo int not null,
	email varchar(30),
	direccion varchar(50),
	telefono bigint
	foreign key(cargo) references Cargo(id_cargo)
);

/*CREAR LA TABLA AREA*/
create table Area(
	id_area int primary key identity(1,1),
	area varchar(50) not null
);

/*CREAR LA TABLA AREA_EMPLEADO*/
create table Area_empleado(
	area int not null,
	empleado int not null,
	foreign key(area) references Area(id_area),
	foreign key(empleado) references Empleado(num_doc)
);

/*CREAR LA TABLA CONTENEDOR*/
create table Contenedor(
	id_contenedor int primary key identity(1,1),
	tipo_contenedor varchar(20) not null,
	peso decimal(4,3) not null /*kilos*/ 
);

/*CREAR LA TABLA PRODUCTO*/
create table Producto(
	id_producto int primary key identity(1,1),
	producto varchar(50) not null,
	tipo_contenedor int not null,
	peso int not null, /*kilos*/
	alergeno varchar(2) not null check(alergeno in ('SI', 'NO')),
	precio int not null,
	total_peso_almacenado int not null,
	total_unds_almacenado int not null,
	foreign key(tipo_contenedor) references Contenedor(id_contenedor)
);

/*CREAR LA TABLA INGRESO*/
create table Ingreso(
	id_ingreso int primary key identity(1,1),
	fecha datetime not null,
	empleado int not null,
	total_peso_ingresado int not null,
	total_unds_ingresado int not null
	foreign key(empleado) references Empleado(num_doc)
);

/*CREAR LA TABLA PRODUCTO_INGRESADO*/
create table Producto_ingresado(
	ingreso int not null,
	producto int not null,
	total_peso_ingresado int not null,
	total_unds_ingresado int not null
	foreign key(ingreso) references Ingreso(id_ingreso),
	foreign key(producto) references Producto(id_producto)
);

/*CREAR LA TABLA VENTA*/
create table Venta(
	id_venta int primary key identity(1,1),
	fecha datetime not null,
	empleado int not null,
	total_venta int not null,
	foreign key(empleado) references Empleado(num_doc),
);

/*CREAR LA TABLA PRODUCTO_VENDIDO*/
create table Producto_vendido(
	venta int not null,
	producto int not null,
	total_unds_vendido int not null,
	total_precio_producto int not null,
	foreign key(venta) references Venta(id_venta),
	foreign key(producto) references Producto(id_producto)
);

/*CREAR UN PROCEDIMIENTO ALMACENADO PARA INGRESAR REGISTROS EN LA TABLA CARGO*/
create procedure ingresar_cargo
@cargo varchar(50)
as
begin
	insert into Cargo(cargo) values(@cargo);
	select * from Cargo;
end
go

/*CREAR UN PROCEDIMIENTO ALMACENADO PARA INGRESAR REGISTROS EN LA TABLA EMPLEADO*/
create procedure ingresar_empleado
@num_doc int,
@nom_1 varchar(20),
@nom_2 varchar(20),
@ape_1 varchar(20),
@ape_2 varchar(20),
@cargo int,
@sueldo int,
@email varchar(30),
@direccion varchar(50),
@telefono bigint
as
begin
	insert into Empleado values(@num_doc, @nom_1, @nom_2, @ape_1, @ape_2, @cargo, @sueldo, @email, @direccion, @telefono);
	select * from Empleado;
end
go

/*CREAR UN PROCEDIMIENTO ALMACENADO PARA INGRESAR REGISTROS EN LA TABLA AREA*/
create procedure ingresar_area
@area varchar(50)
as
begin
	insert into Area(area) values(@area);
	select * from Area;
end
go

/*CREAR UN PROCEDIMIENTO ALMACENADO PARA INGRESAR REGISTROS EN LA TABLA AREA_EMPLEADO*/
create procedure ingresar_area_empleado
@area int,
@empleado int
as
begin
	insert into Area_empleado values(@area, @empleado);
	select * from Area_empleado;
end
go

/*CREAR UN PROCEDIMIENTO ALMACENADO PARA INGRESAR REGISTROS EN LA TABLA CONTENEDOR*/
create procedure ingresar_contenedor
@tipo_contenedor varchar(20),
@peso decimal(4,3)
as
begin
	insert into Contenedor(tipo_contenedor, peso) values(@tipo_contenedor, @peso);
	select * from Contenedor;
end
go

/*CREAR UN PROCEDIMIENTO ALMACENADO PARA INGRESAR REGISTROS EN LA TABLA PRODUCTO*/
create procedure ingresar_producto
@producto varchar(50),
@tipo_contenedor int,
@peso int,
@alergeno varchar(2),
@precio int,
@total_peso_almacenado int,
@total_unds_almacenado int
as
begin
	insert into Producto(producto, tipo_contenedor, peso, alergeno, precio, total_peso_almacenado, total_unds_almacenado) 
	values(@producto, @tipo_contenedor, @peso, @alergeno, @precio, @total_peso_almacenado, @total_unds_almacenado);
	select * from Producto;
end
go

/*CREAR UN PROCEDIMIENTO ALMACENADO PARA INGRESAR REGISTROS EN LA TABLA INGRESO*/
create procedure ingresar_ingreso
@fecha datetime,
@empleado int
as
begin
	insert into Ingreso(fecha, empleado, total_peso_ingresado, total_unds_ingresado) values(@fecha, @empleado, 0, 0);
	select * from Ingreso;
end
go

/*CREAR UN PROCEDIMIENTO ALMACENADO PARA INGRESAR REGISTROS EN LA TABLA INGRESO_PRODUCTO*/
create procedure ingresar_producto_ingresado
@ingreso int,
@producto int,
@total_peso_ingresado int,
@total_unds_ingresado int
as
begin
	insert into Producto_ingresado values(@ingreso, @producto, @total_peso_ingresado, @total_unds_ingresado);
	update Producto set total_peso_almacenado = total_peso_almacenado + @total_peso_ingresado where id_producto = @producto;
	update Producto set total_unds_almacenado = total_unds_almacenado + @total_unds_ingresado where id_producto = @producto;
	update Ingreso set total_peso_ingresado = total_peso_ingresado + @total_peso_ingresado where id_ingreso = @ingreso;
	update Ingreso set total_unds_ingresado = total_unds_ingresado + @total_unds_ingresado where id_ingreso = @ingreso;
	select * from Ingreso;
	select * from Producto_ingresado;
	select * from Producto;
end
go

/*CREAR UN PROCEDIMIENTO ALMACENADO PARA INGRESAR REGISTROS EN LA TABLA VENTA*/
create procedure ingresar_venta
@fecha datetime,
@empleado int
as
begin
	if(select cargo from Empleado where num_doc = @empleado) = (select id_cargo from Cargo where cargo = 'vendedor')
		insert into Venta(fecha, empleado, total_venta) values(@fecha, @empleado, 0);
		select * from Venta;
end
go

/*CREAR UN PROCEDIMIENTO ALMACENADO PARA INGRESAR REGISTROS EN LA TABLA PRODUCTO_VENDIDO*/
create procedure ingresar_producto_vendido
@venta int,
@producto int,
@total_unds_vendido int
as
begin
	insert into Producto_vendido values(@venta, @producto, @total_unds_vendido, (select precio from Producto where id_producto = @producto) * @total_unds_vendido);
	update Producto set total_unds_almacenado = total_unds_almacenado - @total_unds_vendido where id_producto = @producto;
	update Producto set total_peso_almacenado = total_peso_almacenado - ((select peso from Producto where id_producto = @producto) * @total_unds_vendido);
	update Venta set total_venta = total_venta + (select precio from Producto where id_producto = @producto) * @total_unds_vendido where id_venta = @venta;
	select * from Venta
	select * from Producto_vendido
	select * from Producto
end
go

/*CREAR UNA VISTA PARA CONSULTAR LOS DATOS DE LOS EMPLEADOS*/
create view consultar_datos_empleado
as
select emp.num_doc 'No. DOCUMENTO', emp.nom_1 'PRIMER NOMBRE', EMP.nom_2 'SEGUNDO NOMBRE', emp.ape_1 + ' ' + emp.ape_2 'APELLIDOS', car.cargo 'CARGO', emp.sueldo 'SUELDO', emp.telefono 'TELÉFONO', emp.email 'EMAIL', emp.direccion 'DIRECCIÓN'
from Empleado emp
inner join Cargo car
on emp.cargo = car.id_cargo;

/*CREAR UNA VISTA PARA CONSULTAR LOS DATOS DE LOS PRODUCTOS*/
create view consultar_producto
as
select pro.id_producto 'CÓDIGO', pro.producto 'PRODUCTO', pro.peso 'PESO(kg)', con.tipo_contenedor 'CONTENEDOR', pro.alergeno 'ALERGENO', pro.precio 'PRECIO(unidad)'
from Producto pro
inner join Contenedor con
on pro.tipo_contenedor = con.id_contenedor;

/*CREAR UNA VISTA PARA CONSULTAR LOS PRODUCTOS ALMACENADOS*/
create view consultar_cantidad_producto_almacenado
as
select pro.id_producto 'CÓDIGO', pro.producto 'PRODUCTO', pro.total_unds_almacenado 'TOTAL UNIDADES ALMACENADO', pro.total_peso_almacenado 'TOTAL PESO ALMACENADO(kg)'
from Producto pro;

/*CREAR UNA VISTA PARA CONSULTAR LOS INGRESOS*/
create view consultar_ingreso
as
select ing.id_ingreso 'No. INGRESO', ing.fecha 'FECHA Y HORA', emp.nom_1 + ' ' + emp.ape_1 'OPERARIO ENCARGADO', ing.total_unds_ingresado 'TOTAL UNIDADES INGRESADAS', ing.total_peso_ingresado 'TOTAL PESO INGRESADO(kg)'
from Ingreso ing
inner join Empleado emp
on ing.empleado = emp.num_doc;

/*CREAR UNA VISTA PARA CONSULTAR LOS INGRESOS DE LOS PRODUCTOS*/
create view consultar_ingreso_producto
as
select ping.ingreso 'No. INGRESO', pro.producto 'PRODUCTO', ping.total_unds_ingresado 'TOTAL UNIDADES INGRESADAS', ping.total_peso_ingresado 'TOTAL PESO INGRESADO(kg)'
from Producto_ingresado ping
inner join Producto pro
on ping.producto = pro.id_producto;

/*CREAR UNA VISTA PARA CONSULTAR LAS VENTAS*/
create view consultar_venta
as
select ven.id_venta 'No. VENTA', ven.fecha 'FECHA Y HORA', emp.nom_1 + ' ' + emp.ape_1 'VENDEDOR', ven.total_venta 'TOTAL VENTA'
from Venta ven
inner join Empleado emp
on ven.empleado = emp.num_doc;

/*CREAR UNA VISTA PARA CONSULTAR  LAS VENTAS DE LOS PRODUCTOS*/
create view consultar_venta_producto
as
select pven.venta 'No. VENTA', pro.producto 'PRODUCTO', pven.total_unds_vendido 'TOTAL UNIDADES VENDIDAS', pven.total_precio_producto 'TOTAL VENTA'
from Producto_vendido pven
inner join Producto pro
on pven.producto = pro.id_producto;