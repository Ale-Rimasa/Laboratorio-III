--Por cada cliente la cantidad de cuentas que tiene y el promedio de saldo por cuenta
Create View VW_InformacionClientes AS
SELECT Cli.Apellidos, Cli.Nombres, Count(*) AS CantidadCuentas, AVG(Saldo) AS PromedioSaldo
	FROM Clientes Cli
INNER JOIN Cuentas C ON Cli.IDCliente = C.IDCliente
Group BY cli.Apellidos, Cli.Nombres

SELECT * FROM VW_InformacionClientes