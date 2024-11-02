--A) Realizar una función llamada TotalDebitosxTarjeta que reciba un ID de Tarjeta y registre el total
--acumulado en pesos de movimientos de tipo débito que registró esa tarjeta. La función no debe
--contemplar el estado de la tarjeta para realizar el cálculo.

CREATE OR ALTER FUNCTION FN_TotalDebitosxTarjeta(
	@ID_Tarjeta INT
)
RETURNS MONEY
AS BEGIN
	DECLARE @TotalAcumuladoPesos MONEY

	SELECT @TotalAcumuladoPesos = COALESCE(SUM(M.IMPORTE),0)FROM Movimientos AS M
				WHERE M.TIPO = 'D' AND M.IDTARJETA = @ID_Tarjeta

				RETURN @TotalAcumuladoPesos
END

--B) Realizar una función llamada TotalCreditosxTarjeta que reciba un ID de Tarjeta y registre el total
--acumulado en pesos de movimientos de tipo crédito que registró esa tarjeta. La función no debe
--contemplar el estado de la tarjeta para realizar el cálculo.

CREATE OR ALTER FUNCTION FN_TotalCreditosxTarjeta(
	@ID_Tarjeta INT
)
RETURNS MONEY
AS BEGIN
	DECLARE @TotalAcumuladoTC MONEY

	SELECT @TotalAcumuladoTC = COALESCE(SUM) FROM MOVIMIENTOS AS M
		WHERE M.TIPO = 'C' AND M.IDTARJETA = @ID_Tarjeta

		RETURN @TotalAcumuladoTC
END

--C) Realizar una vista que permita conocer los datos de los usuarios y sus respectivas tarjetas. La misma
--debe contener: Apellido y nombre del usuario, número de tarjeta SUBE, estado de la tarjeta y saldo.
CREATE OR ALTER VIEW VW_DatosUsuariosConSusTarjetas AS
SELECT CONCAT(U.APELLIDO, ' ' ,U.Nombre) AS [AP NOM], T.IDTARJETA, T.ESTADO, T.SALDO FROM USUARIOS AS U
	INNER JOIN TARJETAS AS T
		ON U.IDUSUARIO = T.IDUSUARIO
GO
SELECT * FROM VW_DatosUsuarios_Tarjetas WHERE IDTARJETA = 1

--D) Realizar una vista que permita conocer los datos de los usuarios y sus respectivos viajes. La misma
--debe contener: Apellido y nombre del usuario, número de tarjeta SUBE, fecha del viaje, importe del viaje,
--número de interno y nombre de la línea.

CREATE OR ALTER VIEW VW_DatosUsuariosViajes AS
SELECT CONCAT(U.APELLIDO, ' ' ,U.NOMBRE) AS [APNOM], T.IDTARJETA, V.FECHA, V.IMPORTE, v.NRO_INTERNO FROM USUARIOS AS U
		INNER JOIN TARJETAS AS T
			ON U.IDUSUARIO = T.IDUSUARIO
		INNER JOIN VIAJES AS V
			ON T.IDTARJETA = V.IDTARJETA
