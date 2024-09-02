--A) Obtener un listado de actores ordenado por apellido en forma descendente.

SELECT * FROM Actores ORDER BY Apellido DESC

--B) Obtener un listado de actores que tengan edad entre 18 y 28 a�os.
SELECT Apellido, Nombre, FechaNacimiento, DATEDIFF(YEAR,FechaNacimiento,GETDATE()) AS [Edad] FROM Actores --Para saber la edad de los actores
SELECT Apellido, Nombre, FechaNacimiento FROM Actores WHERE DATEDIFF(YEAR,FechaNacimiento,GETDATE()) BETWEEN 18 AND 28

--C) Obtener un listado de actores que cumplan a�os en los meses de Enero, Febrero, Marzo, Octubre, Noviembre y Diciembre.

SELECT * FROM Actores WHERE MONTH(FechaNacimiento) IN (1,2,3,10,11,12) 

--D) Obtener un listado de actores que no sean de nacionalidad con c�digo 1, 2, 3, 6, 7 ni 8.

SELECT * FROM Actores WHERE ID_Pais NOT IN (1,2,3,6,7,8)

--E) Obtener la �ltima pel�cula estrenada del g�nero ciencia ficci�n.

SELECT TOP 1 * FROM Peliculas WHERE ID_Genero = 3 ORDER BY Fecha_Estreno DESC

--F) Obtener la pel�cula que mayor recaudaci�n haya obtenido en el a�o 2011.

SELECT TOP 1 * FROM Peliculas WHERE YEAR(Fecha_Estreno) = 2011 ORDER BY Recaudacion DESC

--G) Obtener las 10 mejores pel�culas calificadas por los cr�ticos. Mostrar todas las pel�culas que se
--encuentren en el 10� puesto si hay m�s de una pel�cula con igual puntaje en dicha posici�n.

SELECT TOP 10 * FROM Peliculas ORDER BY Puntaje DESC		--PREGUNTAR

--H) Obtener un listado de todas las pel�culas en las que haya actuado el actor con c�digo n�mero 3.		

SELECT * FROM Peliculas INNER JOIN
Actores_X_Pelicula AS AXP
	ON Peliculas.ID_Pelicula = AXP.ID_Pelicula
	WHERE ID_Actores = 3

--I) Obtener un listado que indique c�digo de pel�cula, t�tulo y ganancia s�lo de las pel�culas que no hayan generado p�rdida.
SELECT * FROM Peliculas

SELECT ID_Pelicula, Titulo, (Recaudacion - Inversion) AS [Ganancia]
	FROM Peliculas WHERE Recaudacion >= Inversion

--J) Obtener los datos de la pel�cula que menos duraci�n tenga

SELECT TOP 1 * FROM Peliculas Order BY Duracion

--K) Obtener los datos de las pel�culas que su t�tulo comience con la cadena 'Star'.

SELECT * FROM Peliculas WHERE Titulo LIKE 'Star%'

-- L) Obtener los datos de las pel�culas que su t�tulo comience con la letra 'T' pero su �ltima letra no sea 'A', 'E', 'I', 'O' ni 'U'.

SELECT * FROM Peliculas WHERE Titulo LIKE 'T%' AND Titulo NOT LIKE '%[AEIOU]'

--M) Obtener los datos de las pel�culas que su t�tulo contenga al menos un n�mero del 0 al 9.

SELECT * FROM Peliculas WHERE Titulo LIKE '%[0-9]'

--N) Obtener los datos de las pel�culas que su t�tulo contenga exactamente cinco caracteres.
--Resolverlo de dos maneras: 1) Utilizando el operador LIKE y comodines - 2) Utilizando la funci�n
--LEN.

SELECT * FROM Peliculas WHERE Titulo LIKE '_____'

SELECT * FROM Peliculas WHERE LEN(Titulo) = 5

-- O) Obtener los datos de las pel�culas cuya recaudaci�n supere el 25% de la inversi�n.

SELECT * FROM Peliculas WHERE Recaudacion > (Inversion * 1.25)

--P ) Obtener el t�tulo y el valor promedio de cada ticket. Teniendo en cuenta que la recaudaci�n es netamente sobre venta de tickets.

SELECT Titulo, (Recaudacion / TicketsVendidos) AS [Valor Promedio] FROM Peliculas

--Q) Obtener el t�tulo de la pel�cula, la recaudaci�n en d�lares y la recaudaci�n pesos. Teniendo en cuenta que u$s 1 -> $ 4,39

SELECT Titulo, (Recaudacion / 4.39) AS Dolares, (Recaudacion * 4.39) AS [Pesos] FROM Peliculas

--R) Obtener los datos de las pel�culas cuyo puntaje se encuentre en el intervalo (1, 7).

SELECT * FROM Peliculas WHERE Puntaje >= 1 AND Puntaje <= 7

SELECT * FROM Peliculas WHERE Puntaje BETWEEN 1 AND 7