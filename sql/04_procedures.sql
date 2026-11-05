/* ====== PROCEDURES ====== */
USE Sistema_de_Gestion_Salud_Clinica_Samuel;
GO

-- Procedure para agregar PACIENTE
-- Valida que el CUIT no este repetido y que el plan exista.
CREATE PROCEDURE Proc_AgregarPaciente
    @cuit CHAR(11), 
    @nombre VARCHAR(25), 
    @apellido VARCHAR(25), 
    @fecha_nacimiento DATE, 
    @direccion VARCHAR(100),
    @telefono VARCHAR(20),
    @mail VARCHAR(100),
    @plan INT
AS 
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF EXISTS (SELECT * FROM PACIENTES WHERE PAC_CUIT = @cuit)
            RAISERROR('Ya existe un paciente con ese CUIT.', 16, 1);

        IF NOT EXISTS (SELECT * FROM PLANES WHERE PLAN_CODIGO = @plan)
            RAISERROR('El plan indicado no existe.', 16, 1);

        INSERT INTO PACIENTES(
            PAC_CUIT, PAC_NOMBRE, PAC_APELLIDO, PAC_FECHA_NACIMIENTO, PAC_DIRECCION, PAC_TELEFONO, PAC_EMAIL, COD_PLAN
        )
        VALUES(
            @cuit, @nombre, @apellido, @fecha_nacimiento, @direccion, @telefono, @mail, @plan
        );
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END 
GO

-- Procedure para agregar PROFESIONAL
-- Valida que el CUIT no este repetido y que la especialidad exista.
CREATE PROCEDURE Proc_AgregarProfesional
    @cuit CHAR(11), 
    @nombre VARCHAR(25), 
    @apellido VARCHAR(25), 
    @fecha_nacimiento DATE, 
    @direccion VARCHAR(100),
    @telefono VARCHAR(20),
    @mail VARCHAR(100),
    @especialidad INT
AS 
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF EXISTS (SELECT * FROM PROFESIONALES WHERE PRO_CUIT = @cuit)
            RAISERROR('Ya existe un profesional con ese CUIT.', 16, 1);

        IF NOT EXISTS (SELECT * FROM ESPECIALIDADES WHERE ESP_CODIGO = @especialidad)
            RAISERROR('La especialidad indicada no existe.', 16, 1);

        INSERT INTO PROFESIONALES(
            PRO_CUIT, PRO_NOMBRE, PRO_APELLIDO, PRO_FECHA_NACIMIENTO, PRO_DIRECCION, PRO_TELEFONO, PRO_EMAIL, PRO_ESPECIALIDAD
        )
        VALUES(
            @cuit, @nombre, @apellido, @fecha_nacimiento, @direccion, @telefono, @mail, @especialidad
        );
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- Procedure para buscar DNI Paciente
CREATE PROCEDURE Proc_Buscar_DNI_Paciente
    @dni INT 
AS 
BEGIN 
	SELECT PAC_CODIGO, PAC_CUIT, PAC_NOMBRE, PAC_APELLIDO, PAC_DIRECCION, PAC_TELEFONO, PAC_EMAIL, PAC_OBSERVACION, COD_PLAN
	FROM PACIENTES
	WHERE SUBSTRING(PAC_CUIT, 3,8) = @dni;
END
GO

-- Procedure para buscar DNI Profesional
CREATE PROCEDURE Proc_Buscar_DNI_Profesional
    @dni INT 
AS 
BEGIN 
	SELECT PRO_CODIGO, PRO_CUIT, PRO_NOMBRE, PRO_APELLIDO, PRO_DIRECCION, PRO_TELEFONO, PRO_EMAIL, PRO_OBSERVACION, PRO_ESPECIALIDAD
	FROM PROFESIONALES
	WHERE SUBSTRING (PRO_CUIT, 3,8)= @dni;
END
GO

-- Procedure para buscar TURNOS por DNI
CREATE PROCEDURE Proc_BuscarTurnosPorDNI
    @dni INT
AS
BEGIN
    SELECT 
        T.TUR_CODIGO,T.TUR_FECHA, T.TUR_HORA, T.TUR_ESTADO,T.TUR_TIPO_TURNO, P.PAC_NOMBRE, P.PAC_APELLIDO, P.PAC_CUIT
    FROM TURNOS T
    INNER JOIN PACIENTES P ON T.TUR_PACIENTE = P.PAC_CODIGO
    WHERE SUBSTRING(P.PAC_CUIT, 3, 8) = @dni;
END 
GO

