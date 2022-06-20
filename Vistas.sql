-- Vista 1: Desglosa un informe acerca de la cantidad de proyectos
-- por �rea y sus costos promedios calculado y reales
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
CREATE OR ALTER VIEW vEmpleadosPorProyecto
AS
SELECT pa.nombre, COUNT(*) cantidadEmpleados, SUM(dbo.funRetornaSalarioPorRegistroAsignacion(rup.idpRolUsuarioProyecto)) sumaSalariosHora
	FROM RolUsuarioProyecto rup INNER JOIN Proyecto pa ON rup.idfProyecto= pa.idpProyecto
	GROUP BY pa.nombre;
GO

-- Vista 3: Desglosa un informe que contiene la informaci�n b�sica de un empleado
-- asignado a un proyecto como identificaci�n, nombre completo, correo electr�nico, rol, 
-- nombre del proyecto y c�digo del proyecto. 
GO
CREATE OR ALTER VIEW vEmpleados
AS
SELECT u.identificacion id, u.nombre +' '+ u.apellido nombreCompletoEmpleado, u.correo email, r.codigo rol, u.costoHora salarioHora , p.nombre nombreProyecto, p.codigo codigoProyecto
	FROM Usuario u INNER JOIN RolUsuarioProyecto rup ON rup.idUsuario = u.identificacion
	INNER JOIN Rol r ON r.idpRol = rup.idfRol
	INNER JOIN Proyecto p ON p.idpProyecto = rup.idfProyecto;
GO

-- Vista 4: Desglosa un informe completo que contiene la informaci�n b�sica de todos los
-- proyectos como codigo, nombre, siglas, estado, fecha de inicio y fecha de cierre.
-- Este informe se dirige a los participantes de un proyecto, por lo 
-- que los costos no se incluyen por razones de discreci�n. 
GO
CREATE OR ALTER VIEW vProyectos
AS
SELECT p.codigo, p.nombre, p.siglas, p.estado, p.fechaInicio, p.fechaCierre
FROM Proyecto p;
GO

--SUM(dbo.funRetornaSalarioPorRegistroAsignacion(rup.idpRolUsuarioProyecto)) sumaSalarios

SELECT * FROM vProyectosPorArea;
SELECT * FROM vEmpleadosPorProyecto;
SELECT * FROM vEmpleados;
SELECT * FROM vProyectos;
select * from Tarea;