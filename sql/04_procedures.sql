/* ====== PROCEDURES ====== */
CREATE PROCEDURE Proc_AgregarPaciente
    @cuit char(11), 
    @nombre varchar(25), 
    @apellido varchar(25), 
    @fecha_nacimiento date, 
    @direccion varchar(100),
    @telefono varchar(20),
    @mail varchar(100),
    @cobertura int
as 
	insert into Pacientes( pac_cuit, pac_nombre, pac_apellido, pac_fecha_nacimiento, pac_direccion, pac_telefono, pac_email, cod_cobertura)
	values( @cuit, @nombre ,@apellido, @fecha_nacimiento, @direccion ,@telefono,@mail,@cobertura );
end 
go


CREATE PROCEDURE Proc_AgregarProfesional
    @cuit char(11), 
    @nombre varchar(25), 
    @apellido varchar(25), 
    @fecha_nacimiento date, 
    @direccion varchar(100),
    @telefono varchar(20),
    @mail varchar(100),
    @especialidad int,
    @cobertura int
as 
	insert into Profesionales( pro_cuit, pro_nombre, pro_apellido, pro_fecha_nacimiento, pro_direccion, pro_telefono, pro_email, pro_especialidad)
	values( @cuit, @nombre ,@apellido, @fecha_nacimiento, @direccion ,@telefono,@mail,@especialidad );
end
go


CREATE PROCEDURE Proc_Buscar_DNI_Paciente
    @dni int 
as 
begin 
	select pac_codigo, pac_cuit, pac_nombre, pac_apellido, pac_direccion, pac_telefono, pac_email, pac_observacion, cod_cobertura
	from Pacientes
	where substring (pac_Cuit, 3,8)= @dni;
end
go

CREATE PROCEDURE Proc_Buscar_DNI_Profesional
    @dni int 
as 
begin 
	select pro_codigo, pro_cuit, pro_nombre, pro_apellido, pro_direccion, pro_telefono, pro_email, pro_observacion, pro_especialidad
	from Profesionales
	where substring (pro_Cuit, 3,8)= @dni;
end
go

CREATE PROCEDURE Proc_BuscarTurnosPorDNI
    @dni INT
AS
BEGIN
    SELECT 
        t.tur_codigo,t.tur_fecha, t.tur_hora, t.tur_estado,t.tur_tipo_turno, p.pac_nombre, p.pac_apellido, p.pac_cuit
    from turnos t
    inner join pacientes p on t.tur_paciente = p.pac_codigo
    where substring(p.pac_cuit, 3, 8) = @dni;
end 
go
