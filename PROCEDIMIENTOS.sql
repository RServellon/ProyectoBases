-- Al correrlo, LAS  TABLAS DEBEN ESTAR VACIAS SIN REGISTROS, CORRER UNO POR UNO MEJOR
-- cuando da error YA NO sigue ejecutando el bloque que se selecciona

-- Faltan datos de prueba de Archivo, Tarea-Archivo-Proyecto y RegistroHoraUsuario 


--Procedimientos INSERT
CREATE PROCEDURE uspInsertPermiso (
@pCrear INT,
@pLeer INT, 
@pBorrar INT,
@pActualizar INT) 
AS
BEGIN
INSERT INTO Permiso(idpPermiso,crear,leer,borrar,actualizar) 
VALUES(NEXT VALUE FOR secPermiso, @pCrear,@pLeer , @pBorrar, @pActualizar);
END;
GO

CREATE PROCEDURE uspInsertRol (
@pCodigo VARCHAR(15), 
@pNombre VARCHAR(30),
@pPermiso INT)
AS
BEGIN
INSERT INTO Rol(idpRol,codigo,nombre,permiso) 
VALUES(NEXT VALUE FOR secRol,@pCodigo ,@pNombre ,@pPermiso);
END;
GO


CREATE PROCEDURE uspInsertUsuario (
@pIdentificacion VARCHAR(10), 
@pNombre VARCHAR(30), 
@pApellido VARCHAR(30), 
@pCorreo VARCHAR(60),
@pTelefono VARCHAR(20),
@pcostoHora DECIMAL(18,0)) 
AS
BEGIN
INSERT INTO Usuario(idpUsuario,identificacion,nombre,apellido,correo,telefono,costoHora) 
VALUES(NEXT VALUE FOR secUsuario,@pIdentificacion ,@pNombre ,@pApellido,@pCorreo,@pTelefono, @pcostoHora);
END;
GO

CREATE PROCEDURE uspInsertProyecto(
@pCodigo VARCHAR(30), 
@pNombre VARCHAR(60), 
@pSiglas VARCHAR(10), 
@pEstado VARCHAR(20),
@pDescripcion TEXT, 
@pfechaInicio DATETIME,
@pfechaCierre DATETIME,
@pCostoCalculado DECIMAL(18,0),
@pCostoReal DECIMAL(18,0)) 
AS
BEGIN
INSERT INTO Proyecto(idpProyecto,codigo,nombre,siglas,estado,descripcion,fechaInicio,fechaCierre,costoCalculado,costoReal)
VALUES(NEXT VALUE FOR secProyecto,@pCodigo ,@pNombre ,@pSiglas,@pEstado,@pDescripcion,@pfechaInicio,@pfechaCierre,@pCostoCalculado,@pCostoReal );
END;
GO

CREATE PROCEDURE uspInsertRolUsuarioProyecto(
@pIdUsuario VARCHAR(15), 
@pIdfRol INT, 
@pidfProyecto INT, 
@pFechaAsignacion DATETIME,
@pFechaDesasignacion DATETIME) 
AS
BEGIN
INSERT INTO RolUsuarioProyecto(idpRolUsuarioProyecto,idUsuario,idfRol,idfProyecto,fechaAsignacion,fechaDesasignacion)
VALUES(NEXT VALUE FOR secRolUsuarioProyecto,@pIdUsuario,@pIdfRol,@pidfProyecto,@pFechaAsignacion,@pFechaDesasignacion);
END;
GO

CREATE PROCEDURE uspInsertTarea(
@pIdfTarea  INT, 
@pNombre VARCHAR(100), 
@pDuracionHora INT,
@pDescripcion TEXT,
@pEstado VARCHAR(15),
@pPrioridad INT,
@pFechaAsignacion DATETIME,
@pFechaCumplimiento DATETIME,
@pCostoCalculado DECIMAL(18,0),
@pCostoReal DECIMAL(18,0)) 
AS
BEGIN
INSERT INTO Tarea(idpTarea,idfTarea,nombre,duracionHora,descripcion,estado,prioridad,fechaAsignacion,fechaCumplimiento,costoCalculado,costoReal)
VALUES(NEXT VALUE FOR secTarea,@pIdfTarea,@pNombre,@pDuracionHora,@pDescripcion,@pEstado,@pPrioridad,@pFechaAsignacion,@pFechaCumplimiento,@pCostoCalculado,@pCostoReal);
END;
GO

