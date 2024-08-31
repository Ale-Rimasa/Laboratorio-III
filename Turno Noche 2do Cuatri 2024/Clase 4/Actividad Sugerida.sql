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
