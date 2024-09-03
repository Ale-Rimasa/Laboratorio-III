--1 Por cada usuario listar el nombre, apellido y el nombre del tipo de usuario.

SELECT U.Nombre, U.Apellido, TU.TipoUsuario FROM Usuarios AS U 
	INNER JOIN TiposUsuario AS TU 
		ON U.IDTipoUsuario = TU.IDTipoUsuario
GO
/***********************************************************************************************************/

--2 Listar el ID, nombre, apellido y tipo de usuario de aquellos usuario que sean
--del tipo 'Suscripci�n Free' o 'Suscripci�n B�sica'

SELECT U.IDUsuario, U.Nombre, U.Apellido, TU.TipoUsuario FROM Usuarios AS U
	INNER JOIN TiposUsuario AS TU 
		ON U.IDTipoUsuario = TU.IDTipoUsuario
			WHERE TU.TipoUsuario = 'Suscripci�n FREE' OR  TU.TipoUsuario= 'Suscripci�n B�sica'
GO
/***********************************************************************************************************/

--3 Listar los nombres de archivos, extensi�n, tama�o expresado en Megabytes y
-- el nombre del tipo de archivo.
-- NOTA: En la tabla Archivos el tama�o est� expresado en Bytes.

SELECT A.Nombre, A.Extension, (A.Tama�o / 1048576 ) AS [Tama�o en Megabytes], TA.TipoArchivo FROM Archivos AS A
	INNER JOIN TiposArchivos AS TA
	ON A.IDTipoArchivo = TA.IDTipoArchivo
GO
/***********************************************************************************************************/

--4 Listar los nombres de archivos junto a la extensi�n con el siguiente formato
--'NombreArchivo.extension'. Por ejemplo, 'Actividad.pdf'.
--S�lo listar aquellos cuyo tipo de archivo contenga los t�rminos 'ZIP', 'Word',
--'Excel', 'Javascript' o 'GIF'

SELECT CONCAT(A.Nombre , '.', A.Extension) AS [Nombre y Tipo Archivo] FROM Archivos AS A 
	INNER JOIN TiposArchivos AS TA
		ON A.IDTipoArchivo = TA.IDTipoArchivo
			WHERE TA.TipoArchivo LIKE '%ZIP'
			OR TA.TipoArchivo LIKE '%Word'
			OR TA.TipoArchivo LIKE '%Excel'
			OR TA.TipoArchivo LIKE '%Javascript'
			OR TA.TipoArchivo LIKE '%Gif'
GO
/***********************************************************************************************************/
		
-- 5 Listar los nombres de archivos, su extensi�n, el tama�o en megabytes y
--la fecha de creaci�n de aquellos archivos que le pertenezca al usuario due�o con nombre 'Michael' y apellido 'Williams'.

SELECT A.Nombre, A.Extension, (A.Tama�o / 1048576) AS [Tama�o en Mega], A.FechaCreacion FROM Archivos A
	INNER JOIN Usuarios AS U 
	ON A.IDUsuarioDue�o = U.IDUsuario
	WHERE U.Nombre = 'Michael' AND U.Apellido = 'Williams'
GO
/***********************************************************************************************************/

--6 Listar los datos completos del archivo m�s pesado del usuario due�o con nombre 'Michael' y apellido 'Williams'.
--Si hay varios archivos que cumplen esa condici�n, listarlos a todos.

SELECT TOP 1 WITH TIES * FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDue�o = U.IDUsuario
		WHERE U.Nombre ='Michael' AND U.Apellido = 'Williams' ORDER BY A.Tama�o DESC
GO
/***********************************************************************************************************/

-- 7 Listar nombres de archivos, extensi�n, tama�o en bytes, fecha de creaci�n y de modificaci�n,
--apellido y nombre del usuario due�o de aquellos archivos cuya descripci�n contengan el t�rmino 'empresa' o 'presupuesto'

SELECT A.Nombre, A.Extension, A.Tama�o, A.FechaCreacion, A.FechaUltimaModificacion,A.Descripcion, CONCAT(U.Apellido,' ',U.Nombre) AS [Apellido y Nombre] FROM Archivos A
	INNER JOIN Usuarios AS U
	ON A.IDUsuarioDue�o = U.IDUsuario
	WHERE A.Descripcion LIKE '%empresa' OR A.Descripcion LIKE 'Presupuesto%'
GO
/***********************************************************************************************************/

--8  Listar las extensiones sin repetir de aquellos usuarios due�os que tengan tipo de usuario 'Suscripci�n Plus',
--'Suscripci�n Premium' o 'Suscripci�n Empresarial'

