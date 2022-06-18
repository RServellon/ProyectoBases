
--VISTA QUE ME DA UN INFORME DETALLADO DE LA CANTIDAD DE PROYECTOS POR AREA DEL TSE Y SUS COSTES PROMEDIO TOTALES
GO
CREATE OR ALTER VIEW view_det_proy_area 
AS
SELECT a.codigo Area, COUNT(*) cantidad_Proyectos, AVG(p.costoCalculado) prom_costo_calculado, AVG(p.costoReal) prom_costo_real 
	FROM Area a INNER JOIN ProyectoArea pa ON a.idpArea = pa.idfArea 
	INNER JOIN Proyecto p ON p.idpProyecto = pa.idfProyecto
	GROUP BY a.codigo;
GO

select * from view_det_proy_area;
--DROP VIEW view_det_proy_area;


--VISTA QUE ME DA UN INFORME DE LA CANTIDAD DE EMPLEADOS EN CADA PROYECTO
GO
CREATE OR ALTER VIEW view_cant_emp_proy 
AS
SELECT pa.nombre, COUNT(*) cantidad_empleados
	FROM RolUsuarioProyecto rup INNER JOIN Proyecto pa ON rup.idfProyecto= pa.idpProyecto
	GROUP BY pa.nombre;
GO

select * from view_cant_emp_proy;
--DROP VIEW view_cant_emp_proy;


--VISTA QUE ME DA UN INFORME COMPLETO DE UN EMPLEADO Y SU ROL EN CADA PROYECTO
GO
CREATE OR ALTER VIEW view_emp_proyecto 
AS
SELECT u.identificacion id, u.nombre +' '+ u.apellido nombre_empleado, u.correo email, r.codigo rol , p.nombre nombre_proyecto, p.codigo codigo_proyecto
	FROM Usuario u INNER JOIN RolUsuarioProyecto rup ON rup.idUsuario = u.identificacion
	INNER JOIN Rol r ON r.idpRol = rup.idfRol
	INNER JOIN Proyecto p ON p.idpProyecto = rup.idfProyecto;
GO

select * from view_emp_proyecto;



--VISTA QUE ME MUESTRA INFORMACION DE LOS PROYECTOS (A NIVEL DE USUARIOS - LOS COSTES NO DEBERIAN DE APARECER)
GO
CREATE OR ALTER VIEW view_proyectos_inf 
AS
SELECT p.codigo, p.nombre, p.siglas, p.estado, p.fechaInicio fecha_inicio, p.fechaCierre fecha_cierre
FROM Proyecto p;
GO

select * from view_proyectos_inf;
--DROP VIEW view_proyectos_inf;

--VISTA QUE ME FILTRA INFORMACION DE LOS PROYECTOS SEGUN SU ESTADO