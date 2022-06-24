-- Se configura el formato de la fecha
SET DATEFORMAT ymd
DECLARE @dt DATETIME2 = '2016-01-02 12:03:28'
SELECT @dt AS 'date from YMD Format'

-- Se borran las secuencias
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

-- Se crean las secuencias
CREATE SEQUENCE secRol 
	AS INT
	START WITH 1 
	INCREMENT BY 1;
CREATE SEQUENCE secUsuario 
	AS INT
	START WITH 1 
	INCREMENT BY 1;
CREATE SEQUENCE secPermiso 
	AS INT
	START WITH 1 
	INCREMENT BY 1;
CREATE SEQUENCE secProyecto 
	AS INT
	START WITH 1 
	INCREMENT BY 1;
CREATE SEQUENCE secArea
    AS INT
	START WITH 1 
	INCREMENT BY 1;
CREATE SEQUENCE secArchivo
    AS INT
	START WITH 1 
	INCREMENT BY 1;
CREATE SEQUENCE secTarea
    AS INT
	START WITH 1 
	INCREMENT BY 1;
CREATE SEQUENCE secRolUsuarioProyecto
    AS INT
	START WITH 1 
	INCREMENT BY 1;
CREATE SEQUENCE secTareaArchivoProyecto
    AS INT
	START WITH 1 
	INCREMENT BY 1;
CREATE SEQUENCE secRegistroHoraUsuario
    AS INT
	START WITH 1 
	INCREMENT BY 1;

-- Se crean las tablas
CREATE TABLE Permiso (
	idpPermiso INT NOT NULL PRIMARY KEY,
	crear INT NOT NULL  CHECK(crear = 1 OR crear = 0),
	leer INT NOT NULL  CHECK(leer = 1 OR leer = 0),
	borrar INT NOT NULL  CHECK(borrar = 1 OR borrar = 0),
	actualizar INT NOT NULL  CHECK(actualizar = 1 OR actualizar = 0)
)

CREATE TABLE Rol (
	idpRol INT NOT NULL PRIMARY KEY, 
	codigo VARCHAR(10) NOT NULL UNIQUE, 
	nombre VARCHAR(30) NOT NULL UNIQUE,
	permiso INT NOT NULL FOREIGN KEY REFERENCES Permiso(idpPermiso) ON DELETE CASCADE
);

CREATE TABLE Usuario (
	idpUsuario INT NOT NULL PRIMARY KEY, 
	identificacion VARCHAR(15) NOT NULL UNIQUE, 
	nombre VARCHAR(30) NOT NULL, 
	apellido VARCHAR(30) NOT NULL, 
	correo VARCHAR(60) NOT NULL UNIQUE, 
	telefono VARCHAR(20) NULL UNIQUE,
	costoHora DECIMAL(18,0) NOT NULL CHECK(costoHora >= 0)
);

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

CREATE TABLE RolUsuarioProyecto (
	idpRolUsuarioProyecto INT NOT NULL PRIMARY KEY,
	idUsuario VARCHAR(15) NOT NULL FOREIGN KEY REFERENCES Usuario(identificacion) ON DELETE CASCADE,
	idfRol INT NOT NULL FOREIGN KEY REFERENCES Rol(idpRol) ON DELETE CASCADE, 
	idfProyecto INT NOT NULL FOREIGN KEY REFERENCES Proyecto(idpProyecto) ON DELETE CASCADE, 
	fechaAsignacion DATETIME NOT NULL, 
	fechaDesasignacion DATETIME NULL
);

CREATE TABLE Tarea (
	idpTarea INT NOT NULL PRIMARY KEY, 
	idfTarea INT NULL FOREIGN KEY REFERENCES Tarea(idpTarea) ON DELETE NO ACTION,
	nombre VARCHAR(100) NOT NULL, 
	duracionHora INT NOT NULL CHECK(duracionHora > 0),
	descripcion TEXT NULL, 
	estado VARCHAR(15) NOT NULL CHECK(estado in('completado','en proceso','sin iniciar')), 
	prioridad INT NOT NULL CHECK(prioridad BETWEEN 1 AND 3), 
	fechaAsignacion DATETIME NOT NULL,
	fechaCumplimiento DATETIME NULL, 
	costoCalculado DECIMAL(18,0) NOT NULL CHECK(costoCalculado >= 0), 
	costoReal DECIMAL(18,0) NOT NULL CHECK(costoReal >= 0)
);

CREATE TABLE Area (
	idpArea INT NOT NULL PRIMARY KEY,
	codigo VARCHAR(30) NOT NULL UNIQUE,
	nombre VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE UsuarioArea (
	idfUsuario VARCHAR(15) NOT NULL FOREIGN KEY REFERENCES Usuario(identificacion) ON DELETE CASCADE, 
	idfArea INT NOT NULL FOREIGN KEY REFERENCES Area(idpArea) ON DELETE CASCADE,
	CONSTRAINT idpUsuarioArea PRIMARY KEY(idfUsuario, idfArea)
);

CREATE TABLE ProyectoArea (
	idfProyecto INT NOT NULL FOREIGN KEY REFERENCES Proyecto(idpProyecto) ON DELETE CASCADE, 
	idfArea INT NOT NULL FOREIGN KEY REFERENCES Area(idpArea) ON DELETE CASCADE,
	CONSTRAINT idpProyectoArea PRIMARY KEY(idfProyecto, idfArea)
);

CREATE TABLE Archivo ( 
	idpArchivo INT NOT NULL PRIMARY KEY, 
	codigo VARCHAR(30) NOT NULL UNIQUE, 
	nombre VARCHAR(50) NOT NULL, 
	archivo VARBINARY(MAX) NOT NULL, 
	observacion TEXT NULL
);

CREATE TABLE TareaArchivoProyecto (
	idpTareaArchivoProyecto INT NOT NULL PRIMARY KEY, 
	idfTarea INT NULL FOREIGN KEY REFERENCES Tarea(idpTarea) ON DELETE CASCADE,
	idfArchivo INT NULL FOREIGN KEY REFERENCES Archivo(idpArchivo) ON DELETE CASCADE,
	idfProyecto INT NOT NULL FOREIGN KEY REFERENCES Proyecto(idpProyecto) ON DELETE CASCADE
);

CREATE TABLE RegistroHoraUsuario (
	idpRegistroHoraUsuario INT NOT NULL PRIMARY KEY, 
	idfRolUsuarioProyecto INT NOT NULL FOREIGN KEY REFERENCES RolUsuarioProyecto(idpRolUsuarioProyecto) ON DELETE NO ACTION,
	idfTareaArchivoProyecto INT NOT NULL FOREIGN KEY REFERENCES TareaArchivoProyecto(idpTareaArchivoProyecto) ON DELETE NO ACTION,
	cantidadHoras INT NOT NULL CHECK(cantidadHoras BETWEEN 1 AND 40),
	fechaRegistro DATETIME NOT NULL,
	observacion TEXT NULL
);

-- Se crean los procedimientos INSERT para cada tabla
GO
CREATE OR ALTER PROCEDURE uspInsertPermiso (
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

CREATE OR ALTER PROCEDURE uspInsertRol (
@pCodigo VARCHAR(15), 
@pNombre VARCHAR(30),
@pPermiso INT)
AS
BEGIN
INSERT INTO Rol(idpRol,codigo,nombre,permiso) 
VALUES(NEXT VALUE FOR secRol,@pCodigo ,@pNombre ,@pPermiso);
END;
GO


CREATE OR ALTER PROCEDURE uspInsertUsuario (
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

CREATE OR ALTER PROCEDURE uspInsertProyecto(
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

CREATE OR ALTER PROCEDURE uspInsertRolUsuarioProyecto(
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

CREATE OR ALTER PROCEDURE uspInsertTarea(
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

CREATE OR ALTER PROCEDURE uspInsertArea (
@pCodigo VARCHAR(30), 
@pNombre VARCHAR(30))
AS
BEGIN
INSERT INTO Area(idpArea,codigo,nombre) 
VALUES(NEXT VALUE FOR secArea ,@pCodigo ,@pNombre);
END;
GO

CREATE OR ALTER PROCEDURE uspInsertProyectoArea (
@pIdfProyecto INT, 
@pIdfArea INT)
AS
BEGIN
INSERT INTO ProyectoArea(idfProyecto,idfArea) 
VALUES(@pIdfProyecto ,@pIdfArea);
END;
GO

CREATE OR ALTER PROCEDURE uspInsertUsuarioArea (
@pIidfUsuario VARCHAR(15), 
@pIdfArea INT)
AS
BEGIN
INSERT INTO UsuarioArea(idfUsuario,idfArea) 
VALUES( @pIidfUsuario,@pIdfArea);
END;
GO

CREATE OR ALTER PROCEDURE uspInsertArchivo (
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

CREATE OR ALTER PROCEDURE uspInsertTareaArchivoProyecto (
@pIdfTarea INT, 
@pIdfArchivo INT,
@pidfProyecto INT)
AS
BEGIN
INSERT INTO TareaArchivoProyecto(idpTareaArchivoProyecto,idfTarea,idfArchivo,idfProyecto) 
VALUES(NEXT VALUE FOR secTareaArchivoProyecto,@pIdfTarea ,@pIdfArchivo,@pidfProyecto);
END;
GO

CREATE OR ALTER PROCEDURE uspInsertRegistroHoraUsuario(
@pIdfRolUsuarioProyecto INT, 
@pIdfTareaArchivoProyecto INT,
@pCantidadHoras INT,
@pObservacion TEXT)
AS
BEGIN
INSERT INTO RegistroHoraUsuario(idpRegistroHoraUsuario,idfRolUsuarioProyecto,idfTareaArchivoProyecto,cantidadHoras,fechaRegistro,observacion) 
VALUES(NEXT VALUE FOR secRegistroHoraUsuario,@pIdfRolUsuarioProyecto ,@pIdfTareaArchivoProyecto,@pCantidadHoras, GETDATE(), @pObservacion);
END;
GO

-- Se crean los procedimientos UPDATE para cada tabla
CREATE OR ALTER PROCEDURE uspUpdatePermiso (
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

CREATE OR ALTER PROCEDURE uspUpdateRol (
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


CREATE OR ALTER PROCEDURE uspUpdateUsuario (
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

CREATE OR ALTER PROCEDURE uspUpdateProyecto(
@pidpProyecto INT,
@pCodigo VARCHAR(30), 
@pNombre VARCHAR(60), 
@pSiglas VARCHAR(10), 
@pEstado VARCHAR(20),
@pDescripcion TEXT, 
@pfechaInicio DATETIME,
@pCostoCalculado DECIMAL(18,0),
@pCostoReal DECIMAL(18,0)) 
AS
BEGIN
UPDATE Proyecto SET codigo = @pCodigo, nombre = @pNombre, siglas =@pSiglas, estado = @pEstado, descripcion = @pDescripcion,
	   fechaInicio = @pfechaInicio, costoCalculado = @pCostoCalculado, costoReal = @pCostoReal
WHERE idpProyecto = @pidpProyecto;
END;
GO

CREATE OR ALTER PROCEDURE uspUpdateRolUsuarioProyecto(
@pidpRolUsuarioProyecto INT,
@pIdUsuario VARCHAR(15), 
@pIdfRol INT, 
@pidfProyecto INT, 
@pFechaAsignacion DATETIME,
@pFechaDesasignacion DATETIME) 
AS
BEGIN
UPDATE RolUsuarioProyecto SET idUsuario = @pIdUsuario, idfRol = @pIdfRol, idfProyecto = @pidfProyecto, 
	   fechaAsignacion = @pFechaAsignacion, fechaDesasignacion = @pFechaDesasignacion
WHERE idpRolUsuarioProyecto = @pidpRolUsuarioProyecto;
END;
GO

CREATE OR ALTER PROCEDURE uspUpdateTarea(
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

CREATE OR ALTER PROCEDURE uspUpdateArea (
@pidpArea INT,
@pCodigo VARCHAR(30), 
@pNombre VARCHAR(30))
AS
BEGIN
UPDATE Area SET codigo = @pCodigo,nombre = @pNombre 
WHERE idpArea = @pidpArea;
END;
GO

CREATE OR ALTER PROCEDURE uspUpdateProyectoArea (
@pIdfProyecto INT, 
@pIdfArea INT)
AS
BEGIN
UPDATE ProyectoArea SET idfProyecto = @pIdfProyecto,idfArea = @pIdfArea 
WHERE idfProyecto = @pIdfProyecto AND idfArea = @pIdfArea;
END;
GO

CREATE OR ALTER PROCEDURE uspDeleteUsuarioArea(
@pIidfUsuario VARCHAR(15),
@pDfArea INT) 
AS
BEGIN
DELETE FROM UsuarioArea 
WHERE  idfUsuario=@pDfArea AND idfArea=@pDfArea;
END;
GO

CREATE OR ALTER PROCEDURE uspUpdateUsuarioArea (
@pIidfUsuario VARCHAR(15), 
@pIdfArea INT)
AS
BEGIN
UPDATE UsuarioArea SET idfUsuario =@pIidfUsuario ,idfArea = @pIdfArea 
WHERE idfUsuario =@pIidfUsuario  AND idfArea = @pIdfArea;
END;
GO

CREATE OR ALTER PROCEDURE uspUpdateArchivo (
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

CREATE OR ALTER PROCEDURE uspUpdateTareaArchivoProyecto (
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

CREATE OR ALTER PROCEDURE uspUpdateRegistroHoraUsuario(
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

-- Se crean los procedimientos DELETE para cada tabla
CREATE OR ALTER PROCEDURE uspDeletePermiso(
@pIdpPermiso INT) 
AS
BEGIN
DELETE FROM Permiso 
WHERE idpPermiso= @pIdpPermiso ;
END;
GO

CREATE OR ALTER PROCEDURE uspDeleteRol(
@pIdpRol INT) 
AS
BEGIN
DELETE FROM Rol 
WHERE idpRol= @pIdpRol;
END;
GO

CREATE OR ALTER PROCEDURE uspDeleteUsuario (
@pIdpUsuario INT) 
AS
BEGIN
DELETE FROM Usuario 
WHERE idpUsuario=@pIdpUsuario;
END;
GO

CREATE OR ALTER PROCEDURE uspDeleteProyecto(
@pIdpProyecto INT) 
AS
BEGIN
DELETE FROM  Proyecto
WHERE idpProyecto=@pIdpProyecto;
END;
GO

CREATE OR ALTER PROCEDURE uspDeleteRolUsuarioProyecto(
@pIdpRolUsuarioProyecto INT) 
AS
BEGIN
DELETE FROM  RolUsuarioProyecto
WHERE idpRolUsuarioProyecto=@pIdpRolUsuarioProyecto;
END;
GO

CREATE OR ALTER PROCEDURE uspDeleteTarea(
@pIdpTarea INT) 
AS
BEGIN
DELETE FROM  Tarea
WHERE idpTarea =@pIdpTarea;
END;
GO

CREATE OR ALTER PROCEDURE uspDeleteArea(
@pIdpArea INT) 
AS
BEGIN
DELETE FROM Area 
WHERE  idpArea=@pIdpArea;
END;
GO

CREATE OR ALTER PROCEDURE uspDeleteProyectoArea(
@pDfProyecto INT,
@pDfArea INT) 
AS
BEGIN
DELETE FROM ProyectoArea 
WHERE  idfProyecto=@pDfProyecto AND idfArea=@pDfArea;
END;
GO

CREATE OR ALTER PROCEDURE uspDeleteArchivo(
@pIdpArchivo INT) 
AS
BEGIN
DELETE FROM  Archivo
WHERE idpArchivo =@pIdpArchivo;
END;
GO

CREATE OR ALTER PROCEDURE uspDeleteTareaArchivoProyecto(
@pIdpTareaArchivoProyecto INT) 
AS
BEGIN
DELETE FROM  TareaArchivoProyecto
WHERE  idpTareaArchivoProyecto=@pIdpTareaArchivoProyecto;
END;
GO

CREATE OR ALTER PROCEDURE uspDeleteRegistroHoraUsuario(
@pIdpRegistroHoraUsuario INT) 
AS
BEGIN
DELETE FROM  RegistroHoraUsuario
WHERE  idpRegistroHoraUsuario=@pIdpRegistroHoraUsuario;
END;
GO

CREATE OR ALTER PROCEDURE uspDeleteUsuarioArea(
@pIidfUsuario VARCHAR(15),
@pDfArea INT) 
AS
BEGIN
DELETE FROM UsuarioArea 
WHERE  idfUsuario=@pDfArea AND idfArea=@pDfArea;
END;
GO

-- Pruebas de los procedimientos INSERT
EXEC uspInsertPermiso 1,1,1,1;
EXEC uspInsertPermiso 1,0,1,0;
EXEC uspInsertPermiso 0,1,0,1;
EXEC uspInsertPermiso 0,1,0,0;
SELECT * FROM Permiso;

EXEC uspInsertRol 'Admin', 'Administrador', 1;
EXEC uspInsertRol 'Coor', 'Coordinador', 3;
EXEC uspInsertRol 'Part', 'Participante', 2;
EXEC uspInsertRol 'LTecnico', 'Lider tecnico', 2;
SELECT * FROM Rol;

EXEC uspInsertUsuario '100', 'Pedro', 'Gonzales', 'pedro@gmail.com', 11111111, 20000;
EXEC uspInsertUsuario '101', 'Felipe', 'Campos', 'felipe@gmail.com', 22222222, 20000;
EXEC uspInsertUsuario '102', 'Maria', 'Ramirez', 'maria@gmail.com', 33333333, 20000;
EXEC uspInsertUsuario '103', 'Sara', 'Salas', 'sara@gmail.com', 44444444, 17000;
EXEC uspInsertUsuario '104', 'Daniel', 'Villalobos', 'daniel@gmail.com', 55555555, 17000;
EXEC uspInsertUsuario '105', 'Monica', 'Hernandez', 'monica@gmail.com', 66666666, 10000;
EXEC uspInsertUsuario '106', 'Jose', 'Murillo', 'jose@gmail.com', 77777777, 10000;
EXEC uspInsertUsuario '107', 'David', 'Herrera', 'david@gmail.com', 88888888, 12000;
SELECT * FROM Usuario;

EXEC uspInsertProyecto 'P-AAAA-2020-1', 'Sistema Control de Costos', 'SCC', 'administracion', 'Sistema que lleve un control de los costos del area de Recursos Humanos, incluyecto los correspondientes a productos, servicios y empleados', '2020-04-11', NULL, 0, 0 ;
EXEC uspInsertProyecto 'E-BBBB-2022-1', 'Sistema Gestion de Proyectos', 'SGPTI', 'estudio', NULL, '2022-03-31', NULL, 0, 0;
EXEC uspInsertProyecto 'E-CCCC-2021-2', 'Sistema Gestion de Archivos', 'SGAR', 'estudio', NULL, '2021-05-30', NULL, 0, 0;
EXEC uspInsertProyecto 'E-CCCC-2021-3', 'Sistema Gestion de Cedulas', 'SGCE', 'estudio', NULL, '2021-08-30', NULL, 0, 0;
SELECT * FROM Proyecto;
EXEC uspInsertProyecto 'P-PPPP-2021-2', 'Sistema Gestion de Bonos', 'SGBO', 'post', NULL, '2021-08-30', '2021-05-30', 0, 0;
SELECT * FROM Proyecto;

EXEC uspInsertArea 'PTE', 'Proyectos Tecnologicos';
EXEC uspInsertArea 'RRHH', 'Recursos Humanos';
EXEC uspInsertArea 'RF', 'Recursos Financieros';
SELECT * FROM Area;

EXEC uspInsertProyectoArea 1, 2;
EXEC uspInsertProyectoArea 2, 1;
EXEC uspInsertProyectoArea 3, 2;
EXEC uspInsertProyectoArea 4, 2;
SELECT * FROM ProyectoArea;

EXEC uspInsertUsuarioArea '100', 1;
EXEC uspInsertUsuarioArea '101', 1;
EXEC uspInsertUsuarioArea '102', 2;
EXEC uspInsertUsuarioArea '103', 1;
EXEC uspInsertUsuarioArea '104', 2;
EXEC uspInsertUsuarioArea '105', 1;
EXEC uspInsertUsuarioArea '106', 2;
EXEC uspInsertUsuarioArea '107', 1;
SELECT * FROM UsuarioArea;

EXEC uspInsertRolUsuarioProyecto '100', 1, 1, '2020-04-11', NULL;
EXEC uspInsertRolUsuarioProyecto '101', 1, 2, '2020-04-11', NULL;
EXEC uspInsertRolUsuarioProyecto '102', 1, 3, '2021-05-30', NULL;
EXEC uspInsertRolUsuarioProyecto '103', 2, 1, '2020-04-11', NULL;
EXEC uspInsertRolUsuarioProyecto '104', 2, 2, '2022-03-31', NULL;
EXEC uspInsertRolUsuarioProyecto '104', 2, 3, '2021-07-03', '2022-01-10';
EXEC uspInsertRolUsuarioProyecto '105', 3, 1, '2021-05-20', '2022-04-15';
EXEC uspInsertRolUsuarioProyecto '106', 3, 1, '2020-05-20', NULL;
EXEC uspInsertRolUsuarioProyecto '106', 3, 2, '2022-09-10', NULL;
EXEC uspInsertRolUsuarioProyecto '107', 3, 1, '2021-05-22', '2022-04-17';
SELECT * FROM RolUsuarioProyecto;

EXEC uspInsertTarea  NULL, 'Planeacion', 18, NULL, 'completado', 1,'2022-06-14 00:00:00', NULL, 180000.0, 0.0;
EXEC uspInsertTarea  1, 'Hacer cronograma de trabajo', 6, NULL, 'completado', 1,'2022-06-14 00:00:00', NULL, 60000.0, 0.0 ;
EXEC uspInsertTarea  1, 'Oficio de inicio', 5, NULL, 'sin iniciar', 1,'2022-06-14 00:00:00', NULL, 50000.0, 0.0;
EXEC uspInsertTarea  1, 'Organizacion del equipo de trabajo', 7, NULL, 'completado', 2,'2022-06-14 00:00:00', NULL, 70000.0, 0.0;
EXEC uspInsertTarea  3, 'Analisis de recursos tecnicos', 5, NULL, 'completado', 1,'2022-06-14 00:00:00', NULL, 50000.0, 0.0;
EXEC uspInsertTarea  3, 'Analisis de recursos contratados', 5, NULL, 'completado', 2,'2022-06-14 00:00:00', NULL, 50000.0, 0.0;
SELECT * FROM Tarea;

EXEC uspInsertTareaArchivoProyecto 2, NULL, 1;
EXEC uspInsertTareaArchivoProyecto 3, NULL, 1;
EXEC uspInsertTareaArchivoProyecto 2, NULL, 2;
EXEC uspInsertTareaArchivoProyecto 3, NULL, 2;
EXEC uspInsertTareaArchivoProyecto 4, NULL, 3;
EXEC uspInsertTareaArchivoProyecto 4, NULL, 3;
EXEC uspInsertTareaArchivoProyecto 4, NULL, 3;
SELECT * FROM TareaArchivoProyecto;

EXEC uspInsertRegistroHoraUsuario 1, 1, 1, NULL;
EXEC uspInsertRegistroHoraUsuario 2, 2, 1, NULL;
EXEC uspInsertRegistroHoraUsuario 3, 5, 3, 'Corregir lista de correos';
EXEC uspInsertRegistroHoraUsuario 4, 2, 1, NULL;
EXEC uspInsertRegistroHoraUsuario 5, 4, 2, NULL;
EXEC uspInsertRegistroHoraUsuario 6, 6, 3, NULL;
EXEC uspInsertRegistroHoraUsuario 7, 1, 1, NULL;
EXEC uspInsertRegistroHoraUsuario 8, 2, 1, 'Cambiar elformato de fecha';
EXEC uspInsertRegistroHoraUsuario 9, 3, 2, NULL;
EXEC uspInsertRegistroHoraUsuario 9, 7, 2, NULL;
EXEC uspInsertRegistroHoraUsuario 9, 1, 10, NULL;
SELECT * FROM RegistroHoraUsuario;

-- Pruebas de los procedimientos UPDATE
SELECT * FROM Permiso;
EXEC uspUpdatePermiso 4,0,0,0,0;
SELECT * FROM Permiso;

SELECT * FROM Rol;
EXEC uspUpdateRol 3,'Colab', 'Colaborador', 2;
SELECT * FROM Rol;

SELECT * FROM Usuario;
EXEC uspUpdateUsuario '5', 'danielv@gmail.com',50505050,50000;
SELECT * FROM Usuario;

SELECT * FROM Proyecto;
EXEC uspUpdateProyecto 2,'E-DDD-2021-1', 'Sistema Gestion de Proyectos TI', 'SGPTI', 'estudio', NULL, NULL, 0, 0;
SELECT * FROM Proyecto;


SELECT * FROM RolUsuarioProyecto;
EXEC uspUpdateRolUsuarioProyecto 3,'103', 2, 1,  '2021-05-20', '2022-04-15';
SELECT * FROM RolUsuarioProyecto;

SELECT * FROM Tarea;
EXEC uspUpdateTarea 4,2,'Evaluacion', 8, NULL, 'sin iniciar', 1,'2022-06-14 00:00:00', NULL, 70000.0, 0.0;
SELECT * FROM Tarea;

SELECT * FROM TareaArchivoProyecto;
EXEC uspUpdateTareaArchivoProyecto 7, 3, NULL, 2;
SELECT * FROM TareaArchivoProyecto;

SELECT * FROM Area;
EXEC uspUpdateArea 1,'PTEI', 'Proyectos Tecnologicos Innovadore';
SELECT * FROM Area;

SELECT * FROM ProyectoArea;
EXEC uspUpdateProyectoArea 4, 1;
SELECT * FROM ProyectoArea;

SELECT * FROM RegistroHoraUsuario;
EXEC uspUpdateRegistroHoraUsuario 9, 2, 3, 9, '2022-05-20', 'Cambiar el formato de firma';
SELECT * FROM RegistroHoraUsuario;

SELECT * FROM UsuarioArea;
EXEC uspUpdateUsuarioArea '107', 2;
SELECT * FROM UsuarioArea;

-- Pruebas de los procedimientos DELETE
SELECT * FROM Permiso;
EXEC uspDeletePermiso 4;
SELECT * FROM Permiso;

SELECT * FROM Rol;
EXEC uspDeleteRol 4;
SELECT * FROM Rol;

SELECT * FROM Usuario;
EXEC uspDeleteUsuario 8;
SELECT * FROM Usuario;

SELECT * FROM Proyecto;
EXEC uspDeleteProyecto 4;
SELECT * FROM Proyecto;

SELECT * FROM RolUsuarioProyecto;
EXEC uspDeleteRolUsuarioProyecto 10;
EXEC uspDeleteRolUsuarioProyecto 9;
SELECT * FROM RolUsuarioProyecto;

SELECT * FROM Tarea;
EXEC uspDeleteTarea 6;
SELECT * FROM Tarea;

SELECT * FROM Area;
EXEC uspDeleteArea 3;
SELECT * FROM Area;

SELECT * FROM UsuarioArea;
EXEC uspDeleteUsuarioArea 2, 1;
SELECT * FROM UsuarioArea;

SELECT * FROM ProyectoArea;
EXEC uspDeleteProyectoArea 4, 2;
SELECT * FROM ProyectoArea;

SELECT * FROM RegistroHoraUsuario;
EXEC uspDeleteRegistroHoraUsuario 8;
SELECT * FROM RegistroHoraUsuario;

SELECT * FROM TareaArchivoProyecto;
EXEC uspDeleteTareaArchivoProyecto 7;
SELECT * FROM TareaArchivoProyecto;