SELECT DISTINCT A.Extension FROM Archivos A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDue�o = U.IDUsuario
		INNER JOIN TiposUsuario AS TU
		ON U.IDTipoUsuario = TU.IDTipoUsuario
		WHERE TU.TipoUsuario = 'Suscripci�n Plus' OR TU.TipoUsuario = 'Suscripci�n Premium' OR TU.TipoUsuario = 'Suscripci�n Empresarial'
GO
/***********************************************************************************************************/


--9 Listar los apellidos y nombres de los usuarios due�os y el tama�o del archivo
--de los tres archivos con extensi�n 'zip' m�s pesados. Puede ocurrir que el
--mismo usuario aparezca varias veces en el listado.

SELECT TOP 3 CONCAT(U.Apellido,' ',U.Nombre), A.Tama�o FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDue�o = U.IDUsuario
		WHERE A.Extension = 'zip'
GO
/***********************************************************************************************************/

--10 Por cada archivo listar el nombre del archivo, la extensi�n, el tama�o en bytes,
--el nombre del tipo de archivo y el tama�o calculado en su mayor expresi�n y la
--unidad calculada. Siendo Gigabytes si al menos pesa un gigabyte, Megabytes
--si al menos pesa un megabyte, Kilobyte si al menos pesa un kilobyte o en su
--defecto expresado en bytes.
--Por ejemplo, si el archivo imagen.jpg pesa 40960 bytes entonces debe figurar
--40 en la columna Tama�o Calculado y 'Kilobytes' en la columna unidad.

SELECT A.Nombre, A.Extension, A.Tama�o, TA.TipoArchivo,
	CASE									
		WHEN A.Tama�o >= 1073741824 THEN A.Tama�o / 1073741824.0
        WHEN A.Tama�o >= 1048576 THEN A.Tama�o / 1048576.0
        WHEN A.Tama�o >= 1024 THEN A.Tama�o / 1024.0
        ELSE A.Tama�o
	END AS [Tama�o Calculado],
    CASE 
        WHEN A.Tama�o >= 1073741824 THEN 'Gigabytes'
        WHEN A.Tama�o >= 1048576 THEN 'Megabytes'
        WHEN A.Tama�o >= 1024 THEN 'Kilobytes'
        ELSE 'Bytes'
    END AS [Unidad Calculada]	
	FROM Archivos AS A
	INNER JOIN TiposArchivos AS TA
		ON A.IDTipoArchivo = TA.IDTipoArchivo
GO
/***********************************************************************************************************/


--11 Listar los nombres de archivo y extensi�n de los archivos que han sido compartidos.

SELECT A.Nombre, A.Extension FROM ArchivosCompartidos AS AC
	INNER JOIN Archivos AS A
		ON AC.IDArchivo = A.IDArchivo
GO
/***********************************************************************************************************/

-- 12 Listar los nombres de archivo y extensi�n de los archivos que han sido compartidos a usuarios con apellido 'Clarck' o 'Jones'
SELECT A.Nombre AS [Nombre Archivo], A.Extension FROM ArchivosCompartidos AS AC
	INNER JOIN Archivos AS A
		ON AC.IDArchivo = A.IDArchivo
	INNER JOIN Usuarios AS U
		ON AC.IDUsuario = U.IDUsuario
			WHERE U.Apellido = 'Clarck' OR U.Apellido = 'Jones'
GO
/***********************************************************************************************************/


--13 Listar los nombres de archivo, extensi�n, apellidos y nombres de los usuarios a quienes se le hayan compartido archivos con permiso de 'Escritura'

SELECT A.Nombre, A.Extension, CONCAT(U.Apellido,' ', U.Nombre) AS[Apellido y Nombre]  FROM Archivos AS A
	INNER JOIN Usuarios AS U 
		ON A.IDUsuarioDue�o = U.IDUsuario
	INNER JOIN ArchivosCompartidos AS AC
		ON U.IDUsuario = AC.IDUsuario
	INNER JOIN Permisos AS P
		ON AC.IDPermiso = P.IDPermiso
WHERE P.Nombre = 'Escritura'
GO
/***********************************************************************************************************/

--14 Listar los nombres de archivos y extensi�n de los archivos que no han sido compartidos.

SELECT A.IDArchivo, A.Nombre, A.Extension FROM Archivos AS A
	LEFT JOIN ArchivosCompartidos AS AC
		ON A.IDArchivo = AC.IDArchivo
WHERE AC.IDArchivo IS NULL
GO
/***********************************************************************************************************/


--15 Listar los apellidos y nombres de los usuarios due�os que tienen archivos eliminados.

