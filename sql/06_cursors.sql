/* ====== CURSORES ====== */
USE Sistema_de_Gestion_Salud_Clinica_Samuel;
GO

SET NOCOUNT ON;
GO

DECLARE @tur_codigo INT;
DECLARE @turnos_marcados INT = 0;

-- Recorre los turnos PENDIENTE con fecha pasada y los marca como AUSENTE
DECLARE cur_turnos_vencidos CURSOR FOR
    SELECT TUR_CODIGO
    FROM TURNOS
    WHERE TUR_ESTADO = 'PENDIENTE' AND TUR_FECHA < CAST(GETDATE() AS DATE);

BEGIN TRY
    BEGIN TRANSACTION;

    OPEN cur_turnos_vencidos;

    FETCH NEXT FROM cur_turnos_vencidos INTO @tur_codigo;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE TURNOS
        SET TUR_ESTADO = 'AUSENTE'
        WHERE TUR_CODIGO = @tur_codigo AND TUR_ESTADO = 'PENDIENTE';

        SET @turnos_marcados = @turnos_marcados + @@ROWCOUNT;

        FETCH NEXT FROM cur_turnos_vencidos INTO @tur_codigo;
    END

    CLOSE cur_turnos_vencidos;
    DEALLOCATE cur_turnos_vencidos;

    PRINT 'Turnos vencidos marcados como AUSENTE: ' + CAST(@turnos_marcados AS VARCHAR(10));
END TRY
BEGIN CATCH
    IF CURSOR_STATUS('local', 'cur_turnos_vencidos') = 1
        CLOSE cur_turnos_vencidos;

    IF CURSOR_STATUS('local', 'cur_turnos_vencidos') >= 0
        DEALLOCATE cur_turnos_vencidos;

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'Error en cur_turnos_vencidos: ' + ERROR_MESSAGE();
    THROW;
END CATCH;
GO


DECLARE @am_codigo INT;
DECLARE @fact_codigo INT;
DECLARE @monto_total DECIMAL(10,2);
DECLARE @facturas_generadas INT = 0;
DECLARE @medio_pago VARCHAR(20) = 'EFECTIVO';

-- Genera la factura y sus detalles para las atenciones FINALIZADAS que aún no fueron facturadas.
DECLARE cur_facturacion_masiva CURSOR FAST_FORWARD FOR
    SELECT AM.AM_CODIGO, ISNULL(SUM(E.EST_PRECIO_BASE), 0) AS MONTO_TOTAL
    FROM ATENCIONES_MEDICAS AM
    INNER JOIN TURNOS T ON T.TUR_CODIGO = AM.AM_TURNO
    LEFT JOIN ESTUDIOS_SOLICITADOS ESO ON ESO.ESO_ATENCION = AM.AM_CODIGO AND ESO.ESO_ESTADO <> 'CANCELADO'
    LEFT JOIN ESTUDIOS E ON E.EST_CODIGO = ESO.ESO_ESTUDIO
    WHERE T.TUR_ESTADO = 'FINALIZADO' AND NOT EXISTS (
          SELECT *
          FROM FACTURACIONES F
          WHERE F.FACT_ATENCION = AM.AM_CODIGO
    )
    GROUP BY AM.AM_CODIGO;

BEGIN TRY
    BEGIN TRANSACTION;

    OPEN cur_facturacion_masiva;

    FETCH NEXT FROM cur_facturacion_masiva INTO @am_codigo, @monto_total;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO FACTURACIONES (FACT_ATENCION, FACT_MONTO_TOTAL, FACT_MEDIO_PAGO, FACT_ESTADO_PAGO)
        VALUES (@am_codigo, @monto_total, @medio_pago, 'PENDIENTE');

        SET @fact_codigo = SCOPE_IDENTITY();

        INSERT INTO DETALLES_FACTURAS (DF_FACTURA, DF_ESTUDIO_SOLICITADO, DF_MONTO_TOTAL)
        SELECT @fact_codigo, ESO.ESO_CODIGO, E.EST_PRECIO_BASE
        FROM ESTUDIOS_SOLICITADOS ESO
        INNER JOIN ESTUDIOS E ON E.EST_CODIGO = ESO.ESO_ESTUDIO
        WHERE ESO.ESO_ATENCION = @am_codigo AND ESO.ESO_ESTADO <> 'CANCELADO';

        SET @facturas_generadas = @facturas_generadas + 1;

        FETCH NEXT FROM cur_facturacion_masiva INTO @am_codigo, @monto_total;
    END

    CLOSE cur_facturacion_masiva;
    DEALLOCATE cur_facturacion_masiva;

    PRINT 'Facturas generadas: ' + CAST(@facturas_generadas AS VARCHAR(10));
END TRY
BEGIN CATCH
    IF CURSOR_STATUS('local', 'cur_facturacion_masiva') = 1
        CLOSE cur_facturacion_masiva;

    IF CURSOR_STATUS('local', 'cur_facturacion_masiva') >= 0
        DEALLOCATE cur_facturacion_masiva;

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'Error en cur_facturacion_masiva: ' + ERROR_MESSAGE();
    THROW;
END CATCH;
GO

-- Reporte de actividad por profesional.

SET NOCOUNT ON;

DECLARE @codigo INT;
DECLARE @nombre VARCHAR(60);
DECLARE @especialidad VARCHAR(50);
DECLARE @finalizados INT;
DECLARE @ausentes INT;
DECLARE @cancelados INT;
DECLARE @proximos INT;

DECLARE cur_profesionales CURSOR FOR
    SELECT P.PRO_CODIGO, CONCAT(P.PRO_NOMBRE, ' ', P.PRO_APELLIDO), E.ESP_NOMBRE
    FROM PROFESIONALES P
    INNER JOIN ESPECIALIDADES E ON E.ESP_CODIGO = P.PRO_ESPECIALIDAD
    ORDER BY E.ESP_NOMBRE, P.PRO_APELLIDO;

BEGIN TRY
    OPEN cur_profesionales;
    FETCH NEXT FROM cur_profesionales INTO @codigo, @nombre, @especialidad;

    PRINT 'ACTIVIDAD POR PROFESIONAL';
    PRINT '-------------------------';

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- ISNULL: si el profesional no tiene turnos, SUM devuelve NULL y se reemplaza por 0
        SELECT
            @finalizados = ISNULL(SUM(CASE WHEN TUR_ESTADO = 'FINALIZADO' THEN 1 ELSE 0 END), 0),
            @ausentes = ISNULL(SUM(CASE WHEN TUR_ESTADO = 'AUSENTE' THEN 1 ELSE 0 END), 0),
            @cancelados = ISNULL(SUM(CASE WHEN TUR_ESTADO = 'CANCELADO' THEN 1 ELSE 0 END), 0),
            @proximos = ISNULL(SUM(CASE WHEN TUR_ESTADO IN ('PENDIENTE', 'CONFIRMADO') AND TUR_FECHA >= CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END), 0)
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
END TRY
BEGIN CATCH
    IF CURSOR_STATUS('local', 'cur_profesionales') = 1
        CLOSE cur_profesionales;

    IF CURSOR_STATUS('local', 'cur_profesionales') >= 0
        DEALLOCATE cur_profesionales;

    PRINT CONCAT('Error en cur_profesionales: ', ERROR_MESSAGE());
    THROW;
END CATCH;
GO