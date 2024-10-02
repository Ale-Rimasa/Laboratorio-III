--1 Crear una vista en el campo de Cancelada que en vez de ser 0 o 1 que se llamen Cancelada o NO cancelado
-- y en el ID_Destino, que aparezcan los nombres de los destinos.

 CREATE OR ALTER VIEW VW_ModificacionExcu
 AS
 SELECT E.ID_Excursion, D.Nombre AS [Destino], ID_Vehiculo, E.FechaHora,
		E.Costo,
		dbo.FN_TotalPasajesXExcursion(E.ID_Excursion) AS [Cant Vendidos],
		CASE WHEN
			Cancelada = 1 THEN 'Cancelada'
		ELSE 'NO Cancelada'
	END AS Estado		
		FROM Excursiones AS E
	INNER JOIN Destinos AS D
		ON E.ID_Destino = D.ID_Destino
GO

SELECT * FROM VW_ModificacionExcu
--Ejemplo de Procedimiento Almacenado con parámetros que selleciona datos
-- Obtener todas las ventas de una Excursion específica (ID_Excursion)
CREATE PROCEDURE SP_VentasExcursion(
	@ID_Excursion int

)
AS
BEGIN
	SELECT * FROM Ventas WHERE ID_Excursion = @ID_Excursion
END
--Llamo o Ejecuto el SP
 Exec SP_VentasExcursion 2

--Creacion de un nuevo cliente mediante un SP
CREATE or Alter PROCEDURE SP_NuevoCliente(
	@Apellido VARCHAR(100),
	@Nombre VARCHAR(100),
	@FechaNacimiento DATE,
	@Celular VARCHAR(20),
	@Telefono VARCHAR(20),
	@Mail VARCHAR(250)
)
AS BEGIN
		IF @Celular IS NULL AND @Telefono IS NULL BEGIN --begin: como una llave de apertura
			Raiserror('Debe suministrar un valor para telefono o celular',16,0)
			return
		END

		Declare @Edad int
		SET @Edad = YEAR(getdate()) - YEAR(@fechaNacimiento)

		if @Edad < 21 begin
		Raiserror('Debe ser mayor a 21 para ser cliente',16,0)
		return
	END
	INSERT INTO Clientes (Apellido, Nombre, FechaNacimiento, Celular, Telefono, Mail, Saldo)
	VALUES (@Apellido, @Nombre, @FechaNacimiento, @Celular, @Telefono, @Mail, 0)
END

EXEC SP_NuevoCliente 'Alejandro', 'Rimasa', '1992-07-01', '123456789', null, 'rimasa@hotmail.com'
--Hacemos fallar la edad
EXEC SP_NuevoCliente 'Alejandro2', 'Rimasa2', '2010-07-01', '1234567890', null, 'rimasa2@hotmail.com'
--Hacemos fallar telefono o celular
EXEC SP_NuevoCliente 'Alejandro', 'Rimasa', '1992-07-01', null, null, 'rimasa@hotmail.com'

--Ejemplo de creación de función de usuario

--Devolver la cantidad total de pasajes vendidos por ID excursión
CREATE or ALTER FUNCTION FN_TotalPasajesXExcursion(
	@ID_Excursion INT
)
returns int
as
BEGIN
	Declare @TotalPasajes INT
	 
	SELECT @TotalPasajes = COALESCE(SUM(CantidadPasajes),0) FROM VENTAS
	WHERE ID_Excursion = @ID_Excursion
	
	Return @TotalPasajes
END


--Uso de la funcion

SELECT E.ID_Destino, E.FechaHora, dbo.FN_TotalPasajesXExcursion(E.ID_Excursion) AS [Cant Tickets Vendidos]  FROM Excursiones AS E



SELECT * FROM Clientes