-- Procedure para REGISTRAR UN TURNO
/*
    Valida paciente, fecha y que el consultorio sea de la especialidad del profesional.
    La doble reserva del profesional la controla el trigger TR_TURNOS_validar_doble_reserva
    y la del consultorio la constraint UQ_TUR_CONSULTORIO_FECHA_HORA.
    Devuelve el codigo del turno creado en el parametro de salida @turno_creado.
*/
CREATE PROCEDURE Proc_RegistrarTurno
    @paciente INT,
    @profesional INT,          -- NULL si el turno es de tipo ESTUDIO
    @consultorio INT,
    @fecha DATE,
    @hora TIME(0),
    @tipo_turno VARCHAR(20),
    @turno_creado INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM PACIENTES WHERE PAC_CODIGO = @paciente)
            THROW 50001, 'El paciente no existe.', 1;

        IF @fecha < CAST(GETDATE() AS DATE)
            THROW 50002, 'No se puede registrar un turno en una fecha pasada.', 1;

        IF @tipo_turno = 'CONSULTA'
        BEGIN
            IF @profesional IS NULL
                THROW 50003, 'Un turno de CONSULTA requiere un profesional.', 1;

            IF NOT EXISTS (
                SELECT 1
                FROM PROFESIONALES P
                INNER JOIN CONSULTORIOS C ON C.COD_ESPECIALIDAD = P.PRO_ESPECIALIDAD
                WHERE P.PRO_CODIGO = @profesional
                  AND C.CONS_CODIGO = @consultorio
            )
                THROW 50004, 'El consultorio no corresponde a la especialidad del profesional.', 1;
        END

        INSERT INTO TURNOS (TUR_PACIENTE, TUR_PROFESIONAL, TUR_CONSULTORIO, TUR_FECHA, TUR_HORA, TUR_ESTADO, TUR_TIPO_TURNO)
        VALUES (@paciente, @profesional, @consultorio, @fecha, @hora, 'PENDIENTE', @tipo_turno);

        SET @turno_creado = SCOPE_IDENTITY();   -- ultimo IDENTITY generado en este procedure
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- Procedure para REGISTRAR UNA ATENCION MEDICA
/*
    En una sola transaccion: crea la atencion, carga los estudios solicitados y pasa
    el turno a FINALIZADO. Si algo falla, no queda nada a medias.
    @estudios: codigos de ESTUDIOS separados por coma, por ejemplo '1,2'. NULL si no se piden.
*/
CREATE PROCEDURE Proc_RegistrarAtencion
    @turno INT,
    @motivo VARCHAR(150),
    @diagnostico VARCHAR(250),
    @observaciones VARCHAR(250),
    @estudios VARCHAR(200),
    @atencion_creada INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM TURNOS WHERE TUR_CODIGO = @turno)
            THROW 50011, 'El turno no existe.', 1;

        IF NOT EXISTS (SELECT 1 FROM TURNOS WHERE TUR_CODIGO = @turno AND TUR_TIPO_TURNO = 'CONSULTA')
            THROW 50012, 'Solo se registran atenciones en turnos de tipo CONSULTA.', 1;

        IF EXISTS (SELECT 1 FROM ATENCIONES_MEDICAS WHERE AM_TURNO = @turno)
            THROW 50013, 'El turno ya tiene una atencion registrada.', 1;

        IF NOT EXISTS (SELECT 1 FROM TURNOS WHERE TUR_CODIGO = @turno AND TUR_ESTADO = 'CONFIRMADO')
            THROW 50014, 'El turno debe estar CONFIRMADO para registrar la atencion.', 1;

        SET @estudios = NULLIF(LTRIM(RTRIM(@estudios)), '');   -- '' se trata igual que NULL

        -- STRING_SPLIT separa la lista '1,2' en filas (requiere SQL Server 2016 o superior)
        IF EXISTS (
            SELECT 1
            FROM STRING_SPLIT(@estudios, ',') S
            WHERE TRY_CAST(S.value AS INT) IS NULL
               OR NOT EXISTS (SELECT 1 FROM ESTUDIOS E WHERE E.EST_CODIGO = TRY_CAST(S.value AS INT))
        )
            THROW 50015, 'La lista de estudios contiene un codigo inexistente.', 1;

        BEGIN TRANSACTION;

            INSERT INTO ATENCIONES_MEDICAS (AM_TURNO, AM_MOTIVO_CONSULTA, AM_DIAGNOSTICO, AM_OBSERVACIONES)
            VALUES (@turno, @motivo, @diagnostico, @observaciones);

            SET @atencion_creada = SCOPE_IDENTITY();

            INSERT INTO ESTUDIOS_SOLICITADOS (ESO_ATENCION, ESO_ESTUDIO, ESO_ESTADO)
            SELECT DISTINCT @atencion_creada, CAST(S.value AS INT), 'PENDIENTE'
            FROM STRING_SPLIT(@estudios, ',') S;

            UPDATE TURNOS
            SET TUR_ESTADO = 'FINALIZADO'
            WHERE TUR_CODIGO = @turno;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- Procedure para CANCELAR UN TURNO
/*
    En una sola transaccion: cancela el turno y, si era un turno de ESTUDIO, libera los
    estudios solicitados que estaban programados en el (vuelven a PENDIENTE sin turno).
    Las transiciones de estado permitidas las controla el trigger TR_TURNOS_estado.
*/
CREATE PROCEDURE Proc_CancelarTurno
    @turno INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM TURNOS WHERE TUR_CODIGO = @turno)
            THROW 50031, 'El turno no existe.', 1;

        BEGIN TRANSACTION;

            UPDATE TURNOS
            SET TUR_ESTADO = 'CANCELADO'
            WHERE TUR_CODIGO = @turno;

            UPDATE ESTUDIOS_SOLICITADOS
            SET ESO_ESTADO = 'PENDIENTE',
                ESO_TURNO = NULL
            WHERE ESO_TURNO = @turno
              AND ESO_ESTADO = 'PROGRAMADO';

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO