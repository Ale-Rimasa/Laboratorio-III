--A)Realizar un procedimiento almacenado llamado sp_Agregar_Usuario que permita registrar un usuario
--en el sistema. El procedimiento debe recibir como parámetro DNI, Apellido, Nombre, Fecha de
--nacimiento y los datos del domicilio del usuario.

CREATE OR ALTER PROCEDURE SP_Agregar_Usuario(
	@DNI BIGINT,
	@Apellido Varchar(50),
	@Nombre Varchar(50),
	@FechaNac DATE,
	@Domicilio Varchar(50)
)
AS
	BEGIN
		 INSERT INTO USUARIOS (DNI, APELLIDO,NOMBRE,FECHA_NAC,DOMICILIO, ESTADO)
		 VALUES(@DNI, @Apellido, @Nombre, @FechaNac, @Domicilio,1)
	END

--PRUEBA SP_Agregar_Usuario

EXEC SP_Agregar_Usuario '1111111111', 'Rimasa', 'Alejandro', '1992-07-01', 'Rivadavia 1000'

GO
/********************************************************************************************************************************************/
--B) Realizar un procedimiento almacenado llamado sp_Agregar_Tarjeta que dé de alta una tarjeta. El
--procedimiento solo debe recibir el DNI del usuario.
--Como el sistema sólo permite una tarjeta activa por usuario, el procedimiento debe:
--Dar de baja la última tarjeta del usuario (si corresponde).
--Dar de alta la nueva tarjeta del usuario
--Traspasar el saldo de la vieja tarjeta a la nueva tarjeta (si corresponde)


CREATE OR ALTER PROCEDURE SP_Agregar_Tarjeta(
	@DNI VARCHAR(10)
)
AS	BEGIN
		
	DECLARE @ID_Usuario BIGINT, @TarjetaActiva BIGINT, @SaldoTarjetaActiva MONEY
	
	--Obtener el ID del usuario a partir del DNI
	SELECT @ID_Usuario = U.IDUSUARIO FROM USUARIOS AS U WHERE U.DNI = @DNI

	-- Verifico si el Usuario esta en la BD
	IF @ID_Usuario IS NULL BEGIN
		RAISERROR('Usuario no se encuentra',16,0)
		return
	END
	--Verificar tarjeta activa, capturamos la tarjeta y el saldo
	SELECT @TarjetaActiva = T.IDTARJETA, @SaldoTarjetaActiva = T.SALDO   FROM TARJETAS as T WHERE T.ESTADO = 1 AND T.IDUSUARIO = @ID_Usuario

	--Verificamos que el usuario tenga una tarjeta activa
	IF @TarjetaActiva IS NOT NULL BEGIN
		--Damos de baja la tarjeta
		UPDATE TARJETAS SET ESTADO = 0
			WHERE IDTARJETA = @TarjetaActiva
	END
	--Dar de alta nueva tarjeta
	INSERT INTO TARJETAS (IDUSUARIO,FECHA_ALTA,SALDO,ESTADO)
	VALUES(@ID_Usuario,GETDATE(),0,1)

	--Obtenemos el ID de la nueva tarjeta
	DECLARE @IDTarjetaNueva BIGINT
		SET @IDTarjetaNueva = SCOPE_IDENTITY()

	--Traspasamos el saldo de la tarjeta vieja a la nueva, si esta tenía saldo.

	IF @TarjetaActiva > 0 
		BEGIN
		UPDATE TARJETAS
		SET SALDO = @SaldoTarjetaActiva
			WHERE IDTARJETA = @IDTarjetaNueva
		END
END
GO

--C) Realizar un procedimiento almacenado llamado sp_Agregar_Viaje que registre un viaje a una tarjeta
--en particular. El procedimiento debe recibir: Número de tarjeta, importe del viaje, nro de interno y nro de línea.
--El procedimiento deberá:
--Descontar el saldo
--Registrar el viaje
--Registrar el movimiento de débito
--NOTA: Una tarjeta no puede tener una deuda que supere los $2000.

