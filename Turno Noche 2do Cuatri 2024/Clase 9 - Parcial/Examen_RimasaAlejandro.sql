--1 ¿Cuáles de los siguientes mozos han servido platos en el año 2024 que hayan demorado más de 35 minutos
--en prepararse y que sean de una dificultad superior a 8?

SELECT DISTINCT M.Apellidos, M.Nombres FROM Mozos AS M
	INNER JOIN ServiciosMesa AS SM
		ON M.IDMozo = SM.IDMozo
	INNER JOIN Platos AS P
		ON SM.IDPlato = P.IDPlato
	WHERE YEAR(SM.Fecha) = 2024 AND SM.TiempoPreparacion > 35 AND P.NivelDificultad > 8

--2 ¿Cómo se llaman los tres mozos cuyos servicios tuvieron el mejor puntaje promedio?

SELECT TOP 3 CONCAT(M.Apellidos, ' ',M.Nombres) AS [APNOM], AVG(SM.PuntajeObtenido) AS [Mejor puntaje promedio] FROM Mozos AS M
		INNER JOIN ServiciosMesa AS SM
			ON M.IDMozo = SM.IDMozo
			GROUP BY M.Apellidos, M.Nombres
			ORDER BY [Mejor puntaje promedio] DESC

--3 ¿Cuántos servicios de mesa en los que dejaron propina realizó la mozo llamada María López?

SELECT COUNT(*) AS [Cantidad servicios de mesa] FROM ServiciosMesa AS SM
	INNER JOIN Mozos AS M
		ON SM.IDMozo = M.IDMozo
		WHERE M.Apellidos = 'López' AND M.Nombres = 'María' AND Propina IS NOT NULL

--4 ¿Cuál fue la cantidad de servicios de mesa que fueron valorados con un puntaje mayor al puntaje promedio?
SELECT COUNT(SM.IDServicioMesa) AS [Cantidad servicios de mesa] FROM ServiciosMesa AS SM
	WHERE SM.PuntajeObtenido > 
(
SELECT AVG(SM2.PuntajeObtenido) FROM ServiciosMesa AS SM2
)

--5 Agrega las tablas, columnas y restricciones que consideres necesario para poder registrar los cocineros del restaurant. 
--Debe poder registrarse el apellido, nombre, fecha de nacimiento y fecha de ingreso al restaurant. 
CREATE TABLE Cocineros (
	IDCocinero INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	Apellidos VARCHAR(50) NOT NULL,
    Nombres VARCHAR(50) NOT NULL,
	FechaNacimiento DATE NOT NULL,
	FechaIngreso DATE NOT NULL,
)

--También se debe poder conocer qué cocineros participaron en cada servicio de mesa. 
--Tener en cuenta que es posible que más de un cocinero haya trabajo en el mismo servicio de mesa.

CREATE TABLE Cocineros_X_ServicioMesa (
	IDCocinero INT NOT NULL FOREIGN KEY REFERENCES Cocineros (IDCocinero),
	IDServicioMesa BIGINT NOT NULL FOREIGN KEY REFERENCES ServiciosMesa (IDServicioMesa),
)


SELECT * FROM ServiciosMesa
SELECT * FROM Mozos
SELECT * FROM Platos