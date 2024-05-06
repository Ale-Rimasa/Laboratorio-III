USE TP4
GO

SELECT * FROM Medicamentos
SELECT * FROM Laboratorio


--4.1. Realizar una consulta que informe nombre del medicamento, nombre del laboratorio y unidades en stock.

SELECT M.NombreMedicamento, M.Stock_ME ,L.Nombre AS [Nombre Laboratorio]
FROM Medicamentos M INNER JOIN Laboratorio L
ON M.CodLabo_LB_ME = L.CodLabo_LB
GO

--4.2. Realizar una consulta que informe nombre, unidades disponibles
--y precio unitario de los artículos de un determinado laboratorio.

SELECT M.NombreMedicamento, M.Stock_ME, M.Precio_ME
FROM Medicamentos M INNER JOIN Laboratorio L
ON M.CodLabo_LB_ME = L.CodLabo_LB
GO

--4.3. Realizar una consulta que informe nombre del medicamento, unidades en stock, 
--nombre y teléfono del laboratorio de todos aquellos productos que pasen su punto de pedido.

SELECT M.NombreMedicamento, M.Stock_ME, L.Nombre, L.Telefono
FROM Laboratorio L INNER JOIN Medicamentos M
ON L.CodLabo_LB = M.CodLabo_LB_ME
WHERE M.PuntoPedido_ME = 'SI'
GO

--4.4. Realizar una consulta que informe la mayor Cantidad de venta por tipo de medicamento .

SELECT M.Tipo_ME AS [Medicamento más vendido]
FROM Medicamentos M INNER JOIN DetalleVentas 
ON M.CodMedicamento_ME = DetalleVentas.CodMedicamento_ME_DV
WHERE DetalleVentas.Cantidad_DV = (SELECT MAX(DetalleVentas.Cantidad_DV) AS [Mayor Venta] FROM DetalleVentas)
GO


SELECT * FROM DetalleVentas