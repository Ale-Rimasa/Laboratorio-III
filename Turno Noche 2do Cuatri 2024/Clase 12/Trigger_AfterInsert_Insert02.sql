--Crear un trigger que al agregar un movimiento lo registre y actualice el saldo de la cuenta.
CREATE OR ALTER TRIGGER TR_NuevoMovimiento ON Movimientos
AFTER Insert
AS BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

		DECLARE @TipoMovimiento char, @IDCuenta int, @Importe money

		SELECT @TipoMovimiento = TipoMovimiento,
				@IDCuenta = IDCuenta,
				@Importe = Importe
		FROM inserted
		--Si es un debito, que el importe sea negativo
			IF @TipoMovimiento = 'D' BEGIN
				SET @Importe = @Importe * -1
			END

		UPDATE CUENTAS SET Saldo = Saldo + @Importe	WHERE IDCuenta = @IDCuenta

		IF @@TRANCOUNT > 0 BEGIN
			COMMIT TRANSACTION
		END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 BEGIN
			ROLLBACK TRANSACTION
		END
	END CATCH
END

SELECT * FROM Cuentas
SELECT * FROM Movimientos
--Crear un movimiento de credito
INSERT INTO Movimientos(IDCuenta,Fecha,Importe,TipoMovimiento)
VALUES (14,GETDATE(),100,'C')
--Crear un movimiento de débito suficiente
INSERT INTO Movimientos(IDCuenta,Fecha,Importe,TipoMovimiento)
VALUES (14,GETDATE(),70,'D')