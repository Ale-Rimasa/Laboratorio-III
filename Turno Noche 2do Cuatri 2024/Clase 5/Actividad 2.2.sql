--1 Por cada usuario listar el nombre, apellido y el nombre del tipo de usuario.

SELECT U.Nombre, U.Apellido, TU.TipoUsuario FROM Usuarios AS U 
	INNER JOIN TiposUsuario AS TU 
		ON U.IDTipoUsuario = TU.IDTipoUsuario
GO
/***********************************************************************************************************/

--2 Listar el ID, nombre, apellido y tipo de usuario de aquellos usuario que sean
--del tipo 'Suscripción Free' o 'Suscripción Básica'

SELECT U.IDUsuario, U.Nombre, U.Apellido, TU.TipoUsuario FROM Usuarios AS U
	INNER JOIN TiposUsuario AS TU 
		ON U.IDTipoUsuario = TU.IDTipoUsuario
			WHERE TU.TipoUsuario = 'Suscripción FREE' OR  TU.TipoUsuario= 'Suscripción Básica'
GO
/***********************************************************************************************************/

--3 Listar los nombres de archivos, extensión, tamaño expresado en Megabytes y
-- el nombre del tipo de archivo.
-- NOTA: En la tabla Archivos el tamaño está expresado en Bytes.

SELECT A.Nombre, A.Extension, (A.Tamaño / 1048576 ) AS [Tamaño en Megabytes], TA.TipoArchivo FROM Archivos AS A
	INNER JOIN TiposArchivos AS TA
	ON A.IDTipoArchivo = TA.IDTipoArchivo
GO
/***********************************************************************************************************/

--4 Listar los nombres de archivos junto a la extensión con el siguiente formato
--'NombreArchivo.extension'. Por ejemplo, 'Actividad.pdf'.
--Sólo listar aquellos cuyo tipo de archivo contenga los términos 'ZIP', 'Word',
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
		
-- 5 Listar los nombres de archivos, su extensión, el tamaño en megabytes y
--la fecha de creación de aquellos archivos que le pertenezca al usuario dueño con nombre 'Michael' y apellido 'Williams'.

SELECT A.Nombre, A.Extension, (A.Tamaño / 1048576) AS [Tamaño en Mega], A.FechaCreacion FROM Archivos A
	INNER JOIN Usuarios AS U 
	ON A.IDUsuarioDueño = U.IDUsuario
	WHERE U.Nombre = 'Michael' AND U.Apellido = 'Williams'
GO
/***********************************************************************************************************/

--6 Listar los datos completos del archivo más pesado del usuario dueño con nombre 'Michael' y apellido 'Williams'.
--Si hay varios archivos que cumplen esa condición, listarlos a todos.

SELECT TOP 1 WITH TIES * FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDueño = U.IDUsuario
		WHERE U.Nombre ='Michael' AND U.Apellido = 'Williams' ORDER BY A.Tamaño DESC
GO
/***********************************************************************************************************/

-- 7 Listar nombres de archivos, extensión, tamaño en bytes, fecha de creación y de modificación,
--apellido y nombre del usuario dueño de aquellos archivos cuya descripción contengan el término 'empresa' o 'presupuesto'

SELECT A.Nombre, A.Extension, A.Tamaño, A.FechaCreacion, A.FechaUltimaModificacion,A.Descripcion, CONCAT(U.Apellido,' ',U.Nombre) AS [Apellido y Nombre] FROM Archivos A
	INNER JOIN Usuarios AS U
	ON A.IDUsuarioDueño = U.IDUsuario
	WHERE A.Descripcion LIKE '%empresa' OR A.Descripcion LIKE 'Presupuesto%'
GO
/***********************************************************************************************************/

--8  Listar las extensiones sin repetir de aquellos usuarios dueños que tengan tipo de usuario 'Suscripción Plus',
--'Suscripción Premium' o 'Suscripción Empresarial'

