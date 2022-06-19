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

-- 	fechaInicio DATETIME NOT NULL CHECK(fechaInicio >= GETDATE()), 
-- 	fechaCierre DATETIME NULL CHECK(fechaCierre > fechaInicio),
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

-- 	fechaAsignacion DATETIME NOT NULL CHECK(fechaAsignacion <= GETDATE()), 
-- 	fechaDesasignacion DATETIME NULL CHECK(fechaDesasignacion >= fechaAsignacion)
CREATE TABLE RolUsuarioProyecto (
	idpRolUsuarioProyecto INT NOT NULL PRIMARY KEY,
	idUsuario VARCHAR(15) NOT NULL FOREIGN KEY REFERENCES Usuario(identificacion) ON DELETE CASCADE,
	idfRol INT NOT NULL FOREIGN KEY REFERENCES Rol(idpRol) ON DELETE CASCADE, 
	idfProyecto INT NOT NULL FOREIGN KEY REFERENCES Proyecto(idpProyecto) ON DELETE CASCADE, 
	fechaAsignacion DATETIME NOT NULL, 
	fechaDesasignacion DATETIME NULL
);

-- 	fechaAsignacion DATETIME NOT NULL CHECK(fechaAsignacion >= GETDATE()),
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
	idfTarea INT NOT NULL FOREIGN KEY REFERENCES Tarea(idpTarea) ON DELETE CASCADE,
	idfArchivo INT NOT NULL FOREIGN KEY REFERENCES Archivo(idpArchivo) ON DELETE CASCADE,
	idfProyecto INT NOT NULL FOREIGN KEY REFERENCES Proyecto(idpProyecto) ON DELETE CASCADE
);

-- 	fechaRegistro DATETIME NOT NULL CHECK(fechaRegistro >= fechaAsignacion),
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

