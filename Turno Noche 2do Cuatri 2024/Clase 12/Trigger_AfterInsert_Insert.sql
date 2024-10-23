-- Al agregar un cliente nuevo se agregue tambien una caja de ahorro con saldo $0 y fecha de apertura con fecha
--y hora actual.

--Necesitamos que pase 2 cosas, la accion y consecuencia a esa accion, generar la cuenta adicional

CREATE OR ALTER TRIGGER TR_NuevoCliente ON Clientes
AFTER Insert --After porque quiero generar siempre, "Luego de crear el cliente, el cliente se crea siempre"
AS 
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			
			--1ra forma de hacerlo
			--insert into Cuentas(IDCliente,IDTipoCuenta,FechaApertura,LimiteDescubierto,Saldo)
			--Select IDCliente, 'CA', getdate(),0,0 from inserted

			--2da forma
			 Declare @IDCliente int
			 SET @IDCliente = (Select IDCliente from inserted)
			 insert into Cuentas(IDCliente,IDTipoCuenta,FechaApertura,LimiteDescubierto,Saldo)
			 Select IDCliente, 'CA', getdate(),0,0 from inserted
			--insert into Cuentas(IDCliente,IDTipoCuenta,FechaApertura,LimiteDescubierto,Saldo)
			--Values (@IDCliente, 'CA', GETDATE(),0,0)

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
	END CATCH
END

--creamos cliente

Insert into Clientes(IDCliente, Apellidos, Nombres, Estado)
Values (5000, 'Revollo', 'Maria',1)

SELECT * FROM Clientes

Select * from Cuentas

--Si el nombre es Analia le creamos una CC con límite descubierto y sino una CA
CREATE OR ALTER TRIGGER TR_NuevoClienteAnalia ON Clientes
AFTER Insert --After porque quiero generar siempre, "Luego de crear el cliente, el cliente se crea siempre"
AS 
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			
			--1ra forma de hacerlo
			--insert into Cuentas(IDCliente,IDTipoCuenta,FechaApertura,LimiteDescubierto,Saldo)
			--Select IDCliente, 'CA', getdate(),0,0 from inserted

			--2da forma
			 Declare @IDCliente int, @Nombres varchar(50), @TipoCuenta As char(2), @Limite money
			 --Asignamos
			 SET @IDCliente = (Select IDCliente from inserted)
			 SET @Nombres = (Select Nombres from inserted)
			 SET @TipoCuenta = 'CA'
			 SET @Limite = 0

			 IF @Nombres = 'Analia' begin
				SET @TipoCuenta = 'CC'
				SET @Limite = 1000000
			 end
			 ELSE Begin
				SET @TipoCuenta = 'CA'
				SET @Limite = 0
			END

			--Se puede asignar tambien de esta forma= 
			--SELECT @IDCliente= IDCliente, @Nombres = Nombres From inserted

			 insert into Cuentas(IDCliente,IDTipoCuenta,FechaApertura,LimiteDescubierto,Saldo)
			 Select IDCliente, @TipoCuenta, getdate(),@Limite,0 from inserted

			--insert into Cuentas(IDCliente,IDTipoCuenta,FechaApertura,LimiteDescubierto,Saldo)
			--Values (@IDCliente, 'CA', GETDATE(),0,0)
			IF @@TRANCOUNT > 0 Begin
			COMMIT TRANSACTION
			END
	END TRY
	BEGIN CATCH
		 IF @@TRANCOUNT > 0 Begin
		ROLLBACK TRANSACTION
		END
	END CATCH
END