CREATE PROCEDURE uspInsertArea (
@pCodigo VARCHAR(30), 
@pNombre VARCHAR(30))
AS
BEGIN
INSERT INTO Area(idpArea,codigo,nombre) 
VALUES(NEXT VALUE FOR secArea ,@pCodigo ,@pNombre);
END;
GO

CREATE PROCEDURE uspInsertProyectoArea (
@pIdfProyecto INT, 
@pIdfArea INT)
AS
BEGIN
INSERT INTO ProyectoArea(idfProyecto,idfArea) 
VALUES(@pIdfProyecto ,@pIdfArea);
END;
GO

CREATE PROCEDURE uspInsertArchivo (
@pCodigo VARCHAR(30), 
@pNombre VARCHAR(50),
@pArchivo VARBINARY(MAX),
@pObservacion TEXT)
AS
BEGIN
INSERT INTO Archivo(idpArchivo,codigo,nombre,archivo,observacion) 
VALUES(NEXT VALUE FOR secArchivo, @pCodigo,@pNombre,@pArchivo,@pObservacion);
END;
GO

CREATE PROCEDURE uspInsertTareaArchivoProyecto (
@pIdfTarea INT, 
@pIdfArchivo INT,
@pidfProyecto INT)
AS
BEGIN
INSERT INTO TareaArchivoProyecto(idpTareaArchivoProyecto,idfTarea,idfArchivo,idfProyecto) 
VALUES(NEXT VALUE FOR secTareaArchivoProyecto,@pIdfTarea ,@pIdfArchivo,@pidfProyecto);
END;
GO

CREATE PROCEDURE uspInsertRegistroHoraUsuario(
@pIdfRolUsuarioProyecto INT, 
@pIdfTareaArchivoProyecto INT,
@pCantidadHoras INT,
@pFechaRegistro DATETIME,
@pObservacion TEXT)
AS
BEGIN
INSERT INTO RegistroHoraUsuario(idpRegistroHoraUsuario,idfRolUsuarioProyecto,idfTareaArchivoProyecto,cantidadHoras,fechaRegistro,observacion) 
VALUES(NEXT VALUE FOR secRegistroHoraUsuario,@pIdfRolUsuarioProyecto ,@pIdfTareaArchivoProyecto,@pCantidadHoras,@pFechaRegistro,@pObservacion);
END;
GO

CREATE PROCEDURE uspInsertUsuarioArea (
@pIidfUsuario VARCHAR(15), 
@pIdfArea INT)
AS
BEGIN
INSERT INTO UsuarioArea(idfUsuario,idfArea) 
VALUES( @pIidfUsuario,@pIdfArea);
END;
GO


-- --------------------Procedimientos Delete
CREATE PROCEDURE uspDeletePermiso(
@pIdpPermiso INT) 
AS
BEGIN
DELETE FROM Permiso 
where idpPermiso= @pIdpPermiso ;
END;
GO

CREATE PROCEDURE uspDeleteRol(
@pIdpRol INT) 
AS
BEGIN
DELETE FROM Rol 
where idpRol= @pIdpRol;
END;
GO

CREATE PROCEDURE uspDeleteUsuario (
@pIdpUsuario INT) 
AS
BEGIN
DELETE FROM Usuario 
where idpUsuario=@pIdpUsuario;
END;
GO

CREATE PROCEDURE uspDeleteProyecto(
@pIdpProyecto INT) 
AS
BEGIN
DELETE FROM  Proyecto
where idpProyecto=@pIdpProyecto;
END;
GO

CREATE PROCEDURE uspDeleteRolUsuarioProyecto(
@pIdpRolUsuarioProyecto INT) 
AS
BEGIN
DELETE FROM  RolUsuarioProyecto
where idpRolUsuarioProyecto=@pIdpRolUsuarioProyecto;
END;
GO

CREATE PROCEDURE uspDeleteTarea(
@pIdpTarea INT) 
AS
BEGIN
DELETE FROM  Tarea
where idpTarea =@pIdpTarea;
END;
GO

CREATE PROCEDURE uspDeleteArea(
@pIdpArea INT) 
AS
BEGIN
DELETE FROM Area 
where  idpArea=@pIdpArea;
END;
GO

