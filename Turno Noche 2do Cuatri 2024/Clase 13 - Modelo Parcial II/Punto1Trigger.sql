--Haciendo uso de la base de datos que se encuentra en el Campus Virtual resolver:
--Hacer un trigger que al ingresar un registro no permita que un docente pueda tener una materia con el
--cargo de profesor (IDCargo = 1) si no tiene una antigüedad de al menos 5 años.
--Tampoco debe permitir que haya más de un docente con el cargo de profesor (IDCargo = 1) en la misma materia y año.
--Caso contrario registrar el docente a la planta docente.


CREATE OR ALTER TRIGGER TR_RegistroDocente ON PlantaDocente
INSTEAD OF INSERT
AS BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

		DECLARE @Antiguedad INT, @Legajo BIGINT, @ID_Materia BIGINT, @ID_Cargo TINYINT, @Año INT
			
			SELECT @Legajo = Legajo, @ID_Materia = ID_Materia, @ID_Cargo = ID_Cargo, @Año = Año
						FROM inserted
			
			SELECT @Antiguedad = YEAR(GETDATE()) - D.AñoIngreso FROM Docentes AS D
					WHERE D.Legajo = @Legajo

			IF @ID_Cargo = 1 AND @Antiguedad < 5
				BEGIN
					ROLLBACK TRANSACTION
						RAISERROR('El docente no cumple con los requisitos para el cargo', 16,1)
						RETURN
				END

			IF EXISTS ( SELECT 1 FROM PlantaDocente WHERE ID_Materia = @ID_Materia AND Año = @Año AND ID_Cargo = 1)
				BEGIN
				ROLLBACK TRANSACTION
					RAISERROR('Existe un docente con el cargo en esta materia',16,1)
					RETURN
				END
		IF @@TRANCOUNT > 0 BEGIN
		COMMIT TRANSACTION
		END
	END TRY
	BEGIN CATCH
	IF @@TRANCOUNT > 0 BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('Falla al realizar la carga del docente',16,1)
	END
	END CATCH
END


SELECT * FROM PlantaDocente
SELECT * FROM Docentes
SELECT * FROM Cargos
SELECT * FROM Materias

INSERT INTO PlantaDocente (Legajo, ID_Materia, ID_Cargo, Año)
VALUES (1, 2, 1, 2024)

INSERT INTO PlantaDocente (Legajo, ID_Materia, ID_Cargo, Año)
VALUES (2, 1, 1, 2024)

INSERT INTO PlantaDocente (Legajo, ID_Materia, ID_Cargo, Año)
VALUES (3, 1, 1, 2023)

--FALLA por antiguedad
INSERT INTO PlantaDocente (Legajo, ID_Materia, ID_Cargo, Año) 
VALUES (18, 1, 1, 2024)
--FALLA por docente con cargo = 1 en materia
INSERT INTO PlantaDocente (Legajo, ID_Materia, ID_Cargo, Año)
VALUES (2, 1, 1, 2020)
--FALLA en ambas condiciones:
INSERT INTO PlantaDocente (Legajo, ID_Materia, ID_Cargo, Año)
VALUES (17, 1, 1, 2020)