CREATE OR ALTER PROCEDURE SP_Agregar_Viaje(
	@IDTARJETA BIGINT,
	@IMPORTE MONEY,
	@NRO_INTERNO BIGINT,
	@IDLINEA BIGINT
)
AS BEGIN
	BEGIN TRY
	DECLARE @SaldoActualTarjeta MONEY
	--Verificamos tarjeta si existe y guardamos saldo
	SELECT @SaldoActualTarjeta = T.SALDO FROM TARJETAS AS T WHERE T.ESTADO = 1 AND T.IDTARJETA = @IDTARJETA

	--Si no existe tarjeta..
	IF @SaldoActualTarjeta IS NULL
		BEGIN
			RAISERROR('Tarjeta inexistente o inactiva',16,0)
		RETURN
	END
	
	--Verificar que la tarjeta NO tenga deuda mayor a 2000
	IF(@SaldoActualTarjeta - @IMPORTE) < -2000
		BEGIN
			RAISERROR('Recargue tarjeta, deuda excedida',16,0)
		RETURN
	END

	--Registrar el viaje
	INSERT INTO VIAJES (FECHA,NRO_INTERNO,IDLINEA,IDTARJETA,IMPORTE)
		VALUES (GETDATE(),@NRO_INTERNO,@IDLINEA,@IDTARJETA,@IMPORTE)

	--Registro del movimiento del debito
	INSERT INTO MOVIMIENTOS(FECHA,IDTARJETA,IMPORTE,TIPO)
		VALUES (GETDATE(),@IDTARJETA,@IMPORTE,'D')

	--Actualizar saldo de la tarjeta
	UPDATE TARJETAS
		SET SALDO = SALDO - @IMPORTE
			WHERE IDTARJETA = @IDTARJETA
	END TRY
	BEGIN CATCH
	 DECLARE @ErrorMessage NVARCHAR(4000)
        DECLARE @ErrorSeverity INT
        DECLARE @ErrorState INT

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE()

        -- Lanzar el error
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END

GO

--D) Realizar un procedimiento almacenado llamado sp_Agregar_Saldo que registre un movimiento de
--crédito a una tarjeta en particular. El procedimiento debe recibir: El número de tarjeta y el importe a
--recargar. Modificar el saldo de la tarjeta.

CREATE OR ALTER PROCEDURE SP_Agregar_Saldo(
	@IDTarjeta BIGINT,
	@ImporteRecarga MONEY
)
AS BEGIN 
	BEGIN TRY
		DECLARE @SaldoTarjeta MONEY
		--Verificamos si existe la tarjeta y guardamos el saldo
		SELECT @SaldoTarjeta = T.SALDO FROM TARJETAS AS T WHERE T.ESTADO = 1 AND T.IDTARJETA = @IDTarjeta

		--Si no existe tarjeta..
		IF @SaldoTarjeta IS NULL 
			BEGIN
				RAISERROR('Tarjeta inexistente o inactiva',16,0)
			RETURN
		END

		--Registrar el movimiento
		INSERT INTO MOVIMIENTOS(FECHA,IDTARJETA,IMPORTE,TIPO)
			VALUES (GETDATE(),@IDTARJETA,@ImporteRecarga,'C')

		--Actualizar saldo de tarjeta
		UPDATE TARJETAS
			SET SALDO = SALDO + @ImporteRecarga
				WHERE IDTARJETA = @IDTarjeta

		PRINT 'Saldo recargado exitosamente'
	END TRY

	BEGIN CATCH
	 DECLARE @ErrorMessage NVARCHAR(4000)
        DECLARE @ErrorSeverity INT
        DECLARE @ErrorState INT

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE()

        -- Lanzar el error
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
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
	BEGIN TRY
	--Corroboro que exista el usuario
	IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE IDUSUARIO = @IDUsuario)
		BEGIN
			RAISERROR('Usuario no encontrado',16,0)
		RETURN
	END
	--ELiminamos primero el viaje
	DELETE FROM VIAJES WHERE IDTARJETA IN (SELECT IDTARJETA FROM TARJETAS WHERE IDUSUARIO = @IDUsuario)

	--Eliminamos segundo sus movimientos/recargas
	DELETE FROM MOVIMIENTOS WHERE IDTARJETA IN (SELECT IDTARJETA FROM TARJETAS WHERE IDUSUARIO = @IDUsuario)

	--Elimanos tercero la tarjeta
	DELETE FROM TARJETAS WHERE IDUSUARIO = @IDUsuario

	--ELiminamos por último el usuario
	DELETE FROM USUARIOS WHERE IDUSUARIO = @IDUsuario

	PRINT 'El usuario y todos sus datos asociados se eliminaron correctamente'

	END TRY
	BEGIN CATCH
		RAISERROR ('Error',16,1)

	END CATCH
END

EXEC SP_Baja_Fisica_Usuario 25
SELECT * FROM USUARIOS
SELECT * FROM TARJETAS