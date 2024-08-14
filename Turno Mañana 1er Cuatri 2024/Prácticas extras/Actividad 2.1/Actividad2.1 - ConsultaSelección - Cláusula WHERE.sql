USE univ
GO

--1 Listado de todos los idiomas
SELECT* FROM Idiomas
GO

--2 Listado de todos los cursos.
SELECT Nombre
FROM Cursos
GO

--3 Listado con nombre, costo de inscripción (costo de curso), costo de
--certificación y fecha de estreno de todos los cursos.
SELECT C.Nombre, C.CostoCurso, C.CostoCertificacion, C.FechaEstreno
FROM Cursos C
GO

--4 Listado con ID, nombre, costo de inscripción y ID de nivel de todos los cursos
--cuyo costo de certificación sea menor a $5000.
SELECT C.ID, C.Nombre, C.CostoCurso, C.IDNivel,
FROM Cursos C
WHERE C.CostoCertificacion < 5000
GO

--5 Listado con ID, nombre, costo de inscripción y ID de nivel de todos los cursos 
--cuyo costo de certificación sea mayor a $1200.

SELECT C.ID, C.Nombre, C.CostoCurso, C.IDNivel
FROM Cursos C
WHERE C.CostoCertificacion > 1200
Go

SELECT * FROM Clases

--6 Listado con nombre, número y duración de todas las clases del curso con ID número 6.
SELECT C.Nombre, C.Numero, C.Duracion
FROM Clases C
WHERE C.IDCurso = 6
GO

--7 Listado con nombre, número y duración de todas las clases del curso con ID número 10.
SELECT C.Nombre, C.Numero, C.Duracion
FROM Clases C
WHERE C.IDCurso = 10
GO

--8 Listado con nombre y duración de todas las clases del curso con ID número 4. Ordenado por duración de mayor a menor.
SELECT C.Nombre, C.Duracion
FROM Clases C
WHERE C.IDCurso= 4
ORDER BY C.Duracion DESC
GO

--9 Listado de cursos con nombre, fecha de estreno, costo del curso, costo de
--certificación ordenados por fecha de estreno de manera creciente.
SELECT C.Nombre, C.FechaEstreno, C.CostoCurso, C.CostoCertificacion
FROM Cursos C
ORDER BY C.FechaEstreno ASC
GO

--10 Listado con nombre, fecha de estreno y costo del curso de todos aquellos cuyo ID de nivel sea 1, 5, 9 o 10.
SELECT C.Nombre, C.FechaEstreno, C.CostoCurso
FROM Cursos C
WHERE C.IDNivel = 1 OR C.IDNivel= 5 OR C.IDNivel = 9 OR C.IDNivel= 10;
GO

--11 Listado con nombre, fecha de estreno y costo de cursado de los tres cursos más caros de certificar.
SELECT TOP 3 C.Nombre, C.FechaEstreno, C.CostoCurso, C.CostoCertificacion
FROM Cursos C
ORDER BY C.CostoCertificacion DESC 
GO

--12 Listado con nombre, duración y número de todas las clases de los cursos con 
--ID 2, 5 y 7. Ordenados por ID de Curso ascendente y luego por número de clase ascendente.
SELECT C.Nombre, C.Duracion, C.Numero
FROM CLASES C
WHERE C.IDCurso= 2 OR C.IDCurso=5 OR C.IDCurso=7
ORDER BY C.IDCurso ASC, C.Numero ASC
GO

--13 Listado con nombre y fecha de estreno de todos los cursos cuya fecha de 
--estreno haya sido en el primer semestre del año 2019.
SELECT C.Nombre, C.FechaEstreno
FROM CURSOS C
WHERE YEAR(C.FechaEstreno ) = 2008 AND MONTH(C.FechaEstreno ) <= 6;
GO

--14. Listado de cursos cuya fecha de estreno haya sido en el año 2020.
SELECT C.Nombre [Nombre Curso],C.FechaEstreno [Fecha Estreno 2020]
FROM Cursos C
WHERE YEAR(C.FechaEstreno) = 2020
GO

--15 Listado de cursos cuyo mes de estreno haya sido entre el 1 y el 4.
SELECT C.Nombre, C.FechaEstreno [Fecha MES 1 a 4]
FROM Cursos C
WHERE MONTH(C.FechaEstreno) <=4 
GO

--16 Listado de clases cuya duración se encuentre entre 15 y 90 minutos.
SELECT C.Nombre, C.Duracion [Tiempo]
FROM CLASES C
WHERE C.Duracion BETWEEN 15 AND 90
GO

--17 Listado de contenidos cuyo tamaño supere los 5000MB y sean de tipo 4 o sean menores a 400MB y sean de tipo 1.
SELECT C.Tamaño, C.IDTipoContenido
FROM Contenidos C
WHERE C.Tamaño > 500 AND C.IDTipoContenido = 4 OR C.Tamaño < 400 AND C.IDTipoContenido = 1
GO

--18 Listado de cursos que no posean ID de nivel.
SELECT  C.Nombre [No tiene Nivel] ,C.IDNivel 
FROM Cursos C
WHERE C.IDNivel IS NULL
GO

--19 Listado de cursos cuyo costo de certificación corresponda al 20% o más del costo del curso.
SELECT C.Nombre, C.CostoCurso, C.CostoCertificacion
FROM CURSOS C
WHERE C.CostoCertificacion >= 0.2 * C.CostoCurso
GO

--20 Listado de costos de cursado de todos los cursos sin repetir y ordenados de mayor a menor.
SELECT Distinct C.Nombre, C.CostoCurso
FROM Cursos C
Order By C.CostoCurso DESC
GO
