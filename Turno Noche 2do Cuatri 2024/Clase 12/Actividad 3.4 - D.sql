--4) Realizar un trigger que al eliminar un Usuario:
-- Elimine el cliente
-- Elimine todas las tarjetas del cliente
-- Elimine todos los movimientos de sus tarjetas
-- Elimine todos los viajes de sus tarjetas

CREATE OR ALTER TRIGGER TR_BajaCliente ON USUARIOS
AFTER DELETE
AS BEGIN
	BEGIN TRY
			BEGIN TRANSACTION

			DECLARE @IDUsuario BIGINT

			SELECT @IDUsuario = IDUSUARIO FROM deleted

			DELETE FROM VIAJES WHERE IDTARJETA IN (SELECT IDTARJETA FROM TARJETAS WHERE IDUSUARIO = @IDUsuario )

			DELETE FROM MOVIMIENTOS WHERE IDTARJETA IN (SELECT IDTARJETA FROM TARJETAS WHERE IDUSUARIO = @IDUsuario )

			DELETE FROM TARJETAS WHERE IDUSUARIO = @IDUsuario

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



SELECT * FROM USUARIOS
SELECT * FROM VIAJES
SELECT * FROM MOVIMIENTOS
SELECT * FROM TARJETAS
DELETE FROM USUARIOS WHERE IDUSUARIO = 10004

DELETE FROM TARJETAS WHERE IDUSUARIO = 10004;