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

/*********************************************************************************************************************/
--Hacer una función llamada Fn_PuntajeCurso que a partir de un IDCurso devuelva
--el promedio de puntaje en concepto de reseñas.

CREATE OR ALTER FUNCTION FN_PuntajeCurso(
	@IDCurso bigint
)
	RETURNS DECIMAL(4,2)
AS BEGIN
	
	DECLARE @PromedioPuntajeReseñaXCurso DECIMAL(4,2)
		
		SELECT @PromedioPuntajeReseñaXCurso = ISNULL(AVG(R.Puntaje),0) FROM Inscripciones AS I	
			INNER JOIN Reseñas AS R
				ON I.ID = R.IDInscripcion
					WHERE I.IDCurso = @IDCurso

			RETURN @PromedioPuntajeReseñaXCurso
END

SELECT dbo.FN_PuntajeCurso(2) AS [Puntaje Curso]
GO

/*********************************************************************************************************************/
--Hacer una vista que muestre por cada usuario el apellido y nombre, una columna
--llamada Contacto que muestre el celular, si no tiene celular el teléfono, si no tiene
--teléfono el email, si no tiene email el domicilio. También debe mostrar la edad del
--usuario, el total pagado y el total adeudado.

CREATE OR ALTER VIEW VW_ContactoUsuario AS 
SELECT U.ID ,CONCAT(DP.Apellidos, ' ', DP.Nombres) AS [NombreCompleto],
	CASE 
		WHEN DP.Celular IS NOT NULL THEN DP.Celular
		WHEN DP.Telefono IS NOT NULL THEN DP.Telefono
		WHEN DP.Email IS NOT NULL THEN DP.Email
		ELSE
			DP.Domicilio
		END AS [Contacto],
		DATEDIFF(YEAR,DP.Nacimiento,GETDATE()) AS EDAD,
		SUM(P.Importe) AS [Total Pagado],
		ISNULL(SUM(P.Importe),0) - I.Costo AS [Adeuda]
FROM Usuarios AS U
	INNER JOIN Datos_Personales AS DP
		ON U.ID = DP.ID
	INNER JOIN Inscripciones AS I
		ON U.ID = I.IDUsuario
	INNER JOIN PAGOS AS P
		ON I.ID = P.IDInscripcion
			GROUP BY DP.Apellidos, Dp.Nombres, Dp.Nacimiento,I.Costo, DP.Celular,Dp.Telefono, DP.Email, DP.Domicilio, U.ID

SELECT * FROM VW_ContactoUsuario WHERE ID = 1
/*********************************************************************************************************************/
--Hacer uso de la vista creada anteriormente para obtener la cantidad de usuarios que
--adeuden más de los que pagaron.

SELECT COUNT(ID)AS [Cantidad Usuarios que adeudan] FROM VW_ContactoUsuario WHERE Adeuda > 0

/*********************************************************************************************************************/
--Hacer un procedimiento almacenado que permita dar de alta un nuevo curso. Debe
--recibir todos los valores necesarios para poder insertar un nuevo registro.

CREATE OR ALTER PROCEDURE SP_AltaCurso(
	@IDNivel tinyint,
	@Nombre Varchar(100),
	@CostoCurso MONEY,
	@CostoCertificacion MONEY,
	@ESTRENO DATE,
	@DebeSerMayorDeEdad bit
)
AS BEGIN
	INSERT INTO Cursos (IDNivel,Nombre,CostoCurso,CostoCertificacion,Estreno,DebeSerMayorDeEdad)
	VALUES(@IDNivel,@Nombre,@CostoCurso,@CostoCertificacion,@ESTRENO,@DebeSerMayorDeEdad)
END

EXEC SP_AltaCurso 4, 'JAVA intermedio', 10000, 5000, '2025-07-01', 0

SELECT * FROM Cursos

/*********************************************************************************************************************/
--Hacer un procedimiento almacenado que permita modificar porcentualmente el
--Costo de Cursada de todos los cursos. El procedimiento debe recibir un valor
-numérico que representa el valor a aumentar porcentualmente. Por ejemplo, si recibe
--un 60. Debe aumentar un 60% todos los costos.

CREATE OR ALTER PROCEDURE SP_PorcentajeCostoCursada(
	@NumeroPorcentaje DECIMAL(5,2)
)
AS BEGIN
	
	IF @NumeroPorcentaje <= 0
		BEGIN
		RAISERROR('El porcentaje es menor o igual a cero',16,1)
		RETURN
	END
	UPDATE Cursos SET CostoCurso = CostoCurso * (1+@NumeroPorcentaje / 100) 

END

EXEC SP_PorcentajeCostoCursada 5
SELECT * FROM Cursos
/*********************************************************************************************************************/
--Hacer un procedimiento almacenado llamado SP_PagarInscripcion que a partir
--de un IDInscripcion permita hacer un pago de la inscripción. El pago puede ser menor
--al costo de la inscripción o bien el total del mismo. El sistema no debe permitir que el
--usuario pueda abonar más dinero para una inscripción que el costo de la misma. Se
--debe registrar en la tabla de pagos con la información que corresponda.

CREATE OR ALTER PROCEDURE SP_PagaInscripcion(
	@IDInscripcion BIGINT,
	@MontoPado MONEY
)
AS BEGIN
	--Valido si esta el IDInscripcion
	IF @IDInscripcion IS NOT NULL