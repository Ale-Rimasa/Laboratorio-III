--Prueba de Try y Catch

Begin try
	INSERT INTO Clientes (IDCliente,Apellidos,Nombres,Estado) Values
		(1,'Angel','Excepcion',1)
END TRY

BEGIN CATCH
	Print 'Hubo un error en el insert'
	RAISERROR('Hubo un problema al insertar el cliente',16,1)
END CATCH