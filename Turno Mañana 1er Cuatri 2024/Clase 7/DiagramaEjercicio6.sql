USE Ejercicio6
GO

CREATE TABLE Proveedores (
	CodProveedor_Pr int NOT NULL,
	RazonSocial_Pr varchar(25) NOT NULL,
	Direccion_Pr varchar(25) NOT NULL,
	Ciudad_Pr varchar(25) NOT NULL,
	Provincia_Pr varchar(25) NOT NULL,
	Cuit_Pr varchar(25) NOT NULL,
	Telefono_Pr varchar(25) NOT NULL,
	Contacto_Pr varchar(25) NOT NULL,
	WEB_Pr varchar(25) NOT NULL,
	Email_Pr varchar(25) NOT NULL,
	CONSTRAINT PK_Proveedor PRIMARY KEY (CodProveedor_Pr)
)
GO

CREATE TABLE Articulos (
	CodProveedor_Ar int NOT NULL,
	CodArticulo_Ar int NOT NULL,
	Descripcion_Ar text NOT NULL,
	Stock_Ar int NOT NULL,
	PrecioUnitario_Ar money NOT NULL,
	CONSTRAINT PK_Articulos PRIMARY KEY (CodProveedor_Ar,CodArticulo_Ar)
)
GO

CREATE TABLE Clientes (
	Dni_Cl varchar(10) NOT NULL,
	Nombre_Cl varchar(25) NOT NULL,
	Apellido_Cl varchar(25) NOT NULL,
	Direccion_Cl varchar(25) NOT NULL,
	Telefono_Cl varchar(25) NOT NULL,
	CONSTRAINT PK_Clientes PRIMARY KEY (Dni_Cl)
)
GO

CREATE TABLE Cuentas (
	CodCuenta_Cu int NOT NULL,
	Dni_Cu varchar(10) NOT NULL,
	LimiteCuenta int NOT NULL,
	SaldoCuenta money NOT NULL,
	CONSTRAINT PK_Cuentas PRIMARY KEY (CodCuenta_Cu),
	CONSTRAINT FK_Cuentas_Clientes FOREIGN KEY (DNI_Cu) REFERENCES Clientes (Dni_Cl)
)
GO

CREATE TABLE Facturas (
	CodFactura_Fa int NOT NULL,
	CodCuentaCliente_Fa int NOT NULL,
	TotalFactura_Fa money NOT NULL,
	FechaFactura date NOT NULL,
	CONSTRAINT PK_Facturas PRIMARY KEY (CodFactura_Fa),
	CONSTRAINT FK_Facturas_Cuentas FOREIGN KEY (CodCuentaCliente_Fa) REFERENCES Cuentas (CodCuenta_Cu)
)
GO

CREATE TABLE DetalleFactura (
	CodFactura_Df int NOT NULL,
	CodProveedor_Df int NOT NULL,
	CodArticulo_Df int NOT NULL,
	Cantidad_Df int NOT NULL,
	PrecioUnitario_Df money NOT NULL,
	CONSTRAINT PK_DetalleFactura PRIMARY KEY (CodFactura_Df, CodProveedor_Df, CodArticulo_Df),

)
GO
