CREATE OR ALTER PROCEDURE SP_ExtraerDinero(
	@IDCuenta int,
	@ImporteAExtraer money
) 
AS Begin		--El insert y el update pueden fallar, como se puede detectar esto ? TRY y CATCH
				--Y si no hubo errores que permite confirmar las acciones o si hubo al menos un error cancelar todo- Transaccion
	Begin Transaction
	BEGIN TRY
	INSERT INTO Movimientos (IDCuenta, Fecha, Importe, TipoMovimiento)
	VALUES(@IDCuenta, GETDATE(), @ImporteAExtraer, 'D')

	UPDATE Cuentas SET Saldo = Saldo - @ImporteAExtraer WHERE IDCuenta = @IDCuenta
		Commit Transaction
	END TRY
	BEGIN CATCH
		Rollback Transaction
		Raiserror('Hubo un error al registrar la extracción', 16, 1)
	END CATCH
END

SELECT * FROM Cuentas WHERE IDCuenta = 2
SELECT * FROM Movimientos WHERE IDCuenta = 2

Exec SP_ExtraerDinero 2, 250