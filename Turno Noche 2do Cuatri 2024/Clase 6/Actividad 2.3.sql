--1 La cantidad de archivos con extensi�n zip.
SELECT COUNT (*) AS [Total Archivos ZIP] FROM Archivos WHERE Extension = 'zip'
GO

/***********************************************************************************************************/
--2 La cantidad de archivos que fueron modificados y, por lo tanto, su fecha de
--�ltima modificaci�n no es la misma que la fecha de creaci�n.
SELECT COUNT (*) AS [Total Archivos modificados] FROM Archivos WHERE FechaCreacion != FechaUltimaModificacion
GO
/***********************************************************************************************************/

--3 La fecha de creaci�n m�s antigua de los archivos con extensi�n pdf.
SELECT MIN(FechaCreacion) AS [Fecha M�s Antigua] FROM Archivos WHERE Extension = 'pdf'

--CHEQUEO
SELECT * FROM Archivos WHERE Extension = 'pdf' ORDER BY FechaCreacion asc
GO
/***********************************************************************************************************/

--4 La cantidad de extensiones distintas cuyos archivos tienen en su nombre o en
--su descripci�n la palabra 'Informe' o 'Documento'.
SELECT COUNT(Extension) AS [Cantidad Extensiones] FROM Archivos WHERE Nombre LIKE 'Informe%' OR Descripcion LIKE 'Documento%'

--CHEQUEO
SELECT * FROM Archivos WHERE Nombre LIKE 'Informe%' OR Descripcion LIKE 'Documento%'
GO
/***********************************************************************************************************/
--5 El promedio de tama�o (expresado en Megabytes) de los archivos con extensi�n 'doc', 'docx', 'xls', 'xlsx'.
-- REVISAR
SELECT AVG(Tama�o / 1048576) AS [Promedio en MB] FROM Archivos WHERE Extension IN ('doc','docx','xls','xlsx')

SELECT AVG(Tama�o/ 1048576) FROM Archivos WHERE Extension = 'doc' OR Extension = 'docx' OR  Extension = 'xls' OR Extension = 'xlsx'
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
--7 La cantidad de tipos de usuario que tienen asociado usuarios que registren, como due�os, archivos con extensi�n pdf.

/***********************************************************************************************************/
--8 El tama�o m�ximo expresado en Megabytes de los archivos que hayan sido creados en el a�o 2024.

SELECT MAX(Tama�o / 1048576) AS [Tama�o Maximo en MB] FROM Archivos WHERE YEAR(FechaCreacion) = 2024

--CHEQUEO
SELECT  TOP 1 IDArchivo,(Tama�o / 1048576) AS [Tama�o Maximo en MB] FROM Archivos WHERE YEAR(FechaCreacion) = 2024 ORDER BY Tama�o DESC

/***********************************************************************************************************/
--9 El nombre del tipo de usuario y la cantidad de usuarios distintos de dicho tipo
--que registran, como due�os, archivos con extensi�n pdf.

SELECT DISTINCT TU.TipoUsuario AS[Nombre Tipo Usuario], COUNT(*) AS [Usuarios Due�os] FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDue�o = U.IDUsuario
	INNER JOIN TiposUsuario AS TU
		ON U.IDTipoUsuario = TU.IDTipoUsuario
		WHERE A.Extension = 'pdf'
		GROUP BY Tu.TipoUsuario

		--CHEQUEO
SELECT DISTINCT TU.TipoUsuario AS [Nombre Tipo Usuario],U.Apellido, A.Extension, A.IDUsuarioDue�o FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDue�o = U.IDUsuario
	INNER JOIN TiposUsuario AS TU
		ON U.IDTipoUsuario = TU.IDTipoUsuario
		WHERE A.Extension = 'pdf'

/***********************************************************************************************************/
--10 El nombre y apellido de los usuarios due�os y la suma total del tama�o de los
--archivos que tengan compartidos con otros usuarios. Mostrar ordenado de
--mayor sumatoria de tama�o a menor.

SELECT CONCAT(U.Apellido,' ', U.Nombre) AS [Apellido y Nombre], SUM(A.Tama�o) AS [Suma Total de Archivos Compartidos] FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDue�o = U.IDUsuario
	INNER JOIN ArchivosCompartidos AS AC
		ON A.IDArchivo = AC.IDArchivo
		GROUP BY U.Apellido, U.Nombre
		ORDER BY [Suma Total de Archivos Compartidos] DESC

		--CHEQUEOOOO CON ID 5 QUE ES EL PRIMER MAYOR
SELECT DISTINCT CONCAT(U.Apellido,' ', U.Nombre) AS [Apellido y Nombre],A.IDUsuarioDue�o, AC.IDUsuario, SUM(A.Tama�o) AS [Suma Total de Archivos Compartidos] FROM Archivos AS A
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDue�o = U.IDUsuario
	INNER JOIN ArchivosCompartidos AS AC
		ON A.IDArchivo = AC.IDArchivo
		WHERE A.IDUsuarioDue�o = 5 
		GROUP BY U.Apellido, U.Nombre, A.IDUsuarioDue�o, AC.IDUsuario
/***********************************************************************************************************/
--11 El nombre del tipo de archivo y el promedio de tama�o de los archivos que
--corresponden a dicho tipo de archivo.

SELECT TA.TipoArchivo, AVG(A.Tama�o) [Promedio] FROM Archivos AS A
	INNER JOIN TiposArchivos AS TA
		ON A.IDTipoArchivo = TA.IDTipoArchivo
		GROUP BY TA.TipoArchivo
/***********************************************************************************************************/
--12



SELECT * FROM TiposUsuario
SELECT * FROM Usuarios
SELECT * FROM ArchivosCompartidos
SELECT * FROM Archivos