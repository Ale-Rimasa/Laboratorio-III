--B) Realizar un procedimiento almacenado llamado sp_Agregar_Tarjeta que dé de alta una tarjeta. El
--procedimiento solo debe recibir el DNI del usuario.
--Como el sistema sólo permite una tarjeta activa por usuario, el procedimiento debe:
--Dar de baja la última tarjeta del usuario (si corresponde).
--Dar de alta la nueva tarjeta del usuario
--Traspasar el saldo de la vieja tarjeta a la nueva tarjeta (si corresponde)

CREATE OR ALTER PROCEDURE SP_Agregar_Tarjeta(
	@DNI varchar(10)
)
AS BEGIN
	DECLARE @IDUsuario BIGINT, @TarjetaActiva BIGINT, @Saldo MONEY

	BEGIN TRANSACTION
			BEGIN TRY
			--Obtener el ID del usuario a partir del DNI
			SELECT @IDUsuario = U.IDUSUARIO FROM USUARIOS AS U WHERE @DNI = DNI

			-- Verifico si el Usuario esta en la BD
			IF @IDUsuario IS NULL BEGIN
					RAISERROR('Usuario no encontrado',16,1)
					ROLLBACK TRANSACTION
				RETURN
			END

			--Verificar tarjeta activa, capturamos la tarjeta y el saldo
			SELECT @TarjetaActiva = T.IDTARJETA, @Saldo = T.SALDO FROM TARJETAS AS T
						WHERE T.ESTADO = 1 AND T.IDUSUARIO = @IDUsuario
			--Verificamos que el usuario tenga una tarjeta activa
			IF @TarjetaActiva IS NOT NULL BEGIN
			--Damos de baja la tarjeta
				UPDATE TARJETAS SET ESTADO = 0 WHERE IDTARJETA = @TarjetaActiva
			END
			--Dar de alta nueva tarjeta
			INSERT INTO TARJETAS (IDUSUARIO,FECHA_ALTA,SALDO,ESTADO)
				VALUES (@IDUsuario,GETDATE(),0,1)
			--Obtenemos el ID de la nueva tarjeta para traspasar el dinero
			DECLARE @IDTarjetaNueva BIGINT
				SET @IDTarjetaNueva = SCOPE_IDENTITY()
			--Traspasamos el saldo de la tarjeta vieja a la nueva, si esta tenía saldo.
			IF @Saldo > 0 BEGIN
				UPDATE TARJETAS 
					SET SALDO = @Saldo
						WHERE IDTARJETA = @IDTarjetaNueva
			END
	COMMIT TRANSACTION
			END TRY

			BEGIN CATCH

	ROLLBACK TRANSACTION
			RAISERROR('Error al cambiar tarjeta al usuario',16,1)

			END CATCH

END
GO

--C) Realizar un procedimiento almacenado llamado sp_Agregar_Viaje que registre un viaje a una tarjeta
--en particular. El procedimiento debe recibir: Número de tarjeta, importe del viaje, nro de interno y nro de
--línea.
--El procedimiento deberá:
--Descontar el saldo
--Registrar el viaje
--Registrar el movimiento de débito

CREATE OR ALTER PROCEDURE SP_Agregar_Viaje(
	@NumeroTarjeta BIGINT,
	@ImporteViaje MONEY,
	@NroInterno BIGINT,
	@NroLinea BIGINT
)
AS BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
		
		DECLARE @SaldoTarjeta MONEY
	--Verificamos tarjeta si existe y guardamos saldo
	SELECT @SaldoTarjeta = T.SALDO FROM TARJETAS AS T WHERE T.IDTARJETA = @NumeroTarjeta AND T.ESTADO = 1
	
	--Si no existe tarjeta
	IF  @SaldoTarjeta IS NULL
		BEGIN 
			ROLLBACK TRANSACTION
			RAISERROR('No existe tarjeta',16,1)
		RETURN
		END

	--Verificamos si la tarjeta no tiene deuda mayor a 2000
	IF(@SaldoTarjeta - @ImporteViaje) < -2000
		BEGIN
		ROLLBACK TRANSACTION
			RAISERROR('Deuda supera los 2000, ',16,1)
		RETURN
		END
	--Registro de viaje
	INSERT INTO VIAJES (FECHA,NRO_INTERNO,IDLINEA,IDTARJETA,IMPORTE)
	VALUES	(GETDATE(),@NroInterno,@NroLinea,@NumeroTarjeta,@ImporteViaje)

	--Registro el movimiento del debito
	INSERT INTO MOVIMIENTOS (FECHA,IDTARJETA,IMPORTE,TIPO)
	VALUES (GETDATE(),@NumeroTarjeta,@ImporteViaje,'D')

	--Actualizamos el saldo de la tarjeta
	UPDATE TARJETAS
		SET SALDO = SALDO - @ImporteViaje	WHERE IDTARJETA = @NumeroTarjeta
	
	COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		ROLLBACK TRANSACTION
		RAISERROR('Error al agregar viaje',16,1)
		END CATCH
END
GO

--D) Realizar un procedimiento almacenado llamado sp_Agregar_Saldo que registre un movimiento de
--crédito a una tarjeta en particular. El procedimiento debe recibir: El número de tarjeta y el importe a
--recargar. Modificar el saldo de la tarjeta.

CREATE OR ALTER PROCEDURE SP_Agregar_Saldo(
	@NumeroTarjeta BIGINT,
	@ImporteRecarga MONEY
)
AS BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			DECLARE @SaldoTarjeta MONEY
		--Verificamos si existe tarjeta y guardamos el saldo
		SELECT @SaldoTarjeta = T.SALDO FROM TARJETAS AS T WHERE T.ESTADO = 1 AND T.IDTARJETA = @NumeroTarjeta

		--Si tarjeta no existe
		IF @SaldoTarjeta IS NULL
			BEGIN 
			ROLLBACK TRANSACTION
				RAISERROR('Tarjeta no existe en la base de datos',16,1)
			RETURN
		END

		--Registro del movimiento
		INSERT INTO MOVIMIENTOS (FECHA,IDTARJETA,IMPORTE,TIPO)
		VALUES (GETDATE(), @NumeroTarjeta, @ImporteRecarga,'C')

		--ACtualizar saldo de tarjeta
		UPDATE TARJETAS
			SET SALDO = SALDO + @ImporteRecarga
				WHERE IDTARJETA = @NumeroTarjeta
		PRINT 'Saldo cargado correctamente'
		
	COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
		ROLLBACK TRANSACTION
			RAISERROR('No se pudo realizar la carga de la SUBE',16,1)
		END CATCH

END
GO


--E) Realizar un procedimiento almacenado llamado sp_Baja_Fisica_Usuario que elimine un usuario del
--sistema. La eliminación deberá ser 'en cascada'. Esto quiere decir que para cada usuario primero
--deberán eliminarse todos los viajes y recargas de sus respectivas tarjetas. Luego, todas sus tarjetas y
--por último su registro de usuario.

CREATE OR ALTER PROCEDURE SP_Baja_Fisica_Usuario(
	@IDUsuario BIGINT
)
AS BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
		--Chequeo del usuario si existe
			IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE IDUSUARIO = @IDUsuario)
			BEGIN
				ROLLBACK TRANSACTION
					RAISERROR('Usuario no encontrado',16,1)
				RETURN
			END
		--Eliminamos el viaje
		DELETE FROM VIAJES WHERE IDTARJETA IN (SELECT IDTARJETA FROM TARJETAS WHERE IDUSUARIO = @IDUsuario)

		--Eliminamos movimientos
		DELETE FROM MOVIMIENTOS WHERE IDTARJETA IN (SELECT IDTARJETA FROM TARJETAS WHERE IDUSUARIO = @IDUsuario)

		--Eliminamos la tarjeta
		DELETE FROM TARJETAS WHERE IDUSUARIO = @IDUsuario

		--Eliminamos Usuario
		DELETE FROM USUARIOS WHERE IDUSUARIO = @IDUsuario
		PRINT 'El usuario y todos sus datos fueron eliminados'

	COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
	ROLLBACK TRANSACTION
	RAISERROR('No se pudo dar la baja del usuario',16,1)
		END CATCH
END