CREATE PROCEDURE uspDeleteProyectoArea(
@pDfProyecto INT,
@pDfArea INT) 
AS
BEGIN
DELETE FROM ProyectoArea 
where  idfProyecto=@pDfProyecto AND idfArea=@pDfArea;
END;
GO

CREATE PROCEDURE uspDeleteArchivo(
@pIdpArchivo INT) 
AS
BEGIN
DELETE FROM  Archivo
where idpArchivo =@pIdpArchivo;
END;
GO

CREATE PROCEDURE uspDeleteTareaArchivoProyecto(
@pIdpTareaArchivoProyecto INT) 
AS
BEGIN
DELETE FROM  TareaArchivoProyecto
where  idpTareaArchivoProyecto=@pIdpTareaArchivoProyecto;
END;
GO

CREATE PROCEDURE uspDeleteRegistroHoraUsuario(
@pIdpRegistroHoraUsuario INT) 
AS
BEGIN
DELETE FROM  RegistroHoraUsuario
where  idpRegistroHoraUsuario=@pIdpRegistroHoraUsuario;
END;
GO

CREATE PROCEDURE uspDeleteUsuarioArea(
@pIidfUsuario VARCHAR(15),
@pDfArea INT) 
AS
BEGIN
DELETE FROM UsuarioArea 
where  idfUsuario=@pDfArea AND idfArea=@pDfArea;
END;
GO

-- --------------------Procedimientos Update

CREATE PROCEDURE uspUpdatePermiso (
@pIdpPermiso INT,
@pCrear INT,
@pLeer INT, 
@pBorrar INT,
@pActualizar INT) 
AS
BEGIN
UPDATE Permiso SET crear = @pCrear, leer = @pLeer, borrar = @pBorrar, actualizar = @pActualizar
WHERE idpPermiso = @pIdpPermiso;
END;
GO

CREATE PROCEDURE uspUpdateRol (
@pIdpRol INT,
@pCodigo VARCHAR(15), 
@pNombre VARCHAR(30),
@pPermiso INT)
AS
BEGIN;
UPDATE Rol SET codigo = @pcodigo, nombre = @pNombre, permiso = @pPermiso
WHERE idpRol = @pIdpRol;
END;
GO


CREATE PROCEDURE uspUpdateUsuario (
@pIdpUsuario INT,
@pCorreo VARCHAR(60),
@pTelefono VARCHAR(20),
@pcostoHora DECIMAL(18,0)) 
AS
BEGIN
UPDATE Usuario SET correo=@pCorreo, telefono = @pTelefono, costoHora = @pcostoHora
WHERE idpUsuario = @pIdpUsuario;
END;
GO

CREATE PROCEDURE uspUpdateProyecto(
@pidpProyecto INT,
@pCodigo VARCHAR(30), 
@pNombre VARCHAR(60), 
@pSiglas VARCHAR(10), 
@pEstado VARCHAR(20),
@pDescripcion TEXT, 
@pfechaInicio DATETIME,
@pfechaCierre DATETIME,
@pCostoCalculado DECIMAL(18,0),
@pCostoReal DECIMAL(18,0)) 
AS
BEGIN
UPDATE Proyecto SET codigo = @pCodigo, nombre = @pNombre, siglas =@pSiglas, estado = @pEstado, descripcion = @pDescripcion,
	   fechaInicio = @pfechaInicio, fechaCierre = @pfechaCierre, costoCalculado = @pCostoCalculado, costoReal = @pCostoReal
WHERE idpProyecto = @pidpProyecto;
END;
GO

CREATE PROCEDURE uspUpdateRolUsuarioProyecto(
@pidpRolUsuarioProyecto INT,
@pIdUsuario VARCHAR(15), 
@pIdfRol INT, 
@pidfProyecto INT, 
@pFechaAsignacion DATETIME,
@pFechaDesasignacion DATETIME) 
AS
BEGIN
UPDATE RolUsusarioProyecto SET idUsuario = @pIdUsuario, idRol =@pIdfRol, idfProyecto = @pidfProyecto, 
	   fechaAsignacion = @pFechaAsignacion, fechaDesasignacion =@pFechaDesasignacion
