--A) Realizar una función llamada TotalDebitosxTarjeta que reciba un ID de Tarjeta y registre el total
--acumulado en pesos de movimientos de tipo débito que registró esa tarjeta. La función no debe
--contemplar el estado de la tarjeta para realizar el cálculo.

CREATE OR ALTER FUNCTION FN_TotalDebitosxTarjeta(
	@ID_Tarjeta INT
)
returns MONEY 
as
BEGIN 
	Declare @TotalAcumuladoPesos MONEY
		
	SELECT @TotalAcumuladoPesos = COALESCE(SUM(M.IMPORTE),0) FROM MOVIMIENTOS AS M
	WHERE M.TIPO = 'D' AND M.IDTARJETA = @ID_Tarjeta

	Return @TotalAcumuladoPesos
END
GO

--Ejemplo de uso en funcion

SELECT dbo.FN_TotalDebitosxTarjeta(2) AS TotalDebitos


--B) Realizar una función llamada TotalCreditosxTarjeta que reciba un ID de Tarjeta y registre el total
--acumulado en pesos de movimientos de tipo crédito que registró esa tarjeta. La función no debe
--contemplar el estado de la tarjeta para realizar el cálculo.


CREATE OR ALTER FUNCTION FN_TotalCreditosxTarjeta(
	@ID_Tarjeta INT
)
returns MONEY
as
BEGIN
	Declare @TotalAcumuladoPesos MONEY

	SELECT @TotalAcumuladoPesos = COALESCE(SUM(M.IMPORTE),0) FROM MOVIMIENTOS AS M
	WHERE M.TIPO = 'C' AND M.IDTARJETA = @ID_Tarjeta

	Return @TotalAcumuladoPesos
END

--Ejemplo de uso en funcion

SELECT dbo.FN_TotalCreditosxTarjeta(2) AS [Total de Pesos]

--C) Realizar una vista que permita conocer los datos de los usuarios y sus respectivas tarjetas. La misma
--debe contener: Apellido y nombre del usuario, número de tarjeta SUBE, estado de la tarjeta y saldo.

CREATE OR ALTER VIEW VW_DatosUsuarios_Tarjetas AS
SELECT CONCAT(U.APELLIDO,' ',U.NOMBRE) AS [APELLIDO NOMBRE], T.IDTARJETA,
	CASE	
		WHEN T.ESTADO = 1 THEN 'Activo'
		ELSE 'Inactivo'
	END AS [ESTADO TARJETA],
T.SALDO FROM USUARIOS AS U
	INNER JOIN TARJETAS AS T
		ON U.IDUSUARIO = T.IDUSUARIO
GO
SELECT * FROM VW_DatosUsuarios_Tarjetas

--D) Realizar una vista que permita conocer los datos de los usuarios y sus respectivos viajes. La misma
--debe contener: Apellido y nombre del usuario, número de tarjeta SUBE, fecha del viaje, importe del viaje,
--número de interno y nombre de la línea.
CREATE OR ALTER VIEW VW_DatosUsuarios_ConSusViajes AS
SELECT CONCAT(U.APELLIDO,' ',U.NOMBRE) AS [APELLIDO NOMBRE], T.IDTARJETA, V.FECHA, V.IMPORTE, V.NRO_INTERNO, L.NOMBRE FROM USUARIOS AS U
	INNER JOIN TARJETAS AS T
		ON U.IDUSUARIO = T.IDUSUARIO
	INNER JOIN VIAJES AS V
		ON T.IDTARJETA = V.IDTARJETA
	INNER JOIN LINEAS AS L
		ON V.IDLINEA = L.IDLINEA
GO
SELECT * FROM VW_DatosUsuarios_ConSusViajes

--E) Realizar una vista que permita conocer los datos estadísticos de cada tarjeta. La misma debe
--contener: Apellido y nombre del usuario, número de tarjeta SUBE, cantidad de viajes realizados, total de
--dinero acreditado (históricamente), cantidad de recargas, importe de recarga promedio (en pesos) y
--estado de la tarjeta.
-- Esta esta mal
CREATE OR ALTER VIEW VW_DatosEstadisticosTarjeta AS
SELECT CONCAT(U.APELLIDO,' ',U.NOMBRE) AS [APELLIDO NOMBRE], T.IDTARJETA,
(
SELECT COUNT(V.IDVIAJE) FROM VIAJES AS V WHERE T.IDTARJETA = V.IDTARJETA
) AS [CANTIDAD DE VIAJES REALIZADOS],
(
SELECT AVG(M.IMPORTE) FROM MOVIMIENTOS AS M WHERE M.IDTARJETA = T.IDTARJETA
) AS [RECARGA PROMEDIO],
	CASE 
		WHEN T.ESTADO = 1 THEN 'Activo'
		ELSE 'Inactivo'
	END AS [ESTADO TARJETA]
FROM USUARIOS AS U
	INNER JOIN TARJETAS AS T
		 ON U.IDUSUARIO = T.IDUSUARIO
GO

CREATE OR ALTER VIEW VW_DatosEstadisticosTarjetaa AS
SELECT 
    CONCAT(U.APELLIDO, ' ', U.NOMBRE) AS [APELLIDO NOMBRE], 
    T.IDTARJETA AS [NumeroTarjetaSUBE],   
    -- Cantidad de viajes realizados por la tarjeta
    COUNT(V.IDVIAJE) AS [CANTIDAD DE VIAJES REALIZADOS],    
    -- Total de dinero acreditado históricamente (solo movimientos de crédito)
    ISNULL(SUM(CASE WHEN M.TIPO = 'C' THEN M.IMPORTE ELSE 0 END), 0) AS [TOTAL DINERO ACREDITADO],    
    -- Cantidad de recargas (movimientos de crédito)
    COUNT(CASE WHEN M.TIPO = 'C' THEN M.IDMOVIMIENTOS ELSE NULL END) AS [CANTIDAD DE RECARGAS],    
    -- Importe promedio de las recargas (solo movimientos de crédito)
    CASE 
        WHEN COUNT(CASE WHEN M.TIPO = 'C' THEN M.IDMOVIMIENTOS ELSE NULL END) > 0 
        THEN AVG(CASE WHEN M.TIPO = 'C' THEN M.IMPORTE ELSE NULL END)
        ELSE 0 
    END AS [RECARGA PROMEDIO],    
    -- Estado de la tarjeta
    CASE 
        WHEN T.ESTADO = 1 THEN 'Activo'
        ELSE 'Inactivo'
    END AS [ESTADO TARJETA]    
FROM 
    USUARIOS AS U
INNER JOIN 
    TARJETAS AS T ON U.IDUSUARIO = T.IDUSUARIO
LEFT JOIN 
    VIAJES AS V ON T.IDTARJETA = V.IDTARJETA
LEFT JOIN 
    MOVIMIENTOS AS M ON T.IDTARJETA = M.IDTARJETA
GROUP BY 
    U.APELLIDO, U.NOMBRE, T.IDTARJETA, T.ESTADO;



SELECT * FROM VW_DatosEstadisticosTarjetaa