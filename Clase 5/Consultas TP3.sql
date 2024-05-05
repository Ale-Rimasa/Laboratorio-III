SELECT * FROM Clientes
SELECT * FROM ClientesXCuentas
SELECT * FROM Cuentas
SELECT * FROM Transacciones

--1. Realizar una consulta que informe Sucursales
Select * FROM Sucursales
GO
Select NombreSucursal_SU FROM Sucursales
GO

--2 Realizar una consulta que informe los datos de un cliente específico con su respectiva sucursal
SELECT Nombre_CL,Apellido_CL, Direccion_CL, ClientesXCuentas.CodSucursal_SU_CLXCU
FROM Clientes INNER JOIN ClientesXCuentas 
ON Clientes.Dni_CL = ClientesXCuentas.Dni_CL_CLXCU
WHERE Clientes.Dni_CL= '35123456'
GO
--SI le quiero agregar con la direccion de la SUCURSAL seria..
SELECT Nombre_CL,Apellido_CL, Direccion_CL, ClientesXCuentas.CodSucursal_SU_CLXCU, Sucursales.Direccion_SU
FROM ((Clientes INNER JOIN ClientesXCuentas 
ON Clientes.Dni_CL = ClientesXCuentas.Dni_CL_CLXCU)
INNER JOIN Sucursales
ON ClientesXCuentas.CodSucursal_SU_CLXCU = Sucursales.CodSucursal_SU)
WHERE Clientes.Dni_CL= '35123456'
GO



--3 Realizar una consulta que informe los datos de un cliente específico con sus respectivas cuentas
SELECT Nombre_CL,Apellido_CL,Direccion_CL, ClientesXCuentas.CodCuenta_CU_CLXCU  
FROM Clientes INNER JOIN ClientesXCuentas 
ON Clientes.Dni_CL=ClientesXCuentas.Dni_CL_CLXCU
Where Clientes.Dni_CL= '32145678'
GO

--Praticas extras con las funciones de agregado
SELECT SUM(SaldoCuenta_TR) AS SumaTotal FROM Transacciones
GO

SELECT MAX(SaldoCuenta_TR) AS [Monto Maximo] FROM Transacciones 
GO

SELECT AVG(SaldoCuenta_TR) AS [Promedio Monto] FROM Transacciones
GO

SELECT COUNT(SaldoCuenta_TR) AS [Contador Monto] FROM Transacciones
GO

SELECT * FROM Transacciones

--4 Realizar una consulta que informe la mayor transacción y los datos del cliente (Informo todos los clientes)
SELECT MAX(SaldoCuenta_TR) AS [Máxima transacción], T.Dni_CL_CLXCU_TR, Clientes.Nombre_CL
FROM Transacciones T INNER JOIN Clientes	ON T.Dni_CL_CLXCU_TR = Clientes.Dni_CL
GROUP BY T.Dni_CL_CLXCU_TR, Clientes.Nombre_CL
GO

--Otra consulta parecida
--4.b Realizar una consulta que informe la mayor transacción y los datos del cliente que sea de tipo plazo Fijo (Informo todos los clientes)
SELECT MAX(SaldoCuenta_TR) AS [Maximo Saldo], T.Dni_CL_CLXCU_TR, Clientes.Nombre_CL
FROM Transacciones T INNER JOIN CLIENTES
ON T.Dni_CL_CLXCU_TR = Clientes.Dni_CL
WHERE T.TipoTransaccion_TR = 'Plazo Fijo'
GROUP BY T.Dni_CL_CLXCU_TR, Clientes.Nombre_CL
GO

--Mism consulta, haciendola en SUBCONSULTA ACA el monto maximo va a variar y me trae un cliente solo
SELECT Transacciones.SaldoCuenta_TR, clientes.Nombre_CL
FROM Transacciones INNER JOIN Clientes
ON Transacciones.Dni_CL_CLXCU_TR = Clientes.Dni_CL
WHERE SaldoCuenta_TR = (SELECT MAX(SaldoCuenta_TR) FROM Transacciones)
GO

--Realizar una consulta que informe los datos de un cliente específico con sus
--respectivas cuentas, sucursales y saldos.

SELECT ClientesXCuentas.CodCuenta_CU_CLXCU, ClientesXCuentas.CodSucursal_SU_CLXCU, C.Nombre_CL, C.Apellido_CL, C.Direccion_CL, C.Dni_CL, Cuentas.Saldo_CU
FROM ClientesXCuentas INNER JOIN Clientes C
ON ClientesXCuentas.Dni_CL_CLXCU = C.Dni_CL
INNER JOIN Cuentas
ON ClientesXCuentas.CodCuenta_CU_CLXCU = Cuentas.CodCuenta_CU
WHERE C.Apellido_CL = 'Crip'
GO