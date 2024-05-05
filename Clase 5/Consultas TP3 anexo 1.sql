--TP 3 Anexo 1

--6.Informe Nombre y apellido de todos los clientes cuyo nombre comience con la primer letra distinta de ‘A’ y
-- segunda letra sea una ‘e’ seguida por cualquier cadena.

SELECT Clientes.Nombre_CL AS Nombre, Clientes.Apellido_CL AS Apellido,
CONCAT(Clientes.Nombre_CL, ' ', Clientes.Apellido_CL) AS [Nombre Apellido]
FROM Clientes
WHERE Clientes.Nombre_CL LIKE '[^A]e%'
GO

--7. Informe Nombre y apellido de todos los clientes cuyo apellido no comience con ‘S’ o ‘L’

SELECT Clientes.Nombre_CL, Clientes.Apellido_CL
FROM Clientes
WHERE Clientes.Apellido_CL LIKE '[^S^L]%'
GO

SELECT * FROM Clientes