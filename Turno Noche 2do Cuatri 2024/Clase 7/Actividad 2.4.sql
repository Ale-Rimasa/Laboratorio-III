--1 Los nombres y extensiones y tama�o en Megabytes de los archivos que pesen m�s que el promedio de archivos.
SELECT A.Nombre, A.Extension, (A.Tama�o / 1048576) AS [Tama�o en Mb] FROM Archivos AS A
	WHERE A.Tama�o > (
		SELECT AVG(Tama�o) FROM Archivos
		)
		
/***********************************************************************************************************/
--2 Los usuarios indicando apellido y nombre que no sean due�os de ning�n archivo con extensi�n 'zip'.
SELECT CONCAT(U.Apellido, ' ', U.Nombre) AS [Apellido Nombre] FROM Usuarios AS U
	WHERE U.IDUsuario NOT IN (
		SELECT A.IDUsuarioDue�o FROM Archivos AS A
			WHERE A.Extension = 'zip'
			)
/***********************************************************************************************************/
--3  Los usuarios indicando IDUsuario, apellido, nombre y tipo de usuario que no
--hayan creado ni modificado ning�n archivo en el a�o actual.

SELECT U.IDUsuario, CONCAT(U.Apellido, ' ', U.Nombre) AS [Apellido Nombre], TU.TipoUsuario
FROM Usuarios AS U
	INNER JOIN TiposUsuario AS TU
		ON U.IDTipoUsuario = TU.IDTipoUsuario
		WHERE U.IDUsuario NOT IN(
			SELECT A.IDUsuarioDue�o FROM Archivos AS A
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
				ON U.IDUsuario = A.IDUsuarioDue�o
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
--6 Los nombres y extensiones de los archivos que tengan un tama�o mayor al
--del archivo con extensi�n 'xls' m�s grande.

-- Consulta=Obtiene nombre, extension y tama�o donde los Archivos sea MAYOR a tama�o de TODOS...
-- Subconsulta= Obtiene el tama�o de los archivos donde la extensi�n sea xls

SELECT A.Nombre, A.Extension, A.Tama�o FROM Archivos AS A		
	WHERE A.Tama�o > ALL (
	SELECT Tama�o FROM Archivos WHERE Extension = 'xls'
	)
/***********************************************************************************************************/
--7 Los nombres y extensiones de los archivos que tengan un tama�o mayor al
--del archivo con extensi�n 'zip' m�s peque�o.
SELECT A.Nombre, A.Extension FROM Archivos AS A
	WHERE A.Tama�o > 
(
	SELECT MIN(Tama�o) FROM Archivos WHERE Extension = 'zip'
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
--archivos peque�os (menos de 20MB) y la cantidad de archivos grandes
--(20MBs o m�s)
SELECT U.IDUsuario, CONCAT(U.Apellido,' ',U.Nombre) AS [Apellido Nombre],
(
	SELECT COUNT(*) FROM Archivos AS A
	WHERE A.Tama�o < 20000 AND A.IDUsuarioDue�o = U.IDUsuario
) AS [Archivos Peque�os],
(
	SELECT COUNT(*) FROM Archivos AS A2
	WHERE A2.Tama�o >= 20000 AND A2.IDUsuarioDue�o = U.IDUsuario
) AS [Archivos Grandes]
FROM Usuarios AS U
/***********************************************************************************************************/
--10 Por cada usuario indicar el IDUsuario, el apellido, el nombre y la cantidad de archivos creados en el a�o 2022,
--la cantidad en el a�o 2023 y la cantidad creados en el 2024.

SELECT IDUsuario, CONCAT(Apellido,' ', Nombre),
(
	SELECT COUNT(*) FROM Archivos AS A
	WHERE YEAR(A.FechaCreacion) = 2022 AND A.IDUsuarioDue�o = U.IDUsuario
) AS [Archivos 2022],
(
	SELECT COUNT(*) FROM Archivos AS A2
	WHERE YEAR(A2.FechaCreacion) = 2023 AND A2.IDUsuarioDue�o = U.IDUsuario
) AS [Archivos 2023],
(
	SELECT COUNT(*) FROM Archivos AS A3
	WHERE YEAR(A3.FechaCreacion) = 2024 AND A3.IDUsuarioDue�o = U.IDUsuario
) AS [Archivos 2024]
FROM Usuarios AS U
/***********************************************************************************************************/
--11 Los archivos que fueron compartidos con permiso de 'Comentario' pero no con permiso de 'Lectura'

SELECT 

SELECT * FROM TiposUsuario
SELECT * FROM Usuarios
SELECT * FROM Archivos
SELECT * FROM TiposArchivos
SELECT * FROM Permisos
SELECT * FROM ArchivosCompartidos