-- Falta: Agregar check constraints
-- Falta: Agregar tablas Tarea-Archivo y Proyecto-Tarea-Usuario

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
DROP TABLE Rol;
DROP TABLE Permiso;
DROP TABLE Usuario;
DROP TABLE Proyecto;
DROP TABLE Area;
DROP TABLE Archivo;
DROP TABLE Tarea;
DROP TABLE RolUsuarioProyecto;
DROP TABLE TareaArchivoProyecto;
DROP TABLE ProyectoArea;
DROP TABLE RegistroHoraUsuario;

-- Se crean las secuencias
CREATE SEQUENCE secRol 
	AS INT
	START WITH 1 
	increment BY 1;
CREATE SEQUENCE secUsuario 
	AS INT
	START WITH 1 
	increment BY 1;
CREATE SEQUENCE secPermiso 
	AS INT
	START WITH 1 
	increment BY 1;
CREATE SEQUENCE secProyecto 
	AS INT
	START WITH 1 
	increment BY 1;
CREATE SEQUENCE secArea
    AS INT
	START WITH 1 
	increment BY 1;
CREATE SEQUENCE secArchivo
    AS INT
	START WITH 1 
	increment BY 1;
CREATE SEQUENCE secTarea
    AS INT
	START WITH 1 
	increment BY 1;
CREATE SEQUENCE secRolUsuarioProyecto
    AS INT
	START WITH 1 
	increment BY 1;
CREATE SEQUENCE secTareaArchivoProyecto
    AS INT
	START WITH 1 
	increment BY 1;
CREATE SEQUENCE secRegistroHoraUsuario
    AS INT
	START WITH 1 
	increment BY 1;

-- Se crean las tablas
CREATE TABLE Permiso (
	idpPermiso INT NOT NULL PRIMARY KEY,
	crear INT NOT NULL CHECK(crear = 1 OR crear = 0),
	leer INT NOT NULL CHECK(leer = 1 OR leer = 0),
	borrar INT NOT NULL CHECK(borrar = 1 OR borrar = 0),
	actualizar INT NOT NULL CHECK(actualizar = 1 OR actualizar = 0)
)

CREATE TABLE Rol (
	idpRol INT NOT NULL PRIMARY KEY, 
	codigo VARCHAR(10) NOT NULL UNIQUE, 
	nombre VARCHAR(30) NOT NULL UNIQUE,
	permiso INT NOT NULL FOREIGN KEY REFERENCES Permiso(idpPermiso)
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
	idUsuario VARCHAR(15) NOT NULL FOREIGN KEY REFERENCES Usuario(identificacion),
	idfRol INT NOT NULL FOREIGN KEY REFERENCES Rol(idpRol), 
	idfProyecto INT NOT NULL FOREIGN KEY REFERENCES Proyecto(idpProyecto), 
	fechaAsignacion DATETIME NOT NULL, 
	fechaDesasignacion DATETIME NULL
);

-- 	fechaAsignacion DATETIME NOT NULL CHECK(fechaAsignacion >= GETDATE()),
CREATE TABLE Tarea (
	idpTarea INT NOT NULL PRIMARY KEY, 
	idfTarea INT NULL FOREIGN KEY REFERENCES Tarea(idpTarea),
	nombre VARCHAR(100) NOT NULL, 
	duracionHora INT NOT NULL CHECK(duracionHora > 0),
	descripcion TEXT NULL, 
	estado VARCHAR(15) NOT NULL CHECK(estado in('completado','en proceso','sin iniciar')), 
	prioridad INT NOT NULL CHECK(prioridad BETWEEN 1 AND 3), 
	fechaAsignacion DATETIME NOT NULL,
	fechaCumplimiento DATETIME NULL, 
	costoCalculado DECIMAL(18,0) NOT NULL CHECK(costoCalculado >= 0), 
	costoReal DECIMAL(18,0) NOT NULL CHECK(costoCalculado >= 0)
);

CREATE TABLE Area (
	idpArea INT NOT NULL PRIMARY KEY,
	codigo VARCHAR(30) NOT NULL UNIQUE,
	nombre VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE ProyectoArea (
	idfProyecto INT NOT NULL FOREIGN KEY REFERENCES Proyecto(idpProyecto), 
	idfArea INT NOT NULL FOREIGN KEY REFERENCES Area(idpArea),
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
	idfTarea INT NOT NULL FOREIGN KEY REFERENCES Tarea(idpTarea),
	idfArchivo INT NOT NULL FOREIGN KEY REFERENCES Archivo(idpArchivo),
	idfProyecto INT NOT NULL FOREIGN KEY REFERENCES Proyecto(idpProyecto)
);

-- 	fechaRegistro DATETIME NOT NULL CHECK(fechaRegistro >= fechaAsignacion),
CREATE TABLE RegistroHoraUsuario (
	idpRegistroHoraUsuario INT NOT NULL PRIMARY KEY, 
	idfRolUsuarioProyecto INT NOT NULL FOREIGN KEY REFERENCES RolUsuarioProyecto(idpRolUsuarioProyecto),
	idfTareaArchivoProyecto INT NOT NULL FOREIGN KEY REFERENCES TareaArchivoProyecto(idpTareaArchivoProyecto),
	cantidadHoras INT NOT NULL CHECK(cantidadHoras BETWEEN 0 AND 40),
	fechaRegistro DATETIME NOT NULL,
	observacion TEXT NULL
);






