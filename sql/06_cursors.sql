/* ====== CURSORS ====== */
USE Sistema_de_Gestion_Salud_Clinica_Samuel;
GO

/* --------------------------------------------------------------------------
   Un cursor recorre el resultado de un SELECT fila por fila, para hacer algo
   distinto con cada una (llamar a un procedure, imprimir, decidir con IF).
   Ciclo de vida:
     DECLARE  -> define el SELECT que se va a recorrer
     OPEN     -> ejecuta el SELECT
     FETCH    -> trae la fila siguiente a variables
     @@FETCH_STATUS = 0 -> mientras haya filas
     CLOSE / DEALLOCATE -> libera el cursor (siempre hay que hacerlo)
   LOCAL FAST_FORWARD: cursor visible solo en este procedure, de solo lectura y
   que avanza hacia adelante; es la opcion mas liviana.
   Nota: cuando la misma operacion se puede hacer con un unico UPDATE o INSERT
   ... SELECT conviene no usar cursor (es mas lento). Se usa cuando cada fila
   necesita un tratamiento propio, como en estos dos casos.
   -------------------------------------------------------------------------- */


-- CURSOR 1: facturacion masiva.
-- Recorre las atenciones sin factura que tienen estudios REALIZADOS y llama a
-- Proc_FacturarAtencion para cada una. Si una falla, informa el error y sigue
-- con la siguiente (cada factura es una transaccion independiente).
CREATE PROCEDURE Proc_FacturarAtencionesPendientes
    @medio_pago VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @atencion INT;
    DECLARE @factura INT;
    DECLARE @facturadas INT = 0;
    DECLARE @con_error INT = 0;

    DECLARE cur_atenciones CURSOR LOCAL FAST_FORWARD FOR
        SELECT AM.AM_CODIGO
        FROM ATENCIONES_MEDICAS AM
        WHERE NOT EXISTS (SELECT 1 FROM FACTURACIONES F WHERE F.FACT_ATENCION = AM.AM_CODIGO)
          AND EXISTS (
              SELECT 1
              FROM ESTUDIOS_SOLICITADOS ES
              WHERE ES.ESO_ATENCION = AM.AM_CODIGO
                AND ES.ESO_ESTADO = 'REALIZADO'
          )
        ORDER BY AM.AM_CODIGO;

    OPEN cur_atenciones;
    FETCH NEXT FROM cur_atenciones INTO @atencion;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        BEGIN TRY
            EXEC Proc_FacturarAtencion
                @atencion = @atencion,
                @medio_pago = @medio_pago,
                @factura_creada = @factura OUTPUT;

            SET @facturadas = @facturadas + 1;
            PRINT CONCAT('Atencion ', @atencion, ': factura ', @factura, ' generada.');
        END TRY
        BEGIN CATCH
            SET @con_error = @con_error + 1;
            PRINT CONCAT('Atencion ', @atencion, ': no se pudo facturar. ', ERROR_MESSAGE());
        END CATCH

        FETCH NEXT FROM cur_atenciones INTO @atencion;
    END

    CLOSE cur_atenciones;
    DEALLOCATE cur_atenciones;

    PRINT CONCAT('Facturas generadas: ', @facturadas, '. Con error: ', @con_error, '.');
END
GO

-- CURSOR 2: reporte de actividad por profesional.
-- Recorre los profesionales y, para cada uno, calcula sus totales de turnos e
-- imprime una linea de resumen. Los profesionales sin turnos tambien aparecen.
CREATE PROCEDURE Proc_ReporteActividadProfesionales
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @codigo INT;
    DECLARE @nombre VARCHAR(60);
    DECLARE @especialidad VARCHAR(50);
    DECLARE @finalizados INT;
    DECLARE @ausentes INT;
    DECLARE @cancelados INT;
    DECLARE @proximos INT;

    DECLARE cur_profesionales CURSOR LOCAL FAST_FORWARD FOR
        SELECT P.PRO_CODIGO, CONCAT(P.PRO_NOMBRE, ' ', P.PRO_APELLIDO), E.ESP_NOMBRE
        FROM PROFESIONALES P
        INNER JOIN ESPECIALIDADES E ON E.ESP_CODIGO = P.PRO_ESPECIALIDAD
        ORDER BY E.ESP_NOMBRE, P.PRO_APELLIDO;

    OPEN cur_profesionales;
    FETCH NEXT FROM cur_profesionales INTO @codigo, @nombre, @especialidad;

    PRINT 'ACTIVIDAD POR PROFESIONAL';
    PRINT '-------------------------';

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- ISNULL: si el profesional no tiene turnos, SUM devuelve NULL y se reemplaza por 0
        SELECT
            @finalizados = ISNULL(SUM(CASE WHEN TUR_ESTADO = 'FINALIZADO' THEN 1 ELSE 0 END), 0),
            @ausentes    = ISNULL(SUM(CASE WHEN TUR_ESTADO = 'AUSENTE' THEN 1 ELSE 0 END), 0),
            @cancelados  = ISNULL(SUM(CASE WHEN TUR_ESTADO = 'CANCELADO' THEN 1 ELSE 0 END), 0),
            @proximos    = ISNULL(SUM(CASE WHEN TUR_ESTADO IN ('PENDIENTE', 'CONFIRMADO')
                                            AND TUR_FECHA >= CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END), 0)
        FROM TURNOS
        WHERE TUR_PROFESIONAL = @codigo;

        PRINT CONCAT(@nombre, ' (', @especialidad, '): ',
                     @finalizados, ' atendidos, ',
                     @ausentes, ' ausentes, ',
                     @cancelados, ' cancelados, ',
                     @proximos, ' proximos.');

        IF @finalizados = 0 AND @proximos = 0
            PRINT '   -> Sin actividad registrada.';

        FETCH NEXT FROM cur_profesionales INTO @codigo, @nombre, @especialidad;
    END

    CLOSE cur_profesionales;
    DEALLOCATE cur_profesionales;
END
GO

/* Ejemplos de uso (los mensajes aparecen en la pestania "Messages" de SSMS):

EXEC Proc_FacturarAtencionesPendientes @medio_pago = 'DEBITO';

EXEC Proc_ReporteActividadProfesionales;
*/
