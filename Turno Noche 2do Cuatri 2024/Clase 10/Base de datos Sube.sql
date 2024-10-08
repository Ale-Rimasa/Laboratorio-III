USE MASTER
CREATE DATABASE LAB3_ACTIVIDAD_3_1
GO
USE LAB3_ACTIVIDAD_3_1
GO
CREATE TABLE USUARIOS(
IDUSUARIO BIGINT NOT NULL PRIMARY KEY IDENTITY (1, 1),
DNI VARCHAR(10) NOT NULL UNIQUE,
APELLIDO VARCHAR(50) NOT NULL,
NOMBRE VARCHAR(50) NOT NULL,
DOMICILIO VARCHAR(50) NULL,
FECHA_NAC DATE NULL,
ESTADO BIT NOT NULL
)
GO
CREATE TABLE TARJETAS(
IDTARJETA BIGINT NOT NULL PRIMARY KEY IDENTITY(1, 1),
IDUSUARIO BIGINT NOT NULL FOREIGN KEY REFERENCES USUARIOS(IDUSUARIO),
FECHA_ALTA DATE NOT NULL,
SALDO MONEY NOT NULL,
ESTADO BIT NOT NULL
)
GO
CREATE TABLE LINEAS(
IDLINEA BIGINT NOT NULL PRIMARY KEY,
NOMBRE VARCHAR(30) NOT NULL,
DOMICILIO VARCHAR(50) NULL
)
GO
CREATE TABLE VIAJES(
IDVIAJE BIGINT NOT NULL PRIMARY KEY IDENTITY(1, 1),
FECHA DATETIME NOT NULL DEFAULT(GETDATE()),
NRO_INTERNO BIGINT NULL,
IDLINEA BIGINT NOT NULL FOREIGN KEY REFERENCES LINEAS(IDLINEA),
IDTARJETA BIGINT NOT NULL FOREIGN KEY REFERENCES TARJETAS(IDTARJETA),
IMPORTE SMALLMONEY NOT NULL
)
GO
CREATE TABLE MOVIMIENTOS(
IDMOVIMIENTOS BIGINT NOT NULL PRIMARY KEY IDENTITY(1, 1),
FECHA DATETIME NOT NULL,
IDTARJETA BIGINT NOT NULL FOREIGN KEY REFERENCES TARJETAS(IDTARJETA),
IMPORTE SMALLMONEY NOT NULL,
TIPO CHAR NOT NULL CHECK (TIPO = 'C' OR TIPO = 'D') -- 'C' - CR�DITO y 'D' - D�BITO
)