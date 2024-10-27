--1) Realizar un trigger que al agregar un viaje:
-- Verifique que la tarjeta se encuentre activa.
-- Verifique que el saldo de la tarjeta sea suficiente para realizar el viaje.
-- Registre el viaje
-- Registre el movimiento
-- Descuente el saldo de la tarjeta

CREATE OR ALTER TRIGGER TR_NuevoViaje ON Viajes
AFTER INSERT
AS BEGIN
	BEGIN TRY
			BEGIN TRANSACTION

			DECLARE @IDTarjeta BIGINT, @SaldoTarjeta MONEY, @ImporteViaje MONEY
			--Datos del nuevo viaje
			SELECT @IDTarjeta = IDTarjeta,
					@ImporteViaje = IMPORTE
				FROM inserted
		--Verifico que la tarjeta este activa
			IF NOT EXISTS (SELECT 1 FROM TARJETAS WHERE @IDTarjeta = IDTARJETA AND ESTADO = 1)
			BEGIN
				RAISERROR('La tarjeta no está activa',16,1)
				ROLLBACK TRANSACTION
				RETURN
			END
		--Guardo el saldo actual de la tarjeta
			SELECT @SaldoTarjeta = SALDO FROM TARJETAS WHERE IDTARJETA = @IDTarjeta
		--Verifico si el saldo alcanza para viajar
			IF @SaldoTarjeta < @ImporteViaje
			BEGIN
				RAISERROR('Saldo insuficiente para realizar el viaje',16,1)
				ROLLBACK TRANSACTION
				RETURN
			END
		-- Registrar el movimiento de debito en este caso.
		INSERT INTO MOVIMIENTOS (FECHA,IDTARJETA,IMPORTE,TIPO)
		VALUES (GETDATE(), @IDTarjeta, @ImporteViaje, 'D')
		
		--Guardo saldo de la tarjeta
		UPDATE TARJETAS SET SALDO = SALDO - @ImporteViaje
			WHERE IDTARJETA = @IDTarjeta

		IF @@TRANCOUNT > 0 BEGIN
			COMMIT TRANSACTION
		END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 BEGIN
			ROLLBACK TRANSACTION
			RAISERROR('ERROR AL REGISTRAR EL VIAJE',16,1)
		END
	END CATCH
END
GO

SELECT * FROM VIAJES
SELECT * FROM MOVIMIENTOS

INSERT INTO VIAJES(FECHA, NRO_INTERNO,IDLINEA,IDTARJETA,IMPORTE)
VALUES (getdate(), 110, 1, 10006, 50)
GO