SELECT CONCAT(U.Apellido,' ',U.Nombre) AS [Apellido y Nombre] FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDue�o = U.IDUsuario
	WHERE A.Eliminado = 1
GO
/***********************************************************************************************************/

--16 Listar los nombres de los tipos de suscripciones, sin repetir, que tienen 
--archivos que pesan al menos 120 Megabytes.

								--Tama�o a modo de ejemplo ( no pide la columna en este ejercicio)
SELECT DISTINCT TU.TipoUsuario, (A.Tama�o / 1048576 ) AS [Tama�o en Megabytes] FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDue�o = U.IDUsuario
	INNER JOIN TiposUsuario AS TU
		ON U.IDTipoUsuario = TU.IDTipoUsuario
WHERE A.Tama�o / 1048576 >= 120
GO
/***********************************************************************************************************/


--17 Listar los apellidos y nombres de los usuarios due�os, nombre del archivo,
--extensi�n, fecha de creaci�n, fecha de modificaci�n y la cantidad de d�as
--transcurridos desde la �ltima modificaci�n. S�lo incluir a los archivos que se
--hayan modificado (fecha de modificaci�n distinta a la fecha de creaci�n).


SELECT CONCAT(U.Apellido,' ',U.Nombre) AS[Apellido y Nombre], A.Nombre, A.Extension, A.FechaCreacion, A.FechaUltimaModificacion, DATEDIFF(DAY,FechaUltimaModificacion,GETDATE()) AS [Dias Transcurridos] FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDue�o = U.IDUsuario
	WHERE A.FechaUltimaModificacion != A.FechaCreacion
GO
/***********************************************************************************************************/

--18 Listar nombres de archivos, extensi�n, tama�o, apellidos y nombres del
--usuario due�o del archivo, apellido y nombre del usuario que tiene el archivo
--compartido y el nombre de permiso otorgado.

SELECT A.Nombre AS[Nombre Archivo], A.Extension, A.Tama�o, CONCAT(U.Apellido,' ',U.Nombre) AS [Due�o del Archivo],CONCAT(USU.Apellido,' ',USU.Nombre) AS [Usuario Compartido] , P.Nombre AS [Nombre Permiso] FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDue�o = U.IDUsuario
	INNER JOIN ArchivosCompartidos AS AC
		ON A.IDArchivo = AC.IDArchivo
	INNER JOIN Usuarios AS USU 
		ON AC.IDUsuario = USU.IDUsuario
	INNER JOIN Permisos AS P
		ON AC.IDPermiso = P.IDPermiso
GO
/***********************************************************************************************************/

--19 Listar nombres de archivos, extensi�n, tama�o, apellidos y nombres del
--usuario due�o del archivo, apellido y nombre del usuario que tiene el archivo
--compartido y el nombre de permiso otorgado. S�lo listar aquellos registros
--cuyos tipos de usuarios coincidan tanto para el due�o como para el usuario al
--que le comparten el archivo.

SELECT A.Nombre AS[Nombre Archivo], A.Extension, A.Tama�o, CONCAT(U.Apellido,' ',U.Nombre) AS [Due�o del Archivo],CONCAT(USU.Apellido,' ',USU.Nombre) AS [Usuario Compartido] , P.Nombre AS [Nombre Permiso] FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDue�o = U.IDUsuario
	INNER JOIN ArchivosCompartidos AS AC
		ON A.IDArchivo = AC.IDArchivo
	INNER JOIN Usuarios AS USU 
		ON AC.IDUsuario = USU.IDUsuario
	INNER JOIN Permisos AS P
		ON AC.IDPermiso = P.IDPermiso
	INNER JOIN TiposUsuario AS TU
		ON U.IDTipoUsuario = TU.IDTipoUsuario
	INNER JOIN TiposUsuario AS TUSUARIO
		ON USU.IDTipoUsuario = TUSUARIO.IDTipoUsuario
WHERE Tu.TipoUsuario = TUSUARIO.TipoUsuario
GO
/***********************************************************************************************************/


-- 20 Apellidos y nombres de los usuario que tengan compartido o sea due�o del
--archivo con nombre 'Documento Legal'.

SELECT CONCAT(U.Apellido,' ',U.Nombre) AS [Apellido y Nombre] FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDue�o = U.IDUsuario
	INNER JOIN ArchivosCompartidos AS AC
		ON U.IDUsuario = AC.IDUsuario
	WHERE A.Nombre = 'Documento Legal'

SELECT * FROM ArchivosCompartidos
SELECT * FROM Archivos
SELECT * FROM Permisos
SELECT * FROM Usuarios
SELECT * FROM TiposArchivos
SELECT * FROM TiposUsuario
GO
/***********************************************************************************************************/
