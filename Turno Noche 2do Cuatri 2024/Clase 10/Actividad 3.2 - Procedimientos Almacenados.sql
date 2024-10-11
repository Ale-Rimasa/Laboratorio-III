--A)Realizar un procedimiento almacenado llamado sp_Agregar_Usuario que permita registrar un usuario
--en el sistema. El procedimiento debe recibir como parámetro DNI, Apellido, Nombre, Fecha de
--nacimiento y los datos del domicilio del usuario.

CREATE OR ALTER PROCEDURE SP_Agregar_Usuario(
	@DNI BIGINT,
	@Apellido Varchar(50),
	@Nombre Varchar(50),
	@FechaNac DATE,
	@Domicilio Varchar(50)
)
AS
	BEGIN
		 INSERT INTO USUARIOS (DNI, APELLIDO,NOMBRE,FECHA_NAC,DOMICILIO, ESTADO)
		 VALUES(@DNI, @Apellido, @Nombre, @FechaNac, @Domicilio,1)
	END

--PRUEBA SP_Agregar_Usuario

EXEC SP_Agregar_Usuario '1111111111', 'Rimasa', 'Alejandro', '1992-07-01', 'Rivadavia 1000'

GO
/********************************************************************************************************************************************/
--B) Realizar un procedimiento almacenado llamado sp_Agregar_Tarjeta que dé de alta una tarjeta. El
--procedimiento solo debe recibir el DNI del usuario.
--Como el sistema sólo permite una tarjeta activa por usuario, el procedimiento debe:
--Dar de baja la última tarjeta del usuario (si corresponde).
--Dar de alta la nueva tarjeta del usuario
--Traspasar el saldo de la vieja tarjeta a la nueva tarjeta (si corresponde)


CREATE OR ALTER PROCEDURE SP_Agregar_Tarjeta(
	@DNI
)
AS	BEGIN
	