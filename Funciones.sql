-- Funciones
-- Ya están 6 funciones

-- Calcular costo estimado de una tarea padre
-- Se puede usar en un trigger para actualizar los valores
CREATE FUNCTION dbo.funCalculoCostoEstimadoTarea (
	@pIdTarea INT
)
RETURNS DECIMAL(18,0) AS
BEGIN
	DECLARE
	@costoCalculado DECIMAL(18,0);
	SELECT @costoCalculado = SUM(Tarea.costoCalculado)
	FROM Tarea 
	WHERE idpTarea = @pIdTarea;
	RETURN @costoCalculado;
END

SELECT dbo.funCalculoCostoEstimadoTarea(1) AS Costo;
DROP FUNCTION funCalculoCostoEstimadoTarea;

-- Actualizar horas estimadas al ingresar una tarea hija
-- Se puede usr en un trigger para actualizar valores
CREATE FUNCTION dbo.funCalculoHorasTarea (
	@pIdTarea INT
)
RETURNS DECIMAL(18,0) AS
BEGIN
	DECLARE
	@cantidadHoras INT;
	SELECT @cantidadHoras = SUM(Tarea.duracionHora)
	FROM Tarea 
	WHERE idpTarea = @pIdTarea;
	RETURN @cantidadHoras;
END

SELECT dbo.funCalculoHorasTarea(1) AS CantidadHoras;
DROP FUNCTION funCalculoHorasTarea;

-- Reciba id del proyecto y retorne el nombre
CREATE FUNCTION dbo.funRetornaNombreProyectoPorId (
	@pIdProyecto INT
)
RETURNS VARCHAR(60) AS
BEGIN
	DECLARE
	@nombreProyecto VARCHAR(60);
	SELECT @nombreProyecto = Proyecto.nombre
	FROM Proyecto
	WHERE idpProyecto = @pIdProyecto;
	RETURN @nombreProyecto;
END

SELECT dbo.funRetornaNombreProyectoPorId(1) AS nombreProyecto;
DROP FUNCTION funRetornaNombreProyectoPorId;

-- Reciba id del usuario y retorne el nombre
CREATE FUNCTION dbo.funRetornaNombreUsuarioPorId (
	@pIdUsuario VARCHAR(15)
)
RETURNS VARCHAR(60) AS
BEGIN
	DECLARE
	@nombreUsuario VARCHAR(60);
	SELECT @nombreUsuario = CONCAT(Usuario.nombre, ' ',  Usuario.apellido)
	FROM Usuario
	WHERE identificacion = @pIdUsuario;
	RETURN @nombreUsuario;
END

SELECT dbo.funRetornaNombreUsuarioPorId('104') AS nombreUsuario;
DROP FUNCTION funRetornaNombreUsuarioPorId;

-- Retornar proyectos asignados que tiene un usuario
CREATE FUNCTION dbo.funProyectosAsignadosAUsuario (
	@pIdUsuario VARCHAR(15)
)
RETURNS TABLE AS
RETURN (
	SELECT dbo.funRetornaNombreProyectoPorId(RUP.idfProyecto) proyectosAsignado, P.codigo codigo, P.estado estado
	FROM RolUsuarioProyecto AS RUP, Proyecto AS P
	WHERE RUP.idUsuario = @pIdUsuario AND P.idpProyecto = RUP.idfProyecto
)

SELECT * FROM dbo.funProyectosAsignadosAUsuario('104') AS Prueba;
DROP FUNCTION funProyectosAsignadosAUsuario;

-- Retornar cantidad de participantes por proyecto
CREATE FUNCTION dbo.funCantidadParticipantesPorProyecto ()
RETURNS TABLE AS
RETURN (
	SELECT dbo.funRetornaNombreProyectoPorId(RUP.idfProyecto) proyecto, COUNT(*) participantes
	FROM RolUsuarioProyecto AS RUP
	GROUP BY RUP.idfProyecto
)

SELECT * FROM dbo.funCantidadParticipantesPorProyecto();
DROP FUNCTION funCantidadParticipantesPorProyecto;