--CREAR UN SP que reciba un parametro y que seleccione codigo cliente, tipo de cuenta, numero de cuenta y saldo.

CREATE OR ALTER PROCEDURE SP_CuentasxCliente(
	@IDCliente int
)
AS BEGIN
	SELECT CLI.Apellidos, CLI.Nombres, C.IDCuenta, C.FechaApertura, TC.Nombre, C.Saldo 
		FROM Clientes AS CLI 
			INNER JOIN Cuentas AS C
				ON CLI.IDCliente = C.IDCliente
			INNER JOIN TiposCuenta AS TC
				ON TC.IDTipoCuenta = C.IDTipoCuenta
		WHERE CLI.IDCliente = @IDCliente
END

EXEC SP_CuentasxCliente 1