/*

INSERT INTO Permiso VALUES(NEXT VALUE FOR secPermiso, 1, 1, 1, 1);
INSERT INTO Permiso VALUES(NEXT VALUE FOR secPermiso, 0, 1, 0, 0);
INSERT INTO Permiso VALUES(NEXT VALUE FOR secPermiso, 0, 1, 0, 1);
SELECT * FROM Permiso;


INSERT INTO Rol VALUES(NEXT VALUE FOR secRol, 'Admin', 'Administrador', 1);
INSERT INTO Rol VALUES(NEXT VALUE FOR secRol, 'Coor', 'Coordinador', 3);
INSERT INTO Rol VALUES(NEXT VALUE FOR secRol, 'Part', 'Participante', 2);
SELECT * FROM Rol;



INSERT INTO Usuario VALUES(NEXT VALUE FOR secUsuario, '100', 'Pedro', 'Gonzales', 'pedro@gmail.com', 11111111, 20000);
INSERT INTO Usuario VALUES(NEXT VALUE FOR secUsuario, '101', 'Felipe', 'Campos', 'felipe@gmail.com', 22222222, 20000);
INSERT INTO Usuario VALUES(NEXT VALUE FOR secUsuario, '102', 'Maria', 'Ramirez', 'maria@gmail.com', 33333333, 20000);
INSERT INTO Usuario VALUES(NEXT VALUE FOR secUsuario, '103', 'Sara', 'Salas', 'sara@gmail.com', 44444444, 17000);
INSERT INTO Usuario VALUES(NEXT VALUE FOR secUsuario, '104', 'Daniel', 'Villalobos', 'daniel@gmail.com', 55555555, 17000);
INSERT INTO Usuario VALUES(NEXT VALUE FOR secUsuario, '105', 'Monica', 'Hernandez', 'monica@gmail.com', 66666666, 10000);
INSERT INTO Usuario VALUES(NEXT VALUE FOR secUsuario, '106', 'Jose', 'Murillo', 'jose@gmail.com', 77777777, 10000);
SELECT * FROM Usuario;


INSERT INTO Proyecto VALUES(NEXT VALUE FOR secProyecto, 'P-AAAA-2020-1', 'Sistema Control de Costos', 'SCC', 'administracion', 'Sistema que lleve un control de los costos del area de Recursos Humanos, incluyecto los correspondientes a productos, servicios y empleados', '2020-04-11', NULL, 3000, 4000);
INSERT INTO Proyecto VALUES(NEXT VALUE FOR secProyecto, 'E-BBBB-2022-1', 'Sistema Gestion de Proyectos', 'SGPTI', 'estudio', NULL, '2022-03-31', NULL, 1000, 2000);
INSERT INTO Proyecto VALUES(NEXT VALUE FOR secProyecto, 'E-CCCC-2021-2', 'Sistema Gestion de Archivos', 'SGAR', 'estudio', NULL, '2021-05-30', NULL, 2000, 6500);
SELECT * FROM Proyecto;


INSERT INTO RolUsuarioProyecto VALUES(NEXT VALUE FOR secRolUsuarioProyecto, '100', 1, 1, '2020-04-11', NULL);
INSERT INTO RolUsuarioProyecto VALUES(NEXT VALUE FOR secRolUsuarioProyecto, '101', 1, 2, '2020-04-11', NULL);
INSERT INTO RolUsuarioProyecto VALUES(NEXT VALUE FOR secRolUsuarioProyecto, '102', 1, 3, '2021-05-30', NULL);
INSERT INTO RolUsuarioProyecto VALUES(NEXT VALUE FOR secRolUsuarioProyecto, '103', 2, 1, '2020-04-11', NULL);
INSERT INTO RolUsuarioProyecto VALUES(NEXT VALUE FOR secRolUsuarioProyecto, '104', 2, 2, '2022-03-31', NULL);
INSERT INTO RolUsuarioProyecto VALUES(NEXT VALUE FOR secRolUsuarioProyecto, '104', 2, 3, '2021-07-03', '2022-01-10');
INSERT INTO RolUsuarioProyecto VALUES(NEXT VALUE FOR secRolUsuarioProyecto, '105', 3, 1, '2021-05-20', '2022-04-15');
INSERT INTO RolUsuarioProyecto VALUES(NEXT VALUE FOR secRolUsuarioProyecto, '106', 3, 1, '2020-05-20', NULL);
INSERT INTO RolUsuarioProyecto VALUES(NEXT VALUE FOR secRolUsuarioProyecto, '106', 3, 2, '2022-09-10', NULL);
SELECT * FROM RolUsuarioProyecto;


INSERT INTO Area VALUES(NEXT VALUE FOR secArea, 'PTE', 'Proyectos Tecnologicos');
INSERT INTO Area VALUES(NEXT VALUE FOR secArea, 'RRHH', 'Recursos Humanos');
SELECT * FROM Area;


INSERT INTO ProyectoArea VALUES(2, 1);
INSERT INTO ProyectoArea VALUES(3, 2);
INSERT INTO ProyectoArea VALUES(1, 2);
INSERT INTO ProyectoArea VALUES(1, 1);
INSERT INTO ProyectoArea VALUES(3, 1);
SELECT * FROM ProyectoArea;

INSERT INTO Tarea VALUES(NEXT VALUE FOR secTarea, NULL, 'Planeacion', 18, NULL, 'completado', 1,'2022-06-14 00:00:00', NULL, 180000.0, 0.0);
INSERT INTO Tarea VALUES(NEXT VALUE FOR secTarea, 1, 'Hacer cronograma de trabajo', 6, NULL, 'completado', 1,'2022-06-14 00:00:00', NULL, 60000.0, 0.0);
INSERT INTO Tarea VALUES(NEXT VALUE FOR secTarea, 1, 'Oficio de inicio', 5, NULL, 'sin iniciar', 1,'2022-06-14 00:00:00', NULL, 50000.0, 0.0);
INSERT INTO Tarea VALUES(NEXT VALUE FOR secTarea, 1, 'Organizacion del equipo de trabajo', 7, NULL, 'completado', 2,'2022-06-14 00:00:00', NULL, 70000.0, 0.0);
INSERT INTO Tarea VALUES(NEXT VALUE FOR secTarea, 3, 'Analisis de recursos tecnicos', 5, NULL, 'completado', 1,'2022-06-14 00:00:00', NULL, 50000.0, 0.0);
SELECT * FROM TAREA;
DELETE FROM Tarea WHERE idpTarea = 6;

-- No s� c�mo se suben los archivos
-- INSERT INTO Archivo VALUES(NEXT VALUE FOR secArchivo, 'ACT-Pv5', 'Acta de constitucion', CAST('acta' AS VARBINARY(MAX)), NULL);
-- INSERT INTO Archivo VALUES(NEXT VALUE FOR secArchivo);
-- INSERT INTO Archivo VALUES(NEXT VALUE FOR secArchivo);
-- SELECT * FROM Archivo;

*/