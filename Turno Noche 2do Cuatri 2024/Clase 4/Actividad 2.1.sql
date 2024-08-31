--1 Todos los clientes indicando Apellido, Nombre y Correo Electrónico.
SELECT Apellido, Nombre, CorreoElectronico FROM Clientes
GO
--2 Todos los clientes indicando Apellido y Nombre con el formato: [Apellido],
--[Nombre] (ordenados por Apellido en forma descendente). Por ejemplo:
--Martinez, Sofía.

SELECT CONCAT(Apellido,',',Nombre) AS Cliente FROM Clientes ORDER BY Apellido desc
GO
--3 Los clientes cuya ciudad contenga la palabra ‘Jujuy’ (indicando Nombre, Apellido y Ciudad)
SELECT Nombre,Apellido, Ciudad FROM Clientes WHERE Ciudad LIKE '%Jujuy'
GO
-- 4 Los clientes que no tengan registrado su correo electrónico (indicando
--IdCliente, Apellido y Nombre). Ordenar por Apellido en forma descendente y
--por Nombre en forma ascendente.

SELECT IdCliente,Apellido,Nombre FROM Clientes WHERE CorreoElectronico IS NULL ORDER BY Apellido DESC, Nombre ASC
GO
--5 El último cliente del listado en orden alfabético (ordenado por Apellido y luego por Nombre). 
--Indicar IdCliente, Apellido y Nombre.

SELECT TOP 1 IdCliente,Apellido,Nombre FROM Clientes ORDER BY Apellido ASC, Nombre ASC
GO

-- 6 Los clientes cuyo año de alta haya sido 2019 (Indicar Nombre, Apellido y Fecha de alta).
SELECT Nombre,Apellido,FechaAlta FROM Clientes WHERE YEAR(FechaAlta) = 2019
GO

--7 Todos los clientes indicando Apellido, Nombre y Datos de Contacto. La última
--columna debe contener el mail si el cliente tiene mail, de lo contrario el Celular,
--sino el Teléfono y en caso de no tener ninguno debe indicar 'Incontactable'

SELECT Apellido, Nombre, CorreoElectronico FROM Clientes WHERE
		 CorreoElectronico IS NOT NULL 

--8 Todos los clientes, indicando el semestre en el cual se produjo su alta. Indicar
--Nombre, Apellido, Fecha de Alta y la frase “Primer Semestre” o “Segundo
--Semestre” según corresponda.

SELECT Nombre, Apellido, FechaAlta FROM Clientes WHERE MONTH(FechaAlta) <= 6  OR MONTH(FechaAlta) >7 AND MONTH(FechaAlta) <= 12  

--9 Los clientes que tengan registrado teléfono pero no celular. Indicar IdCliente,
--Apellido y Nombre. Ordenar en forma descendente por fecha de alta.

SELECT IdCliente, CONCAT(Apellido,' ', Nombre) AS [Apellido y Nombre], FechaAlta FROM Clientes WHERE Telefono IS NOT NULL AND Celular IS NULL ORDER BY FechaAlta desc

--10 Todas las ciudades donde residen los clientes. NOTA: no se pueden repetir.
SELECT DISTINCT Ciudad FROM Clientes

SELECT * FROM Pedidos
--11 Todos los pedidos cuyo Estado no sea Rechazado. Indicar IdPedido, IdCliente,
--Fecha y Monto Total. Ordenar los resultados por fecha de pedido (del más
--reciente al más antigüo).

SELECT IdPedido, IdCliente, FechaPedido, MontoTotal FROM Pedidos WHERE Estado = 'Pagado' OR Estado = 'Pendiente'

--12 Todos los pedidos cuyo Estado sea “Pagado” o “En preparación” y su monto
--esté entre $500 y $1250 (ambos inclusive). Indicar el valor de todas las
--columnas.

Select MontoTotal, Estado FROM Pedidos WHERE Estado = 'Pagado' OR Estado = 'Pendiente' AND MontoTotal BETWEEN 500 AND 1250