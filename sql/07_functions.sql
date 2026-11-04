/* ====== FUNCTIONS ====== */
USE Sistema_de_Gestion_Salud_Clinica_Samuel;
GO

/* --------------------------------------------------------------------------
   Diferencias con un procedure:
     - Una funcion SIEMPRE devuelve un valor (escalar) o una tabla.
     - Se usa DENTRO de una consulta (SELECT, WHERE, JOIN), no con EXEC.
     - No puede modificar datos de las tablas (INSERT/UPDATE/DELETE sobre tablas
       reales) ni manejar transacciones: solo calcula y devuelve.
   Tipos usados en este archivo:
     - Escalar: devuelve un unico valor.
     - Con valores de tabla en linea (inline): un solo SELECT; se comporta como
       una vista con parametros.
     - Con valores de tabla de varias instrucciones (multi-statement): arma la
       tabla resultado paso a paso (variables, IF, WHILE).
   -------------------------------------------------------------------------- */


-- FUNCION ESCALAR: edad de una persona a la fecha de hoy.
-- DATEDIFF(YEAR, ...) solo resta los anios y falla si todavia no paso el cumpleanios
-- (para alguien nacido el 20/12/2000, el 01/11/2026 devolveria 26 en vez de 25).
-- Por eso se resta 1 cuando el cumpleanios de este anio todavia no llego.
CREATE FUNCTION Fn_Edad (@fecha_nacimiento DATE)
RETURNS INT
AS
BEGIN
    DECLARE @hoy DATE = CAST(GETDATE() AS DATE);
    DECLARE @edad INT = DATEDIFF(YEAR, @fecha_nacimiento, @hoy);

    IF DATEADD(YEAR, @edad, @fecha_nacimiento) > @hoy
        SET @edad = @edad - 1;

    RETURN @edad;
END
GO

-- FUNCION ESCALAR: DNI a partir del CUIT.
-- El CUIT se forma con 2 digitos de tipo + 8 del DNI + 1 digito verificador,
-- por eso el DNI no se guarda aparte (seria un dato redundante: CUIT -> DNI).
CREATE FUNCTION Fn_DNIDesdeCUIT (@cuit CHAR(11))
RETURNS CHAR(8)
AS
BEGIN
    RETURN SUBSTRING(@cuit, 3, 8);
END
GO

-- FUNCION DE TABLA EN LINEA: ingresos por consultas de un mes y anio cualquiera.
-- Version con parametros de la vista INGRESO_POR_PACIENTE_POR_MES (que tiene octubre
-- fijo). Cuenta solo consultas FINALIZADAS: un turno cancelado o ausente no genera cobro.
CREATE FUNCTION Fn_IngresosConsultasPorMes (@anio INT, @mes INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        P.PAC_CODIGO,
        P.PAC_APELLIDO,
        P.PAC_NOMBRE,
        C.COB_NOMBRE,
        C.COB_PLAN,
        COUNT(*) AS CANTIDAD_CONSULTAS,
        C.COB_PAGO_CONSULTA,
        COUNT(*) * C.COB_PAGO_CONSULTA AS INGRESO_TOTAL
    FROM TURNOS T
    INNER JOIN PACIENTES P ON P.PAC_CODIGO = T.TUR_PACIENTE
    INNER JOIN COBERTURAS C ON C.COB_CODIGO = P.COD_COBERTURA
    WHERE T.TUR_TIPO_TURNO = 'CONSULTA'
      AND T.TUR_ESTADO = 'FINALIZADO'
      AND YEAR(T.TUR_FECHA) = @anio
      AND MONTH(T.TUR_FECHA) = @mes
    GROUP BY P.PAC_CODIGO, P.PAC_APELLIDO, P.PAC_NOMBRE, C.COB_NOMBRE, C.COB_PLAN, C.COB_PAGO_CONSULTA
);
GO

-- FUNCION DE TABLA EN LINEA: historial completo de un paciente.
-- Turnos (consultas y estudios) con profesional, especialidad y diagnostico.
-- LEFT JOIN porque los turnos de estudio no tienen profesional y los turnos
-- pendientes, cancelados o ausentes no tienen atencion.
CREATE FUNCTION Fn_HistorialPaciente (@paciente INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        T.TUR_CODIGO,
        T.TUR_FECHA,
        T.TUR_HORA,
        T.TUR_TIPO_TURNO,
        T.TUR_ESTADO,
        PR.PRO_NOMBRE + ' ' + PR.PRO_APELLIDO AS PROFESIONAL,   -- con + queda NULL si no hay profesional
        ES.ESP_NOMBRE AS ESPECIALIDAD,
        AM.AM_MOTIVO_CONSULTA,
        AM.AM_DIAGNOSTICO
    FROM TURNOS T
    LEFT JOIN PROFESIONALES PR ON PR.PRO_CODIGO = T.TUR_PROFESIONAL
    LEFT JOIN ESPECIALIDADES ES ON ES.ESP_CODIGO = PR.PRO_ESPECIALIDAD
    LEFT JOIN ATENCIONES_MEDICAS AM ON AM.AM_TURNO = T.TUR_CODIGO
    WHERE T.TUR_PACIENTE = @paciente
);
GO

-- FUNCION DE TABLA DE VARIAS INSTRUCCIONES: agenda de un profesional en un dia.
-- Genera los horarios de 08:00 a 17:30 cada 30 minutos con un WHILE e indica si
-- cada uno esta LIBRE u OCUPADO (los turnos cancelados o ausentes liberan el horario).
CREATE FUNCTION Fn_AgendaProfesional (@profesional INT, @fecha DATE)
RETURNS @agenda TABLE (
    HORA TIME(0),
    ESTADO VARCHAR(10),
    TURNO INT,
    PACIENTE VARCHAR(60)
)
AS
BEGIN
    DECLARE @hora TIME(0) = '08:00';

    WHILE @hora <= '17:30'
    BEGIN
        INSERT INTO @agenda (HORA, ESTADO, TURNO, PACIENTE)
        SELECT @hora, 'LIBRE', NULL, NULL;

        SET @hora = DATEADD(MINUTE, 30, @hora);
    END

    UPDATE A
    SET A.ESTADO = 'OCUPADO',
        A.TURNO = T.TUR_CODIGO,
        A.PACIENTE = CONCAT(P.PAC_NOMBRE, ' ', P.PAC_APELLIDO)
    FROM @agenda A
    INNER JOIN TURNOS T ON T.TUR_HORA = A.HORA
    INNER JOIN PACIENTES P ON P.PAC_CODIGO = T.TUR_PACIENTE
    WHERE T.TUR_PROFESIONAL = @profesional
      AND T.TUR_FECHA = @fecha
      AND T.TUR_ESTADO NOT IN ('CANCELADO', 'AUSENTE');

    RETURN;
END
GO

/* Ejemplos de uso:

SELECT PAC_NOMBRE, PAC_APELLIDO, PAC_FECHA_NACIMIENTO, dbo.Fn_Edad(PAC_FECHA_NACIMIENTO) AS EDAD
FROM PACIENTES;

SELECT PAC_CUIT, dbo.Fn_DNIDesdeCUIT(PAC_CUIT) AS DNI FROM PACIENTES;

SELECT * FROM Fn_IngresosConsultasPorMes(2026, 9);

SELECT * FROM Fn_HistorialPaciente(3) ORDER BY TUR_FECHA, TUR_HORA;

SELECT * FROM Fn_AgendaProfesional(1, '2026-10-14');
*/
