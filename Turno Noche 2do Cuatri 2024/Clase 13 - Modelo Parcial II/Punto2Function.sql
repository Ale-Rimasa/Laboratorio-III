--2)Haciendo uso de la base de datos que se encuentra en el Campus Virtual resolver:
--Hacer una funci�n SQL que a partir de un legajo docente y un a�o devuelva la cantidad de horas semanales
--que dedicar� esa persona a la docencia ese a�o. La cantidad de horas es un n�mero entero >= 0.
--NOTA: No hay que multiplicar el valor por la cantidad de semanas que hay en un a�o.

CREATE OR ALTER FUNCTION FN_HorasSemanalesDocente(
	@Legajo BIGINT,
	@A�oIngreso INT
)
RETURNS TINYINT
AS BEGIN

DECLARE @HorasSemanalTotales TINYINT

	SELECT @HorasSemanalTotales =COALESCE(SUM(M.HorasSemanales),0) FROM PlantaDocente AS PC
		INNER JOIN Materias AS M
			ON PC.ID_Materia = M.ID_Materia
				WHERE PC.Legajo = @Legajo AND PC.A�o = @A�oIngreso
			
			RETURN @HorasSemanalTotales
END

SELECT * FROM Materias
SELECT * FROM Docentes
SELECT dbo.