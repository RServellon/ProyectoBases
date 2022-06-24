-- Funciones

-- Función 1: Calcular costo estimado de una tarea padre
-- Costo estimado = salario por hora de un usuario * duración de tarea
GO
CREATE OR ALTER FUNCTION dbo.funCalculoCostoEstimadoTarea (
	@pIdTarea INT
)
RETURNS DECIMAL(18,0) AS
BEGIN
	DECLARE
	@costoCalculado DECIMAL(18,0);
	SELECT @costoCalculado = SUM(Tarea.costoCalculado)
	FROM Tarea 
	WHERE idfTarea = @pIdTarea;
	RETURN @costoCalculado;
END
GO

SELECT dbo.funCalculoCostoEstimadoTarea(1) AS Costo;
--DROP FUNCTION funCalculoCostoEstimadoTarea;

GO
CREATE OR ALTER FUNCTION dbo.funCalculoCostoEstimado (
	@pIdTareaAsignacion INT,
	@pIdUsuarioAsignacion INT
)
RETURNS DECIMAL(18,0) AS
BEGIN
	DECLARE
	@costoHora DECIMAL(18,0),
	@duracionHora INT;
	SELECT @duracionHora = t.duracionHora,
		   @costoHora = dbo.funRetornaSalarioPorRegistroAsignacion(@pIdUsuarioAsignacion) 
	FROM Tarea t, TareaArchivoProyecto tap
	WHERE t.idfTarea = tap.idfTarea AND tap.idpTareaArchivoProyecto = @pIdTareaAsignacion
	RETURN @costoHora * @duracionHora;
END
GO

SELECT dbo.funCalculoCostoEstimado(2, 1) AS Costo;


-- Función 2: Calcular horas estimadas de una tarea padre
-- Se puede usar al agregar, eliminar o actualizar una tarea y se deba
-- de volver a calcular la duración estimada de su tarea padre
GO
CREATE OR ALTER FUNCTION dbo.funCalculoHorasTarea (
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
GO

SELECT dbo.funCalculoHorasTarea(1) AS CantidadHoras;
--DROP FUNCTION funCalculoHorasTarea;


-- Función 1: Recibe id del usuario por parámetro y
-- retorna su salario por hora
GO
CREATE OR ALTER FUNCTION dbo.funRetornaSalarioPorIdUsuario (
	@pIdUsuario VARCHAR(15)
)
RETURNS DECIMAL(18,0) AS
BEGIN
	DECLARE
	@salario DECIMAL(18,0);
	SELECT @salario = costoHora
	FROM Usuario
	WHERE identificacion = @pIdUsuario;
	RETURN @salario;
END
GO

SELECT * FROM Usuario;
SELECT dbo.funRetornaSalarioPorIdUsuario('103') AS SalarioHora;

-- Función 2: Recibe id del proyecto por parámetro y
-- retorna su nombre
GO
CREATE OR ALTER FUNCTION dbo.funRetornaNombreProyectoPorId (
	@pIdProyecto INT
)
RETURNS VARCHAR(100) AS
BEGIN
	DECLARE
	@nombre VARCHAR(100);
	SELECT @nombre = nombre
	FROM Proyecto
	WHERE idpProyecto = @pIdProyecto;
	RETURN @nombre;
END
GO

SELECT * FROM Proyecto;
SELECT dbo.funRetornaNombreProyectoPorId(1) AS NombreProyecto;


-- Función 3: Reciba id de la tarea por parámetro
-- y retorne su duracion en horas
GO
CREATE OR ALTER FUNCTION dbo.funRetornaDuracionPorIdTarea (
	@pIdTarea INT
)
RETURNS INT AS
BEGIN
	DECLARE
	@duracion INT;
	SELECT @duracion = Tarea.duracionHora
	FROM Tarea
	WHERE idpTarea = @pIdTarea;
	RETURN @duracion;
END
GO

SELECT * FROM Tarea;
SELECT dbo.funRetornaDuracionPorIdTarea(5) AS DuracionHoras;


-- Función 4: Recibe por parámetro un estado (estudio, administracion, post)
-- y retorna los proyectos que lo posean
GO
CREATE OR ALTER FUNCTION dbo.funRetornaProyectosPorEstado (
	@pEstado VARCHAR(20)
)
RETURNS TABLE AS
RETURN
	SELECT *
	FROM vProyectos
	WHERE estado = @pEstado;
GO

SELECT * FROM Proyecto;
SELECT * FROM dbo.funRetornaProyectosPorEstado('estudio') AS Proyectos;

-- Función 5: Recibe por parámetro un estado (sin iniciar, en proceso, completado)
-- y el identificador de un proyecto, de manera que retorna todas las tareas
-- que esten asociadas a dicho proyecto y cumplan con el estado indicado
GO
CREATE OR ALTER FUNCTION dbo.funRetornaTareasDeProyectoPorEstado (
	@pEstado VARCHAR(20),
	@pIdProyecto INT
)
RETURNS TABLE AS
RETURN
	SELECT *
	FROM vTareas
	WHERE vTareas.estado = @pEstado AND vTareas.idProyecto = @pIdProyecto;
GO

SELECT * FROM Tarea;
SELECT * FROM Proyecto;
SELECT * FROM TareaArchivoProyecto;
SELECT * FROM dbo.funRetornaTareasDeProyectoPorEstado('sin iniciar', 1) AS Proyectos;

-- Función 6: Recibe por parámetro una prioridad (1, 2, 3)
-- y el identificador de un proyecto, de manera que retorna todas las tareas
-- que esten asociadas a dicho proyecto y cumplan con la prioridad indicada
GO
CREATE OR ALTER FUNCTION dbo.funRetornaTareasDeProyectoPorPrioridad (
	@pPrioridad INT,
	@pIdProyecto INT
)
RETURNS TABLE AS
RETURN
	SELECT *
	FROM vTareas
	WHERE vTareas.prioridad = @pPrioridad AND vTareas.idProyecto = @pIdProyecto;
GO

SELECT * FROM dbo.funRetornaTareasDeProyectoPorPrioridad(1, 2);
