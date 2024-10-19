-- Use Master
-- Drop Database EjemploTransacciones
Create Database EjemploTransacciones
Collate Latin1_General_CI_AI
 
Use EjemploTransacciones

Create Table Clientes(
    IDCliente int not null primary key,
    Apellidos varchar(50) not null,
    Nombres varchar(50) not null,
    Estado bit not null default (1)
)

Create Table TiposCuenta(
    IDTipoCuenta varchar(2) not null primary key,
    Nombre varchar(50) not null
)

Create Table Cuentas(
    IDCuenta int not null primary key identity (1, 1),
    IDCliente int not null foreign key references Clientes(IDCliente),
    IDTipoCuenta varchar(2) not null foreign key references TiposCuenta(IDTipoCuenta),
    FechaApertura date not null,
    LimiteDescubierto money not null,
    Saldo money not null
)
 
Create Table Movimientos(
    IDMovimiento bigint not null primary key identity (1, 1),
    IDCuenta int not null foreign key references Cuentas(IdCuenta),
    Fecha date not null default (getdate()),
    Importe money not null check (Importe > 0),
    TipoMovimiento char not null check (TipoMovimiento in ('C', 'D'))
)

Alter Table Cuentas
Add Constraint Chk_SaldoCorrecto Check (Saldo >= LimiteDescubierto * -1)

-- Datos
Set Dateformat 'YMD'

INSERT INTO Clientes (IDCliente, Apellidos, Nombres, Estado) VALUES
(1, 'Garc�a', 'Juan', 1),
(2, 'P�rez', 'Mar�a', 1),
(3, 'L�pez', 'Carlos', 1),
(4, 'Mart�nez', 'Ana', 1),
(5, 'Hern�ndez', 'Luis', 1),
(6, 'Ram�rez', 'Sof�a', 1);

INSERT INTO TiposCuenta (IDTipoCuenta, Nombre) VALUES
('CC', 'Cuenta Corriente'),
('CA', 'Caja de Ahorro');

SET IDENTITY_INSERT Cuentas ON

INSERT INTO Cuentas (IDCuenta, IDCliente, IDTipoCuenta, FechaApertura, LimiteDescubierto, Saldo) VALUES
(1, 1, 'CC', '2024-01-01', 1000.00, 50.00),
(2, 1, 'CA', '2024-02-01', 0.00, 300.00),
(3, 2, 'CC', '2024-03-01', 2000.00, 400.00),
(4, 3, 'CA', '2024-04-01', 0.00, 200.00),
(5, 4, 'CC', '2024-05-01', 500.00, -100.00),
(6, 5, 'CA', '2024-06-01', 0.00, 500.00),
(7, 6, 'CC', '2024-07-01', 3000.00, -700.00),
(8, 1, 'CA', '2024-08-01', 0.00, 0.00),
(9, 3, 'CA', '2024-09-01', 0.00, 0.00),
(10, 5, 'CC', '2024-10-01', 1000.00, 0.00);

Set IDENTITY_INSERT Cuentas OFF

INSERT INTO Movimientos (IDCuenta, Fecha, Importe, TipoMovimiento) VALUES
(1, '2024-09-15', 200.00, 'C'),
(1, '2024-09-20', 150.00, 'D'),
(2, '2024-09-05', 300.00, 'C'),
(3, '2024-09-10', 400.00, 'C'),
(4, '2024-09-15', 200.00, 'C'),
(5, '2024-09-20', 100.00, 'D'),
(6, '2024-09-25', 500.00, 'C'),
(7, '2024-09-30', 700.00, 'D')