--2)Haciendo uso de la base de datos que se encuentra en el Campus Virtual resolver:
--Hacer una función SQL que a partir de un legajo docente y un año devuelva la cantidad de horas semanales
--que dedicará esa persona a la docencia ese año. La cantidad de horas es un número entero >= 0.
--NOTA: No hay que multiplicar el valor por la cantidad de semanas que hay en un año.

CREATE OR ALTER FUNCTION FN_HorasSemanalesDocente(
	@Legajo BIGINT,
	@AñoIngreso INT
)
RETURNS TINYINT
AS BEGIN

DECLARE @HorasSemanalTotales TINYINT

	SELECT @HorasSemanalTotales =COALESCE(SUM(M.HorasSemanales),0) FROM PlantaDocente AS PC
		INNER JOIN Materias AS M
			ON PC.ID_Materia = M.ID_Materia
				WHERE PC.Legajo = @Legajo AND PC.Año = @AñoIngreso
			
			RETURN @HorasSemanalTotales
END

SELECT * FROM Materias
SELECT * FROM Docentes
SELECT dbo.