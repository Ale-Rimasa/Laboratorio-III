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

SELECT * FROM Pagos
SELECT * FROM Inscripciones