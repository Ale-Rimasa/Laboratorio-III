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

SELECT COUNT(DISTINCT Tu.IDTipoUsuario) AS [Cantidad tipos usuario] FROM Archivos As a
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDueño = U.IDUsuario
	INNER JOIN TiposUsuario AS TU
		ON U.IDTipoUsuario = TU.IDTipoUsuario
		WHERE a.Extension = 'pdf'

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
--12 Por cada extensión, indicar la extensión, la cantidad de archivos con esa
--extensión y el total acumulado en bytes. Ordenado por cantidad de archivos
--de forma ascendente.


SELECT Extension, COUNT(*) AS [Cantidad archivos],
	   SUM(Tamaño) AS [Total Acumulado] 
				  FROM Archivos				  
				  GROUP BY Extension
				  ORDER BY [Cantidad archivos] ASC
				

--CHEQUEO DE CANTIDAD DE DATOS
SELECT Extension, COUNT(Extension) AS [Cantidad archivos],
	   SUM(Tamaño) AS [Total Acumulado] 
				  FROM Archivos				  
				  GROUP BY Extension, Tamaño
				  ORDER BY Extension ASC
/***********************************************************************************************************/
--13 Por cada usuario, indicar IDUSuario, Apellido, Nombre y la sumatoria total en
--bytes de los archivos que es dueño. Si algún usuario no registra archivos
--indicar 0 en la sumatoria total.

SELECT A.IDUsuarioDueño, CONCAT(U.Apellido,' ', U.Nombre) AS [Apellido Nombre], COALESCE(SUM(A.Tamaño),0) AS [Suma Total] FROM Usuarios AS U
	LEFT JOIN Archivos AS A
		ON U.IDUsuario = A.IDUsuarioDueño
			GROUP BY A.IDUsuarioDueño, U.Apellido, U.Nombre

/***********************************************************************************************************/
--14 Los tipos de archivos que fueron compartidos más de una vez con el permiso con nombre 'Lectura'

SELECT TA.TipoArchivo FROM TiposArchivos AS TA
		INNER JOIN Archivos AS A
			ON TA.IDTipoArchivo = A.IDTipoArchivo
		INNER JOIN ArchivosCompartidos AS AC
			ON A.IDArchivo = AC.IDArchivo
		INNER JOIN Permisos AS P
			ON AC.IDPermiso = p.IDPermiso
			WHERE p.Nombre = 'Lectura'
			GROUP BY Ta.TipoArchivo
			HAVING COUNT (AC.IDArchivo) > 1
/***********************************************************************************************************/
--15 Escribí una consulta que requiera una función de resumen, el uso de joins y de
--having. Pega en el Foro de Actividad 2.3 en el hilo "Queries del Ejercicio 15" el
--enunciado de la consulta y la tabla en formato texto plano de lo que daría
--como resultado con los datos que trabajamos en conjunto.

-- Listar Apellido y Nombre de los usuarios dueños cuyo promedio de tamaño de los archivos compartidos sea mayor a 500000 bytes.
--Ordenando el tamaño de forma descendente.

SELECT CONCAT (U.Apellido, ' ', U.Nombre) AS [Apellido Nombre], AVG(A.Tamaño) [Promedio de tamaños de archivo compartidos] FROM Archivos AS A
	INNER JOIN ArchivosCompartidos AS AC
		ON A.IDArchivo = AC.IDArchivo
	INNER JOIN Usuarios AS U
		ON A.IDUsuarioDueño = U.IDUsuario
			GROUP BY U.Apellido, U.Nombre
			HAVING AVG(A.Tamaño) > 500000
			ORDER BY [Promedio de tamaños de archivo compartidos] DESC
/***********************************************************************************************************/
--16 Por cada tipo de archivo indicar el tipo de archivo y el tamaño del archivo de
--dicho tipo que sea más pesado.

SELECT Ta.TipoArchivo, MAX(A.Tamaño) AS [Archivo más pesado] FROM Archivos AS A
	INNER JOIN TiposArchivos AS TA
		ON A.IDTipoArchivo = TA.IDTipoArchivo
		GROUP BY TA.TipoArchivo
		ORDER BY [Archivo más pesado] DESC
/***********************************************************************************************************/
--17 El nombre del tipo de archivo y el promedio de tamaño de los archivos que
--corresponden a dicho tipo de archivo. Solamente listar aquellos registros que
--superen los 50 Megabytes de promedio.

SELECT TA.TipoArchivo, AVG(A.Tamaño) AS [Promedio Tamaño] FROM Archivos AS A
	INNER JOIN TiposArchivos AS TA
		ON A.IDTipoArchivo = TA.IDTipoArchivo
		GROUP BY TA.TipoArchivo
		HAVING AVG(A.Tamaño) > 52428800
/***********************************************************************************************************/
--18 Listar las extensiones que registren más de 2 archivos que no hayan sido compartidos.

SELECT A.Extension, COUNT(*) AS [Cantidad archivo compartidos] FROM Archivos AS A
	LEFT JOIN ArchivosCompartidos AS AC
		ON A.IDArchivo = AC.IDArchivo
		WHERE AC.IDArchivo IS NULL
		GROUP BY A.Extension
		HAVING COUNT(*) > 2


SELECT * FROM TiposUsuario
SELECT * FROM Usuarios
SELECT * FROM ArchivosCompartidos
SELECT * FROM Archivos
SELECT * FROM TiposArchivos
SELECT * FROM Permisos