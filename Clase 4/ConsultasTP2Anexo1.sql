USE TP2
GO
Select * FROM Articulo
--TP2 BIS 2.a Agregar al ejercicio 02 tres tablas más, dos que permitan registrar las ventas y una para registrar los clientes,
--relacionadas correctamente con las tablas existentes.

--2.b Informe todas las facturas realizadas a un determinado cliente.
SELECT NroVenta_V, ClienteVenta_V FROM Ventas WHERE ventas.ClienteVenta_V = '36624456'
GO
--La otra forma que puede hacerse es con un JOIN
SELECT NroVenta_V, ClienteVenta_V FROM Ventas INNER JOIN Clientes
ON Ventas.ClienteVenta_V = Clientes.DniCliente_CL
WHERE Ventas.ClienteVenta_V = '36624456'
GO

--2.c Informe todos los productos de un determinado proveedor.
SELECT Articulo.ID_AR, Articulo.Nombre_AR, PrecioUnitario_AR, RazonSocial_PR FROM (Articulo INNER JOIN ProveedoresXArticulo
ON Articulo.ID_AR = ProveedoresXArticulo.ID_AR) INNER JOIN Proveedores
ON ProveedoresXArticulo.ID_PR = Proveedores.ID_PR
WHERE Proveedores.ID_PR = '005'
GO

--2.d Informe todos los clientes que compraron un artículo determinado.
SELECT Clientes.NombreCliente_CL, Articulo.Nombre_AR, Articulo.ID_AR
FROM (((CLIENTES INNER JOIN Ventas 
ON Clientes.DniCliente_CL = Ventas.ClienteVenta_V) INNER JOIN DetalleVentas
ON ventas.NroVenta_V = DetalleVentas.NroVenta_DV) INNER JOIN Articulo
ON DetalleVentas.ID_AR_DV = Articulo.ID_AR)
WHERE Articulo.ID_AR = 'AR003'
GO