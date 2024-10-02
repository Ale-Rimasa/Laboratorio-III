--1 Listado con la cantidad de cursos.
SELECT COUNT(*) AS[Cantidad Cursos] FROM Cursos
/******************************************************************************************************************/
--2 Listado con la cantidad de usuarios.
SELECT COUNT(*) AS [Cantidad de Usuarios] FROM Usuarios

/******************************************************************************************************************/
--3 Listado con el promedio de costo de certificaci�n de los cursos.
SELECT AVG(CostoCertificacion) AS [Promedio Costo certificaci�n] FROM Cursos

/******************************************************************************************************************/
--4 Listado con el promedio general de calificaci�n de rese�as.
SELECT AVG(Puntaje) AS [Calificaci�n de rese�as] FROM Rese�as

/******************************************************************************************************************/
--5 Listado con la fecha de estreno de curso m�s antigua.
SELECT TOP 1 WITH TIES Estreno AS [Fecha de curso m�s antiguo] FROM Cursos
	ORDER BY Estreno

SELECT MIN(Estreno) AS [Fecha de curso m�s antiguo] FROM Cursos

/******************************************************************************************************************/
--6 Listado con el costo de certificaci�n menos costoso.
SELECT TOP 1 WITH TIES CostoCertificacion AS [Certificaci�n menos costosa] FROM Cursos
	ORDER BY CostoCertificacion

SELECT MIN(CostoCertificacion) AS [Certificaci�n menos costosa] FROM Cursos

/******************************************************************************************************************/
--7 Listado con el costo total de todos los cursos.
SELECT SUM(CostoCurso) AS [Costo total de cursos] FROM CURSOS
/******************************************************************************************************************/
--8 Listado con la suma total de todos los pagos.
	SELECT SUM(Importe) [Suma Total de pagos realizados] FROM Pagos
/******************************************************************************************************************/
--9 Listado con la cantidad de cursos de nivel principiante.
SELECT COUNT(*) AS [Cantidad de cursos Principiantes] FROM Cursos
	WHERE IDNivel = 5

/******************************************************************************************************************/
--10 Listado con la suma total de todos los pagos realizados en 2020.
SELECT SUM(Importe) AS [Suma Total a�o 2020] FROM Pagos
WHERE YEAR(Fecha) = 2020

/******************************************************************************************************************/
--11 Listado con la cantidad de usuarios que son instructores.
SELECT DISTINCT COUNT(*) AS [Cantidad de usuarios Instructores]  FROM Usuarios AS U
	INNER JOIN Instructores_x_Curso AS IXU
		ON U.ID = IXU.IDUsuario

SELECT COUNT(*) AS [Cantidad de usuarios Instructores] FROM Instructores_x_Curso

/******************************************************************************************************************/
--12 Listado con la cantidad de usuarios distintos que se hayan certificado.
SELECT COUNT(DISTINCT U.ID) AS [Cantidad de usuarios certificados] FROM Usuarios AS U
	INNER JOIN Inscripciones AS I
		ON U.ID = I.IDUsuario
	INNER JOIN Certificaciones AS C
		ON I.ID = C.IDInscripcion

/******************************************************************************************************************/
--13 Listado con el nombre del pa�s y la cantidad de usuarios de cada pa�s.

SELECT P.Nombre, COUNT(*) AS [Cantidad de usuarios] FROM Paises AS P
	INNER JOIN Localidades AS L
		ON P.ID = L.IDPais
	INNER JOIN Datos_Personales AS DP
		ON L.ID = DP.IDLocalidad
		GROUP BY P.Nombre

/******************************************************************************************************************/
--14 Listado con el apellido y nombres del usuario y el importe m�s costoso abonado
--como pago. S�lo listar aquellos que hayan abonado m�s de $7500.

SELECT CONCAT(DP.Apellidos,' ',DP.Nombres) AS [Apellido Nombres], MAX(P.Importe) AS [Importe M�ximo] FROM Datos_Personales AS DP
	INNER JOIN Usuarios AS U
		ON DP.ID = U.ID
	INNER JOIN Inscripciones AS I
		ON U.ID = I.IDUsuario
	INNER JOIN Pagos AS P
		ON I.ID = P.IDInscripcion
		GROUP BY DP.Apellidos, DP.Nombres
			HAVING MAX(P.Importe) > 7500
				ORDER BY [Importe M�ximo] DESC
