Use PruebaJoins
GO

--INNER JOIN
SELECT * FROM Departamento
	INNER JOIN Empleado 
	ON Departamento.ID_DP = Empleado.ID_Departamento
go
--LEFT JOIN
SELECT Nombre_DP, Departamento.ID_DP, Apellido_EM, Empleado.ID_Departamento 
FROM Departamento  LEFT JOIN Empleado
ON Departamento.ID_DP = Empleado.ID_Departamento
GO

--RIGHT JOIN
SELECT Nombre_DP, D.ID_DP, Apellido_EM, E.ID_Departamento 
FROM Departamento D RIGHT JOIN Empleado AS E
ON D.ID_DP = E.ID_Departamento
GO

--FULL JOIN
SELECT Nombre_DP, D.ID_DP, Apellido_EM, E.ID_Departamento 
FROM Departamento D FULL JOIN Empleado AS E
ON D.ID_DP = E.ID_Departamento
GO