WHERE idRolUsuarioProyecto = @pidpRolUsuarioProyecto;
END;
GO

CREATE PROCEDURE uspUpdateTarea(
@pidpTarea INT,
@pIdfTarea  INT, 
@pNombre VARCHAR(100), 
@pDuracionHora INT,
@pDescripcion TEXT,
@pEstado VARCHAR(15),
@pPrioridad INT,
@pFechaAsignacion DATETIME,
@pFechaCumplimiento DATETIME,
@pCostoCalculado DECIMAL(18,0),
@pCostoReal DECIMAL(18,0)) 
AS
BEGIN
UPDATE Tarea SET idfTarea = @pIdfTarea,nombre = @pNombre, duracionHora = @pDuracionHora,descripcion = @pDescripcion,estado = @pEstado,
	   prioridad = @pPrioridad,fechaAsignacion = @pFechaAsignacion,fechaCumplimiento = @pFechaCumplimiento,costoCalculado = @pCostoCalculado,
	   costoReal = @pCostoReal
WHERE idpTarea = @pidpTarea;
END;
GO

CREATE PROCEDURE uspUpdateArea (
@pidpArea INT,
@pCodigo VARCHAR(30), 
@pNombre VARCHAR(30))
AS
BEGIN
UPDATE Area SET codigo = @pCodigo,nombre = @pNombre 
WHERE idpArea = @pidpArea;
END;
GO

CREATE PROCEDURE uspUpdateProyectoArea (
@pIdfProyecto INT, 
@pIdfArea INT)
AS
BEGIN
UPDATE ProyectoArea SET idfProyecto = @pIdfProyecto,idfArea = @pIdfArea 
WHERE idfProyecto = @pIdfProyecto AND idfArea = @pIdfArea;
END;
GO

CREATE PROCEDURE uspUpdateArchivo (
@pidpArchivo INT,
@pCodigo VARCHAR(30), 
@pNombre VARCHAR(50),
@pArchivo VARBINARY(MAX),
@pObservacion TEXT)
AS
BEGIN
UPDATE Archivo SET codigo = @pCodigo,nombre = @pNombre,archivo = @pArchivo ,observacion = @pObservacion
WHERE idpArchivo = @pidpArchivo;
END;
GO

CREATE PROCEDURE uspUpdateTareaArchivoProyecto (
@pidpTareaArchivoProyecto INT,
@pIdfTarea INT, 
@pIdfArchivo INT,
@pidfProyecto INT)
AS
BEGIN
UPDATE TareaArchivoProyecto SET idfTarea = @pIdfTarea,idfArchivo = @pIdfArchivo,idfProyecto = @pidfProyecto
WHERE idpTareaArchivoProyecto = @pidpTareaArchivoProyecto;
END;
GO

CREATE PROCEDURE uspUpdateRegistroHoraUsuario(
@pIdpRegistroHoraUsuario INT,
@pIdfRolUsuarioProyecto INT, 
@pIdfTareaArchivoProyecto INT,
@pCantidadHoras INT,
@pFechaRegistro DATETIME,
@pObservacion TEXT)
AS
BEGIN
UPDATE RegistrohoraUsuario SET idfRolUsuarioProyecto = @pIdfRolUsuarioProyecto,idfTareaArchivoProyecto = @pIdfTareaArchivoProyecto,
	   cantidadHoras = @pCantidadHoras,fechaRegistro = @pFechaRegistro,observacion=@pObservacion
WHERE idpRegistroHoraUsuario = @pIdpRegistroHoraUsuario;
END;
GO

CREATE PROCEDURE uspUpdateUsuarioArea (
@pIidfUsuario VARCHAR(15), 
@pIdfArea INT)
AS
BEGIN
UPDATE UsuarioArea SET idfUsuario =@pIidfUsuario ,idfArea = @pIdfArea 
WHERE idfUsuario =@pIidfUsuario  AND idfArea = @pIdfArea;
END;
GO













--FORMATO DE FECHA ANTES DEL LOS INSERT
SET DATEFORMAT ymd
DECLARE @dt DATETIME2 = '2016-01-02 12:03:28'
SELECT @dt AS 'date from YMD Format'

-- PRUEBAS DE INSERTAR REGISTROS

EXEC uspInsertPermiso 1,1,1,1;
EXEC uspInsertPermiso 1,0,1,0;
EXEC uspInsertPermiso 0,1,0,1;
SELECT * FROM Permiso;


