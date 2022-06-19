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




CREATE TABLE Proyecto ( 
	idpProyecto INT NOT NULL PRIMARY KEY,
	codigo VARCHAR(30) NOT NULL UNIQUE,
	nombre VARCHAR(60) NOT NULL,
	siglas VARCHAR(10) NOT NULL UNIQUE,
	estado VARCHAR(20) NOT NULL CHECK(estado IN('estudio', 'administracion','post')),
	descripcion TEXT NULL, 
	fechaInicio DATETIME NOT NULL, 
	fechaCierre DATETIME NULL,
	costoCalculado DECIMAL(18,0) NOT NULL CHECK(costoCalculado >= 0),
	costoReal DECIMAL(18,0) NOT NULL CHECK(CostoReal >= 0)
);

drop TRIGGER trigBeforeInsertProyecto;
drop TRIGGER trigBeforeUpdateProyecto;



select * from Proyecto;

update Proyecto set nombre = 'Este es un nombre' where idpProyecto = 2;

INSERT INTO Proyecto VALUES(NEXT VALUE FOR secProyecto, 'P-AAAA-2020-1', 'Sistema Control de Costos', 'SCC', 'administracion', 'Sistema que lleve un control de los costos del area de Recursos Humanos, incluyecto los correspondientes a productos, servicios y empleados', '2020-04-11', '2024-04-11', 3000, 4000);
INSERT INTO Proyecto VALUES(NEXT VALUE FOR secProyecto, 'E-BBBB-2022-1', 'Sistema Gestion de Proyectos', 'SGPTI', 'estudio', NULL, '2022-03-01', NULL, 1000, 2000);
INSERT INTO Proyecto VALUES(NEXT VALUE FOR secProyecto, 'E-CCCC-2021-2', 'Sistema Gestion de Archivos', 'SGAR', 'estudio', NULL, '2019-05-01', NULL, 2000, 6500);



DROP SEQUENCE secRol;
DROP SEQUENCE secUsuario;
DROP SEQUENCE secPermiso;
DROP SEQUENCE secProyecto;
DROP SEQUENCE secArea;
DROP SEQUENCE secArchivo;
DROP SEQUENCE secTarea;
DROP SEQUENCE secRolUsuarioProyecto;
DROP SEQUENCE secTareaArchivoProyecto;
DROP SEQUENCE secRegistroHoraUsuario;

-- Se borran las tablas
DROP TABLE RegistroHoraUsuario;
DROP TABLE RolUsuarioProyecto;
DROP TABLE TareaArchivoProyecto;
DROP TABLE ProyectoArea;
DROP TABLE UsuarioArea;
DROP TABLE Rol;
DROP TABLE Permiso;
DROP TABLE Usuario;
DROP TABLE Proyecto;
DROP TABLE Area;
DROP TABLE Archivo;
DROP TABLE Tarea;