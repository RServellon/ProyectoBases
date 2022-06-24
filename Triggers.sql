--Triggers


--escalas de level
--0–10 Informational messages
--11–18 Errors
--19–25 Fatal errors



/*

TRIGGER trigBeforeInsertProyecto

1) Validar cuando se agrega un proyecto la fecha de inicio sea menor o igual al día actual, 
	para evitar registren proyectos a futuro que puede y no sean concretados y permitir registrar
	proyectos que se hayan iniciado anteriormente.

2) Validar que cuando se cumple un proyecto la fecha de cumplimiento sea mayor al día actual, 
	para evitar que se registre un proyecto como cerrado en una fecha anterior a la fecha actual 
	del sistema y se permita poner una fecha de cierre programada, de esta manera la fecha de inicio 
	del proyecto será siempre menor a la fecha de cierre.

*/


GO
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

/*

TRIGGER trigBeforeUpdateProyecto

1) Al momento de hacer un update, la fechaInicio no puede ser modificada, para mantener un 
	control en el registro de fechas y evitar incongruencias con las fechas.

2) La fecha de cierre puede ser modificada, por el proyecto se termina antes de lo esperado o se retraza,
	pero todo esto solo puede pasar si la fecha de cierre es mayor a la fecha actual, para evitar que la 
	fecha de cierre sea antes de la fecha de inicio.
*/
GO
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
/*
TRIGGER trigBeforeInsertRegistroHoraUsuario
1) Al registrar las horas de un usuario en la tabla RegistroHoraUsuario  la fechaRegistro 
	de dicha tabla debe estar entre la fechaInicio  y la  fechaCierre del respectivo proyecto

2) Validar que ese usuario y la tarea pertenezcan al mismo proyecto, para evitar tener horas registradas
	de usuarios que no pertenecen a un proyecto concreto.
*/
GO
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

-- Prueba de Trigger Before Insert Registro Hora Usuario
-- @pIdUsuario VARCHAR(15),
-- @pIdfRol INT,
-- @pidfProyecto INT,
-- @pFechaAsignacion DATETIME,
-- @pFechaDesasignacion DATETIME)
EXEC uspInsertRolUsuarioProyecto '102', 1, 3, '2021-05-30', NULL;
EXEC uspUpdateRolUsuarioProyecto 3,'103', 2, 1, '2021-05-20', '2022-04-15';
SELECT * FROM RolUsuarioProyecto;

-- Prueba de Trigger Before Insert Registro Hora Usuario
-- @pIdfTarea INT,
-- @pIdfArchivo INT,
-- @pidfProyecto INT)
-- Numero de secuencia: 5
EXEC uspInsertTareaArchivoProyecto 4, NULL, 3;
SELECT * FROM TareaArchivoProyecto;


-- Prueba de Trigger Before Insert Registro Hora Usuario
-- Prueba de Trigger Before Insert Registro Hora Usuario-- @pIdfRolUsuarioProyecto INT,
-- @pIdfTareaArchivoProyecto INT,
-- @pCantidadHoras INT,
-- @pObservacion TEXT)
-- EXEC uspInsertRolUsuarioProyecto '102', 1, 3, '2021-05-30', NULL;
EXEC uspInsertRegistroHoraUsuario 3, 5, 3, 'Corregir lista de correos';


