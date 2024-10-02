--1 Listado con apellidos y nombres de los usuarios que no se hayan inscripto a cursos
--durante el año 2019.
SELECT CONCAT(DP.Apellidos,' ',DP.Nombres) AS [Apellido Nombre] FROM Usuarios AS U
	INNER JOIN Datos_Personales AS DP
		ON U.ID = DP.ID
 WHERE U.ID NOT IN (
 SELECT I.IDUsuario FROM Inscripciones AS I
	WHERE YEAR(I.Fecha) = 2019
)



/***********************************************************************************************************/
--2 Listado con apellidos y nombres de los usuarios que se hayan inscripto a cursos pero
--no hayan realizado ningún pago.
SELECT CONCAT(DP.Apellidos,' ',DP.Nombres) AS [Usuarios que deben], U.ID FROM Usuarios AS U
	INNER JOIN Datos_Personales AS DP
		ON U.ID = DP.ID
			WHERE U.ID IN
(
SELECT I.IDUsuario FROM Inscripciones AS I
			WHERE I.Costo = 0
)

/***********************************************************************************************************/
--3 Listado de países que no tengan usuarios relacionados.
SELECT P.Nombre FROM Paises AS P
	WHERE P.ID NOT IN (
SELECT L.IDPais FROM Usuarios AS U
	INNER JOIN Datos_Personales AS DP
		ON U.ID = DP.ID
	INNER JOIN Localidades AS L
		ON DP.IDLocalidad = L.ID
)

/***********************************************************************************************************/
--4 Listado de clases cuya duración sea mayor a la duración promedio.
SELECT C.Nombre FROM Clases AS C
	WHERE C.Duracion > (
SELECT AVG(C2.Duracion) FROM Clases AS C2
					   )

SELECT * FROM Clases
/***********************************************************************************************************/

--5 Listado de contenidos cuyo tamaño sea mayor al tamaño de todos los contenidos de
--tipo 'Audio de alta calidad'.

SELECT C.ID FROM Contenidos AS C
	WHERE C.Tamaño > ALL (
SELECT C2.Tamaño FROM Contenidos AS C2
	INNER JOIN TiposContenido AS TC
		ON C2.IDTipo = TC.ID
			WHERE TC.Nombre = 'Audio de alta calidad'
)

SELECT * FROM Contenidos
SELECT * FROM TiposContenido
/***********************************************************************************************************/
-- 6 Listado de contenidos cuyo tamaño sea menor al tamaño de algún contenido de tipo 'Audio de alta calidad'.

SELECT C.ID FROM Contenidos AS C
	WHERE C.Tamaño < ANY (
SELECT C2.Tamaño FROM Contenidos AS C2
	INNER JOIN TiposContenido AS TC
		ON C2.IDTipo = TC.ID 
			WHERE TC.Nombre = 'Audio de alta calidad'
	)
/***********************************************************************************************************/
-- 7 Listado con nombre de país y la cantidad de usuarios de género masculino y la
--cantidad de usuarios de género femenino que haya registrado.

SELECT P.Nombre,
( SELECT COUNT(*) FROM Usuarios AS U
	INNER JOIN Datos_Personales AS DP
		ON U.ID = DP.ID
	INNER JOIN Localidades AS L
		ON DP.IDLocalidad = L.ID
			WHERE DP.Genero = 'M' AND L.IDPais = P.ID 
) AS [Cantidad Usuarios Masculinos],
( SELECT COUNT(*) FROM Usuarios AS U
	INNER JOIN Datos_Personales AS DP
		ON U.ID = DP.ID
	INNER JOIN Localidades AS L
		ON DP.IDLocalidad = L.ID
			WHERE DP.Genero = 'F'AND L.IDPais = P.ID 
) AS [Cantidad Usuarios Femeninos]
		FROM Paises AS P
/***********************************************************************************************************/
-- 8 Listado con apellidos y nombres de los usuarios y la cantidad de inscripciones
--realizadas en el 2019 y la cantidad de inscripciones realizadas en el 2020.

SELECT CONCAT(DP.Apellidos , ' ', DP.Nombres) AS [Apellido Nombre] ,
(
SELECT COUNT(*) FROM Inscripciones AS I
	WHERE YEAR(I.Fecha) = 2019 AND I.IDUsuario = DP.ID
) AS [Cantidad Inscripciones 2019],
(
SELECT COUNT(*) FROM Inscripciones AS I
	WHERE YEAR(I.Fecha) = 2020 AND I.IDUsuario = DP.ID
) AS [Cantidad Inscripciones 2020]
FROM Datos_Personales AS DP

/***********************************************************************************************************/
-- 9 Listado con nombres de los cursos y la cantidad de idiomas de cada tipo. Es decir, la
--cantidad de idiomas de audio, la cantidad de subtítulos y la cantidad de texto de
-- video.

SELECT C.Nombre,
(
SELECT COUNT(*) FROM FormatosIdioma AS FI
	INNER JOIN Idiomas_x_Curso AS IXC
		ON FI.ID = IXC.IDFormatoIdioma
			WHERE FI.Nombre = 'Audio' AND C.ID = IXC.IDCurso
) AS [Idiomas de audio],
(
SELECT COUNT(*) FROM FormatosIdioma AS FI
	INNER JOIN Idiomas_x_Curso AS IXC
		ON FI.ID = IXC.IDFormatoIdioma
			WHERE FI.Nombre = 'Subtitulo' AND C.ID = IXC.IDCurso
) AS [Subtitulo],
(
SELECT COUNT(*) FROM FormatosIdioma AS FI
	INNER JOIN Idiomas_x_Curso AS IXC
		ON FI.ID = IXC.IDFormatoIdioma
			WHERE FI.Nombre = 'Texto del video' AND C.ID = IXC.IDCurso
) AS [Texto del video]
					FROM CURSOS AS C

SELECT * FROM Idiomas_x_Curso
SELECT * FROM FormatosIdioma
/***********************************************************************************************************/
-- 10 Listado con apellidos y nombres de los usuarios, nombre de usuario y cantidad de
--cursos de nivel 'Principiante' que realizó y cantidad de cursos de nivel 'Avanzado' que
--realizó.

SELECT CONCAT(DP.Apellidos,' ',DP.Nombres) AS [Apellido Nombre], U.NombreUsuario,
(
SELECT COUNT(*) FROM Niveles AS N
	INNER JOIN Cursos AS C
		ON N.ID = C.IDNivel
	INNER JOIN Inscripciones AS I
		ON I.IDCurso = C.ID
			WHERE N.Nombre ='Principiante' AND U.ID = I.IDUsuario
) AS [Curso Principante Realizado],
(
SELECT COUNT(*) FROM Niveles AS N
	INNER JOIN Cursos AS C
		ON N.ID = C.IDNivel
	INNER JOIN Inscripciones AS I
		ON I.IDCurso = C.ID
			WHERE N.Nombre ='Avanzado' AND U.ID = I.IDUsuario
) AS [Curso Avanzado Realizado]
FROM Datos_Personales AS DP
	INNER JOIN Usuarios AS U
		ON DP.ID = U.ID
			ORDER BY [Apellido Nombre]

--MAS EFICIENTE
SELECT CONCAT(DP.Apellidos, ' ', DP.Nombres) AS [Apellido Nombre], 
       U.NombreUsuario,
       SUM(CASE WHEN N.Nombre = 'Principiante' THEN 1 ELSE 0 END) AS [Curso Principiante Realizado],
       SUM(CASE WHEN N.Nombre = 'Avanzado' THEN 1 ELSE 0 END) AS [Curso Avanzado Realizado]
