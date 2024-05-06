--1 INFORME TODOS LOS MODELOS REGISTRADOS DE UNA DETERMINADA MARCA
SELECT M.Modelo_MO, M.TipoVehiculo_MO
FROM Modelos M INNER JOIN Marcas
ON M.CodMarca_MA_MO = Marcas.CodMarca_MA
WHERE Marcas.Marca_MA = 'FORD'
GO

--2 INFORME LOS NOMBRES DE LOS TALLERES OFICIALES CUYAS MARCAS NO COMIENCEN CON VOCAL, POSTERIORMENTE UNA VOCAL,
--SEGUIDA DE CUALQUIER CARACTER INDIVIDUAL, Y CUALQUIER CADENA DE CARACTERES.
SELECT M.TallerOficial_MA, M.CodMarca_MA, m.Marca_MA
FROM MARCAS M
WHERE M.TallerOficial_MA LIKE '[^A,E,I,O,U][A,E,I,O,U]%'
GO

SELECT * FROM Marcas
SELECT * FROM Modelos
SELECT * FROM Moviles

--3 INFORME EL NOMBRE DE LAS MARCAS (Marca_MA) que posean móviles dados de baja
 SELECT Ma.Marca_MA [Nombre Marca]
 FROM Modelos Mo INNER JOIN Moviles Mov
 ON Mo.CodModelo_MO = Mov.CODModelo_MO_MV INNER JOIN Marcas Ma
 ON Ma.CodMarca_MA = Mo.CodMarca_MA_MO
 Where Mov.Baja_MV Is NULL
 GO

 --4 Informe la cantidad de móviles, marca y modelo, de cada marca y modelo (agrupados por marca y modelo)

 SELECT COUNT(Mo.Modelo_MO) AS CantidadModelos, COUNT(Ma.Marca_MA) AS CantidadMarcas
 FROM Marcas Ma INNER JOIN Modelos Mo
 ON Ma.CodMarca_MA = Mo.CodMarca_MA_MO INNER JOIN Moviles Mov
 ON Mo.CodModelo_MO = Mov.CODModelo_MO_MV
 Group by Ma.CodMarca_MA, Mo.CodModelo_MO
 GO

 --1B INFORME EL TALLER OFICIAL DE UNA MARCA PARTICULAR
 SELECT Ma.TallerOficial_MA AS [Nombre del Taller]
 FROM Marcas Ma
 WHERE Ma.Marca_MA = 'Toyota'
 GO

 --2b INFORME LOS NOMBRES DE LOS TALLERES OFICIALES CUYAS MARCAS COMIENCEN CON P o una F. 
 --SEGUIDA POR DOS VOCALES Y LUEGO CUALQUIER CADENA DE CARACTERES.
 SELECT Ma.TallerOficial_MA, Ma.Marca_MA
 FROM Marcas Ma
 WHERE Ma.Marca_MA LIKE '[P,F][A,E,I,O,U][A,E,I,O,U]%'
 GO

 --3 INFORME EL NOMBRE DE LAS MARCAS (MARCA_MA) QUE POSEAN MODELOS DADOS DE BAJA
 Select DISTINCT Ma.Marca_MA
 FROM Marcas Ma Inner Join Moviles
ON Ma.CodMarca_MA = Moviles.CodMarca_MA_MP_MV
Where Baja_MV = 1;
go