EXEC uspInsertRol 'Admin', 'Administrador', 1;
EXEC uspInsertRol 'Coor', 'Coordinador', 3;
EXEC uspInsertRol 'Part', 'Participante', 2;
SELECT * FROM Rol;

EXEC uspInsertUsuario '100', 'Pedro', 'Gonzales', 'pedro@gmail.com', 11111111, 20000;
EXEC uspInsertUsuario '101', 'Felipe', 'Campos', 'felipe@gmail.com', 22222222, 20000;
EXEC uspInsertUsuario '102', 'Maria', 'Ramirez', 'maria@gmail.com', 33333333, 20000;
EXEC uspInsertUsuario '103', 'Sara', 'Salas', 'sara@gmail.com', 44444444, 17000;
EXEC uspInsertUsuario '104', 'Daniel', 'Villalobos', 'daniel@gmail.com', 55555555, 17000;
EXEC uspInsertUsuario '105', 'Monica', 'Hernandez', 'monica@gmail.com', 66666666, 10000;
EXEC uspInsertUsuario '106', 'Jose', 'Murillo', 'jose@gmail.com', 77777777, 10000;
SELECT * FROM Usuario;

EXEC uspInsertProyecto 'P-AAAA-2020-1', 'Sistema Control de Costos', 'SCC', 'administracion', 'Sistema que lleve un control de los costos del area de Recursos Humanos, incluyecto los correspondientes a productos, servicios y empleados', '2020-04-11', NULL, 0, 0 ;
EXEC uspInsertProyecto 'E-BBBB-2022-1', 'Sistema Gestion de Proyectos', 'SGPTI', 'estudio', NULL, '2022-03-31', NULL, 0, 0;
EXEC uspInsertProyecto 'E-CCCC-2021-2', 'Sistema Gestion de Archivos', 'SGAR', 'estudio', NULL, '2021-05-30', NULL, 0, 0;
SELECT * FROM Proyecto;

EXEC uspInsertRolUsuarioProyecto '100', 1, 1, '2020-04-11', NULL;
EXEC uspInsertRolUsuarioProyecto '101', 1, 2, '2020-04-11', NULL;
EXEC uspInsertRolUsuarioProyecto '102', 1, 3, '2021-05-30', NULL;
EXEC uspInsertRolUsuarioProyecto '103', 2, 1, '2020-04-11', NULL;
EXEC uspInsertRolUsuarioProyecto '104', 2, 2, '2022-03-31', NULL;
EXEC uspInsertRolUsuarioProyecto '104', 2, 3, '2021-07-03', '2022-01-10';
EXEC uspInsertRolUsuarioProyecto '105', 3, 1, '2021-05-20', '2022-04-15';
EXEC uspInsertRolUsuarioProyecto '106', 3, 1, '2020-05-20', NULL;
EXEC uspInsertRolUsuarioProyecto '106', 3, 2, '2022-09-10', NULL;
SELECT * FROM RolUsuarioProyecto;

EXEC uspInsertTarea  NULL, 'Planeacion', 18, NULL, 'completado', 1,'2022-06-14 00:00:00', NULL, 180000.0, 0.0;
EXEC uspInsertTarea  1, 'Hacer cronograma de trabajo', 6, NULL, 'completado', 1,'2022-06-14 00:00:00', NULL, 60000.0, 0.0 ;
EXEC uspInsertTarea  1, 'Oficio de inicio', 5, NULL, 'sin iniciar', 1,'2022-06-14 00:00:00', NULL, 50000.0, 0.0;
EXEC uspInsertTarea  1, 'Organizacion del equipo de trabajo', 7, NULL, 'completado', 2,'2022-06-14 00:00:00', NULL, 70000.0, 0.0;
EXEC uspInsertTarea  3, 'Analisis de recursos tecnicos', 5, NULL, 'completado', 1,'2022-06-14 00:00:00', NULL, 50000.0, 0.0;
SELECT * FROM TAREA;

EXEC uspInsertArea 'PTE', 'Proyectos Tecnologicos';
EXEC uspInsertArea 'RRHH', 'Recursos Humanos';
SELECT * FROM Area;

