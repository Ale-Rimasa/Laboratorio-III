--1 Todos los clientes indicando Apellido, Nombre y Correo Electr�nico.
SELECT Apellido, Nombre, CorreoElectronico FROM Clientes
GO
--2 Todos los clientes indicando Apellido y Nombre con el formato: [Apellido],
--[Nombre] (ordenados por Apellido en forma descendente). Por ejemplo:
--Martinez, Sof�a.

SELECT CONCAT(Apellido,',',Nombre) AS Cliente FROM Clientes ORDER BY Apellido desc
GO
--3 Los clientes cuya ciudad contenga la palabra �Jujuy� (indicando Nombre, Apellido y Ciudad)
SELECT Nombre,Apellido, Ciudad FROM Clientes WHERE Ciudad LIKE '%Jujuy'
GO
-- 4 Los clientes que no tengan registrado su correo electr�nico (indicando
--IdCliente, Apellido y Nombre). Ordenar por Apellido en forma descendente y
--por Nombre en forma ascendente.

SELECT IdCliente,Apellido,Nombre FROM Clientes WHERE CorreoElectronico IS NULL ORDER BY Apellido DESC, Nombre ASC
GO
--5 El �ltimo cliente del listado en orden alfab�tico (ordenado por Apellido y luego por Nombre). 
--Indicar IdCliente, Apellido y Nombre.

SELECT TOP 1 IdCliente,Apellido,Nombre FROM Clientes ORDER BY Apellido ASC, Nombre ASC
GO

-- 6 Los clientes cuyo a�o de alta haya sido 2019 (Indicar Nombre, Apellido y Fecha de alta).
SELECT Nombre,Apellido,FechaAlta FROM Clientes WHERE YEAR(FechaAlta) = 2019
GO

--7 Todos los clientes indicando Apellido, Nombre y Datos de Contacto. La �ltima
--columna debe contener el mail si el cliente tiene mail, de lo contrario el Celular,
--sino el Tel�fono y en caso de no tener ninguno debe indicar 'Incontactable'

SELECT Apellido, Nombre, CorreoElectronico FROM Clientes WHERE
		 CorreoElectronico IS NOT NULL 

--8 Todos los clientes, indicando el semestre en el cual se produjo su alta. Indicar
--Nombre, Apellido, Fecha de Alta y la frase �Primer Semestre� o �Segundo
--Semestre� seg�n corresponda.

SELECT Nombre, Apellido, FechaAlta FROM Clientes WHERE MONTH(FechaAlta) <= 6  OR MONTH(FechaAlta) >7 AND MONTH(FechaAlta) <= 12  

--9 Los clientes que tengan registrado tel�fono pero no celular. Indicar IdCliente,
--Apellido y Nombre. Ordenar en forma descendente por fecha de alta.

SELECT IdCliente, CONCAT(Apellido,' ', Nombre) AS [Apellido y Nombre], FechaAlta FROM Clientes WHERE Telefono IS NOT NULL AND Celular IS NULL ORDER BY FechaAlta desc

--10 Todas las ciudades donde residen los clientes. NOTA: no se pueden repetir.
SELECT DISTINCT Ciudad FROM Clientes

--11 Todos los pedidos cuyo Estado no sea Rechazado. Indicar IdPedido, IdCliente,
--Fecha y Monto Total. Ordenar los resultados por fecha de pedido (del m�s
--reciente al m�s antig�o).

SELECT IdPedido, IdCliente, FechaPedido, MontoTotal FROM Pedidos WHERE Estado = 'Pagado' OR Estado = 'Pendiente'

--12 Todos los pedidos cuyo Estado sea �Pagado� o �En preparaci�n� y su monto
--est� entre $500 y $1250 (ambos inclusive). Indicar el valor de todas las
--columnas.

Select * FROM Pedidos WHERE MontoTotal BETWEEN 500 AND 1250 AND (Estado = 'Pagado' OR Estado = 'Pendiente')

--13 Listar los meses del a�o en los que se registraron pedidos en los a�os 2018 y
--2019. NOTA: no indicar m�s de una vez el mismo mes.

SELECT DISTINCT MONTH(FechaPedido) AS [Meses con pedidos entre 2018 y 2019] FROM Pedidos WHERE YEAR(FechaPedido) BETWEEN 2018 AND 2019

--14 Indicar los distintos ID de clientes que realizaron pedidos por un monto total
--mayor a $1000 y cuyo estado no sea Rechazado.

SELECT IdCliente FROM Pedidos WHERE Estado != 'Rechazado' AND MontoTotal > 1000

-- 15 Listar todos los datos de los pedidos realizados por los clientes con ID 1, 8,
--16, 24, 32 y 48. Los registros deben estar ordenados por IdCliente y Estado.

SELECT * FROM Pedidos WHERE IdCliente = 1 OR IdCliente = 8 OR IdCliente = 16 OR IdCliente = 24 OR IdCliente= 32 OR IdCliente = 48 ORDER BY IdCliente, Estado
-- OTRA FORMA DE HACERLO
SELECT * FROM Pedidos WHERE IdCliente IN (1,8,16,24,32) ORDER BY IdCliente, Estado

--16 Listar todos los datos de los tres pedidos de m�s bajo monto que se
-- encuentren en estado Pagado.

SELECT TOP 3 *  FROM Pedidos WHERE Estado = 'Pagado' ORDER BY MontoTotal ASC

