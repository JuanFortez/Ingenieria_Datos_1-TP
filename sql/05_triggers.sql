/* ====== TRIGGERS ====== */

CREATE TRIGGER TR_TURNOS_validar_doble_reserva
ON TURNOS
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM inserted I
        INNER JOIN TURNOS T 
            ON T.TUR_PROFESIONAL = I.TUR_PROFESIONAL 
            AND T.TUR_FECHA = I.TUR_FECHA 
            AND T.TUR_HORA = I.TUR_HORA 
            AND T.TUR_CODIGO <> I.TUR_CODIGO
        WHERE I.TUR_PROFESIONAL IS NOT NULL
            AND I.TUR_ESTADO NOT IN ('CANCELADO', 'AUSENTE')
            AND T.TUR_ESTADO NOT IN ('CANCELADO', 'AUSENTE')
    )
    BEGIN
        PRINT('El profesional ya tiene un turno asignado en esa fecha y hora.');
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

CREATE TRIGGER TR_TURNOS_estado
ON TURNOS
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM deleted D
        WHERE D.TUR_ESTADO = 'FINALIZADO'
    )
    BEGIN
        PRINT('No se puede modificar un turno finalizado.');
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF EXISTS (
        SELECT *
        FROM inserted I
        INNER JOIN deleted D ON D.TUR_CODIGO = I.TUR_CODIGO
        WHERE I.TUR_ESTADO <> D.TUR_ESTADO 
        AND NOT ((D.TUR_ESTADO = 'PENDIENTE' AND I.TUR_ESTADO IN ('CONFIRMADO', 'CANCELADO', 'AUSENTE')) 
                OR (D.TUR_ESTADO = 'CONFIRMADO' AND I.TUR_ESTADO IN ('FINALIZADO', 'CANCELADO', 'AUSENTE')))
    )
    BEGIN
        PRINT('Transicion de estado de turno no permitida.');
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO
