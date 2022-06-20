-- Vista 1: Desglosa un informe acerca de la cantidad de proyectos
-- por área y sus costos promedios calculado y reales
GO
CREATE OR ALTER VIEW vProyectosPorArea 
AS
SELECT a.codigo Area, COUNT(*) cantidadProyectos, AVG(p.costoCalculado) promedioCostoCalculado, AVG(p.costoReal) promedioCostoReal 
	FROM Area a INNER JOIN ProyectoArea pa ON a.idpArea = pa.idfArea 
	INNER JOIN Proyecto p ON p.idpProyecto = pa.idfProyecto
	GROUP BY a.codigo;
GO

-- Vista 2: Desglosa un informe acerca de la cantidad de empleados
-- en cada proyecto
GO
CREATE OR ALTER VIEW vCantidadEmpleadosPorProyecto
AS
SELECT pa.nombre, COUNT(*) cantidadEmpleados
	FROM RolUsuarioProyecto rup INNER JOIN Proyecto pa ON rup.idfProyecto= pa.idpProyecto
	GROUP BY pa.nombre;
GO

-- Vista 3: Desglosa un informe que contiene la información básica de un empleado
-- asignado a un proyecto como identificación, nombre completo, correo electrónico, rol, 
-- nombre del proyecto y código del proyecto. 
GO
CREATE OR ALTER VIEW vEmpleadoPorProyecto
AS
SELECT u.identificacion id, u.nombre +' '+ u.apellido nombreCompletoEmpleado, u.correo email, r.codigo rol , p.nombre nombreProyecto, p.codigo codigoProyecto
	FROM Usuario u INNER JOIN RolUsuarioProyecto rup ON rup.idUsuario = u.identificacion
	INNER JOIN Rol r ON r.idpRol = rup.idfRol
	INNER JOIN Proyecto p ON p.idpProyecto = rup.idfProyecto;
GO

-- Vista 4: Desglosa un informe completo que contiene la información básica de todos los
-- proyectos como codigo, nombre, siglas, estado, fecha de inicio y fecha de cierre.
-- Este informe se dirige a los participantes de un proyecto, por lo 
-- que los costos no se incluyen por razones de discreción. 
GO
CREATE OR ALTER VIEW vDesgloseProyecto
AS
SELECT p.codigo, p.nombre, p.siglas, p.estado, p.fechaInicio, p.fechaCierre
FROM Proyecto p;
GO


-- Vista 5: Desglosa informe simplificado que contiene la siguiente información de los
-- proyectos: codigo, nombre, siglas y estado
GO
CREATE OR ALTER VIEW vEstadoProyectos
AS
SELECT p.codigo, p.nombre, p.siglas, p.estado
FROM Proyecto p;
GO


SELECT * FROM vProyectosPorArea;
SELECT * FROM vCantidadEmpleadosPorProyecto;
SELECT * FROM vEmpleadoPorProyecto;
SELECT * FROM vDesgloseProyecto;
SELECT * FROM vEstadoProyectos;
