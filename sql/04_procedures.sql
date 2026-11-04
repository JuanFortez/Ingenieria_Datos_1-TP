/* ====== PROCEDURES ====== */

-- Procedure para agregar PACIENTE
CREATE PROCEDURE Proc_AgregarPaciente
    @cuit CHAR(11), 
    @nombre VARCHAR(25), 
    @apellido VARCHAR(25), 
    @fecha_nacimiento DATE, 
    @direccion VARCHAR(100),
    @telefono VARCHAR(20),
    @mail VARCHAR(100),
    @cobertura INT
AS 
	INSERT INTO PACIENTES( PAC_CUIT, PAC_NOMBRE, PAC_APELLIDO, PAC_FECHA_NACIMIENTO, PAC_DIRECCION, PAC_TELEFONO, PAC_EMAIL, COD_COBERTURA)
	VALUES( @cuit, @nombre ,@apellido, @fecha_nacimiento, @direccion , @telefono, @mail,@cobertura );
END 
GO

-- Procedure para agregar PROFESIONAL
CREATE PROCEDURE Proc_AgregarProfesional
    @cuit CHAR(11), 
    @nombre VARCHAR(25), 
    @apellido VARCHAR(25), 
    @fecha_nacimiento DATE, 
    @direccion VARCHAR(100),
    @telefono VARCHAR(20),
    @mail VARCHAR(100),
    @especialidad INT,
    @cobertura INT
AS 
	INSERT INTO PROFESIONALES( PRO_CUIT, PRO_NOMBRE, PRO_APELLIDO, PRO_FECHA_NACIMIENTO, PRO_DIRECCION, PRO_TELEFONO, PRO_EMAIL, PRO_ESPECIALIDAD)
	VALUES( @cuit, @nombre ,@apellido, @fecha_nacimiento, @direccion ,@telefono,@mail,@especialidad );
END
GO

-- Procedure para buscar DNI Paciente
CREATE PROCEDURE Proc_Buscar_DNI_Paciente
    @dni INT 
AS 
BEGIN 
	SELECT PAC_CODIGO, PAC_CUIT, PAC_NOMBRE, PAC_APELLIDO, PAC_DIRECCION, PAC_TELEFONO, PAC_EMAIL, PAC_OBSERVACION, COD_COBERTURA
	FROM PACIENTES
	WHERE SUBSTRING (PAC_CUIT, 3,8)= @dni;
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
