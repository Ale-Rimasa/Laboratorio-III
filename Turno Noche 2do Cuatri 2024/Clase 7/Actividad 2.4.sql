--1 Los nombres y extensiones y tamaño en Megabytes de los archivos que pesen más que el promedio de archivos.
SELECT A.Nombre, A.Extension, (A.Tamaño / 1048576) AS [Tamaño en Mb] FROM Archivos AS A
	WHERE A.Tamaño > (
		SELECT AVG(Tamaño) FROM Archivos
		)
		
/***********************************************************************************************************/
--2 Los usuarios indicando apellido y nombre que no sean dueños de ningún archivo con extensión 'zip'.
SELECT CONCAT(U.Apellido, ' ', U.Nombre) AS [Apellido Nombre] FROM Usuarios AS U
	WHERE U.IDUsuario NOT IN (
		SELECT A.IDUsuarioDueño FROM Archivos AS A
			WHERE A.Extension = 'zip'
			)
/***********************************************************************************************************/
--3  Los usuarios indicando IDUsuario, apellido, nombre y tipo de usuario que no
--hayan creado ni modificado ningún archivo en el año actual.

SELECT U.IDUsuario, CONCAT(U.Apellido, ' ', U.Nombre) AS [Apellido Nombre], TU.TipoUsuario
FROM Usuarios AS U
	INNER JOIN TiposUsuario AS TU
		ON U.IDTipoUsuario = TU.IDTipoUsuario
		WHERE U.IDUsuario NOT IN(
			SELECT A.IDUsuarioDueño FROM Archivos AS A
				WHERE YEAR (A.FechaCreacion) = 2024
				 OR YEAR(A.FechaUltimaModificacion) = 2024
				)
SELECT * FROM ARCHIVOS WHERE YEAR(FechaCreacion) = 2024
SELECT * FROM ARCHIVOS WHERE YEAR(FechaUltimaModificacion) = 2024
/***********************************************************************************************************/
--4 Los tipos de usuario que no registren usuario con archivos eliminados.
SELECT TU.TipoUsuario FROM TiposUsuario AS TU
	WHERE Tu.IDTipoUsuario NOT IN (
		SELECT U.IDTipoUsuario FROM Usuarios AS U
			INNER JOIN Archivos AS A
				ON U.IDUsuario = A.IDUsuarioDueño
			WHERE A.Eliminado = 1
)
/***********************************************************************************************************/
--5 Los tipos de archivos que no se hayan compartido con el permiso de 'Lectura'

SELECT TA.TipoArchivo FROM TiposArchivos AS TA
	WHERE TA.IDTipoArchivo NOT IN 
(
	SELECT A.IDTipoArchivo FROM Archivos AS A
		INNER JOIN ArchivosCompartidos AS AC
			ON A.IDArchivo = AC.IDArchivo
		INNER JOIN Permisos AS P
			ON AC.IDPermiso = P.IDPermiso
			WHERE P.Nombre = 'Lectura'
)
/***********************************************************************************************************/
--6 Los nombres y extensiones de los archivos que tengan un tamaño mayor al
--del archivo con extensión 'xls' más grande.

-- Consulta=Obtiene nombre, extension y tamaño donde los Archivos sea MAYOR a tamaño de TODOS...
-- Subconsulta= Obtiene el tamaño de los archivos donde la extensión sea xls

SELECT A.Nombre, A.Extension, A.Tamaño FROM Archivos AS A		
	WHERE A.Tamaño > ALL (
	SELECT Tamaño FROM Archivos WHERE Extension = 'xls'
	)
/***********************************************************************************************************/
--7 Los nombres y extensiones de los archivos que tengan un tamaño mayor al
--del archivo con extensión 'zip' más pequeño.
SELECT A.Nombre, A.Extension FROM Archivos AS A
	WHERE A.Tamaño > 
(
	SELECT MIN(Tamaño) FROM Archivos WHERE Extension = 'zip'
)
/***********************************************************************************************************/
--8 Por cada tipo de archivo indicar el tipo y la cantidad de archivos eliminados y
--la cantidad de archivos no eliminados.

SELECT TA.TipoArchivo,
(
	SELECT COUNT(*) FROM Archivos AS A
		WHERE Eliminado = 1 AND A.IDTipoArchivo = TA.IDTipoArchivo
) AS [Archivos Eliminados],
(
	SELECT COUNT(*) FROM Archivos AS A2
		WHERE Eliminado = 0 AND A2.IDTipoArchivo = TA.IDTipoArchivo
) AS [Archivos NO Eliminados]
		FROM TiposArchivos AS TA

