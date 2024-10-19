--
CREATE OR ALTER FUNCTION FN_ObtenerSaldoCuenta(
	@IDCuenta int
)
returns money
AS Begin
		Declare @TotalCreditos money
		Declare @TotalDebitos money

		Set @TotalCreditos = (
			Select IsNull(Sum(Importe),0) from Movimientos where IDCuenta = @IDCuenta AND TipoMovimiento = 'C'
	)

		Set @TotalCreditos = (
			Select IsNull(Sum(Importe),0) from Movimientos where IDCuenta = @IDCuenta AND TipoMovimiento = 'D'
	)
		Return @TotalCreditos - @TotalDebitos
end

SELECT dbo.FN_ObtenerSaldoCuenta(2)
--Comparar los saldos
SELECT C.IDCuenta, C.Saldo, dbo.FN_ObtenerSaldoCuenta(C.IDCuenta) AS SaldoRecalculado
FROM Cuentas C
--El IsNull sirve para transformar NULL a 0. En estos caso cuando no hay nada para sumar