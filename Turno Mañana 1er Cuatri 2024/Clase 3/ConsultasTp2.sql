USE TP2
GO

Select * FROM Articulo
SELECT * FROM Proveedores
Go
--2.1. Realizar una consulta que informe razón social, ciudad y provincia de las empresas ubicadas en Buenos Aires.
SELECT RazonSocial_PR, Ciudad_PR FROM Proveedores WHERE Provincia_PR = 'Buenos Aires'
GO

--2.2. Realizar una consulta que informe el código de artículo y el nombre,
--ordenados según código de artículo en forma descendente.
SELECT ID_AR, Nombre_AR FROM Articulo ORDER BY ID_AR Desc
GO

--2.3. Realizar una consulta que informe las provincias en las que hay proveedores.
SELECT DISTINCT Provincia_PR AS ProveedoresEnProvincia FROM Proveedores WHERE Provincia_PR IS NOT NULL 
GO

--2.4. Realizar una consulta que informe el nombre de los artículos y
--la cantidad de dinero de estos en stock (cantidad X precio unitario).
SELECT Nombre_AR,[Cantidad_AR]*[PrecioUnitario_AR] AS DineroTotal FROM Articulo

--2.5. Realizar una consulta que informe nombre, cantidad y precio unitario de los artículos de un determinado proveedor.
SELECT Nombre_AR, Cantidad_AR, PrecioUnitario_AR FROM (Articulo INNER JOIN ProveedoresXArticulo ON Articulo.ID_AR = ProveedoresXArticulo.ID_AR)
INNER JOIN  Proveedores ON ProveedoresXArticulo.ID_PR = Proveedores.ID_PR
WHERE Proveedores.RazonSocial_PR = 'Fravega'
GO


--Otras pruebas
SELECT  Nombre_AR, Cantidad_AR, PrecioUnitario_AR, ProveedoresXArticulo.ID_PR 
FROM Articulo INNER JOIN ProveedoresXArticulo 
ON Articulo.ID_AR = ProveedoresXArticulo.ID_PR WHERE ID_PR= 'AR001'
GO

SELECT  Nombre_AR, Cantidad_AR, PrecioUnitario_AR
FROM (Articulo INNER JOIN ProveedoresXArticulo 
ON Articulo.ID_AR = ProveedoresXArticulo.ID_AR) INNER JOIN Proveedores
ON ProveedoresXArticulo.ID_PR = Proveedores.ID_PR
WHERE Proveedores.RazonSocial_PR = 'Plaza vea'
GO