--17 Listar los pedidos que tengan estado Rechazado y un monto total menor a
--$500 o bien tengan estado En preparaci�n y un monto total que supere los
--$1000. Indicar todas las columnas excepto Id de Cliente y Fecha del pedido.
--Ordenar por Id de pedido.

SELECT * FROM Pedidos

SELECT IdPedido, Estado, MontoTotal FROM Pedidos 
		WHERE Estado = 'Rechazado' AND MontoTotal < 500 
		OR Estado = 'Pendiente' AND MontoTotal > 1000 
		ORDER BY IdPedido ASC

--18 Listar los pedidos realizados en el a�o 2023 indicando todas las columnas y
--adem�s una llamada �DiaSemana� que devuelva a qu� d�a de la semana (1-7)
--corresponde la fecha del pedido. Ordenar los registros por la columna que
--contiene el d�a de la semana.
--DESAF�O: crear otra columna llamada DiaSemanaEnLetras que contenga el
--d�a de la semana pero en letras (suponiendo que la semana comienza en
--1-DOMINGO). Por ejemplo si la fecha del pedido es 20/07/2023, la columna
--DiaSemana debe contener 6 y la columna DiaSemanaEnLetras debe contener
--JUEVES.

SELECT IdPedido, IdCliente, FechaPedido, Estado, MontoTotal,
	DATEPART(WEEKDAY,FechaPedido) AS[Dia Semana], DATENAME(WEEKDAY,FechaPedido) AS [Dia Semana en Letras] 
	FROM Pedidos
	WHERE YEAR(FechaPedido) = 2023 
	ORDER BY [Dia Semana]

--19 Listar los pedidos en estado Pendiente y cuyo mes de realizaci�n coincida con
--el mes actual (sin importar el a�o). NOTA: obtener el mes actual mediante una
--funci�n, no forzar el valor.

SELECT * FROM Pedidos WHERE Estado = 'Pendiente' AND MONTH(FechaPedido) = MONTH (GETDATE())

--20 La empresa que distribuye los pedidos desea otorgar una bonificaci�n sobre
--el monto total en aquellos pedidos que est�n en estado Pendiente o En
--preparaci�n. Si el pedido fue realizado entre los a�os 2017 y 2019 la
--bonificaci�n ser� del 50%. Si el pedido se realiz� en los a�os 2020 o 2021, la
--bonificaci�n ser� del 30%. Para los pedidos efectuados entre los a�os 2022 y
--2023, la bonificaci�n es del 10%. Calcular, dependiendo del estado de cada
--pedido y el a�o en que se realiz�, el valor del monto total una vez efectuada la
--bonificaci�n, inform�ndolo en una columna llamada MontoTotalBonificado.
--Listar adem�s todos las columnas de Pedidos, ordenadas por la fecha del
--pedido. No tener en cuenta los pedidos que no est�n en los estados
--mencionados.

SELECT IdCliente, IdPedido, FechaPedido,Estado, MontoTotal,
	CASE
		 WHEN YEAR(FechaPedido) >= 2017 AND YEAR(FechaPedido) <= 2019 AND Estado = 'Pendiente' OR Estado = 'En preparaci�n' THEN MontoTotal * 0.5
		 WHEN YEAR(FechaPedido) >= 2020 AND YEAR(FechaPedido) <= 2021 AND Estado = 'Pendiente' OR Estado = 'En preparaci�n' THEN MontoTotal * 0.3
		 WHEN YEAR(FechaPedido) >= 2022 AND YEAR(FechaPedido) <= 2023 AND Estado = 'Pendiente' OR Estado = 'En preparaci�n' THEN MontoTotal * 0.1
	END AS [Monto total Bonificado]
	FROM Pedidos 
	WHERE Estado = 'Pendiente' OR Estado = 'En preparacion'
	ORDER BY FechaPedido 


--21 Listar los pedidos que no hayan sido realizados por los clientes con ID 2, 9, 17,
--25, 33 y 47. Indicar Id de cliente, Id de pedido, fecha de pedido, estado y monto
--total. Ordenar por Id de cliente.

SELECT IdCliente, IdPedido, FechaPedido, Estado, MontoTotal 
	FROM Pedidos
		WHERE IdCliente NOT IN (2,9,17,25,33,47)
		ORDER BY IdCliente

--23 Listar todos los datos de los clientes cuyos apellidos comienzan con O, no
--poseen correo electr�nico y su a�o de alta es 2017. Hacer la misma consulta
--para los clientes con apellido que comienza con P y a�o de alta 2019 que no
--poseen tel�fono ni celular. Ordenar los registros por fecha de alta

SELECT * FROM Clientes WHERE Apellido LIKE 'O%' AND CorreoElectronico IS NULL AND YEAR(FechaAlta) = 2017 ORDER BY FechaAlta

SELECT * FROM Clientes WHERE APELLIDO LIKE 'P%' AND CorreoElectronico IS NULL AND Telefono IS NULL AND YEAR(FechaAlta) = 2019 ORDER BY FechaAlta

--24Listar todos los datos del pedido que haya registrado el mayor monto total. En
--caso de empate se deben listar todos los pedidos con igual monto.

SELECT TOP 1 WITH TIES * FROM Pedidos ORDER BY MontoTotal DESC

-- WITH TIES: Selecciona el primer registro con el monto m�s alto,
--si hay otros registros con el mismo valor en la columna MontoTotal, los incluye tambi�n.