--Realizar un trigger usando deleted, de un movimiento en particular que no lo borre y
--que muestre el movimiento que se pretendio borrar
--Cuando se intente borrar un movimiento, no borrarlo y seleccionarlo en su lugar
CREATE OR ALTER TRIGGER TR_BajaMovimiento ON Movimientos
INSTEAD OF DELETE 
AS
BEGIN
	SELECT * FROM deleted --Selecciona el registro que se prendía eliminar
	-- ProQue pasa si hacemos dentro del trigger un delete?? a cualquier movimiento selecionado
	delete from Movimientos WHERE IDMovimiento = (Select IDMovimiento from deleted)
	--Si ejecuto esto puede que se haga un ciclo infinito, pero si se trata de un trigger de tipo instead ACA ESTO SI SE VA A BORRAR.
END

SELECT * FROM Movimientos

delete from Movimientos Where IDMovimiento = 8

-- De esta forma no puedo borrar los datos de la tabla movimiendo.
--El Trigger evita que se pueda hacer un delete en la tabla, lo que hace es una selección