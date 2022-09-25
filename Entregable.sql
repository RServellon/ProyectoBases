-- Agrego secuencias modulo, estudio, RolPermisoModulo, TareaArchivoEstudio
-- En tablas, cambiar nombre de proyectoarea a estudioarea, crear
--			tabla de modulos, estudios, RolPermisoModulo, TareaArchivoEstudio, registrohorausuaruoestudio, registrohorausuarioproyecto

-- Se configura el formato de la fecha
SET DATEFORMAT ymd
DECLARE @dt DATETIME2 = '2016-01-02 12:03:28'
SELECT @dt AS 'date from YMD Format'

-- Se borran las secuencias
DROP SEQUENCE secRol;
DROP SEQUENCE secUsuario;
DROP SEQUENCE secPermiso;
DROP SEQUENCE secModulo;
DROP SEQUENCE secProyecto;
DROP SEQUENCE secEstudio;
DROP SEQUENCE secArea;
DROP SEQUENCE secArchivo;
DROP SEQUENCE secTarea;
DROP SEQUENCE secRolUsuarioProyecto;
DROP SEQUENCE secRolUsuarioEstudio;
DROP SEQUENCE secRolPermisoModulo;
DROP SEQUENCE secTareaArchivoProyecto;
DROP SEQUENCE secTareaArchivoEstudio;
DROP SEQUENCE secRegistroHoraUsuarioProyecto;
DROP SEQUENCE secRegistroHoraUsuarioEstudio;

-- Se borran las tablas
DROP TABLE RegistroHoraUsuarioProyecto;
DROP TABLE RegistroHoraUsuarioEstudio;
DROP TABLE RolUsuarioProyecto;
DROP TABLE RolUsuarioEstudio;
DROP TABLE RolPermisoModulo;
DROP TABLE TareaArchivoProyecto;
DROP TABLE TareaArchivoEstudio;
DROP TABLE EstudioArea;
DROP TABLE UsuarioArea;
DROP TABLE Rol;
DROP TABLE Permiso;
DROP TABLE Modulo;
DROP TABLE Usuario;
DROP TABLE Proyecto;
DROP TABLE Estudio;
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
CREATE SEQUENCE secModulo
	AS INT
	START WITH 1 
	INCREMENT BY 1;
CREATE SEQUENCE secProyecto 
	AS INT
	START WITH 1 
	INCREMENT BY 1;
CREATE SEQUENCE secEstudio
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
CREATE SEQUENCE secRolPermisoModulo
    AS INT
	START WITH 1 
	INCREMENT BY 1;
CREATE SEQUENCE secRolUsuarioProyecto
    AS INT
	START WITH 1 
	INCREMENT BY 1;
CREATE SEQUENCE secRolUsuarioEstudio
    AS INT
	START WITH 1 
	INCREMENT BY 1;
CREATE SEQUENCE secTareaArchivoProyecto
    AS INT
	START WITH 1 
	INCREMENT BY 1;
CREATE SEQUENCE secTareaArchivoEstudio
    AS INT
	START WITH 1 
	INCREMENT BY 1;
CREATE SEQUENCE secRegistroHoraUsuarioProyecto
    AS INT
	START WITH 1 
	INCREMENT BY 1;
CREATE SEQUENCE secRegistroHoraUsuarioEstudio
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
);

CREATE TABLE Modulo (
	idpModulo INT NOT NULL PRIMARY KEY,
	codigo VARCHAR(10) NOT NULL UNIQUE,
	nombre VARCHAR(30) NOT NULL, 
	descripcion VARCHAR(30) NULL
);

CREATE TABLE Rol (
	idpRol INT NOT NULL PRIMARY KEY, 
	codigo VARCHAR(10) NOT NULL UNIQUE, 
	nombre VARCHAR(30) NOT NULL UNIQUE,
	costoHora DECIMAL(18,0) NOT NULL CHECK(costoHora >= 0) 
);

CREATE TABLE Usuario (
	idpUsuario INT NOT NULL PRIMARY KEY, 
	identificacion VARCHAR(15) NOT NULL UNIQUE, 
	nombre VARCHAR(30) NOT NULL, 
	apellido VARCHAR(30) NOT NULL, 
	correo VARCHAR(60) NOT NULL UNIQUE, 
	telefono VARCHAR(20) NULL UNIQUE
);

CREATE TABLE Proyecto ( 
	idpProyecto INT NOT NULL PRIMARY KEY,
	codigo VARCHAR(30) NOT NULL UNIQUE,
	nombre VARCHAR(60) NOT NULL,
	siglas VARCHAR(10) NOT NULL UNIQUE,
	estado VARCHAR(30) NOT NULL CHECK(estado IN('completado', 'revision','pendiente','ejecucion','detenido','cancelado')),
	descripcion TEXT NULL, 
	fechaInicio DATETIME NOT NULL, 
	fechaCierre DATETIME NULL,
	costoProyectado DECIMAL(18,0) NOT NULL CHECK(costoProyectado >= 0),
	costoReal DECIMAL(18,0) NOT NULL CHECK(CostoReal >= 0)
);

CREATE TABLE Estudio ( 
	idpEstudio INT NOT NULL PRIMARY KEY,
	codigo VARCHAR(30) NOT NULL UNIQUE,
	nombre VARCHAR(60) NOT NULL,
	estado VARCHAR(30) NOT NULL CHECK(estado IN('completado', 'revision','pendiente','ejecucion','detenido','cancelado')),
	descripcion TEXT NULL, 
	fechaInicio DATETIME NOT NULL, 
	fechaCierre DATETIME NULL,
	costoProyectado DECIMAL(18,0) NOT NULL CHECK(costoProyectado >= 0),
	costoReal DECIMAL(18,0) NOT NULL CHECK(CostoReal >= 0)
);

CREATE TABLE Tarea (
	idpTarea INT NOT NULL PRIMARY KEY, 
	idfTarea INT NULL FOREIGN KEY REFERENCES Tarea(idpTarea) ON DELETE NO ACTION,
	nombre VARCHAR(100) NOT NULL, 
	duracionHora INT NOT NULL CHECK(duracionHora > 0),
	descripcion TEXT NULL, 
	estado VARCHAR(15) NOT NULL CHECK(estado in('completado','en proceso','sin iniciar','cancelado')), 
	prioridad INT NOT NULL CHECK(prioridad BETWEEN 1 AND 3), 
	fechaAsignacion DATETIME NOT NULL,
	fechaCumplimiento DATETIME NULL, 
	costoProyectado DECIMAL(18,0) NOT NULL CHECK(costoProyectado >= 0), 
	costoReal DECIMAL(18,0) NOT NULL CHECK(costoReal >= 0)
);

