--Triggers


--escalas de level
--0–10 Informational messages
--11–18 Errors
--19–25 Fatal errors

--parametros del RAISERROR
--RAISERROR ( 'msg',level,state)
--Listo
CREATE OR ALTER TRIGGER trigBeforeInsertProyecto
	ON dbo.Proyecto INSTEAD OF INSERT AS BEGIN
	
	DECLARE @fechaInicio DATETIME, @fechaCierre  DATETIME
	SELECT @fechaInicio = fechaInicio FROM INSERTED
	SELECT @fechaCierre = fechaCierre FROM INSERTED

	IF    @fechaInicio > SYSDATETIME ()
		RAISERROR ( 'la fecha de inicio del proyecto debe ser menor o igual al dia actual',11,1);
	ELSE IF SYSDATETIME ()  >= @fechaCierre 
		RAISERROR ( 'la fecha de cierre del proyecto debe ser mayor al dia actual',11,1);
	ELSE 
		INSERT INTO Proyecto 
		SELECT * FROM INSERTED;
END

--Listo
CREATE OR ALTER TRIGGER trigBeforeUpdateProyecto
	ON dbo.Proyecto INSTEAD OF UPDATE AS BEGIN
	DECLARE @fechaInicioOLD DATETIME, @fechaInicioNEW  DATETIME, @fechaCierre DATETIME
	SELECT @fechaInicioOLD = fechaInicio FROM DELETED 
	SELECT @fechaInicioNEW = fechaInicio FROM INSERTED
	SELECT @fechaCierre = fechaCierre FROM INSERTED
	
	IF @fechaInicioOLD != @fechaInicioNEW
		RAISERROR ( 'No se puede modificar la fecha de inicio',11,1);
	ELSE IF SYSDATETIME ()  >= @fechaCierre 
		RAISERROR ( 'la fecha de cierre del proyecto debe ser mayor al dia actual',11,1);
	ELSE 
		UPDATE Proyecto SET Proyecto.codigo  = INSERTED.codigo , Proyecto.nombre  = INSERTED.nombre, 
			Proyecto.siglas   = INSERTED.siglas,  Proyecto.estado    = INSERTED.estado, 
			Proyecto.descripcion   = INSERTED.descripcion, Proyecto.fechaCierre   = INSERTED.fechaCierre, 
			Proyecto.costoCalculado    = INSERTED.costoCalculado, Proyecto.costoReal    = INSERTED.costoReal
			from INSERTED;
END

--Listo
CREATE OR ALTER TRIGGER trigBeforeInsertRegistroHoraUsuario
	ON dbo.RegistroHoraUsuario INSTEAD OF INSERT AS BEGIN
	
	DECLARE @idfRolUsuarioProyecto  INT, @idfTareaArchivoProyecto INT, @fechaRegistro DATETIME, 
	@idpProyecto int, @idpProyectoFromUser int ,  @idUsuario VARCHAR(15), @fechaInicio DATETIME, @fechaCierre DATETIME, @msg varchar(10)

	

	SELECT @idfRolUsuarioProyecto = idfRolUsuarioProyecto FROM INSERTED
	SELECT @idfTareaArchivoProyecto = idfTareaArchivoProyecto FROM INSERTED
	SELECT @fechaRegistro = fechaRegistro FROM INSERTED

	SELECT @idpProyecto = idfProyecto FROM TareaArchivoProyecto where idpTareaArchivoProyecto = @idfTareaArchivoProyecto;
	SELECT @idpProyectoFromUser = idfProyecto FROM RolUsuarioProyecto where idpRolUsuarioProyecto = @idfRolUsuarioProyecto;

	SELECT @fechaInicio = fechaInicio FROM Proyecto where idpProyecto = @idpProyectoFromUser;
	SELECT @fechaCierre = fechaCierre FROM Proyecto where idpProyecto = @idpProyectoFromUser;

	IF    @idpProyecto != @idpProyectoFromUser
		RAISERROR ( 'Este usuario no pertenece a el proyecto registrado',11,1);
	ELSE IF @fechaRegistro NOT BETWEEN @fechaInicio AND @fechaCierre
		RAISERROR ( 'La fecha de registro debe encajar en el rango del proyecto',11,1);
	ELSE 
		INSERT INTO RegistroHoraUsuario 
		SELECT * FROM INSERTED;
END