EXEC uspInsertProyectoArea 1, 2;
EXEC uspInsertProyectoArea 2, 1;
EXEC uspInsertProyectoArea 3, 2;
SELECT * FROM ProyectoArea;

EXEC uspInsertArchivo 

--PRUEBAS  DE PROCEDIMIENTOS DELETE

EXEC uspDeletePermiso 3;

EXEC uspDeleteRol 3;

EXEC uspDeleteUsuario 3;

EXEC uspDeleteProyecto 3;

EXEC uspDeleteRolUsuarioProyecto 3;

EXEC uspDeleteTarea 5;

EXEC uspDeleteArea 2;

EXEC uspDeleteProyectoArea 2,1;

--PRUEBAS  DE PROCEDIMIENTOS UPDATE
SELECT * FROM Permiso;
EXEC uspUpdatePermiso 3,0,0,0,0;
SELECT * FROM Permiso;

SELECT * FROM Rol;
EXEC uspUpdateRol 2,'Cola', 'Colaborador', 1;
SELECT * FROM Rol;

SELECT * FROM Usuario;
EXEC uspUpdateUsuario '5', 'danielv@gmail.com',50505050,50000;
SELECT * FROM Usuario;

SELECT * FROM Proyecto;
EXEC uspUpdateProyecto 2,'E-DDD-2021-2', 'Sistema Gestion de Recursos', 'SGRE', 'estudio', NULL, '2021-05-30', NULL, 0, 0;
SELECT * FROM Proyecto;

SELECT * FROM RolUsuarioProyecto;
EXEC uspUpdateRolUsuarioProyecto 3,'103', 2, 1,  '2021-05-20', '2022-04-15';
SELECT * FROM RolUsuarioProyecto;

SELECT * FROM TAREA;
EXEC uspUpdateTarea 4,2,'Evaluacion', 8, NULL, 'sin iniciar', 1,'2022-06-14 00:00:00', NULL, 70000.0, 0.0;
SELECT * FROM TAREA;

SELECT * FROM Area;
EXEC uspUpdateArea 1,'PTEI', 'Proyectos Tecnologicos Innovadore';
SELECT * FROM Area;




--Dropear Prodedimientos
--Para Pruebas 
DROP PROCEDURE uspInsertPermiso;
DROP PROCEDURE uspInsertRol;
DROP PROCEDURE uspInsertUsuario;
DROP PROCEDURE uspInsertProyecto;
DROP PROCEDURE uspInsertRolUsuarioProyecto;
DROP PROCEDURE uspInsertTarea;
DROP PROCEDURE uspInsertArea;
DROP PROCEDURE uspInsertProyectoArea;
DROP PROCEDURE uspInsertArchivo;
DROP PROCEDURE uspInsertTareaArchivoProyecto;
DROP PROCEDURE uspInsertRegistroHoraUsuario;
DROP PROCEDURE uspInsertUsuarioArea;

DROP PROCEDURE uspDeletePermiso;
DROP PROCEDURE uspDeleteRol;
DROP PROCEDURE uspDeleteUsuario;
DROP PROCEDURE uspDeleteProyecto;
DROP PROCEDURE uspDeleteRolUsuarioProyecto;
DROP PROCEDURE uspDeleteTarea;
DROP PROCEDURE uspDeleteArea;
DROP PROCEDURE uspDeleteProyectoArea;
DROP PROCEDURE uspDeleteArchivo;
DROP PROCEDURE uspDeleteTareaArchivoProyecto;
DROP PROCEDURE uspDeleteRegistroHoraUsuario;
DROP PROCEDURE uspDeleteUsuarioArea;

DROP PROCEDURE uspUpdatePermiso;
DROP PROCEDURE uspUpdateRol;
DROP PROCEDURE uspUpdateUsuario;
DROP PROCEDURE uspUpdateProyecto;
DROP PROCEDURE uspUpdateRolUsuarioProyecto;
DROP PROCEDURE uspUpdateTarea;
DROP PROCEDURE uspUpdateArea;
DROP PROCEDURE uspUpdateProyectoArea;
DROP PROCEDURE uspUpdateArchivo;
DROP PROCEDURE uspUpdateTareaArchivoProyecto;
DROP PROCEDURE uspUpdateRegistroHoraUsuario;
DROP PROCEDURE uspUpdateUsuarioArea;