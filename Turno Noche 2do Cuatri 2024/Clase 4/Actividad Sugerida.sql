--A) Obtener un listado de actores ordenado por apellido en forma descendente.

SELECT * FROM Actores ORDER BY Apellido DESC

--B) Obtener un listado de actores que tengan edad entre 18 y 28 años.
SELECT Apellido, Nombre, FechaNacimiento, DATEDIFF(YEAR,FechaNacimiento,GETDATE()) AS [Edad] FROM Actores --Para saber la edad de los actores
SELECT Apellido, Nombre, FechaNacimiento FROM Actores WHERE DATEDIFF(YEAR,FechaNacimiento,GETDATE()) BETWEEN 18 AND 28

--C) Obtener un listado de actores que cumplan años en los meses de Enero, Febrero, Marzo, Octubre, Noviembre y Diciembre.

SELECT * FROM Actores WHERE MONTH(FechaNacimiento) IN (1,2,3,10,11,12) 

--D) Obtener un listado de actores que no sean de nacionalidad con código 1, 2, 3, 6, 7 ni 8.

SELECT * FROM Actores WHERE ID_Pais NOT IN (1,2,3,6,7,8)

--E) Obtener la última película estrenada del género ciencia ficción.

SELECT TOP 1 * FROM Peliculas WHERE ID_Genero = 3 ORDER BY Fecha_Estreno DESC

--F) Obtener la película que mayor recaudación haya obtenido en el año 2011.

SELECT TOP 1 * FROM Peliculas WHERE YEAR(Fecha_Estreno) = 2011 ORDER BY Recaudacion DESC

--G) Obtener las 10 mejores películas calificadas por los críticos. Mostrar todas las películas que se
--encuentren en el 10° puesto si hay más de una película con igual puntaje en dicha posición.

SELECT TOP 10 * FROM Peliculas ORDER BY Puntaje DESC		--PREGUNTAR

--H) Obtener un listado de todas las películas en las que haya actuado el actor con código número 3.		

SELECT * FROM Peliculas INNER JOIN
Actores_X_Pelicula AS AXP
	ON Peliculas.ID_Pelicula = AXP.ID_Pelicula
	WHERE ID_Actores = 3

--I) Obtener un listado que indique código de película, título y ganancia sólo de las películas que no hayan generado pérdida.
SELECT * FROM Peliculas

SELECT ID_Pelicula, Titulo, (Recaudacion - Inversion) AS [Ganancia]
	FROM Peliculas WHERE Recaudacion >= Inversion

--J) Obtener los datos de la película que menos duración tenga

SELECT TOP 1 * FROM Peliculas Order BY Duracion

--K) Obtener los datos de las películas que su título comience con la cadena 'Star'.

SELECT * FROM Peliculas WHERE Titulo LIKE 'Star%'

-- L) Obtener los datos de las películas que su título comience con la letra 'T' pero su última letra no sea 'A', 'E', 'I', 'O' ni 'U'.

SELECT * FROM Peliculas WHERE Titulo LIKE 'T%' AND Titulo NOT LIKE '%[AEIOU]'

--M) Obtener los datos de las películas que su título contenga al menos un número del 0 al 9.

SELECT * FROM Peliculas WHERE Titulo LIKE '%[0-9]'

--N) Obtener los datos de las películas que su título contenga exactamente cinco caracteres.
--Resolverlo de dos maneras: 1) Utilizando el operador LIKE y comodines - 2) Utilizando la función
--LEN.

SELECT * FROM Peliculas WHERE Titulo LIKE '_____'

SELECT * FROM Peliculas WHERE LEN(Titulo) = 5

-- O) Obtener los datos de las películas cuya recaudación supere el 25% de la inversión.

SELECT * FROM Peliculas WHERE Recaudacion > (Inversion * 1.25)

--P ) Obtener el título y el valor promedio de cada ticket. Teniendo en cuenta que la recaudación es netamente sobre venta de tickets.

SELECT Titulo, (Recaudacion / TicketsVendidos) AS [Valor Promedio] FROM Peliculas

--Q) Obtener el título de la película, la recaudación en dólares y la recaudación pesos. Teniendo en cuenta que u$s 1 -> $ 4,39

SELECT Titulo, (Recaudacion / 4.39) AS Dolares, (Recaudacion * 4.39) AS [Pesos] FROM Peliculas

--R) Obtener los datos de las películas cuyo puntaje se encuentre en el intervalo (1, 7).

SELECT * FROM Peliculas WHERE Puntaje >= 1 AND Puntaje <= 7

SELECT * FROM Peliculas WHERE Puntaje BETWEEN 1 AND 7