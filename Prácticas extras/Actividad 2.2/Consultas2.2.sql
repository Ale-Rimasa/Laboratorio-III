USE Univ2
GO

--1 Listado con nombre de usuario de todos los usuarios y sus respectivos nombres y apellidos.
SELECT Usuarios.NombreUsuario AS [Apellido y Nombre]
FROM Usuarios
Go

--8 Listado con nombre y apellidos, g�nero, fecha de nacimiento, mail, nombre del curso y
--fecha de certificaci�n de todos aquellos usuarios que se hayan certificado.

SELECT U.NombreUsuario AS [Apellido y nombre], DP.Genero, Dp.Nacimiento, Dp.Email, Dp
FROM Usuarios U
INNER JOIN Datos_Personales Dp
	ON U.ID = DP.ID


SELECT * FROM Certificaciones
SELECT * FROM Inscripciones
SELECT * FROM Usuarios

--9 Listado de cursos con nombre, costo de cursado y certificaci�n, costo total (cursado
	--+ certificaci�n) con 10% de todos los cursos de nivel Principiante.
SELECT TOP (10) PERCENT
	C.Nombre, C.CostoCurso, C.CostoCertificacion,
	C.CostoCurso + C.CostoCertificacion AS [Costo Total]
FROM Cursos C
	INNER JOIN Niveles N
	ON C.IDNivel = N.ID
WHERE N.Nombre = 'Principiante'
GO

SELECT * FROM Cursos
SELECT * FROM Certificaciones
SELECT * FROM Usuarios

--10 Listado con nombre y apellido y mail de todos los instructores. Sin repetir.
SELECT Distinct Dp.Nombres, Dp.Apellidos, Dp.Email
FROM Instructores_x_Curso IC
INNER JOIN Usuarios U
	ON IC.IDUsuario = U.ID
INNER JOIN Datos_Personales Dp
	ON U.ID = Dp.ID
GO

--11 Listado con nombre y apellido de todos los usuarios que hayan cursado alg�n curso cuya categor�a sea 'Historia'.

SELECT Dp.Nombres, Dp.Apellidos
FROM Datos_Personales Dp
INNER JOIN Usuarios U
	ON Dp.ID = U.ID
INNER JOIN Inscripciones I
	ON U.ID = I.ID
INNER JOIN Categorias_x_Curso CxC
	ON I.IDCurso = CxC.IDCurso
WHERE CxC.IDCategoria = 9
GO




--12Listado con nombre de idioma, c�digo de curso y c�digo de tipo de idioma. Listar
--todos los idiomas indistintamente si no tiene cursos relacionados.