FROM Datos_Personales AS DP
INNER JOIN Usuarios AS U ON DP.ID = U.ID
INNER JOIN Inscripciones AS I ON U.ID = I.IDUsuario
INNER JOIN Cursos AS C ON I.IDCurso = C.ID
INNER JOIN Niveles AS N ON C.IDNivel = N.ID
GROUP BY DP.Apellidos, DP.Nombres, U.NombreUsuario
/***********************************************************************************************************/
-- 11 Listado con nombre de los cursos y la recaudación de inscripciones de usuarios de
-- género femenino que se inscribieron y la recaudación de inscripciones de usuarios de
-- género masculino.
SELECT C.Nombre,
(
SELECT SUM(I.Costo) FROM Inscripciones AS I
	INNER JOIN Usuarios AS U
		ON I.IDUsuario = U.ID
	INNER JOIN Datos_Personales AS DP
		ON U.ID = DP.ID
			WHERE DP.Genero = 'F' AND C.ID = I.IDCurso
) AS [Recaudación Femenina],
(
SELECT SUM(I.Costo) FROM Inscripciones AS I
	INNER JOIN Usuarios AS U
		ON I.IDUsuario = U.ID
	INNER JOIN Datos_Personales AS DP
		ON U.ID = DP.ID
			WHERE DP.Genero = 'M' AND C.ID = I.IDCurso
) AS [Recaudación Masculina]
FROM Cursos AS C
	ORDER BY C.Nombre

--MAS EFICIENTE

SELECT C.Nombre,
       SUM(CASE WHEN DP.Genero = 'F' THEN I.Costo ELSE 0 END) AS [Recaudación Femenina],
       SUM(CASE WHEN DP.Genero = 'M' THEN I.Costo ELSE 0 END) AS [Recaudación Masculina]
FROM Cursos AS C
INNER JOIN Inscripciones AS I ON C.ID = I.IDCurso
INNER JOIN Usuarios AS U ON I.IDUsuario = U.ID
INNER JOIN Datos_Personales AS DP ON U.ID = DP.ID
GROUP BY C.Nombre

/***********************************************************************************************************/
-- 12 Listado con nombre de país de aquellos que hayan registrado más usuarios de
-- género masculino que de género femenino.

SELECT P.Nombre AS [Paises con Mayor cantidad de Masculinos] FROM Paises AS P
	WHERE 
		(SELECT COUNT(*) FROM Localidades AS L
			INNER JOIN Datos_Personales AS DP
				ON L.ID = DP.IDLocalidad
			WHERE DP.Genero = 'M' AND L.IDPais = P.ID
		) >
		(SELECT COUNT(*) FROM Localidades AS L
			INNER JOIN Datos_Personales AS DP
				ON L.ID = DP.IDLocalidad
			WHERE DP.Genero = 'F' AND L.IDPais = P.ID
		)


/***********************************************************************************************************/
-- 13 Listado con nombre de país de aquellos que hayan registrado más usuarios de
-- género masculino que de género femenino pero que haya registrado al menos un
-- usuario de género femenino.

SELECT P.Nombre AS [Paises con Mayor cantidad de Masculinos] FROM Paises AS P
	WHERE 
		(SELECT COUNT(*) FROM Localidades AS L
			INNER JOIN Datos_Personales AS DP
				ON L.ID = DP.IDLocalidad
			WHERE DP.Genero = 'M' AND L.IDPais = P.ID
		) >= ANY
		(SELECT COUNT(*) FROM Localidades AS L
			INNER JOIN Datos_Personales AS DP
				ON L.ID = DP.IDLocalidad
			WHERE DP.Genero = 'F' AND L.IDPais = P.ID
		)
/***********************************************************************************************************/
-- 14 	Listado de cursos que hayan registrado la misma cantidad de idiomas de audio que
-- de subtítulos.
SELECT C.Nombre FROM Cursos AS C
		WHERE (
(SELECT COUNT(*) FROM Idiomas_x_Curso AS IXC
	INNER JOIN FormatosIdioma AS FI
		ON IXC.IDFormatoIdioma = FI.ID
	WHERE FI.Nombre = 'Audio' AND IXC.IDCurso = C.ID) =
(SELECT COUNT(*) FROM Idiomas_x_Curso AS IXC
	INNER JOIN FormatosIdioma AS FI
		ON IXC.IDFormatoIdioma = FI.ID
	WHERE FI.Nombre = 'Subtitulo' AND IXC.IDCurso = C.ID)
)
/***********************************************************************************************************/
--15 Listado de usuarios que hayan realizado más cursos en el año 2018 que en el 2019 y
-- a su vez más cursos en el año 2019 que en el 2020.



SELECT * FROM Cursos
SELECT * FROM Paises
SELECT * FROM Localidades
SELECT * FROM Datos_Personales