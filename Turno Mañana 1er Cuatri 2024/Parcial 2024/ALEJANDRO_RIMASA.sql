USE Parcial_1_Facu
GO

--Consultas

--1 Seleccione todas las materias de un departamento determinado, cuyos nombres de materia comiencen con una letra 'I' y sigan con 'N' y luego continue con 0 o más caracteres

SELECT M.Materia AS [Nombre Materia]
FROM Materias M 
INNER JOIN MatxDto MxD
	ON M.Cod_Mat = MxD.Cod_Mat 
INNER JOIN Departamentos D
	ON MxD.Cod_Dto = D.Cod_Dto
WHERE D.Cod_Dto = 2613 AND M.Materia LIKE '[I,N]%'
GO

--2 Informe los nombres y la cantidad de horas asignadas, a cada docente de un determinado departamento

SELECT D.nombre AS [Nombre Docente], C.Horas AS [Horas asignadas] 
FROM Docentes D
INNER JOIN DocxCargosxMat DxC
	ON D.Legajo = DxC.Legajo
INNER JOIN Cargos C
	ON DxC.Cod_Cargo = C.Cod_Cargo
INNER JOIN Departamentos Dep
	ON Dxc.Cod_Dto = Dep.Cod_Dto
WHERE Dep.Nom_Dto = 'TSGIA'
GO

--3 Informe los Puntos consumidos por cada departamento			

SELECT D.Cod_Dto, D.Nom_Dto  ,SUM(C.Puntos) AS [Puntos consumidos]
FROM Departamentos D
INNER JOIN DocxCargosxMat DxC
	ON Dxc.Cod_Dto = D.Cod_Dto
INNER JOIN Cargos C
	ON DxC.Cod_Cargo = C.Cod_Cargo
	GROUP BY D.Cod_Dto, D.Nom_Dto
GO



--4 Informe las materias que dictan y el nombre de los docentes que tienen titulo de "Ingeniería Mecánica"

SELECT D.nombre as [Nombre Docente], M.Materia
FROM DOCENTES D 
INNER JOIN DocxCargosxMat DxC
	ON D.Legajo = DxC.Legajo
INNER JOIN Materias M
	ON DxC.Cod_Mat = M.Cod_Mat
WHERE D.titulo = 'Ingeniería Mecánica'
	ORDER BY D.nombre ASC
GO



