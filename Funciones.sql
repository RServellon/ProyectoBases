-- Funciones

-- Calcular costo estimado de una tarea padre
-- Se puede usar en un trigger para actualizar los valores
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

-- Actualizar horas estimadas al ingresar una tarea hija
-- Se puede usar en un trigger para actualizar valores
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


-- Reciba id del usuario y retorne el salario por hora
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


-- Reciba id del registro y retorne el salario por hora
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

SELECT dbo.funRetornaSalarioPorRegistroAsignacion(1) AS costoHora;
--DROP FUNCTION funRetornaSalarioPorRegistroAsignacion;