Create Database SegundoParcial20242C
go
Use SegundoParcial20242C
go
Create Table Provincias(
    ID_Provincia int not null primary key identity (1, 1),
    Nombre varchar(50) not null,
    ImpuestoImportacion decimal(10, 2) null -- Por ej: 25 es 25% de recargo. NULL si no tiene recargo.
)
go
Create Table Clientes(
    ID_Cliente int not null primary key identity (1, 1),
    ID_Provincia int not null foreign key references Provincias(ID_Provincia),
    Apellidos varchar(100) not null,
    Nombres varchar(100) not null,
    Domicilio varchar(200) not null
)
go
Create Table Importaciones(
    ID_Importacion bigint not null primary key identity (1, 1),
    ID_Cliente int not null foreign key references Clientes(ID_Cliente),
    Descripcion varchar(200),
    Fecha date,
    Valor money,
    Arancel money,
    Pagado bit
)
GO
Create Table Envios(
    ID_Importacion bigint not null primary key foreign key references Importaciones(ID_Importacion),
    FechaEstimada date,
    Costo money
)
go
-- Provincias
    INSERT INTO Provincias (Nombre, ImpuestoImportacion) VALUES ('Buenos Aires', 5);
    INSERT INTO Provincias (Nombre, ImpuestoImportacion) VALUES ('Cordoba', 11);
    INSERT INTO Provincias (Nombre, ImpuestoImportacion) VALUES ('Santa Fe', 17);
    INSERT INTO Provincias (Nombre, ImpuestoImportacion) VALUES ('Entre Rios', 28);
    INSERT INTO Provincias (Nombre, ImpuestoImportacion) VALUES ('Tucumán', null);
    INSERT INTO Provincias (Nombre, ImpuestoImportacion) VALUES ('Mendoza', null);
    INSERT INTO Provincias (Nombre, ImpuestoImportacion) VALUES ('La Pampa', null);
    INSERT INTO Provincias (Nombre, ImpuestoImportacion) VALUES ('San Juan', null);

-- Clientes
    INSERT INTO Clientes (ID_Provincia, Apellidos, Nombres, Domicilio) VALUES (5, 'Gonzalez', 'Juan', 'Av. Mitre 123');
    INSERT INTO Clientes (ID_Provincia, Apellidos, Nombres, Domicilio) VALUES (4, 'Rodriguez', 'María', 'Av. San Martin 456');
    INSERT INTO Clientes (ID_Provincia, Apellidos, Nombres, Domicilio) VALUES (1, 'Sanchez', 'Pedro', 'Av. 9 de Julio 789');
    INSERT INTO Clientes (ID_Provincia, Apellidos, Nombres, Domicilio) VALUES (7, 'Perez', 'Lucia', 'Av. Corrientes 123');
    INSERT INTO Clientes (ID_Provincia, Apellidos, Nombres, Domicilio) VALUES (8, 'Gomez', 'Diego', 'Av. Rivadavia 456');
    INSERT INTO Clientes (ID_Provincia, Apellidos, Nombres, Domicilio) VALUES (2, 'Martinez', 'Ana', 'Av. Belgrano 789');
    INSERT INTO Clientes (ID_Provincia, Apellidos, Nombres, Domicilio) VALUES (3, 'Diaz', 'Carlos', 'Av. La Plata 123');
    INSERT INTO Clientes (ID_Provincia, Apellidos, Nombres, Domicilio) VALUES (6, 'Lopez', 'Sofia', 'Av. San Juan 456');
    INSERT INTO Clientes (ID_Provincia, Apellidos, Nombres, Domicilio) VALUES (5, 'Ramirez', 'Jorge', 'Av. Salta 789');
    INSERT INTO Clientes (ID_Provincia, Apellidos, Nombres, Domicilio) VALUES (1, 'Jimenez', 'Luciana', 'Av. Córdoba 123');

    -- Importaciones
INSERT INTO Importaciones (ID_Cliente, Descripcion, Fecha, Valor, Arancel, Pagado) VALUES (1, 'Electrodomésticos', '2024-10-15', 15000, 750, 1);
INSERT INTO Importaciones (ID_Cliente, Descripcion, Fecha, Valor, Arancel, Pagado) VALUES (2, 'Textiles', '2024-09-12', 12000, 1320, 0);
INSERT INTO Importaciones (ID_Cliente, Descripcion, Fecha, Valor, Arancel, Pagado) VALUES (3, 'Juguetes', '2024-08-08', 5000, 250, 1);
INSERT INTO Importaciones (ID_Cliente, Descripcion, Fecha, Valor, Arancel, Pagado) VALUES (4, 'Electrónica', '2024-07-25', 8000, 2240, 0);
INSERT INTO Importaciones (ID_Cliente, Descripcion, Fecha, Valor, Arancel, Pagado) VALUES (5, 'Libros', '2024-06-18', 3000, 0, 1);
INSERT INTO Importaciones (ID_Cliente, Descripcion, Fecha, Valor, Arancel, Pagado) VALUES (6, 'Herramientas', '2024-05-29', 11000, 1210, 1);
INSERT INTO Importaciones (ID_Cliente, Descripcion, Fecha, Valor, Arancel, Pagado) VALUES (7, 'Bicicletas', '2024-04-14', 25000, 4250, 0);
INSERT INTO Importaciones (ID_Cliente, Descripcion, Fecha, Valor, Arancel, Pagado) VALUES (8, 'Muebles', '2024-03-01', 30000, 0, 1);
INSERT INTO Importaciones (ID_Cliente, Descripcion, Fecha, Valor, Arancel, Pagado) VALUES (9, 'Medicamentos', '2024-02-20', 18000, 900, 1);
INSERT INTO Importaciones (ID_Cliente, Descripcion, Fecha, Valor, Arancel, Pagado) VALUES (10, 'Computadoras', '2024-01-15', 45000, 2250, 0);

-- Envios
INSERT INTO Envios (ID_Importacion, FechaEstimada, Costo) VALUES (1, '2024-10-25', 1000);
INSERT INTO Envios (ID_Importacion, FechaEstimada, Costo) VALUES (2, '2024-09-22', 800);
INSERT INTO Envios (ID_Importacion, FechaEstimada, Costo) VALUES (3, '2024-08-18', 500);
INSERT INTO Envios (ID_Importacion, FechaEstimada, Costo) VALUES (4, '2024-07-30', 950);
INSERT INTO Envios (ID_Importacion, FechaEstimada, Costo) VALUES (5, '2024-06-25', 300);
INSERT INTO Envios (ID_Importacion, FechaEstimada, Costo) VALUES (6, '2024-06-05', 700);
INSERT INTO Envios (ID_Importacion, FechaEstimada, Costo) VALUES (7, '2024-04-20', 1200);
INSERT INTO Envios (ID_Importacion, FechaEstimada, Costo) VALUES (8, '2024-03-10', 1100);
INSERT INTO Envios (ID_Importacion, FechaEstimada, Costo) VALUES (9, '2024-02-28', 850);
INSERT INTO Envios (ID_Importacion, FechaEstimada, Costo) VALUES (10, '2024-01-25', 1500);