CREATE TABLE Area (
	idpArea INT NOT NULL PRIMARY KEY,
	codigo VARCHAR(30) NOT NULL UNIQUE,
	nombre VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE Archivo ( 
	idpArchivo INT NOT NULL PRIMARY KEY, 
	codigo VARCHAR(30) NOT NULL UNIQUE, 
	nombre VARCHAR(50) NOT NULL, 
	archivo VARBINARY(MAX) NOT NULL, 
	categoria VARCHAR(30) NOT NULL CHECK(categoria in('estudio','administracion','postimplementacion')), 
	observacion TEXT NULL
);

CREATE TABLE RolUsuarioProyecto (
	idpRolUsuarioProyecto INT NOT NULL PRIMARY KEY,
	idUsuario VARCHAR(15) NOT NULL FOREIGN KEY REFERENCES Usuario(identificacion) ON DELETE CASCADE,
	idfRol INT NOT NULL FOREIGN KEY REFERENCES Rol(idpRol) ON DELETE CASCADE, 
	idfProyecto INT NOT NULL FOREIGN KEY REFERENCES Proyecto(idpProyecto) ON DELETE CASCADE, 
	fechaAsignacion DATETIME NOT NULL, 
	fechaDesasignacion DATETIME NULL
);

CREATE TABLE RolUsuarioEstudio (
	idpRolUsuarioEstudio INT NOT NULL PRIMARY KEY,
	idUsuario VARCHAR(15) NOT NULL FOREIGN KEY REFERENCES Usuario(identificacion) ON DELETE CASCADE,
	idfRol INT NOT NULL FOREIGN KEY REFERENCES Rol(idpRol) ON DELETE CASCADE, 
	idfEstudio INT NOT NULL FOREIGN KEY REFERENCES Estudio(idpEstudio) ON DELETE CASCADE, 
	fechaAsignacion DATETIME NOT NULL, 
	fechaDesasignacion DATETIME NULL
);

CREATE TABLE RolPermisoModulo (
	idpRolPermisoModulo INT NOT NULL PRIMARY KEY,
	idfRol INT NOT NULL FOREIGN KEY REFERENCES Rol(idpRol) ON DELETE CASCADE,
	idfPermiso INT NOT NULL FOREIGN KEY REFERENCES Permiso(idpPermiso) ON DELETE CASCADE,
	idfModulo INT NOT NULL FOREIGN KEY REFERENCES Modulo(idpModulo) ON DELETE CASCADE
);

CREATE TABLE UsuarioArea (
	idfUsuario VARCHAR(15) NOT NULL FOREIGN KEY REFERENCES Usuario(identificacion) ON DELETE CASCADE, 
	idfArea INT NOT NULL FOREIGN KEY REFERENCES Area(idpArea) ON DELETE CASCADE,
	CONSTRAINT idpUsuarioArea PRIMARY KEY(idfUsuario, idfArea)
);

CREATE TABLE EstudioArea (
	idfEstudio INT NOT NULL FOREIGN KEY REFERENCES Estudio(idpEstudio) ON DELETE CASCADE, 
	idfArea INT NOT NULL FOREIGN KEY REFERENCES Area(idpArea) ON DELETE CASCADE,
	CONSTRAINT idpProyectoArea PRIMARY KEY(idfEstudio, idfArea)
);

CREATE TABLE TareaArchivoProyecto (
	idpTareaArchivoProyecto INT NOT NULL PRIMARY KEY, 
	idfTarea INT NULL FOREIGN KEY REFERENCES Tarea(idpTarea) ON DELETE CASCADE,
	idfArchivo INT NULL FOREIGN KEY REFERENCES Archivo(idpArchivo) ON DELETE CASCADE,
	idfProyecto INT NOT NULL FOREIGN KEY REFERENCES Proyecto(idpProyecto) ON DELETE CASCADE
);

CREATE TABLE TareaArchivoEstudio (
	idpTareaArchivoEstudio INT NOT NULL PRIMARY KEY, 
	idfTarea INT NULL FOREIGN KEY REFERENCES Tarea(idpTarea) ON DELETE CASCADE,
	idfArchivo INT NULL FOREIGN KEY REFERENCES Archivo(idpArchivo) ON DELETE CASCADE,
	idfEstudio INT NOT NULL FOREIGN KEY REFERENCES Estudio(idpEstudio) ON DELETE CASCADE
);

CREATE TABLE RegistroHoraUsuarioProyecto (
	idpRegistroHoraUsuarioProyecto INT NOT NULL PRIMARY KEY, 
	idfRolUsuarioProyecto INT NOT NULL FOREIGN KEY REFERENCES RolUsuarioProyecto(idpRolUsuarioProyecto) ON DELETE NO ACTION,
	idfTareaArchivoProyecto INT NOT NULL FOREIGN KEY REFERENCES TareaArchivoProyecto(idpTareaArchivoProyecto) ON DELETE NO ACTION,
	cantidadHoras INT NOT NULL CHECK(cantidadHoras BETWEEN 1 AND 40),
	fechaRegistro DATETIME NOT NULL,
	estado VARCHAR(50) NOT NULL CHECK(estado in('aceptado','pendiente','negado')), 
	observacion TEXT NULL
);

CREATE TABLE RegistroHoraUsuarioEstudio (
	idpRegistroHoraUsuarioEstudio INT NOT NULL PRIMARY KEY, 
	idfRolUsuarioEstudio INT NOT NULL FOREIGN KEY REFERENCES RolUsuarioEstudio(idpRolUsuarioEstudio) ON DELETE NO ACTION,
	idfTareaArchivoEstudio INT NOT NULL FOREIGN KEY REFERENCES TareaArchivoEstudio(idpTareaArchivoEstudio) ON DELETE NO ACTION,
	cantidadHoras INT NOT NULL CHECK(cantidadHoras BETWEEN 1 AND 40),
	fechaRegistro DATETIME NOT NULL,
	estado VARCHAR(50) NOT NULL CHECK(estado in('aceptado','pendiente','negado')), 
	observacion TEXT NULL
);
