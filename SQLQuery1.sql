-- Falta: Agregar check constraints
-- Falta: Agregar tablas Tarea-Archivo y Proyecto-Tarea-Usuario

-- Tablas Primarias: Rol(sec), Usuario(sec), Proyecto(sec),
--					Area(sec), 
-- Tablas Compuestas: RolUsuarioProyecto(sec), 

-- Se borran las secuencias
DROP SEQUENCE secRol;
DROP SEQUENCE secUsuario;
DROP SEQUENCE secProyecto;
DROP SEQUENCE secArea;
DROP SEQUENCE secArchivo;
DROP SEQUENCE secTarea;
DROP SEQUENCE secRolUsuarioProyecto;

-- Se borran las tablas
DROP TABLE Rol;
DROP TABLE Usuario;
DROP TABLE Proyecto;
DROP TABLE Area;
DROP TABLE ProyectoArea;
DROP TABLE Archivo;
DROP TABLE Tarea;
DROP TABLE RolUsuarioProyecto;
DROP TABLE ProyectoArchivo;
DROP TABLE ProyectoArea;
DROP TABLE TareaArchivo;
DROP TABLE ProyectoTareaUsuario;

-- Se crean las secuencias
CREATE SEQUENCE secRol 
	AS INT
	START WITH 1 
	increment BY 1;
CREATE SEQUENCE secUsuario 
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

-- Se crean las tablas
CREATE TABLE Rol (
	idpRol INT NOT NULL PRIMARY KEY, 
	codigo VARCHAR(10) NOT NULL UNIQUE, 
	nombre VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE Usuario (
	idpUsuario INT NOT NULL PRIMARY KEY, 
	identificacion VARCHAR(15) NOT NULL UNIQUE, 
	nombre VARCHAR(30) NOT NULL, 
	apellido VARCHAR(30) NOT NULL, 
	correo VARCHAR(60) NOT NULL UNIQUE, 
	telefono VARCHAR(20) NULL UNIQUE,
	costoHora DECIMAL(18,0) NOT NULL
);

CREATE TABLE Proyecto ( 
	idpProyecto INT NOT NULL PRIMARY KEY,
	codigo VARCHAR(30) NOT NULL UNIQUE,
	nombre VARCHAR(60) NOT NULL,
	siglas VARCHAR(10) NOT NULL UNIQUE,
	estado VARCHAR(20) NOT NULL,
	descripcion TEXT NULL, 
	fechaInicio DATETIME NOT NULL, 
	fechaCierre DATETIME NOT NULL,
	costoCalculado DECIMAL(18,0) NOT NULL,
	costoReal DECIMAL(18,0) NOT NULL
);

CREATE TABLE RolUsuarioProyecto (
	idpRolUsuarioProyecto INT NOT NULL PRIMARY KEY,
	idUsuario VARCHAR(15) NOT NULL FOREIGN KEY REFERENCES Usuario(identificacion),
	idfRol INT NOT NULL FOREIGN KEY REFERENCES Rol(idpRol), 
	idfProyecto INT NOT NULL FOREIGN KEY REFERENCES Proyecto(idpProyecto), 
	fechaAsignacion DATETIME NOT NULL, 
	fechaDesasignacion DATETIME NULL
);

CREATE TABLE Tarea (
	idpTarea INT NOT NULL PRIMARY KEY, 
	nombre VARCHAR(100) NOT NULL, 
	descripcion TEXT NULL, 
	estado VARCHAR(15) NOT NULL, 
	prioridad INT NOT NULL, 
	fechaAsignacion DATETIME NOT NULL,
	fechaCumplimiento DATETIME NOT NULL
);

CREATE TABLE Area (
	idpArea INT NOT NULL PRIMARY KEY,
	codigo VARCHAR(30) NOT NULL UNIQUE,
	nombre VARCHAR(30) NOT NULL UNIQUE,
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
	observacion TEXT NULL,
	fechaRegistro DATETIME NOT NULL
);

CREATE TABLE ProyectoArchivo (
	idfArchivo INT NOT NULL FOREIGN KEY REFERENCES Archivo(idpArchivo),
	idfProyecto INT NOT NULL FOREIGN KEY REFERENCES Proyecto(idpProyecto),
	CONSTRAINT idpProyectoArchivo PRIMARY KEY(idfArchivo, idfProyecto)
);






