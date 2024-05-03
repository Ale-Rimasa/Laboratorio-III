USE Tp1
GO

--1.1. Realizar una consulta que informe todos los profesores de la institución.
Select * FROM Profesores
Go

--1.2. Realizar una consulta que informe el DNI del alumno y su nombre.
Select Dni_ES, Nombre_ES FROM Estudiantes
Go

--1.3. Realizar una consulta que informe el nombre de un determinado legajo docente y ciudad.
SELECT Nombre_PR FROM Profesores WHERE Legajo_PR ='698' OR Ciudad_PR= 'Benavidez'