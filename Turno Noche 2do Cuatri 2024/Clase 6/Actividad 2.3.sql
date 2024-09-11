--1 La cantidad de archivos con extensión zip.
SELECT COUNT (*) AS [Total Archivos ZIP] FROM Archivos WHERE Extension = 'zip'
GO

/***********************************************************************************************************/
--2 La cantidad de archivos que fueron modificados y, por lo tanto, su fecha de
--última modificación no es la misma que la fecha de creación.
SELECT COUNT (*) AS [Total Archivos modificados] FROM Archivos WHERE FechaCreacion != FechaUltimaModificacion
GO
/***********************************************************************************************************/

--3 La fecha de creación más antigua de los archivos con extensión pdf.
SELECT MIN(FechaCreacion) AS [Fecha Más Antigua] FROM Archivos WHERE Extension = 'pdf'

--CHEQUEO
SELECT * FROM Archivos WHERE Extension = 'pdf' ORDER BY FechaCreacion asc
GO
/***********************************************************************************************************/

--4 La cantidad de extensiones distintas cuyos archivos tienen en su nombre o en
--su descripción la palabra 'Informe' o 'Documento'.
SELECT COUNT(Extension) AS [Cantidad Extensiones] FROM Archivos WHERE Nombre LIKE 'Informe%' OR Descripcion LIKE 'Documento%'

--CHEQUEO
SELECT * FROM Archivos WHERE Nombre LIKE 'Informe%' OR Descripcion LIKE 'Documento%'
GO
/***********************************************************************************************************/
--5 El promedio de tamaño (expresado en Megabytes) de los archivos con extensión 'doc', 'docx', 'xls', 'xlsx'.
-- REVISAR
SELECT AVG(Tamaño / 1048576) AS [Promedio en MB] FROM Archivos WHERE Extension IN ('doc','docx','xls','xlsx')

SELECT AVG(Tamaño/ 1048576) FROM Archivos WHERE Extension = 'doc' OR Extension = 'docx' OR  Extension = 'xls' OR Extension = 'xlsx'
/***********************************************************************************************************/
--6 La cantidad de archivos que le fueron compartidos al usuario con apellido 'Clarck'

SELECT COUNT(*) AS [Archivos compartidos Clarck] FROM ArchivosCompartidos AS AC
	INNER JOIN Usuarios AS U
		ON AC.IDUsuario = U.IDUsuario
		WHERE u.Apellido = 'Clarck'

--CHEQUEO
SELECT * FROM ArchivosCompartidos AS AC
	INNER JOIN Usuarios AS U
		ON AC.IDUsuario = U.IDUsuario
		WHERE U.Apellido = 'Clarck'

/***********************************************************************************************************/
--7 La cantidad de tipos de usuario que tienen asociado usuarios que registren, como dueños, archivos con extensión pdf.

/***********************************************************************************************************/
--8 El tamaño máximo expresado en Megabytes de los archivos que hayan sido creados en el año 2024.

SELECT MAX(Tamaño / 1048576) AS [Tamaño Maximo en MB] FROM Archivos WHERE YEAR(FechaCreacion) = 2024

--CHEQUEO
SELECT  TOP 1 IDArchivo,(Tamaño / 1048576) AS [Tamaño Maximo en MB] FROM Archivos WHERE YEAR(FechaCreacion) = 2024 ORDER BY Tamaño DESC

/***********************************************************************************************************/
--9 El nombre del tipo de usuario y la cantidad de usuarios distintos de dicho tipo
--que registran, como dueños, archivos con extensión pdf.

SELECT DISTINCT TU.TipoUsuario AS[Nombre Tipo Usuario], COUNT(*) AS [Usuarios Dueños] FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDueño = U.IDUsuario
	INNER JOIN TiposUsuario AS TU
		ON U.IDTipoUsuario = TU.IDTipoUsuario
		WHERE A.Extension = 'pdf'
		GROUP BY Tu.TipoUsuario

		--CHEQUEO
SELECT DISTINCT TU.TipoUsuario AS [Nombre Tipo Usuario],U.Apellido, A.Extension, A.IDUsuarioDueño FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDueño = U.IDUsuario
	INNER JOIN TiposUsuario AS TU
		ON U.IDTipoUsuario = TU.IDTipoUsuario
		WHERE A.Extension = 'pdf'

/***********************************************************************************************************/
--10 El nombre y apellido de los usuarios dueños y la suma total del tamaño de los
--archivos que tengan compartidos con otros usuarios. Mostrar ordenado de
--mayor sumatoria de tamaño a menor.

SELECT CONCAT(U.Apellido,' ', U.Nombre) AS [Apellido y Nombre], SUM(A.Tamaño) AS [Suma Total de Archivos Compartidos] FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDueño = U.IDUsuario
	INNER JOIN ArchivosCompartidos AS AC
		ON A.IDArchivo = AC.IDArchivo
		GROUP BY U.Apellido, U.Nombre
		ORDER BY [Suma Total de Archivos Compartidos] DESC

		--CHEQUEOOOO CON ID 5 QUE ES EL PRIMER MAYOR
SELECT DISTINCT CONCAT(U.Apellido,' ', U.Nombre) AS [Apellido y Nombre],A.IDUsuarioDueño, AC.IDUsuario, SUM(A.Tamaño) AS [Suma Total de Archivos Compartidos] FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDueño = U.IDUsuario
	INNER JOIN ArchivosCompartidos AS AC
		ON A.IDArchivo = AC.IDArchivo
		WHERE A.IDUsuarioDueño = 5 
		GROUP BY U.Apellido, U.Nombre, A.IDUsuarioDueño, AC.IDUsuario
/***********************************************************************************************************/
--11 El nombre del tipo de archivo y el promedio de tamaño de los archivos que
--corresponden a dicho tipo de archivo.

SELECT TA.TipoArchivo, AVG(A.Tamaño) [Promedio] FROM Archivos AS A
	INNER JOIN TiposArchivos AS TA
		ON A.IDTipoArchivo = TA.IDTipoArchivo
		GROUP BY TA.TipoArchivo
/***********************************************************************************************************/
--12



SELECT * FROM TiposUsuario
SELECT * FROM Usuarios
SELECT * FROM ArchivosCompartidos
SELECT * FROM Archivos