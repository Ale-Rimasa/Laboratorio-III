CREATE OR ALTER PROCEDURE SP_CrearCliente(
	@IDCliente bigint,
	@Apellidos varchar(50),
	@Nombres varchar(50)
)
AS BEGIN
	INSERT INTO Clientes (IDCliente,Apellidos,Nombres,Estado)
		Values (@IDCliente,@Apellidos,@Nombres,0)
END

EXEC SP_CrearCliente 8, 'Gonzales', 'Henry'

SELECT * FROM Clientes

--Borrar un Proc Almacenado
DROP PROCEDURE SP_CrearCliente