SELECT DISTINCT A.Extension FROM Archivos A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDueño = U.IDUsuario
		INNER JOIN TiposUsuario AS TU
		ON U.IDTipoUsuario = TU.IDTipoUsuario
		WHERE TU.TipoUsuario = 'Suscripción Plus' OR TU.TipoUsuario = 'Suscripción Premium' OR TU.TipoUsuario = 'Suscripción Empresarial'
GO
/***********************************************************************************************************/


--9 Listar los apellidos y nombres de los usuarios dueños y el tamaño del archivo
--de los tres archivos con extensión 'zip' más pesados. Puede ocurrir que el
--mismo usuario aparezca varias veces en el listado.

SELECT TOP 3 CONCAT(U.Apellido,' ',U.Nombre), A.Tamaño FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDueño = U.IDUsuario
		WHERE A.Extension = 'zip'
GO
/***********************************************************************************************************/

--10 Por cada archivo listar el nombre del archivo, la extensión, el tamaño en bytes,
--el nombre del tipo de archivo y el tamaño calculado en su mayor expresión y la
--unidad calculada. Siendo Gigabytes si al menos pesa un gigabyte, Megabytes
--si al menos pesa un megabyte, Kilobyte si al menos pesa un kilobyte o en su
--defecto expresado en bytes.
--Por ejemplo, si el archivo imagen.jpg pesa 40960 bytes entonces debe figurar
--40 en la columna Tamaño Calculado y 'Kilobytes' en la columna unidad.

SELECT A.Nombre, A.Extension, A.Tamaño, TA.TipoArchivo,
	CASE									
		WHEN A.Tamaño >= 1073741824 THEN A.Tamaño / 1073741824.0
        WHEN A.Tamaño >= 1048576 THEN A.Tamaño / 1048576.0
        WHEN A.Tamaño >= 1024 THEN A.Tamaño / 1024.0
        ELSE A.Tamaño
	END AS [Tamaño Calculado],
    CASE 
        WHEN A.Tamaño >= 1073741824 THEN 'Gigabytes'
        WHEN A.Tamaño >= 1048576 THEN 'Megabytes'
        WHEN A.Tamaño >= 1024 THEN 'Kilobytes'
        ELSE 'Bytes'
    END AS [Unidad Calculada]	
	FROM Archivos AS A
	INNER JOIN TiposArchivos AS TA
		ON A.IDTipoArchivo = TA.IDTipoArchivo
GO
/***********************************************************************************************************/


--11 Listar los nombres de archivo y extensión de los archivos que han sido compartidos.

SELECT A.Nombre, A.Extension FROM ArchivosCompartidos AS AC
	INNER JOIN Archivos AS A
		ON AC.IDArchivo = A.IDArchivo
GO
/***********************************************************************************************************/

-- 12 Listar los nombres de archivo y extensión de los archivos que han sido compartidos a usuarios con apellido 'Clarck' o 'Jones'
SELECT A.Nombre AS [Nombre Archivo], A.Extension FROM ArchivosCompartidos AS AC
	INNER JOIN Archivos AS A
		ON AC.IDArchivo = A.IDArchivo
	INNER JOIN Usuarios AS U
		ON AC.IDUsuario = U.IDUsuario
			WHERE U.Apellido = 'Clarck' OR U.Apellido = 'Jones'
GO
/***********************************************************************************************************/


--13 Listar los nombres de archivo, extensión, apellidos y nombres de los usuarios a quienes se le hayan compartido archivos con permiso de 'Escritura'

SELECT A.Nombre, A.Extension, CONCAT(U.Apellido,' ', U.Nombre) AS[Apellido y Nombre]  FROM Archivos AS A
	INNER JOIN Usuarios AS U 
		ON A.IDUsuarioDueño = U.IDUsuario
	INNER JOIN ArchivosCompartidos AS AC
		ON U.IDUsuario = AC.IDUsuario
	INNER JOIN Permisos AS P
		ON AC.IDPermiso = P.IDPermiso
WHERE P.Nombre = 'Escritura'
GO
/***********************************************************************************************************/

