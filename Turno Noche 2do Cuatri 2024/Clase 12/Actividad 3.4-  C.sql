--3) Realizar un trigger que al registrar una nueva tarjeta:
-- Le realice baja lógica a la última tarjeta del cliente.
-- Le asigne a la nueva tarjeta el saldo de la última tarjeta del cliente.
-- Registre la nueva tarjeta para el cliente (con el saldo de la vieja tarjeta, la fecha de alta de la tarjeta
--deberá ser la del sistema).

CREATE OR ALTER TRIGGER TR_NuevaTarjeta ON Tarjetas
AFTER INSERT
AS BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

		DECLARE @IDUsuario BIGINT, @IDTarjetaAntigua BIGINT, @SaldoAntiguo MONEY

		--Obtener el ID del usuario de la nueva tarjeta desde la tabla INSERTED
		SELECT @IDUsuario = IDUsuario FROM inserted

		--Buscar la ultima tarjeta activa del usuario
		SELECT TOP 1 @IDTarjetaAntigua = IDTARJETA, @SaldoAntiguo = SALDO FROM TARJETAS WHERE ESTADO = 1 AND IDUSUARIO = @IDUsuario ORDER BY FECHA_ALTA DESC

		--Baja lógica de la última tarjeta (cambiar a inactivo)
		IF @IDTarjetaAntigua IS NOT NULL
			BEGIN
				UPDATE TARJETAS
				SET ESTADO = 0
				WHERE IDTARJETA = @IDTarjetaAntigua
			END

		--Transferir el saldo de la tarjeta antigua a la nueva
		UPDATE TARJETAS SET SALDO = @SaldoAntiguo, FECHA_ALTA = GETDATE() WHERE IDTARJETA = (SELECT IDTARJETA FROM inserted)

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


SELECT * FROM TARJETAS

INSERT INTO TARJETAS (IDUSUARIO, FECHA_ALTA, SALDO,ESTADO)
VALUES (17, GETDATE(), 100, 1)

SELECT * FROM TARJETAS WHERE IDUSUARIO = 24 ORDER BY FECHA_ALTA DESC;