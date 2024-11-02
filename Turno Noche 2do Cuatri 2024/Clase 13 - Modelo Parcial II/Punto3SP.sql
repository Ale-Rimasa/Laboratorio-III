--Haciendo uso de la base de datos que se encuentra en el Campus Virtual resolver:
--Hacer un procedimiento almacenado que reciba un ID de Materia y 
--liste la cantidad de docentes distintos que han trabajado en ella.


CREATE OR ALTER PROCEDURE SP_CantDocentesXMateria(
	@ID_Materia BIGINT
)
AS BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

		SELECT COUNT(DISTINCT PC.Legajo) AS [Docentes Totales], M.Nombre FROM PlantaDocente AS PC
				INNER JOIN Materias AS M
					ON PC.ID_Materia = M.ID_Materia
			WHERE PC.ID_Materia = @ID_Materia
			GROUP BY M.Nombre

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Materia inexisistente',16,1)
	END CATCH
END

EXEC SP_CantDocentesXMateria 2