Use Prueba21052024
Go

CREATE TABLE Productos(
	ProductoID char(4) NOT NULL,
	NombreProducto varchar(25) NOT NULL,
	PrecioProducto money NULL,
	DescripcionProducto text NULL
	CONSTRAINT PK_Productos PRIMARY KEY (ProductoID)
)

CREATE TABLE Productos2(
ProveedorID_Prod char(4) NOT NULL,
ProductoID_Prod char(4) NOT NULL,
NombreProducto_prod varchar(25) NOT NULL,
PrecioProducto_Prod money NULL,
DescripcionProducto_Prod text NULL,
CONSTRAINT PK_Productos2 PRIMARY KEY (ProveedorID_Prod, ProductoID_Prod),
CONSTRAINT FK_Productos2_Proveedores FOREIGN KEY (ProveedorID_Prod) REFERENCES Proveedores (CodProveedor_Pr)
)
GO
--DROP TABLE Productos			ELIMINACION DE TABLA, todo lo que se elimina no se puede volver a recuperar
--GO

CREATE TABLE Proveedores (
CodProveedor_Pr Char(4) NOT NULL,
RazonSocial_Pr varchar(25) NOT NULL,
Direccion_Pr varchar(25) NOT NULL,
Ciudad_Pr varchar(25) NOT NULL,
Provincia_Pr varchar(25) NOT NULL,
Telefono_Pr varchar(25) NOT NULL,
Cuit_Pr varchar(25) NOT NULL,
Contacto_Pr varchar(25) NOT NULL,
Web_Pr varchar(25) NOT NULL,
)
GO