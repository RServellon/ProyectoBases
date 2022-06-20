-- Funciones

-- Función 1: Calcular costo estimado de una tarea padre
-- Se puede usar al agregar, eliminar o actualizar una tarea y se deba
-- de volver a calcular el costo estimado de su tarea padre
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
	@pIdTarea INT,
	@pIdRolUsuarioProyecto INT
)
RETURNS DECIMAL(18,0) AS
BEGIN
	DECLARE
	@costoHora DECIMAL(18,0),
	@duracionHora INT;
	SELECT @duracionHora = Tarea.duracionHora,
		   @costoHora = dbo.funRetornaSalarioPorRegistroAsignacion(@pIdRolUsuarioProyecto) 
	FROM Tarea
	WHERE idfTarea = @pIdTarea
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


-- Función 3: Reciba id del usuario por parámetro
-- y retorne su salario por hora
GO
CREATE OR ALTER FUNCTION dbo.funRetornaSalarioPorIdUsuario (
	@pIdUsuario INT
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

SELECT dbo.funRetornaSalarioPorIdUsuario('104') AS costoHora;
--DROP FUNCTION funRetornaSalarioPorIdUsuario;


-- Función 4: Reciba id del registro de asignación de un usuario a un proyecto
-- por parámetro y retorne el salario por hora correspondiente al usuario
GO
CREATE OR ALTER FUNCTION dbo.funRetornaSalarioPorRegistroAsignacion (
	@pIdRegistro INT
)
RETURNS DECIMAL(18,0) AS
BEGIN
	DECLARE
	@salario DECIMAL(18,0);
	SELECT @salario = dbo.funRetornaSalarioPorIdUsuario(RUP.idUsuario)
	FROM RolUsuarioProyecto AS RUP
	WHERE idpRolUsuarioProyecto = @pIdRegistro;
	RETURN @salario;
END
GO
select * from RolUsuarioProyecto;
SELECT dbo.funRetornaSalarioPorRegistroAsignacion(1) AS costoHora;
--DROP FUNCTION funRetornaSalarioPorRegistroAsignacion;


-- Función 5: Reciba id de la tarea por parámetro
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

SELECT dbo.funRetornaSalarioPorIdUsuario('104') AS Duracion;
--DROP FUNCTION funRetornaSalarioPorIdUsuario;


-- Funcion 6
GO
CREATE OR ALTER FUNCTION dbo.funRetornaProyectosPorEstado (
	@pEstado VARCHAR(20)
)
RETURNS TABLE AS
RETURN
	SELECT *
	FROM vDesgloseProyecto
	WHERE estado = @pEstado;
GO

SELECT * FROM dbo.funRetornaProyectosPorEstado('estudio') AS Proyectos;
--DROP FUNCTION funRetornaSalarioPorIdUsuario;
