--La fábrica quiere evitar que empleados sin experiencia mayor a 5 años puedan
--generar producciones de piezas cuyo costo unitario de producción supere los $ 15.
--Hacer un trigger que asegure esta comprobación para registros de producción cuya
--fecha sea mayor a la actual. En caso de poder registrar la información, calcular el
--costo total de producción.

CREATE OR ALTER TRIGGER TR_Produccion ON Produccion
AFTER INSERT
AS BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

		DECLARE @AnioActual INT = YEAR(GETDATE()), @AnioAlta INT, @IDOperario BIGINT, @IDPieza BIGINT, @CostoUnitario MONEY, @Fecha DATE
		
		SELECT @IDOperario = IDOperario, @IDPieza = IDPieza, @Fecha = Fecha FROM inserted 

		SELECT @AnioAlta = AnioAlta FROM Operarios WHERE IDOperario = @IDOperario
		SELECT @CostoUnitario = CostoUnitarioProduccion FROM Piezas WHERE IDPieza = @IDPieza

		IF (@Fecha > GETDATE() AND (@AnioActual - @AnioAlta) < 5 AND @CostoUnitario > 15)
		BEGIN
			RAISERROR('No se permite producir piezas costosas para operarios con menos de 5 años',16,1)
			ROLLBACK TRANSACTION
		END

		ELSE
			BEGIN
				UPDATE Produccion SET CostoTotal = Cantidad * @CostoUnitario
					FROM Produccion AS PR
						INNER JOIN inserted AS I
							ON PR.IDProduccion = I.IDProduccion

		END

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
			RAISERROR('Falla en la comprobación',16,1)
			RETURN
	END CATCH
END
/*****************************************************************************************************************/
--Hacer un listado que permita visualizar el nombre del material, el nombre de la pieza
--y la cantidad de operarios que nunca produjeron esta pieza.

SELECT M.IDMaterial, P.Nombre, 
	(SELECT COUNT(*) FROM Operarios AS Ope WHERE NOT EXISTS 
		(SELECT 1 FROM Produccion AS PR WHERE PR.IDOperario = Ope.IDOperario AND PR.IDPieza = P.IDPieza)) AS CantidadOperarios 					
					FROM Materiales AS M
					INNER JOIN Piezas AS P
						ON M.IDMaterial = P.IDMaterial
GO

/*****************************************************************************************************************/
--Hacer un procedimiento almacenado llamado Punto_3 que reciba el nombre de un material y un valor porcentual
--(admite 2 decimales) y modifique el precio unitario de producción a partir de este valor porcentual 
--a todas las piezas que sean de estematerial.
--Por ejemplo:
-- Si el procedimiento recibe 'Acero' y 50. Debe aumentar el precio unitario de
--producción de todas las piezas de acero en un 50%.
-- Si el procedimiento recibe 'Vidrio' y -25. Debe disminuir el precio unitario de
--producción de todas las piezas de vidrio en un 25%.
--NOTA: No se debe permitir hacer un descuento del 100% ni un aumento mayor al 1000%.

CREATE OR ALTER PROCEDURE Punto_3(
	@NombreMaterial VARCHAR(50),
	@ValorPorcentual DECIMAL(5,2)
)
AS BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

		IF @ValorPorcentual = -100 OR @ValorPorcentual > 1000
			BEGIN
				RAISERROR('El descuento no puede ser del 100% ni el aumento mayor a 1000%',16,1)
				RETURN
			END

		UPDATE Piezas
			SET CostoUnitarioProduccion = CostoUnitarioProduccion * (1 + @ValorPorcentual / 100)
				WHERE IDMaterial = (Select IDMaterial FROM Materiales WHERE Nombre = @NombreMaterial)
		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
			ROLLBACK TRANSACTION
			RAISERROR ('Ingrese nuevamente un material y un porcentaje',16,1)
	END CATCH
END

EXEC Punto_3 'Acero', 150

SELECT * FROM Materiales
SELECT * FROM Piezas