/******************************************************************************************************************/
--15 Listado con el apellido y nombres de usuario de cada usuario y el importe m�s
--costoso del curso al cual se haya inscripto. Si hay usuarios sin inscripciones deben
--figurar en el listado de todas maneras.
 SELECT CONCAT(DP.Apellidos,' ',DP.Nombres) AS [Apellido Nombre], MAX(C.CostoCurso) AS [Curso Inscripto Mas Caro] FROM Datos_Personales AS DP
	INNER JOIN Usuarios AS U
		ON DP.ID = U.ID
	LEFT JOIN Inscripciones AS I
		ON U.ID = I.IDUsuario
	LEFT JOIN Cursos AS C
		ON I.IDCurso = C.ID
		GROUP BY DP.Apellidos, DP.Nombres
		ORDER BY [Apellido Nombre]

/******************************************************************************************************************/
--16 Listado con el nombre del curso, nombre del nivel, cantidad total de clases y
--duraci�n total del curso en minutos.
SELECT C.Nombre, N.Nombre, CL. FROM Cursos AS C
	INNER JOIN Niveles AS N
		ON C.IDNivel = N.ID
	INNER JOIN Clases AS CL
		ON C.ID = CL.IDCurso

SELECT * FROM Clases
SELECT * FROM Certificaciones
SELECT * FROM Inscripciones
SELECT * FROM Instructores_x_Curso
SELECT * FROM Niveles
SELECT * FROM Pagos
SELECT * FROM Rese�as
SELECT * FROM Usuarios
SELECT * FROM Datos_Personales
SELECT * FROM Cursos

/******************************************************************************************************************/
17 Listado con el nombre del curso y cantidad de contenidos registrados. S�lo listar
aquellos cursos que tengan m�s de 10 contenidos registrados.
/******************************************************************************************************************/
18 Listado con nombre del curso, nombre del idioma y cantidad de tipos de idiomas.
/******************************************************************************************************************/
19 Listado con el nombre del curso y cantidad de idiomas distintos disponibles.
/******************************************************************************************************************/
20 Listado de categor�as de curso y cantidad de cursos asociadas a cada categor�a.
S�lo mostrar las categor�as con m�s de 5 cursos.
/******************************************************************************************************************/
21 Listado con tipos de contenido y la cantidad de contenidos asociados a cada tipo.
Mostrar tambi�n aquellos tipos que no hayan registrado contenidos con cantidad 0.
/******************************************************************************************************************/
22 Listado con Nombre del curso, nivel, a�o de estreno y el total recaudado en concepto
de inscripciones. Listar tambi�n aquellos cursos sin inscripciones con total igual a
$0.
/******************************************************************************************************************/
23 Listado con Nombre del curso, costo de cursado y certificaci�n y cantidad de
usuarios distintos inscriptos cuyo costo de cursado sea menor a $10000 y cuya
cantidad de usuarios inscriptos sea menor a 5. Listar tambi�n aquellos cursos sin
inscripciones con cantidad 0.
/******************************************************************************************************************/
24 Listado con Nombre del curso, fecha de estreno y nombre del nivel del curso que
m�s recaud� en concepto de certificaciones.
/******************************************************************************************************************/
25 Listado con Nombre del idioma del idioma m�s utilizado como subt�tulo.
/******************************************************************************************************************/
26 Listado con Nombre del curso y promedio de puntaje de rese�as apropiadas.
/******************************************************************************************************************/
27 Listado con Nombre de usuario y la cantidad de rese�as inapropiadas que registr�.
/******************************************************************************************************************/
28 Listado con Nombre del curso, nombre y apellidos de usuarios y la cantidad de
veces que dicho usuario realiz� dicho curso. No mostrar cursos y usuarios que
contabilicen cero.
/******************************************************************************************************************/
29 Listado con Apellidos y nombres, mail y duraci�n total en concepto de clases de
cursos a los que se haya inscripto. S�lo listar informaci�n de aquellos registros cuya
duraci�n total supere los 400 minutos.
/******************************************************************************************************************/
30 Listado con nombre del curso y recaudaci�n total. La recaudaci�n total consiste en
la sumatoria de costos de inscripci�n y de certificaci�n. Listarlos ordenados de
mayor a menor por recaudaci�n.