--14 Listar los nombres de archivos y extensión de los archivos que no han sido compartidos.

SELECT A.IDArchivo, A.Nombre, A.Extension FROM Archivos AS A
	LEFT JOIN ArchivosCompartidos AS AC
		ON A.IDArchivo = AC.IDArchivo
WHERE AC.IDArchivo IS NULL
GO
/***********************************************************************************************************/


--15 Listar los apellidos y nombres de los usuarios dueños que tienen archivos eliminados.

SELECT CONCAT(U.Apellido,' ',U.Nombre) AS [Apellido y Nombre] FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDueño = U.IDUsuario
	WHERE A.Eliminado = 1
GO
/***********************************************************************************************************/

--16 Listar los nombres de los tipos de suscripciones, sin repetir, que tienen 
--archivos que pesan al menos 120 Megabytes.

								--Tamaño a modo de ejemplo ( no pide la columna en este ejercicio)
SELECT DISTINCT TU.TipoUsuario, (A.Tamaño / 1048576 ) AS [Tamaño en Megabytes] FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDueño = U.IDUsuario
	INNER JOIN TiposUsuario AS TU
		ON U.IDTipoUsuario = TU.IDTipoUsuario
WHERE A.Tamaño / 1048576 >= 120
GO
/***********************************************************************************************************/


--17 Listar los apellidos y nombres de los usuarios dueños, nombre del archivo,
--extensión, fecha de creación, fecha de modificación y la cantidad de días
--transcurridos desde la última modificación. Sólo incluir a los archivos que se
--hayan modificado (fecha de modificación distinta a la fecha de creación).


SELECT CONCAT(U.Apellido,' ',U.Nombre) AS[Apellido y Nombre], A.Nombre, A.Extension, A.FechaCreacion, A.FechaUltimaModificacion, DATEDIFF(DAY,FechaUltimaModificacion,GETDATE()) AS [Dias Transcurridos] FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDueño = U.IDUsuario
	WHERE A.FechaUltimaModificacion != A.FechaCreacion
GO
/***********************************************************************************************************/

--18 Listar nombres de archivos, extensión, tamaño, apellidos y nombres del
--usuario dueño del archivo, apellido y nombre del usuario que tiene el archivo
--compartido y el nombre de permiso otorgado.

SELECT A.Nombre AS[Nombre Archivo], A.Extension, A.Tamaño, CONCAT(U.Apellido,' ',U.Nombre) AS [Dueño del Archivo],CONCAT(USU.Apellido,' ',USU.Nombre) AS [Usuario Compartido] , P.Nombre AS [Nombre Permiso] FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDueño = U.IDUsuario
	INNER JOIN ArchivosCompartidos AS AC
		ON A.IDArchivo = AC.IDArchivo
	INNER JOIN Usuarios AS USU 
		ON AC.IDUsuario = USU.IDUsuario
	INNER JOIN Permisos AS P
		ON AC.IDPermiso = P.IDPermiso
GO
/***********************************************************************************************************/

--19 Listar nombres de archivos, extensión, tamaño, apellidos y nombres del
--usuario dueño del archivo, apellido y nombre del usuario que tiene el archivo
--compartido y el nombre de permiso otorgado. Sólo listar aquellos registros
--cuyos tipos de usuarios coincidan tanto para el dueño como para el usuario al
--que le comparten el archivo.

SELECT A.Nombre AS[Nombre Archivo], A.Extension, A.Tamaño, CONCAT(U.Apellido,' ',U.Nombre) AS [Dueño del Archivo],CONCAT(USU.Apellido,' ',USU.Nombre) AS [Usuario Compartido] , P.Nombre AS [Nombre Permiso] FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDueño = U.IDUsuario
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


-- 20 Apellidos y nombres de los usuario que tengan compartido o sea dueño del
--archivo con nombre 'Documento Legal'.

SELECT CONCAT(U.Apellido,' ',U.Nombre) AS [Apellido y Nombre] FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDueño = U.IDUsuario
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
