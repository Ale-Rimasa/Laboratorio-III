--Hacer una función llamada FN_PagosxUsuario que a partir de un IDUsuario
--devuelva el total abonado en concepto de pagos. Si no hay pagos debe retornar 0.


CREATE OR ALTER FUNCTION FN_PagosxUsuario(
	@IDUsuario INT
)
returns money
as
BEGIN
	Declare @TotalAbonado money

	SELECT @TotalAbonado = SUM(P.Importe) FROM Pagos AS P
		INNER JOIN Inscripciones AS I
			ON P.IDInscripcion = I.ID
		WHERE I.IDUsuario = @IDUsuario

		RETURN ISNULL(@TotalAbonado,0);
END		


SELECT U.ID, dbo.FN_PagosxUsuario(U.ID) AS [Total abonado] FROM Usuarios AS U
	Where U.ID = 6

/********************************************************************************************************************/

--Hacer una función llamada FN_DeudaxUsuario que a partir de un IDUsuario
--devuelva el total adeudado. Si no hay deuda debe retornar 0.

CREATE OR ALTER FUNCTION FN_DeudaxUsuario(
	@IDUsuario INT
)
	Returns money
AS BEGIN
	DECLARE @SumaPago MONEY = 0, @SumaCosto MONEY = 0, @TotalAdeudado MONEY

	SELECT @SumaCosto = ISNULL(SUM(I.Costo),0) FROM Inscripciones AS I WHERE I.IDUsuario = @IDUsuario
	
	SELECT @SumaPago = ISNULL(SUM(P.Importe),0) FROM Pagos AS P 
		INNER JOIN Inscripciones AS I
			ON P.IDInscripcion = I.ID WHERE I.IDUsuario = @IDUsuario

	SET @TotalAdeudado = @SumaCosto - @SumaPago			

			RETURN ISNULL(@TotalAdeudado,0)
END

SELECT ID, dbo.FN_DeudaxUsuario(ID) AS [Deuda del usuario] FROM Usuarios WHERE ID= 39


/********************************************************************************************************************/
--Hacer una función llamada FN_CalcularEdad que a partir de un IDUsuario devuelva
--la edad del mismo. La edad es un valor entero.

CREATE OR ALTER FUNCTION FN_CalcularEdad(
	@IDUsuario INT
)
	returns INT
AS BEGIN
	DECLARE @Edad INT, @FechaNac DATE
	--Fecha nacimiento del usuario
	SELECT @FechaNac= DP.Nacimiento FROM Usuarios AS U
		INNER JOIN Datos_Personales AS DP
			ON U.ID = DP.ID
				WHERE U.ID = @IDUsuario
	--Calculo de edad
	IF @FechaNac IS NOT NULL
		BEGIN
			SELECT @Edad = DATEDIFF(YEAR,@FechaNac,GETDATE())
		   -CASE 
				WHEN DATEADD(YEAR,DATEDIFF(YEAR,@FechaNac,GETDATE()), @FechaNac) > GETDATE()
				THEN 1
				ELSE 0
			END
END
	ELSE
		SET @Edad = NULL

	RETURN @Edad
END

SELECT CONCAT(DP.Apellidos,' ', DP.Nombres),dbo.FN_CalcularEdad(U.ID) AS [EDAD] FROM Usuarios AS U
		INNER JOIN Datos_Personales AS DP
			ON U.ID = DP.ID
WHERE U.ID = 2

--Hacer una función llamada Fn_PuntajeCurso que a partir de un IDCurso devuelva
--el promedio de puntaje en concepto de reseñas.

CREATE OR ALTER FUNCTION FN_PuntajeCurso(
	@IDCurso bigint
)
	RETURNS DECIMAL
AS BEGIN
	
