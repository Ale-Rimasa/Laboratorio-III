--1 Por cada usuario listar el nombre, apellido y el nombre del tipo de usuario.

SELECT U.Nombre, U.Apellido, TU.TipoUsuario FROM Usuarios AS U 
	INNER JOIN TiposUsuario AS TU 
		ON U.IDTipoUsuario = TU.IDTipoUsuario

--2 Listar el ID, nombre, apellido y tipo de usuario de aquellos usuario que sean
--del tipo 'Suscripci�n Free' o 'Suscripci�n B�sica'

SELECT U.IDUsuario, U.Nombre, U.Apellido, TU.TipoUsuario FROM Usuarios AS U
	INNER JOIN TiposUsuario AS TU 
		ON U.IDTipoUsuario = TU.IDTipoUsuario
			WHERE TU.TipoUsuario = 'Suscripci�n FREE' OR  TU.TipoUsuario= 'Suscripci�n B�sica'

--3 Listar los nombres de archivos, extensi�n, tama�o expresado en Megabytes y
-- el nombre del tipo de archivo.
-- NOTA: En la tabla Archivos el tama�o est� expresado en Bytes.

SELECT A.Nombre, A.Extension, (A.Tama�o / 1048576 ) AS [Tama�o en Megabytes], TA.TipoArchivo FROM Archivos AS A
	INNER JOIN TiposArchivos AS TA
	ON A.IDTipoArchivo = TA.IDTipoArchivo

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
		
-- 5 Listar los nombres de archivos, su extensi�n, el tama�o en megabytes y
--la fecha de creaci�n de aquellos archivos que le pertenezca al usuario due�o con nombre 'Michael' y apellido 'Williams'.

SELECT A.Nombre, A.Extension, (A.Tama�o / 1048576) AS [Tama�o en Mega], A.FechaCreacion FROM Archivos A
	INNER JOIN Usuarios AS U 
	ON A.IDUsuarioDue�o = U.IDUsuario
	WHERE U.Nombre = 'Michael' AND U.Apellido = 'Williams'

--6 Listar los datos completos del archivo m�s pesado del usuario due�o con nombre 'Michael' y apellido 'Williams'.
--Si hay varios archivos que cumplen esa condici�n, listarlos a todos.

SELECT TOP 1 WITH TIES * FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDue�o = U.IDUsuario
		WHERE U.Nombre ='Michael' AND U.Apellido = 'Williams' ORDER BY A.Tama�o DESC

-- 7 Listar nombres de archivos, extensi�n, tama�o en bytes, fecha de creaci�n y de modificaci�n,
--apellido y nombre del usuario due�o de aquellos archivos cuya descripci�n contengan el t�rmino 'empresa' o 'presupuesto'

SELECT A.Nombre, A.Extension, A.Tama�o, A.FechaCreacion, A.FechaUltimaModificacion,A.Descripcion, CONCAT(U.Apellido,' ',U.Nombre) AS [Apellido y Nombre] FROM Archivos A
	INNER JOIN Usuarios AS U
	ON A.IDUsuarioDue�o = U.IDUsuario
	WHERE A.Descripcion LIKE '%empresa' OR A.Descripcion LIKE 'Presupuesto%'

--8  Listar las extensiones sin repetir de aquellos usuarios due�os que tengan tipo de usuario 'Suscripci�n Plus',
--'Suscripci�n Premium' o 'Suscripci�n Empresarial'

SELECT DISTINCT A.Extension FROM Archivos A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDue�o = U.IDUsuario
		INNER JOIN TiposUsuario AS TU
		ON U.IDTipoUsuario = TU.IDTipoUsuario
		WHERE TU.TipoUsuario = 'Suscripci�n Plus' OR TU.TipoUsuario = 'Suscripci�n Premium' OR TU.TipoUsuario = 'Suscripci�n Empresarial'


--9 Listar los apellidos y nombres de los usuarios due�os y el tama�o del archivo
--de los tres archivos con extensi�n 'zip' m�s pesados. Puede ocurrir que el
--mismo usuario aparezca varias veces en el listado.

SELECT TOP 3 CONCAT(U.Apellido,' ',U.Nombre), A.Tama�o FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDue�o = U.IDUsuario
		WHERE A.Extension = 'zip'

--10 Por cada archivo listar el nombre del archivo, la extensi�n, el tama�o en bytes,
--el nombre del tipo de archivo y el tama�o calculado en su mayor expresi�n y la
--unidad calculada. Siendo Gigabytes si al menos pesa un gigabyte, Megabytes
--si al menos pesa un megabyte, Kilobyte si al menos pesa un kilobyte o en su
--defecto expresado en bytes.
--Por ejemplo, si el archivo imagen.jpg pesa 40960 bytes entonces debe figurar
--40 en la columna Tama�o Calculado y 'Kilobytes' en la columna unidad.

SELECT A.Nombre, A.Extension, A.Tama�o, TA.TipoArchivo FROM Archivos AS A
	INNER JOIN TiposArchivos AS TA
		ON A.IDTipoArchivo = TA.IDTipoArchivo


--11 Listar los nombres de archivo y extensi�n de los archivos que han sido compartidos.

SELECT A.Nombre, A.Extension FROM ArchivosCompartidos AS AC
	INNER JOIN Archivos AS A
		ON AC.IDArchivo = A.IDArchivo

-- 12 Listar los nombres de archivo y extensi�n de los archivos que han sido compartidos a usuarios con apellido 'Clarck' o 'Jones'
SELECT A.Nombre AS [Nombre Archivo], A.Extension FROM ArchivosCompartidos AS AC
	INNER JOIN Archivos AS A
		ON AC.IDArchivo = A.IDArchivo
	INNER JOIN Usuarios AS U
		ON AC.IDUsuario = U.IDUsuario
			WHERE U.Apellido = 'Clarck' OR U.Apellido = 'Jones'


--13 Listar los nombres de archivo, extensi�n, apellidos y nombres de los usuarios a quienes se le hayan compartido archivos con permiso de 'Escritura'



SELECT * FROM Archivos
SELECT * FROM ArchivosCompartidos
SELECT * FROM Permisos
SELECT * FROM Usuarios
SELECT * FROM TiposArchivos
SELECT * FROM TiposUsuario