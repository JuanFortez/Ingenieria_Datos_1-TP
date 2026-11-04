/* ====== TRIGGERS ====== */
USE Sistema_de_Gestion_Salud_Clinica_Samuel;
GO

-- Trigger para validar que el profesional no se le asigne doble turno en la misma fecha y hora
CREATE TRIGGER TR_TURNOS_validar_doble_reserva
ON TURNOS
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
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
            RAISERROR('El profesional ya tiene un turno asignado en esa fecha y hora.', 16, 1);
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- Trigger para modificar estado de turno
CREATE TRIGGER TR_TURNOS_estado
ON TURNOS
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF EXISTS (
            SELECT *
            FROM deleted D
            WHERE D.TUR_ESTADO = 'FINALIZADO'
        )
        BEGIN
            RAISERROR('No se puede modificar un turno finalizado.', 16, 1);
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
            RAISERROR('Transicion de estado de turno no permitida.', 16, 1);
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- Trigger para asignar automáticamente departamento a un estudio solicitado
CREATE TRIGGER TR_ESO_asignar_departamento
ON ESTUDIOS_SOLICITADOS
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        UPDATE ES
        SET ES.ESO_DEPARTAMENTO = D.DEPTO_CODIGO
        FROM ESTUDIOS_SOLICITADOS ES
        INNER JOIN inserted I ON I.ESO_CODIGO = ES.ESO_CODIGO
        INNER JOIN ATENCIONES_MEDICAS AM ON AM.AM_CODIGO = I.ESO_ATENCION
        INNER JOIN TURNOS T ON T.TUR_CODIGO = AM.AM_TURNO
        INNER JOIN PROFESIONALES P ON P.PRO_CODIGO = T.TUR_PROFESIONAL
        INNER JOIN DEPARTAMENTOS D ON D.DEPTO_ESPECIALIDAD = P.PRO_ESPECIALIDAD
        WHERE ES.ESO_DEPARTAMENTO IS NULL OR ES.ESO_DEPARTAMENTO <> D.DEPTO_CODIGO;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- Trigger para evitar que se borre un turno con atención médica ya registrada
CREATE TRIGGER TR_TURNOS_no_borrar_con_atencion
ON TURNOS
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF EXISTS (
            SELECT *
            FROM deleted D
            INNER JOIN ATENCIONES_MEDICAS AM ON AM.AM_TURNO = D.TUR_CODIGO
        )
        BEGIN
            RAISERROR('No se puede eliminar un turno que tiene una atencion asociada.', 16, 1);
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
