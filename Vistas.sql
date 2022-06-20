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

SELECT * FROM Proyecto;
SELECT * FROM vProyectosPorArea;

-- Vista 2: Desglosa un informe acerca de la cantidad de empleados
-- en cada proyecto y la suma de los salarios por hora de estos
GO
CREATE OR ALTER VIEW vEmpleadosPorProyecto
AS
SELECT pa.nombre, COUNT(*) cantidadEmpleados, SUM(dbo.funRetornaSalarioPorIdUsuario(rup.idUsuario)) sumaSalariosHora
	FROM RolUsuarioProyecto rup INNER JOIN Proyecto pa ON rup.idfProyecto= pa.idpProyecto
	GROUP BY pa.nombre;
GO

SELECT * FROM vEmpleadosPorProyecto;


-- Vista 3: Desglosa un informe que contiene la información básica de un empleado
-- asignado a un proyecto como identificación, nombre completo, correo electrónico, rol, 
-- nombre del proyecto y código del proyecto. 
GO
CREATE OR ALTER VIEW vEmpleados
AS
SELECT u.identificacion id, u.nombre +' '+ u.apellido nombreCompletoEmpleado, u.correo email, r.codigo rol, u.costoHora salarioHora , p.nombre nombreProyecto, p.codigo codigoProyecto
	FROM Usuario u INNER JOIN RolUsuarioProyecto rup ON rup.idUsuario = u.identificacion
	INNER JOIN Rol r ON r.idpRol = rup.idfRol
	INNER JOIN Proyecto p ON p.idpProyecto = rup.idfProyecto;
GO

SELECT * FROM vEmpleados;

-- Vista 4: Desglosa un informe completo que contiene la información básica de todos los
-- proyectos como codigo, nombre, siglas, estado, fecha de inicio y fecha de cierre.
-- Este informe se dirige a los participantes de un proyecto, por lo 
-- que los costos no se incluyen por razones de discreción. 
GO
CREATE OR ALTER VIEW vProyectos
AS
SELECT p.codigo, p.nombre, p.siglas, p.estado, p.fechaInicio, p.fechaCierre
FROM Proyecto p;
GO

SELECT * FROM vProyectos;

-- Vista 5: Desglosa un informe de las tareas asociadas a sus proyectos
-- con la siguiente información nombre de tarea, estado, prioridad,
-- nombre de proyecto e identificador del proyecto
GO
CREATE OR ALTER VIEW vTareas
AS
SELECT  t.nombre nombreTarea, t.estado, t.prioridad, p.nombre nombreProyecto, p.idpProyecto idProyecto
FROM TareaArchivoProyecto tap, Proyecto p, Tarea t
WHERE tap.idfTarea = t.idpTarea AND tap.idfProyecto = p.idpProyecto;
GO

SELECT * FROM vTareas;


-- Vista 6: Desglosa un informe acerca de la cantidad de tareas
-- en cada proyecto
GO
CREATE OR ALTER VIEW vTareasPorProyecto
AS
SELECT p.nombre nombreProyecto, p.idpProyecto, COUNT(*) cantidadTareas
FROM TareaArchivoProyecto tap INNER JOIN Proyecto p ON tap.idfProyecto = p.idpProyecto
GROUP BY p.nombre, p.idpProyecto;
GO

SELECT * FROM vTareasPorProyecto;