/***********************************************************************************************************/
--9 Por cada usuario indicar el IDUsuario, el apellido, el nombre, la cantidad de
--archivos pequeños (menos de 20MB) y la cantidad de archivos grandes
--(20MBs o más)
SELECT U.IDUsuario, CONCAT(U.Apellido,' ',U.Nombre) AS [Apellido Nombre],
(
	SELECT COUNT(*) FROM Archivos AS A
	WHERE A.Tamaño < 20000 AND A.IDUsuarioDueño = U.IDUsuario
) AS [Archivos Pequeños],
(
	SELECT COUNT(*) FROM Archivos AS A2
	WHERE A2.Tamaño >= 20000 AND A2.IDUsuarioDueño = U.IDUsuario
) AS [Archivos Grandes]
FROM Usuarios AS U
/***********************************************************************************************************/
--10 Por cada usuario indicar el IDUsuario, el apellido, el nombre y la cantidad de archivos creados en el año 2022,
--la cantidad en el año 2023 y la cantidad creados en el 2024.

SELECT IDUsuario, CONCAT(Apellido,' ', Nombre),
(
	SELECT COUNT(*) FROM Archivos AS A
	WHERE YEAR(A.FechaCreacion) = 2022 AND A.IDUsuarioDueño = U.IDUsuario
) AS [Archivos 2022],
(
	SELECT COUNT(*) FROM Archivos AS A2
	WHERE YEAR(A2.FechaCreacion) = 2023 AND A2.IDUsuarioDueño = U.IDUsuario
) AS [Archivos 2023],
(
	SELECT COUNT(*) FROM Archivos AS A3
	WHERE YEAR(A3.FechaCreacion) = 2024 AND A3.IDUsuarioDueño = U.IDUsuario
) AS [Archivos 2024]
FROM Usuarios AS U
/***********************************************************************************************************/
--11 Los archivos que fueron compartidos con permiso de 'Comentario' pero no con permiso de 'Lectura'

SELECT A.IDArchivo, A.Nombre FROM Archivos AS A
	INNER JOIN ArchivosCompartidos AS AC
		ON A.IDArchivo = AC.IDArchivo
	INNER JOIN Permisos AS P
		ON AC.IDPermiso = P.IDPermiso
			WHERE P.Nombre = 'Comentario' AND A.IDArchivo NOT IN 
(
SELECT AC1.IDArchivo FROM ArchivosCompartidos AS AC1
	INNER JOIN Permisos AS P1
		ON AC1.IDPermiso = P1.IDPermiso
		WHERE P1.Nombre = 'Lectura'
)
/***********************************************************************************************************/
--12 Los tipos de archivos que registran más archivos eliminados que no eliminados.

SELECT TA.IDTipoArchivo, TA.TipoArchivo FROM TiposArchivos AS TA
		WHERE (
SELECT COUNT(*) FROM Archivos AS A
		WHERE A.IDTipoArchivo= TA.IDTipoArchivo AND A.Eliminado = 1
) >
(
SELECT COUNT(*) FROM Archivos AS A
		WHERE A.IDTipoArchivo= TA.IDTipoArchivo AND A.Eliminado = 0
)
/***********************************************************************************************************/
--13 Los usuario que registren más archivos pequeños que archivos grandes (pero que al menos registren un archivo de cada uno)
SELECT U.IDUsuario, U.Nombre, U.Apellido FROM Usuarios AS U
	WHERE (
	SELECT COUNT(*) FROM Archivos AS A
	WHERE A.IDUsuarioDueño = U.IDUsuario AND A.Tamaño < 1048576
) > 
(
	SELECT COUNT(*) FROM Archivos AS A1
	WHERE A1.IDUsuarioDueño = U.IDUsuario AND A1.Tamaño >= 1048576
)
AND (
	SELECT COUNT(*) FROM Archivos AS A2
	WHERE A2.IDUsuarioDueño = U.IDUsuario AND A2.Tamaño < 1048576
) > 0
AND (
	SELECT COUNT(*) FROM Archivos AS A3
	WHERE A3.IDUsuarioDueño = U.IDUsuario AND A3.Tamaño >= 1048576
) > 0

/***********************************************************************************************************/
--14 Los usuarios que hayan creado más archivos en el 2022 que en el 2023 y en el 2023 que en el 2024.
SELECT U.IDUsuario, U.Nombre, U.Apellido
FROM Usuarios AS U
WHERE (
    SELECT COUNT(*)
    FROM Archivos AS A
    WHERE A.IDUsuarioDueño = U.IDUsuario
      AND YEAR(A.FechaCreacion) = 2022
) > (
    SELECT COUNT(*)
    FROM Archivos AS A
    WHERE A.IDUsuarioDueño = U.IDUsuario
      AND YEAR(A.FechaCreacion) = 2023
)
AND (
    SELECT COUNT(*)
    FROM Archivos AS A1
    WHERE A1.IDUsuarioDueño = U.IDUsuario
      AND YEAR(A1.FechaCreacion) = 2023
) > (
    SELECT COUNT(*)
    FROM Archivos AS A2
    WHERE A2.IDUsuarioDueño = U.IDUsuario
      AND YEAR(A2.FechaCreacion) = 2024
)


SELECT * FROM TiposUsuario
SELECT * FROM Usuarios
SELECT * FROM Archivos
SELECT * FROM TiposArchivos
SELECT * FROM Permisos
SELECT * FROM ArchivosCompartidos